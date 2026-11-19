#!/usr/bin/env python3.12
"""populating-next-pointers' Walkthrough: the reference solution (scripts/replay-solutions/populating-next-pointers.py),
which links each level of a perfect tree while walking the level above it along the next pointers it set the round
before: node.left.next = node.right inside one parent, node.right.next = node.next.left across to the next parent. One
frame per pointer set, on each sample Test Case. The tree is drawn as the description's Diagram draws it, with the
next pointers as the tree view's second link along each level; a level's last node keeps next = null, drawn to ∅ once
the walk reaches it. The answer is read along next, each level's values then a # moving from its last node.

    CODEBITE_DB=<database> scripts/walkthroughs/populating-next-pointers.py

writes common/src/main/resources/walkthroughs/populating-next-pointers.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import build_tree, driver_list, josa, plural, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, level_order_tree, move, tree_links  # noqa: E402

SLUG = "populating-next-pointers"

wt = Walkthrough(
    {"en": "Populating Next Right Pointers", "ko": "다음 오른쪽 포인터 연결"},
    {"en": "A level already linked is a list: walk it along next, and each node links the level below it, its left "
           "child to its right child, and its right child across to the left child of the node its next reaches.",
     "ko": "이미 연결된 레벨은 리스트입니다. next를 따라 걸으며 각 노드가 아래 레벨을 잇습니다. 왼쪽 자식은 오른쪽 "
           "자식으로, 오른쪽 자식은 next가 가리키는 노드의 왼쪽 자식으로 잇습니다."},
    views=[
        {"id": "tree", "type": "tree", "arity": 2,
         "title": {"en": "root: next along each level", "ko": "root: 레벨마다 next"},
         "empty": {"en": "empty tree", "ko": "빈 트리"}},
        {"id": "result", "type": "output", "title": {"en": "answer, read along next", "ko": "답 (next를 따라 읽기)"},
         "empty": {"en": "not read yet", "ko": "아직 없음"}},
    ],
)


def level_of(node):
    """A linked level, from its leftmost node along next."""
    out = []
    while node:
        out.append(node)
        node = node.next
    return out


def solve(values, run):
    """Solution.connect with a frame per pointer set. Returns the answer as the Driver prints it."""
    tree, root = build_tree(values)
    nodes = {}
    stack = [root] if root else []
    while stack:
        n = stack.pop()
        n.next = None
        nodes[n.id] = n
        stack += [c for c in (n.left, n.right) if c]
    shown = set()  # nodes whose next the drawing shows: set by the walk, or a level's last once the walk reaches it
    tags = {}
    done = []      # levels walked, dimmed

    def frame(caption, lit=(), good=(), link_marks=None, moves=None, result=(), path=False, **answer):
        marks = ({"path": [n["id"] for n in tree["nodes"]]} if path
                 else {"dim": [i for i in done if i not in lit], "lit": list(lit), "good": list(good)})
        state = {"nodeMarks": marks, "tags": [[i, t] for i, t in tags.items()],
                 **tree_links([nodes[i] for i in sorted(shown)], "next")}
        if link_marks:
            state["linkMarks"] = link_marks
        run.frame(caption, tree=state, result={"values": list(result), "marks": {"path": list(range(len(result)))}},
                  moves=moves, **answer)

    if root is None:
        frame({"en": "The tree is empty: there is nothing to link, so the answer is [].",
               "ko": "트리가 비어 있어 이을 노드가 없으므로 답은 []입니다."}, answer="[]")
        return "[]"
    n = len(tree["nodes"])
    shown.add(root.id)
    frame({"en": f"A perfect tree of {n} {plural(n, 'node', 'nodes')}, every next null. Level 0 is just the root "
                 f"{root.val}, so its next stays null: that level is linked already.",
           "ko": f"노드 {n}개짜리 포화 이진 트리이고, 모든 next가 null입니다. 레벨 0에는 root {root.val}뿐이므로 next는 "
                 f"null로 남고, 이 레벨은 이미 연결됐습니다."}, lit=[root.id])

    leftmost, depth = root, 0
    while leftmost and leftmost.left:
        node = leftmost
        tags = {node.id: "node"}
        frame({"en": f"Walk level {depth} from its leftmost node {node.val} to link level {depth + 1} below it.",
               "ko": f"레벨 {depth}의 가장 왼쪽 노드 {node.val}부터 걸으며 그 아래 레벨 {depth + 1}의 노드들을 잇습니다."},
              lit=[node.id])
        while node:
            node.left.next = node.right
            shown.add(node.left.id)
            frame({"en": f"Inside {node.val}: its left child {node.left.val} points at its right child "
                         f"{node.right.val}. {node.left.val}.next = {node.right.val}.",
                   "ko": f"{node.val}의 두 자식끼리 잇습니다. 왼쪽 자식의 next를 오른쪽 자식으로 정합니다: "
                         f"{node.left.val}.next = {node.right.val}."},
                  lit=[node.id], good=[node.left.id, node.right.id], link_marks={"good": [["next", node.left.id]]})
            if node.next:
                node.right.next = node.next.left
                shown.add(node.right.id)
                frame({"en": f"{node.val}.next is {node.next.val}, so {node.val}'s right child {node.right.val} points "
                             f"across at {node.next.val}'s left child {node.next.left.val}.",
                       "ko": f"{node.val}.next가 노드 {node.next.val}이므로, {node.val}의 오른쪽 자식 "
                             f"{node.right.val}의 next를 그 노드의 왼쪽 자식으로 정합니다: "
                             f"{node.right.val}.next = {node.next.left.val}."},
                      lit=[node.id, node.next.id], good=[node.right.id, node.next.left.id],
                      link_marks={"lit": [["next", node.id]], "good": [["next", node.right.id]]})
                tags = {node.next.id: "node"}
                frame({"en": f"node follows {node.val}.next to {node.next.val}.",
                       "ko": f"node가 {node.val}.next를 따라 다음 노드 {node.next.val}에 갑니다."},
                      lit=[node.next.id], link_marks={"lit": [["next", node.id]]},
                      moves=[move(at("tree", node.id), at("tree", node.next.id), value="node")])
            else:
                shown.add(node.right.id)
                frame({"en": f"{node.val}.next is null: {node.val} ends level {depth}, so its right child "
                             f"{node.right.val} ends level {depth + 1} and keeps next = null.",
                       "ko": f"{node.val}.next가 null이므로 {node.val}의 오른쪽 자식 {node.right.val}도 아래 레벨의 "
                             f"마지막 노드입니다. 그 next는 null로 남습니다."},
                      lit=[node.id], good=[node.right.id], link_marks={"good": [["next", node.right.id]]})
            node = node.next
        done.extend(x.id for x in level_of(leftmost))
        leftmost, depth = leftmost.left, depth + 1
        tags = {}
        if not leftmost.left:
            frame({"en": f"Level {depth} is linked, and its nodes have no children: every next is set.",
                   "ko": f"레벨 {josa(depth, '이가')} 다 이어졌고, 그 노드들에는 자식이 없습니다. 모든 next가 "
                         f"정해졌습니다."}, lit=[x.id for x in level_of(leftmost)])

    # the answer as the Driver prints it: each level along next from its leftmost node, then a '#'
    out, moves, start = [], [], root
    while start:
        last = None
        for x in level_of(start):
            moves.append(move(at("tree", x.id), at("result", len(out))))
            out.append(x.val)
            last = x
        moves.append(move(at("tree", last.id), at("result", len(out)), value="#"))
        out.append("#")
        start = start.left
    printed = "[" + ",".join(str(v) for v in out) + "]"
    tags = {}
    frame({"en": f"Read each level along next from its leftmost node, a # where next is null: {printed}.",
           "ko": f"각 레벨을 가장 왼쪽 노드부터 next를 따라 읽고, next가 null인 곳에 # 표시를 적으면 답은 {printed}입니다."},
          path=True, result=out, moves=moves, answer=printed)
    return printed


for number, sample in enumerate(sample_cases(SLUG), start=1):
    values = json.loads(sample["input"])
    run = sample_run(wt, number, sample, input=f"root = {driver_list(values)}", setup={"tree": level_order_tree(values)})
    solve(values, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
