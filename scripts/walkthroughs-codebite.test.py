"""scripts/walkthroughs/codebite.py: what every tracer shares (run-script-tests.sh runs this under python3 -I)."""
import os
import sys
import unittest

sys.dont_write_bytecode = True
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), "walkthroughs"))
from codebite import run_label  # noqa: E402

DESCRIPTION = "Intro.\n\n**Example 1:**\n```\nInput: x = 1\n```\n\n**Example 2:**\n```\nInput: x = 2\n```\n"


class RunLabel(unittest.TestCase):
    def test_a_sample_the_description_shows_is_labelled_as_its_example(self):
        self.assertEqual(run_label(2, DESCRIPTION), {"en": "Example 2", "ko": "예시 2"})

    def test_a_sample_beyond_the_examples_is_labelled_as_the_test_panel_numbers_it(self):
        self.assertEqual(run_label(3, DESCRIPTION), {"en": "Case 3", "ko": "케이스 3"})

    def test_example_numbers_are_matched_whole(self):
        self.assertEqual(run_label(1, "**Example 12:**")["en"], "Case 1")


if __name__ == "__main__":
    unittest.main()
