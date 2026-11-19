#!/usr/bin/env python3.12
"""lca-bst's Walkthrough: the reference solution (scripts/replay-solutions/lca-bst.py) walks down from the root of
the BST: while both p and q are below the node it goes left, while both are above it goes right, and the first node
where they split (or that is one of them) is their lowest common ancestor. The tree is drawn as the description's
Diagram draws it, p and q tagged; the node compared is lit and the way down shaded. One frame per node compared, on
each sample Test Case.

    CODEBITE_DB=<database> scripts/walkthroughs/lca-bst.py

writes common/src/main/resources/walkthroughs/lca-bst.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import build_tree, driver_list, josa, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, level_order_tree  # noqa: E402

SLUG = "lca-bst"

wt = Walkthrough(
    {"en": "Lowest Common Ancestor of a BST", "ko": "이진 검색 트리의 최소 공통 조상"},
    {"en": "In a BST everything left of a node is smaller and everything right is larger: walk down from the root, "
           "going left while p and q are both smaller and right while both are larger. The first node that sends "
           "them different ways, or is one of them, is their lowest common ancestor.",
     "ko": "BST에서는 노드의 왼쪽이 모두 작고 오른쪽이 모두 큽니다. root에서 내려가며 p와 q가 둘 다 작으면 왼쪽, 둘 다 "
           "크면 오른쪽으로 갑니다. 두 값이 처음으로 서로 다른 쪽으로 갈리는 노드, 또는 둘 중 하나인 노드가 최소 공통 "
           "조상입니다."},
    views=[{"id": "tree", "type": "tree", "arity": 2, "title": {"en": "root", "ko": "root (트리)"}}],
)


def solve(values, p, q, run):
    """Solution.lowestCommonAncestor with a frame per node compared. Returns the answer as the Driver prints it."""
    tree, root = build_tree(values)
    ids = {n["value"]: n["id"] for n in tree["nodes"]}
    tags = [[ids[p], "p"], [ids[q], "q"]]
    low, high = sorted((p, q))
    walked = []

    def frame(caption, marks, edge=None, shade=None, edges=None, **answer):
        run.frame(caption, tree={"nodeMarks": marks, "shade": list(walked) if shade is None else shade,
                                 "edgeMarks": edges or ({"lit": [edge]} if edge else {}), "tags": tags}, **answer)

    frame({"en": f"p = {p} and q = {q}, so low = {low} and high = {high}. Start at the root {root.val}.",
           "ko": f"p = {p}, q = {q}이므로 low = {low}, high = {high}입니다. root {root.val}에서 시작합니다."},
          {"lit": [ids[p], ids[q]]})
    node, parent = root, None
    while node:
        walked.append(node.id)
        edge = [parent.id, node.id] if parent else None
        if high < node.val:
            frame({"en": f"{low} and {high} are both smaller than {node.val}, so both are in its left subtree: go left.",
                   "ko": f"{low}, {high} 모두 {node.val}보다 작으므로 둘 다 왼쪽 서브트리에 있습니다. 왼쪽으로 갑니다."},
                  {"lit": [node.id]}, edge=edge)
            parent, node = node, node.left
        elif low > node.val:
            frame({"en": f"{low} and {high} are both larger than {node.val}, so both are in its right subtree: go right.",
                   "ko": f"{low}, {high} 모두 {node.val}보다 크므로 둘 다 오른쪽 서브트리에 있습니다. 오른쪽으로 갑니다."},
                  {"lit": [node.id]}, edge=edge)
            parent, node = node, node.right
        else:
            if node.val in (p, q):
                why = {"en": f"{node.val} is {'p' if node.val == p else 'q'} itself, and the other is below it: a node "
                             f"counts as its own descendant.",
                       "ko": f"{josa(node.val, '은는')} {'p' if node.val == p else 'q'} 자신이고 다른 하나는 그 아래에 "
                             f"있습니다. 노드는 자기 자신의 자손으로 칩니다."}
            else:
                why = {"en": f"{low} < {node.val} < {high}: p and q split here, one on each side.",
                       "ko": f"{low} < {node.val} < {high}이므로 p와 q가 여기서 양쪽으로 갈립니다."}
            others = [ids[v] for v in (p, q) if v != node.val]
            frame(why, {"lit": [node.id] + others}, edge=edge)
            path = list(walked)
            frame({"en": f"So {node.val} is the deepest node with both {p} and {q} at or below it: the answer is "
                         f"{node.val}.",
                   "ko": f"따라서 {p}, {q} 둘 다를 자기 자신 또는 아래에 둔 가장 깊은 노드는 {node.val}입니다. 답은 "
                         f"{node.val}입니다."},
                  {"path": [node.id], "lit": others}, shade=path,
                  edges={"path": [[a, b] for a, b in zip(path, path[1:])]}, answer=str(node.val))
            return str(node.val)
    raise ValueError("p or q is not in the tree")


for number, sample in enumerate(sample_cases(SLUG), start=1):
    line, p_line, q_line = sample["input"].split("\n")
    values, p, q = json.loads(line), int(p_line), int(q_line)
    run = sample_run(wt, number, sample, input=f"root = {driver_list(values)}, p = {p}, q = {q}",
                     setup={"tree": level_order_tree(values)})
    solve(values, p, q, run)
wt.write(walkthrough_path(SLUG))
