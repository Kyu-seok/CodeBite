#!/usr/bin/env python3.12
"""valid-sudoku's Walkthrough: the reference solution (scripts/replay-solutions/valid-sudoku.py),
one pass over the board with one set of (row, digit), (column, digit) and (box, digit) keys,
recording one frame per filled cell on each sample Test Case.

    CODEBITE_DB=<database> scripts/walkthroughs/valid-sudoku.py

writes common/src/main/resources/walkthroughs/valid-sudoku.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough  # noqa: E402

SLUG = "valid-sudoku"

wt = Walkthrough(
    {"en": "Valid Sudoku", "ko": "유효한 스도쿠"},
    {"en": "One pass, one set: each digit leaves three keys (its row, its column, its 3×3 box); "
           "a digit whose key is already in the set is a repeat.",
     "ko": "한 번 훑고 집합 하나로 확인합니다: 숫자마다 행, 열, 3×3 박스 키 세 개를 남기고, "
           "이미 집합에 있는 키를 만든 숫자가 중복입니다."},
    views=[
        {"id": "board", "type": "grid", "title": {"en": "board", "ko": "보드"},
         "values": {".": {"label": {"en": "empty", "ko": "빈 칸"}, "tone": "empty", "glyph": ""}}},
        {"id": "lines", "type": "table",
         "title": {"en": "digits seen per row and column", "ko": "행과 열마다 본 숫자"}},
        {"id": "boxes", "type": "table",
         "title": {"en": "digits seen in each box (row ÷ 3, col ÷ 3)", "ko": "박스마다 본 숫자 (행 ÷ 3, 열 ÷ 3)"}},
        {"id": "state", "type": "vars"},
    ],
)


def solve(board, run):
    """Solution.isValidSudoku with a frame per filled cell. Returns nothing; the last frame has the answer."""
    seen = set()
    where = {}  # key -> the cell that put it in the set, so a repeat can point at both cells

    def digits(*prefix):
        return " ".join(d for d in "123456789" if (*prefix, d) in seen)

    def frame(caption, cell=None, lit=(), good=(), bad=(), path=(), lit_keys=(), good_keys=(), bad_keys=(), **answer):
        def table_marks(keys, kind):
            out = []
            for key in keys:
                if key[0] == kind == "box":
                    out.append([key[1], key[2]])
                elif key[0] == kind:
                    out.append([key[1], 0 if kind == "row" else 1])
            return out

        def marks(kind):
            return {"lit": table_marks(lit_keys, kind), "good": table_marks(good_keys, kind),
                    "bad": table_marks(bad_keys, kind)}

        line_marks = {name: marks("row")[name] + marks("col")[name] for name in ("lit", "good", "bad")}
        run.frame(caption,
                  board={"cells": board,
                         "marks": {"lit": [list(p) for p in lit], "good": [list(p) for p in good],
                                   "bad": [list(p) for p in bad], "path": [list(p) for p in path]}},
                  lines={"columns": [{"en": "row i", "ko": "i행"}, {"en": "col i", "ko": "i열"}],
                         "rows": [{"label": str(i), "cells": [digits("row", i), digits("col", i)]} for i in range(9)],
                         "marks": line_marks},
                  boxes={"columns": ["0", "1", "2"],
                         "rows": [{"label": str(br), "cells": [digits("box", br, bc) for bc in range(3)]}
                                  for br in range(3)],
                         "marks": marks("box")},
                  state={"items": [
                      {"label": {"en": "cell", "ko": "칸"}, "value": "–" if cell is None else f"{cell[0]},{cell[1]}"},
                      {"label": {"en": "keys in the set", "ko": "집합의 키"}, "value": len(seen)}]},
                  **answer)

    filled = sum(1 for row in board for d in row if d != ".")
    frame({"en": f"The board has {filled} filled cells. Read it row by row; an empty cell is skipped, "
                 "a digit is checked against the set of keys seen so far.",
           "ko": f"채워진 칸은 {filled}개입니다. 보드를 행 순서로 읽으며 빈 칸은 건너뛰고, "
                 "숫자는 지금까지 본 키의 집합과 비교합니다."})
    for r in range(9):
        for c in range(9):
            digit = board[r][c]
            if digit == ".":
                continue
            keys = [("row", r, digit), ("col", c, digit), ("box", r // 3, c // 3, digit)]
            hits = [key for key in keys if key in seen]
            if hits:
                first = where[hits[0]]
                names_en = {"row": f"row {r}", "col": f"column {c}", "box": f"box ({r // 3},{c // 3})"}
                names_ko = {"row": f"{r}행", "col": f"{c}열", "box": f"({r // 3},{c // 3}) 박스"}
                kind = hits[0][0]
                frame({"en": f"Cell {r},{c} holds {digit}, but {names_en[kind]} already has a {digit} "
                             f"(cell {first[0]},{first[1]}): a repeat, so the board is invalid. Answer false.",
                       "ko": f"{r},{c} 칸의 숫자 {digit}: {names_ko[kind]}에 같은 숫자가 이미 있습니다 "
                             f"({first[0]},{first[1]} 칸). 중복이므로 보드는 유효하지 않고, 답은 false입니다."},
                      cell=(r, c), bad=[(r, c), first], lit_keys=[k for k in keys if k not in hits],
                      bad_keys=hits, answer="false")
                return
            seen.update(keys)
            for key in keys:
                where[key] = (r, c)
            frame({"en": f"Cell {r},{c} holds {digit}: row {r}, column {c} and box ({r // 3},{c // 3}) "
                         f"have no {digit} yet, so all three keys go into the set.",
                   "ko": f"{r},{c} 칸의 숫자 {digit}: {r}행, {c}열, ({r // 3},{c // 3}) 박스에 같은 숫자가 아직 없으므로 "
                         "키 세 개를 모두 집합에 넣습니다."},
                  cell=(r, c), good=[(r, c)], good_keys=keys)
    done = [(r, c) for r in range(9) for c in range(9) if board[r][c] != "."]
    frame({"en": f"Every one of the {len(done)} digits added three new keys and none repeated, "
                 "so no row, column or box holds a digit twice. Answer true.",
           "ko": f"숫자 {len(done)}개가 모두 새 키 세 개씩을 더했고 겹친 키가 없으므로, "
                 "어떤 행, 열, 박스에도 같은 숫자가 두 번 나오지 않습니다. 답은 true입니다."},
          path=done, answer="true")


for number, sample in enumerate(sample_cases(SLUG), start=1):
    board = json.loads(sample["input"])
    run = sample_run(wt, number, sample, input=f"board = {sample['input']}")
    solve(board, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
