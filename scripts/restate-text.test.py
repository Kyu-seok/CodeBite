import json
import os
import subprocess
import sys
import tempfile
import unittest

SCRIPT = os.path.join(os.path.dirname(os.path.abspath(__file__)), "restate-text.py")
CURRENT = {
    "en": {"title": "Merge Cafe Queues", "description": "Merge the queues.\n\n**Example 1:**\n```\nInput: q = [[1]]\nOutput: [1]\n```",
           "constraints": "- `0 <= k <= 10`\n- The total number of order nodes is small."},
    "ko": {"title": "카페 주문 큐 합치기", "description": "큐를 합치세요.",
           "constraints": "- `0 <= k <= 10`\n- 모든 큐의 주문 노드 총 개수는 작습니다."},
}


def restate(edits, version=900, slug="merge-cafe-queues"):
    """Runs the script on a spec; returns (result, {file name: text} written)."""
    with tempfile.TemporaryDirectory() as tmp:
        spec = os.path.join(tmp, "spec.json")
        current = os.path.join(tmp, "current.json")
        out = os.path.join(tmp, "migrations")
        os.mkdir(out)
        with open(spec, "w", encoding="utf-8") as f:
            json.dump({"slug": slug, "version": version, "why": ["The constraints named order nodes."], "edits": edits}, f)
        with open(current, "w", encoding="utf-8") as f:
            json.dump(CURRENT, f)
        result = subprocess.run([sys.executable, "-I", SCRIPT, spec, "--current", current, "--out-dir", out],
                                capture_output=True, text=True)
        written = {}
        for name in os.listdir(out):
            with open(os.path.join(out, name), encoding="utf-8") as f:
                written[name] = f.read()
        return result, written


class RestateText(unittest.TestCase):
    def test_both_languages_are_rewritten_and_untouched_columns_left_out(self):
        result, written = restate([
            {"lang": "en", "column": "constraints", "old": "order nodes", "new": "nodes"},
            {"lang": "ko", "column": "constraints", "old": "주문 노드", "new": "노드"},
        ])
        self.assertEqual(result.returncode, 0, result.stderr)
        sql = written["V900__restate_merge_cafe_queues.sql"]
        self.assertTrue(sql.startswith("-- V900: merge-cafe-queues, text only. The constraints named order nodes.\n"))
        self.assertIn("UPDATE problems SET\n    constraints = $$- `0 <= k <= 10`\n- The total number of nodes is small.$$\n"
                      "WHERE slug = $$merge-cafe-queues$$;", sql)
        self.assertIn("UPDATE problem_translations SET\n    constraints = $$- `0 <= k <= 10`\n- 모든 큐의 노드 총 개수는 작습니다.$$\n"
                      "WHERE locale = 'ko'\n  AND problem_id = (SELECT id FROM problems WHERE slug = $$merge-cafe-queues$$);", sql)
        self.assertNotIn("description", sql)
        self.assertNotIn("title", sql)

    def test_edits_to_one_column_apply_in_order(self):
        result, written = restate([
            {"lang": "en", "column": "description", "old": "Merge the queues.", "new": "Merge the sorted queues."},
            {"lang": "en", "column": "description", "old": "sorted queues", "new": "sorted lists"},
        ])
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn("description = $$Merge the sorted lists.\n\n**Example 1:**", written["V900__restate_merge_cafe_queues.sql"])

    def test_korean_only_edits_name_the_file_ko_and_leave_problems_alone(self):
        result, written = restate([{"lang": "ko", "column": "title", "old": "카페 주문 큐", "new": "카페 큐"}])
        self.assertEqual(result.returncode, 0, result.stderr)
        sql = written["V900__restate_merge_cafe_queues_ko.sql"]
        self.assertNotIn("UPDATE problems", sql)
        self.assertIn("title = $$카페 큐 합치기$$", sql)

    def test_an_old_text_not_found_writes_nothing(self):
        result, written = restate([
            {"lang": "en", "column": "constraints", "old": "order nodes", "new": "nodes"},
            {"lang": "en", "column": "constraints", "old": "no such text", "new": "x"},
        ])
        self.assertEqual(result.returncode, 1)
        self.assertIn("en constraints: 'no such text' occurs 0 times", result.stderr)
        self.assertEqual(written, {})

    def test_an_old_text_found_twice_is_refused(self):
        result, written = restate([{"lang": "en", "column": "constraints", "old": "`0 <= k", "new": "`1 <= k"},
                                   {"lang": "en", "column": "constraints", "old": "-", "new": "*"}])
        self.assertEqual(result.returncode, 1)
        self.assertIn("'-' occurs 2 times", result.stderr)
        self.assertEqual(written, {})

    def test_a_dollar_quote_in_the_new_text_is_refused(self):
        result, written = restate([{"lang": "en", "column": "title", "old": "Merge", "new": "$$Merge"}])
        self.assertEqual(result.returncode, 1)
        self.assertIn("$$", result.stderr)
        self.assertEqual(written, {})

    def test_a_column_outside_the_statement_is_refused(self):
        result, written = restate([{"lang": "en", "column": "slug", "old": "merge", "new": "join"}])
        self.assertEqual(result.returncode, 1)
        self.assertIn("column slug", result.stderr)
        self.assertEqual(written, {})


if __name__ == "__main__":
    unittest.main()
