#!/usr/bin/env python3.12
"""biggest-clear-floor's Walkthrough: the reference solution (scripts/replay-solutions/biggest-clear-floor.py), the side
of the largest clear square ending at each tile (its bottom-right corner), one frame per tile in row order, on each
sample Test Case.

The solution keeps one row (`side`, with `diagonal` the old value up-left); the Walkthrough draws the whole table those
rows roll through, as a grid the floor's shape beside the floor itself, drawn as the description's Diagram draws it. A
desk tile is 0, moved in from the floor; a clear tile is 1 + the smallest of the three sides above, left and up-left,
moved in from that smallest one. The biggest square so far is its corner, tagged `best`; the last frame marks the square on the floor.

    CODEBITE_DB=<database> scripts/walkthroughs/biggest-clear-floor.py

writes common/src/main/resources/walkthroughs/biggest-clear-floor.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move  # noqa: E402

SLUG = "biggest-clear-floor"
UNSET = " "
BEST = {"en": "best", "ko": "최대"}

wt = Walkthrough(
    {"en": "Biggest Clear Floor", "ko": "가장 큰 빈 교실 바닥"},
    {"en": "For each clear tile, find the side of the biggest clear square whose bottom-right corner it is: one more "
           "than the smallest of the squares ending above it, to its left and up-left, since all three must fit.",
     "ko": "빈 타일마다 그 타일을 오른쪽 아래 꼭짓점으로 하는 가장 큰 빈 정사각형의 변을 구합니다. 위, 왼쪽, 왼쪽 위에서 "
           "끝나는 정사각형이 모두 들어가야 하므로, 셋 중 가장 작은 변에 1을 더한 값입니다."},
    views=[
        {"id": "floor", "type": "grid", "title": {"en": "floor", "ko": "floor (교실 바닥)"},
         "values": {"1": {"tone": "c"}, "0": {"tone": "wall"}}},
        {"id": "side", "type": "grid", "title": {"en": "side of the biggest square ending here",
                                                 "ko": "여기서 끝나는 가장 큰 정사각형의 변"},
         "values": {UNSET: {"glyph": "", "tone": "empty"}}},
    ],
)


def solve(floor, run):
    """Solution.biggestClearFloor with a frame per tile, the whole side table drawn. Returns the answer as the Driver
    prints it."""
    rows, cols = len(floor), len(floor[0])
    side = [[UNSET] * cols for _ in range(rows)]
    best = (0, None)  # (side, corner)

    def square(k, corner):
        r, c = corner
        return [[rr, cc] for rr in range(r - k + 1, r + 1) for cc in range(c - k + 1, c + 1)]

    def frame(caption, floor_marks=None, side_marks=None, moves=None, **answer):
        corner = best[1]
        tags = [[corner[0], corner[1], BEST]] if corner else []
        run.frame(caption, floor={"cells": floor, "marks": floor_marks or {}},
                  side={"cells": side, "marks": side_marks or {}, "tags": tags}, moves=moves, **answer)

    frame({"en": f"A {rows} × {cols} floor. Fill the side table tile by tile, row by row.",
           "ko": f"{rows} × {cols} 바닥입니다. 정사각형 변 표를 한 행씩, 타일마다 채웁니다."})
    for r in range(rows):
        for c in range(cols):
            here = f"({r},{c})"
            if floor[r][c] == "0":
                side[r][c] = 0
                frame({"en": f"Tile {here} has a desk, so no clear square ends here: 0.",
                       "ko": f"타일 {here}에는 책상이 있어 여기서 끝나는 빈 정사각형이 없습니다: 0."},
                      floor_marks={"lit": [[r, c]]}, side_marks={"good": [[r, c]]},
                      moves=[move(at("floor", [r, c]), at("side", [r, c]), value="0")])
                continue
            if r == 0 or c == 0:
                side[r][c] = 1
                en = f"Tile {here} is clear, on the {'top row' if r == 0 else 'left column'}: no room to grow, side 1."
                ko = f"타일 {here}: 비어 있지만 {'맨 윗행' if r == 0 else '맨 왼쪽 열'}이라 더 커질 수 없어 변은 1입니다."
                moves = [move(at("floor", [r, c]), at("side", [r, c]), value="1")]
                lit = []
            else:
                around = [(side[r - 1][c], [r - 1, c]), (side[r][c - 1], [r, c - 1]), (side[r - 1][c - 1], [r - 1, c - 1])]
                low, src = min(around, key=lambda a: a[0])
                side[r][c] = low + 1
                en = f"Tile {here} is clear; above {around[0][0]}, left {around[1][0]}, up-left {around[2][0]}, so " \
                     f"1 + the smallest, {low} + 1 = {low + 1}."
                ko = f"타일 {here}: 비어 있고, 위 {around[0][0]}, 왼쪽 {around[1][0]}, 왼쪽 위 {around[2][0]} 중 " \
                     f"가장 작은 값에 1을 더해 {low} + 1 = {low + 1}입니다."
                moves = [move(at("side", src), at("side", [r, c]), value=f"{low}+1")]
                lit = [a[1] for a in around]
            if side[r][c] > best[0]:
                best = (side[r][c], (r, c))
                en += " A new biggest square."
                ko += " 새 최대 정사각형입니다."
            frame({"en": en, "ko": ko}, floor_marks={"lit": [[r, c]]},
                  side_marks={"lit": lit, "good": [[r, c]]}, moves=moves)
    k, corner = best
    if corner is None:
        frame({"en": "No tile is clear, so there is no square. Answer: 0.",
               "ko": "빈 타일이 없어 정사각형도 없습니다. 답은 0입니다."}, answer="0")
        return
    frame({"en": f"The biggest side is {k}, ending at ({corner[0]},{corner[1]}): a {k} × {k} clear square, area "
                 f"{k} × {k} = {k * k}.",
           "ko": f"가장 큰 변은 ({corner[0]},{corner[1]})에서 끝나는 {k}입니다. {k} × {k} 빈 정사각형의 넓이는 "
                 f"{k} × {k} = {k * k}입니다."},
          floor_marks={"path": square(k, corner)}, side_marks={"path": [list(corner)]}, answer=str(k * k))


for number, sample in enumerate(sample_cases(SLUG), start=1):
    floor = json.loads(sample["input"])
    run = sample_run(wt, number, sample, input=f"floor = {sample['input']}")
    solve(floor, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
