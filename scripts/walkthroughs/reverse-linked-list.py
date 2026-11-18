#!/usr/bin/env python3.12
"""reverse-linked-list's Walkthrough: the reference solution (scripts/replay-solutions/reverse-linked-list.py),
one pass with prev and curr turning each node's next back to prev, recording one frame per arrow turned and one
per step forward on each sample Test Case. The nodes keep their places in the row; only the arrows turn, the arrow
cut drawn faded beside the new one, and the reversed list is read into the answer at the end.

    CODEBITE_DB=<database> scripts/walkthroughs/reverse-linked-list.py

writes common/src/main/resources/walkthroughs/reverse-linked-list.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import driver_list, josa, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, linked_list, move, node_id  # noqa: E402

SLUG = "reverse-linked-list"

wt = Walkthrough(
    {"en": "Reverse Linked List", "ko": "연결 리스트 뒤집기"},
    {"en": "Nothing moves but the arrows: each step saves curr's next, turns curr's arrow back to prev, and steps both "
           "pointers forward, so the part up to prev is already reversed.",
     "ko": "노드는 그대로 두고 화살표만 돌립니다. 한 단계마다 curr의 next를 기억해 두고, curr의 화살표를 prev 쪽으로 돌린 뒤 "
           "두 포인터를 한 칸씩 옮기므로 prev까지는 이미 뒤집혀 있습니다."},
    views=[
        {"id": "list", "type": "linkedlist", "title": {"en": "head", "ko": "head (리스트)"},
         "empty": {"en": "empty list", "ko": "빈 리스트"}},
        {"id": "result", "type": "output", "title": {"en": "answer", "ko": "답"},
         "empty": {"en": "not read yet", "ko": "아직 없음"}},
    ],
)


class ListNode:
    def __init__(self, val):
        self.val, self.next = val, None


def solve(values, run):
    """Solution.reverseList with a frame per step. Returns the answer as the Driver prints it."""
    order = [ListNode(v) for v in values]
    for a, b in zip(order, order[1:]):
        a.next = b
    head = order[0] if order else None

    def frame(caption, prev, curr, nxt=None, marks=None, link=None, cut=None, moves=None, result=(), **answer):
        pointers = {"prev": node_id(order, prev), "curr": node_id(order, curr)}
        if nxt is not None:
            pointers["next"] = node_id(order, nxt)
        state = {**linked_list(order), "pointers": pointers, "marks": marks or {}}
        if link is not None:
            state["linkMarks"] = {"good": [node_id(order, link)]}
        if cut is not None:
            state["cut"] = {node_id(order, cut[0]): node_id(order, cut[1])}
        run.frame(caption, list=state, result={"values": list(result), "marks": {"path": list(range(len(result)))}},
                  moves=moves, **answer)

    if head is None:
        frame({"en": "The list is empty: head is null, and its reverse is the empty list.",
               "ko": "리스트가 비어 있습니다. head가 null이므로 뒤집어도 빈 리스트입니다."}, None, None, answer="[]")
        return "[]"

    n = len(order)
    if n == 1:
        start = {"en": f"One node, {head.val}, whose arrow points to null. prev starts as null and curr at the head {head.val}.",
                 "ko": f"노드는 {head.val} 하나이고 화살표는 null을 가리킵니다. prev는 null, curr는 head {head.val}에서 시작합니다."}
    else:
        start = {"en": f"{n} nodes from {head.val} to {order[-1].val}. prev starts as null and curr at the head {head.val}; "
                       f"every arrow still points right.",
                 "ko": f"노드 {n}개가 {head.val}에서 {order[-1].val}까지 이어집니다. prev는 null, curr는 head {head.val}에서 "
                       f"시작하며 화살표는 아직 모두 오른쪽을 가리킵니다."}
    frame(start, None, head, marks={"lit": [0]})
    prev, curr = None, head
    while curr:
        nxt = curr.next
        curr.next = prev
        back = "null" if prev is None else str(prev.val)
        if nxt is None:
            saved = {"en": "next = null (the last node)", "ko": "next = null을"}
        else:
            saved = {"en": f"next = {nxt.val}", "ko": f"next = {josa(nxt.val, '을를')}"}
        if prev is None:
            turned = {"en": f"turn {curr.val}'s arrow to prev, which is null: {curr.val} will be the tail.",
                      "ko": f"{curr.val}의 화살표를 prev(null) 쪽으로 돌립니다. {josa(curr.val, '이가')} 꼬리가 됩니다."}
        else:
            turned = {"en": f"turn {curr.val}'s arrow back to prev ({back}).",
                      "ko": f"{curr.val}의 화살표를 prev({back}) 쪽으로 돌립니다."}
        frame({"en": f"Save {saved['en']}, then {turned['en']}",
               "ko": f"{saved['ko']} 기억해 두고, {turned['ko']}"},
              prev, curr, nxt, marks={"lit": [node_id(order, curr)]}, link=curr,
              cut=(curr, nxt) if nxt is not None else None,
              moves=[move(at("list", node_id(order, curr)), at("list", node_id(order, prev)), value="next")] if prev else None)
        prev, curr = curr, nxt
        if curr:
            frame({"en": f"Step forward: prev = {prev.val}, curr = {curr.val}. Everything up to {prev.val} is reversed.",
                   "ko": f"한 칸 나아가 prev = {prev.val}, curr = {josa(curr.val, '이가')} 됩니다. {prev.val}까지는 뒤집혔습니다."},
                  prev, curr, marks={"lit": [node_id(order, curr)]})
    result, node = [], prev
    while node:
        result.append(node.val)
        node = node.next
    printed = driver_list(result)
    if n == 1:
        last = {"en": f"curr ran off the end, so prev ({prev.val}) is the new head: one node reads the same, {printed}.",
                "ko": f"curr가 끝을 지나갔으므로 prev({prev.val})가 새 head입니다. 노드 하나는 뒤집어도 {printed}입니다."}
    else:
        last = {"en": f"curr ran off the end, so prev ({prev.val}) is the new head: reading from it gives {printed}.",
                "ko": f"curr가 끝을 지나갔으므로 prev({prev.val})가 새 head입니다. 여기서부터 읽으면 {printed}입니다."}
    frame(last, prev, None, marks={"path": list(range(n))}, result=result,
          moves=[move(at("list", node_id(order, nd)), at("result", i)) for i, nd in enumerate(reversed(order))],
          answer=printed)
    return printed


for number, sample in enumerate(sample_cases(SLUG), start=1):
    values = json.loads(sample["input"])
    run = sample_run(wt, number, sample, input=f"head = {driver_list(values)}")
    solve(values, run)
wt.write(walkthrough_path(SLUG))
