#!/usr/bin/env python3.12
"""right-side-skill-view's Walkthrough: the reference solution (scripts/replay-solutions/right-side-skill-view.py),
breadth first one level at a time: the last node of each level, the one seen from the right, goes into the answer,
then the level is replaced by its nodes' children, left before right. The tree is drawn as the description's Diagram
draws it, the current level shaded; the level list is an array whose values move in from their nodes, and each seen
value moves from its node into the answer. Two frames per level, on each sample Test Case.

    CODEBITE_DB=<database> scripts/walkthroughs/right-side-skill-view.py

writes common/src/main/resources/walkthroughs/right-side-skill-view.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import build_tree, driver_list, josa, plural, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, level_order_tree, move  # noqa: E402

SLUG = "right-side-skill-view"

wt = Walkthrough(
    {"en": "Right-Side Skill View", "ko": "오른쪽에서 본 스킬 트리"},
    {"en": "Read the tree one level at a time, each level listed left to right: its last node is the one seen from "
           "the right, whichever branch it hangs on. Then replace the level with its nodes' children, in order.",
     "ko": "트리를 한 층씩, 각 층을 왼쪽에서 오른쪽 순서로 나열해 읽습니다. 그 마지막 노드가 어느 가지에 달려 있든 "
           "오른쪽에서 보이는 노드입니다. 그다음 층을 그 노드들의 자식으로 순서대로 바꿉니다."},
    views=[
        {"id": "tree", "type": "tree", "arity": 2, "title": {"en": "root", "ko": "root (트리)"},
         "empty": {"en": "empty tree", "ko": "빈 트리"}},
        {"id": "level", "type": "array", "title": {"en": "level, left to right", "ko": "level (현재 층, 왼쪽부터)"}},
        {"id": "result", "type": "output", "title": {"en": "seen from the right", "ko": "오른쪽에서 보이는 값"},
         "empty": {"en": "none yet", "ko": "아직 없음"}},
    ],
)


def solve(values, run):
    """Solution.rightSideView with two frames per level. Returns the answer as the Driver prints it."""
    tree, root = build_tree(values)
    view, level, seen, done = [], [], [], []

    def frame(caption, nodes=None, cells=None, r_good=(), moves=None, path=False, **answer):
        if path:
            node_marks = {"path": list(seen), "dim": [n["id"] for n in tree["nodes"] if n["id"] not in seen]}
        else:
            node_marks = {"dim": [i for i in done if i not in [n.id for n in level]], **(nodes or {})}
        run.frame(caption,
                  tree={"nodeMarks": node_marks, "shade": [] if path else [n.id for n in level]},
                  level={"values": [n.val for n in level], "marks": cells or {}},
                  result={"values": [str(v) for v in view], "marks": {"good": list(r_good)}},
                  moves=moves, **answer)

    if root is None:
        frame({"en": "The tree is empty, so nothing is seen: the answer is [].",
               "ko": "트리가 비어 있어 보이는 노드가 없으므로 답은 []입니다."}, answer="[]")
        return "[]"
    n = len(tree["nodes"])
    level = [root]
    frame({"en": f"A tree of {n} {plural(n, 'node', 'nodes')}. Level 0 is just the root {root.val}.",
           "ko": f"노드 {n}개짜리 트리입니다. 0층은 root {root.val}뿐입니다."},
          nodes={"good": [root.id]}, cells={"good": [0]}, moves=[move(at("tree", root.id), at("level", 0))])
    depth = 0
    while level:
        last = level[-1]
        view.append(last.val)
        seen.append(last.id)
        if len(level) == 1:
            why = {"en": f"Level {depth} holds only {last.val}, so it is seen from the right.",
                   "ko": f"{depth}층에는 {last.val}만 있으므로 오른쪽에서 보입니다."}
        else:
            hidden = ", ".join(str(x.val) for x in level[:-1])
            why = {"en": f"Level {depth} is {', '.join(str(x.val) for x in level)}: the last, {last.val}, hides "
                         f"{hidden} from the right.",
                   "ko": f"{depth}층은 {', '.join(str(x.val) for x in level)}입니다. 마지막 {josa(last.val, '이가')} "
                         f"오른쪽에서 {hidden} 값을 가립니다."}
        frame(why, nodes={"lit": [last.id]}, cells={"lit": [len(level) - 1]}, r_good=[len(view) - 1],
              moves=[move(at("level", len(level) - 1), at("result", len(view) - 1))])
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
    printed = driver_list(view)
    frame({"en": f"Every level gave its last node: seen from the right, the tree shows {printed}.",
           "ko": f"모든 층에서 마지막 노드를 골랐습니다. 오른쪽에서 보면 {printed}입니다."},
          r_good=(), path=True, answer=printed)
    return printed


for number, sample in enumerate(sample_cases(SLUG), start=1):
    values = json.loads(sample["input"])
    run = sample_run(wt, number, sample, input=f"root = {driver_list(values)}", setup={"tree": level_order_tree(values)})
    solve(values, run)
wt.write(walkthrough_path(SLUG))
