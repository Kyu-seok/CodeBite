#!/usr/bin/env python3.12
"""min-wait-drive's Walkthrough: the reference solution (scripts/replay-solutions/min-wait-drive.py), the smallest
total wait to reach each intersection (the cheaper of the totals above and to the left, plus its own wait), one frame
per intersection in row order, on each sample Test Case.

The solution keeps one row (`cost`); the Walkthrough draws the whole table it rolls through, as a grid the map's shape
beside the map, which is drawn as the description's Diagram draws it. Each total moves in from the cheaper neighbour
and takes the intersection's own wait from the map; the tracer keeps each choice, so the last frame marks the route on
both.

    CODEBITE_DB=<database> scripts/walkthroughs/min-wait-drive.py

writes common/src/main/resources/walkthroughs/min-wait-drive.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import josa, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move  # noqa: E402

SLUG = "min-wait-drive"
UNSET = " "

wt = Walkthrough(
    {"en": "Min Wait Drive", "ko": "최소 대기 경로"},
    {"en": "An intersection is entered from the north or the west, so the least wait to reach it is the cheaper of "
           "those two totals plus its own wait. Fill the totals row by row; the bottom-right one is the answer.",
     "ko": "교차로에는 위나 왼쪽에서만 들어올 수 있으므로, 그곳까지의 최소 대기는 두 합계 중 작은 값에 그 교차로의 대기를 "
           "더한 값입니다. 한 행씩 채우면 오른쪽 아래 값이 답입니다."},
    views=[
        {"id": "grid", "type": "grid", "title": {"en": "wait at each intersection", "ko": "교차로별 대기 시간"}},
        {"id": "cost", "type": "grid", "title": {"en": "least total wait to get here", "ko": "여기까지의 최소 대기 합계"},
         "values": {UNSET: {"glyph": "", "tone": "empty"}}},
    ],
)


def solve(grid, run):
    """Solution.minWaitRoute with a frame per intersection, the whole cost table drawn. Returns the answer as the Driver
    prints it."""
    rows, cols = len(grid), len(grid[0])
    cost = [[UNSET] * cols for _ in range(rows)]
    came = {}

    def frame(caption, grid_marks=None, cost_marks=None, moves=None, **answer):
        run.frame(caption, grid={"cells": grid, "marks": grid_marks or {}},
                  cost={"cells": cost, "marks": cost_marks or {}}, moves=moves, **answer)

    frame({"en": f"A {rows} × {cols} map, driving from the top-left to the bottom-right, east or south only.",
           "ko": f"{rows} × {cols} 지도에서 왼쪽 위부터 오른쪽 아래까지 동쪽이나 남쪽으로만 갑니다."})
    for r in range(rows):
        for c in range(cols):
            w = grid[r][c]
            here = f"({r},{c})"
            moves = [move(at("grid", [r, c]), at("cost", [r, c]), value=f"+{w}")]
            if r == 0 and c == 0:
                cost[r][c] = w
                en, ko, lit = f"The start {here} costs its own wait: {w}.", f"출발점 {here}: 자기 대기만 듭니다: {w}.", []
            else:
                options = []
                if r > 0:
                    options.append((cost[r - 1][c], (r - 1, c)))
                if c > 0:
                    options.append((cost[r][c - 1], (r, c - 1)))
                best, src = min(options, key=lambda o: o[0])
                came[(r, c)] = src
                cost[r][c] = best + w
                moves.insert(0, move(at("cost", list(src)), at("cost", [r, c])))
                lit = [list(s) for _, s in options]
                if len(options) == 1:
                    side_en = "from the north" if r > 0 else "from the west"
                    side_ko = "위에서만" if r > 0 else "왼쪽에서만"
                    en = f"{here} can only be reached {side_en}: {best} + its wait {w} = {best + w}."
                    ko = f"{here}에는 {side_ko} 올 수 있습니다: {best} + 대기 {w} = {best + w}."
                else:
                    en = f"{here}: north {options[0][0]}, west {options[1][0]}; the cheaper is {best}, plus its wait " \
                         f"{w} = {best + w}."
                    ko = f"{here}: 위 {options[0][0]}, 왼쪽 {options[1][0]} 중 작은 {best}에 대기 {josa(w, '을를')} 더해 " \
                         f"{best + w}입니다."
            frame({"en": en, "ko": ko}, grid_marks={"lit": [[r, c]]}, cost_marks={"lit": lit, "good": [[r, c]]},
                  moves=moves)
    route, here = [[rows - 1, cols - 1]], (rows - 1, cols - 1)
    while here in came:
        here = came[here]
        route.append(list(here))
    route.reverse()
    answer = cost[rows - 1][cols - 1]
    waits = " → ".join(str(grid[r][c]) for r, c in route)
    frame({"en": f"The bottom-right total, {answer}, is the answer. Walking back along each cheaper choice gives the "
                 f"route {waits}." if len(route) > 1 else
                 f"The only intersection is the start and the end: its wait, {answer}, is the answer.",
           "ko": f"오른쪽 아래 합계 {josa(answer, '이가')} 답입니다. 더 작은 쪽을 거슬러 가면 경로가 나옵니다: {waits}." if len(route) > 1
                 else f"교차로가 하나뿐이라 출발점이 곧 도착점이고, 그 대기 {josa(answer, '이가')} 답입니다."},
          grid_marks={"path": route}, cost_marks={"path": route}, answer=str(answer))


for number, sample in enumerate(sample_cases(SLUG), start=1):
    grid = json.loads(sample["input"])
    run = sample_run(wt, number, sample, input=f"grid = {sample['input']}")
    solve(grid, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
