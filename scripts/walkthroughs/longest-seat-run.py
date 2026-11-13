#!/usr/bin/env python3.12
"""longest-seat-run's Walkthrough: the reference solution (scripts/replay-solutions/longest-seat-run.py),
a hash set walked from each run's first seat only, recording one frame per seat the loop visits on each
sample Test Case.

    CODEBITE_DB=<database> scripts/walkthroughs/longest-seat-run.py

writes common/src/main/resources/walkthroughs/longest-seat-run.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import josa, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough  # noqa: E402

SLUG = "longest-seat-run"

wt = Walkthrough(
    {"en": "Longest Seat Run", "ko": "가장 긴 좌석 구간"},
    {"en": "Put the seats in a hash set and count up only from a seat whose seat - 1 is missing: "
           "each run is walked once, from its first seat, so the whole scan is O(n).",
     "ko": "좌석을 해시 집합에 넣고, seat - 1이 없는 좌석에서만 위로 세어 나갑니다. 구간마다 첫 좌석에서 "
           "한 번만 걸으므로 전체가 O(n)입니다."},
    views=[
        {"id": "seats", "type": "array", "title": {"en": "seat set, in loop order", "ko": "좌석 집합 (순회 순서)"}},
        {"id": "state", "type": "vars"},
    ],
)


def solve(seat_ids, run):
    """Solution.longestSeatBlock with a frame per seat the loop visits. Returns the answer as the Driver prints it."""
    seats = set(seat_ids)
    order = list(seats)  # the order `for seat in seats` visits them
    at = {s: i for i, s in enumerate(order)}
    tags = {}
    runs = []  # "first–last" of every run walked so far
    longest = 0
    best = []

    def frame(caption, seat=None, lit=(), good=(), path=(), grew=False, **answer):
        run.frame(caption,
                  seats={"values": order, "pointers": {"seat": at[seat] if seat is not None else None},
                         "tags": [[at[s], t] for s, t in tags.items()],
                         "marks": {"lit": [at[s] for s in lit], "good": [at[s] for s in good],
                                   "path": [at[s] for s in path]}},
                  state={"items": [
                      {"label": {"en": "runs walked", "ko": "걸어 본 구간"}, "value": list(runs),
                       "empty": {"en": "none yet", "ko": "아직 없음"}},
                      {"label": {"en": "longest", "ko": "longest (최장 길이)"}, "value": longest, "mark": "good" if grew else None}]},
                  **answer)

    frame({"en": f"Put the {len(seat_ids)} seat ids in a hash set ({len(seats)} distinct), so asking "
                 f"\"is seat x free?\" takes O(1). Then visit each seat once.",
           "ko": f"좌석 번호 {len(seat_ids)}개를 해시 집합에 넣어(서로 다른 번호 {len(seats)}개) "
                 f"\"좌석 x가 비어 있나?\"를 O(1)에 확인합니다. 그다음 좌석을 하나씩 봅니다."})
    for seat in seats:
        if seat - 1 in seats:
            tags[seat] = {"en": "skip", "ko": "건너뜀"}
            frame({"en": f"Seat {seat}: seat {seat - 1} is in the set too, so {seat} is not the first seat of "
                         f"its run. Skip it; the walk from that run's first seat counts it.",
                   "ko": f"좌석 {seat}: 좌석 {seat - 1}도 집합에 있으니 좌석 {josa(seat, "은는")} 구간의 첫 좌석이 아니므로 "
                         f"건너뜁니다. 이 구간의 첫 좌석에서 걸을 때 함께 셉니다."},
                  seat=seat, lit=[seat, seat - 1])
            continue
        end = seat
        while end + 1 in seats:
            end += 1
        length = end - seat + 1
        walked = list(range(seat, end + 1))
        runs.append(f"{seat}–{end}" if end > seat else f"{seat}")
        tags[seat] = {"en": f"len {length}", "ko": f"길이 {length}"}
        grew = length > longest
        old = longest
        longest = max(longest, length)
        if grew:
            best = walked
        span = (f"{seat}, {seat + 1}, …, {end}" if length > 5 else ", ".join(map(str, walked)))
        if grew:
            en_end, ko_end = (f", which beats {old}, so longest is now {longest}.",
                              f"이전 최댓값 {old}보다 길어 이제 longest = {longest}입니다.")
        else:
            en_end, ko_end = (f", which does not beat {longest}.",
                              f"longest {longest}보다 길지 않습니다.")
        frame({"en": f"Seat {seat}: seat {seat - 1} is missing, so a run starts here. Counting up while the next "
                     f"seat is in the set gives {span}, length {length}" + en_end,
               "ko": f"좌석 {seat}: 좌석 {josa(seat - 1, "이가")} 없으므로 여기서 구간이 시작됩니다. 다음 좌석이 집합에 "
                     f"있는 동안 위로 세면 {span}, 길이 {josa(length, "(으)로")} " + ko_end},
              seat=seat, lit=walked[1:], good=[seat], grew=grew)
    frame({"en": f"Every seat is visited, and each run was walked once, from its first seat. "
                 f"The longest run is {best[0]}–{best[-1]}: answer {longest}.",
           "ko": f"모든 좌석을 봤고, 구간마다 첫 좌석에서 한 번씩만 걸었습니다. 가장 긴 구간은 "
                 f"{best[0]}–{best[-1]}이므로 답은 {longest}입니다."},
          path=best, answer=str(longest))


for number, sample in enumerate(sample_cases(SLUG), start=1):
    seat_ids = json.loads(sample["input"])
    run = sample_run(wt, number, sample, input=f"seatIds = {sample['input']}")
    solve(seat_ids, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
