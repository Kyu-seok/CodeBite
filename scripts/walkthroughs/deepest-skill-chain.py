#!/usr/bin/env python3.12
"""deepest-skill-chain's Walkthrough: the reference solution (scripts/replay-solutions/deepest-skill-chain.py), a
recursion where a tree's depth is one more than the deeper of its two subtrees' depths, an empty tree's being 0.
The recursion walks the input tree, so it has no drawing of its own (#359): the current call's node is lit, the calls
still open are shaded, and each node is tagged with the depth its call returns, which moves up into its parent. One
frame per call entering a node with children and one per call returning, on each sample Test Case.

    CODEBITE_DB=<database> scripts/walkthroughs/deepest-skill-chain.py

writes common/src/main/resources/walkthroughs/deepest-skill-chain.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import build_tree, driver_list, josa, plural, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, level_order_tree, move  # noqa: E402

SLUG = "deepest-skill-chain"

wt = Walkthrough(
    {"en": "Deepest Skill Chain", "ko": "가장 깊은 스킬 체인"},
    {"en": "A tree's depth is its root plus the deeper of its two subtrees, and an empty subtree's depth is 0: ask each "
           "child for its depth, then hand 1 + the larger one up to the parent.",
     "ko": "트리의 깊이는 루트 하나에 두 서브트리 중 더 깊은 쪽의 깊이를 더한 값이고, 빈 서브트리의 깊이는 0입니다. "
           "각 자식에게 깊이를 물은 뒤 1 + 더 큰 값을 부모에게 돌려줍니다."},
    views=[{"id": "tree", "type": "tree", "arity": 2,
            "title": {"en": "root (under each node: the depth it returns)",
                      "ko": "root (노드 아래: 돌려주는 깊이)"},
            "empty": {"en": "empty tree", "ko": "빈 트리"}}],
)


def tag(d):
    return {"en": f"depth {d}", "ko": f"깊이 {d}"}


def solve(values, run):
    """Solution.maxSkillDepth with a frame per call entering a node with children and per call returning.
    Returns the answer as the Driver prints it."""
    tree, root = build_tree(values)
    tags, stack, done, depth_of = {}, [], [], {}

    def frame(caption, lit=None, good=None, moves=None, path=None, **answer):
        if path is not None:
            marks, shade = {"path": [n.id for n in path], "dim": [i for i in done if i not in [n.id for n in path]]}, []
            edges = {"path": [[a.id, b.id] for a, b in zip(path, path[1:])]}
        else:
            marks = {"dim": [i for i in done if i not in stack and i != good]}
            if lit is not None:
                marks["lit"] = [lit]
            if good is not None:
                marks["good"] = [good]
            shade, edges = list(stack), {}
        run.frame(caption, tree={"nodeMarks": marks, "shade": shade, "edgeMarks": edges,
                                 "tags": [[i, t] for i, t in tags.items()]}, moves=moves, **answer)

    if root is None:
        frame({"en": "The tree is empty, so its depth is 0.", "ko": "트리가 비어 있으므로 깊이는 0입니다."}, answer="0")
        return "0"
    n = len(tree["nodes"])
    frame({"en": f"A skill tree of {n} {plural(n, 'node', 'nodes')} with root {root.val}. Ask the root for its depth: "
                 f"it must ask its children first.",
           "ko": f"root가 {root.val}인 노드 {n}개짜리 스킬 트리입니다. root에게 깊이를 묻는데, root는 먼저 자식들에게 "
                 f"물어야 합니다."})

    def side(kid, ko=False):
        """A child's depth as a caption reads it: an empty side is 0."""
        if kid is None:
            return "0(자식 없음)" if ko else "0 (no child)"
        return str(depth_of[kid.id])

    def depth(node):
        if node is None:
            return 0
        stack.append(node.id)
        leaf = node.left is None and node.right is None
        if not leaf:
            if node.left:
                ask = {"en": f"{node.val} has children, so it asks its left child {node.left.val} first.",
                       "ko": f"{josa(node.val, '은는')} 자식이 있으므로 먼저 왼쪽 자식 {node.left.val}에게 묻습니다."}
            else:
                ask = {"en": f"{node.val}'s left side is empty (depth 0), so it asks its right child {node.right.val}.",
                       "ko": f"{node.val}의 왼쪽은 비어 있으므로(깊이 0) 오른쪽 자식 {node.right.val}에게 묻습니다."}
            frame(ask, lit=node.id)
        d = 1 + max(depth(node.left), depth(node.right))
        depth_of[node.id] = d
        tags[node.id] = tag(d)
        stack.pop()
        if leaf:
            frame({"en": f"{node.val} is a leaf: both sides are empty (0), so it returns 1 + 0 = 1.",
                   "ko": f"{josa(node.val, '은는')} 리프입니다. 양쪽이 비어 있으므로(0) 1 + 0 = 1을 돌려줍니다."},
                  good=node.id)
        else:
            best = d - 1
            frame({"en": f"{node.val}'s left depth is {side(node.left)} and its right depth is {side(node.right)}: "
                         f"it returns 1 + {best} = {d}.",
                   "ko": f"{node.val}의 왼쪽 깊이는 {side(node.left, True)}, 오른쪽 깊이는 {side(node.right, True)}"
                         f"입니다. 1 + {best} = {josa(d, '을를')} 돌려줍니다."},
                  good=node.id,
                  moves=[move(at("tree", k.id), at("tree", node.id), value=str(depth_of[k.id]))
                         for k in (node.left, node.right) if k])
        done.append(node.id)
        return d

    answer = depth(root)
    path, node = [root], root
    while node.left or node.right:
        kids = [k for k in (node.left, node.right) if k]
        node = max(kids, key=lambda k: depth_of[k.id])  # the first of the deepest, left before right
        path.append(node)
    chain = " -> ".join(str(x.val) for x in path)
    frame({"en": f"The root returns {answer}: the longest chain from the root down, {chain}, has {answer} "
                 f"{plural(answer, 'node', 'nodes')}.",
           "ko": f"root가 {josa(answer, '을를')} 돌려줍니다. root에서 내려가는 가장 긴 체인 {chain}의 노드가 "
                 f"{answer}개입니다."}, path=path, answer=str(answer))
    return str(answer)


for number, sample in enumerate(sample_cases(SLUG), start=1):
    values = json.loads(sample["input"])
    run = sample_run(wt, number, sample, input=f"root = {driver_list(values)}", setup={"tree": level_order_tree(values)})
    solve(values, run)
wt.write(walkthrough_path(SLUG))
