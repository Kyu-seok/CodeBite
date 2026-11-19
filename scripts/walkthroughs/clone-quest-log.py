#!/usr/bin/env python3.12
"""clone-quest-log's Walkthrough: the reference solution (scripts/replay-solutions/clone-quest-log.py), a map from
each original node to its copy. The first pass makes one copy per node with no links; the second sets each copy's next
and then its related, one assignment per frame, to copies.get() of whatever the original's reach, so no copy points
back into the original.

The log is a `linkedlist` with each node's `related` as its second link, drawn under the row; the copies are a list of
their own, each at its original's position, so copies[node] is the copy at the same position and a lookup shows as
the same position lit in both rows. A copy's links are drawn once the second pass sets them (Node(val) starts with
both null). The answer is the copy read as the Driver prints it, each related as a position.

    CODEBITE_DB=<database> scripts/walkthroughs/clone-quest-log.py

writes common/src/main/resources/walkthroughs/clone-quest-log.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import driver_list, plural, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, linked_list, move, node_id  # noqa: E402

SLUG = "clone-quest-log"

wt = Walkthrough(
    {"en": "Clone the Quest Log", "ko": "퀘스트 로그 복제"},
    {"en": "A copy's related can reach a node that has no copy yet, so make every copy first, keeping a map from each "
           "original to its copy; then each copy's next and related are the copies of the nodes the original's reach.",
     "ko": "사본의 related는 아직 사본이 없는 노드를 가리킬 수 있으므로, 먼저 모든 노드의 사본을 만들어 원본마다 사본을 "
           "맵에 적어 둡니다. 그다음 사본의 next와 related를 원본의 next와 related가 가리키는 노드의 사본으로 정합니다."},
    views=[
        {"id": "log", "type": "linkedlist",
         "title": {"en": "original log: next above, related below", "ko": "원본 로그: 위는 next, 아래는 related"}},
        {"id": "copy", "type": "linkedlist",
         "title": {"en": "copies[node], at its original's position", "ko": "copies[node], 원본과 같은 위치"},
         "empty": {"en": "no copies yet", "ko": "아직 사본 없음"}},
        {"id": "result", "type": "output", "title": {"en": "printed copy", "ko": "출력한 사본"},
         "empty": {"en": "not read yet", "ko": "아직 읽지 않음"}},
    ],
)


class Node:
    def __init__(self, val=0, next=None, related=None):
        self.val = val
        self.next = next
        self.related = related


def solve(pairs, run):
    """The Driver's list and the reference cloneQuestLog. Returns the printed copy."""
    order = [Node(v) for v, _ in pairs]
    for a, b in zip(order, order[1:]):
        a.next = b
    for node, (_, r) in zip(order, pairs):
        if r is not None:
            node.related = order[r]
    copies = {}
    made = []  # the copies in the order they were made: each one's position is its original's
    linked = {"next": set(), "related": set()}  # the copies whose next / related the second pass has set
    result = []

    def frame(caption, log_marks=None, log_links=None, copy_marks=None, copy_links=None, moves=None, **answer):
        log = {**linked_list(order, link="related"), "marks": log_marks or {}}
        if log_links:
            log["linkMarks"] = log_links
        full = linked_list(made, link="related")
        copy = {"nodes": full["nodes"], "next": {i: t for i, t in full["next"].items() if i in linked["next"]},
                "links": {"related": {i: t for i, t in full["links"]["related"].items() if i in linked["related"]}},
                "marks": copy_marks or {}}
        if copy_links:
            copy["linkMarks"] = copy_links
        run.frame(caption, log=log, copy=copy,
                  result={"values": list(result), "marks": {"path": list(range(len(result)))}}, moves=moves, **answer)

    set_related = sum(1 for n in order if n.related is not None)
    frame({"en": f"The log has {len(order)} {plural(len(order), 'node', 'nodes')}, {set_related} of them with a related "
                 f"pointer (the arrows under the row). copies is an empty map.",
           "ko": f"로그에는 노드가 {len(order)}개 있고, 그중 {set_related}개에 related 포인터(아래쪽 화살표)가 있습니다. "
                 f"맵 copies는 비어 있습니다."})
    node = order[0] if order else None
    i = 0
    while node:
        copies[node] = Node(node.val)
        made.append(copies[node])
        frame({"en": f"First pass: copies[node {i}] = a new node with value {node.val} and no links yet.",
               "ko": f"첫 번째 순회: copies[{i}번 노드]에 값 {node.val}의 새 노드를 링크 없이 넣습니다."},
              log_marks={"lit": [i]}, copy_marks={"good": [i]}, moves=[move(at("log", i), at("copy", i))])
        node = node.next
        i += 1
    for i, (original, copy) in enumerate(copies.items()):
        for link in ("next", "related"):
            target = getattr(original, link)
            setattr(copy, link, copies.get(target))
            linked[link].add(i)
            j = node_id(order, target)
            key = i if link == "next" else ["related", i]
            if j is None:
                caption = {"en": f"Node {i}'s {link} is null, and copies.get(null) is null, so copy {i}'s {link} is "
                                 f"null too.",
                           "ko": f"{i}번 노드의 {link} 포인터가 null이고 copies.get(null)도 null이므로, {i}번 사본의 {link} 포인터도 "
                                 f"null입니다."}
                lit = [i]
            else:
                reached = {"en": "itself", "ko": "자기 자신을"} if j == i else {"en": f"node {j}", "ko": f"{j}번 노드를"}
                caption = {"en": f"Node {i}'s {link} reaches {reached['en']}, so copy {i}'s {link} is "
                                 f"copies[node {j}], the copy at position {j}, never the original.",
                           "ko": f"{i}번 노드의 {link} 포인터가 {reached['ko']} 가리키므로, {i}번 사본의 {link} 포인터는 "
                                 f"원본이 아니라 같은 위치의 사본 copies[{j}번 노드]입니다."}
                lit = sorted({i, j})
            frame(caption, log_marks={"lit": lit}, log_links={"lit": [key]},
                  copy_marks={"lit": [j]} if j is not None and j != i else {}, copy_links={"good": [key]})
    head = copies.get(order[0]) if order else None
    node = head
    while node:
        result.append(driver_list([node.val, node_id(made, node.related)]))
        node = node.next
    printed = "[" + ",".join(result) + "]"
    frame({"en": f"Every copy is linked. Read from copies[head], each related written as a position, the copy prints "
                 f"{printed}, the same as the log.",
           "ko": f"모든 사본이 이어졌습니다. copies[head]부터 읽어 related를 위치로 적으면 원본과 같은 "
                 f"{printed}입니다."},
          log_marks={"dim": list(range(len(order)))}, copy_marks={"path": list(range(len(made)))},
          moves=[move(at("copy", k), at("result", k), value=result[k]) for k in range(len(result))], answer=printed)
    return printed


for number, sample in enumerate(sample_cases(SLUG), start=1):
    pairs = json.loads(sample["input"])
    run = sample_run(wt, number, sample, input=f"head = {sample['input']}")
    solve(pairs, run)
wt.write(walkthrough_path(SLUG))
