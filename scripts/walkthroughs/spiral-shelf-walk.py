#!/usr/bin/env python3.12
"""spiral-shelf-walk's Walkthrough: the reference solution (scripts/replay-solutions/spiral-shelf-walk.py), four
boundaries closing in on the grid, recording one frame per side walked and one per ring finished on each sample
Test Case. The boundaries are the shaded rectangle still to visit; each cubby read moves into the answer and keeps
its place in the order as a tag.

    CODEBITE_DB=<database> scripts/walkthroughs/spiral-shelf-walk.py

writes common/src/main/resources/walkthroughs/spiral-shelf-walk.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import driver_list, josa, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move  # noqa: E402

SLUG = "spiral-shelf-walk"

wt = Walkthrough(
    {"en": "Spiral Shelf Walk", "ko": "나선형 선반 순회"},
    {"en": "Keep four boundaries (top, bottom, left, right): walk the ring they enclose, then move each one cubby "
           "inward, until they cross.",
     "ko": "네 경계(top, bottom, left, right)가 둘러싼 테두리를 한 바퀴 돈 뒤 경계를 한 칸씩 안으로 옮기고, "
           "경계가 엇갈릴 때까지 반복합니다."},
    views=[
        {"id": "shelf", "type": "grid",
         "title": {"en": "shelf (shaded: inside the boundaries, tag: visit order)",
                   "ko": "shelf (음영: 경계 안, 태그: 방문 순서)"}},
        {"id": "result", "type": "output", "title": {"en": "spiral order", "ko": "나선 순서"}},
    ],
)

SIDES = {
    "top": ({"en": "Top row, left to right", "ko": "위쪽 행을 왼쪽에서 오른쪽으로"}),
    "right": ({"en": "Right column, top to bottom", "ko": "오른쪽 열을 위에서 아래로"}),
    "bottom": ({"en": "Bottom row, right to left", "ko": "아래쪽 행을 오른쪽에서 왼쪽으로"}),
    "left": ({"en": "Left column, bottom to top", "ko": "왼쪽 열을 아래에서 위로"}),
}


def solve(shelf, run):
    """Solution.spiralOrder with a frame per side and per ring. Returns the order."""
    rows, cols = len(shelf), len(shelf[0])
    result = []
    order = {}  # (r, c) -> its 1-based place in the spiral
    top, bottom, left, right = 0, rows - 1, 0, cols - 1

    def frame(caption, read=(), moves=None, path=False, **answer):
        inside = [[r, c] for r in range(top, bottom + 1) for c in range(left, right + 1)]
        run.frame(caption,
                  shelf={"cells": shelf, "shade": inside,
                         "tags": [[r, c, str(k)] for (r, c), k in order.items()],
                         "marks": {"dim": [] if path else [[r, c] for (r, c) in order if (r, c) not in read],
                                   "lit": [[r, c] for r, c in read],
                                   "path": [[r, c] for (r, c) in order] if path else []}},
                  result={"values": result,
                          "marks": {"path": list(range(len(result)))} if path
                          else {"good": list(range(len(result) - len(read), len(result)))}},
                  moves=moves, **answer)

    def walk(side, cells):
        cells = list(cells)
        start = len(result)
        for r, c in cells:
            result.append(shelf[r][c])
            order[(r, c)] = len(result)
        values = ", ".join(str(shelf[r][c]) for r, c in cells)
        values_ko = "".join(f"{shelf[r][c]}, " for r, c in cells[:-1]) + josa(shelf[cells[-1][0]][cells[-1][1]], "을를")
        where = ({"en": f"row {cells[0][0]}", "ko": f"{cells[0][0]}행"} if side in ("top", "bottom")
                 else {"en": f"column {cells[0][1]}", "ko": f"{cells[0][1]}열"})
        frame({"en": f"{SIDES[side]['en']} ({where['en']}): {values} join the order.",
               "ko": f"{SIDES[side]['ko']} ({where['ko']}) 읽어 {values_ko} 순서에 붙입니다."},
              read=cells,
              moves=[move(at("shelf", [r, c]), at("result", start + k)) for k, (r, c) in enumerate(cells)])

    frame({"en": f"A {rows}×{cols} shelf. The boundaries start at the edges: top = 0, bottom = {bottom}, "
                 f"left = 0, right = {right}, so the shaded ring is the whole shelf.",
           "ko": f"{rows}×{cols} 선반입니다. 경계는 가장자리에서 시작해 top = 0, bottom = {bottom}, "
                 f"left = 0, right = {right}이므로 음영이 선반 전체입니다."})
    while top <= bottom and left <= right:
        walk("top", ((top, c) for c in range(left, right + 1)))
        down = [(r, right) for r in range(top + 1, bottom + 1)]
        if down:
            walk("right", down)
        skipped = []
        if top < bottom:
            back = [(bottom, c) for c in range(right - 1, left - 1, -1)]
            if back:
                walk("bottom", back)
            else:
                skipped.append("bottom")
        else:
            skipped.append("bottom")
        if left < right:
            up = [(r, left) for r in range(bottom - 1, top, -1)]
            if up:
                walk("left", up)
            else:
                skipped.append("left")
        else:
            skipped.append("left")
        if not down:
            skipped.insert(0, "right")
        top, bottom, left, right = top + 1, bottom - 1, left + 1, right - 1
        names = {"right": ("right column", "오른쪽 열"), "bottom": ("bottom row", "아래쪽 행"),
                 "left": ("left column", "왼쪽 열")}
        note_en = note_ko = ""
        if skipped:
            note_en = (" (the " + " and ".join(names[s][0] for s in skipped)
                       + " had no cubbies left that weren't read)")
            note_ko = " (" + ", ".join(names[s][1] for s in skipped) + "에는 읽지 않은 칸이 남아 있지 않았습니다)"
        if top <= bottom and left <= right:
            frame({"en": f"The ring is done{note_en}. Each boundary steps one cubby inward: "
                         f"top = {top}, bottom = {bottom}, left = {left}, right = {right}.",
                   "ko": f"한 바퀴를 마쳤습니다{note_ko}. 경계를 한 칸씩 안으로 옮겨 "
                         f"top = {top}, bottom = {bottom}, left = {left}, right = {right}입니다."})
        else:
            cross = ({"en": f"top = {top} passes bottom = {bottom}", "ko": f"top = {josa(top, '이가')} bottom = {bottom}보다 커져"}
                     if top > bottom else
                     {"en": f"left = {left} passes right = {right}", "ko": f"left = {josa(left, '이가')} right = {right}보다 커져"})
            frame({"en": f"The ring is done{note_en}. Stepping inward, {cross['en']}, so every cubby is read: "
                         f"answer {driver_list(result)}.",
                   "ko": f"한 바퀴를 마쳤습니다{note_ko}. 안으로 옮기면 {cross['ko']} 모든 칸을 읽었으므로 "
                         f"답은 {driver_list(result)}입니다."},
                  path=True, answer=driver_list(result))
    return result


for number, sample in enumerate(sample_cases(SLUG), start=1):
    shelf = json.loads(sample["input"])
    run = sample_run(wt, number, sample, input=f"shelf = {sample['input']}")
    solve(shelf, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
