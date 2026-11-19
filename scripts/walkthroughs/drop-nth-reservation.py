#!/usr/bin/env python3.12
"""drop-nth-reservation's Walkthrough: the reference solution (scripts/replay-solutions/drop-nth-reservation.py), a
dummy node before the head and two pointers, lead and trail, recording one frame per step on each sample Test Case:
lead walks n bookings ahead alone, then both walk together until lead is on the last booking, which leaves trail just
before the n-th from the end, and trail's arrow is re-pointed past it. The list read from dummy.next is the answer.

    CODEBITE_DB=<database> scripts/walkthroughs/drop-nth-reservation.py

writes common/src/main/resources/walkthroughs/drop-nth-reservation.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import ListNode, driver_list, josa, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, linked_list, move, node_id  # noqa: E402

SLUG = "drop-nth-reservation"

wt = Walkthrough(
    {"en": "Drop the Nth Reservation", "ko": "뒤에서 N번째 예약 취소"},
    {"en": "lead walks n bookings ahead of trail, then both walk together. When lead stands on the last booking, trail "
           "is just before the n-th from the end, so one arrow re-pointed past it drops it. A dummy node before the "
           "head lets trail stand before the first booking too.",
     "ko": "lead가 trail보다 예약 n개만큼 먼저 간 뒤, 둘이 함께 나아갑니다. lead가 마지막 예약에 서면 trail은 뒤에서 n번째 "
           "예약 바로 앞에 있으므로, 화살표 하나를 그 예약 너머로 돌리면 취소됩니다. head 앞의 dummy 노드 덕분에 trail은 첫 "
           "예약 앞에도 설 수 있습니다."},
    views=[
        {"id": "bookings", "type": "linkedlist", "title": {"en": "bookings from dummy", "ko": "dummy부터의 예약"},
         "empty": {"en": "no bookings", "ko": "예약 없음"}},
        {"id": "result", "type": "output", "title": {"en": "answer", "ko": "답"},
         "empty": {"en": "not read yet", "ko": "아직 없음"}},
        {"id": "state", "type": "vars"},
    ],
)


def solve(values, n, run):
    """Solution.dropTailBooking with a frame per step. Returns the answer as the Driver prints it."""
    nodes = [ListNode(v) for v in values]
    for a, b in zip(nodes, nodes[1:]):
        a.next = b
    dummy = ListNode("")  # the solution's dummy holds 0; its value is never read, so it is drawn empty
    dummy.next = nodes[0] if nodes else None
    order = [dummy] + nodes
    ptr = {"dummy": dummy, "trail": dummy, "lead": dummy}

    def nid(node):
        return node_id(order, node)

    def frame(caption, marks, link=None, cut=None, moves=None, result=(), **answer):
        state = {**linked_list(order), "pointers": {k: nid(v) for k, v in ptr.items()}, "marks": marks}
        if link is not None:
            state["linkMarks"] = {"good": [nid(link)]}
        if cut is not None:
            state["cut"] = {nid(cut[0]): nid(cut[1])}
        run.frame(caption, bookings=state,
                  result={"values": list(result), "marks": {"path": list(range(len(result)))}},
                  state={"items": [{"label": "n", "value": n}]}, moves=moves, **answer)

    def name(node):
        return "dummy" if node is dummy else str(node.val)

    if len(nodes) == 1:
        books = {"en": f"One booking, {nodes[0].val}", "ko": f"예약은 {nodes[0].val} 하나뿐이고"}
    else:
        books = {"en": f"{len(nodes)} bookings from {nodes[0].val} to {nodes[-1].val}",
                 "ko": f"예약 {len(nodes)}개가 {nodes[0].val}부터 {nodes[-1].val}까지 있고"}
    frame({"en": f"{books['en']}, and n = {n}. dummy goes before the head, and lead and trail both start there.",
           "ko": f"{books['ko']} n = {n}입니다. head 앞에 dummy를 두고, lead와 trail 모두 거기서 시작합니다."},
          {"lit": [0]})
    lead = trail = dummy
    for step in range(1, n + 1):
        lead = lead.next
        ptr["lead"] = lead
        if step < n:
            more = {"en": f"{n - step} more to go.", "ko": f"{n - step}칸 더 갑니다."}
        else:
            more = {"en": f"lead is now {n} ahead of trail.", "ko": f"이제 lead가 trail보다 {n}칸 앞섭니다."}
        frame({"en": f"lead steps alone to {lead.val} ({step} of {n}); {more['en']}",
               "ko": f"lead만 {josa(lead.val, '(으)로')} 한 칸 갑니다({step}/{n}). {more['ko']}"},
              {"lit": [nid(lead)]})
    while lead.next:
        lead, trail = lead.next, trail.next
        ptr.update(lead=lead, trail=trail)
        frame({"en": f"lead.next is not null, so both step: lead to {lead.val}, trail to {trail.val}, still {n} apart.",
               "ko": f"lead.next가 null이 아니므로 둘 다 한 칸 갑니다. lead는 {josa(lead.val, '(으)로')}, trail은 "
                     f"{josa(trail.val, '(으)로')} 가며 간격은 그대로 {n}칸입니다."},
              {"lit": [nid(lead), nid(trail)]})
    gone = trail.next
    after = gone.next
    trail.next = gone.next
    if after is None:
        to = {"en": "null", "ko": "null을"}
    else:
        to = {"en": str(after.val), "ko": josa(after.val, "을를")}
    frame({"en": f"lead is on the last booking, so trail.next = {gone.val} is {n} from the end. trail.next = "
                 f"trail.next.next: {name(trail)} now points to {to['en']}, past {gone.val}.",
           "ko": f"lead가 마지막 예약에 섰으므로 trail.next인 {josa(gone.val, '이가')} 뒤에서 {n}번째입니다. "
           f"trail.next = trail.next.next로 {name(trail)}의 화살표가 예약 {gone.val} 너머 {to['ko']} 가리킵니다."},
          {"bad": [nid(gone)], "lit": [nid(trail)]}, link=trail, cut=(trail, gone))
    result, node, chain = [], dummy.next, []
    while node:
        result.append(node.val)
        chain.append(node)
        node = node.next
    printed = driver_list(result)
    ptr = {"dummy": dummy}
    if result:
        last = {"en": f"Reading from dummy.next skips {gone.val} and gives {printed}.",
                "ko": f"dummy.next부터 읽으면 예약 {josa(gone.val, '이가')} 빠진 {printed}입니다."}
    else:
        last = {"en": f"dummy.next is null now, so the schedule is empty: {printed}.",
                "ko": f"이제 dummy.next가 null이므로 스케줄이 비었습니다. 답은 {printed}입니다."}
    frame(last, {"path": [nid(c) for c in chain], "dim": [0, nid(gone)]}, result=result,
          moves=[move(at("bookings", nid(c)), at("result", i)) for i, c in enumerate(chain)], answer=printed)
    return printed


for number, sample in enumerate(sample_cases(SLUG), start=1):
    lines = sample["input"].split("\n")
    values, n = json.loads(lines[0]), int(lines[1])
    run = sample_run(wt, number, sample, input=f"head = {driver_list(values)}, n = {n}")
    solve(values, n, run)
wt.write(walkthrough_path(SLUG))
