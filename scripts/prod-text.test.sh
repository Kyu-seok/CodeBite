#!/usr/bin/env bash
# Tests scripts/prod-text.sh against a stub curl, so nothing reaches production.
set -euo pipefail
here=$(cd "$(dirname "$0")" && pwd)
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
mkdir "$tmp/bin"
cat > "$tmp/bin/curl" <<'STUB'
#!/usr/bin/env bash
case "$*" in
  *missing*) exit 22 ;;
  *"Accept-Language: ko"*) printf '%s' '{"title":"제목","description":"한국어\nshared block","constraints":"- 제약"}' ;;
  *) printf '%s' '{"title":"Title","description":"English\nshared block\nonly english","constraints":"- limit"}' ;;
esac
STUB
chmod +x "$tmp/bin/curl"
run() { PATH="$tmp/bin:$PATH" "$here/prod-text.sh" "$@"; }

fail() { echo "FAIL: $1" >&2; exit 1; }

printf 'shared block\n' > "$tmp/both"
run some-slug --contains "$tmp/both" >/dev/null || fail "text in both languages should pass"

printf 'only english' > "$tmp/one"
if run some-slug --contains "$tmp/one" >"$tmp/out"; then fail "text in one language should fail"; fi
grep -q '^ko: NOT FOUND$' "$tmp/out" || fail "should name the language missing the text"

run some-slug > "$tmp/plain"
grep -q '^--- ko ---$' "$tmp/plain" || fail "plain output should print both languages"
grep -q '^title: 제목$' "$tmp/plain" || fail "plain output should print the title"
grep -q '^- limit$' "$tmp/plain" || fail "plain output should print the constraints"

code=0
run missing >/dev/null 2>&1 || code=$?
[[ "$code" -eq 2 ]] || fail "an unreadable problem should exit 2, got $code"

echo "prod-text.test.sh: ok"
