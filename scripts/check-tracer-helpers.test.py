"""Tests for scripts/check-tracer-helpers.py, on a throwaway tracer directory.

Run: python3 -I scripts/check-tracer-helpers.test.py
"""
import os, shutil, subprocess, sys, tempfile, unittest
from pathlib import Path

SCRIPT = Path(__file__).with_name("check-tracer-helpers.py")
ORDINAL = 'def ordinal(n):\n    return f"{n}th"\n'


class CheckTracerHelpers(unittest.TestCase):
    def setUp(self):
        self.dir = Path(tempfile.mkdtemp(prefix="check-tracer-helpers-test-"))
        self.addCleanup(shutil.rmtree, self.dir)
        self.write("codebite.py", "def plural(n, one, many):\n    return one if n == 1 else many\n")

    def write(self, name, text):
        (self.dir / name).write_text(text, encoding="utf-8")

    def check(self, **env):
        run = subprocess.run([sys.executable, "-I", str(SCRIPT), str(self.dir)], capture_output=True, text=True,
                             env={**os.environ, **env}, timeout=60)
        return run.returncode, run.stdout

    def test_two_tracers_sharing_a_body_fail_naming_both_and_codebite(self):
        self.write("two-sum.py", ORDINAL + "\n\ndef solve(nums):\n    return ordinal(nums[0])\n")
        self.write("three-sum.py", "import json\n\n\n" + ORDINAL + "\n\ndef solve(nums):\n    return json.dumps(nums)\n")
        code, out = self.check()
        self.assertEqual(code, 1)
        self.assertEqual(out, "  COPY  ordinal: three-sum.py and two-sum.py define the same function; "
                              "move it into codebite.py and import it from there\n")

    def test_the_same_name_with_different_bodies_passes(self):
        self.write("two-sum.py", "def show(x):\n    return str(x)\n")
        self.write("three-sum.py", 'def show(x):\n    return "none" if x is None else str(x)\n')
        self.assertEqual(self.check(), (0, ""))

    def test_layout_comments_and_a_docstring_do_not_make_a_copy_a_different_function(self):
        self.write("two-sum.py", ORDINAL)
        self.write("three-sum.py", 'def ordinal( n ):\n    """n as an ordinal."""\n    # every n\n    return (f"{n}th")\n')
        code, out = self.check()
        self.assertEqual(code, 1)
        self.assertIn("COPY  ordinal: three-sum.py and two-sum.py", out)

    def test_three_tracers_sharing_a_body_are_one_line(self):
        for name in ("two-sum.py", "three-sum.py", "four-sum.py"):
            self.write(name, ORDINAL)
        code, out = self.check()
        self.assertEqual(code, 1)
        self.assertEqual(out, "  COPY  ordinal: four-sum.py, three-sum.py and two-sum.py define the same function; "
                              "move it into codebite.py and import it from there\n")

    def test_a_tracer_copying_a_codebite_helper_is_told_to_import_it(self):
        self.write("two-sum.py", "def plural(n, one, many):\n    return one if n == 1 else many\n")
        code, out = self.check()
        self.assertEqual(code, 1)
        self.assertEqual(out, "  COPY  plural: two-sum.py defines a function codebite.py has; import it from there\n")

    def test_another_signature_is_another_function(self):
        self.write("two-sum.py", "def listed(values, sep=', '):\n    return sep.join(values)\n")
        self.write("three-sum.py", "def listed(values, sep=' and '):\n    return sep.join(values)\n")
        self.assertEqual(self.check(), (0, ""))

    def test_methods_are_not_compared(self):
        body = "    def walk(self):\n        return 1\n"
        self.write("two-sum.py", "class Solution:\n" + body)
        self.write("three-sum.py", "class Solution:\n" + body)
        self.assertEqual(self.check(), (0, ""))

    NESTED = "    def nid(i):\n        return f\"n{i}\"\n"

    def nested_in(self, *names):
        for name in names:
            self.write(name, f"def solve(nums):\n{self.NESTED}    return nid(len(nums)) + {name!r}\n")

    def test_two_tracers_sharing_a_nested_function_fail_naming_both(self):
        self.nested_in("two-sum.py", "three-sum.py")
        code, out = self.check()
        self.assertEqual(code, 1)
        self.assertEqual(out, "  COPY  nid: three-sum.py and two-sum.py define the same nested function; "
                              "move it into codebite.py and import it from there\n")

    def test_a_nested_function_inside_a_method_is_compared(self):
        for name in ("two-sum.py", "three-sum.py"):
            self.write(name, "class Solution:\n    def solve(self, nums):\n"
                       + self.NESTED.replace("    ", "        ") + f"        return nid(0) + {name!r}\n")
        code, out = self.check()
        self.assertEqual(code, 1)
        self.assertIn("COPY  nid: three-sum.py and two-sum.py define the same nested function", out)

    def test_a_listed_nested_copy_passes(self):
        self.nested_in("two-sum.py", "three-sum.py")
        self.write("nested-copies.known", "# cleared by #999\nnid: three-sum.py, two-sum.py\n")
        self.assertEqual(self.check(), (0, ""))

    def test_a_third_tracer_copying_a_listed_nested_function_fails(self):
        self.nested_in("two-sum.py", "three-sum.py", "four-sum.py")
        self.write("nested-copies.known", "nid: three-sum.py, two-sum.py\n")
        code, out = self.check()
        self.assertEqual(code, 1)
        self.assertIn("COPY  nid: four-sum.py, three-sum.py and two-sum.py define the same nested function", out)

    def test_a_listed_nested_copy_that_is_gone_fails_as_stale(self):
        self.nested_in("two-sum.py")
        self.write("nested-copies.known", "nid: three-sum.py, two-sum.py\n")
        code, out = self.check()
        self.assertEqual(code, 1)
        self.assertEqual(out, "  STALE  nested-copies.known lists nid: three-sum.py, two-sum.py, "
                              "which no longer share it; remove the line\n")

    def test_a_tracer_in_python_312_syntax_is_read(self):
        # Tracers run on python3.12 and nest a quote inside an f-string; this machine's python3 is 3.9.
        nested = 'def q(text):\n    return f"{", ".join(text)}"\n'
        self.write("two-sum.py", nested)
        self.write("three-sum.py", nested)
        code, out = self.check()
        self.assertEqual(code, 1)
        self.assertIn("COPY  q: three-sum.py and two-sum.py", out)

    def test_one_file_defining_a_function_twice_is_not_a_copy(self):
        self.write("two-sum.py", ORDINAL + "\n\n" + ORDINAL)
        self.assertEqual(self.check(), (0, ""))

    def test_a_tracer_that_does_not_parse_exits_2_naming_it(self):
        self.write("two-sum.py", "def solve(:\n")
        run = subprocess.run([sys.executable, "-I", str(SCRIPT), str(self.dir)], capture_output=True, text=True)
        self.assertEqual(run.returncode, 2)
        self.assertIn("two-sum.py:1: does not parse", run.stderr)


if __name__ == "__main__":
    unittest.main()
