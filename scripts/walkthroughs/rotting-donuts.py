#!/usr/bin/env python3.12
"""rotting-donuts' Walkthrough: the reference solution (scripts/replay-solutions/rotting-donuts.py),
a multi-source BFS, recording one frame per wave on each sample Test Case.

    CODEBITE_DB=<database> scripts/walkthroughs/rotting-donuts.py

writes common/src/main/resources/walkthroughs/rotting-donuts.json.
"""
import copy
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough  # noqa: E402

SLUG = "rotting-donuts"

wt = Walkthrough(
    {"en": "Rotting Donuts", "ko": "도넛 상함 전파"},
    {"en": "Multi-source BFS: every stale donut spreads at once, and each wave is one minute.",
     "ko": "다중 출발 BFS: 상한 도넛이 모두 동시에 번지고, 한 번의 물결이 1분입니다."},
    views=[
        {"id": "tray", "type": "grid", "title": {"en": "tray", "ko": "트레이"}, "showValues": False,
         "values": {"0": {"label": {"en": "empty slot", "ko": "빈 자리"}, "tone": "empty"},
                    "1": {"label": {"en": "fresh", "ko": "신선"}, "tone": "a", "glyph": "●"},
                    "2": {"label": {"en": "stale", "ko": "상함"}, "tone": "b", "glyph": "●"}}},
        {"id": "state", "type": "vars"},
    ],
)


def plural(n, one, many):
    return one if n == 1 else many


def solve(ward, run):
    """Solution.oranges_rotting with a frame per wave. Returns the answer as the Driver prints it."""
    rows = len(ward)
    cols = len(ward[0]) if ward else 0
    went_stale = {}  # (r, c) -> the minute it went stale, so the tray shows the BFS layers

    def frame(caption, lit=(), good=(), bad=(), **answer):
        tags = [[r, c, {"en": "start", "ko": "시작"} if m == 0 else {"en": f"min {m}", "ko": f"{m}분"}]
                for (r, c), m in went_stale.items()]
        run.frame(caption,
                  tray={"cells": ward, "tags": tags,
                        "marks": {"lit": [list(p) for p in lit], "good": [list(p) for p in good],
                                  "bad": [list(p) for p in bad]}},
                  state={"items": [
                      {"label": {"en": "minute", "ko": "분"}, "value": minutes},
                      {"label": {"en": "fresh left", "ko": "남은 신선"}, "value": fresh,
                       "mark": "bad" if bad else None},
                      {"label": {"en": "wave (queue)", "ko": "물결 (큐)"}, "value": [f"{r},{c}" for r, c in rotten],
                       "empty": {"en": "empty", "ko": "비어 있음"}}]},
                  **answer)

    fresh = sum(row.count(1) for row in ward)
    rotten = [(r, c) for r in range(rows) for c in range(cols) if ward[r][c] == 2]
    for p in rotten:
        went_stale[p] = 0
    minutes = 0
    s = len(rotten)
    frame({"en": f"Count {fresh} fresh {plural(fresh, 'donut', 'donuts')} and put the {s} stale "
                 f"{plural(s, 'one', 'ones')} into the first wave.",
           "ko": f"신선한 도넛 {fresh}개를 세고, 상한 도넛 {s}개를 첫 물결에 넣습니다."},
          lit=rotten)
    while rotten and fresh:
        spreading, next_wave = rotten, []
        for r, c in rotten:
            for nr, nc in ((r + 1, c), (r - 1, c), (r, c + 1), (r, c - 1)):
                if 0 <= nr < rows and 0 <= nc < cols and ward[nr][nc] == 1:
                    ward[nr][nc] = 2
                    fresh -= 1
                    next_wave.append((nr, nc))
        rotten = next_wave
        minutes += 1
        for p in next_wave:
            went_stale[p] = minutes
        n = len(next_wave)
        if n:
            frame({"en": f"Minute {minutes}: the wave reaches {n} fresh {plural(n, 'neighbour', 'neighbours')}; "
                         f"{plural(n, 'it goes stale and becomes', 'they go stale and become')} the next wave. "
                         f"{fresh} fresh left.",
                   "ko": f"{minutes}분: 물결이 이웃한 신선한 도넛 {n}개에 닿아 상하게 하고, 그 도넛들이 다음 물결이 됩니다. "
                         f"신선한 도넛 {fresh}개 남음."},
                  lit=spreading, good=next_wave)
        else:
            frame({"en": f"Minute {minutes}: no fresh donut sits next to the wave, so the wave dies out.",
                   "ko": f"{minutes}분: 물결 옆에 신선한 도넛이 없어 물결이 끊깁니다."},
                  lit=spreading)
    answer = -1 if fresh else minutes
    if fresh:
        stuck = [(r, c) for r in range(rows) for c in range(cols) if ward[r][c] == 1]
        frame({"en": f"The wave is gone but {fresh} fresh {plural(fresh, 'donut is', 'donuts are')} walled off "
                     f"by empty slots and never {plural(fresh, 'goes', 'go')} stale: answer -1.",
               "ko": f"물결은 끝났지만 신선한 도넛 {fresh}개가 빈 자리에 막혀 끝내 상하지 않습니다: 답 -1."},
              bad=stuck, answer=str(answer))
    else:
        frame({"en": f"No fresh donut is left. It took {minutes} {plural(minutes, 'wave', 'waves')}, "
                     f"one per minute: answer {minutes}.",
               "ko": f"신선한 도넛이 하나도 남지 않았습니다. 물결 {minutes}번, 한 번에 1분씩 걸렸으므로 답은 {minutes}입니다."},
              answer=str(answer))


for number, sample in enumerate(sample_cases(SLUG), start=1):
    ward = json.loads(sample["input"])
    run = sample_run(wt, number, sample, input=f"ward = {sample['input']}")
    solve(copy.deepcopy(ward), run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
