#!/usr/bin/env bash
# Checks the locally running backend, worker and frontend (bootRun, npm run dev) and the
# local database for the ways they drift from the code and config you think you're running:
#
#   ELSEWHERE  it runs another checkout's code (the main checkout or another worktree), so a
#              change on this checkout's branch isn't in it; restart it from here
#   STALE      the source changed after the process started; bootRun doesn't reload, so restart it
#   PROD       it carries a value from the production infra/.env (see scripts/dev-env.sh)
#   BEHIND     the database lacks a migration this checkout has; the backend applies it on start
#   UNREACHABLE  Judge0 doesn't answer, so every Run and Submit fails; known before a UI check is planned
#
# Branch servers (scripts/dev-branch-servers.sh: own ports, database, Kafka topics) are named as
# such. Another checkout's branch servers are another session's, never a problem here.
#
# Run from the root of the checkout or worktree whose code you want to see:  scripts/dev-status.sh
set -euo pipefail
# ps prints, and date parses, the start time in the C locale's English month and day names.
export LC_ALL=C
# shellcheck source=SCRIPTDIR/dev-servers-common.sh
source "$(dirname "${BASH_SOURCE[0]}")/dev-servers-common.sh"

# Epoch seconds for a `ps -o lstart=` time, on macOS (BSD date) and Linux (GNU date).
to_epoch() {
  date -j -f "%a %b %d %T %Y" "$1" +%s 2>/dev/null || date -d "$1" +%s
}

# `touch -t` stamp for epoch seconds, on macOS and Linux.
to_stamp() {
  date -r "$1" +%Y%m%d%H%M.%S 2>/dev/null || date -d "@$1" +%Y%m%d%H%M.%S
}

here=$(git rev-parse --show-toplevel)
main=$(main_checkout)
problems=0
found=0

# The main checkout runs the shared dev servers; a worktree session never restarts them.
in_main_checkout() { [[ "$here" == "$main" ]]; }
# Whether $1, the checkout a process runs from, is the shared servers' seen from a worktree.
is_shared_server() { ! in_main_checkout && [[ "$1" == "$main" ]]; }

# The checkout a process runs from: the path in its command line in front of $2 (an app_pattern).
checkout_of() {
  ps -o command= -p "$1" | tr ' :' '\n\n' | awk -v s="$2" '
    !r && length($0) > length(s) && substr($0, length($0) - length(s) + 1) == s { r = substr($0, 1, length($0) - length(s)) }
    END { print r }'
}

# Prints where a process runs from; ELSEWHERE when that isn't this checkout, unless it is a
# branch server ($2 = its database), which belongs to whichever session started it.
report_checkout() {
  local root=$1 branch_db=${2:-}
  local branch
  branch=$(git -C "$root" branch --show-current 2>/dev/null || true)
  echo "  from $root (${branch:-detached})"
  if [[ -n "$branch_db" ]]; then
    echo "  branch server (scripts/dev-branch-servers.sh), database $branch_db, not a shared dev server"
  elif [[ "$root" != "$here" ]]; then
    if is_shared_server "$root"; then
      echo "  ELSEWHERE  the shared dev server runs $main; don't restart it, run scripts/dev-branch-servers.sh to see this branch"
    else
      echo "  ELSEWHERE  not this checkout ($here); restart it from here to run this branch's code"
    fi
    problems=1
  fi
}

# Highest Flyway version among a checkout's migrations, SQL and Java.
newest_migration() {
  find "$1/common/src/main/resources/db/migration" "$1/common/src/main/java/db/migration" \
    -name 'V*__*' 2>/dev/null | sed -E 's|.*/V([0-9]+)__.*|\1|' | sort -n | tail -n 1
}

for module in backend worker; do
  pids=$(pgrep -f "$(app_pattern "$module")" || true)
  if [[ -z "$pids" ]]; then
    echo "$module: not running"
    continue
  fi
  for pid in $pids; do
    found=1
    started=$(ps -o lstart= -p "$pid" | sed 's/^ *//; s/ *$//')
    branch_db=$(env_value "$pid" CODEBITE_DEV_BRANCH)
    port=$(env_value "$pid" SERVER_PORT)
    echo "$module: pid $pid, started $started${port:+, port $port}"
    root=$(checkout_of "$pid" "$(app_pattern "$module")")
    report_checkout "$root" "$branch_db"
    # Another session's branch server: its staleness and values are that session's business.
    [[ -n "$branch_db" && "$root" != "$here" ]] && continue

    marker=$(mktemp)
    touch -t "$(to_stamp "$(to_epoch "$started")")" "$marker"
    changed=$(find "$root/$module/src/main" "$root/common/src/main" -type f -newer "$marker" 2>/dev/null | head -n 3)
    rm -f "$marker"
    if [[ -n "$changed" ]]; then
      if is_shared_server "$root"; then
        echo "  STALE  source changed since it started (the shared server: the user restarts it, not a worktree session):"
      else
        echo "  STALE  source changed since it started, restart it:"
      fi
      sed 's/^/           /' <<<"$changed"
      problems=1
    fi

    env_of=$(ps eww -o command= -p "$pid" | tr ' ' '\n')
    while IFS= read -r line; do
      case "$line" in
        CORS_ALLOWED_ORIGINS=*code-bite.com*|JUDGE0_URL=http://judge0:*|DB_USER=*|DB_PASSWORD=*|JWT_SECRET=*)
          echo "  PROD   ${line%%=*} is set; restart from a shell that only sourced scripts/dev-env.sh"
          problems=1
          ;;
      esac
    done <<<"$env_of"
  done
done

pids=$(pgrep -f "$(app_pattern frontend)" || true)
if [[ -z "$pids" ]]; then
  echo "frontend: not running"
fi
for pid in $pids; do
  found=1
  echo "frontend: pid $pid (vite reloads on change)"
  report_checkout "$(checkout_of "$pid" "$(app_pattern frontend)")" "$(env_value "$pid" CODEBITE_DEV_BRANCH)"
done

db=$(flyway_version codebite)
ours=$(newest_migration "$here")
if in_main_checkout; then
  start_hint="start the backend from here to apply them"
else
  start_hint="the shared backend runs $main; scripts/dev-branch-servers.sh migrates a database of this branch's own"
fi
if [[ -z "$db" ]]; then
  echo "database: not reachable (docker container codebite-postgres)"
elif (( db < ours )); then
  echo "database: at V$db"
  echo "  BEHIND  this checkout has migrations up to V$ours; $start_hint"
  in_main_checkout && problems=1
elif (( db > ours )); then
  echo "database: at V$db, past this checkout's V$ours (another branch's migrations, run by a backend started from its worktree)"
  echo "  Fine while that branch merges them unchanged. Edited after they ran, every backend fails Flyway's checksum check until 'flyway repair'."
else
  echo "database: at V$db, this checkout's newest"
fi

# The Judge0 the dev backend calls: its JUDGE0_URL when one from here sets it, else the dev profile's
# default. Off the local network it doesn't answer, and every Run and Submit fails.
judge0_url=""
for pid in $(pgrep -f "$(app_pattern backend "$here")" || true); do
  judge0_url=$(env_value "$pid" JUDGE0_URL)
  [[ -n "$judge0_url" ]] && break
done
if [[ -z "$judge0_url" ]]; then
  judge0_url=$(sed -nE 's/^ *url: \$\{JUDGE0_URL:([^}]+)\}.*/\1/p' "$here/backend/src/main/resources/application-dev.yml" | head -n 1)
fi
if [[ -n "$judge0_url" ]]; then
  if curl -s -f -m 3 -o /dev/null "$judge0_url/about"; then
    echo "judge0: $judge0_url answers"
  else
    echo "judge0: $judge0_url"
    echo "  UNREACHABLE  Run and Submit fail until it answers; a UI check can only stub their results"
    problems=1
  fi
fi

# A version the database ran under another name: two branches took the same
# number. Flyway refuses to start until one of them is renumbered.
if [[ -n "$db" ]]; then
  while IFS='|' read -r version description; do
    file=$(find "$here/common/src/main/resources/db/migration" "$here/common/src/main/java/db/migration" \
      -name "V${version}__*" 2>/dev/null | head -n 1)
    [[ -z "$file" ]] && continue
    name=$(basename "$file")
    name=${name#*__}
    name=${name%.*}
    if [[ "${name//_/ }" != "$description" ]]; then
      echo "  CLASH  V$version ran as \"$description\", but here it is $(basename "$file"); renumber this branch's migration"
      problems=1
    fi
  done < <(docker exec codebite-postgres psql -U codebite -d codebite -tAc \
    "SELECT version, description FROM flyway_schema_history WHERE success AND version ~ '^[0-9]+$'" 2>/dev/null || true)
fi

# This checkout's branch database, when scripts/dev-branch-servers.sh has made one.
branch_db=$("$here/scripts/dev-branch-servers.sh" name 2>/dev/null || true)
if [[ -n "$branch_db" ]]; then
  bdb=$(flyway_version "$branch_db")
  if [[ -n "$bdb" ]]; then
    echo "branch database $branch_db: at V$bdb"
    if (( bdb < ours )); then
      echo "  BEHIND  this checkout has migrations up to V$ours; restart scripts/dev-branch-servers.sh to apply them"
      problems=1
    fi
  fi
fi

if [[ $found -eq 1 && $problems -eq 0 ]]; then
  echo "OK: running code, config and database match this checkout"
fi
exit "$problems"
