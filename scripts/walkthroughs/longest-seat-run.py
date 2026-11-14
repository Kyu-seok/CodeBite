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
from walkthrough_trace import Walkthrough, probe, span  # noqa: E402

SLUG = "longest-seat-run"

wt = Walkthrough(
    {"en": "Longest Seat Run", "ko": "가장 긴 좌석 구간"},
    {"en": "Put the seats in a hash set and count up only from a seat whose seat - 1 is missing: "
           "each run is walked once, from its first seat, so the whole scan is O(n).",
     "ko": "좌석을 해시 집합에 넣고, seat - 1이 없는 좌석에서만 위로 세어 나갑니다. 구간마다 첫 좌석에서 "
           "한 번만 걸으므로 전체가 O(n)입니다."},
    views=[
        {"id": "seats", "type": "set", "title": {"en": "seat set, in loop order", "ko": "좌석 집합 (순회 순서)"}},
        {"id": "line", "type": "array", "title": {"en": "the same seats, by number", "ko": "같은 좌석, 번호 순"}},
    ],
)


def solve(seat_ids, run):
    """Solution.longestSeatRun with a frame per seat the loop visits. Returns the answer as the Driver prints it."""
    seats = set(seat_ids)
    order = list(seats)  # the order `for seat in seats` visits them
    line = sorted(seats)  # where each run is a range: drawn only, the solution never sorts
    pos = {s: i for i, s in enumerate(line)}
    tags = {}
    runs = {}  # first seat -> the span of the run walked from it
    longest = 0
    best = None  # (first, last) of the longest run so far
    visited = []  # seats the loop has passed, faded in the set

    def frame(caption, seat=None, lit=(), good=(), path=(), probes=(), grew=False, last=False, **answer):
        spans = {} if last else {f"run {a}": sp for a, sp in runs.items()}
        if best:
            spans["best"] = span(pos[best[0]], pos[best[1]], {"en": f"longest = {longest}", "ko": f"최장 = {longest}"},
                                 mark="path" if last else "good" if grew else None, below=True)
        found = {p["value"] for p in probes if p["value"] in seats}
        run.frame(caption,
                  seats={"members": order, "probes": list(probes),
                         "marks": {"dim": [s for s in visited if s not in found and not last],
                                   "lit": [s for s in lit if s in seats], "good": list(good), "path": list(path)}},
                  line={"values": line, "pointers": {"seat": pos[seat] if seat is not None else None},
                        "tags": [[pos[s], t] for s, t in tags.items()], "spans": spans,
                        "marks": {"lit": [pos[s] for s in lit if s in seats], "good": [pos[s] for s in good],
                                  "path": [pos[s] for s in path]}},
                  **answer)

    frame({"en": f"Put the {len(seat_ids)} seat ids in a hash set ({len(seats)} distinct), so asking "
                 f"\"is seat x free?\" takes O(1). Then visit each seat once, in the set's own order.",
           "ko": f"좌석 번호 {len(seat_ids)}개를 해시 집합에 넣어(서로 다른 번호 {len(seats)}개) "
                 f"\"좌석 x가 비어 있나?\"를 O(1)에 확인합니다. 그다음 집합의 순서대로 좌석을 하나씩 봅니다."})
    for seat in seats:
        below = probe(seat - 1, label={"en": "seat - 1", "ko": "seat - 1"})
        if seat - 1 in seats:
            tags[seat] = {"en": "skip", "ko": "건너뜀"}
            frame({"en": f"Seat {seat}: looking up seat {seat - 1} finds it, so {seat} is not the first seat of "
                         f"its run. Skip it; the walk from that run's first seat counts it.",
                   "ko": f"좌석 {seat}: 좌석 {josa(seat - 1, "을를")} 찾으니 집합에 있으므로 좌석 {josa(seat, "은는")} "
                         f"구간의 첫 좌석이 아니라 건너뜁니다. 이 구간의 첫 좌석에서 걸을 때 함께 셉니다."},
                  seat=seat, lit=[seat], probes=[below])
            visited.append(seat)
            continue
        end = seat
        while end + 1 in seats:
            end += 1
        length = end - seat + 1
        walked = list(range(seat, end + 1))
        runs[seat] = span(pos[seat], pos[end], {"en": f"len {length}", "ko": f"길이 {length}"}, mark="lit")
        tags[seat] = {"en": "start", "ko": "시작"}
        grew = length > longest
        old = longest
        longest = max(longest, length)
        if grew:
            best = (seat, end)
        steps = [probe(s) for s in walked[1:]] + [probe(end + 1)]
        if grew:
            en_end, ko_end = (f", which beats {old}: the longest is now {longest}.",
                              f"이전 최댓값 {old}보다 길어 이제 최장은 {longest}입니다.")
        else:
            en_end, ko_end = (f", which does not beat {longest}.",
                              f"최장 {longest}보다 길지 않습니다.")
        frame({"en": f"Seat {seat}: seat {seat - 1} is missing, so a run starts here; looking up each next seat "
                     f"until {end + 1} misses walks {seat}–{end}, length {length}" + en_end
                     if length > 1 else
                     f"Seat {seat}: seat {seat - 1} is missing, so a run starts here, and {seat + 1} is missing "
                     f"too: length 1" + en_end,
               "ko": f"좌석 {seat}: 좌석 {josa(seat - 1, "이가")} 없으므로 여기서 구간이 시작되고, {josa(end + 1, "이가")} "
                     f"없을 때까지 위로 찾아 {seat}–{end}, 길이 {josa(length, "(으)로")} " + ko_end},
              seat=seat, lit=walked[1:], good=[seat], probes=[below, *steps], grew=grew)
        runs[seat] = span(pos[seat], pos[end], {"en": f"len {length}", "ko": f"길이 {length}"})
        visited.append(seat)
    first, last_seat = best
    frame({"en": f"Every seat is visited, and each run was walked once, from its first seat. "
                 f"The longest run is {first}–{last_seat}: answer {longest}.",
           "ko": f"모든 좌석을 봤고, 구간마다 첫 좌석에서 한 번씩만 걸었습니다. 가장 긴 구간은 "
                 f"{first}–{last_seat}이므로 답은 {longest}입니다."},
          path=list(range(first, last_seat + 1)), last=True, answer=str(longest))


for number, sample in enumerate(sample_cases(SLUG), start=1):
    seat_ids = json.loads(sample["input"])
    run = sample_run(wt, number, sample, input=f"seatIds = {sample['input']}")
    solve(seat_ids, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
