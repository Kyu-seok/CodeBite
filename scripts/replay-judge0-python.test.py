"""Tests for scripts/replay-judge0-python.py, against a fake Judge0.

Run: python3 -I scripts/replay-judge0-python.test.py
"""
import importlib.util, os, shutil, stat, tempfile, unittest
from pathlib import Path

spec = importlib.util.spec_from_file_location("replay", Path(__file__).with_name("replay-judge0-python.py"))
replay = importlib.util.module_from_spec(spec)
spec.loader.exec_module(replay)

ACCEPTED, WRONG, TLE, RUNTIME = 3, 4, 5, 11


def result(status, stdout=""):
    return {"status": {"id": status, "description": str(status)}, "stdout": stdout, "stderr": "", "compile_output": ""}


class FakeJudge:
    """Answers each (source, stdin) from a script: source -> {stdin: [result, ...]}, one result per call."""

    def __init__(self, script):
        self.script = {src: {k: list(v) for k, v in answers.items()} for src, answers in script.items()}
        self.calls = []

    def __call__(self, source, language_id, stdins):
        self.calls.append((source, language_id, list(stdins)))
        return [self.script[source][stdin].pop(0) for stdin in stdins]


def problem(slug, cases, source=None, origin="user"):
    return {"slug": slug,
            "test_cases": [{"input": i, "expected_output": o} for i, o in cases],
            "solution": {"source": source, "origin": origin} if source else None}


def run(problems, judge, **kw):
    kw.setdefault("assemble", lambda slug, code: code)
    kw.setdefault("sleep", lambda s: None)
    kw.setdefault("log", lambda *a: None)
    return replay.replay(problems, judge, 100, **kw)


class ReplayTest(unittest.TestCase):

    def test_solution_matching_every_expected_output_passes(self):
        judge = FakeJudge({"sol": {"1": [result(ACCEPTED, "2\n")], "5": [result(ACCEPTED, " 10 ")]}})
        report = run([problem("double", [("1", "2"), ("5", "10")], "sol")], judge)
        self.assertEqual(report.passed, ["double"])
        self.assertEqual(report.failed, [])
        self.assertEqual(judge.calls, [("sol", 100, ["1", "5"])])

    def test_problem_fails_with_the_first_failing_case_in_order(self):
        judge = FakeJudge({"sol": {"1": [result(ACCEPTED, "2")], "2": [result(ACCEPTED, "5")],
                                   "3": [result(RUNTIME)]}})
        report = run([problem("double", [("1", "2"), ("2", "4"), ("3", "6")], "sol")], judge)
        self.assertEqual(report.passed, [])
        self.assertEqual([(f.slug, f.status, f.case) for f in report.failed], [("double", "WRONG_ANSWER", 2)])

    def test_time_limit_exceeded_cases_are_retried_once(self):
        judge = FakeJudge({
            "flaky": {"1": [result(ACCEPTED, "2")], "2": [result(TLE), result(ACCEPTED, "4")]},
            "slow": {"1": [result(TLE), result(TLE)]},
        })
        report = run([problem("flaky", [("1", "2"), ("2", "4")], "flaky"),
                      problem("slow", [("1", "2")], "slow")], judge)
        self.assertEqual(report.passed, ["flaky"])
        self.assertEqual([(f.slug, f.status) for f in report.failed], [("slow", "TIME_LIMIT_EXCEEDED")])
        self.assertEqual(judge.calls, [("flaky", 100, ["1", "2"]), ("flaky", 100, ["2"]),
                                       ("slow", 100, ["1"]), ("slow", 100, ["1"])])

    def test_problem_without_a_submission_uses_its_reference_solution_or_has_nothing_to_replay(self):
        judge = FakeJudge({"ref": {"1": [result(RUNTIME)]}})
        report = run([problem("referenced", [("1", "2")]), problem("bare", [("1", "2")])], judge,
                     references={"referenced": "ref"})
        self.assertEqual([(f.slug, f.origin) for f in report.failed], [("referenced", "reference")])
        self.assertEqual(report.nothing, ["bare"])
        self.assertEqual(judge.calls, [("ref", 100, ["1"])])

    def test_an_error_judging_one_problem_fails_it_and_the_replay_goes_on(self):
        judge = FakeJudge({"ok": {"1": [result(ACCEPTED, "2")]}})
        report = run([problem("broken", [("1", "2")], "missing"), problem("fine", [("1", "2")], "ok")], judge)
        self.assertEqual(report.passed, ["fine"])
        self.assertEqual([(f.slug, f.status) for f in report.failed], [("broken", "ERROR")])
        self.assertIn("missing", report.failed[0].detail)

    def test_problem_without_test_cases_fails_rather_than_passing_unchecked(self):
        report = run([problem("empty", [], "sol")], FakeJudge({}))
        self.assertEqual([(f.slug, f.status) for f in report.failed], [("empty", "NO_TEST_CASES")])

    def test_pauses_between_judged_problems_only(self):
        judge = FakeJudge({"a": {"1": [result(ACCEPTED, "2")]}, "c": {"1": [result(ACCEPTED, "2")]}})
        sleeps = []
        run([problem("a", [("1", "2")], "a"), problem("b", [("1", "2")]), problem("c", [("1", "2")], "c")],
            judge, pause=2.5, sleep=sleeps.append)
        self.assertEqual(sleeps, [2.5])


# The local judge's tests run real tiny programs on a local Python 3.12.
PYTHON_312 = os.environ.get("CODEBITE_PYTHON312") or shutil.which("python3.12") or "/opt/homebrew/bin/python3.12"
ECHO_DOUBLE = "print(int(input()) * 2)"


@unittest.skipUnless(os.path.exists(PYTHON_312), f"needs Python 3.12 at {PYTHON_312}")
class LocalJudgeTest(unittest.TestCase):

    def verdicts(self, source, cases, time_limit=5):
        judge = replay.local_judge(PYTHON_312, time_limit)
        report = run([problem("p", cases, source)], judge)
        return report.passed, [(f.status, f.case) for f in report.failed]

    def test_correct_output_is_accepted(self):
        self.assertEqual(self.verdicts(ECHO_DOUBLE, [("1", "2"), ("21", "42")]), (["p"], []))

    def test_wrong_output_is_wrong_answer(self):
        self.assertEqual(self.verdicts(ECHO_DOUBLE, [("1", "2"), ("2", "5")]), ([], [("WRONG_ANSWER", 2)]))

    def test_an_exception_is_a_runtime_error_with_its_message(self):
        judge = replay.local_judge(PYTHON_312)
        report = run([problem("p", [("1", "2")], "raise ValueError('boom')")], judge)
        self.assertEqual([(f.status, f.detail) for f in report.failed], [("RUNTIME_ERROR", "ValueError: boom")])

    def test_a_syntax_error_is_a_runtime_error(self):
        self.assertEqual(self.verdicts("def f(:\n    pass", [("1", "2")]), ([], [("RUNTIME_ERROR", 1)]))

    def test_modern_syntax_runs(self):
        source = "match int(input()):\n    case n:\n        xs: list[int] = [n]\n        print(f\"{xs[0] * 2}\")"
        self.assertEqual(self.verdicts(source, [("4", "8")]), (["p"], []))

    def test_a_run_past_the_time_limit_is_time_limit_exceeded_after_one_retry(self):
        judge = replay.local_judge(PYTHON_312, time_limit=0.5)
        calls = []
        counting = lambda source, language_id, stdins: calls.append(stdins) or judge(source, language_id, stdins)
        report = run([problem("p", [("1", "2"), ("2", "4")], "import time\nn = int(input())\n"
                                                          "time.sleep(2 if n == 2 else 0)\nprint(n * 2)")],
                     counting)
        self.assertEqual([(f.status, f.case) for f in report.failed], [("TIME_LIMIT_EXCEEDED", 2)])
        self.assertEqual(calls, [["1", "2"], ["2"]])


    def test_a_target_naming_an_interpreter_judges_locally(self):
        report = run([problem("p", [("3", "6")], ECHO_DOUBLE)], replay.judge_for(PYTHON_312))
        self.assertEqual(report.passed, ["p"])

    def test_a_target_naming_a_url_judges_on_judge0(self):
        judge = replay.judge_for("http://127.0.0.1:9/")
        with self.assertRaises(OSError):  # nothing listens on the discard port: proof it went over HTTP
            judge("print(1)", 100, [""])


class LocalJudgeVersionTest(unittest.TestCase):

    def interpreter(self, version):
        """A stand-in interpreter that reports the given version, whatever it is asked to run."""
        path = Path(tempfile.mkdtemp()) / "python"
        path.write_text(f"#!/bin/sh\necho {version}\n")
        path.chmod(path.stat().st_mode | stat.S_IEXEC)
        self.addCleanup(shutil.rmtree, path.parent)
        return str(path)

    def test_an_interpreter_older_than_3_12_is_refused(self):
        with self.assertRaisesRegex(ValueError, r"3\.11\.9.*3\.12 or newer"):
            replay.local_judge(self.interpreter("3.11.9"))

    def test_an_interpreter_that_is_not_python_is_refused(self):
        with self.assertRaisesRegex(ValueError, "not a Python"):
            replay.local_judge("/nonexistent/python3.12")

    def test_3_12_and_newer_are_accepted(self):
        replay.local_judge(self.interpreter("3.12.0"))
        replay.local_judge(self.interpreter("3.13.1"))


if __name__ == "__main__":
    unittest.main()
