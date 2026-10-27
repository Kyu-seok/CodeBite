"""Tests for scripts/replay-judge0-python.py, against a fake Judge0.

Run: python3 -I scripts/replay-judge0-python.test.py
"""
import importlib.util, unittest
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


if __name__ == "__main__":
    unittest.main()
