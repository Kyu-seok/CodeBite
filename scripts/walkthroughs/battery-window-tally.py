#!/usr/bin/env python3.12
"""battery-window-tally's Walkthrough: the reference solution
(scripts/replay-solutions/battery-window-tally.py), a running total and a count of every running total
seen so far, recording one frame per reading on each sample Test Case.

    CODEBITE_DB=<database> scripts/walkthroughs/battery-window-tally.py

writes common/src/main/resources/walkthroughs/battery-window-tally.json.
"""
import json
import os
import sys
from collections import Counter

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough  # noqa: E402

SLUG = "battery-window-tally"

wt = Walkthrough(
    {"en": "Battery Window Tally", "ko": "배터리 변동 구간 세기"},
    {"en": "A window ending here sums to k exactly when the running total before it was total - k, so count how "
           "often each running total has appeared and look total - k up at every reading.",
     "ko": "여기서 끝나는 구간의 합이 k인 것은 구간 앞까지의 누적합이 total - k일 때뿐입니다. 그래서 누적합마다 "
           "나온 횟수를 세어 두고, 읽을 때마다 total - k를 찾아봅니다."},
    views=[
        {"id": "readings", "type": "array", "title": {"en": "readings (tag: running total)",
                                                      "ko": "readings (태그: 누적합)"}},
        {"id": "seen", "type": "table", "title": {"en": "seen (running total → times)",
                                                  "ko": "seen (누적합 → 횟수)"}},
        {"id": "state", "type": "vars"},
    ],
)


def solve(readings, k, run):
    """Solution.countWindowTallies with a frame per reading. Returns the answer as the Driver prints it."""
    n = len(readings)
    seen = Counter({0: 1})
    totals_at = {0: [-1]}  # running total -> the indexes it was reached after (-1: before any reading),
    #                        so a frame can name the windows a lookup counted
    total = 0
    count = 0
    i = None
    found_windows = []  # every (start, end) counted so far, for the last frame

    def frame(caption, need=None, lit=(), path=(), row_lit=None, row_good=None, count_mark=None, **answer):
        keys = list(seen)
        row_marks = {}
        if row_lit is not None and row_lit in seen:
            row_marks["lit"] = [[keys.index(row_lit), 0]]
        if row_good is not None:
            row_marks["good"] = [[keys.index(row_good), 0]]
        run.frame(caption,
                  readings={"values": readings, "pointers": {"i": i},
                            "tags": [[j, f"Σ{t}"] for t, js in totals_at.items() for j in js if j >= 0],
                            "marks": {"dim": [j for j in range(n) if i is None or j > i] if not path else [],
                                      "path": list(path), "lit": list(lit)}},
                  seen={"columns": [{"en": "times", "ko": "횟수"}],
                        "rows": [{"label": str(t), "cells": [c]} for t, c in seen.items()],
                        "marks": row_marks},
                  state={"items": [{"label": "k", "value": k},
                                   {"label": "total", "value": total},
                                   {"label": "total - k", "value": "–" if need is None else need},
                                   {"label": "count", "value": count, "mark": count_mark}]},
                  **answer)

    frame({"en": f"k = {k}. Before any reading the running total is 0, so seen starts as {{0: 1}}. "
                 f"Read left to right.",
           "ko": f"k = {k}. 아무것도 읽기 전의 누적합은 0이므로 seen은 {{0: 1}}에서 시작합니다. "
                 f"왼쪽부터 읽습니다."})
    for i, reading in enumerate(readings):
        before = total
        total += reading
        need = total - k
        hits = seen[need]
        windows = [(j + 1, i) for j in totals_at.get(need, [])]
        count += hits
        found_windows.extend(windows)
        seen[total] += 1
        totals_at.setdefault(total, []).append(i)
        step = f"total = {before} + {reading} = {total}; total - k = {total} - {k} = {need}"
        if hits:
            listed = ", ".join(f"[{a}..{b}]" for a, b in windows)
            same = need == total
            frame({"en": f"{step}, seen {hits} {'time' if hits == 1 else 'times'}: "
                         f"{'that window sums' if hits == 1 else 'those windows sum'} to {k} "
                         f"(readings{listed}). count = {count}. "
                         + (f"Then record {total}." if not same else f"Then record {total} again: now {seen[total]}."),
                   "ko": f"{step}이고 seen에 {hits}번 있습니다. 합이 {k}인 구간: readings{listed}. "
                         f"count = {count}. 이어서 누적합 {total}의 횟수를 1 늘립니다."},
                  need=need, path=range(min(a for a, _ in windows), i + 1),
                  row_lit=None if same else need, row_good=total, count_mark="good")
        else:
            frame({"en": f"{step}, not in seen: no window ending here sums to {k}. Record {total}.",
                   "ko": f"{step}이고 seen에 없습니다. 여기서 끝나며 합이 {k}인 구간은 없습니다. "
                         f"누적합 {total}의 횟수를 1 늘립니다."},
                  need=need, lit=[i], row_good=total)
    i = None
    answer = str(count)
    if count:
        listed = ", ".join(f"[{a}..{b}]" for a, b in found_windows)
        frame({"en": f"Every reading read. The windows that sum to {k} are readings{listed}: answer {count}.",
               "ko": f"모든 기록을 읽었습니다. 합이 {k}인 구간은 readings{listed}로 {count}개입니다. 답은 {count}입니다."},
              path=sorted({j for a, b in found_windows for j in range(a, b + 1)}), count_mark="good", answer=answer)
    else:
        frame({"en": f"Every reading read and no lookup of total - k hit: no window sums to {k}. Answer 0.",
               "ko": f"모든 기록을 읽는 동안 total - k가 seen에 한 번도 없었으므로 합이 {k}인 구간이 없습니다. 답은 0입니다."},
              answer=answer)


for number, sample in enumerate(sample_cases(SLUG), start=1):
    lines = sample["input"].split("\n")
    readings, k = json.loads(lines[0]), int(lines[1])
    run = sample_run(wt, number, sample, input=f"readings = {lines[0].strip()}, k = {k}")
    solve(readings, k, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
