#!/usr/bin/env python3.12
"""can-attend-bookings' Walkthrough: the reference solution (scripts/replay-solutions/can-attend-bookings.py), sort the
bookings by start and compare each neighbouring pair, stopping at the first that overlaps, recording one frame per
pair on each sample Test Case.

The bookings as given and as sorted are two groups on one number line, so an unsorted list (example 3) shows each
booking moving to its place; the earlier booking's end, which the later one's start is compared with, is the one
point on the axis.

    CODEBITE_DB=<database> scripts/walkthroughs/can-attend-bookings.py

writes common/src/main/resources/walkthroughs/can-attend-bookings.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import driver_list, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move  # noqa: E402

SLUG = "can-attend-bookings"
GIVEN, SORTED = 0, 1
END = {"en": "end", "ko": "끝"}
LABELS = [{"en": "bookings", "ko": "bookings (예약)"},
          {"en": "sorted by start", "ko": "시작 순으로 정렬"}]

wt = Walkthrough(
    {"en": "Can Attend All Bookings", "ko": "테이블 예약 충돌 검사"},
    {"en": "Sort the bookings by start. Then a booking can only collide with the one right before it, so check "
           "each neighbouring pair: the earlier one must end by the time the later one starts.",
     "ko": "예약을 시작 시각 순으로 정렬합니다. 그러면 각 예약은 바로 앞 예약하고만 겹칠 수 있으므로, 이웃한 두 "
           "예약마다 앞 예약이 뒤 예약의 시작 시각까지 끝나는지 확인합니다."},
    views=[
        {"id": "line", "type": "intervals", "empty": {"en": "not sorted yet", "ko": "아직 정렬 전"}},
    ],
)


def solve(bookings, run):
    """Solution.verifyTableBookings with a frame per neighbouring pair. Returns the answer as the Driver prints it."""
    order = sorted(range(len(bookings)), key=lambda i: bookings[i])
    ordered = [bookings[i] for i in order]
    shown = []  # the sorted group as drawn: empty until the sort frame

    def frame(caption, given=None, srt=None, point=None, moves=None, **answer):
        line = {"groups": [{"label": LABELS[GIVEN], "intervals": bookings, "marks": given or {}},
                           {"label": LABELS[SORTED], "intervals": shown, "marks": srt or {}}]}
        if point is not None:
            line["points"] = [{"at": point[0], "label": point[1], "mark": point[2]}]
        run.frame(caption, line=line, moves=moves, **answer)

    n = len(bookings)
    frame({"en": f"{n} bookings for the one window table, in the order given.",
           "ko": f"창가 테이블 하나의 예약 {n}개가 주어진 순서대로 있습니다."}, given={"lit": list(range(n))})
    shown.extend(ordered)
    already = order == list(range(n))
    frame({"en": "Sort them by start: " + ("they are already in order, so each one keeps its place." if already else
                                           f"{', '.join(driver_list(b) for b in ordered)}."),
           "ko": "시작 시각 순으로 정렬합니다. " + ("이미 정렬되어 있어 순서가 그대로입니다." if already else
                                          f"{', '.join(driver_list(b) for b in ordered)} 순서가 됩니다.")},
          given={"dim": list(range(n))}, srt={"good": list(range(n))},
          moves=[move(at("line", [GIVEN, i]), at("line", [SORTED, j])) for j, i in enumerate(order)])
    for j in range(n - 1):
        earlier, later = ordered[j], ordered[j + 1]
        e, ln = driver_list(earlier), driver_list(later)
        end = END
        if earlier[1] <= later[0]:
            frame({"en": f"{e} ends at {earlier[1]} and {ln} starts at {later[0]}: {earlier[1]} ≤ {later[0]}, so the "
                         "table is free in time.",
                   "ko": f"{e} 예약은 {earlier[1]}분에 끝나고 {ln} 예약은 {later[0]}분에 시작합니다. "
                         f"{earlier[1]} ≤ {later[0]}이므로 테이블이 제때 빕니다."},
                  given={"dim": list(range(n))}, srt={"lit": [j, j + 1], "dim": list(range(j))},
                  point=(earlier[1], end, "lit"))
        else:
            frame({"en": f"{ln} starts at {later[0]}, before {e} ends at {earlier[1]}: the two parties collide, so "
                         "not every booking fits. Answer: false.",
                   "ko": f"{ln} 예약이 {later[0]}분에 시작하는데 {e} 예약은 {earlier[1]}분에야 끝나므로 두 팀이 "
                         "충돌합니다. 모든 예약을 받을 수 없으니 답은 false입니다."},
                  given={"dim": list(range(n))}, srt={"bad": [j, j + 1], "dim": list(range(j))},
                  point=(earlier[1], end, "bad"), answer="false")
            return
    frame({"en": "Every booking ends by the time the next one starts, so the table can host them all. Answer: true.",
           "ko": "모든 예약이 다음 예약이 시작하기 전에 끝나므로 테이블이 모든 예약을 받을 수 있습니다. 답은 true입니다."},
          given={"dim": list(range(n))}, srt={"path": list(range(n))}, answer="true")


for number, sample in enumerate(sample_cases(SLUG), start=1):
    bookings = json.loads(sample["input"])
    values = [v for b in bookings for v in b]
    run = sample_run(wt, number, sample, input=f"bookings = {sample['input']}",
                     setup={"line": {"domain": [min(values), max(values)]}})
    solve(bookings, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
