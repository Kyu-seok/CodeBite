#!/usr/bin/env python3.12
"""split-tickets-into-equal-sums' Walkthrough: the reference solution
(scripts/replay-solutions/split-tickets-into-equal-sums.py), a set of every sum some of the tickets seen so far
add up to, recording one frame per ticket on each sample Test Case.

The set is drawn in the order its sums went in. Each ticket adds itself to every sum already there; each sum that
is new moves in from the sum it was built on (`3+2`). The tracer keeps the tickets behind each sum, so the last
frame, which looks up half the total, marks the tickets of one group `path`. No sample has an odd total, so an
extra run shows the early return.

    CODEBITE_DB=<database> scripts/walkthroughs/split-tickets-into-equal-sums.py

writes common/src/main/resources/walkthroughs/split-tickets-into-equal-sums.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import josa, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move, probe  # noqa: E402

SLUG = "split-tickets-into-equal-sums"

wt = Walkthrough(
    {"en": "Split Tickets into Equal Sums", "ko": "티켓을 합이 같은 두 그룹으로 나누기"},
    {"en": "Two equal groups each sum to half the total, so the question is whether some tickets add up to half. "
           "Keep every sum some of the tickets seen so far reach: each ticket adds itself to every one of them.",
     "ko": "합이 같은 두 그룹은 각각 전체 합의 절반이므로, 몇 장의 티켓으로 절반을 만들 수 있는지가 문제입니다. "
           "지금까지 본 티켓 일부로 만들 수 있는 합을 모두 모아 두고, 티켓마다 그 합 각각에 자기 점수를 더합니다."},
    views=[
        {"id": "tickets", "type": "array", "title": {"en": "tickets", "ko": "tickets (티켓 점수)"}},
        {"id": "reachable", "type": "set",
         "title": {"en": "reachable sums", "ko": "reachable (만들 수 있는 합)"},
         "hit": {"en": "reachable", "ko": "만들 수 있음"}, "miss": {"en": "not reachable", "ko": "만들 수 없음"}},
        {"id": "state", "type": "vars"},
    ],
)


def solve(tickets, run):
    """Solution.canSplitEqually with a frame per ticket."""
    n = len(tickets)
    total = sum(tickets)
    order = [0]  # the set's members in the order they went in
    behind = {0: []}  # sum -> the ticket indexes it was first built from

    def frame(caption, i=None, unread=None, ticket_marks=None, set_marks=None, probes=(), moves=None, **answer):
        items = [{"label": {"en": "total", "ko": "total (전체 합)"}, "value": total}]
        if total % 2 == 0:
            items.append({"label": {"en": "half", "ko": "half (절반)"}, "value": total // 2})
        run.frame(caption,
                  tickets={"values": tickets, "pointers": {"i": i}, "marks": ticket_marks or {},
                           "unread": list(range(n)) if unread is None else unread},
                  reachable={"members": list(order), "marks": set_marks or {}, "probes": list(probes)},
                  state={"items": items}, moves=moves, **answer)

    if total % 2:
        frame({"en": f"The tickets add up to {total}, which is odd, so no two groups can have equal sums.",
               "ko": f"티켓 합이 {josa(total, '이가')} 홀수이므로 합이 같은 두 그룹으로 나눌 수 없습니다."},
              ticket_marks={"lit": list(range(n))}, unread=[])
        frame({"en": "The solution returns false before building any sums. Answer: false.",
               "ko": "합을 만들어 보기도 전에 false를 반환합니다. 답은 false입니다."},
              ticket_marks={"bad": list(range(n))}, unread=[], answer="false")
        return
    half = total // 2
    frame({"en": f"The tickets add up to {total}, so each group must sum to {half}. Before any ticket, the only "
                 "reachable sum is 0, the empty group.",
           "ko": f"티켓 합이 {total}이므로 각 그룹의 합은 {josa(half, '이가')} 되어야 합니다. 아직 티켓을 보지 "
                 "않았으니 만들 수 있는 합은 빈 그룹의 0뿐입니다."},
          set_marks={"good": [0]})
    for i, ticket in enumerate(tickets):
        seen = list(order)
        new = []
        for s in seen:
            t = s + ticket
            if t not in behind and t not in new:
                new.append(t)
                behind[t] = behind[s] + [i]
                order.append(t)
        moves = [move(at("reachable", t - ticket), at("reachable", t), value=f"{t - ticket}+{ticket}") for t in new]
        new_en = ", ".join(map(str, new))
        if new:
            caption = {"en": f"Ticket {i} is worth {ticket}: adding it to each of the {len(seen)} sums so far gives "
                             f"{len(new)} new: {new_en}.",
                       "ko": f"티켓 {i}의 점수는 {ticket}입니다. 지금까지의 합 {len(seen)}개 각각에 더하면 새로운 "
                             f"합 {len(new)}개가 생깁니다: {new_en}."}
        else:
            caption = {"en": f"Ticket {i} is worth {ticket}: adding it to each sum so far gives only sums already "
                             "there, so nothing new.",
                       "ko": f"티켓 {i}의 점수는 {ticket}입니다. 지금까지의 합에 더해도 이미 있는 합뿐이라 새로 "
                             "생기는 합이 없습니다."}
        frame(caption, i=i, unread=list(range(i + 1, n)), ticket_marks={"lit": [i]},
              set_marks={"good": new}, moves=moves)
    group = behind.get(half)
    if group is not None:
        picked = " + ".join(str(tickets[i]) for i in group)
        names = ", ".join(map(str, group))
        frame({"en": f"Is {half} reachable? Yes: tickets {names}, {picked} = {half}, form one group and the rest "
                     "the other. Answer: true.",
               "ko": f"{josa(half, '을를')} 만들 수 있을까요? 네, 티켓 {names}번의 {picked} = {half}로 한 그룹을, "
                     "나머지로 다른 그룹을 만듭니다. 답은 true입니다."},
              unread=[], ticket_marks={"path": group}, set_marks={"path": [half]},
              probes=[probe(half, hit=True, label={"en": f"{total} / 2 = {half}", "ko": f"{total} / 2 = {half}"})],
              answer="true")
    else:
        frame({"en": f"Is {half} reachable? No: no group of tickets adds up to {half}, so the tickets can't be "
                     "split evenly. Answer: false.",
               "ko": f"{josa(half, '을를')} 만들 수 있을까요? 아니요. 어떤 티켓 조합도 합이 {josa(half, '이가')} "
                     "되지 않으므로 똑같이 나눌 수 없습니다. 답은 false입니다."},
              unread=[],
              probes=[probe(half, hit=False, label={"en": f"{total} / 2 = {half}", "ko": f"{total} / 2 = {half}"})],
              answer="false")


for number, sample in enumerate(sample_cases(SLUG), start=1):
    tickets = json.loads(sample["input"])
    run = sample_run(wt, number, sample, input=f"tickets = {sample['input']}")
    solve(tickets, run)
extra = [1, 2, 4]
solve(extra, wt.run({"en": "Odd total", "ko": "홀수 합"}, input=f"tickets = {json.dumps(extra, separators=(',', ':'))}",
                    expected="false", extra=True))
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
