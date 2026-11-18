#!/usr/bin/env python3.12
"""binary-tree-level-order's Walkthrough: the reference solution
(scripts/replay-solutions/binary-tree-level-order.py), breadth first one level at a time, recording one frame per
level read into the answer and one per node whose children join the next level, on each sample Test Case. The tree
is drawn as the description's Diagram draws it; the level being read and the one being built are one queue, front on
the left, each value tagged with its depth, and each level's values move from the queue into the answer as one list.

    CODEBITE_DB=<database> scripts/walkthroughs/binary-tree-level-order.py

writes common/src/main/resources/walkthroughs/binary-tree-level-order.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import driver_list, josa, plural, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, level_order_tree, move  # noqa: E402

SLUG = "binary-tree-level-order"

wt = Walkthrough(
    {"en": "Binary Tree Level Order Traversal", "ko": "이진 트리 레벨 순서 순회"},
    {"en": "Keep one level in a queue: read its values into the answer as one list, then replace each node with its "
           "children, left before right, so the queue then holds exactly the next level.",
     "ko": "한 레벨을 큐에 둡니다. 그 값들을 리스트 하나로 답에 넣은 뒤 각 노드를 왼쪽, 오른쪽 자식 순으로 바꿔 넣으면 큐에는 "
           "정확히 다음 레벨이 남습니다."},
    views=[
        {"id": "tree", "type": "tree", "arity": 2, "title": {"en": "root", "ko": "root (트리)"},
         "empty": {"en": "empty tree", "ko": "빈 트리"}},
        {"id": "level", "type": "queue", "title": {"en": "level queue", "ko": "레벨 큐"},
         "empty": {"en": "empty", "ko": "비어 있음"}},
        {"id": "result", "type": "output", "title": {"en": "answer, one list per depth", "ko": "답 (깊이마다 리스트 하나)"},
         "empty": {"en": "none yet", "ko": "아직 없음"}},
    ],
)


class TreeNode:
    def __init__(self, id, val):
        self.id, self.val, self.left, self.right = id, val, None, None


def build(values):
    """The tree as the solution sees it, each node carrying its level-order index (the tree view's id)."""
    tree = level_order_tree(values)
    nodes = {n["id"]: TreeNode(n["id"], n["value"]) for n in tree["nodes"]}
    for e in tree["edges"]:
        setattr(nodes[e["from"]], "right" if e["slot"] else "left", nodes[e["to"]])
    return tree, nodes.get(0)


def depth_tag(d):
    return {"en": f"depth {d}", "ko": f"깊이 {d}"}


def solve(values, run):
    """Solution.levelOrder with a frame per step. Returns the answer as the Driver prints it."""
    tree, root = build(values)
    levels = []
    queue = []      # (node, depth), front first: the level being read, then the next level as it grows
    leaving = None  # the front, drawn for the frame it leaves
    done = []       # ids of nodes whose children were taken

    def frame(caption, lit=(), good=(), shade=(), q_lit=(), q_good=(), r_good=(), moves=None, path=False, **answer):
        shown = ([leaving] if leaving else []) + queue
        if path:
            node_marks = {"path": [n["id"] for n in tree["nodes"]]}
        else:
            node_marks = {"dim": [i for i in done if i not in lit], "good": list(good), "lit": list(lit)}
        run.frame(caption,
                  tree={"nodeMarks": node_marks, "shade": list(shade)},
                  level={"values": [n.val for n, _ in shown], "tags": [[i, depth_tag(d)] for i, (_, d) in enumerate(shown)],
                         "marks": {"lit": list(q_lit), "good": list(q_good)}},
                  result={"values": [list(lv) for lv in levels],
                          "marks": {"path": list(range(len(levels)))} if path else {"good": list(r_good)}},
                  moves=moves, **answer)

    if root is None:
        frame({"en": "The tree is empty: there are no levels, so the answer is [].",
               "ko": "트리가 비어 있어 레벨이 없으므로 답은 []입니다."}, answer="[]")
        return "[]"

    n = len(tree["nodes"])
    frame({"en": f"A tree of {n} {plural(n, 'node', 'nodes')} with root {root.val}. Read it level by level, left to right.",
           "ko": f"root가 {root.val}인 노드 {n}개짜리 트리입니다. 위 레벨부터 왼쪽에서 오른쪽으로 읽습니다."})
    queue.append((root, 0))
    frame({"en": f"Level 0 is just the root: {root.val} joins the queue.",
           "ko": f"레벨 0은 root뿐이므로 {josa(root.val, '이가')} 큐에 들어갑니다."},
          good=[root.id], q_good=[0], moves=[move(at("tree", root.id), at("level", 0))])
    depth = 0
    while queue:
        level = [n for n, _ in queue]
        levels.append([n.val for n in level])
        shown = driver_list(levels[-1])
        frame({"en": f"The queue holds depth {depth}: its {len(level)} {plural(len(level), 'value goes', 'values go')} into "
                     f"the answer as the list {shown}.",
               "ko": f"큐에는 깊이 {depth}의 노드가 있습니다. 값 {len(level)}개를 리스트 하나로 묶어 답에 넣습니다: {shown}."},
              shade=[n.id for n in level], q_lit=list(range(len(level))), r_good=[len(levels) - 1],
              moves=[move(at("level", i), at("result", len(levels) - 1)) for i in range(len(level))])
        for _ in range(len(level)):
            leaving = queue.pop(0)
            node = leaving[0]
            kids = [c for c in (node.left, node.right) if c]
            back = len(queue) + 1  # the drawn position of the first child to join, behind the front leaving
            queue.extend((c, depth + 1) for c in kids)
            shade = [n.id for n, d in queue if d == depth] + [node.id]
            if kids:
                names = " and ".join(str(c.val) for c in kids)
                frame({"en": f"{node.val} leaves the front; its {plural(len(kids), 'child', 'children')} {names} "
                             f"{plural(len(kids), 'joins', 'join')} the back at depth {depth + 1}.",
                       "ko": f"{josa(node.val, '이가')} 앞에서 나가고, 자식 "
                             f"{''.join(f'{c.val}, ' for c in kids[:-1])}{josa(kids[-1].val, '이가')} 깊이 "
                             f"{josa(depth + 1, '(으)로')} "
                             f"뒤에 들어갑니다."},
                      lit=[node.id], good=[c.id for c in kids], shade=shade, q_lit=[0],
                      q_good=list(range(back, back + len(kids))),
                      moves=[move(at("tree", c.id), at("level", back + i)) for i, c in enumerate(kids)])
            else:
                frame({"en": f"{node.val} leaves the front; it has no children, so nothing joins.",
                       "ko": f"{josa(node.val, '이가')} 앞에서 나갑니다. 자식이 없어 들어오는 노드가 없습니다."},
                      lit=[node.id], shade=shade, q_lit=[0])
            done.append(node.id)
        leaving = None
        depth += 1
    printed = driver_list(levels)
    frame({"en": f"The queue is empty: every depth is read, so the answer is {printed}.",
           "ko": f"큐가 비었습니다. 모든 깊이를 읽었으므로 답은 {printed}입니다."}, path=True, answer=printed)
    return printed


for number, sample in enumerate(sample_cases(SLUG), start=1):
    values = json.loads(sample["input"])
    run = sample_run(wt, number, sample, input=f"root = {driver_list(values)}",
                     setup={"tree": level_order_tree(values)})
    solve(values, run)
wt.write(walkthrough_path(SLUG))
