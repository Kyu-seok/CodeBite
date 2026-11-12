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

# require_current_db itself, as every reader shares it: a checkout without migrations (a worktree before
# common/ exists, say) neither warns nor errors, and an unreachable database prints the one message
# dev-status.sh prints too, prefixed by the script's name.
mkdir "$tmp/bare"
(
  set -euo pipefail
  # shellcheck source=SCRIPTDIR/dev-servers-common.sh
  source "$here/dev-servers-common.sh"
  PATH="$tmp/bin:$PATH" STUB_VERSION=7 require_current_db codebite "$tmp/bare" db-sql.sh 2>"$tmp/err" \
    || fail "a checkout with no migrations should not fail the check: $(cat "$tmp/err")"
  [[ ! -s "$tmp/err" ]] || fail "a checkout with no migrations should not warn: $(cat "$tmp/err")"
  if PATH="$tmp/bin:$PATH" STUB_VERSION='' require_current_db codebite "$tmp/bare" db-sql.sh 2>"$tmp/err"; then
    fail "an unreachable database should return 1"
  fi
  [[ "$(cat "$tmp/err")" == "db-sql.sh: database codebite $(db_unreachable_message)" ]] \
    || fail "the unreachable message should be the shared one, prefixed by the script: $(cat "$tmp/err")"
  grep -q 'open -a Docker' "$tmp/err" || fail "the unreachable message should say how to start the database"
)

echo "db-sql.test.sh: ok"
