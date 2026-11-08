#!/usr/bin/env bash
# Checks scripts/test-failures.sh against hand-written JUnit XML in a fake repo root (CODEBITE_ROOT),
# so no Gradle run is needed; a stub gradlew there records what --run invokes.
set -euo pipefail

script="$(cd "$(dirname "$0")" && pwd)/test-failures.sh"
fake=$(mktemp -d)
trap 'rm -rf "$fake"' EXIT
fail=0
check() { [[ "$2" == "$3" ]] || { echo "FAIL: $1: expected '$3', got '$2'"; fail=1; }; }
contains() { grep -qF -- "$3" <<<"$2" || { echo "FAIL: $1: no '$3' in:"; echo "$2"; fail=1; }; }
lacks() { grep -qF -- "$3" <<<"$2" && { echo "FAIL: $1: unexpected '$3' in:"; echo "$2"; fail=1; } || true; }

results=$fake/backend/build/test-results/test
mkdir -p "$results"
run() { set +e; out=$(CODEBITE_ROOT=$fake "$script" "$@" 2>&1); code=$?; set -e; }

# --- two failing tests among ten ----------------------------------------------------------------

# Eight passing tests in one suite, a failure and an error in another, as Gradle writes them.
cat > "$results/TEST-com.codebite.auth.AuthIntegrationTest.xml" <<'XML'
<?xml version="1.0" encoding="UTF-8"?>
<testsuite name="com.codebite.auth.AuthIntegrationTest" tests="8" skipped="1" failures="0" errors="0" timestamp="2026-11-09T01:02:03" hostname="h" time="0.4">
  <properties/>
  <testcase name="a()" classname="com.codebite.auth.AuthIntegrationTest" time="0.1"/>
  <testcase name="b()" classname="com.codebite.auth.AuthIntegrationTest" time="0.1"/>
  <testcase name="c()" classname="com.codebite.auth.AuthIntegrationTest" time="0.1"/>
  <testcase name="d()" classname="com.codebite.auth.AuthIntegrationTest" time="0.1"/>
  <testcase name="e()" classname="com.codebite.auth.AuthIntegrationTest" time="0.1"/>
  <testcase name="f()" classname="com.codebite.auth.AuthIntegrationTest" time="0.1"/>
  <testcase name="g()" classname="com.codebite.auth.AuthIntegrationTest" time="0.1"/>
  <testcase name="h()" classname="com.codebite.auth.AuthIntegrationTest" time="0.1">
    <skipped/>
  </testcase>
  <system-out><![CDATA[01:02:03.000 [Test worker] INFO some logging
]]></system-out>
  <system-err><![CDATA[]]></system-err>
</testsuite>
XML
cat > "$results/TEST-com.codebite.problem.StatementsMatchTestCasesTest.xml" <<'XML'
<?xml version="1.0" encoding="UTF-8"?>
<testsuite name="com.codebite.problem.StatementsMatchTestCasesTest" tests="2" skipped="0" failures="1" errors="1" timestamp="2026-11-09T01:02:04" hostname="h" time="1.2">
  <properties/>
  <testcase name="examplesMatchSamples()" classname="com.codebite.problem.StatementsMatchTestCasesTest" time="1.0">
    <failure message="[two-sum] example 2 output &quot;[1, 2]&quot; is not the sample&#10;expected: &lt;[0, 1]&gt;&#10; but was: &lt;[1, 2]&gt;" type="org.opentest4j.AssertionFailedError">org.opentest4j.AssertionFailedError: [two-sum] example 2 output "[1, 2]" is not the sample
expected: &lt;[0, 1]&gt;
 but was: &lt;[1, 2]&gt;
	at org.junit.jupiter.api.AssertionFailureBuilder.build(AssertionFailureBuilder.java:151)
	at org.junit.jupiter.api.AssertionFailureBuilder.buildAndThrow(AssertionFailureBuilder.java:132)
	at com.codebite.problem.StatementsMatchTestCasesTest.examplesMatchSamples(StatementsMatchTestCasesTest.java:88)
</failure>
  </testcase>
  <testcase name="constraintsNameParameters()" classname="com.codebite.problem.StatementsMatchTestCasesTest" time="0.2">
    <error message="Migration V12__add_problem.sql: syntax error at or near &quot;SELCT&quot;" type="org.flywaydb.core.api.FlywayException">org.flywaydb.core.api.FlywayException: Migration V12__add_problem.sql: syntax error at or near "SELCT"
	at org.flywaydb.core.Flyway.migrate(Flyway.java:170)
	at com.codebite.problem.MigratedDatabase.open(MigratedDatabase.java:40)
</error>
  </testcase>
  <system-out><![CDATA[]]></system-out>
  <system-err><![CDATA[]]></system-err>
</testsuite>
XML

run backend
check "failures exit 1" "$code" 1
contains "the summary counts failed and total" "$out" "2 of 10 failed"
contains "the failed test is named by class and method" "$out" "com.codebite.problem.StatementsMatchTestCasesTest > examplesMatchSamples()"
contains "the errored test is reported like a failure" "$out" "com.codebite.problem.StatementsMatchTestCasesTest > constraintsNameParameters()"
contains "the error's message is printed" "$out" 'Migration V12__add_problem.sql: syntax error at or near "SELCT"'
contains "a multi-line message is printed whole, unescaped" "$out" '[two-sum] example 2 output "[1, 2]" is not the sample'
contains "the second line of the message" "$out" 'expected: <[0, 1]>'
contains "the third line of the message" "$out" ' but was: <[1, 2]>'
lacks "no stack frames" "$out" "at org.junit"
lacks "no stack frames from the error" "$out" "at org.flywaydb"
lacks "passing tests print nothing" "$out" "a()"
lacks "skipped tests print nothing" "$out" "h()"
check "exactly two entries" "$(grep -c ' > ' <<<"$out")" 2
lacks "no colour codes" "$out" $'\e['

# --- no failures --------------------------------------------------------------------------------

rm "$results/TEST-com.codebite.problem.StatementsMatchTestCasesTest.xml"
run backend
check "no failures exit 0" "$code" 0
check "no failures print only the summary" "$out" "0 of 8 failed"

# --- no results ---------------------------------------------------------------------------------

run worker
check "no results exit 2" "$code" 2
contains "no results names the Gradle command" "$out" "./gradlew :worker:test"

run
check "no module is a usage error" "$code" 2
run frontend
check "an unknown module is a usage error" "$code" 2

# --- --run ----------------------------------------------------------------------------------------

# The stub gradlew writes a failing suite where Gradle would, then exits 1 as a failing run does.
cat > "$fake/gradlew" <<'SH'
#!/usr/bin/env bash
echo "$*" > "$(dirname "$0")/gradlew.log"
echo "TmpRedTest > blowsUp() FAILED"
echo "    at org.junit.Gradle.trace(Gradle.java:1)"
[[ -n "${GRADLE_STUB_COMPILE_ERROR:-}" ]] && { echo "error: cannot find symbol"; exit 1; }
mkdir -p "$(dirname "$0")/worker/build/test-results/test"
cat > "$(dirname "$0")/worker/build/test-results/test/TEST-com.codebite.worker.SubmissionConsumerTest.xml" <<'XML'
<?xml version="1.0" encoding="UTF-8"?>
<testsuite name="com.codebite.worker.SubmissionConsumerTest" tests="1" skipped="0" failures="1" errors="0" timestamp="t" hostname="h" time="0.1">
  <testcase name="gradesEveryCase()" classname="com.codebite.worker.SubmissionConsumerTest" time="0.1">
    <failure message="expected ACCEPTED but was WRONG_ANSWER" type="java.lang.AssertionError">java.lang.AssertionError: expected ACCEPTED but was WRONG_ANSWER
	at com.codebite.worker.SubmissionConsumerTest.gradesEveryCase(SubmissionConsumerTest.java:30)
</failure>
  </testcase>
</testsuite>
XML
exit 1
SH
chmod +x "$fake/gradlew"
run worker --run
check "--run runs the module's tests quietly" "$(cat "$fake/gradlew.log")" ":worker:test -q"
check "--run then reports, exit 1 on a failure" "$code" 1
contains "--run reports the fresh failure" "$out" "com.codebite.worker.SubmissionConsumerTest > gradesEveryCase()"
contains "--run reports its message" "$out" "  expected ACCEPTED but was WRONG_ANSWER"
contains "--run ends with the summary" "$out" "1 of 1 failed"
lacks "--run keeps Gradle's own trace output out of the report" "$out" "at org.junit.Gradle"
contains "--run names the log holding Gradle's output" "$out" "worker/build/test-failures-gradle.log"
set +e; stdout=$(CODEBITE_ROOT=$fake "$script" worker --run 2>"$fake/stderr"); set -e
lacks "--run keeps the log line off stdout, so stdout is only the report" "$stdout" "test-failures-gradle.log"
check "--run's stdout starts with the report" "$(head -n 1 <<<"$stdout")" "com.codebite.worker.SubmissionConsumerTest > gradesEveryCase()"
contains "--run names the log on stderr" "$(cat "$fake/stderr")" "worker/build/test-failures-gradle.log"
contains "the log holds Gradle's output" "$(cat "$fake/worker/build/test-failures-gradle.log")" "at org.junit.Gradle"

rm -r "$fake/worker/build/test-results"
GRADLE_STUB_COMPILE_ERROR=1 run worker --run
check "--run that produces no results exits 2" "$code" 2
contains "--run with no results names the log" "$out" "worker/build/test-failures-gradle.log"
contains "--run with no results prints Gradle's output" "$out" "error: cannot find symbol"

(( fail == 0 )) || exit 1
echo "test-failures.test.sh: ok"
