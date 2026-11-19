#!/usr/bin/env python3.12
"""balanced-hamster-tree's Walkthrough: the reference solution (scripts/replay-solutions/balanced-hamster-tree.py), a
recursion that returns a subtree's height (an empty one's is 0), or -1 as soon as some node in it has two sides whose
heights differ by more than one; a -1 from the left side is returned at once, without asking the right. The recursion
walks the input tree, so it has no drawing of its own (#359): the current call's node is lit, the calls still open are
shaded, and each node is tagged with what its call returns (a height, or ✗), which moves up into its parent. One frame
per call entering a node with children and one per call returning, on each sample Test Case.

    CODEBITE_DB=<database> scripts/walkthroughs/balanced-hamster-tree.py

writes common/src/main/resources/walkthroughs/balanced-hamster-tree.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import build_tree, driver_list, josa, plural, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, level_order_tree, move  # noqa: E402

SLUG = "balanced-hamster-tree"

wt = Walkthrough(
    {"en": "Balanced Hamster Tree", "ko": "햄스터 가계도 균형 검사"},
    {"en": "Each call returns its subtree's height, 1 + the taller side, after checking that its two sides differ by at "
           "most 1; once one node fails, every call above it returns the failure (✗) without looking further.",
     "ko": "각 호출은 두 쪽 높이 차가 1 이하인지 확인한 뒤 서브트리의 높이(1 + 더 높은 쪽)를 돌려줍니다. 한 노드에서 실패하면 "
           "그 위의 호출은 더 보지 않고 실패(✗)를 그대로 돌려줍니다."},
    views=[{"id": "tree", "type": "tree", "arity": 2,
            "title": {"en": "root (under each node: the height it returns)",
                      "ko": "root (노드 아래: 돌려주는 높이)"},
            "empty": {"en": "empty tree", "ko": "빈 트리"}}],
)


def show(h):
    return "✗" if h < 0 else str(h)


def solve(values, run):
    """Solution.isBalanced with a frame per call entering a node with children and per call returning.
    Returns the answer as the Driver prints it."""
    tree, root = build_tree(values)
    tags, stack, done, h_of = {}, [], [], {}
    failed = []  # the node that broke the balance, then each call that passed the failure up

    def frame(caption, lit=None, good=None, bad=None, moves=None, final=None, **answer):
        if final == "true":
            marks, shade = {"path": [n["id"] for n in tree["nodes"]]}, []
        elif final == "false":
            marks, shade = {"bad": list(failed), "dim": [n["id"] for n in tree["nodes"] if n["id"] not in failed]}, []
        else:
            marks = {"dim": [i for i in done if i not in stack and i != good and i != bad]}
            for name, x in (("lit", lit), ("good", good), ("bad", bad)):
                if x is not None:
                    marks[name] = [x]
            shade = list(stack)
        run.frame(caption, tree={"nodeMarks": marks, "shade": shade, "tags": [[i, t] for i, t in tags.items()]},
                  moves=moves, **answer)

    if root is None:
        frame({"en": "The tree is empty, so it is balanced.", "ko": "트리가 비어 있으므로 균형 잡혀 있습니다."},
              answer="true")
        return "true"
    n = len(tree["nodes"])
    frame({"en": f"A family tree of {n} {plural(n, 'hamster', 'hamsters')} with root {root.val}. Ask the root for its "
                 f"height: it must ask its children first.",
           "ko": f"root가 {root.val}인 햄스터 {n}마리의 가계도입니다. root에게 높이를 묻는데, root는 먼저 자식들에게 "
                 f"물어야 합니다."})

    def tag(h):
        if h < 0:
            return "✗"
        return {"en": f"h {h}", "ko": f"높이 {h}"}

    def side_en(kid):
        return "0 (none)" if kid is None else show(h_of[kid.id])

    def side_ko(kid):
        return "0(없음)" if kid is None else show(h_of[kid.id])

    def finish(node, h, caption, kids):
        h_of[node.id] = h
        tags[node.id] = tag(h)
        if h < 0:
            failed.append(node.id)
        frame(caption, good=node.id if h >= 0 else None, bad=node.id if h < 0 else None,
              moves=[move(at("tree", k.id), at("tree", node.id), value=show(h_of[k.id])) for k in kids] or None)
        stack.pop()
        done.append(node.id)
        return h

    def height(node):
        if node is None:
            return 0
        stack.append(node.id)
        if node.left is None and node.right is None:
            return finish(node, 1, {"en": f"{node.val} is a leaf: both sides are empty (0), so it returns 1 + 0 = 1.",
                                    "ko": f"{josa(node.val, '은는')} 리프입니다. 양쪽이 비어 있으므로(0) 1 + 0 = 1을 "
                                          f"돌려줍니다."}, [])
        if node.left:
            ask = {"en": f"{node.val} has children, so it asks its left child {node.left.val} first.",
                   "ko": f"{josa(node.val, '은는')} 자식이 있으므로 먼저 왼쪽 자식 {node.left.val}에게 묻습니다."}
        else:
            ask = {"en": f"{node.val}'s left side is empty (height 0), so it asks its right child {node.right.val}.",
                   "ko": f"{node.val}의 왼쪽은 비어 있으므로(높이 0) 오른쪽 자식 {node.right.val}에게 묻습니다."}
        frame(ask, lit=node.id)
        left = height(node.left)
        if left < 0:
            return finish(node, -1, {"en": f"{node.val}'s left side returned ✗: some node below is unbalanced, so "
                                           f"{node.val} returns ✗ too without asking its right side.",
                                     "ko": f"{node.val}의 왼쪽이 ✗ 표시를 돌려줬습니다. 아래 어딘가가 균형이 깨졌으므로 "
                                           f"오른쪽은 묻지 않고 ✗ 표시를 그대로 돌려줍니다."}, [node.left])
        right = height(node.right)
        kids = [k for k in (node.left, node.right) if k]
        if right < 0:
            return finish(node, -1, {"en": f"{node.val}'s right side returned ✗, so {node.val} returns ✗ too.",
                                     "ko": f"{node.val}의 오른쪽이 ✗ 표시를 돌려줬으므로 {node.val}도 ✗ 표시를 "
                                           f"돌려줍니다."}, kids)
        heights = {"en": f"{node.val}'s sides have heights {side_en(node.left)} and {side_en(node.right)}",
                   "ko": f"{node.val}의 두 쪽 높이는 {side_ko(node.left)}, {side_ko(node.right)}"}
        if abs(left - right) > 1:
            return finish(node, -1, {"en": heights["en"] + f": they differ by {abs(left - right)}, more than 1, so "
                                                           f"{node.val} is unbalanced and returns ✗.",
                                     "ko": heights["ko"] + f"입니다. 차이가 {josa(abs(left - right), '(으)로')} 1보다 커서 "
                                                           f"균형이 깨졌으므로 ✗ 표시를 돌려줍니다."}, kids)
        h = 1 + max(left, right)
        return finish(node, h, {"en": heights["en"] + f", at most 1 apart: it returns 1 + {max(left, right)} = {h}.",
                                "ko": heights["ko"] + f"입니다. 차이가 1 이하이므로 1 + {max(left, right)} = "
                                                      f"{josa(h, '을를')} 돌려줍니다."}, kids)

    answer = height(root) >= 0
    if answer:
        frame({"en": f"The root returns height {h_of[root.id]}, not ✗: every node's sides differ by at most 1, so the "
                     f"tree is balanced: true.",
               "ko": f"root가 ✗ 표시가 아닌 높이 {josa(h_of[root.id], '을를')} 돌려줍니다. 모든 노드의 두 쪽 높이 차가 "
                     f"1 이하이므로 균형 잡혀 있어 답은 true입니다."}, final="true", answer="true")
        return "true"
    first = next(x["value"] for x in tree["nodes"] if x["id"] == failed[0])
    frame({"en": f"The root returns ✗: {first}'s sides differ by more than 1, so the tree is not balanced: false.",
           "ko": f"root가 ✗ 표시를 돌려줍니다. {first}의 두 쪽 높이 차가 1보다 크므로 균형이 깨져 답은 false입니다."},
          final="false", answer="false")
    return "false"


for number, sample in enumerate(sample_cases(SLUG), start=1):
    values = json.loads(sample["input"])
    run = sample_run(wt, number, sample, input=f"root = {driver_list(values)}", setup={"tree": level_order_tree(values)})
    solve(values, run)
wt.write(walkthrough_path(SLUG))
