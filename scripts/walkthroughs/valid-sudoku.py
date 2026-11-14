#!/usr/bin/env python3.12
"""valid-sudoku's Walkthrough: the reference solution (scripts/replay-solutions/valid-sudoku.py),
one pass over the board, recording one frame per filled cell on each sample Test Case.

The solution keeps one set of (row, digit), (column, digit) and (box, digit) keys; the drawing keeps
the same facts the way a solver pictures them, one map per key family from a region ("row 1") to the
digits seen there, so a key ("row", 1, "5") is in the set exactly when row 1's card holds a 5. Each
digit is looked up in its row's, then its column's, then its box's card, stopping at the first hit
as `any(key in seen for key in keys)` does.

    CODEBITE_DB=<database> scripts/walkthroughs/valid-sudoku.py

writes common/src/main/resources/walkthroughs/valid-sudoku.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import josa, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move  # noqa: E402

SLUG = "valid-sudoku"

FAMILIES = ("rows", "cols", "boxes")  # one map view per key family, looked up in this order

wt = Walkthrough(
    {"en": "Valid Sudoku", "ko": "유효한 스도쿠"},
    {"en": "One pass over the board: each row, column and 3×3 box remembers the digits seen in it, and a digit "
           "already in its row's, column's or box's list is a repeat.",
     "ko": "보드를 한 번 훑습니다: 행, 열, 3×3 박스마다 그 안에서 본 숫자를 기억하고, 숫자가 자기 행, 열, 박스의 "
           "목록에 이미 있으면 중복입니다."},
    views=[
        {"id": "board", "type": "grid", "title": {"en": "board", "ko": "보드"}, "boxes": 3,
         "values": {".": {"label": {"en": "empty", "ko": "빈 칸"}, "glyph": ""}}},
        {"id": "rows", "type": "map", "title": {"en": "rows: digits seen", "ko": "행: 본 숫자"},
         "empty": {"en": "no row yet", "ko": "아직 없음"}},
        {"id": "cols", "type": "map", "title": {"en": "columns: digits seen", "ko": "열: 본 숫자"},
         "empty": {"en": "no column yet", "ko": "아직 없음"}},
        {"id": "boxes", "type": "map", "title": {"en": "boxes: digits seen", "ko": "박스: 본 숫자"},
         "empty": {"en": "no box yet", "ko": "아직 없음"}},
    ],
)


def regions(r, c):
    """The cell's row, column and box, by family: each (map key, English name, Korean name)."""
    return {"rows": (f"row {r}", f"row {r}", f"{r}행"),
            "cols": (f"col {c}", f"column {c}", f"{c}열"),
            "boxes": (f"box {r // 3},{c // 3}", f"box ({r // 3},{c // 3})", f"({r // 3},{c // 3}) 박스")}


def region_cells(r, c):
    """Every cell of the cell's row, column and 3×3 box: the band the step works in."""
    br, bc = r // 3 * 3, c // 3 * 3
    cells = {(r, j) for j in range(9)} | {(i, c) for i in range(9)}
    cells |= {(br + i, bc + j) for i in range(3) for j in range(3)}
    return sorted(cells)


def solve(board, run):
    """Solution.isValidSudoku with a frame per filled cell. Returns nothing; the last frame has the answer."""
    seen = {f: {} for f in FAMILIES}  # family -> region key -> digits seen there, in order (a dict as an ordered set)
    names = {}  # region key -> (English, Korean) name, the card's label
    where = {}  # (region key, digit) -> the cell that put it there, so a repeat can point at both cells

    def frame(caption, cell=None, bad=(), path=(), probes=None, good_keys=(), bad_chip=None, all_path=False,
              moves=None, **answer):
        maps = {}
        for f in FAMILIES:
            entries = []
            for key, digits in seen[f].items():
                entry = {"key": key, "label": {"en": names[key][0], "ko": names[key][1]}, "value": list(digits)}
                if bad_chip and bad_chip[0] == key:
                    entry["marks"] = {"bad": [list(digits).index(bad_chip[1])]}
                entries.append(entry)
            maps[f] = {"entries": entries,
                       "marks": {"good": [k for k in good_keys if k in seen[f]],
                                 "path": list(seen[f]) if all_path else []}}
            if probes and f in probes:
                maps[f]["probe"] = probes[f]
        grid = {"cells": board,
                "marks": {"lit": [list(cell)] if cell and not bad else [], "bad": [list(p) for p in bad],
                          "path": [list(p) for p in path]}}
        if cell:
            grid["shade"] = [list(p) for p in region_cells(*cell)]
        run.frame(caption, board=grid, moves=moves, **maps, **answer)

    filled = sum(1 for row in board for d in row if d != ".")
    frame({"en": f"The board has {filled} filled cells. Read it row by row, skipping empty cells; each digit is "
                 "looked up in the digits its row, column and box have seen so far.",
           "ko": f"채워진 칸은 {filled}개입니다. 보드를 행 순서로 읽으며 빈 칸은 건너뛰고, 숫자마다 그 행, 열, "
                 "박스에서 지금까지 본 숫자 중에 있는지 찾아봅니다."})
    for r in range(9):
        for c in range(9):
            digit = board[r][c]
            if digit == ".":
                continue
            regs = regions(r, c)
            probes, hit = {}, None
            for f in FAMILIES:  # any() stops at the first region that has seen the digit
                key, en, ko = regs[f]
                found = digit in seen[f].get(key, {})
                probes[f] = {"key": key, "hit": found,
                             "label": {"en": f"{digit} in {en}?", "ko": f"{ko}에 {digit}?"}}
                if found:
                    hit = f
                    break
            if hit:
                key, en, ko = regs[hit]
                first = where[(key, digit)]
                frame({"en": f"Cell {r},{c} holds {digit}, and {en} has seen a {digit} already, at cell "
                             f"{first[0]},{first[1]}. A repeat, so the answer is false.",
                       "ko": f"{r},{c} 칸의 숫자 {digit}: {ko}에서 이미 {first[0]},{first[1]} 칸의 "
                             f"{josa(int(digit), '을를')} 봤습니다. 중복이므로 답은 false입니다."},
                      cell=(r, c), bad=[(r, c), first], probes=probes, bad_chip=(key, digit), answer="false",
                      moves=[move(at("board", [r, c]), at(hit, key), value=digit, mark="bad")])
                return
            for f in FAMILIES:
                key, en, ko = regs[f]
                names[key] = (en, ko)
                seen[f].setdefault(key, {})[digit] = True
                where[(key, digit)] = (r, c)
            en = ", ".join(regs[f][1] for f in FAMILIES)
            ko = ", ".join(regs[f][2] for f in FAMILIES)
            frame({"en": f"Cell {r},{c} holds {digit}: {en} have not seen a {digit} yet, so it goes into all three.",
                   "ko": f"{r},{c} 칸의 숫자 {digit}: {ko} 어디에도 아직 {josa(int(digit), '이가')} 없으므로 "
                         "세 곳 모두에 넣습니다."},
                  cell=(r, c), probes=probes, good_keys=[regs[f][0] for f in FAMILIES],
                  moves=[move(at("board", [r, c]), at(f, regs[f][0]), value=digit) for f in FAMILIES])
    done = [(r, c) for r in range(9) for c in range(9) if board[r][c] != "."]
    frame({"en": f"All {len(done)} digits went in without a repeat, so no row, column or box holds a digit "
                 "twice. Answer true.",
           "ko": f"숫자 {len(done)}개가 모두 중복 없이 들어갔으므로, 어떤 행, 열, 박스에도 같은 숫자가 두 번 "
                 "나오지 않습니다. 답은 true입니다."},
          path=done, all_path=True, answer="true")


for number, sample in enumerate(sample_cases(SLUG), start=1):
    board = json.loads(sample["input"])
    run = sample_run(wt, number, sample, input=f"board = {sample['input']}")
    solve(board, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
