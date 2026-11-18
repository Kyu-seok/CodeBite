#!/usr/bin/env python3.12
"""detect-portal-loop's Walkthrough: the reference solution (scripts/replay-solutions/detect-portal-loop.py),
Floyd's slow and fast pointers, recording one frame per step of the pair on each sample Test Case. The rooms are a
linked list whose last room's arrow back to an earlier room is drawn under the row; slow steps one room, fast two,
and they land on the same room exactly when the chain loops.

    CODEBITE_DB=<database> scripts/walkthroughs/detect-portal-loop.py

writes common/src/main/resources/walkthroughs/detect-portal-loop.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import driver_list, josa, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, linked_list, node_id  # noqa: E402

SLUG = "detect-portal-loop"

wt = Walkthrough(
    {"en": "Detect Portal Loop", "ko": "포털 루프 감지"},
    {"en": "fast moves two rooms for slow's one: on a chain that ends, fast reaches the end; on a loop, fast gains one "
           "room a step on slow and must land on it.",
     "ko": "slow가 방 한 칸을 갈 때 fast는 두 칸을 갑니다. 끝이 있는 체인이면 fast가 끝에 닿고, 루프가 있으면 fast가 한 "
           "단계에 한 칸씩 slow를 따라잡아 결국 같은 방에 섭니다."},
    views=[{"id": "rooms", "type": "linkedlist", "title": {"en": "rooms from head", "ko": "head부터의 방들"},
            "empty": {"en": "no rooms", "ko": "방 없음"}}],
)


class ListNode:
    def __init__(self, val):
        self.val, self.next = val, None


def solve(values, pos, run):
    """Solution.hasPortalLoop with a frame per step. Returns the answer as the Driver prints it."""
    order = [ListNode(v) for v in values]
    for a, b in zip(order, order[1:]):
        a.next = b
    if pos >= 0 and order:
        order[-1].next = order[pos]
    head = order[0] if order else None

    def frame(caption, slow, fast, marks, **answer):
        run.frame(caption, rooms={**linked_list(order), "marks": marks,
                                  "pointers": {"slow": node_id(order, slow), "fast": node_id(order, fast)}}, **answer)

    if head is None:
        frame({"en": "There are no rooms: head is null, so there is nothing to loop. false.",
               "ko": "방이 없습니다. head가 null이므로 루프도 없습니다. 답은 false입니다."}, None, None, {}, answer="false")
        return "false"

    if pos >= 0:
        tail = {"en": f"the last room {order[-1].val} teleports back to {order[pos].val} (index {pos})",
                "ko": f"마지막 방 {order[-1].val}의 next가 인덱스 {pos}의 방 {josa(order[pos].val, '(으)로')} 되돌아갑니다"}
    else:
        tail = {"en": "the last room's next is null", "ko": "마지막 방의 next는 null입니다"}
    slow = fast = head
    frame({"en": f"slow and fast both start at the head {head.val}; {tail['en']}.",
           "ko": f"slow와 fast 모두 head {head.val}에서 시작합니다. {tail['ko']}."},
          slow, fast, {"lit": [0]})
    while fast and fast.next:
        slow, fast = slow.next, fast.next.next
        s, f = node_id(order, slow), node_id(order, fast)
        if slow is fast:
            frame({"en": f"slow steps to {slow.val} and fast jumps two to {fast.val}: they meet, so the chain loops. true.",
                   "ko": f"slow는 {josa(slow.val, '(으)로')} 한 칸, fast는 {josa(fast.val, '(으)로')} 두 칸 갑니다. 둘이 "
                         f"만났으니 루프가 있고, 답은 true입니다."},
                  slow, fast, {"path": [s]}, answer="true")
            return "true"
        if fast is not None:
            where = {"en": f"fast jumps two to {fast.val}", "ko": f"fast는 {josa(fast.val, '(으)로')} 두 칸 갑니다"}
        else:
            where = {"en": "fast jumps two, past the last room to null", "ko": "fast는 두 칸 가서 마지막 방을 지나 null이 됩니다"}
        frame({"en": f"slow steps to {slow.val}; {where['en']}.",
               "ko": f"slow는 {josa(slow.val, '(으)로')} 한 칸, {where['ko']}."},
              slow, fast, {"lit": [s] + ([f] if f is not None else [])})
    if fast is None:
        why = {"en": "fast is null", "ko": "fast가 null이므로"}
    else:
        why = {"en": f"fast is on the last room {fast.val}, whose next is null", "ko": f"fast가 선 마지막 방 {fast.val}의 next가 null이므로"}
    frame({"en": f"Now {why['en']}: the chain ends, so there is no loop. false.",
           "ko": f"{why['ko']} 체인이 끝납니다. 루프가 없으니 답은 false입니다."},
          slow, fast, {"dim": list(range(len(order)))}, answer="false")
    return "false"


for number, sample in enumerate(sample_cases(SLUG), start=1):
    lines = sample["input"].split("\n")
    values, pos = json.loads(lines[0]), int(lines[1])
    run = sample_run(wt, number, sample, input=f"head = {driver_list(values)}, pos = {pos}")
    solve(values, pos, run)
wt.write(walkthrough_path(SLUG))
