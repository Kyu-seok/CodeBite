"""scripts/walkthroughs/codebite.py: what every tracer shares (run-script-tests.sh runs this under python3 -I)."""
import os
import sys
import unittest

sys.dont_write_bytecode = True
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), "walkthroughs"))
from codebite import (bag_text, build_list, cell_at, driver_list, josa, or_infinity, plural, quote,  # noqa: E402
                      run_label)

DESCRIPTION = "Intro.\n\n**Example 1:**\n```\nInput: x = 1\n```\n\n**Example 2:**\n```\nInput: x = 2\n```\n"


class RunLabel(unittest.TestCase):
    def test_a_sample_the_description_shows_is_labelled_as_its_example(self):
        self.assertEqual(run_label(2, DESCRIPTION), {"en": "Example 2", "ko": "예시 2"})

    def test_a_sample_beyond_the_examples_is_labelled_as_the_test_panel_numbers_it(self):
        self.assertEqual(run_label(3, DESCRIPTION), {"en": "Case 3", "ko": "케이스 3"})

    def test_example_numbers_are_matched_whole(self):
        self.assertEqual(run_label(1, "**Example 12:**")["en"], "Case 1")


class DriverList(unittest.TestCase):
    def test_a_list_prints_as_the_driver_prints_it_with_no_spaces(self):
        self.assertEqual(driver_list([[1, 3], [2, 6]]), "[[1,3],[2,6]]")

    def test_strings_are_quoted_and_escaped_as_json(self):
        self.assertEqual(driver_list(["eat", "a\"b", "é"]), '["eat","a\\"b","\\u00e9"]')


class Plural(unittest.TestCase):
    def test_one_takes_the_singular(self):
        self.assertEqual(plural(1, "window", "windows"), "window")

    def test_zero_and_many_take_the_plural(self):
        self.assertEqual([plural(0, "book", "books"), plural(2, "book", "books")], ["books", "books"])


class Josa(unittest.TestCase):
    def test_a_number_read_with_a_final_vowel_takes_the_vowel_form(self):
        # 이, 사, 오, 구
        self.assertEqual([josa(n, "은는") for n in (2, 14, 25, 109)], ["2는", "14는", "25는", "109는"])

    def test_a_number_read_with_a_final_consonant_takes_the_consonant_form(self):
        # 일, 삼, 육, 칠, 팔, and 영 십 백 천 만 for a final 0
        self.assertEqual([josa(n, "이가") for n in (1, 3, 6, 7, 8, 0, 10, 100, 1000, 10000)],
                         ["1이", "3이", "6이", "7이", "8이", "0이", "10이", "100이", "1000이", "10000이"])

    def test_a_negative_number_is_read_by_its_digits(self):
        self.assertEqual(josa(-4, "을를"), "-4를")

    def test_ro_drops_eu_after_a_vowel_or_a_final_rieul(self):
        # 로 after 이 사 오 구 and after 일 칠 팔 (ㄹ); 으로 after 삼 육 and 영 십 백
        self.assertEqual([josa(n, "(으)로") for n in (2, 4, 5, 9, 1, 7, 8)],
                         ["2로", "4로", "5로", "9로", "1로", "7로", "8로"])
        self.assertEqual([josa(n, "(으)로") for n in (3, 6, 0, 10, 100)],
                         ["3으로", "6으로", "0으로", "10으로", "100으로"])

    def test_an_unknown_particle_is_refused(self):
        with self.assertRaises(ValueError):
            josa(3, "로")


class CaptionHelpers(unittest.TestCase):
    def test_a_string_is_named_in_single_quotes(self):
        self.assertEqual(quote("aba"), "'aba'")

    def test_an_unreached_cost_shows_as_infinity_and_a_reached_one_as_itself(self):
        self.assertEqual([or_infinity(float("inf")), or_infinity(0), or_infinity(7)], ["∞", 0, 7])

    def test_a_grid_cell_is_written_in_parentheses(self):
        self.assertEqual(cell_at(1, 2), "(1,2)")

    def test_a_bag_tag_names_its_size_in_both_languages(self):
        self.assertEqual(bag_text(4), {"en": "bag 4", "ko": "봉지 4"})


class BuildList(unittest.TestCase):
    def test_the_nodes_come_back_in_order_each_linked_to_the_next(self):
        nodes = build_list([3, 1, 2])
        self.assertEqual([n.val for n in nodes], [3, 1, 2])
        self.assertEqual([nodes[0].next, nodes[1].next, nodes[2].next], [nodes[1], nodes[2], None])

    def test_no_values_give_no_nodes(self):
        self.assertEqual(build_list([]), [])


if __name__ == "__main__":
    unittest.main()
