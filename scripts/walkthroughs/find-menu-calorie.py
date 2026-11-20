#!/usr/bin/env python3.12
"""find-menu-calorie's Walkthrough: the reference solution (scripts/replay-solutions/find-menu-calorie.py), a
staircase search from the top-right corner, recording one frame per cell compared on each sample Test Case.
The grid is drawn as the description's Diagram; the cell compared is lit, the column or row it rules out is
marked bad in that frame and faded after, and the cells walked through are shaded, so the staircase shows.

    CODEBITE_DB=<database> scripts/walkthroughs/find-menu-calorie.py

writes common/src/main/resources/walkthroughs/find-menu-calorie.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough  # noqa: E402

SLUG = "find-menu-calorie"

wt = Walkthrough(
    {"en": "Find the Menu Calorie", "ko": "메뉴 칼로리 찾기"},
    {"en": "Start at the top-right cell, the largest of its row and the smallest of its column: bigger than "
           "target rules out its whole column, smaller rules out its whole row, so each comparison drops a line "
           "and the walk takes at most m + n steps.",
     "ko": "오른쪽 위 칸에서 시작합니다. 그 칸은 자기 행에서 가장 크고 자기 열에서 가장 작으므로, target보다 크면 그 열 "
           "전체를, 작으면 그 행 전체를 지울 수 있습니다. 비교마다 한 줄씩 지워 많아야 m + n번 만에 끝납니다."},
    views=[
        {"id": "menu", "type": "grid",
         "title": {"en": "menu (shaded: the walk, faded: ruled out)", "ko": "menu (칼로리 표, 음영: 지나온 칸, 흐림: 지운 칸)"}},
        {"id": "state", "type": "vars"},
    ],
)


def solve(menu, target, run):
    """Solution.findCalorie with a frame per comparison. Returns the answer as the Driver prints it."""
    m, n = len(menu), len(menu[0])
    row, col = 0, n - 1
    walk = []
    gone = set()  # cells ruled out

    def frame(caption, lit=(), bad=(), path=(), **answer):
        run.frame(caption,
                  menu={"cells": menu, "shade": [list(c) for c in walk],
                        "tags": [[r, c, {"en": "here", "ko": "여기"}] for r, c in lit],
                        "marks": {"dim": [list(c) for c in gone if c not in bad],
                                  "bad": [list(c) for c in bad], "lit": [list(c) for c in lit],
                                  "path": [list(c) for c in path]}},
                  state={"items": [{"label": {"en": "target", "ko": "target (목표)"}, "value": target}]},
                  **answer)

    frame({"en": f"Look for {target} in the {m} × {n} chart. Start at the top-right cell, row 0, column {n - 1}: "
                 f"everything left of it is smaller, everything below it bigger.",
           "ko": f"{m} × {n} 칼로리 표에서 target = {target} 값을 찾습니다. 오른쪽 위 칸(0행, {n - 1}열)에서 시작하며, 그 "
                 f"왼쪽은 모두 더 작고 아래는 모두 더 큽니다."})
    while row < m and col >= 0:
        value = menu[row][col]
        walk.append((row, col))
        here = f"menu[{row}][{col}] = {value}"
        if value == target:
            frame({"en": f"{here} is target: the chart has it, so the answer is true.",
                   "ko": f"{here}: target과 같습니다. 칼로리 표에 있으니 답은 true입니다."},
                  path=[(row, col)], answer="true")
            return
        if value > target:
            ruled = [(r, col) for r in range(row, m)]
            col -= 1
            en = (f"{here} > {target}, and every cell below it is bigger still: rule out column {col + 1} "
                  f"and step left to column {col}.")
            ko = (f"{here} > {target}: 그 아래 칸은 더 크므로 {col + 1}열을 지우고 왼쪽 {col}열로 갑니다.")
        else:
            ruled = [(row, c) for c in range(0, col + 1)]
            row += 1
            en = (f"{here} < {target}, and every cell left of it is smaller still: rule out row {row - 1} "
                  f"and step down to row {row}.")
            ko = (f"{here} < {target}: 그 왼쪽 칸은 더 작으므로 {row - 1}행을 지우고 아래 {row}행으로 갑니다.")
        if row == m or col < 0:
            en = en.rsplit(" and step", 1)[0] + ", which leaves no cell."
            ko = ko.rsplit("을 지우고", 1)[0] + "을 지우면 남은 칸이 없습니다."
        frame({"en": en, "ko": ko}, lit=[walk[-1]], bad=[c for c in ruled if c != walk[-1]])
        gone.update(ruled)
    frame({"en": f"The walk left the chart with every row or column ruled out, so no cell holds {target}: false.",
           "ko": f"모든 행이나 열을 지워 표 밖으로 나왔습니다. target = {target} 값인 칸이 없으니 답은 false입니다."},
          answer="false")


for number, sample in enumerate(sample_cases(SLUG), start=1):
    lines = sample["input"].split("\n")
    menu, target = json.loads(lines[0]), int(lines[1])
    run = sample_run(wt, number, sample, input=f"menu = {lines[0].strip()}, target = {target}")
    solve(menu, target, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
