import os
import subprocess
import sys
import tempfile
import unittest

SCRIPT = os.path.join(os.path.dirname(os.path.abspath(__file__)), "check-problems-mapping.py")
HEADER = "# Mapping\n\n| # | CodeBite Name | CodeBite Slug | LeetCode Reference | LC # |\n|---|--|--|--|--|\n"


def check(rows, problems):
    with tempfile.NamedTemporaryFile("w", suffix=".md", encoding="utf-8", delete=False) as mapping:
        mapping.write(HEADER + rows)
    try:
        return subprocess.run(
            [sys.executable, "-I", SCRIPT, mapping.name],
            input=problems, capture_output=True, text=True,
        )
    finally:
        os.unlink(mapping.name)


class CheckProblemsMapping(unittest.TestCase):
    def test_matching_rows_pass_silently(self):
        result = check("| 1 | Two Sum | two-sum | Two Sum | 1 |\n", "1\tTwo Sum\ttwo-sum\n")
        self.assertEqual((result.returncode, result.stdout), (0, ""))

    def test_a_row_naming_another_problem_is_reported(self):
        result = check("| 1 | Old | old-slug | Two Sum | 1 |\n", "1\tNew\tnew-slug\n")
        self.assertEqual(result.returncode, 1)
        self.assertIn("#1 is Old (old-slug); the database has New (new-slug)", result.stdout)

    def test_a_problem_without_a_row_is_reported(self):
        result = check("", "0\tPiggy Bank Total\tpiggy-bank-total\n")
        self.assertEqual(result.returncode, 1)
        self.assertIn("#0 has no row", result.stdout)

    def test_a_row_without_a_problem_is_reported(self):
        result = check("| 9 | Gone | gone | Gone | 9 |\n", "")
        self.assertEqual(result.returncode, 1)
        self.assertIn("#9 is Gone (gone); the database has no such number", result.stdout)


if __name__ == "__main__":
    unittest.main()
