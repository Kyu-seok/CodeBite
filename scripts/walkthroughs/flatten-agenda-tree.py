#!/usr/bin/env python3.12
"""flatten-agenda-tree's Walkthrough: the reference solution (scripts/replay-solutions/flatten-agenda-tree.py) walks
down the right pointers from the root; a node with a left child finds the last node of its left subtree in preorder
(walking right from the left child), hangs its own right subtree there, and moves its left subtree over to its right.
The tree is drawn as it stands after each step, so it reshapes as subtrees are moved (the drawing lays out each frame's
tree on its own); `node` and `tail` are tags on their nodes. A rewiring is one frame: the solution's three pointer
writes (tail.right, then node.right and node.left together) land between two frames, since between the first and the
others a subtree briefly hangs from two parents, which a tree can't draw. One frame per node reached, per step of the
tail walk and per rewiring, on each sample Test Case.

    CODEBITE_DB=<database> scripts/walkthroughs/flatten-agenda-tree.py

writes common/src/main/resources/walkthroughs/flatten-agenda-tree.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import build_tree, driver_list, plural, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move  # noqa: E402

SLUG = "flatten-agenda-tree"

wt = Walkthrough(
    {"en": "Flatten Agenda Tree", "ko": "회의 안건 트리 펼치기"},
    {"en": "In preorder a node's right subtree comes right after the last node of its left subtree, found by walking "
           "right from the left child: hang the right subtree there, move the left subtree over to the right, and step "
           "right to do the same at the next node.",
     "ko": "전위 순회에서 노드의 오른쪽 서브트리는 왼쪽 서브트리의 마지막 노드 바로 다음에 옵니다. 그 노드는 왼쪽 자식에서 "
           "오른쪽으로만 내려가면 나옵니다. 오른쪽 서브트리를 그 아래에 달고, 왼쪽 서브트리를 오른쪽으로 옮긴 뒤, 오른쪽으로 "
           "한 칸 내려가 다음 노드에서 같은 일을 합니다."},
    views=[{"id": "tree", "type": "tree", "arity": 2, "title": {"en": "root", "ko": "root (트리)"},
            "empty": {"en": "empty tree", "ko": "빈 트리"}}],
)

NODE = {"en": "node", "ko": "node (현재)"}
TAIL = {"en": "tail", "ko": "tail (끝)"}


def solve(values, run):
    """Solution.flattenAgenda with a frame per node reached, per step of the tail walk and per rewiring.
    Returns the answer as the Driver prints it."""
    tree, root = build_tree(values)
    by_id = {}

    def collect(x):
        if x:
            by_id[x.id] = x
            collect(x.left)
            collect(x.right)
    collect(root)
    placed = []  # nodes whose left is already empty, behind node on the chain

    def state():
        nodes = [{"id": i, "value": x.val} for i, x in sorted(by_id.items())]
        edges = []
        for i, x in sorted(by_id.items()):
            for slot, kid in enumerate((x.left, x.right)):
                if kid:
                    edges.append({"from": i, "to": kid.id, "slot": slot})
        return {"nodes": nodes, "edges": edges}

    def frame(caption, node=None, tail=None, lit=None, good=None, moves=None, final=False, **answer):
        if final:
            marks, tags = {"path": list(by_id)}, []
        else:
            marks = {"dim": [i for i in placed if i != node]}
            if lit:
                marks["lit"] = lit
            if good:
                marks["good"] = good
            tags = ([[node.id, NODE]] if node else []) + ([[tail.id, TAIL]] if tail and tail is not node else [])
        run.frame(caption, tree={**state(), "nodeMarks": marks, "tags": tags}, moves=moves, **answer)

    if root is None:
        frame({"en": "The tree is empty, so there is nothing to flatten: the chain is [].",
               "ko": "트리가 비어 있어 펼칠 것이 없으므로 답은 []입니다."}, answer="[]")
        return "[]"
    n = len(by_id)
    frame({"en": f"An agenda tree of {n} {plural(n, 'item', 'items')}. Start node at the root {root.val} and walk down "
                 f"the right pointers, fixing each node's left side.",
           "ko": f"안건 {n}개짜리 트리입니다. node를 root {root.val}에 두고 오른쪽 포인터를 따라 내려가며 각 노드의 "
                 f"왼쪽을 정리합니다."},
          node=root, lit=[root.id])
    node = root
    while node:
        if node.left:
            tail = node.left
            frame({"en": f"{node.val} has a left child, so its right side must come after its whole left subtree. "
                         f"Find that subtree's last node: start tail at {tail.val}.",
                   "ko": f"{node.val} 노드에 왼쪽 자식이 있으므로 오른쪽은 왼쪽 서브트리 전체 뒤에 와야 합니다. 그 서브트리의 "
                         f"마지막 노드를 찾기 위해 tail을 {tail.val} 노드에서 시작합니다."},
                  node=node, tail=tail, lit=[tail.id])
            while tail.right:
                tail = tail.right
                frame({"en": f"tail has a right child, so step right to {tail.val}.",
                       "ko": f"tail에 오른쪽 자식이 있으므로 오른쪽 {tail.val} 노드로 내려갑니다."},
                      node=node, tail=tail, lit=[tail.id])
            moved, kid = node.right, node.left
            tail.right = node.right
            node.right, node.left = node.left, None
            if moved:
                hang = {"en": f"tail {tail.val} has no right child, so it is the left subtree's last node: hang "
                              f"{node.val}'s right subtree, {moved.val}, under it, and move the left subtree, "
                              f"{kid.val}, to {node.val}'s right.",
                        "ko": f"tail {tail.val} 노드에는 오른쪽 자식이 없으므로 왼쪽 서브트리의 마지막 노드입니다. "
                              f"{node.val}의 오른쪽 서브트리 {moved.val} 노드를 그 아래에 달고, 왼쪽 서브트리 {kid.val} "
                              f"노드를 {node.val}의 오른쪽으로 옮깁니다."}
                moves = [move(at("tree", node.id), at("tree", moved.id), value=str(moved.val)),
                         move(at("tree", node.id), at("tree", kid.id), value=str(kid.val))]
                good = [moved.id, kid.id]
            else:
                hang = {"en": f"tail {tail.val} is the left subtree's last node, and {node.val} has no right subtree to "
                              f"hang under it: just move the left subtree, {kid.val}, to {node.val}'s right.",
                        "ko": f"tail {tail.val} 노드가 왼쪽 서브트리의 마지막 노드인데 {node.val}에는 달 오른쪽 "
                              f"서브트리가 없습니다. 왼쪽 서브트리 {kid.val} 노드만 {node.val}의 오른쪽으로 옮깁니다."}
                moves = [move(at("tree", node.id), at("tree", kid.id), value=str(kid.val))]
                good = [kid.id]
            frame(hang, node=node, tail=tail, lit=[node.id], good=good, moves=moves)
        nxt = node.right
        placed.append(node.id)
        if nxt:
            lead = ({"en": f"{node.val} has no left child now, so it is in place. Step right to {nxt.val}.",
                     "ko": f"이제 {node.val} 노드에는 왼쪽 자식이 없으므로 제자리입니다. 오른쪽 {nxt.val} 노드로 "
                           f"내려갑니다."})
            node = nxt
            frame(lead, node=node, lit=[node.id])
        else:
            node = None

    chain, x = [], root
    while x:
        chain.append(x.val)
        x = x.right
    printed = driver_list(chain)
    frame({"en": f"The last node has no right child, so the walk ends. Following right from the root gives the "
                 f"preorder chain {printed}.",
           "ko": f"마지막 노드에 오른쪽 자식이 없으므로 순회가 끝납니다. root부터 오른쪽을 따라가면 전위 순회 체인 "
                 f"{printed}입니다."},
          final=True, answer=printed)
    return printed


for number, sample in enumerate(sample_cases(SLUG), start=1):
    values = json.loads(sample["input"])
    run = sample_run(wt, number, sample, input=f"root = {driver_list(values)}")
    solve(values, run)
wt.write(walkthrough_path(SLUG))
