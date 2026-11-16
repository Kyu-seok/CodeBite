#!/usr/bin/env bash
# Tests scripts/prod-text.sh against a stub curl, so nothing reaches production, and a stub docker
# standing in for the local database.
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
# The local database: Flyway's version, then a problem as json_build_object returns it. The slug
# drifted-slug has an English description edited since (an admin-page edit in production).
cat > "$tmp/bin/docker" <<'STUB'
#!/usr/bin/env bash
case "$*" in
  *flyway_schema_history*) echo 589 ;;
  *"'gone-slug'"*) ;;
  *"'drifted-slug'"*) printf '%s\n' '{"en":{"title":"Title","description":"English, edited","constraints":"- limit"},"ko":{"title":"제목","description":"한국어\nshared block","constraints":"- 제약"}}' ;;
  *) printf '%s\n' '{"en":{"title":"Title","description":"English\nshared block\nonly english","constraints":"- limit"},"ko":{"title":"제목","description":"한국어\nshared block","constraints":"- 제약"}}' ;;
esac
STUB
chmod +x "$tmp/bin/docker"
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

run --matches-db some-slug other-slug > "$tmp/same" || fail "problems equal to production should pass: $(cat "$tmp/same")"
grep -q 'all 2 problem' "$tmp/same" || fail "a match should say so"

if run --matches-db some-slug drifted-slug > "$tmp/drift"; then fail "a drifted problem should fail"; fi
grep -q '^drifted-slug (en): description DIFFERS from production$' "$tmp/drift" || fail "should name the drifted field: $(cat "$tmp/drift")"
if grep -q '(ko)' "$tmp/drift"; then fail "the Korean text matched and shouldn't be reported"; fi

if run --matches-db gone-slug > "$tmp/gone"; then fail "a problem missing locally should fail"; fi
grep -q '^gone-slug: not in database' "$tmp/gone" || fail "should say the problem is missing locally"

code=0
run --matches-db "bad'slug" >/dev/null 2>&1 || code=$?
[[ "$code" -eq 2 ]] || fail "a malformed slug should exit 2, got $code"

echo "prod-text.test.sh: ok"
