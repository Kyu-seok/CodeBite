#!/usr/bin/env python3.12
"""battery-window-tally's Walkthrough: the reference solution
(scripts/replay-solutions/battery-window-tally.py), a running total and a count of every running total
seen so far. The running totals are labels under the readings and their counts are map cards; each reading looks
total - k up in the map, a probe that hits or misses, with the windows a hit counts drawn as spans, and then moves
into its running total's card, one frame per reading on each sample Test Case.

    CODEBITE_DB=<database> scripts/walkthroughs/battery-window-tally.py

writes common/src/main/resources/walkthroughs/battery-window-tally.json.
"""
import json
import os
import sys
from collections import Counter

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import plural, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, map_entries, move, span  # noqa: E402

SLUG = "battery-window-tally"

wt = Walkthrough(
    {"en": "Battery Window Tally", "ko": "배터리 변동 구간 세기"},
    {"en": "A window ending here sums to k exactly when the running total before it was total - k, so count how "
           "often each running total has appeared and look total - k up at every reading.",
     "ko": "여기서 끝나는 구간의 합이 k인 것은 구간 앞까지의 누적합이 total - k일 때뿐입니다. 그래서 누적합마다 "
           "나온 횟수를 세어 두고, 읽을 때마다 total - k를 찾아봅니다."},
    views=[
        {"id": "readings", "type": "array", "title": {"en": "readings (under: running total)",
                                                      "ko": "readings (아래: 누적합)"}},
        {"id": "seen", "type": "map", "title": {"en": "seen (running total → times)", "ko": "seen (누적합 → 횟수)"}},
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
    under = []  # [index, "Σtotal"] for every reading read
    found_windows = []  # every (start, end) counted so far, for the last frame

    def frame(caption, probe=None, windows=(), path=(), seen_marks=None, count_mark=None, moves=None, **answer):
        if len(windows) > 2:
            raise SystemExit("more than two windows end at one reading: draw them another way")
        spans = {f"w{w}": span(a, b, {"en": f"sum {k}", "ko": f"합 {k}"}, mark="good", below=w == 1)
                 for w, (a, b) in enumerate(windows)}
        run.frame(caption,
                  readings={"values": readings, "pointers": {"i": i}, "under": list(under), "spans": spans,
                            "unread": list(range(len(under), n)),
                            "marks": {"path": list(path)} if path else {"lit": [i]} if i is not None else {}},
                  seen={"entries": map_entries(seen), "marks": seen_marks or {}, **({"probe": probe} if probe else {})},
                  state={"items": [{"label": "k", "value": k},
                                   {"label": {"en": "count", "ko": "count (구간 수)"}, "value": count, "mark": count_mark}]},
                  moves=moves, **answer)

    frame({"en": f"k = {k}, and before any reading the running total is 0, so seen starts as {{0: 1}}. "
                 f"Read left to right.",
           "ko": f"아무것도 읽기 전의 누적합은 0이므로 seen은 {{0: 1}}에서 시작합니다(k = {k}). "
                 f"왼쪽부터 읽습니다."},
          seen_marks={"lit": [0]})
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
        under.append([i, f"Σ{total}"])
        # looked up before this total is recorded, so k = 0 still only finds the earlier totals
        probe = {"key": need, "label": f"{total} − {k} = {need}", "hit": bool(hits)}
        store = [move(at("readings", i), at("seen", total), value=f"Σ{total}")]
        step = f"total = {before} + {reading} = {total}; total - k = {total} - {k} = {need}"
        recorded = (f"Then record {total}." if seen[total] == 1 else f"Then record {total} again: now {seen[total]}.")
        if hits:
            listed = ", ".join(f"[{a}..{b}]" for a, b in windows)
            frame({"en": f"{step}, seen {hits} {plural(hits, 'time', 'times')}: "
                         f"{plural(hits, 'that window sums', 'those windows sum')} to {k} "
                         f"(readings{listed}), so count = {count}. {recorded}",
                   "ko": f"{step}이고 seen에 {hits}번 있으므로 합이 {k}인 구간(readings{listed})을 세어 "
                         f"count = {count}입니다. 이어서 누적합 {total}의 횟수를 1 늘립니다."},
                  probe, windows, seen_marks={"good": [total]}, count_mark="good", moves=store)
        else:
            frame({"en": f"{step}, not in seen: no window ending here sums to {k}. {recorded}",
                   "ko": f"{step}이고 seen에 없으므로 여기서 끝나며 합이 {k}인 구간은 없습니다. "
                         f"누적합 {total}의 횟수를 1 늘립니다."},
                  probe, seen_marks={"good": [total]}, moves=store)
    i = None
    answer = str(count)
    if count:
        listed = ", ".join(f"[{a}..{b}]" for a, b in found_windows)
        frame({"en": f"Every reading read. The windows that sum to {k} are readings{listed}: answer {count}.",
               "ko": f"모든 기록을 읽었습니다. 합이 {k}인 구간은 모두 {count}개(readings{listed})이므로 답은 {count}입니다."},
              path=sorted({j for a, b in found_windows for j in range(a, b + 1)}), count_mark="path", answer=answer)
    else:
        frame({"en": f"Every reading read and no lookup of total - k hit: no window sums to {k}. Answer 0.",
               "ko": f"모든 기록을 읽는 동안 total - k가 seen에 한 번도 없었으므로 합이 {k}인 구간이 없습니다. 답은 0입니다."},
              count_mark="path", answer=answer)

for number, sample in enumerate(sample_cases(SLUG), start=1):
    lines = sample["input"].split("\n")
    readings, k = json.loads(lines[0]), int(lines[1])
    run = sample_run(wt, number, sample, input=f"readings = {lines[0].strip()}, k = {k}")
    solve(readings, k, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
