#!/usr/bin/env python3.12
"""binary-tree-codec's Walkthrough: the reference solution (scripts/replay-solutions/binary-tree-codec.py) serializes
a tree breadth first through a queue, writing each node's value, or # for a missing child, as one token, then
deserializes the tokens with a second queue: each node taken from the front reads the next two tokens as its left and
right child. The input tree, the queue and the tokens are drawn; serialize takes one frame per token written (the
front leaving into its token, its two children joining the back), and deserialize one frame per node taken, its
children growing on the rebuilt tree from their tokens, on each sample Test Case.

    CODEBITE_DB=<database> scripts/walkthroughs/binary-tree-codec.py

writes common/src/main/resources/walkthroughs/binary-tree-codec.json.
"""
import json
import os
import sys
from collections import deque

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import build_tree, driver_list, josa, plural, sample_cases, sample_run, tree_values, walkthrough_path  # noqa: E402
from walkthrough_trace import Tree, Walkthrough, at, level_order_tree, move  # noqa: E402

SLUG = "binary-tree-codec"

wt = Walkthrough(
    {"en": "Serialize and Deserialize Binary Tree", "ko": "이진 트리 직렬화와 역직렬화"},
    {"en": "Write the tree level by level with # for every missing child: then the tokens after each node's own, in "
           "queue order, are exactly its two children, so reading them back with the same queue rebuilds the tree.",
     "ko": "트리를 한 층씩 적되 없는 자식마다 # 토큰을 적습니다. 그러면 큐 순서대로 각 노드 뒤에 오는 토큰 두 개가 바로 "
           "그 노드의 두 자식이라서, 같은 큐로 다시 읽으면 트리가 그대로 복원됩니다."},
    views=[
        {"id": "root", "type": "tree", "arity": 2, "title": "root",
         "empty": {"en": "empty tree", "ko": "빈 트리"}},
        {"id": "queue", "type": "queue", "title": "queue", "empty": {"en": "empty", "ko": "비어 있음"}},
        {"id": "data", "type": "array", "title": {"en": "data, split at commas", "ko": "data (쉼표로 나눈 토큰)"}},
        {"id": "copy", "type": "tree", "arity": 2, "title": {"en": "deserialize(data)", "ko": "deserialize(data) (복원한 트리)"},
         "empty": {"en": "nothing yet", "ko": "아직 없음"}},
    ],
)

SIDES = (("left", "왼쪽"), ("right", "오른쪽"))


def solve(values, run):
    """Codec.serialize, then Codec.deserialize, with a frame per token written and per node taken while reading.
    Returns the answer as the Driver prints it."""
    tree, root = build_tree(values)
    full = 2 * len(tree["nodes"]) + 1  # every node's token and every missing child's #
    parts = []
    queue = deque([root])
    copy = Tree()
    state = {"phase": "write", "written": []}

    def token(x):
        return "#" if x is None else x.val

    def frame(caption, root_marks=None, q_marks=None, data_marks=None, copy_marks=None, moves=None, **answer):
        if state["phase"] == "write":
            q = [token(x) for x in queue]
        else:
            q = [copy_val[x] for x in queue]
        run.frame(caption,
                  root={"nodeMarks": root_marks if root_marks is not None else {"dim": list(state["written"])}},
                  queue={"values": q, "marks": q_marks or {}},
                  data={"values": parts + [""] * (full - len(parts)), "unread": list(range(len(parts), full)),
                        "marks": data_marks or {}},
                  copy={**copy.state(), "nodeMarks": copy_marks or {}},
                  moves=moves, **answer)

    copy_val = {}
    if root is None:
        frame({"en": "The tree is empty. serialize starts with the root, null, alone in the queue.",
               "ko": "트리가 비어 있습니다. serialize는 root인 null 하나를 큐에 넣고 시작합니다."})
    else:
        n = len(tree["nodes"])
        frame({"en": f"A tree of {n} {plural(n, 'node', 'nodes')}. serialize starts with the root {root.val} alone in "
                     f"the queue; the tokens will number {full}: one per node and one # per missing child.",
               "ko": f"노드 {n}개짜리 트리이고, serialize는 root {root.val} 하나를 큐에 넣고 시작합니다. 토큰은 "
                     f"노드마다 하나, 없는 자식마다 # 하나씩 모두 {full}개가 됩니다."})

    # serialize
    while queue:
        node = queue[0]
        parts.append("#" if node is None else str(node.val))
        i = len(parts) - 1
        moves = [move(at("queue", 0), at("data", i))]
        if node is None:
            frame({"en": "The front is a missing child: write #. Nothing joins the queue.",
                   "ko": "맨 앞은 없는 자식이므로 # 토큰을 적습니다. 큐에 들어가는 것은 없습니다."},
                  q_marks={"lit": [0]}, data_marks={"good": [i]}, moves=moves)
            queue.popleft()
            continue
        state["written"].append(node.id)
        queue.append(node.left)
        queue.append(node.right)
        back = len(queue)
        for k, kid in enumerate((node.left, node.right)):
            pos = back - 2 + k
            if kid is None:
                moves.append(move(at("root", node.id), at("queue", pos), value="#"))
            else:
                moves.append(move(at("root", kid.id), at("queue", pos)))
        kids = [(token(node.left), "왼쪽"), (token(node.right), "오른쪽")]
        frame({"en": f"Take {node.val} from the front and write it. Its left child ({token(node.left)}) and right child "
                     f"({token(node.right)}) join the back, # for a missing one.",
               "ko": f"맨 앞의 {node.val} 값을 꺼내 적습니다. 왼쪽 자식({kids[0][0]})과 오른쪽 자식({kids[1][0]})이 "
                     f"큐 뒤에 들어가며, 없는 자식은 # 토큰입니다."},
              root_marks={"lit": [node.id], "dim": state["written"][:-1]},
              q_marks={"lit": [0], "good": [back - 2, back - 1]}, data_marks={"good": [i]}, moves=moves)
        queue.popleft()

    data = ",".join(parts)
    state["phase"] = "read"
    state["written"] = [n["id"] for n in tree["nodes"]]

    # deserialize
    if parts[0] == "#":
        frame({"en": f"serialize wrote \"{data}\". deserialize reads the first token, #: the root is null, so the "
                     f"rebuilt tree is empty too, and the answer is [].",
               "ko": f"serialize가 \"{data}\" 문자열을 썼습니다. deserialize가 읽은 첫 토큰이 # 표시라서 root가 null이므로 "
                     f"복원한 트리도 비어 있고, 답은 []입니다."},
              data_marks={"path": [0]}, answer="[]")
        return "[]"
    top = copy.add(int(parts[0]), id=0)
    copy_val[top] = int(parts[0])
    queue = deque([top])
    frame({"en": f"serialize wrote \"{data}\". deserialize makes the root {parts[0]} from the first token and puts "
                 f"it in the queue.",
           "ko": f"serialize가 \"{data}\" 문자열을 썼습니다. deserialize는 첫 토큰 {josa(int(parts[0]), '(으)로')} root "
                 f"노드를 만들어 큐에 넣습니다."},
          data_marks={"lit": [0]}, copy_marks={"good": [top]}, q_marks={"good": [0]},
          moves=[move(at("data", 0), at("copy", top)), move(at("copy", top), at("queue", 0))])
    i = 1
    while queue:
        node = queue[0]
        made, moves = [], []
        for k in (0, 1):
            tok = parts[i + k]
            if tok != "#":
                kid = copy.add(int(tok), parent=node, slot=k, id=i + k)
                copy_val[kid] = int(tok)
                queue.append(kid)
                made.append(kid)
                moves += [move(at("data", i + k), at("copy", kid)), move(at("copy", kid), at("queue", len(queue) - 1))]
        left, right = parts[i], parts[i + 1]
        said = []
        for (en, ko), tok in zip(SIDES, (left, right)):
            said.append(({"en": f"no {en} child", "ko": f"{ko} 자식 없음"} if tok == "#" else
                         {"en": f"{en} child {tok}", "ko": f"{ko} 자식 {tok}"}))
        joined = len(made)
        tail = ({"en": "; nothing joins the queue.", "ko": ". 큐에 들어가는 것은 없습니다."} if not joined else
                {"en": f"; {plural(joined, 'it joins', 'they join')} the queue.",
                 "ko": f". 새 노드를 큐에 넣습니다."})
        frame({"en": f"Take {copy_val[node]} from the front: the next two tokens, {left} and {right}, are its children: "
                     f"{said[0]['en']}, {said[1]['en']}{tail['en']}",
               "ko": f"맨 앞의 {copy_val[node]} 값을 꺼내 다음 두 토큰 {left}, {right} 토큰을 자식으로 읽습니다: "
                     f"{said[0]['ko']}, {said[1]['ko']}{tail['ko']}"},
              data_marks={"lit": [i, i + 1]}, copy_marks={"lit": [node], "good": made},
              q_marks={"lit": [0], "good": list(range(len(queue) - joined, len(queue)))}, moves=moves or None)
        queue.popleft()
        i += 2

    class Node:
        def __init__(self, val):
            self.val, self.left, self.right = val, None, None
    built = {n["id"]: Node(n["value"]) for n in copy.nodes}
    for e in copy.edges:
        setattr(built[e["from"]], "right" if e["slot"] else "left", built[e["to"]])
    printed = driver_list(tree_values(built[0]))
    frame({"en": f"Every token is read and the queue is empty. The rebuilt tree is {printed}, the same as root in "
                 f"shape and in every value.",
           "ko": f"토큰을 모두 읽어 큐가 비었습니다. 복원한 트리는 모양과 모든 값이 root와 같은 {printed}입니다."},
          root_marks={}, copy_marks={"path": [n["id"] for n in copy.nodes]}, answer=printed)
    return printed


for number, sample in enumerate(sample_cases(SLUG), start=1):
    values = json.loads(sample["input"])
    run = sample_run(wt, number, sample, input=f"root = {driver_list(values)}", setup={"root": level_order_tree(values)})
    solve(values, run)
wt.write(walkthrough_path(SLUG))
