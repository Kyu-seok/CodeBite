#!/usr/bin/env python3.12
"""shortest-table-booking's Walkthrough: the reference solution (scripts/replay-solutions/shortest-table-booking.py),
an offline sweep that answers the probes in time order, pushing each booking onto a min-heap of (length, end) once it
has started and popping the top while it is already over, recording one frame per probe picked, booking pushed,
booking popped and answer written, on each sample Test Case.

The bookings by start and the heap are two groups on one number line: the heap is drawn as its pop order, shortest
first, so its top is the first row and an over booking leaves from there. The probe minute is the one point on the
axis; the probes and the answers aligned with them are arrays, the answer moving in from the heap's top.

    CODEBITE_DB=<database> scripts/walkthroughs/shortest-table-booking.py

writes common/src/main/resources/walkthroughs/shortest-table-booking.json.
"""
import heapq
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import driver_list, josa, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move  # noqa: E402

SLUG = "shortest-table-booking"
BOOKINGS, STARTED = 0, 1
PROBE = {"en": "probe", "ko": "조회 시점"}
LABELS = [{"en": "bookings, by start", "ko": "시작 순으로 정렬한 예약"},
          {"en": "started (heap), shortest first", "ko": "시작한 예약 (힙, 짧은 순)"}]

wt = Walkthrough(
    {"en": "Shortest Table Booking", "ko": "가장 짧은 예약 찾기"},
    {"en": "Answer the probes in time order. Before each one, add every booking that has started to a heap keyed by "
           "length, then drop the shortest while it is already over: what stays on top is the shortest booking "
           "covering the minute.",
     "ko": "조회 시점을 시간 순으로 처리합니다. 각 시점마다 이미 시작한 예약을 길이 기준 힙에 넣고, 가장 짧은 예약이 "
           "이미 끝났으면 꺼냅니다. 그러면 힙의 맨 위가 그 분을 포함하는 가장 짧은 예약입니다."},
    views=[
        {"id": "probes", "type": "array", "title": {"en": "probes", "ko": "probes (조회 시점)"}},
        {"id": "line", "type": "intervals", "empty": {"en": "empty", "ko": "비어 있음"}},
        {"id": "answers", "type": "array", "title": {"en": "answers", "ko": "answers (답)"}},
    ],
)


def solve(intervals, queries, run):
    """Solution.findTightestBooking with a frame per step. Returns the answer as the Driver prints it."""
    bookings = sorted(intervals)
    answers = [-1] * len(queries)
    started = []  # the solution's heap of (length, end)
    drawn = []    # the heap as drawn: (length, end, start) in pop order
    next_booking = 0
    done = []     # probe indexes answered

    def frame(caption, now=None, minute=None, b_marks=None, s_marks=None, a_marks=None, moves=None, **answer):
        p_marks = {"dim": list(done)}
        if now is not None:
            p_marks["lit"] = [now]
        line = {"groups": [{"label": LABELS[BOOKINGS], "intervals": bookings,
                            "marks": {"dim": list(range(next_booking)), **(b_marks or {})}},
                           {"label": LABELS[STARTED], "intervals": [[s, e] for _, e, s in drawn],
                            "marks": s_marks or {}}]}
        if minute is not None:
            line["points"] = [{"at": minute, "label": PROBE, "mark": "lit"}]
        run.frame(caption, probes={"values": queries, "pointers": {"now": now}, "marks": p_marks}, line=line,
                  answers={"values": answers, "marks": a_marks or {}}, moves=moves, **answer)

    frame({"en": f"{len(bookings)} bookings sorted by start, and {len(queries)} probes, each answer starting at -1. "
                 "Take the probes in time order, so a booking that starts only has to be added once.",
           "ko": f"예약 {len(bookings)}개를 시작 순으로 정렬하고, 조회 시점 {len(queries)}개의 답은 모두 -1로 시작합니다. "
                 "조회 시점을 시간 순으로 처리하면 시작한 예약을 한 번씩만 넣으면 됩니다."})
    for index in sorted(range(len(queries)), key=queries.__getitem__):
        minute = queries[index]
        frame({"en": f"The earliest probe left is minute {minute}, probe {index}.",
               "ko": f"남은 조회 시점 중 가장 이른 것은 {index}번, {minute}분입니다."}, now=index, minute=minute)
        while next_booking < len(bookings) and bookings[next_booking][0] <= minute:
            start, end = bookings[next_booking]
            length = end - start + 1
            heapq.heappush(started, (length, end))
            drawn.append((length, end, start))
            drawn.sort()
            pos = drawn.index((length, end, start))
            b = next_booking
            next_booking += 1
            frame({"en": f"{driver_list([start, end])} starts at {start} ≤ {minute}: push it onto the heap with its "
                         f"length, {end} - {start} + 1 = {length}.",
                   "ko": f"{driver_list([start, end])} 예약은 {start}분에 시작해 {minute}분 이전이므로 힙에 넣습니다. "
                         f"길이는 {end} - {start} + 1 = {josa(length, '이가')} 됩니다."},
                  now=index, minute=minute, b_marks={"lit": [b]}, s_marks={"good": [pos]},
                  moves=[move(at("line", [BOOKINGS, b]), at("line", [STARTED, pos]))])
        while started and started[0][1] < minute:
            length, end = heapq.heappop(started)
            start = drawn[0][2]
            frame({"en": f"The shortest on the heap, {driver_list([start, end])}, ended at {end} < {minute}: it can't "
                         "cover this probe or any later one, so pop it.",
                   "ko": f"힙에서 가장 짧은 {driver_list([start, end])} 예약은 {end}분에 끝나 {minute}분보다 앞이므로 "
                         "이 시점도, 이후 시점도 포함할 수 없습니다. 힙에서 꺼냅니다."},
                  now=index, minute=minute, s_marks={"bad": [0]},
                  moves=[move(at("line", [STARTED, 0]), mark="bad")])
            drawn.pop(0)
        if started:
            length, end = started[0]
            start = drawn[0][2]
            answers[index] = length
            done.append(index)
            frame({"en": f"The top, {driver_list([start, end])}, has started and isn't over, so it covers minute "
                         f"{minute} and nothing on the heap is shorter: answer {length}.",
                   "ko": f"맨 위의 {driver_list([start, end])} 예약은 시작했고 아직 끝나지 않았으므로 {minute}분을 "
                         f"포함하며, 힙에 이보다 짧은 예약은 없습니다. 답은 {length}입니다."},
                  now=index, minute=minute, s_marks={"path": [0]}, a_marks={"good": [index]},
                  moves=[move(at("line", [STARTED, 0]), at("answers", index), value=str(length))])
        else:
            done.append(index)
            frame({"en": f"The heap is empty: no booking that has started is still going at minute {minute}, so the "
                         "answer stays -1.",
                   "ko": f"힙이 비었습니다. 시작한 예약 중 {minute}분까지 이어지는 예약이 없으므로 답은 -1 그대로입니다."},
                  now=index, minute=minute, a_marks={"bad": [index]})
    answer = driver_list(answers)
    frame({"en": f"Every probe is answered, in the order given: {answer}.",
           "ko": f"모든 조회 시점의 답을 원래 순서대로 구했습니다: {answer}."},
          a_marks={"path": list(range(len(answers)))}, answer=answer)


for number, sample in enumerate(sample_cases(SLUG), start=1):
    intervals_line, queries_line = sample["input"].split("\n")
    intervals, queries = json.loads(intervals_line), json.loads(queries_line)
    values = [v for b in intervals for v in b] + queries
    run = sample_run(wt, number, sample, input=f"bookings = {intervals_line}, probes = {queries_line}",
                     setup={"line": {"domain": [min(values), max(values)]}})
    solve(intervals, queries, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
