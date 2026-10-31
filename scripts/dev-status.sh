#!/usr/bin/env bash
# Checks the locally running backend, worker and frontend (bootRun, npm run dev) and the
# local database for the ways they drift from the code and config you think you're running:
#
#   ELSEWHERE  it runs another checkout's code (the main checkout or another worktree), so a
#              change on this checkout's branch isn't in it; restart it from here
#   STALE      the source changed after the process started; bootRun doesn't reload, so restart it
#   PROD       it carries a value from the production infra/.env (see scripts/dev-env.sh)
#   BEHIND     the database lacks a migration this checkout has; the backend applies it on start
#
# Branch servers (scripts/dev-branch-backend.sh: own ports, database, Kafka topics) are named as
# such. Another checkout's branch servers are another session's, never a problem here.
#
# Run from the root of the checkout or worktree whose code you want to see:  scripts/dev-status.sh
set -euo pipefail
# ps prints, and date parses, the start time in the C locale's English month and day names.
export LC_ALL=C

# Epoch seconds for a `ps -o lstart=` time, on macOS (BSD date) and Linux (GNU date).
to_epoch() {
  date -j -f "%a %b %d %T %Y" "$1" +%s 2>/dev/null || date -d "$1" +%s
}

# `touch -t` stamp for epoch seconds, on macOS and Linux.
to_stamp() {
  date -r "$1" +%Y%m%d%H%M.%S 2>/dev/null || date -d "@$1" +%Y%m%d%H%M.%S
}

here=$(git rev-parse --show-toplevel)
# The main checkout runs the shared dev servers; a worktree must not restart them.
main=$(dirname "$(git rev-parse --path-format=absolute --git-common-dir)")
problems=0
found=0

# The checkout a process runs from: the path in its command line in front of $2.
checkout_of() {
  ps -o command= -p "$1" | tr ' :' '\n\n' | awk -v s="/$2" '
    !r && length($0) > length(s) && substr($0, length($0) - length(s) + 1) == s { r = substr($0, 1, length($0) - length(s)) }
    END { print r }'
}

# The value of $2 in the environment process $1 started with.
env_value() {
  ps eww -o command= -p "$1" | tr ' ' '\n' | sed -n "s/^$2=//p" | head -n 1
}

# Prints where a process runs from; ELSEWHERE when that isn't this checkout, unless it is a
# branch server ($2 = its database), which belongs to whichever session started it.
report_checkout() {
  local root=$1 branch_db=${2:-}
  local branch
  branch=$(git -C "$root" branch --show-current 2>/dev/null || true)
  echo "  from $root (${branch:-detached})"
  if [[ -n "$branch_db" ]]; then
    echo "  branch server (scripts/dev-branch-backend.sh), database $branch_db, not a shared dev server"
  elif [[ "$root" != "$here" ]]; then
    if [[ "$here" != "$main" && "$root" == "$main" ]]; then
      echo "  ELSEWHERE  the shared dev server runs $main; don't restart it, run scripts/dev-branch-backend.sh to see this branch"
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
  pids=$(pgrep -f "/$module/build/classes/java/main" || true)
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
    root=$(checkout_of "$pid" "$module/build/classes/java/main")
    report_checkout "$root" "$branch_db"
    # Another session's branch server: its staleness and values are that session's business.
    [[ -n "$branch_db" && "$root" != "$here" ]] && continue

    marker=$(mktemp)
    touch -t "$(to_stamp "$(to_epoch "$started")")" "$marker"
    changed=$(find "$root/$module/src/main" "$root/common/src/main" -type f -newer "$marker" 2>/dev/null | head -n 3)
    rm -f "$marker"
    if [[ -n "$changed" ]]; then
      if [[ "$here" != "$main" && "$root" == "$main" ]]; then
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

pids=$(pgrep -f "frontend/node_modules/.bin/vite" || true)
if [[ -z "$pids" ]]; then
  echo "frontend: not running"
fi
for pid in $pids; do
  found=1
  echo "frontend: pid $pid (vite reloads on change)"
  report_checkout "$(checkout_of "$pid" "frontend/node_modules/.bin/vite")" "$(env_value "$pid" CODEBITE_DEV_BRANCH)"
done

db=$(docker exec codebite-postgres psql -U codebite -d codebite -tAc \
  "SELECT max(version::int) FROM flyway_schema_history WHERE success AND version ~ '^[0-9]+$'" 2>/dev/null || true)
ours=$(newest_migration "$here")
if [[ "$here" == "$main" ]]; then
  start_hint="start the backend from here to apply them"
else
  start_hint="the shared backend runs $main; scripts/dev-branch-backend.sh migrates a database of this branch's own"
fi
if [[ -z "$db" ]]; then
  echo "database: not reachable (docker container codebite-postgres)"
elif (( db < ours )); then
  echo "database: at V$db"
  echo "  BEHIND  this checkout has migrations up to V$ours; $start_hint"
  [[ "$here" == "$main" ]] && problems=1
elif (( db > ours )); then
  echo "database: at V$db, past this checkout's V$ours (another branch's migrations, run by a backend started from its worktree)"
  echo "  Fine while that branch merges them unchanged. Edited after they ran, every backend fails Flyway's checksum check until 'flyway repair'."
else
  echo "database: at V$db, this checkout's newest"
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

# This checkout's branch database, when scripts/dev-branch-backend.sh has made one.
branch_db=$("$here/scripts/dev-branch-backend.sh" name 2>/dev/null || true)
if [[ -n "$branch_db" ]]; then
  bdb=$(docker exec codebite-postgres psql -U codebite -d "$branch_db" -tAc \
    "SELECT max(version::int) FROM flyway_schema_history WHERE success AND version ~ '^[0-9]+$'" 2>/dev/null || true)
  if [[ -n "$bdb" ]]; then
    echo "branch database $branch_db: at V$bdb"
    if (( bdb < ours )); then
      echo "  BEHIND  this checkout has migrations up to V$ours; restart scripts/dev-branch-backend.sh to apply them"
      problems=1
    fi
  fi
fi

if [[ $found -eq 1 && $problems -eq 0 ]]; then
  echo "OK: running code, config and database match this checkout"
fi
exit "$problems"
