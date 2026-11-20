#!/usr/bin/env bash
# Tests scripts/db-sql.sh against a stub docker, so no database is needed: the query reaches psql
# from the argument or from stdin, CODEBITE_DB picks the database, a BEHIND database is refused naming both
# versions unless CODEBITE_ALLOW_STALE=1, and a failing query exits non-zero with psql's message.
set -euo pipefail
here=$(cd "$(dirname "$0")" && pwd)
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
mkdir "$tmp/bin"
cat > "$tmp/bin/docker" <<'STUB'
#!/usr/bin/env bash
# STUB_DOCKER is the state docker is in: up (the default), down (the daemon doesn't answer),
# stopped (the daemon answers, the container isn't running) or absent (no such container).
case "${STUB_DOCKER:-up} $1" in
  "down "*) echo 'Cannot connect to the Docker daemon at unix:///var/run/docker.sock. Is the docker daemon running?' >&2; exit 1 ;;
  *" info") exit 0 ;;
  "up inspect") echo true; exit 0 ;;
  "stopped inspect") echo false; exit 0 ;;
  "absent inspect") echo; echo 'Error: No such object: codebite-postgres' >&2; exit 1 ;;
  "stopped exec") echo 'Error response from daemon: container 3f2a9c is not running' >&2; exit 1 ;;
  "absent exec") echo 'Error response from daemon: No such container: codebite-postgres' >&2; exit 1 ;;
esac
printf '%s\n' "$*" >> "$STUB_LOG"
case "$*" in
  *max*) cat >/dev/null; printf '%s\n' "$STUB_VERSION" ;;   # docker exec -i drains stdin
  *) query=$(cat); printf '%s\n' "$query" > "$STUB_QUERY"
     if [[ "$query" == *boom* ]]; then echo 'ERROR:  relation "boom" does not exist' >&2; exit 3; fi
     echo 1 ;;
esac
STUB
chmod +x "$tmp/bin/docker"
export STUB_LOG="$tmp/log" STUB_QUERY="$tmp/query"
run() { PATH="$tmp/bin:$PATH" "$here/db-sql.sh" "$@"; }

fail() { echo "FAIL: $1" >&2; exit 1; }

out=$(STUB_VERSION=999999 run "select 1" 2>"$tmp/err")
[[ "$out" == 1 ]] || fail "the argument's query should print psql's rows, got '$out'"
grep -q 'select 1' "$tmp/query" || fail "the argument should reach psql on stdin"
grep -q -- '-d codebite ' "$tmp/log" || fail "should read the codebite database by default"
grep -q -- ' -tA ' "$tmp/log" || fail "output should be tuples only, unaligned"
[[ ! -s "$tmp/err" ]] || fail "a database at the newest migration should not warn: $(cat "$tmp/err")"

out=$(printf 'select 1\n' | STUB_VERSION=999999 run 2>"$tmp/err")
[[ "$out" == 1 ]] || fail "a query on stdin should print psql's rows, got '$out'"
grep -q 'select 1' "$tmp/query" || fail "stdin should reach psql"

: > "$tmp/log"
STUB_VERSION=999999 CODEBITE_DB=x run "select 1" >/dev/null 2>&1
grep -q -- '-d x ' "$tmp/log" || fail "CODEBITE_DB should name the database"
if grep -q -- '-d codebite ' "$tmp/log"; then fail "CODEBITE_DB should replace the default"; fi

if STUB_VERSION=1 run "select 1" >/dev/null 2>"$tmp/err"; then
  fail "a database behind this checkout should be refused"
fi
grep -q 'db-sql.sh: database codebite at V1, this checkout.s migrations reach V[0-9]' "$tmp/err" \
  || fail "the refusal should name both versions: $(cat "$tmp/err")"
grep -q 'dev-branch-servers.sh' "$tmp/err" || fail "the refusal should name scripts/dev-branch-servers.sh"
grep -q 'CODEBITE_ALLOW_STALE=1' "$tmp/err" || fail "the refusal should name the way to read it anyway"
: > "$tmp/query"
out=$(STUB_VERSION=1 CODEBITE_ALLOW_STALE=1 run "select 1" 2>"$tmp/err")
[[ "$out" == 1 ]] || fail "CODEBITE_ALLOW_STALE=1 should read a database behind, got '$out'"
grep -q 'WARNING: database codebite at V1' "$tmp/err" || fail "reading a database behind should still warn: $(cat "$tmp/err")"

if STUB_VERSION=999999 run "select * from boom" >/dev/null 2>"$tmp/err"; then
  fail "a failing query should exit non-zero"
fi
grep -q 'relation "boom" does not exist' "$tmp/err" || fail "a failing query should pass psql's message through"

if STUB_VERSION=999999 run a b >/dev/null 2>&1; then fail "two arguments should be a usage error"; fi

# Docker down: one line saying what to start, exit 2 (1 is a failing query), and no query sent.
: > "$tmp/log"
code=0; out=$(STUB_DOCKER=down run "select 1" 2>"$tmp/err") || code=$?
[[ $code == 2 ]] || fail "a Docker daemon that doesn't answer should exit 2, got $code"
[[ "$(cat "$tmp/err")" == "db-sql.sh: database codebite not reachable: the Docker daemon doesn't answer; start Docker Desktop (open -a Docker) and rerun" ]] \
  || fail "a Docker daemon that doesn't answer should say to start Docker Desktop, in one line: $(cat "$tmp/err")"
[[ -z "$out" && ! -s "$tmp/log" ]] || fail "no query should run while the Docker daemon doesn't answer"

# Docker up, container not running (stopped, or never created): the compose command, exit 2.
for state in stopped absent; do
  : > "$tmp/log"
  code=0; out=$(STUB_DOCKER=$state run "select 1" 2>"$tmp/err") || code=$?
  [[ $code == 2 ]] || fail "a codebite-postgres that is $state should exit 2, got $code"
  [[ "$(cat "$tmp/err")" == "db-sql.sh: database codebite not reachable: the codebite-postgres container isn't running; start it: docker compose -f infra/docker-compose.yml up -d postgres" ]] \
    || fail "a codebite-postgres that is $state should name the compose command, in one line: $(cat "$tmp/err")"
  [[ -z "$out" && ! -s "$tmp/log" ]] || fail "no query should run while codebite-postgres is $state"
done
grep -q '^  postgres:$' "$here/../infra/docker-compose.yml" \
  || fail "the compose command names the service postgres, which infra/docker-compose.yml no longer has"

# require_current_db itself, as every reader shares it: a checkout without migrations (a worktree before
# common/ exists, say) neither warns nor errors, and a database that can't be read returns 2 with the
# one message dev-status.sh prints too, prefixed by the script's name: what to start when Docker or
# the container is down, and otherwise that the container runs, so it is the database that is missing.
mkdir "$tmp/bare"
(
  set -euo pipefail
  # shellcheck source=SCRIPTDIR/dev-servers-common.sh
  source "$here/dev-servers-common.sh"
  PATH="$tmp/bin:$PATH" STUB_VERSION=7 require_current_db codebite "$tmp/bare" db-sql.sh 2>"$tmp/err" \
    || fail "a checkout with no migrations should not fail the check: $(cat "$tmp/err")"
  [[ ! -s "$tmp/err" ]] || fail "a checkout with no migrations should not warn: $(cat "$tmp/err")"
  code=0
  PATH="$tmp/bin:$PATH" STUB_VERSION='' require_current_db nope "$tmp/bare" db-sql.sh 2>"$tmp/err" || code=$?
  [[ $code == 2 ]] || fail "a database that can't be read should return 2, got $code"
  [[ "$(cat "$tmp/err")" == "db-sql.sh: database nope not readable though the codebite-postgres container runs: no such database, no migration has run in it, or Postgres is still starting (rerun in a few seconds)" ]] \
    || fail "a missing database should not be told to start Docker: $(cat "$tmp/err")"
  code=0
  PATH="$tmp/bin:$PATH" STUB_DOCKER=down require_current_db codebite "$tmp/bare" db-sql.sh 2>"$tmp/err" || code=$?
  [[ $code == 2 ]] || fail "a database behind a Docker that is down should return 2, got $code"
  [[ "$(cat "$tmp/err")" == "db-sql.sh: database codebite $(PATH="$tmp/bin:$PATH" STUB_DOCKER=down db_unreachable_message)" ]] \
    || fail "the unreachable message should be the shared one, prefixed by the script: $(cat "$tmp/err")"
  grep -q 'start Docker Desktop' "$tmp/err" || fail "the unreachable message should say what to start: $(cat "$tmp/err")"
  # db_psql itself, for a caller that skips require_current_db: nothing runs, and it returns 2.
  : > "$tmp/log"
  code=0
  PATH="$tmp/bin:$PATH" STUB_DOCKER=stopped db_psql codebite -tAc 'select 1' >/dev/null 2>"$tmp/err" || code=$?
  [[ $code == 2 ]] || fail "db_psql with the container stopped should return 2, got $code"
  grep -q "database codebite not reachable: the codebite-postgres container isn't running; start it: docker compose" "$tmp/err" \
    || fail "db_psql with the container stopped should say what to start: $(cat "$tmp/err")"
  [[ ! -s "$tmp/log" ]] || fail "db_psql with the container stopped should not reach docker exec"
)

echo "db-sql.test.sh: ok"
