"""scripts/walkthroughs/codebite.py: what every tracer shares (run-script-tests.sh runs this under python3 -I)."""
import os
import sys
import unittest
from collections import deque

sys.dont_write_bytecode = True
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), "walkthroughs"))
from codebite import (ListNode, bag_text, bit_digits, bit_text, build_list, cell_at, driver_list,  # noqa: E402
                      halving_find, heap_moves, hold_to_best, josa, node_name, node_object, or_infinity, plural, quote,
                      record_return, run_label, table_cell, table_frame, task_frame, union_root)

class RecordedRun:
    """A run that keeps the frames it is given, as (caption, the rest by keyword)."""

    def __init__(self):
        self.frames = []

    def frame(self, caption, **state):
        self.frames.append((caption, state))


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


class Bits(unittest.TestCase):
    def test_a_number_is_written_in_binary_padded_to_the_width(self):
        self.assertEqual([bit_text(5, 4), bit_text(0, 3), bit_text(6, 3)], ["0101", "000", "110"])

    def test_a_number_wider_than_the_width_keeps_all_its_bits(self):
        self.assertEqual(bit_text(9, 2), "1001")

    def test_the_digits_come_as_numbers_highest_place_first(self):
        self.assertEqual(bit_digits(5, 4), [0, 1, 0, 1])


class TableCell(unittest.TestCase):
    def test_a_table_entry_sits_one_row_and_one_column_in_past_the_headers(self):
        self.assertEqual([table_cell(0, 0), table_cell(2, 5)], [[1, 1], [3, 6]])


class TableFrame(unittest.TestCase):
    def test_a_frame_draws_the_grid_in_the_table_view_with_its_marks_moves_and_answer(self):
        run = RecordedRun()
        table_frame(run, [["", "a"], ["b", 1]], "filled", marks={"good": [[1, 1]]}, moves=["a move"], answer="1")
        self.assertEqual(run.frames, [("filled", {"table": {"cells": [["", "a"], ["b", 1]], "marks": {"good": [[1, 1]]}},
                                                  "moves": ["a move"], "answer": "1"})])

    def test_a_frame_with_no_marks_or_moves_draws_the_grid_bare(self):
        run = RecordedRun()
        table_frame(run, [[0]], "start")
        self.assertEqual(run.frames, [("start", {"table": {"cells": [[0]], "marks": {}}, "moves": None})])


class TaskFrame(unittest.TestCase):
    """Three tasks, 1 waiting on 0 and 2 on 1, with task 0 placed first in the order."""

    def frame(self, ready, **given):
        run = RecordedRun()
        task_frame(run, 3, [[1, 0], [2, 1]], [0, 1, 1], [0], deque(ready), "step", **given)
        (caption, state), = run.frames
        self.assertEqual(caption, "step")
        return state

    def test_tasks_are_drawn_in_diagram_order_with_their_waits_and_a_placed_one_tagged_and_dimmed(self):
        self.assertEqual(self.frame([1], node_lit=[1]), {
            "tasks": {"nodes": [{"id": 1}, {"id": 0, "tag": {"en": "#1", "ko": "1번째"}}, {"id": 2}],
                      "values": {"0": 0, "1": 1, "2": 1},
                      "nodeMarks": {"dim": [0], "path": [], "bad": [], "good": [], "lit": [1]},
                      "edgeMarks": {"bad": [], "lit": []}},
            "ready": {"values": [1], "marks": {"lit": [], "good": []}},
            "done": {"values": [0], "marks": {}},
            "moves": None})

    def test_the_task_leaving_the_queue_is_still_drawn_at_its_front(self):
        self.assertEqual(self.frame([1], leaving=0, queue_lit=[0])["ready"],
                         {"values": [0, 1], "marks": {"lit": [0], "good": []}})

    def test_a_final_path_lights_the_order_and_dims_no_task(self):
        state = self.frame([], node_path=[0], answer="[0]")
        self.assertEqual([state["tasks"]["nodeMarks"]["dim"], state["tasks"]["nodeMarks"]["path"], state["done"],
                          state["answer"]], [[], [0], {"values": [0], "marks": {"path": [0]}}, "[0]"])

    def test_marked_edges_and_moves_pass_through(self):
        state = self.frame([], edge_lit=[1], edge_bad=[0], moves=["a move"])
        self.assertEqual([state["tasks"]["edgeMarks"], state["moves"]], [{"bad": [0], "lit": [1]}, ["a move"]])


class UnionFind(unittest.TestCase):
    """parent = [0, 0, 1, 2]: the chain 3 → 2 → 1 → 0."""

    def test_the_root_is_found_without_changing_a_parent(self):
        parent = [0, 0, 1, 2]
        self.assertEqual([union_root(parent, 3), union_root(parent, 0), parent], [0, 0, [0, 0, 1, 2]])

    def test_find_halves_the_path_and_records_where_it_stood_and_what_it_rewrote(self):
        parent, writes, visited = [0, 0, 1, 2], [], []
        self.assertEqual(halving_find(parent, 3, writes, visited), 0)
        # 3 jumps over 2 to 1 (parent[3], read from cell 2, becomes 1); 1's parent is already the root
        self.assertEqual([parent, visited, writes], [[0, 0, 1, 1], [3, 1, 0], [(2, 3, 1)]])

    def test_find_on_a_root_stands_only_on_it(self):
        parent, writes, visited = [0, 1], [], []
        self.assertEqual([halving_find(parent, 1, writes, visited), visited, writes], [1, [1], []])


class HoldToBest(unittest.TestCase):
    def test_a_longer_window_becomes_the_best_and_says_so(self):
        self.assertEqual(hold_to_best(2, 5, 3, (0, 2)), (True, 4, (2, 5), "a new best, 4", "best = 4로 갱신"))

    def test_a_window_no_longer_than_the_best_leaves_it(self):
        self.assertEqual(hold_to_best(2, 4, 3, (0, 2)), (False, 3, (0, 2), "best stays 3", "best = 3 그대로"))

    def test_the_first_window_beats_no_best(self):
        self.assertEqual(hold_to_best(0, 0, 0, None), (True, 1, (0, 0), "a new best, 1", "best = 1로 갱신"))


class ListNodeNames(unittest.TestCase):
    def test_a_node_is_named_by_its_value_and_the_dummy_as_dummy(self):
        dummy, node = ListNode(""), ListNode(7)
        self.assertEqual([node_name(node, dummy), node_name(dummy, dummy)], ["7", "dummy"])

    def test_a_node_equal_to_the_dummy_but_another_object_is_named_by_its_value(self):
        self.assertEqual(node_name(ListNode(""), ListNode("")), "")

    def test_a_node_as_a_korean_object_takes_the_particle_its_value_is_read_with(self):
        # 삼을, 사를
        self.assertEqual([node_object(ListNode(3)), node_object(ListNode(4))], ["3을", "4를"])

    def test_no_node_is_null_as_a_korean_object(self):
        self.assertEqual(node_object(None), "null을")


class RecordReturn(unittest.TestCase):
    def test_a_returned_value_joins_the_result_as_json_and_its_place_comes_back(self):
        result = []
        self.assertEqual([record_return(result, None), record_return(result, 12), record_return(result, True)],
                         [0, 1, 2])
        self.assertEqual(result, ["null", "12", "true"])


class BuildList(unittest.TestCase):
    def test_the_nodes_come_back_in_order_each_linked_to_the_next(self):
        nodes = build_list([3, 1, 2])
        self.assertEqual([n.val for n in nodes], [3, 1, 2])
        self.assertEqual([nodes[0].next, nodes[1].next, nodes[2].next], [nodes[1], nodes[2], None])

    def test_no_values_give_no_nodes(self):
        self.assertEqual(build_list([]), [])


class HeapMoves(unittest.TestCase):
    """A heap list as the last frame drew it against the list now, entries compared by identity."""

    def setUp(self):
        self.a, self.b, self.c, self.d = (1, "a"), (2, "b"), (3, "c"), (4, "d")

    def moves(self, heap, drawn, fresh=()):
        return heap_moves("heap", heap, drawn, lambda e: f"<{e[0]}>", fresh)

    def test_an_entry_still_at_its_node_has_no_move(self):
        self.assertEqual(self.moves([self.a, self.b], [self.a, self.b]), [])

    def test_an_entry_at_a_new_node_moves_from_its_old_one_with_its_text(self):
        self.assertEqual(self.moves([self.b, self.a, self.c], [self.a, self.b, self.c]),
                         [{"from": {"view": "heap", "at": 1}, "to": {"view": "heap", "at": 0}, "value": "<2>"},
                          {"from": {"view": "heap", "at": 0}, "to": {"view": "heap", "at": 1}, "value": "<1>"}])

    def test_an_entry_whose_old_node_is_gone_is_moved_in_with_no_source(self):
        # a pop: a left, and the last entry c, lifted to the top, came from node 2, which the heap no longer has
        self.assertEqual(self.moves([self.c, self.b], [self.a, self.b, self.c]),
                         [{"to": {"view": "heap", "at": 0}, "value": "<3>"}])

    def test_a_fresh_entry_is_left_to_the_caller_and_the_entries_it_displaced_still_move(self):
        self.assertEqual(self.moves([self.a, self.d, self.b], [self.b, self.d], fresh=[self.a]),
                         [{"from": {"view": "heap", "at": 0}, "to": {"view": "heap", "at": 2}, "value": "<2>"}])

    def test_an_equal_entry_that_is_another_object_is_not_the_same_entry(self):
        twin = tuple([1, "a"])
        self.assertEqual(self.moves([twin], [self.a]), [{"to": {"view": "heap", "at": 0}, "value": "<1>"}])


if __name__ == "__main__":
    unittest.main()
