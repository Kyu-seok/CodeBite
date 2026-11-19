#!/usr/bin/env python3.12
"""rebuild-tree-from-traversals' Walkthrough: the reference solution
(scripts/replay-solutions/rebuild-tree-from-traversals.py) first indexes every inorder value's position in a map,
then builds recursively: build(low, high) takes the next preorder value as the root of inorder[low..high], looks up
its position, and builds the part left of it as the left subtree and the part right of it as the right subtree.
The recursion walks the tree it builds, so it has no drawing of its own (#359): the tree grows one node per call,
the new node lit and the calls still open shaded, each value moving in from its preorder cell; the call's inorder
range is a span with its two halves under it. One frame for the map and one per node built, on each sample Test Case.

    CODEBITE_DB=<database> scripts/walkthroughs/rebuild-tree-from-traversals.py

writes common/src/main/resources/walkthroughs/rebuild-tree-from-traversals.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import TreeNode, driver_list, josa, plural, sample_cases, sample_run, tree_values, walkthrough_path  # noqa: E402
from walkthrough_trace import Tree, Walkthrough, at, map_entries, move, span  # noqa: E402

SLUG = "rebuild-tree-from-traversals"

wt = Walkthrough(
    {"en": "Rebuild Tree From Traversals", "ko": "순회 결과로 트리 복원"},
    {"en": "Preorder lists each subtree's root first, and inorder puts that root between its left and right subtrees: "
           "take the next preorder value as the root, find it in inorder, and build the values left of it as the left "
           "subtree and those right of it as the right subtree, recursively.",
     "ko": "전위 순회는 각 서브트리의 루트를 먼저 적고, 중위 순회는 그 루트를 왼쪽과 오른쪽 서브트리 사이에 둡니다. 전위 "
           "순회의 다음 값을 루트로 삼아 중위 순회에서 찾고, 그 왼쪽 값들로 왼쪽 서브트리를, 오른쪽 값들로 오른쪽 "
           "서브트리를 재귀적으로 만듭니다."},
    views=[
        {"id": "preorder", "type": "array", "title": "preorder"},
        {"id": "inorder", "type": "array", "title": "inorder"},
        {"id": "position", "type": "map", "title": {"en": "position (inorder index)", "ko": "position (중위 인덱스)"},
         "empty": {"en": "empty", "ko": "비어 있음"}},
        {"id": "tree", "type": "tree", "arity": 2, "title": {"en": "rebuilt tree", "ko": "복원한 트리"},
         "empty": {"en": "nothing yet", "ko": "아직 없음"}},
    ],
)


def solve(preorder, inorder, run):
    """Solution.rebuildTree with a frame for the map and one per node built. Returns the answer as the Driver prints it."""
    n = len(preorder)
    position = {}
    grown = Tree()
    used = 0          # preorder values taken so far
    stack = []        # ids of the calls still open

    def frame(caption, pre=None, ino=None, pos=None, tree=None, moves=None, **answer):
        run.frame(caption,
                  preorder={"values": preorder, "pointers": {"next": used} if used < n else {},
                            "marks": {"dim": list(range(used))}, **(pre or {})},
                  inorder={"values": inorder, **(ino or {})},
                  position={"entries": map_entries(position), **(pos or {})},
                  tree={**grown.state(), "shade": list(stack), **(tree or {})}, moves=moves, **answer)

    frame({"en": f"{n} {plural(n, 'value', 'values')}. Preorder's first value is the root; inorder will say which "
                 f"values hang left of it and which right.",
           "ko": f"값 {n}개입니다. preorder의 첫 값이 루트이고, inorder를 보면 어떤 값이 그 왼쪽에, 어떤 값이 오른쪽에 "
                 f"달리는지 알 수 있습니다."})
    for i, v in enumerate(inorder):
        position[v] = f"i={i}"
    frame({"en": "First, index where each value sits in inorder, so each root's place is one lookup away.",
           "ko": "먼저 각 값이 inorder의 몇 번 칸에 있는지 map에 적어 두어, 루트의 자리를 한 번에 찾게 합니다."},
          pos={"marks": {"good": list(inorder)}},
          moves=[move(at("inorder", i), at("position", v), value=f"i={i}") for i, v in enumerate(inorder)])

    def halves(low, middle, high):
        spans = {"range": span(low, high, {"en": f"[{low}..{high}]", "ko": f"[{low}..{high}]"}, fade=True)}
        if low <= middle - 1:
            spans["left"] = span(low, middle - 1, {"en": "left", "ko": "왼쪽"}, below=True)
        if middle + 1 <= high:
            spans["right"] = span(middle + 1, high, {"en": "right", "ko": "오른쪽"}, below=True)
        return spans

    def part(low, high):
        if low > high:
            return {"en": "none", "ko": "없음"}
        vals = "[" + ",".join(str(x) for x in inorder[low:high + 1]) + "]"
        return {"en": vals, "ko": vals}

    def build(low, high, parent=None, slot=None):
        nonlocal used
        if low > high:
            return None
        k = used
        value = preorder[k]
        used += 1
        node = TreeNode(k, value)
        grown.add(value, parent=parent, slot=slot, id=k)
        middle = int(position[value][2:])
        left, right = part(low, middle - 1), part(middle + 1, high)
        if parent is None:
            where = {"en": f"The next preorder value, {value}, is the root.",
                     "ko": f"preorder의 다음 값 {josa(value, '이가')} 루트입니다."}
        else:
            side = ("left", "왼쪽") if slot == 0 else ("right", "오른쪽")
            pv = preorder[parent]
            where = {"en": f"The next preorder value, {value}, is the root of {pv}'s {side[0]} subtree.",
                     "ko": f"preorder의 다음 값 {josa(value, '은는')} {pv}의 {side[1]} 서브트리 루트입니다."}
        stack.append(k)
        frame({"en": where["en"] + f" Inorder has it at index {middle}. Left part: {left['en']}, right part: "
                                   f"{right['en']}.",
               "ko": where["ko"] + f" inorder의 {middle}번 칸에 있습니다. 왼쪽 부분: {left['ko']}, 오른쪽 부분: "
                                   f"{right['ko']}."},
              pre={"marks": {"dim": list(range(k)), "lit": [k]}, "pointers": {"next": k}},
              ino={"pointers": {"mid": middle}, "marks": {"lit": [middle]}, "spans": halves(low, middle, high)},
              pos={"probe": {"key": value, "hit": True}},
              tree={"nodeMarks": {"good": [k]}},
              moves=[move(at("preorder", k), at("tree", k))])
        node.left = build(low, middle - 1, k, 0)
        node.right = build(middle + 1, high, k, 1)
        stack.pop()
        return node

    root = build(0, n - 1)
    printed = driver_list(tree_values(root))
    frame({"en": f"Every preorder value is placed, each between its left and right parts of inorder: the tree reads "
                 f"{printed}.",
           "ko": f"preorder의 모든 값이 inorder의 왼쪽과 오른쪽 부분 사이에 자리 잡았습니다. 트리는 {printed}입니다."},
          tree={"nodeMarks": {"path": [x["id"] for x in grown.nodes]}}, answer=printed)
    return printed


for number, sample in enumerate(sample_cases(SLUG), start=1):
    pre_line, in_line = sample["input"].split("\n")
    preorder, inorder = json.loads(pre_line), json.loads(in_line)
    run = sample_run(wt, number, sample, input=f"preorder = {driver_list(preorder)}, inorder = {driver_list(inorder)}")
    solve(preorder, inorder, run)
wt.write(walkthrough_path(SLUG))
