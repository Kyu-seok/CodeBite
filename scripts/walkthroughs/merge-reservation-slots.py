#!/usr/bin/env python3.12
"""merge-reservation-slots' Walkthrough: the reference solution
(scripts/replay-solutions/merge-reservation-slots.py), sort by start and sweep once, recording one
frame per seating, both on one number line, on each sample Test Case.

    CODEBITE_DB=<database> scripts/walkthroughs/merge-reservation-slots.py

writes common/src/main/resources/walkthroughs/merge-reservation-slots.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import driver_list, plural, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move  # noqa: E402

SLUG = "merge-reservation-slots"
SORTED = {"en": "seatings, sorted by start", "ko": "시작 순으로 정렬한 예약"}
MERGED = {"en": "merged windows", "ko": "합친 구간"}
LAST_END = {"en": "last end", "ko": "마지막 끝"}

wt = Walkthrough(
    {"en": "Merge Reservation Slots", "ko": "예약 창 합치기"},
    {"en": "Sort by start, then each seating can only overlap the last merged window: "
           "start ≤ its end extends it, anything later opens a new one.",
     "ko": "시작 시각으로 정렬하면 각 예약은 마지막으로 합친 구간하고만 겹칠 수 있습니다: "
           "시작이 그 끝 이하면 구간을 늘리고, 더 늦으면 새 구간을 엽니다."},
    views=[
        {"id": "line", "type": "intervals", "empty": {"en": "none yet", "ko": "아직 없음"}},
    ],
)


def window(w):
    return f"[{w[0]},{w[1]}]"


def solve(seatings, run):
    """Solution.mergeSeatingWindows with a frame per seating. Returns the merged list.
    Both groups share one number line: the seating read is lit, the merged window it lands in is marked, it moves
    there, and the last merged end it is compared with is drawn on the axis."""
    ordered = sorted(seatings)
    merged = []

    def frame(caption, sorted_marks=None, merged_marks=None, compared=None, moves=None, **answer):
        line = {"groups": [{"label": SORTED, "intervals": ordered, "marks": sorted_marks or {}},
                           {"label": MERGED, "intervals": merged, "marks": merged_marks or {}}]}
        if compared is not None:
            line["points"] = [{"at": compared, "label": LAST_END, "mark": "lit"}]
        run.frame(caption, line=line, moves=moves, **answer)

    frame({"en": f"Sort the {len(ordered)} seatings by start: {', '.join(window(w) for w in ordered)}. "
                 "Now a seating can only overlap the window just before it.",
           "ko": f"예약 {len(ordered)}개를 시작 시각으로 정렬합니다: {', '.join(window(w) for w in ordered)}. "
                 "이제 각 예약은 바로 앞 구간하고만 겹칠 수 있습니다."},
          sorted_marks={"lit": list(range(len(ordered)))})
    for i, (start, end) in enumerate(ordered):
        seat = window((start, end))
        read = {"lit": [i], "dim": list(range(i))}
        if merged and start <= merged[-1][1]:
            last = len(merged) - 1
            before = window(merged[-1])
            old_end = merged[-1][1]
            merged[-1][1] = max(merged[-1][1], end)
            if end > old_end:
                en = f"extends it to {window(merged[-1])}."
                ko = f"{window(merged[-1])} 구간으로 늘어납니다."
                marks = {"good": [last]}
            else:
                en = f"already covers it, so it stays {window(merged[-1])}."
                ko = f"이미 그 안에 있으므로 구간은 {window(merged[-1])} 그대로입니다."
                marks = {"lit": [last]}
            frame({"en": f"{seat}: start {start} ≤ last end {old_end}, so it overlaps {before}; " + en,
                   "ko": f"{seat}: 시작 {start} ≤ 마지막 끝 {old_end}이므로 {before} 구간과 겹치고, " + ko},
                  read, marks, old_end, [move(at("line", [0, i]), at("line", [1, last]))])
        else:
            compared = merged[-1][1] if merged else None
            if merged:
                why_en = f"start {start} > last end {compared}, so it can't touch {window(merged[-1])}"
                why_ko = f"시작 {start} > 마지막 끝 {compared}이므로 {window(merged[-1])} 구간과 닿지 않아"
            else:
                why_en = "nothing is merged yet"
                why_ko = "아직 합친 구간이 없어"
            merged.append([start, end])
            frame({"en": f"{seat}: {why_en}; it opens a new window.",
                   "ko": f"{seat}: {why_ko} 새 구간을 엽니다."},
                  read, {"good": [len(merged) - 1]}, compared,
                  [move(at("line", [0, i]), at("line", [1, len(merged) - 1]))])
    answer = driver_list(merged)
    n = len(merged)
    frame({"en": f"Every seating is in a window. {len(ordered)} seatings became {n} "
                 f"non-overlapping {plural(n, 'window', 'windows')}: {answer}.",
           "ko": f"모든 예약이 구간에 들어갔습니다. 예약 {len(ordered)}개가 겹치지 않는 구간 {n}개가 되었습니다: {answer}."},
          {"dim": list(range(len(ordered)))}, {"path": list(range(n))}, answer=answer)


for number, sample in enumerate(sample_cases(SLUG), start=1):
    seatings = json.loads(sample["input"])
    values = [v for w in seatings for v in w]
    run = sample_run(wt, number, sample, input=f"seatings = {sample['input']}",
                     setup={"line": {"domain": [min(values), max(values)]}})
    solve(seatings, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
