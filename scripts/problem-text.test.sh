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
  *) cat >/dev/null; printf '%s\n' '# some-slug' ;;
esac
STUB
chmod +x "$tmp/bin/docker"
export STUB_LOG="$tmp/log"
run() { PATH="$tmp/bin:$PATH" "$here/problem-text.sh" "$@"; }

fail() { echo "FAIL: $1" >&2; exit 1; }

STUB_VERSION=999999 run some-slug >/dev/null 2>"$tmp/err"
grep -q -- '-d codebite ' "$tmp/log" || fail "should read the codebite database by default"
[[ ! -s "$tmp/err" ]] || fail "a database at the newest migration should not warn"

: > "$tmp/log"
STUB_VERSION=999999 CODEBITE_DB=codebite_branch run some-slug >/dev/null 2>&1
grep -q -- '-d codebite_branch ' "$tmp/log" || fail "CODEBITE_DB should name the database"
if grep -q -- '-d codebite ' "$tmp/log"; then fail "CODEBITE_DB should replace the default"; fi

STUB_VERSION=1 CODEBITE_DB=codebite_branch run some-slug >/dev/null 2>"$tmp/err"
grep -q 'WARNING: database codebite_branch at V1' "$tmp/err" || fail "a database behind this checkout should warn, naming it"

echo "problem-text.test.sh: ok"
