#!/usr/bin/env python3.12
"""mirror-menu-tree's Walkthrough: the reference solution (scripts/replay-solutions/mirror-menu-tree.py) mirrors a
tree recursively, each call copying its node and hanging the mirror of the node's right subtree on the copy's left
and the mirror of its left subtree on the copy's right. The recursion walks the input tree, so it has no drawing of
its own (#359): the current call's node is lit on the input tree and the calls still open are shaded. Beside it the
mirrored tree grows as the description's Diagram draws the two, each copy moving across from its node. One frame per
call on a node, on each sample Test Case.

    CODEBITE_DB=<database> scripts/walkthroughs/mirror-menu-tree.py

writes common/src/main/resources/walkthroughs/mirror-menu-tree.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import (TreeNode, build_tree, driver_list, josa, plural, sample_cases, sample_run,  # noqa: E402
                      tree_values, walkthrough_path)
from walkthrough_trace import Tree, Walkthrough, at, level_order_tree, move  # noqa: E402

SLUG = "mirror-menu-tree"

wt = Walkthrough(
    {"en": "Mirror the Menu Tree", "ko": "메뉴 트리 뒤집기"},
    {"en": "The mirror of a tree is its root with the mirror of its right subtree on the left and the mirror of its "
           "left subtree on the right: copy each node, then build its two sides from the opposite sides, recursively.",
     "ko": "트리를 뒤집은 결과는 루트 아래 왼쪽에 오른쪽 서브트리를 뒤집은 것, 오른쪽에 왼쪽 서브트리를 뒤집은 것을 단 "
           "트리입니다. 노드를 하나씩 옮기며 양쪽을 반대편에서 재귀적으로 만듭니다."},
    views=[
        {"id": "tree", "type": "tree", "arity": 2, "title": {"en": "root", "ko": "root (원래 트리)"},
         "empty": {"en": "empty tree", "ko": "빈 트리"}},
        {"id": "mirror", "type": "tree", "arity": 2, "title": {"en": "mirrored tree", "ko": "뒤집은 트리"},
         "empty": {"en": "nothing yet", "ko": "아직 없음"}},
    ],
)


def solve(values, run):
    """Solution.mirrorTree with a frame per call on a node. Returns the answer as the Driver prints it."""
    tree, root = build_tree(values)
    grown = Tree()
    stack, done = [], []

    def frame(caption, lit=None, moves=None, final=False, **answer):
        if final:
            marks, mirror_marks = {"dim": list(done)}, {"path": [n["id"] for n in grown.nodes]}
        else:
            marks = {"dim": [i for i in done if i not in stack]}
            mirror_marks = {}
            if lit is not None:
                marks["lit"] = [lit]
                mirror_marks["good"] = [lit]
        run.frame(caption, tree={"nodeMarks": marks, "shade": [] if final else list(stack)},
                  mirror={**grown.state(), "nodeMarks": mirror_marks}, moves=moves, **answer)

    n = len(tree["nodes"])
    frame({"en": f"A tree of {n} {plural(n, 'node', 'nodes')} with root {root.val}. Mirror it from the root down: "
                 f"each node's right side becomes its copy's left side.",
           "ko": f"root가 {root.val}인 노드 {n}개짜리 트리를 root부터 내려가며 뒤집습니다. 각 노드의 오른쪽이 "
                 f"복사본의 왼쪽이 됩니다."})

    def mirror(node, parent=None, slot=None, side=None):
        if node is None:
            return None
        stack.append(node.id)
        copy = TreeNode(node.id, node.val)
        grown.add(node.val, parent=None if parent is None else parent.id, slot=slot, id=node.id)
        kids = [k for k in (node.right, node.left) if k]
        if not kids:
            rest = {"en": " It has no children, so its mirror is just itself.",
                    "ko": " 자식이 없으므로 그대로 끝납니다."}
        elif len(kids) == 2:
            rest = {"en": f" Next, mirror its right child {node.right.val} onto the left.",
                    "ko": f" 다음으로 오른쪽 자식 {josa(node.right.val, '을를')} 뒤집어 왼쪽에 답니다."}
        elif node.right:
            rest = {"en": f" Its only child, {node.right.val}, is on the right, so it goes to the left.",
                    "ko": f" 하나뿐인 자식 {josa(node.right.val, '이가')} 오른쪽에 있으므로 왼쪽으로 갑니다."}
        else:
            rest = {"en": f" Its only child, {node.left.val}, is on the left, so it goes to the right.",
                    "ko": f" 하나뿐인 자식 {josa(node.left.val, '이가')} 왼쪽에 있으므로 오른쪽으로 갑니다."}
        if parent is None:
            head = {"en": f"Copy the root {node.val}: it stays the root.",
                    "ko": f"root {josa(node.val, '을를')} 복사하며, root는 그대로 root입니다."}
        else:
            was, now = ("right", "left") if side == "right" else ("left", "right")
            ko_was, ko_now = ("오른쪽", "왼쪽") if side == "right" else ("왼쪽", "오른쪽")
            head = {"en": f"{node.val} was {parent.val}'s {was} child, so its copy becomes the {now} child of "
                          f"{parent.val}'s copy.",
                    "ko": f"{josa(node.val, '은는')} {parent.val}의 {ko_was} 자식이었으므로 복사본은 {parent.val}의 "
                          f"{ko_now} 자식이 됩니다."}
        frame({"en": head["en"] + rest["en"], "ko": head["ko"] + rest["ko"]}, lit=node.id,
              moves=[move(at("tree", node.id), at("mirror", node.id))])
        copy.left = mirror(node.right, node, 0, "right")
        copy.right = mirror(node.left, node, 1, "left")
        stack.pop()
        done.append(node.id)
        return copy

    result = tree_values(mirror(root))
    printed = driver_list(result)
    frame({"en": f"Every node is copied with its sides swapped, so each level reads right to left: {printed}.",
           "ko": f"모든 노드를 좌우를 바꿔 옮겼으므로 각 층을 오른쪽에서 왼쪽으로 읽은 순서가 됩니다. 답은 "
                 f"{printed}입니다."}, final=True, answer=printed)
    return printed


for number, sample in enumerate(sample_cases(SLUG), start=1):
    values = json.loads(sample["input"])
    run = sample_run(wt, number, sample, input=f"root = {driver_list(values)}", setup={"tree": level_order_tree(values)})
    solve(values, run)
wt.write(walkthrough_path(SLUG))
