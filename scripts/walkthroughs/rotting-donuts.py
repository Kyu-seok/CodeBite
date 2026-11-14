#!/usr/bin/env python3.12
"""rotting-donuts' Walkthrough: the reference solution (scripts/replay-solutions/rotting-donuts.py),
a multi-source BFS, with its queue drawn: a frame per donut leaving the front, and one per wave joining the back.

    CODEBITE_DB=<database> scripts/walkthroughs/rotting-donuts.py

writes common/src/main/resources/walkthroughs/rotting-donuts.json.
"""
import copy
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import plural, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move  # noqa: E402

SLUG = "rotting-donuts"

wt = Walkthrough(
    {"en": "Rotting Donuts", "ko": "도넛 상함 전파"},
    {"en": "Multi-source BFS: every stale donut starts in the queue, and each wave through the queue is one minute.",
     "ko": "다중 출발 BFS: 상한 도넛이 모두 큐에서 시작하고, 큐를 한 번 도는 물결이 1분입니다."},
    views=[
        {"id": "tray", "type": "grid", "title": {"en": "tray", "ko": "트레이"}, "showValues": False,
         "values": {"0": {"label": {"en": "empty slot", "ko": "빈 자리"}, "tone": "empty"},
                    "1": {"label": {"en": "fresh", "ko": "신선"}, "tone": "a", "glyph": "●"},
                    "2": {"label": {"en": "stale", "ko": "상함"}, "tone": "b", "glyph": "●"}}},
        {"id": "queue", "type": "queue", "title": {"en": "queue", "ko": "큐"}},
        {"id": "state", "type": "vars"},
    ],
)


def name(p):
    return f"{p[0]},{p[1]}"


def minute_tag(m):
    return {"en": "start", "ko": "시작"} if m == 0 else {"en": f"min {m}", "ko": f"{m}분"}


def solve(ward, run):
    """Solution.oranges_rotting with the BFS queue drawn: each stale donut joins it from its cell, and the front
    leaves to turn its fresh neighbours stale. Returns nothing; the last frame carries the answer as the Driver
    prints it."""
    rows = len(ward)
    cols = len(ward[0]) if ward else 0
    went_stale = {}  # (r, c) -> the minute it went stale, so the tray and the queue show the BFS layers
    queue = []       # the donuts waiting, front first: the rest of this wave, then the next

    def frame(caption, lit=(), good=(), bad=(), path=(), queue_marks=None, moves=None, **answer):
        run.frame(caption,
                  tray={"cells": ward, "tags": [[r, c, minute_tag(m)] for (r, c), m in went_stale.items()],
                        "marks": {"lit": [list(p) for p in lit], "good": [list(p) for p in good],
                                  "bad": [list(p) for p in bad], "path": [list(p) for p in path]}},
                  queue={"values": [name(p) for p in queue],
                         "tags": [[i, minute_tag(went_stale[p])] for i, p in enumerate(queue)],
                         "marks": queue_marks or {}},
                  state={"items": [{"label": {"en": "fresh left", "ko": "남은 신선"}, "value": fresh,
                                    "mark": "bad" if bad else None,
                                    "why": "how many fresh donuts are left, which the answer waits on; the tray "
                                           "draws each donut, not their number (a cell holding 1 is chance)"}]},
                  moves=moves, **answer)

    fresh = sum(row.count(1) for row in ward)
    rotten = [(r, c) for r in range(rows) for c in range(cols) if ward[r][c] == 2]
    for p in rotten:
        went_stale[p] = 0
    minutes = 0
    queue = list(rotten)
    s = len(rotten)
    frame({"en": f"Count {fresh} fresh {plural(fresh, 'donut', 'donuts')}; the {s} stale "
                 f"{plural(s, 'one joins', 'ones join')} the queue as the first wave.",
           "ko": f"신선한 도넛 {fresh}개를 세고, 상한 도넛 {s}개가 첫 물결로 큐에 들어갑니다."},
          lit=rotten, queue_marks={"good": list(range(s))},
          moves=[move(at("tray", list(p)), at("queue", i), value=name(p)) for i, p in enumerate(queue)])
    while rotten and fresh:
        next_wave = []
        for r, c in rotten:
            turned = []
            for nr, nc in ((r + 1, c), (r - 1, c), (r, c + 1), (r, c - 1)):
                if 0 <= nr < rows and 0 <= nc < cols and ward[nr][nc] == 1:
                    ward[nr][nc] = 2
                    fresh -= 1
                    next_wave.append((nr, nc))
                    turned.append((nr, nc))
                    went_stale[(nr, nc)] = minutes + 1
            here = name((r, c))
            if not turned:
                frame({"en": f"Donut ({here}) leaves the front of the queue; no fresh donut sits next to it.",
                       "ko": f"({here}) 도넛이 큐 앞에서 나오지만, 옆에 신선한 도넛이 없습니다."},
                      lit=[(r, c)], queue_marks={"lit": [0]}, moves=[move(at("queue", 0))])
                queue.pop(0)
                continue
            n, m = len(turned), minutes + 1
            frame({"en": f"Donut ({here}) leaves the front of the queue and turns {n} fresh "
                         f"{plural(n, 'neighbour', 'neighbours')} stale at minute {m}.",
                   "ko": f"({here}) 도넛이 큐 앞에서 나와 이웃한 신선한 도넛 {n}개를 {m}분에 상하게 합니다."},
                  lit=[(r, c)], good=turned, queue_marks={"lit": [0]},
                  moves=[move(at("queue", 0), at("tray", list(p))) for p in turned])
            queue.pop(0)
            back = len(queue)
            queue.extend(turned)
            frame({"en": f"{plural(n, 'It joins', 'They join')} the back of the queue in minute {m}'s wave. "
                         f"{fresh} fresh left.",
                   "ko": f"새로 상한 도넛 {n}개가 {m}분 물결로 큐 뒤에 들어갑니다. 신선한 도넛 {fresh}개 남음."},
                  good=turned, queue_marks={"good": list(range(back, len(queue)))},
                  moves=[move(at("tray", list(p)), at("queue", back + i), value=name(p))
                         for i, p in enumerate(turned)])
        rotten = next_wave
        minutes += 1
    answer = -1 if fresh else minutes
    if fresh:
        stuck = [(r, c) for r in range(rows) for c in range(cols) if ward[r][c] == 1]
        frame({"en": f"The queue is empty but {fresh} fresh {plural(fresh, 'donut is', 'donuts are')} walled off "
                     f"by empty slots and never {plural(fresh, 'goes', 'go')} stale: answer -1.",
               "ko": f"큐가 비었지만 신선한 도넛 {fresh}개가 빈 자리에 막혀 끝내 상하지 않습니다: 답 -1."},
              bad=stuck, answer=str(answer))
    else:
        left = len(queue)
        frame({"en": f"No fresh donut is left after minute {minutes}'s wave, so the {left} still queued "
                     f"{plural(left, 'has', 'have')} nothing to turn: answer {minutes}.",
               "ko": f"{minutes}분 물결이 끝나자 신선한 도넛이 남지 않아, 큐에 남은 {left}개는 상하게 할 도넛이 없습니다: "
                     f"답은 {minutes}입니다."},
              path=[p for p, m in went_stale.items() if m == minutes and minutes > 0],
              queue_marks={"dim": list(range(left))}, answer=str(answer))


for number, sample in enumerate(sample_cases(SLUG), start=1):
    ward = json.loads(sample["input"])
    run = sample_run(wt, number, sample, input=f"ward = {sample['input']}")
    solve(copy.deepcopy(ward), run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
