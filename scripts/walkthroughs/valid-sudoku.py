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
from walkthrough_trace import Walkthrough, at, move, probe  # noqa: E402

SLUG = "valid-sudoku"

FAMILIES = ("rows", "cols", "boxes")  # one set view per key family; the solution keeps all three in one set

wt = Walkthrough(
    {"en": "Valid Sudoku", "ko": "유효한 스도쿠"},
    {"en": "One pass, one set: each digit leaves three keys (its row, its column, its 3×3 box); "
           "a digit whose key is already in the set is a repeat.",
     "ko": "한 번 훑고 집합 하나로 확인합니다: 숫자마다 행, 열, 3×3 박스 키 세 개를 남기고, "
           "이미 집합에 있는 키를 만든 숫자가 중복입니다."},
    views=[
        {"id": "board", "type": "grid", "title": {"en": "board", "ko": "보드"},
         "values": {".": {"label": {"en": "empty", "ko": "빈 칸"}, "tone": "empty", "glyph": ""}}},
        {"id": "rows", "type": "set", "title": {"en": "row keys (row:digit)", "ko": "행 키 (행:숫자)"},
         "empty": {"en": "empty", "ko": "비어 있음"}},
        {"id": "cols", "type": "set", "title": {"en": "column keys (col:digit)", "ko": "열 키 (열:숫자)"},
         "empty": {"en": "empty", "ko": "비어 있음"}},
        {"id": "boxes", "type": "set", "title": {"en": "box keys (row÷3,col÷3:digit)", "ko": "박스 키 (행÷3,열÷3:숫자)"},
         "empty": {"en": "empty", "ko": "비어 있음"}},
    ],
)


def member(key):
    """A key as its set view writes it: ("row", 1, "5") is 1:5 in the row set, ("box", 0, 1, "5") is 0,1:5."""
    return ",".join(map(str, key[1:-1])) + ":" + key[-1]


def family(key):
    return {"row": "rows", "col": "cols", "box": "boxes"}[key[0]]


def solve(board, run):
    """Solution.isValidSudoku with a frame per filled cell. Returns nothing; the last frame has the answer."""
    seen = set()
    order = {f: [] for f in FAMILIES}  # each family's members in the order they went in
    where = {}  # key -> the cell that put it in the set, so a repeat can point at both cells

    def frame(caption, lit=(), good=(), bad=(), path=(), probes=(),  # probes: (key, hit) pairs
               good_keys=(), bad_keys=(), all_path=False,
              moves=None, **answer):
        sets = {}
        for f in FAMILIES:
            members = [member(k) for k in order[f]]
            sets[f] = {"members": members,
                       "probes": [probe(member(k), hit=hit) for k, hit in probes if family(k) == f],
                       "marks": {"good": [member(k) for k in good_keys if family(k) == f],
                                 "bad": [member(k) for k in bad_keys if family(k) == f],
                                 "path": members if all_path else []}}
        run.frame(caption,
                  board={"cells": board,
                         "marks": {"lit": [list(p) for p in lit], "good": [list(p) for p in good],
                                   "bad": [list(p) for p in bad], "path": [list(p) for p in path]}},
                  moves=moves, **sets, **answer)

    filled = sum(1 for row in board for d in row if d != ".")
    frame({"en": f"The board has {filled} filled cells. Read it row by row; an empty cell is skipped, "
                 "a digit's three keys are looked up in the set of keys seen so far.",
           "ko": f"채워진 칸은 {filled}개입니다. 보드를 행 순서로 읽으며 빈 칸은 건너뛰고, "
                 "숫자의 키 세 개를 지금까지 본 키의 집합에서 찾아봅니다."})
    for r in range(9):
        for c in range(9):
            digit = board[r][c]
            if digit == ".":
                continue
            keys = [("row", r, digit), ("col", c, digit), ("box", r // 3, c // 3, digit)]
            hits = [key for key in keys if key in seen][:1]  # any() stops at the first key found
            if hits:
                probed = keys[:keys.index(hits[0]) + 1]
                first = where[hits[0]]
                names_en = {"row": f"row {r}", "col": f"column {c}", "box": f"box ({r // 3},{c // 3})"}
                names_ko = {"row": f"{r}행", "col": f"{c}열", "box": f"({r // 3},{c // 3}) 박스"}
                kind = hits[0][0]
                frame({"en": f"Cell {r},{c} holds {digit}, and key {member(hits[0])} is already in the set: "
                             f"{names_en[kind]} has a {digit} at cell {first[0]},{first[1]}. A repeat, so the answer is false.",
                       "ko": f"{r},{c} 칸의 숫자 {digit}: 키 {member(hits[0])} → 이미 집합에 있습니다. {names_ko[kind]}의 "
                             f"{first[0]},{first[1]} 칸에 같은 숫자가 있으니 중복이고, 답은 false입니다."},
                      bad=[(r, c), first], probes=[(k, k in seen) for k in probed], bad_keys=hits, answer="false",
                      moves=[move(at("board", [r, c]), at(family(k), member(k)), value=member(k), mark="bad") for k in hits])
                return
            seen.update(keys)
            for key in keys:
                order[family(key)].append(key)
                where[key] = (r, c)
            frame({"en": f"Cell {r},{c} holds {digit}: keys {member(keys[0])}, {member(keys[1])} and "
                         f"{member(keys[2])} are not in the set yet, so all three go in.",
                   "ko": f"{r},{c} 칸의 숫자 {digit}: 키 세 개({member(keys[0])}, {member(keys[1])}, {member(keys[2])})가 "
                         "아직 집합에 없으므로 모두 넣습니다."},
                  good=[(r, c)], good_keys=keys, probes=[(k, False) for k in keys],  # each missed, then went in
                  moves=[move(at("board", [r, c]), at(family(k), member(k)), value=member(k)) for k in keys])
    done = [(r, c) for r in range(9) for c in range(9) if board[r][c] != "."]
    frame({"en": f"Every one of the {len(done)} digits added three new keys and none repeated, "
                 "so no row, column or box holds a digit twice. Answer true.",
           "ko": f"숫자 {len(done)}개가 모두 새 키 세 개씩을 더했고 겹친 키가 없으므로, "
                 "어떤 행, 열, 박스에도 같은 숫자가 두 번 나오지 않습니다. 답은 true입니다."},
          path=done, all_path=True, answer="true")


for number, sample in enumerate(sample_cases(SLUG), start=1):
    board = json.loads(sample["input"])
    run = sample_run(wt, number, sample, input=f"board = {sample['input']}")
    solve(board, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
