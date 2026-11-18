#!/usr/bin/env python3.12
"""count-dungeon-paths' Walkthrough: the grid DP over the dungeon, filling each tile with the number of paths that
reach it (the paths from above plus the paths from the left), one frame per tile in row order, on each sample Test
Case.

The reference solution (scripts/replay-solutions/count-dungeon-paths.py) returns the same count in closed form,
C(rows + cols - 2, rows - 1); the picks for #359 chose this problem to show the grid DP, which is the table that
formula counts, so the tracer fills it and the last caption names the formula. Each tile's count moves in from the
tile above and the tile to the left.

    CODEBITE_DB=<database> scripts/walkthroughs/count-dungeon-paths.py

writes common/src/main/resources/walkthroughs/count-dungeon-paths.json.
"""
import os
import sys
from math import comb

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import josa, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move  # noqa: E402

SLUG = "count-dungeon-paths"
START = {"en": "start", "ko": "출발"}
TREASURE = {"en": "treasure", "ko": "보물"}

wt = Walkthrough(
    {"en": "Count Dungeon Paths", "ko": "던전 경로 수 세기"},
    {"en": "A tile can only be entered from the tile above or the tile to its left, so the paths reaching it are "
           "the paths reaching those two, added: fill the grid row by row, and the treasure tile holds the answer.",
     "ko": "타일에는 위 타일이나 왼쪽 타일에서만 들어올 수 있으므로, 그 타일에 오는 경로 수는 두 타일의 경로 수를 "
           "더한 값입니다. 격자를 한 행씩 채우면 보물 타일에 답이 남습니다."},
    views=[
        {"id": "dungeon", "type": "grid", "title": {"en": "paths reaching each tile", "ko": "타일별 경로 수"},
         "values": {"": {"tone": "empty", "glyph": ""}}},
    ],
)


def solve(rows, cols, run):
    """The grid DP with a frame per tile. Returns the answer as the Driver prints it."""
    paths = [[""] * cols for _ in range(rows)]
    tags = [[0, 0, START]] + ([[rows - 1, cols - 1, TREASURE]] if (rows, cols) != (1, 1) else [])

    def frame(caption, marks=None, moves=None, **answer):
        run.frame(caption, dungeon={"cells": paths, "tags": tags, "marks": marks or {}}, moves=moves, **answer)

    paths[0][0] = 1
    frame({"en": f"A {rows} × {cols} dungeon. The start tile is reached one way, by standing on it: 1 path.",
           "ko": f"{rows} × {cols} 던전입니다. 출발 타일에는 그 자리에 서 있는 한 가지 방법뿐이므로 경로 수는 1입니다."},
          marks={"good": [[0, 0]]})
    for r in range(rows):
        for c in range(cols):
            if r == 0 and c == 0:
                continue
            above = paths[r - 1][c] if r > 0 else 0
            left = paths[r][c - 1] if c > 0 else 0
            paths[r][c] = above + left
            here = f"({r},{c})"
            moves, lit = [], []
            if r > 0:
                moves.append(move(at("dungeon", [r - 1, c]), at("dungeon", [r, c]), value=str(above)))
                lit.append([r - 1, c])
            if c > 0:
                moves.append(move(at("dungeon", [r, c - 1]), at("dungeon", [r, c]), value=str(left)))
                lit.append([r, c - 1])
            if r == 0:
                en = f"Tile {here} is on the top row: it can only be entered from the left, so it has the same " \
                     f"count, {left}."
                ko = f"타일 {here}: 맨 윗행이라 왼쪽에서만 들어올 수 있으므로 경로 수도 똑같이 " \
                     f"{left}입니다."
            elif c == 0:
                en = f"Tile {here} is in the left column: it can only be entered from above, so it has the same " \
                     f"count, {above}."
                ko = f"타일 {here}: 맨 왼쪽 열이라 위에서만 들어올 수 있으므로 경로 수도 똑같이 " \
                     f"{above}입니다."
            else:
                en = f"Tile {here}: {above} {'path comes' if above == 1 else 'paths come'} from above and {left} " \
                     f"from the left, so {above} + {left} = {paths[r][c]}."
                ko = f"타일 {here}: 위에서 {above}가지, 왼쪽에서 {left}가지가 오므로 {above} + {left} = " \
                     f"{paths[r][c]}가지입니다."
            frame({"en": en, "ko": ko}, marks={"lit": lit, "good": [[r, c]]}, moves=moves)
    total = paths[rows - 1][cols - 1]
    downs, rights = rows - 1, cols - 1
    frame({"en": f"The treasure tile holds {total}: the number of ways to order {downs} moves down among "
                 f"{downs + rights} moves, C({downs + rights}, {downs}) = {comb(downs + rights, downs)}.",
           "ko": f"보물 타일의 값은 {total}입니다. 이동 {downs + rights}번 중 아래로 가는 {downs}번의 순서를 고르는 "
                 f"방법의 수 C({downs + rights}, {downs}) = {josa(comb(downs + rights, downs), '과와')} 같습니다."},
          marks={"path": [[rows - 1, cols - 1]]}, answer=str(total))


for number, sample in enumerate(sample_cases(SLUG), start=1):
    rows_line, cols_line = sample["input"].split("\n")
    rows, cols = int(rows_line), int(cols_line)
    run = sample_run(wt, number, sample, input=f"rows = {rows}, cols = {cols}")
    solve(rows, cols, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
