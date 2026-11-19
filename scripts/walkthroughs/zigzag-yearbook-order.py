#!/usr/bin/env python3.12
"""zigzag-yearbook-order's Walkthrough: the reference solution (scripts/replay-solutions/zigzag-yearbook-order.py),
breadth first one level at a time: each level is listed left to right, and its values go into the answer as one row,
as listed on an even row and reversed on an odd one; then the level is replaced by its nodes' children, left before
right. The tree is drawn as the description's Diagram draws it, the current level shaded; the level list is an array
whose values move in from their nodes, each tagged with its place in the row it is written into, and each row moves
from the level into the answer. Two frames per level, on each sample Test Case.

    CODEBITE_DB=<database> scripts/walkthroughs/zigzag-yearbook-order.py

writes common/src/main/resources/walkthroughs/zigzag-yearbook-order.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import build_tree, driver_list, plural, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, level_order_tree, move  # noqa: E402

SLUG = "zigzag-yearbook-order"

wt = Walkthrough(
    {"en": "Zigzag Yearbook Order", "ko": "지그재그 졸업앨범 순서"},
    {"en": "Read the tree one level at a time, each level listed left to right as its nodes' children always are; the "
           "zigzag is only in how each row is written: as listed on rows 0, 2, 4…, reversed on rows 1, 3, 5….",
     "ko": "트리를 한 층씩 읽으며 각 층은 언제나 자식 순서대로 왼쪽부터 나열합니다. 지그재그는 행을 적는 방법에만 있습니다. "
           "0, 2, 4…번 행은 나열한 그대로, 1, 3, 5…번 행은 뒤집어 적습니다."},
    views=[
        {"id": "tree", "type": "tree", "arity": 2, "title": {"en": "root", "ko": "root (트리)"},
         "empty": {"en": "empty tree", "ko": "빈 트리"}},
        {"id": "level", "type": "array",
         "title": {"en": "level, left to right (tag: place in the row)", "ko": "level (현재 층, 왼쪽부터; 태그: 행 안의 자리)"}},
        {"id": "result", "type": "output", "title": {"en": "rows", "ko": "rows (행 목록)"},
         "empty": {"en": "none yet", "ko": "아직 없음"}},
    ],
)



def solve(values, run):
    """Solution.zigzagRows with two frames per level. Returns the answer as the Driver prints it."""
    tree, root = build_tree(values)
    rows, level, done = [], [], []

    def frame(caption, nodes=None, cells=None, read=None, r_good=(), moves=None, path=False, **answer):
        if path:
            node_marks = {"path": [n["id"] for n in tree["nodes"]]}
        else:
            node_marks = {"dim": [i for i in done if i not in [n.id for n in level]], **(nodes or {})}
        # each cell tagged with its place in the row it is written into, so a reversed row reads off the tags
        tags = [] if read is None else [[i, f"[{len(level) - 1 - i if read else i}]"] for i in range(len(level))]
        run.frame(caption,
                  tree={"nodeMarks": node_marks, "shade": [] if path else [n.id for n in level]},
                  level={"values": [n.val for n in level], "marks": cells or {}, "tags": tags},
                  result={"values": [driver_list(r) for r in rows],
                          "marks": {"good": list(r_good)} if not path else {}},
                  moves=moves, **answer)

    if root is None:
        frame({"en": "The tree is empty, so it has no levels: the answer is [].",
               "ko": "트리가 비어 있어 층이 없으므로 답은 []입니다."}, answer="[]")
        return "[]"
    n = len(tree["nodes"])
    level = [root]
    frame({"en": f"A tree of {n} {plural(n, 'node', 'nodes')}. Level 0 is just the root {root.val}.",
           "ko": f"노드 {n}개짜리 트리입니다. 0층은 root {root.val}뿐입니다."},
          nodes={"good": [root.id]}, cells={"good": [0]}, moves=[move(at("tree", root.id), at("level", 0))])
    depth = 0
    while level:
        vals = [x.val for x in level]
        flip = len(rows) % 2 == 1
        row = vals[::-1] if flip else vals
        rows.append(row)
        listed, written = driver_list(vals), driver_list(row)
        if flip:
            why = {"en": f"Row {depth} is odd, so level {depth}, {listed}, is written reversed: {written}.",
                   "ko": f"{depth}번 행은 홀수 행이므로 {depth}층 {listed} 목록을 뒤집어 {written} 행으로 적습니다."}
        else:
            why = {"en": f"Row {depth} is even, so level {depth}, {listed}, is written as listed: {written}.",
                   "ko": f"{depth}번 행은 짝수 행이므로 {depth}층 {listed} 목록을 그대로 {written} 행으로 적습니다."}
        frame(why, cells={"lit": list(range(len(level)))}, read=flip, r_good=[len(rows) - 1],
              moves=[move(at("level", i), at("result", len(rows) - 1)) for i in range(len(level))])
        done.extend(x.id for x in level)
        kids = [c for x in level for c in (x.left, x.right) if c]
        depth += 1
        if not kids:
            level = []
            frame({"en": f"No node on level {depth - 1} has children, so the next level is empty and the walk stops.",
                   "ko": f"{depth - 1}층의 노드에 자식이 없으므로 다음 층이 비어 순회를 마칩니다."})
            break
        level = kids
        frame({"en": f"Level {depth} is their children, left to right: {', '.join(str(c.val) for c in kids)}.",
               "ko": f"{depth}층은 그 자식들을 왼쪽부터 나열한 {', '.join(str(c.val) for c in kids)}입니다."},
              nodes={"good": [c.id for c in kids]}, cells={"good": list(range(len(kids)))},
              moves=[move(at("tree", c.id), at("level", i)) for i, c in enumerate(kids)])
    printed = driver_list(rows)
    frame({"en": f"Every level gave one row, every other one reversed: {printed}.",
           "ko": f"모든 층이 한 행씩, 한 행 걸러 뒤집혀 들어갔습니다. 답은 {printed}입니다."},
          path=True, answer=printed)
    return printed


for number, sample in enumerate(sample_cases(SLUG), start=1):
    values = json.loads(sample["input"])
    run = sample_run(wt, number, sample, input=f"root = {driver_list(values)}", setup={"tree": level_order_tree(values)})
    solve(values, run)
wt.write(walkthrough_path(SLUG))
