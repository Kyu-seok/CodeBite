#!/usr/bin/env bash
# Checks scripts/judge-local.sh without Docker: a fake `docker` on PATH stands in for the local
# database, answering the migration check and the Test Case export. Judges this checkout's
# Piggy Bank Total in Python only, so it runs wherever python3 is 3.12 or newer.
# scripts/judge-local.test.py covers the judging itself.
set -euo pipefail

script="$(cd "$(dirname "$0")" && pwd)/judge-local.sh"
fake=$(mktemp -d)
trap 'rm -rf "$fake"' EXIT
fail=0
check() { [[ "$2" == "$3" ]] || { echo "FAIL: $1: expected '$3', got '$2'"; fail=1; }; }
contains() { grep -qE -- "$3" <<<"$2" || { echo "FAIL: $1: no /$3/ in:"; echo "$2"; fail=1; }; }

# The fake database: the newest migration is applied, and the export answers $fake/export.json.
mkdir "$fake/bin"
cat > "$fake/bin/docker" <<'SH'
#!/usr/bin/env bash
sql=$(cat)
echo "$* $sql" >> "$FAKE_DIR/docker.log"
if [[ "$*$sql" == *flyway_schema_history* ]]; then echo 99999; else cat "$FAKE_DIR/export.json"; fi
SH
chmod +x "$fake/bin/docker"
export FAKE_DIR=$fake PATH="$fake/bin:$PATH"

run() { set +e; out=$("$script" "$@" 2>&1); code=$?; set -e; }

# --- usage ------------------------------------------------------------------------------------

run
check "no slug is a usage error" "$code" 2
contains "no slug prints the usage" "$out" "usage: scripts/judge-local.sh <slug>"

# --- from the database ------------------------------------------------------------------------

# A Former Slug comes back as the current one, whose Driver is judged.
echo '{"slug": "piggy-bank-total", "test_cases": [{"input": "3\n4", "expected_output": "7"},
      {"input": "0\n0", "expected_output": "0"}]}' > "$fake/export.json"
run old-piggy-slug --languages python
check "a right solution passes" "$code" 0
contains "python is Accepted" "$out" "python +ACCEPTED"
contains "the slug reaches the database" "$(cat "$fake/docker.log")" "old-piggy-slug"

echo '{"slug": "piggy-bank-total", "test_cases": [{"input": "3\n4", "expected_output": "8"}]}' > "$fake/export.json"
run piggy-bank-total --languages python
check "a wrong expected output fails" "$code" 1
contains "the failing case is named" "$out" "WRONG_ANSWER on test case 1"

: > "$fake/export.json"
run no-such-problem
check "an unknown slug is an error" "$code" 2
contains "an unknown slug is named" "$out" "no problem no-such-problem"

echo '{"slug": "piggy-bank-total", "test_cases": []}' > "$fake/export.json"
run piggy-bank-total --languages python
check "a problem without Test Cases fails" "$code" 1
contains "no Test Cases is said" "$out" "NO_TEST_CASES"

# --- from a file, before the migration exists -------------------------------------------------

rm -f "$fake/docker.log"
echo '[{"input": "10\n20", "expected_output": "30"}]' > "$fake/cases.json"
run piggy-bank-total --cases "$fake/cases.json" --languages python
check "cases from a file pass" "$code" 0
check "cases from a file leave the database alone" "$([[ -e "$fake/docker.log" ]] && echo touched || echo untouched)" untouched

exit "$fail"
