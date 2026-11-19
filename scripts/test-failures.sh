#!/usr/bin/env bash
# Prints only a Gradle module's failing tests from its last test run: each failed or errored test
# as `<class> > <method>`, then its assertion message whole (the XML's `message`, unescaped, however
# many lines), and none of the stack trace. Passing and skipped tests print nothing. Ends with
# `<failed> of <total> failed`; exits 1 when any failed, 0 when none, 2 without result files.
#
#   scripts/test-failures.sh <module>          # backend, common or worker; reads
#                                              # <module>/build/test-results/test/TEST-*.xml
#   scripts/test-failures.sh <module> --run    # :<module>:test -q first (through gradle-test.sh,
#                                              # one Gradle run at a time), then reports;
#                                              # Gradle's own output (the full traces) goes to
#                                              # <module>/build/test-failures-gradle.log, named
#                                              # on stderr so stdout stays the report alone
#
# Plain text, no colour: it is read by agents more than by people. Gradle's own output keeps the
# full traces (root build.gradle, testLogging exceptionFormat 'full') for whoever wants them.
set -euo pipefail

usage() { echo "usage: scripts/test-failures.sh <backend|common|worker> [--run]" >&2; exit 2; }
[[ $# -ge 1 && $# -le 2 ]] || usage
module=$1
case "$module" in backend|common|worker) ;; *) usage ;; esac
run=false
if [[ $# -eq 2 ]]; then
  [[ "$2" == --run ]] || usage
  run=true
fi
root=${CODEBITE_ROOT:-$(cd "$(dirname "$0")/.." && pwd)}
results=$root/$module/build/test-results/test

log=$module/build/test-failures-gradle.log
if $run; then
  mkdir -p "$root/$module/build"
  CODEBITE_ROOT=$root "$(dirname "$0")/gradle-test.sh" ":$module:test" -q >"$root/$log" 2>&1 || true
  echo "test-failures.sh: Gradle's output is in $log" >&2
fi

if ! compgen -G "$results/TEST-*.xml" >/dev/null; then
  if $run; then
    cat "$root/$log" >&2
    echo "test-failures.sh: ./gradlew :$module:test -q produced no test results (output above, kept in $log)" >&2
  else
    echo "test-failures.sh: no test results under $module/build/test-results/test; run ./gradlew :$module:test (or pass --run)" >&2
  fi
  exit 2
fi

python3 -I - "$results" <<'PY'
import glob, sys
import xml.etree.ElementTree as ET

total = failed = 0
for path in sorted(glob.glob(sys.argv[1] + "/TEST-*.xml")):
    for case in ET.parse(path).getroot().iter("testcase"):
        total += 1
        failure = case.find("failure")
        if failure is None:
            failure = case.find("error")
        if failure is None:
            continue
        failed += 1
        message = failure.get("message") or failure.get("type") or "(no message)"
        print(f"{case.get('classname')} > {case.get('name')}")
        for line in message.splitlines() or [message]:
            print(f"  {line}")
        print()
print(f"{failed} of {total} failed")
sys.exit(1 if failed else 0)
PY
