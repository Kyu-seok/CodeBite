#!/usr/bin/env python3.12
"""find-submap's Walkthrough: the reference solution (scripts/replay-solutions/find-submap.py) writes each tree as its
preorder walk with "#" for every missing child, which pins down a subtree's shape and values, then asks whether
subRoot's walk appears whole inside root's. Python evaluates walk(subRoot) first, so the frames do too: one frame per
token written, each moving from its node (a "#" from the node whose child is missing) into that tree's walk, then
one frame for the search, on each sample Test Case.

    CODEBITE_DB=<database> scripts/walkthroughs/find-submap.py

writes common/src/main/resources/walkthroughs/find-submap.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import build_tree, driver_list, josa, plural, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, level_order_tree, move, span  # noqa: E402

SLUG = "find-submap"

wt = Walkthrough(
    {"en": "Find the Sub-map", "ko": "서브맵 찾기"},
    {"en": "A preorder walk that writes # for every missing child describes a subtree's shape and values exactly, and "
           "a subtree's walk is one unbroken stretch of the whole tree's walk: so subRoot is in root exactly when its "
           "walk appears inside root's.",
     "ko": "없는 자식마다 # 표시를 적는 전위 순회는 서브트리의 모양과 값을 정확히 나타내고, 서브트리의 순회는 전체 트리 순회 "
           "안에 끊기지 않고 이어진 한 구간입니다. 그래서 subRoot의 순회가 root의 순회 안에 그대로 있을 때만 서브트리입니다."},
    views=[
        {"id": "root", "type": "tree", "arity": 2, "title": "root"},
        {"id": "sub", "type": "tree", "arity": 2, "title": "subRoot"},
        {"id": "subwalk", "type": "array", "title": {"en": "walk of subRoot", "ko": "subRoot의 순회"}},
        {"id": "rootwalk", "type": "array", "title": {"en": "walk of root", "ko": "root의 순회"}},
    ],
)

SIDE = {"left": ("left", "왼쪽"), "right": ("right", "오른쪽")}


def solve(root_values, sub_values, run):
    """Solution.containsSubBranch with a frame per token written and one for the search.
    Returns the answer as the Driver prints it."""
    trees = {"root": build_tree(root_values), "sub": build_tree(sub_values)}
    walks = {"root": [], "sub": []}
    written = {"root": [], "sub": []}
    walk_view = {"root": "rootwalk", "sub": "subwalk"}

    full = {t: 2 * len(trees[t][0]["nodes"]) + 1 for t in trees}  # a walk's length: each node and each missing child

    def frame(caption, lit=None, moves=None, walk_marks=None, walk_spans=None, node_marks=None, **answer):
        views = {}
        for t in ("root", "sub"):
            if node_marks is not None:
                views[t] = {"nodeMarks": node_marks.get(t, {})}
            else:
                marks = {"dim": [i for i in written[t] if not (lit and lit[0] == t and lit[1] == i)]}
                if lit and lit[0] == t:
                    marks["lit"] = [lit[1]]
                views[t] = {"nodeMarks": marks}
            wm = (walk_marks or {}).get(t)
            if wm is None:
                wm = {"good": [len(walks[t]) - 1]} if lit and lit[0] == t else {}
            views[walk_view[t]] = {"values": walks[t] + [""] * (full[t] - len(walks[t])), "marks": wm,
                                   "unread": list(range(len(walks[t]), full[t])),
                                   "spans": (walk_spans or {}).get(t, {})}
        run.frame(caption, moves=moves, **views, **answer)

    def name(t):
        return "root" if t == "root" else "subRoot"

    nr, ns = len(trees["root"][0]["nodes"]), len(trees["sub"][0]["nodes"])
    frame({"en": f"root has {nr} {plural(nr, 'node', 'nodes')}, subRoot {ns}. Write each as its preorder walk (node, "
                 f"left side, right side) with # for a missing child, subRoot first.",
           "ko": f"root는 노드 {nr}개, subRoot는 {ns}개입니다. 각각을 전위 순회(노드, 왼쪽, 오른쪽)로 적되 없는 자식은 "
                 f"# 표시로 적습니다. subRoot부터 적습니다."})

    def walk(t):
        _, top = trees[t]
        stack = [(top, None, None)]
        while stack:
            node, parent, side = stack.pop()
            if node is None:
                walks[t].append("#")
                en, ko = SIDE[side]
                frame({"en": f"{parent.val} has no {en} child: write #.",
                       "ko": f"{parent.val}에는 {ko} 자식이 없으므로 # 표시를 적습니다."},
                      lit=(t, parent.id), moves=[move(at(t, parent.id), at(walk_view[t], len(walks[t]) - 1), value="#")])
            else:
                walks[t].append(str(node.val))
                written[t].append(node.id)
                came = ({"en": f"Start {name(t)}'s walk at its root: write {node.val}.",
                         "ko": f"{name(t)}의 순회를 root부터 시작해 {josa(node.val, '을를')} 적습니다."}
                        if parent is None else
                        {"en": f"Next, {parent.val}'s {SIDE[side][0]} child: write {node.val}.",
                         "ko": f"다음은 {parent.val}의 {SIDE[side][1]} 자식이므로 {josa(node.val, '을를')} 적습니다."})
                frame(came, lit=(t, node.id), moves=[move(at(t, node.id), at(walk_view[t], len(walks[t]) - 1))])
                stack += [(node.right, node, "right"), (node.left, node, "left")]
        return walks[t]

    sub_walk = walk("sub")
    root_walk = walk("root")
    m = len(sub_walk)
    starts = [i for i in range(len(root_walk) - m + 1) if root_walk[i:i + m] == sub_walk]
    sub_text, root_text = ",".join(sub_walk), ",".join(root_walk)
    if starts:
        s = starts[0]
        # the nodes behind root_walk[s:s+m]: the root nodes in preorder, matched to the non-# tokens
        order = []

        def pre(node):
            if node:
                order.append(node.id)
                pre(node.left)
                pre(node.right)
        pre(trees["root"][1])
        before = sum(1 for tok in root_walk[:s] if tok != "#")
        inside = sum(1 for tok in sub_walk if tok != "#")
        ids = order[before:before + inside]
        frame({"en": f"subRoot's walk, {sub_text}, appears whole in root's walk, starting at index {s}: the "
                     f"subtree under {root_walk[s]} matches, so the answer is true.",
               "ko": f"subRoot의 순회 {sub_text} 전체가 root의 순회 안 {s}번 칸부터 그대로 나타납니다. "
                     f"{root_walk[s]} 아래 서브트리가 일치하므로 답은 true입니다."},
              walk_marks={"sub": {"path": list(range(m))}, "root": {"path": list(range(s, s + m))}},
              walk_spans={"root": {"match": span(s, s + m - 1, {"en": "subRoot's walk", "ko": "subRoot의 순회"})}},
              node_marks={"root": {"path": ids}, "sub": {"path": [n["id"] for n in trees["sub"][0]["nodes"]]}},
              answer="true")
        return "true"
    # the place where the longest start of subRoot's walk matches, to show where it breaks
    best, at_i = -1, 0
    for i in range(len(root_walk)):
        k = 0
        while k < m and i + k < len(root_walk) and root_walk[i + k] == sub_walk[k]:
            k += 1
        if k > best:
            best, at_i = k, i
    wrong = root_walk[at_i + best] if at_i + best < len(root_walk) else None
    frame({"en": f"subRoot's walk, {sub_text}, appears nowhere in root's walk: the closest, from index {at_i}, "
                 f"has {wrong} where subRoot has {sub_walk[best]}. So the answer is false.",
           "ko": f"subRoot의 순회 {sub_text} 전체는 root의 순회 어디에도 없습니다. 가장 가까운 {at_i}번 칸부터의 "
                 f"구간에는 subRoot의 '{sub_walk[best]}' 자리에 '{wrong}' 토큰이 있으므로 답은 false입니다."},
          walk_marks={"sub": {"lit": list(range(best)), "bad": [best]},
                      "root": {"lit": list(range(at_i, at_i + best)), "bad": [at_i + best]}},
          walk_spans={"root": {"closest": span(at_i, min(at_i + m, len(root_walk)) - 1,
                                               {"en": "closest", "ko": "가장 가까운 구간"}, mark="bad")}},
          node_marks={}, answer="false")
    return "false"


for number, sample in enumerate(sample_cases(SLUG), start=1):
    root_line, sub_line = sample["input"].split("\n")
    root_values, sub_values = json.loads(root_line), json.loads(sub_line)
    run = sample_run(wt, number, sample, input=f"root = {driver_list(root_values)}, subRoot = {driver_list(sub_values)}",
                     setup={"root": level_order_tree(root_values), "sub": level_order_tree(sub_values)})
    solve(root_values, sub_values, run)
wt.write(walkthrough_path(SLUG))
