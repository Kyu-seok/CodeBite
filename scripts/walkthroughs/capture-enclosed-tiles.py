#!/usr/bin/env python3.12
"""capture-enclosed-tiles' Walkthrough: the reference solution (scripts/replay-solutions/capture-enclosed-tiles.py),
which marks every border 'O' safe ('S'), floods from them with a stack, then flips the rest, on each sample Test
Case. The board is drawn as the description's grid Diagram draws it; a frame per tile popped that saves new tiles
(and one for pushing them), one for each run of pops that save nothing, and one for each half of the flip.

    CODEBITE_DB=<database> scripts/walkthroughs/capture-enclosed-tiles.py

writes common/src/main/resources/walkthroughs/capture-enclosed-tiles.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import cell_name, driver_list, listed_cells, plural, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move  # noqa: E402

SLUG = "capture-enclosed-tiles"

wt = Walkthrough(
    {"en": "Capture Enclosed Tiles", "ko": "갇힌 영역 점령"},
    {"en": "Work from the border in: every 'O' on the border is safe, and so is every 'O' a safe tile touches. Mark "
           "them 'S' with a stack, then every 'O' left is captured and the 'S' tiles turn back into 'O'.",
     "ko": "테두리에서 안쪽으로 찾습니다. 테두리의 'O' 타일은 살아남고, 살아남은 타일에 맞닿은 'O' 타일도 살아남습니다. 스택으로 "
           "그런 타일에 'S' 표시를 하고 나면, 남은 'O' 타일은 모두 점령되고 'S' 타일은 다시 'O' 타일이 됩니다."},
    views=[
        {"id": "board", "type": "grid", "title": {"en": "board", "ko": "board (보드)"},
         "values": {"X": {"label": {"en": "your tile", "ko": "내 타일"}, "tone": "plain"},
                    "O": {"label": {"en": "enemy tile", "ko": "적 타일"}, "tone": "b"},
                    "S": {"label": {"en": "safe: reaches the border", "ko": "안전: 테두리에 닿음"}, "tone": "c"}}},
        {"id": "stack", "type": "stack", "title": {"en": "stack: safe tiles to spread from",
                                                    "ko": "스택: 퍼져 나갈 안전한 타일"},
         "empty": {"en": "empty", "ko": "비어 있음"}},
    ],
)


def solve(board, run):
    """Solution.captureEnclosedTiles with a frame per step. Returns the board as the Driver prints it."""
    rows, cols = len(board), len(board[0])
    todo = []       # the stack, bottom first
    leaving = []    # the tiles popped this frame, still drawn on top, first popped on top

    def frame(caption, lit=(), good=(), bad=(), path=(), stack_marks=None, moves=None, **answer):
        run.frame(caption,
                  board={"cells": board,
                         "marks": {"path": [list(p) for p in path], "bad": [list(p) for p in bad],
                                   "good": [list(p) for p in good], "lit": [list(p) for p in lit]}},
                  stack={"values": [cell_name(p) for p in todo + leaving[::-1]], "marks": stack_marks or {}},
                  moves=moves, **answer)

    enemy = sum(row.count("O") for row in board)
    frame({"en": f"A {rows}×{cols} board with {enemy} enemy {plural(enemy, 'tile', 'tiles')}. An 'O' survives only "
                 f"if 'O' tiles link it to the border, so start from the border.",
           "ko": f"{rows}×{cols} 보드에 적 타일이 {enemy}개 있습니다. 'O' 타일을 따라 테두리에 이어진 'O'만 살아남으므로 "
                 f"테두리에서 시작합니다."})

    border = []
    for r in range(rows):
        for c in range(cols):
            if (r in (0, rows - 1) or c in (0, cols - 1)) and board[r][c] == "O":
                board[r][c] = "S"
                border.append((r, c))
    todo[:] = border
    b = len(border)
    if b:
        frame({"en": f"{b} border {plural(b, 'tile is', 'tiles are')} 'O': {listed_cells(border)}. Mark "
                     f"{plural(b, 'it', 'each')} safe ('S') and push {plural(b, 'it', 'them')} onto the stack.",
               "ko": f"테두리의 'O' 타일 {b}개, {listed_cells(border)} 칸을 안전('S')으로 표시하고 스택에 넣습니다."},
              good=border, stack_marks={"good": list(range(b))},
              moves=[m for i, p in enumerate(border)
                     for m in (move(None, at("board", list(p)), value="S"),
                               move(at("board", list(p)), at("stack", i), value=cell_name(p)))])
    else:
        frame({"en": "No border tile is 'O', so nothing is safe and the stack stays empty.",
               "ko": "테두리에 'O' 타일이 없으므로 안전한 타일이 없고 스택은 비어 있습니다."})

    def flush():
        """One frame for the pops in a row that saved nothing."""
        if not leaving:
            return
        k = len(leaving)
        base = len(todo)
        end = {"en": " The stack is empty.", "ko": " 스택이 비었습니다."} if not todo else {"en": "", "ko": ""}
        frame({"en": f"Pop {listed_cells(leaving)}: no neighbour is an 'O' still unmarked, so "
                     f"{plural(k, 'it saves', 'they save')} nothing." + end["en"],
               "ko": f"{listed_cells(leaving)} 칸을 꺼내지만, 아직 표시하지 않은 'O' 이웃이 없어 살릴 타일이 없습니다."
                     + end["ko"]},
              lit=list(leaving), stack_marks={"lit": list(range(base, base + k))},
              moves=[move(at("stack", base + i)) for i in range(k)])
        leaving.clear()

    while todo:
        r, c = todo.pop()
        added = [(nr, nc) for nr, nc in ((r + 1, c), (r - 1, c), (r, c + 1), (r, c - 1))
                 if 0 <= nr < rows and 0 <= nc < cols and board[nr][nc] == "O"]
        if not added:
            leaving.append((r, c))
            if not todo:
                flush()
            continue
        todo.append((r, c))  # still on the stack while the pops before it are drawn
        flush()
        todo.pop()
        for nr, nc in added:
            board[nr][nc] = "S"
        leaving.append((r, c))
        top = len(todo)
        n = len(added)
        frame({"en": f"Pop ({cell_name((r, c))}): {listed_cells(added)} {plural(n, 'is an', 'are')} 'O' next to a safe tile, "
                     f"so {plural(n, 'it is', 'they are')} safe too.",
               "ko": f"({cell_name((r, c))}) 칸을 꺼냅니다. 맞닿은 'O' 타일 {listed_cells(added)} 칸도 안전한 타일과 이어져 "
                     f"있으므로 'S' 표시를 합니다."},
              lit=[(r, c)], good=added, stack_marks={"lit": [top]},
              moves=[move(at("stack", top), at("board", list(p)), value="S") for p in added])
        leaving.clear()
        todo.extend(added)
        frame({"en": f"Push {listed_cells(added)}, to spread on from {plural(n, 'it', 'them')}.",
               "ko": f"{listed_cells(added)} 칸을 스택에 넣어, 거기서 계속 퍼져 나갑니다."},
              good=added, stack_marks={"good": list(range(top, len(todo)))},
              moves=[move(at("board", list(p)), at("stack", top + i), value=cell_name(p)) for i, p in enumerate(added)])

    captured = [(r, c) for r in range(rows) for c in range(cols) if board[r][c] == "O"]
    if captured:
        for r, c in captured:
            board[r][c] = "X"
        k = len(captured)
        frame({"en": f"Now sweep the board. {plural(k, 'The one', 'The')} 'O' still unmarked, {listed_cells(captured)}, "
                     f"cannot reach the border: {plural(k, 'it is', 'they are')} captured and become 'X'.",
               "ko": f"이제 보드를 훑습니다. 표시되지 않은 'O' 타일 {listed_cells(captured)} 칸은 테두리에 닿을 수 없어 "
                     f"점령되어 'X' 타일이 됩니다."},
              bad=captured, moves=[move(None, at("board", list(p)), value="X", mark="bad") for p in captured])
    safe = [(r, c) for r in range(rows) for c in range(cols) if board[r][c] == "S"]
    for r, c in safe:
        board[r][c] = "O"
    result = driver_list(board)
    none = {"en": "No 'O' was captured, and the ", "ko": "점령된 'O' 타일은 없고, "} if not captured else \
        {"en": "The ", "ko": ""}
    frame({"en": f"{none['en']}safe tiles turn back into 'O'. Answer: {result}.",
           "ko": f"{none['ko']}안전한 'S' 타일은 다시 'O' 타일이 됩니다. 답은 {result}입니다."},
          path=safe, moves=[move(None, at("board", list(p)), value="O") for p in safe], answer=result)


for number, sample in enumerate(sample_cases(SLUG), start=1):
    board = json.loads(sample["input"])
    run = sample_run(wt, number, sample, input=f"board = {sample['input']}")
    solve(board, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
