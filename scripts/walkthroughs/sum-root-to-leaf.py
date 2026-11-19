#!/usr/bin/env python3.12
"""sum-root-to-leaf's Walkthrough: the reference solution (scripts/replay-solutions/sum-root-to-leaf.py), a
depth-first recursion, left before right, whose call carries the number spelled from the root down to its node (the
parent's number × 10 + its digit); a leaf adds its number to the total. The recursion walks the input tree, so it has
no drawing of its own (#359): the current call's node is lit, the open calls are shaded, and each node is tagged with
its number, which moves down from its parent. The total is an output of one chip each leaf's number moves into. One
frame per call, on each sample Test Case.

    CODEBITE_DB=<database> scripts/walkthroughs/sum-root-to-leaf.py

writes common/src/main/resources/walkthroughs/sum-root-to-leaf.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import build_tree, driver_list, josa, plural, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, level_order_tree, move  # noqa: E402

SLUG = "sum-root-to-leaf"

wt = Walkthrough(
    {"en": "Sum Root to Leaf Numbers", "ko": "루트에서 리프까지의 수 더하기"},
    {"en": "Going down one level appends a digit, which is the number so far × 10 + the digit: carry that number into "
           "each call, and every leaf adds the number its path spells to the total.",
     "ko": "한 층 내려가면 숫자 하나가 뒤에 붙는데, 이는 지금까지의 수 × 10 + 그 숫자입니다. 그 수를 각 호출에 넘기고, 리프마다 "
           "경로가 만든 수를 합계에 더합니다."},
    views=[
        {"id": "tree", "type": "tree", "arity": 2,
         "title": {"en": "root (under each node: the number spelled down to it)",
                   "ko": "root (노드 아래: 내려오며 만든 수)"}},
        {"id": "result", "type": "output", "title": {"en": "total", "ko": "total (합계)"}},
    ],
)


def solve(values, run):
    """Solution.sumNumbers with a frame per call. Returns the answer as the Driver prints it."""
    tree, root = build_tree(values)
    tags, stack, done, leaves = {}, [], [], []
    total = 0

    def frame(caption, lit=None, good=None, moves=None, r_good=False, final=False, **answer):
        if final:
            marks, shade = {"path": list(leaves), "dim": [n["id"] for n in tree["nodes"] if n["id"] not in leaves]}, []
        else:
            marks = {"dim": [i for i in done if i not in stack]}
            for name, x in (("lit", lit), ("good", good)):
                if x is not None:
                    marks[name] = [x]
            shade = list(stack)
        run.frame(caption, tree={"nodeMarks": marks, "shade": shade, "tags": [[i, t] for i, t in tags.items()]},
                  result={"values": [str(total)], "marks": {"good": [0]} if r_good else {}}, moves=moves, **answer)

    n = len(tree["nodes"])
    frame({"en": f"A tree of {n} {plural(n, 'digit', 'digits')}. Walk down from the root {root.val}, left before right, "
                 f"carrying the number spelled so far; the total starts at 0.",
           "ko": f"숫자 {n}개짜리 트리입니다. root {root.val}부터 왼쪽 먼저 내려가며 지금까지 만든 수를 넘기고, 합계는 "
                 f"0에서 시작합니다."})

    def walk(node, number, parent=None):
        nonlocal total
        stack.append(node.id)
        before = number
        number = number * 10 + node.val
        tags[node.id] = str(number)
        came = [move(at("tree", parent.id), at("tree", node.id), value=f"{before}×10+{node.val}")] if parent else []
        spelled = (f"{before} × 10 + {node.val} = {number}" if parent else f"{number}")
        if not node.left and not node.right:
            was = total
            total += number
            leaves.append(node.id)
            frame({"en": f"{node.val} is a leaf: its path spells {spelled}, so the total becomes {was} + {number} = "
                         f"{total}.",
                   "ko": f"{node.val} 노드는 리프이고 경로가 만든 수는 {spelled}입니다. 합계는 {was} + {number} = "
                         f"{josa(total, '이가')} 됩니다."},
                  good=node.id, r_good=True,
                  moves=came + [move(at("tree", node.id), at("result", 0), value=f"+{number}")])
        else:
            first = node.left or node.right
            frame({"en": f"Down to {node.val}: the number so far is {spelled}. It has children, so go on to "
                         f"{first.val}.",
                   "ko": f"{node.val} 노드까지 내려와 지금까지의 수는 {spelled}입니다. 자식이 있으므로 {first.val} "
                         f"노드로 내려갑니다."},
                  lit=node.id, moves=came or None)
        for child in (node.left, node.right):
            if child:
                walk(child, number, node)
        stack.pop()
        done.append(node.id)

    walk(root, 0)
    nums = [int(tags[i]) for i in leaves]
    parts = " + ".join(str(x) for x in nums)
    frame({"en": f"Every leaf is added: {parts} = {total}." if len(nums) > 1 else
                 f"The only leaf spells {total}, so the total is {total}.",
           "ko": f"모든 리프를 더했습니다. {parts} = {total}입니다." if len(nums) > 1 else
                 f"리프가 하나뿐이고 {josa(total, '을를')} 만들므로 합계는 {total}입니다."},
          final=True, answer=str(total))
    return str(total)


for number, sample in enumerate(sample_cases(SLUG), start=1):
    values = json.loads(sample["input"])
    run = sample_run(wt, number, sample, input=f"root = {driver_list(values)}", setup={"tree": level_order_tree(values)})
    solve(values, run)
wt.write(walkthrough_path(SLUG))
