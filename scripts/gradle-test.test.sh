#!/usr/bin/env bash
# Checks scripts/gradle-test.sh with a stub gradlew in a fake repo root (CODEBITE_ROOT) and a lock
# directory of its own (CODEBITE_GRADLE_LOCK), so no Gradle runs and no real lock is touched.
set -euo pipefail

script="$(cd "$(dirname "$0")" && pwd)/gradle-test.sh"
fake=$(mktemp -d)
trap 'rm -rf "$fake"' EXIT
fail=0
check() { [[ "$2" == "$3" ]] || { echo "FAIL: $1: expected '$3', got '$2'"; fail=1; }; }
contains() { grep -qF -- "$3" <<<"$2" || { echo "FAIL: $1: no '$3' in:"; echo "$2"; fail=1; }; }

export CODEBITE_ROOT=$fake/repo CODEBITE_GRADLE_LOCK=$fake/gradle.lock CODEBITE_GRADLE_POLL=0.1
log=$fake/runs.log
mkdir -p "$CODEBITE_ROOT"
# The stub logs when each run starts and ends, sleeps, and exits with $STUB_EXIT.
cat > "$CODEBITE_ROOT/gradlew" <<EOF
#!/usr/bin/env bash
echo "start \$*" >> "$log"
sleep "\${STUB_SLEEP:-0}"
echo "end \$*" >> "$log"
exit "\${STUB_EXIT:-0}"
EOF
chmod +x "$CODEBITE_ROOT/gradlew"

# --- passes the arguments and the exit code through, and releases the lock ------------------------

set +e; STUB_EXIT=3 "$script" :backend:test --tests 'com.codebite.problem.*' >/dev/null 2>&1; code=$?; set -e
check "exit code" "$code" 3
contains "arguments" "$(cat "$log")" "start :backend:test --tests com.codebite.problem.*"
check "lock released after a failure" "$([[ -e $CODEBITE_GRADLE_LOCK ]] && echo held || echo free)" free

# --- two runs at once never overlap ---------------------------------------------------------------

: > "$log"
STUB_SLEEP=1 "$script" one >/dev/null 2>&1 &
first=$!
sleep 0.3
out=$(STUB_SLEEP=0 "$script" two 2>&1)
wait "$first"
check "runs one after the other" "$(tr '\n' ' ' < "$log")" "start one end one start two end two "
contains "the waiting run says whom it waits for" "$out" "waiting for the Gradle lock"
contains "and names the holder's arguments" "$out" "one"

# --- a lock left by a dead process is taken over -----------------------------------------------------

: > "$log"
mkdir "$CODEBITE_GRADLE_LOCK"
sleep 0 & dead=$!; wait "$dead"
echo "$dead somewhere gone" > "$CODEBITE_GRADLE_LOCK/owner"
out=$("$script" after-stale 2>&1)
contains "stale lock taken over" "$(cat "$log")" "end after-stale"
contains "and said so" "$out" "stale"

# --- a run inside a run that holds the lock doesn't wait on itself -----------------------------------

: > "$log"
cat > "$fake/outer.sh" <<EOF
#!/usr/bin/env bash
"$script" inner
EOF
chmod +x "$fake/outer.sh"
# The stub, as the outer "gradlew", calls gradle-test.sh again (as a git hook under merge-ticket does).
cat > "$CODEBITE_ROOT/gradlew" <<EOF
#!/usr/bin/env bash
echo "start \$*" >> "$log"
[[ "\$1" == outer ]] && "$script" nested
echo "end \$*" >> "$log"
EOF
if command -v timeout >/dev/null; then t=(timeout 10); else t=(); fi
set +e; "${t[@]}" "$script" outer >/dev/null 2>&1; code=$?; set -e
check "nested run finishes" "$code" 0
check "nested run order" "$(tr '\n' ' ' < "$log")" "start outer start nested end nested end outer "

[[ $fail -eq 0 ]] && echo "gradle-test.test.sh: all passed"
exit $fail
