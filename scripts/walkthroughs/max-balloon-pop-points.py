#!/usr/bin/env python3.12
"""max-balloon-pop-points' Walkthrough: the reference solution (scripts/replay-solutions/max-balloon-pop-points.py),
an interval DP over the row padded with a 1 at each end, best[left][right] being the most points from popping every
balloon strictly between, filled by gap width, one frame per cell, on each sample Test Case.

The table is a grid, row `left` by column `right`, headed by the padded values; cells with no balloon between
(right = left + 1) are the 0 base, cells below them unused. Each cell tries every balloon between as the one popped
last and moves in from the two smaller cells of the winning split; the last frame walks the splits back to a popping
order.

    CODEBITE_DB=<database> scripts/walkthroughs/max-balloon-pop-points.py

writes common/src/main/resources/walkthroughs/max-balloon-pop-points.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import josa, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move  # noqa: E402

SLUG = "max-balloon-pop-points"
CORNER, UNSET, UNUSED = "", " ", "·"
SAMPLES = sample_cases(SLUG)
VALUES = sorted({v for s in SAMPLES for v in json.loads(s["input"])} | {1})


def head(v):
    return f"#{v}"  # a header cell: drawn as the balloon's number, kept apart from the points


wt = Walkthrough(
    {"en": "Max Balloon Pop Points", "ko": "풍선 터뜨리기 최대 점수"},
    {"en": "Pad the row with a 1 at each end and think about which balloon between two walls is popped last: its "
           "neighbours then are the walls, and the two sides before it are smaller problems. Fill the table from "
           "narrow gaps to wide ones.",
     "ko": "줄 양 끝에 1을 붙이고, 두 벽 사이에서 마지막으로 터뜨릴 풍선을 고릅니다. 그때 이웃은 두 벽이고, 그 전의 "
           "양쪽은 더 작은 문제입니다. 좁은 구간부터 넓은 구간 순으로 표를 채웁니다."},
    views=[
        {"id": "table", "type": "grid",
         "title": {"en": "best points between left (rows) and right (columns)",
                   "ko": "left(행)와 right(열) 사이의 최대 점수"},
         "values": {**{head(v): {"tone": "a", "glyph": str(v)} for v in VALUES},
                    CORNER: {"glyph": "", "tone": "plain"}, UNSET: {"glyph": "", "tone": "empty"},
                    UNUSED: {"glyph": "", "tone": "plain"}}},
    ],
)


def solve(balloons, run):
    """Solution.maxPopPoints with a frame per cell. Returns the answer as the Driver prints it.
    best[left][right] is grid cell (left + 1, right + 1)."""
    values = [1, *balloons, 1]
    n = len(values)
    grid = [[CORNER] + [head(v) for v in values]]
    for left in range(n):
        grid.append([head(values[left])] + [UNUSED if right <= left else 0 if right == left + 1 else UNSET
                                            for right in range(n)])
    best = [[0] * n for _ in range(n)]
    choice = {}

    def cell(left, right):
        return [left + 1, right + 1]

    def frame(caption, marks=None, moves=None, **answer):
        run.frame(caption, table={"cells": grid, "marks": marks or {}}, moves=moves, **answer)

    frame({"en": f"Padded row: {values}. A cell with no balloon between its two walls (right = left + 1) scores 0.",
           "ko": f"양 끝을 채운 줄: {values}. 두 벽 사이에 풍선이 없는 칸(right = left + 1)은 0점입니다."},
          marks={"good": [cell(k, k + 1) for k in range(n - 1)]})
    for gap in range(2, n):
        for left in range(n - gap):
            right = left + gap
            edge = values[left] * values[right]
            options = [(best[left][last] + best[last][right] + edge * values[last], last)
                       for last in range(left + 1, right)]
            score, last = max(options, key=lambda o: (o[0], -o[1]))
            best[left][right] = score
            choice[(left, right)] = last
            grid[left + 1][right + 1] = score
            a, b = best[left][last], best[last][right]
            L, R, V = values[left], values[right], values[last]
            others = ", ".join(str(o) for o, _ in options)
            if len(options) == 1:
                en = f"Between walls {L} and {R}, only {V} is left to pop: {a} + {b} + {L}×{V}×{R} = {score}."
                ko = f"벽 {L}, {R} 사이에는 풍선 {V} 하나만 남습니다: {a} + {b} + {L}×{V}×{R} = {score}."
            else:
                en = f"Between walls {L} and {R}, try each balloon as the last popped ({others}). The best pops {V} " \
                     f"last: {a} + {b} + {L}×{V}×{R} = {score}."
                ko = f"벽 {L}, {R} 사이의 풍선을 하나씩 마지막으로 터뜨려 봅니다({others}). 가장 좋은 것은 {josa(V, '을를')} " \
                     f"마지막에 터뜨리는 경우입니다: {a} + {b} + {L}×{V}×{R} = {score}."
            frame({"en": en, "ko": ko},
                  marks={"lit": [[0, left + 1], [0, right + 1], [0, last + 1], cell(left, last), cell(last, right)],
                         "good": [cell(left, right)]},
                  moves=[move(at("table", cell(left, last)), at("table", cell(left, right))),
                         move(at("table", cell(last, right)), at("table", cell(left, right)),
                              value=f"+{b}+{L}×{V}×{R}")])
    answer = best[0][n - 1]
    order, path = [], []

    def walk(left, right):
        if right - left < 2:
            return
        last = choice[(left, right)]
        path.append(cell(left, right))
        walk(left, last)
        walk(last, right)
        order.append(values[last])

    walk(0, n - 1)
    sequence = ", ".join(str(v) for v in order)
    frame({"en": f"The top-right cell, between the two padded ends, holds the answer: {answer}. Following each cell's "
                 f"last-popped choice back gives a popping order: {sequence}.",
           "ko": f"양 끝 벽 사이인 오른쪽 위 칸의 값 {josa(answer, '이가')} 답입니다. 각 칸의 마지막 선택을 거슬러 가면 "
                 f"터뜨리는 순서가 나옵니다: {sequence}."},
          marks={"path": path}, answer=str(answer))


for number, sample in enumerate(SAMPLES, start=1):
    balloons = json.loads(sample["input"])
    run = sample_run(wt, number, sample, input=f"balloons = {sample['input']}")
    solve(balloons, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
