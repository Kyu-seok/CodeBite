"""Tests for scripts/judge-local.py, on a throwaway problem in a temporary repository root.

Run: python3 -I scripts/judge-local.test.py
"""
import json, os, shutil, subprocess, sys, tempfile, unittest
from pathlib import Path

SCRIPT = Path(__file__).with_name("judge-local.py")

DRIVERS = {
    "python.py": "{USER_CODE}\n\na = int(input())\nb = int(input())\nprint(Solution().add(a, b))\n",
    "java.java": "import java.util.*;\n\n{USER_CODE}\n\npublic class Main {\n    public static void main(String[] args) {\n"
                 "        Scanner sc = new Scanner(System.in);\n        int a = sc.nextInt(), b = sc.nextInt();\n"
                 "        System.out.println(new Solution().add(a, b));\n    }\n}\n",
    "javascript.js": "{USER_CODE}\n\nconst [a, b] = require('fs').readFileSync('/dev/stdin', 'utf8').trim().split('\\n').map(Number);\n"
                     "console.log(new Solution().add(a, b));\n",
    "cpp.cpp": "#include <iostream>\nusing namespace std;\n\n{USER_CODE}\n\nint main() {\n    int a, b;\n    cin >> a >> b;\n"
               "    cout << Solution().add(a, b) << endl;\n    return 0;\n}\n",
}
SOLUTIONS = {
    "py": "class Solution:\n    def add(self, a, b):\n        return a + b\n",
    "java": "class Solution {\n    int add(int a, int b) { return a + b; }\n}\n",
    "js": "class Solution {\n    add(a, b) { return a + b; }\n}\n",
    "cpp": "class Solution {\npublic:\n    int add(int a, int b) { return a + b; }\n};\n",
}
TOOLS = {"java": ["javac", "java"], "javascript": ["node"], "cpp": ["g++"]}
CASES = [{"input": "1\n2", "expected_output": "3"}, {"input": "5\n5", "expected_output": "10"}]
PY_RIGHT = "class Solution:\n    def add(self, a, b):\n        return a + b\n"


class JudgeLocal(unittest.TestCase):
    def setUp(self):
        self.root = Path(tempfile.mkdtemp(prefix="judge-local-test-"))
        self.addCleanup(shutil.rmtree, self.root)
        self.driver("add-two", DRIVERS)
        self.cases = CASES

    def driver(self, slug, files):
        d = self.root / "common/src/main/resources/drivers" / slug
        d.mkdir(parents=True, exist_ok=True)
        for name, text in files.items():
            (d / name).write_text(text)

    def solution(self, name, text):
        d = self.root / "scripts/replay-solutions"
        d.mkdir(parents=True, exist_ok=True)
        (d / name).write_text(text)

    def judge(self, *languages, env=None):
        cases = self.root / "cases.json"
        cases.write_text(json.dumps(self.cases))
        args = [sys.executable, "-I", str(SCRIPT), str(self.root), str(cases), "add-two"]
        if languages:
            args += ["--languages", ",".join(languages)]
        return subprocess.run(args, capture_output=True, text=True, env={**os.environ, **(env or {})}, timeout=120)

    def test_a_right_python_solution_is_accepted(self):
        self.solution("add-two.py", PY_RIGHT)
        r = self.judge("python")
        self.assertEqual(r.returncode, 0, r.stdout + r.stderr)
        self.assertRegex(r.stdout, r"python\s+ACCEPTED")

    def test_right_solutions_are_accepted_in_every_language(self):
        for ext, text in SOLUTIONS.items():
            self.solution(f"add-two.{ext}", text)
        for language, tools in TOOLS.items():
            with self.subTest(language):
                if not all(shutil.which(t) for t in tools):
                    self.skipTest(f"{language} toolchain not installed")
                r = self.judge(language)
                self.assertEqual(r.returncode, 0, r.stdout + r.stderr)
                self.assertRegex(r.stdout, rf"{language}\s+ACCEPTED")

    def test_a_compile_error_is_reported_as_one(self):
        self.solution("add-two.java", "class Solution { int add(int a, int b) { return a + } }\n")
        if not shutil.which("javac"):
            self.skipTest("javac not installed")
        r = self.judge("java")
        self.assertEqual(r.returncode, 1)
        self.assertIn("COMPILATION_ERROR", r.stdout)

    def test_a_wrong_answer_fails_on_the_first_case_it_gets_wrong(self):
        self.solution("add-two.py", "class Solution:\n    def add(self, a, b):\n        return 10\n")
        r = self.judge("python")
        self.assertEqual(r.returncode, 1)
        self.assertIn("WRONG_ANSWER on test case 1", r.stdout)

    def test_output_is_compared_trimmed_and_a_null_expected_output_only_has_to_run(self):
        self.solution("add-two.py", PY_RIGHT.replace("return a + b", "return f'  {a + b}  '"))
        self.cases = [{"input": "1\n2", "expected_output": "3\n"}, {"input": "4\n4", "expected_output": None}]
        self.assertEqual(self.judge("python").returncode, 0)

    def test_an_empty_expected_output_is_a_real_answer(self):
        self.solution("add-two.py", PY_RIGHT)
        self.cases = [{"input": "1\n2", "expected_output": ""}]
        self.assertIn("WRONG_ANSWER on test case 1", self.judge("python").stdout)

    def test_a_crash_is_a_runtime_error(self):
        self.solution("add-two.py", "class Solution:\n    def add(self, a, b):\n        raise KeyError('boom')\n")
        r = self.judge("python")
        self.assertEqual(r.returncode, 1)
        self.assertIn("RUNTIME_ERROR on test case 1", r.stdout)
        self.assertIn("KeyError", r.stdout)

    def test_a_missing_compiler_is_reported_as_missing_not_as_a_failed_case(self):
        self.solution("add-two.java", SOLUTIONS["java"])
        empty = self.root / "empty-path"
        empty.mkdir()
        r = self.judge("java", env={"PATH": str(empty)})
        self.assertEqual(r.returncode, 2, r.stdout + r.stderr)
        self.assertRegex(r.stdout, r"java\s+NOT JUDGED: javac not found")
        self.assertNotRegex(r.stdout, "WRONG_ANSWER|RUNTIME_ERROR|COMPILATION_ERROR")

    def test_a_cxx_that_does_not_exist_is_missing(self):
        self.solution("add-two.cpp", SOLUTIONS["cpp"])
        r = self.judge("cpp", env={"CXX": str(self.root / "no-such-g++")})
        self.assertEqual(r.returncode, 2)
        self.assertIn("NOT JUDGED", r.stdout)

    def test_a_language_without_a_reference_solution_is_not_judged(self):
        self.solution("add-two.py", PY_RIGHT)
        r = self.judge("python", "javascript")
        self.assertEqual(r.returncode, 2)
        self.assertRegex(r.stdout, r"python\s+ACCEPTED")
        self.assertIn("NOT JUDGED: no reference solution at scripts/replay-solutions/add-two.js", r.stdout)

    def test_a_failure_outranks_a_missing_toolchain(self):
        self.solution("add-two.py", "class Solution:\n    def add(self, a, b):\n        return 0\n")
        self.assertEqual(self.judge("python", "javascript").returncode, 1)

    def test_an_unknown_language_is_a_usage_error(self):
        r = self.judge("rust")
        self.assertEqual(r.returncode, 2)
        self.assertIn("rust", r.stderr)
        self.assertNotIn("Traceback", r.stderr)

    def test_library_markers_are_inlined(self):
        self.driver("add-two", {"python.py": "# {{LIB:Adder}}\n{USER_CODE}\n\nprint(Solution().add(*map(int, open(0).read().split())))\n"})
        self.driver("lib/python", {"Adder.py": "def adder(a, b):\n    return a + b\n"})
        self.solution("add-two.py", "class Solution:\n    def add(self, a, b):\n        return adder(a, b)\n")
        self.assertEqual(self.judge("python").returncode, 0)

    def test_a_missing_driver_fails_the_problem(self):
        (self.root / "common/src/main/resources/drivers/add-two/javascript.js").unlink()
        self.solution("add-two.js", SOLUTIONS["js"])
        r = self.judge("javascript")
        self.assertEqual(r.returncode, 1)
        self.assertIn("NO_DRIVER", r.stdout)
        self.assertNotIn("Traceback", r.stderr)

    def test_a_problem_without_test_cases_fails(self):
        self.solution("add-two.py", PY_RIGHT)
        self.cases = []
        r = self.judge("python")
        self.assertEqual(r.returncode, 1)
        self.assertIn("NO_TEST_CASES", r.stdout)


if __name__ == "__main__":
    unittest.main()
