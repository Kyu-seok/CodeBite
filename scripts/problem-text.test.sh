#!/usr/bin/env bash
# Tests scripts/problem-text.sh against a stub docker, so no database is needed.
set -euo pipefail
here=$(cd "$(dirname "$0")" && pwd)
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
mkdir "$tmp/bin"
cat > "$tmp/bin/docker" <<'STUB'
#!/usr/bin/env bash
printf '%s\n' "$*" >> "$STUB_LOG"
case "$*" in
  *max*) printf '%s\n' "$STUB_VERSION" ;;
  *) cat > "$STUB_SQL"; printf '%s\n' "${STUB_OUT-# some-slug}" ;;
esac
STUB
chmod +x "$tmp/bin/docker"
export STUB_LOG="$tmp/log" STUB_SQL="$tmp/sql"
run() { PATH="$tmp/bin:$PATH" "$here/problem-text.sh" "$@"; }

fail() { echo "FAIL: $1" >&2; exit 1; }

STUB_VERSION=999999 run some-slug >/dev/null 2>"$tmp/err"
grep -q -- '-d codebite ' "$tmp/log" || fail "should read the codebite database by default"
[[ ! -s "$tmp/err" ]] || fail "a database at the newest migration should not warn"

: > "$tmp/log"
STUB_VERSION=999999 CODEBITE_DB=codebite_branch run some-slug >/dev/null 2>&1
grep -q -- '-d codebite_branch ' "$tmp/log" || fail "CODEBITE_DB should name the database"
if grep -q -- '-d codebite ' "$tmp/log"; then fail "CODEBITE_DB should replace the default"; fi

if STUB_VERSION=1 CODEBITE_DB=codebite_branch run some-slug >/dev/null 2>"$tmp/err"; then
  fail "a database behind this checkout should be refused"
fi
grep -q 'problem-text.sh: database codebite_branch at V1' "$tmp/err" || fail "the refusal should name the database: $(cat "$tmp/err")"
STUB_VERSION=1 CODEBITE_DB=codebite_branch CODEBITE_ALLOW_STALE=1 run some-slug >/dev/null 2>"$tmp/err" \
  || fail "CODEBITE_ALLOW_STALE=1 should read a database behind: $(cat "$tmp/err")"
grep -q 'WARNING: database codebite_branch at V1' "$tmp/err" || fail "reading a database behind should still warn, naming it"

# --json prints every case as judge-local.sh --cases reads them.
out=$(STUB_VERSION=999999 STUB_OUT='[{"input":"1","expected_output":"2"}]' run some-slug --json) \
  || fail "--json should succeed"
[[ "$out" == '[{"input":"1","expected_output":"2"}]' ]] || fail "--json should print the cases as they come: $out"
grep -q "json_agg" "$tmp/sql" || fail "--json should aggregate the cases into one JSON list"
grep -q "'expected_output'" "$tmp/sql" || fail "--json should name expected_output as judge-local.sh --cases reads it"
grep -q "order_index" "$tmp/sql" || fail "--json should keep order_index order"
if STUB_VERSION=999999 STUB_OUT='' run some-slug --json >/dev/null 2>"$tmp/err"; then
  fail "--json for an unknown slug should fail"
fi
grep -q "no problem with slug" "$tmp/err" || fail "--json for an unknown slug should say so: $(cat "$tmp/err")"
if STUB_VERSION=999999 run some-slug --bogus >/dev/null 2>&1; then fail "an unknown option should be refused"; fi

echo "problem-text.test.sh: ok"
