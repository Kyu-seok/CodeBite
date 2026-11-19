#!/usr/bin/env python3.12
"""best-skill-tree-path's Walkthrough: the reference solution (scripts/replay-solutions/best-skill-tree-path.py), a
recursion where each call returns its node's gain (the best sum of a chain starting at the node and going down one
side), a child's gain below 0 counting as 0, and on the way tries the path that turns at its node: its score plus
both children's kept gains, the best of these being the answer. The recursion walks the input tree, so it has no
drawing of its own (#359): the current call's node is lit, the calls still open are shaded, and each node is tagged
with the gain it returns, which moves up into its parent; the best turn so far is a box each new record moves into.
One frame per call entering a node with children and one per call returning, on each sample Test Case.

    CODEBITE_DB=<database> scripts/walkthroughs/best-skill-tree-path.py

writes common/src/main/resources/walkthroughs/best-skill-tree-path.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import build_tree, driver_list, josa, plural, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, level_order_tree, move  # noqa: E402

SLUG = "best-skill-tree-path"

wt = Walkthrough(
    {"en": "Best Skill Tree Path", "ko": "최고의 스킬 트리 경로"},
    {"en": "Every path turns at one highest node: that node's score plus the best chain down its left and the best "
           "chain down its right, a chain worth less than 0 left out. One pass from the leaves up: each node returns "
           "its best chain down one side (its gain) and tries the path turning at it.",
     "ko": "모든 경로는 가장 높은 노드 하나에서 꺾입니다. 그 노드의 점수에 왼쪽으로 내려가는 가장 좋은 체인과 오른쪽으로 "
           "내려가는 가장 좋은 체인을 더하되, 0보다 작은 체인은 뺍니다. 리프에서 위로 한 번 훑으며 각 노드는 한쪽으로 "
           "내려가는 가장 좋은 체인(gain)을 돌려주고, 자기에서 꺾이는 경로를 재 봅니다."},
    views=[
        {"id": "tree", "type": "tree", "arity": 2,
         "title": {"en": "root (under each node: the gain it returns)", "ko": "root (노드 아래: 돌려주는 gain)"}},
        {"id": "best", "type": "output", "title": {"en": "best: largest path sum so far",
                                                   "ko": "best (지금까지 가장 큰 경로 합)"}},
    ],
)


def tag(g):
    return {"en": f"gain {g}", "ko": f"gain {g}"}


def solve(values, run):
    """Solution.maxPathSum with a frame per call entering a node with children and per call returning.
    Returns the answer as the Driver prints it."""
    tree, root = build_tree(values)
    tags, stack, done, gain_of = {}, [], [], {}
    best, best_node = None, None  # None is -∞

    def frame(caption, lit=None, good=None, moves=None, record=False, path=None, **answer):
        if path is not None:
            ids, edges = path
            marks, shade, edge_marks = {"path": ids, "dim": [i for i in done if i not in ids]}, [], {"path": edges}
        else:
            marks = {"dim": [i for i in done if i not in stack and i != good]}
            if lit is not None:
                marks["lit"] = [lit]
            if good is not None:
                marks["good"] = [good]
            shade, edge_marks = list(stack), {}
        run.frame(caption, tree={"nodeMarks": marks, "shade": shade, "edgeMarks": edge_marks,
                                 "tags": [[i, t] for i, t in tags.items()]},
                  best={"values": ["-∞" if best is None else str(best)], "marks": {"good": [0]} if record else {}},
                  moves=moves, **answer)

    n = len(tree["nodes"])
    frame({"en": f"A skill tree of {n} {plural(n, 'node', 'nodes')}. Each call returns its node's gain; best starts "
                 f"at -∞, since a path may be a single negative node.",
           "ko": f"노드 {n}개짜리 스킬 트리입니다. 각 호출은 자기 노드의 gain을 돌려줍니다. 경로가 음수 노드 하나일 수도 "
                 f"있으므로 best는 -∞에서 시작합니다."})

    def kept(kid):
        return 0 if kid is None else max(gain_of[kid.id], 0)

    def side(kid, ko=False):
        """A child's gain as the caption reads it: an empty or negative side counts 0."""
        if kid is None:
            return "0(자식 없음)" if ko else "0 (no child)"
        g = gain_of[kid.id]
        if g < 0:
            return f"{g}, 버리고 0" if ko else f"{g}, dropped to 0"
        return str(g)

    def gain(node):
        nonlocal best, best_node
        if node is None:
            return 0
        stack.append(node.id)
        leaf = node.left is None and node.right is None
        if not leaf:
            if node.left:
                ask = {"en": f"{node.val} has children: first find its left child {node.left.val}'s gain.",
                       "ko": f"{node.val}에는 자식이 있으므로 먼저 왼쪽 자식 {node.left.val}의 gain을 구합니다."}
            else:
                ask = {"en": f"{node.val}'s left side is empty (gain 0): find its right child {node.right.val}'s gain.",
                       "ko": f"{node.val}의 왼쪽은 비어 있으므로(gain 0) 오른쪽 자식 {node.right.val}의 gain을 "
                             f"구합니다."}
            frame(ask, lit=node.id)
        gain(node.left)
        gain(node.right)
        left, right = kept(node.left), kept(node.right)
        turn = node.val + left + right
        beats = best is None or turn > best
        if beats:
            best, best_node = turn, node
        g = node.val + max(left, right)
        gain_of[node.id] = g
        tags[node.id] = tag(g)
        stack.pop()
        moves = [move(at("tree", k.id), at("tree", node.id), value=str(gain_of[k.id]),
                      mark="bad" if gain_of[k.id] < 0 else None) for k in (node.left, node.right) if k]
        if beats:
            moves.append(move(at("tree", node.id), at("best", 0), value=str(best)))
        verdict = ({"en": "a new best", "ko": "새 best입니다"} if beats else
                   {"en": f"not more than best {best}", "ko": f"best {best}보다 크지 않습니다"})
        if leaf:
            caption = {"en": f"{node.val} is a leaf: the path of just {node.val} sums to {turn}, {verdict['en']}. "
                             f"It returns gain {g}.",
                       "ko": f"{node.val}: 리프이므로 이 노드 하나뿐인 경로의 합 {turn}, {verdict['ko']}. "
                             f"gain {josa(g, '을를')} 돌려줍니다."}
        else:
            caption = {"en": f"{node.val} + left {side(node.left)} + right {side(node.right)} = {turn} for the path "
                             f"turning here, {verdict['en']}. It returns {node.val} + {max(left, right)} = {g}.",
                       "ko": f"{node.val} + 왼쪽 {side(node.left, True)} + 오른쪽 {side(node.right, True)} = {turn}: "
                             f"여기서 꺾이는 경로의 합이며 {verdict['ko']}. {node.val} + {max(left, right)} = "
                             f"{josa(g, '을를')} 돌려줍니다."}
        frame(caption, good=node.id, moves=moves, record=beats)
        done.append(node.id)
        return g

    gain(root)

    def chain(node):
        """The nodes of node's best chain down, following the child with the larger gain while it is above 0."""
        out = []
        while node:
            out.append(node)
            kids = [k for k in (node.left, node.right) if k and gain_of[k.id] > 0]
            node = max(kids, key=lambda k: gain_of[k.id]) if kids else None
        return out

    lefts = list(reversed(chain(best_node.left))) if kept(best_node.left) > 0 else []
    rights = chain(best_node.right) if kept(best_node.right) > 0 else []
    nodes = lefts + [best_node] + rights
    edges = [[a.id, b.id] if b in (a.left, a.right) else [b.id, a.id] for a, b in zip(nodes, nodes[1:])]
    route = " -> ".join(str(x.val) for x in nodes)
    total = " + ".join(str(x.val) for x in nodes)
    frame({"en": f"The best path turns at {best_node.val}: {route}, {total} = {best}.",
           "ko": f"가장 좋은 경로는 {best_node.val}에서 꺾이는 경로 {route}, 합계 {total} = {best}입니다."},
          path=([x.id for x in nodes], edges), answer=str(best))
    return str(best)


for number, sample in enumerate(sample_cases(SLUG), start=1):
    values = json.loads(sample["input"])
    run = sample_run(wt, number, sample, input=f"root = {driver_list(values)}", setup={"tree": level_order_tree(values)})
    solve(values, run)
wt.write(walkthrough_path(SLUG))
