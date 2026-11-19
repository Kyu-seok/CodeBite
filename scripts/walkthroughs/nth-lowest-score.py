#!/usr/bin/env python3.12
"""nth-lowest-score's Walkthrough: the reference solution (scripts/replay-solutions/nth-lowest-score.py), an in-order
walk of the BST with an explicit stack: push nodes going left until there is none, pop the lowest one waiting, count
it, then go to its right child. The k-th node popped is the answer. The tree is drawn as the description's Diagram
draws it, each popped node tagged with its place in the order; the stack stands beside it, each push moving in from
its node and each pop leaving to it. One frame per push and per pop, on each sample Test Case.

    CODEBITE_DB=<database> scripts/walkthroughs/nth-lowest-score.py

writes common/src/main/resources/walkthroughs/nth-lowest-score.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import build_tree, driver_list, josa, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, level_order_tree, move, stack  # noqa: E402

SLUG = "nth-lowest-score"

wt = Walkthrough(
    {"en": "Nth Lowest Score", "ko": "N번째 낮은 점수"},
    {"en": "An in-order walk visits a BST's scores from lowest to highest: keep the nodes still waiting on a stack, "
           "go left as far as possible, pop the lowest waiting node and count it, then go to its right child. The "
           "k-th node popped is the k-th lowest score.",
     "ko": "중위 순회는 BST의 점수를 낮은 것부터 차례로 방문합니다. 아직 기다리는 노드를 스택에 두고, 왼쪽으로 끝까지 "
           "내려간 뒤, 기다리는 가장 낮은 노드를 꺼내 세고 그 오른쪽 자식으로 갑니다. k번째로 꺼낸 노드가 k번째로 낮은 "
           "점수입니다."},
    views=[
        {"id": "tree", "type": "tree", "arity": 2,
         "title": {"en": "root (under each node: its place in order)", "ko": "root (노드 아래: 낮은 순서)"}},
        {"id": "waiting", "type": "stack", "title": {"en": "stack", "ko": "stack (스택)"},
         "empty": {"en": "empty", "ko": "비어 있음"}},
        {"id": "state", "type": "vars"},
    ],
)


def ordinal(n):
    return f"{n}{'th' if 10 <= n % 100 <= 20 else {1: 'st', 2: 'nd', 3: 'rd'}.get(n % 10, 'th')}"


def place(n):
    return {"en": ordinal(n), "ko": f"{n}번째"}


def solve(values, k, run):
    """Solution.nthLowestScore with a frame per push and per pop. Returns the answer as the Driver prints it."""
    tree, root = build_tree(values)
    tags, counted = {}, []
    waiting = []

    def frame(caption, nodes=None, shown=None, s_marks=None, moves=None, **answer):
        items = waiting if shown is None else shown
        run.frame(caption,
                  tree={"nodeMarks": {"dim": [i for i in counted if i not in (nodes or {}).get("path", [])],
                                      **(nodes or {})},
                        "shade": [n.id for n in items], "tags": [[i, t] for i, t in tags.items()]},
                  waiting={**stack(items, value=lambda n: n.val), "marks": s_marks or {}},
                  state={"items": [{"label": "k", "value": k}]}, moves=moves, **answer)

    frame({"en": f"Find the {ordinal(k)} lowest score. Start at the root {root.val} and go left as far as possible, "
                 f"keeping each node on the stack.",
           "ko": f"{k}번째로 낮은 점수를 찾습니다. root {root.val}부터 왼쪽으로 끝까지 내려가며 지나는 노드를 스택에 "
                 f"쌓습니다."})
    node, count = root, 0
    while waiting or node:
        while node:
            waiting.append(node)
            nxt = node.left
            then = ({"en": f" Go left to {nxt.val}.", "ko": f" 왼쪽의 {josa(nxt.val, '(으)로')} 갑니다."} if nxt else
                    {"en": f" It has no left child, so stop going left.",
                     "ko": f" 왼쪽 자식이 없으므로 더 내려가지 않습니다."})
            frame({"en": f"Push {node.val}: it waits until everything left of it is counted." + then["en"],
                   "ko": f"{josa(node.val, '을를')} 스택에 넣습니다. 왼쪽이 모두 세어질 때까지 기다립니다." + then["ko"]},
                  nodes={"lit": [node.id]}, s_marks={"good": [len(waiting) - 1]},
                  moves=[move(at("tree", node.id), at("waiting", len(waiting) - 1))])
            node = nxt
        shown = list(waiting)
        node = waiting.pop()
        count += 1
        k_left = k - count
        tags[node.id] = place(count)
        counted.append(node.id)
        moves = [move(at("waiting", len(shown) - 1), at("tree", node.id), value=f"#{count}")]
        if k_left == 0:
            frame({"en": f"Pop {node.val}: it is the {ordinal(count)} lowest score, and k = {k}.",
                   "ko": f"{josa(node.val, '을를')} 꺼냅니다. {count}번째로 낮은 점수이고 k = {k}입니다."},
                  nodes={"good": [node.id]}, shown=shown, s_marks={"lit": [len(shown) - 1]}, moves=moves)
            frame({"en": f"The {ordinal(k)} node the in-order walk counts is {node.val}, so the {ordinal(k)} lowest "
                         f"score is {node.val}.",
                   "ko": f"중위 순회가 {k}번째로 센 노드가 {node.val}이므로 {k}번째로 낮은 점수는 {node.val}입니다."},
                  nodes={"path": [node.id]}, answer=str(node.val))
            return str(node.val)
        right = node.right
        then = ({"en": f" Next, its right child {right.val}.", "ko": f" 다음은 오른쪽 자식 {right.val}입니다."} if right else
                {"en": " It has no right child, so the next node waiting comes off the stack.",
                 "ko": " 오른쪽 자식이 없으므로 다음은 스택에서 기다리는 노드입니다."})
        frame({"en": f"Pop {node.val}: nothing lower is left, so it is the {ordinal(count)} lowest." + then["en"],
               "ko": f"{josa(node.val, '을를')} 꺼냅니다. 더 낮은 점수가 남지 않았으므로 {count}번째로 낮은 점수입니다."
                     + then["ko"]},
              nodes={"good": [node.id]}, shown=shown, s_marks={"lit": [len(shown) - 1]}, moves=moves)
        node = right
    raise ValueError("k is larger than the tree")


for number, sample in enumerate(sample_cases(SLUG), start=1):
    line, k_line = sample["input"].split("\n")
    values, k = json.loads(line), int(k_line)
    run = sample_run(wt, number, sample, input=f"root = {driver_list(values)}, k = {k}",
                     setup={"tree": level_order_tree(values)})
    solve(values, k, run)
wt.write(walkthrough_path(SLUG))
