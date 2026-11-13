"""scripts/walkthroughs/walkthrough_trace.py: the recorder every tracer writes through (run-script-tests.sh runs this under python3 -I)."""
import os
import sys
import tempfile
import unittest

sys.dont_write_bytecode = True
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), "walkthroughs"))
from walkthrough_trace import Walkthrough  # noqa: E402


def walkthrough_answering(answer):
    wt = Walkthrough("Title", "Approach.", views=[{"id": "state", "type": "vars"}])
    wt.run("Example 1", input="x = 1", expected="2").frame("Done.", answer=answer, state={"items": []})
    return wt


class Write(unittest.TestCase):
    def test_a_refused_run_leaves_the_committed_file_as_it_was(self):
        with tempfile.TemporaryDirectory() as d:
            path = os.path.join(d, "walkthrough.json")
            with open(path, "w", encoding="utf-8") as fh:
                fh.write("committed\n")
            with self.assertRaises(ValueError):
                walkthrough_answering("3").write(path)
            with open(path, encoding="utf-8") as fh:
                self.assertEqual(fh.read(), "committed\n")

    def test_a_refused_run_writes_no_file(self):
        with tempfile.TemporaryDirectory() as d:
            path = os.path.join(d, "walkthrough.json")
            with self.assertRaises(ValueError):
                walkthrough_answering("3").write(path)
            self.assertFalse(os.path.exists(path))

    def test_an_accepted_run_is_written(self):
        with tempfile.TemporaryDirectory() as d:
            path = os.path.join(d, "walkthrough.json")
            walkthrough_answering("2").write(path)
            with open(path, encoding="utf-8") as fh:
                self.assertIn('"answer": "2"', fh.read())


if __name__ == "__main__":
    unittest.main()
