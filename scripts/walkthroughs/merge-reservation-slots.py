#!/usr/bin/env python3.12
"""merge-reservation-slots' Walkthrough: the reference solution
(scripts/replay-solutions/merge-reservation-slots.py), sort by start and sweep once, recording one
frame per seating on each sample Test Case.

    CODEBITE_DB=<database> scripts/walkthroughs/merge-reservation-slots.py

writes common/src/main/resources/walkthroughs/merge-reservation-slots.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import driver_list, plural, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough  # noqa: E402

SLUG = "merge-reservation-slots"
COLUMNS = [{"en": "start", "ko": "시작"}, {"en": "end", "ko": "끝"}]

wt = Walkthrough(
    {"en": "Merge Reservation Slots", "ko": "예약 창 합치기"},
    {"en": "Sort by start, then each seating can only overlap the last merged window: "
           "start ≤ its end extends it, anything later opens a new one.",
     "ko": "시작 시각으로 정렬하면 각 예약은 마지막으로 합친 구간하고만 겹칠 수 있습니다: "
           "시작이 그 끝 이하면 구간을 늘리고, 더 늦으면 새 구간을 엽니다."},
    views=[
        {"id": "sorted", "type": "table", "title": {"en": "seatings, sorted by start", "ko": "시작 순으로 정렬한 예약"}},
        {"id": "merged", "type": "table", "title": {"en": "merged windows", "ko": "합친 구간"}},
        {"id": "state", "type": "vars"},
    ],
)


def window(w):
    return f"[{w[0]},{w[1]}]"


def solve(seatings, run):
    """Solution.mergeSeatingWindows with a frame per seating. Returns the merged list."""
    ordered = sorted(seatings)
    merged = []

    def frame(caption, at=None, s_marks=None, m_marks=None, start=None, **answer):
        last_end = merged[-1][1] if merged else "–"
        run.frame(caption,
                  sorted={"columns": COLUMNS,
                          "rows": [{"label": str(i), "cells": list(w)} for i, w in enumerate(ordered)],
                          "marks": s_marks or {}},
                  merged={"columns": COLUMNS,
                          "rows": [{"label": str(i), "cells": list(w)} for i, w in enumerate(merged)],
                          "marks": m_marks or {}},
                  state={"items": [
                      {"label": {"en": "seating", "ko": "예약"}, "value": "–" if at is None else window(ordered[at])},
                      {"label": {"en": "last merged end", "ko": "마지막 구간의 끝"}, "value": last_end}]},
                  **answer)

    frame({"en": f"Sort the {len(ordered)} seatings by start: {', '.join(window(w) for w in ordered)}. "
                 "Now a seating can only overlap the window just before it.",
           "ko": f"예약 {len(ordered)}개를 시작 시각으로 정렬합니다: {', '.join(window(w) for w in ordered)}. "
                 "이제 각 예약은 바로 앞 구간하고만 겹칠 수 있습니다."},
          s_marks={"lit": [[i, 0] for i in range(len(ordered))]})
    for i, (start, end) in enumerate(ordered):
        seat = window((start, end))
        lit_seat = [[i, 0], [i, 1]]
        if merged and start <= merged[-1][1]:
            last = len(merged) - 1
            before = window(merged[-1])
            old_end = merged[-1][1]
            merged[-1][1] = max(merged[-1][1], end)
            if end > old_end:
                en = f"extends it to {window(merged[-1])}."
                ko = f"{window(merged[-1])} 구간으로 늘어납니다."
                changed = [[last, 1]]
            else:
                en = f"already covers it, so it stays {window(merged[-1])}."
                ko = f"이미 그 안에 있으므로 구간은 {window(merged[-1])} 그대로입니다."
                changed = []
            frame({"en": f"{seat}: start {start} ≤ last end {old_end}, so it overlaps {before}; " + en,
                   "ko": f"{seat}: 시작 {start} ≤ 마지막 끝 {old_end}이므로 {before} 구간과 겹치고, " + ko},
                  at=i, s_marks={"lit": lit_seat, "dim": [[k, c] for k in range(i) for c in (0, 1)]},
                  m_marks={"good": changed} if changed else {"lit": [[last, 1]]})
        else:
            if merged:
                why_en = f"start {start} > last end {merged[-1][1]}, so it can't touch {window(merged[-1])}"
                why_ko = f"시작 {start} > 마지막 끝 {merged[-1][1]}이므로 {window(merged[-1])} 구간과 닿지 않아"
            else:
                why_en = "nothing is merged yet"
                why_ko = "아직 합친 구간이 없어"
            merged.append([start, end])
            frame({"en": f"{seat}: {why_en}; it opens a new window.",
                   "ko": f"{seat}: {why_ko} 새 구간을 엽니다."},
                  at=i, s_marks={"lit": lit_seat, "dim": [[k, c] for k in range(i) for c in (0, 1)]},
                  m_marks={"good": [[len(merged) - 1, 0], [len(merged) - 1, 1]]})
    answer = driver_list(merged)
    n = len(merged)
    frame({"en": f"Every seating is in a window. {len(ordered)} seatings became {n} "
                 f"non-overlapping {plural(n, 'window', 'windows')}: {answer}.",
           "ko": f"모든 예약이 구간에 들어갔습니다. 예약 {len(ordered)}개가 겹치지 않는 구간 {n}개가 되었습니다: {answer}."},
          s_marks={"dim": [[k, c] for k in range(len(ordered)) for c in (0, 1)]},
          m_marks={"path": [[k, c] for k in range(n) for c in (0, 1)]}, answer=answer)


for number, sample in enumerate(sample_cases(SLUG), start=1):
    seatings = json.loads(sample["input"])
    run = sample_run(wt, number, sample, input=f"seatings = {sample['input']}")
    solve(seatings, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
