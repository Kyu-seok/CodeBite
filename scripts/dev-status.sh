#!/usr/bin/env bash
# Checks the locally running backend and worker (./gradlew :backend:bootRun / :worker:bootRun)
# for the two ways they drift from the code and config you think you're running:
#
#   STALE  the source changed after the process started; bootRun doesn't reload, so restart it
#   PROD   it carries a value from the production infra/.env (see scripts/dev-env.sh)
#
# Run from the repo root:  scripts/dev-status.sh
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

problems=0
found=0
for module in backend worker; do
  pid=$(pgrep -f "/$module/build/classes/java/main" | head -n 1 || true)
  if [[ -z "$pid" ]]; then
    echo "$module: not running"
    continue
  fi
  found=1
  started=$(ps -o lstart= -p "$pid" | sed 's/^ *//; s/ *$//')
  echo "$module: pid $pid, started $started"

  marker=$(mktemp)
  touch -t "$(to_stamp "$(to_epoch "$started")")" "$marker"
  changed=$(find "$module/src/main" common/src/main -type f -newer "$marker" 2>/dev/null | head -n 3)
  rm -f "$marker"
  if [[ -n "$changed" ]]; then
    echo "  STALE  source changed since it started, restart it:"
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

if [[ $found -eq 1 && $problems -eq 0 ]]; then
  echo "OK: running code and config match this checkout"
fi
exit "$problems"
