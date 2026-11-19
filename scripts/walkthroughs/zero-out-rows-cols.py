#!/usr/bin/env python3.12
"""zero-out-rows-cols's Walkthrough: the reference solution (scripts/replay-solutions/zero-out-rows-cols.py), two
passes over the board, recording one frame per row scanned in the first (each 0 adds its row and column to the
sets) and, when a set holds anything, one per cell in the second (the cell's row looked up, then its column unless
the row hit, a hit writing 0); on each sample Test Case. With both sets empty the second pass is one frame.

    CODEBITE_DB=<database> scripts/walkthroughs/zero-out-rows-cols.py

writes common/src/main/resources/walkthroughs/zero-out-rows-cols.json.
"""
import copy
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import driver_list, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move, probe  # noqa: E402

SLUG = "zero-out-rows-cols"

wt = Walkthrough(
    {"en": "Zero Out Rows and Cols", "ko": "행과 열을 0으로 지우기"},
    {"en": "First pass: note the row and column of every original 0 in two sets. Second pass: a cell whose row or "
           "column is in a set becomes 0. The new zeros never reach the sets, so only the original ones wipe.",
     "ko": "첫 번째 순회에서 원래 0인 칸의 행과 열을 두 집합에 적어 두고, 두 번째 순회에서 행이나 열이 집합에 있는 "
           "칸을 0으로 바꿉니다. 새로 생긴 0은 집합에 들어가지 않으므로 원래 0만 지웁니다."},
    views=[
        {"id": "board", "type": "grid", "title": {"en": "board", "ko": "board (보드)"}},
        {"id": "rows", "type": "set", "title": {"en": "zero_rows", "ko": "zero_rows (0이 있는 행)"},
         "empty": {"en": "no row yet", "ko": "아직 없음"}},
        {"id": "cols", "type": "set", "title": {"en": "zero_cols", "ko": "zero_cols (0이 있는 열)"},
         "empty": {"en": "no column yet", "ko": "아직 없음"}},
    ],
)


def solve(board, run):
    """Solution.zeroOutRowsAndCols with a frame per row scanned and per cell checked. Returns the board."""
    original = copy.deepcopy(board)
    rows, cols = [], []  # the sets, in the order their members went in

    def frame(caption, lit=(), good=(), path=(), shade=(), row_probe=None, col_probe=None, row_good=(), col_good=(),
              moves=None, **answer):
        run.frame(caption,
                  board={"cells": copy.deepcopy(board), "shade": [list(x) for x in shade],
                         "marks": {"lit": [list(x) for x in lit], "good": [list(x) for x in good],
                                   "path": [list(x) for x in path]}},
                  rows={"members": list(rows), "probes": [row_probe] if row_probe else [],
                        "marks": {"good": list(row_good)}},
                  cols={"members": list(cols), "probes": [col_probe] if col_probe else [],
                        "marks": {"good": list(col_good)}},
                  moves=moves, **answer)

    m, n = len(board), len(board[0])
    frame({"en": f"A {m}×{n} board. First pass: find every 0 and note its row and column.",
           "ko": f"{m}×{n} 보드입니다. 첫 번째 순회에서 0을 모두 찾아 그 행과 열을 적어 둡니다."})
    for r in range(m):
        zeros = [c for c in range(n) if board[r][c] == 0]
        cells = [(r, c) for c in range(n)]
        if not zeros:
            frame({"en": f"Row {r} has no 0.", "ko": f"{r}행에는 0이 없습니다."}, lit=cells)
            continue
        new_rows = [] if r in rows else [r]
        new_cols = [c for c in zeros if c not in cols]
        rows.extend(new_rows)
        cols.extend(new_cols)
        moves = [move(at("board", [r, zeros[0]]), at("rows", r), value=str(r))] if new_rows else []
        moves += [move(at("board", [r, c]), at("cols", c), value=str(c)) for c in new_cols]
        where = ", ".join(str(c) for c in zeros)
        frame({"en": f"Row {r} has a 0 in column {where}: row {r} goes into zero_rows and column {where} into zero_cols.",
               "ko": f"{r}행의 {where}열에 0이 있습니다. {r}행을 zero_rows에, {where}열을 zero_cols에 넣습니다."},
              lit=[(r, c) for c in zeros], row_good=new_rows, col_good=new_cols, moves=moves or None)
    written = []
    if not rows:
        frame({"en": "No 0 was found, so both sets are empty: the second pass finds no cell to change.",
               "ko": "0이 없어 두 집합이 모두 비었으므로, 두 번째 순회에서 바꿀 칸이 없습니다."})
    else:
        frame({"en": "Second pass: each cell looks up its row in zero_rows, then its column in zero_cols.",
               "ko": "두 번째 순회: 칸마다 행을 zero_rows에서, 이어서 열을 zero_cols에서 찾습니다."})
        for r in range(m):
            for c in range(n):
                row_hit = r in rows
                rp = probe(r, label={"en": f"row {r}?", "ko": f"{r}행?"})
                cp = None if row_hit else probe(c, label={"en": f"col {c}?", "ko": f"{c}열?"})
                if row_hit or c in cols:
                    was = board[r][c]
                    board[r][c] = 0
                    written.append((r, c))
                    src = at("rows", r) if row_hit else at("cols", c)
                    why = ({"en": f"row {r} is in zero_rows", "ko": f"{r}행이 zero_rows에 있으므로"} if row_hit
                           else {"en": f"column {c} is in zero_cols", "ko": f"{c}열이 zero_cols에 있으므로"})
                    if was == 0:
                        en, ko = (f"Cell ({r}, {c}): {why['en']}; it is an original 0 and stays 0.",
                                  f"({r}, {c}) 칸: {why['ko']} 0을 씁니다. 원래 0인 칸이라 그대로 0입니다.")
                    else:
                        en, ko = (f"Cell ({r}, {c}): {why['en']}, so {was} becomes 0.",
                                  f"({r}, {c}) 칸: {why['ko']} {was}에서 0으로 바뀝니다.")
                    frame({"en": en, "ko": ko}, good=[(r, c)], row_probe=rp, col_probe=cp,
                          moves=[move(src, at("board", [r, c]), value="0")])
                else:
                    frame({"en": f"Cell ({r}, {c}): neither row {r} nor column {c} is in a set, so {board[r][c]} stays.",
                           "ko": f"({r}, {c}) 칸: {r}행도 {c}열도 집합에 없으므로 {board[r][c]} 그대로입니다."},
                          lit=[(r, c)], row_probe=rp, col_probe=cp)
    answer = driver_list(board)
    changed = [(r, c) for r, c in written if original[r][c] != 0]
    if changed:
        en = f"Every cell in a row or column of an original 0 is 0 now: answer {answer}."
        ko = f"원래 0이 있던 행과 열의 칸이 모두 0이 되었습니다. 답은 {answer}입니다."
    else:
        en, ko = f"The board is unchanged: answer {answer}.", f"보드는 그대로입니다. 답은 {answer}입니다."
    frame({"en": en, "ko": ko}, path=written, answer=answer)
    return board


for number, sample in enumerate(sample_cases(SLUG), start=1):
    board = json.loads(sample["input"])
    run = sample_run(wt, number, sample, input=f"board = {sample['input']}")
    solve(board, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
