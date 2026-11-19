#!/usr/bin/env python3.12
"""longest-folder-path's Walkthrough: the reference solution (scripts/replay-solutions/longest-folder-path.py), a
recursion where each call returns its node's height (the nodes on its longest chain down) and, on the way, tries the
path that bends at its node: the left height plus the right height is that path's edge count, and the best of these
is the answer. The recursion walks the input tree, so it has no drawing of its own (#359): the current call's node is
lit, the calls still open are shaded, and each node is tagged with the height it returns, which moves up into its
parent; the best bend so far is a box each new record moves into. One frame per call entering a node with children
and one per call returning, on each sample Test Case.

    CODEBITE_DB=<database> scripts/walkthroughs/longest-folder-path.py

writes common/src/main/resources/walkthroughs/longest-folder-path.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import build_tree, driver_list, josa, plural, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, level_order_tree, move  # noqa: E402

SLUG = "longest-folder-path"

wt = Walkthrough(
    {"en": "Longest Folder Path", "ko": "가장 긴 폴더 경로"},
    {"en": "Every path bends at one highest folder, so it is that folder's longest chain down on the left plus its "
           "longest chain down on the right. One pass from the leaves up: each folder returns its height, and adds "
           "its two children's heights to try the path bending there.",
     "ko": "모든 경로는 가장 높은 폴더 하나에서 꺾이므로, 그 폴더의 왼쪽으로 가장 긴 체인과 오른쪽으로 가장 긴 체인을 이은 "
           "것입니다. 리프에서 위로 한 번 훑으며 각 폴더는 자기 높이를 돌려주고, 두 자식의 높이를 더해 거기서 꺾이는 "
           "경로를 재 봅니다."},
    views=[
        {"id": "tree", "type": "tree", "arity": 2,
         "title": {"en": "root (under each node: the height it returns)", "ko": "root (노드 아래: 돌려주는 높이)"}},
        {"id": "best", "type": "output", "title": {"en": "best: longest path so far, in edges",
                                                   "ko": "best (지금까지 가장 긴 경로의 간선 수)"}},
    ],
)


def tag(h):
    return {"en": f"height {h}", "ko": f"높이 {h}"}


def solve(values, run):
    """Solution.longestPathEdges with a frame per call entering a node with children and per call returning.
    Returns the answer as the Driver prints it."""
    tree, root = build_tree(values)
    tags, stack, done, height = {}, [], [], {}
    best = 0
    best_node = root

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
                  best={"values": [str(best)], "marks": {"good": [0]} if record else {}}, moves=moves, **answer)

    n = len(tree["nodes"])
    frame({"en": f"A folder tree of {n} {plural(n, 'folder', 'folders')}. Each call returns its folder's height; best "
                 f"starts at 0 edges.",
           "ko": f"폴더 {n}개짜리 트리입니다. 각 호출은 자기 폴더의 높이를 돌려주며, best는 간선 0개에서 시작합니다."})

    def h(kid):
        return 0 if kid is None else height[kid.id]

    def depth(node):
        nonlocal best, best_node
        if node is None:
            return 0
        stack.append(node.id)
        leaf = node.left is None and node.right is None
        if not leaf:
            if node.left:
                ask = {"en": f"{node.val} has children: first find its left child {node.left.val}'s height.",
                       "ko": f"{josa(node.val, '은는')} 자식이 있으므로 먼저 왼쪽 자식 {node.left.val}의 높이를 구합니다."}
            else:
                ask = {"en": f"{node.val}'s left side is empty (height 0): find its right child {node.right.val}'s "
                             f"height.",
                       "ko": f"{node.val}의 왼쪽은 비어 있으므로(높이 0) 오른쪽 자식 {node.right.val}의 높이를 구합니다."}
            frame(ask, lit=node.id)
        left, right = depth(node.left), depth(node.right)
        through = left + right
        beats = through > best
        if beats:
            best, best_node = through, node
        d = 1 + max(left, right)
        height[node.id] = d
        tags[node.id] = tag(d)
        stack.pop()
        moves = [move(at("tree", k.id), at("tree", node.id), value=str(height[k.id]))
                 for k in (node.left, node.right) if k]
        if beats:
            moves.append(move(at("tree", node.id), at("best", 0), value=str(best)))
        if leaf:
            caption = {"en": f"{node.val} is a leaf: height 1, and no path bends here (0 edges).",
                       "ko": f"{josa(node.val, '은는')} 리프입니다. 높이는 1이고, 여기서 꺾이는 경로는 간선 0개입니다."}
        else:
            verdict = ({"en": "a new best", "ko": "새 best입니다"} if beats else
                       {"en": f"not more than best {best}", "ko": f"best {best}보다 길지 않습니다"})
            caption = {"en": f"{node.val}: left height {left} + right height {right} = {through} "
                             f"{plural(through, 'edge', 'edges')} bending here, "
                             f"{verdict['en']}. It returns 1 + {max(left, right)} = {d}.",
                       "ko": f"{node.val}: 왼쪽 높이 {left} + 오른쪽 높이 {right} = 간선 {through}개가 여기서 꺾이며 "
                             f"{verdict['ko']}. 1 + {max(left, right)} = {josa(d, '을를')} 돌려줍니다."}
        frame(caption, good=node.id, moves=moves, record=beats)
        done.append(node.id)
        return d

    depth(root)

    def chain(node):
        """The nodes of node's longest chain down, the first of the tallest child each time."""
        out = []
        while node:
            out.append(node)
            kids = [k for k in (node.left, node.right) if k]
            node = max(kids, key=lambda k: height[k.id]) if kids else None
        return out

    lefts = list(reversed(chain(best_node.left))) if best_node.left else []
    rights = chain(best_node.right) if best_node.right else []
    nodes = lefts + [best_node] + rights
    edges = [[a.id, b.id] if b in (a.left, a.right) else [b.id, a.id] for a, b in zip(nodes, nodes[1:])]
    route = " -> ".join(str(x.val) for x in nodes)
    frame({"en": f"The longest path bends at {best_node.val}: {route}, {best} {plural(best, 'edge', 'edges')}.",
           "ko": f"가장 긴 경로는 {best_node.val}에서 꺾이는 경로 {route}, 간선 {best}개입니다."},
          path=([x.id for x in nodes], edges), answer=str(best))
    return str(best)


for number, sample in enumerate(sample_cases(SLUG), start=1):
    values = json.loads(sample["input"])
    run = sample_run(wt, number, sample, input=f"root = {driver_list(values)}", setup={"tree": level_order_tree(values)})
    solve(values, run)
wt.write(walkthrough_path(SLUG))
