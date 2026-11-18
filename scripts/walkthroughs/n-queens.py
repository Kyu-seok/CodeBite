#!/usr/bin/env python3.12
"""n-queens's Walkthrough: the reference solution (scripts/replay-solutions/n-queens.py), backtracking one row per
call: place(row) tries each column no placed queen attacks (its column, diagonal and anti-diagonal sets), places a
queen there and calls place(row + 1); when the call returns it lifts the queen and tries further right. The call tree
is too big to draw whole, so the call stack stands beside the board: one card per open call, the squares the placed
queens attack shaded, each queen moving from its call onto the board.

One frame per queen placed and one per queen lifted, not per square checked: the attacked squares are shaded, so
the columns a call skips show on the board without a frame each. n = 5 still takes over a hundred frames.

    CODEBITE_DB=<database> scripts/walkthroughs/n-queens.py

writes common/src/main/resources/walkthroughs/n-queens.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import driver_list, josa, plural, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, call, move  # noqa: E402

SLUG = "n-queens"

wt = Walkthrough(
    {"en": "N-Queens", "ko": "N-퀸"},
    {"en": "One queen per row: each call places its row's queen on a square no earlier queen attacks and calls the next "
           "row; a row with no such square sends the search back up the stack to move the queen above it.",
     "ko": "한 행에 퀸 하나씩 둡니다. 호출마다 앞선 퀸이 공격하지 않는 칸에 퀸을 두고 다음 행을 호출하며, 그런 칸이 없는 "
           "행에서는 스택을 거슬러 올라가 윗행의 퀸을 옮깁니다."},
    views=[
        {"id": "board", "type": "grid", "values": {"Q": {"tone": "a"}, "": {"glyph": ""}}},
        {"id": "stack", "type": "callstack", "title": {"en": "call stack", "ko": "호출 스택"}},
        {"id": "result", "type": "output",
         "title": {"en": "arrangements (queen's column per row)", "ko": "배치 (행마다 퀸의 열)"},
         "empty": {"en": "none yet", "ko": "아직 없음"}},
    ],
)


def solve(n, run):
    """Solution.solveNQueens with a frame per queen placed and lifted. Returns the answer as the Driver prints it."""
    board = [["" for _ in range(n)] for _ in range(n)]
    boards = []
    queens = []           # queens[row] = column
    columns, diagonals, anti_diagonals = set(), set(), set()
    stack = []

    def attacked():
        return [[r, c] for r in range(n) for c in range(n)
                if board[r][c] == "" and (c in columns or r - c in diagonals or r + c in anti_diagonals)]

    def frame(caption, marks=None, call_marks=None, moves=None, done=False, **answer):
        run.frame(caption,
                  board={"cells": [row[:] for row in board], "marks": marks or {}, "shade": [] if done else attacked()},
                  stack={"calls": [dict(c) for c in stack], "marks": call_marks or {}},
                  result={"values": [driver_list(cols) for cols in found],
                          "marks": {"path": list(range(len(found)))} if done else {}},
                  moves=moves, **answer)

    found = []
    stack.append(call("place", row=0))
    frame({"en": f"An empty {n}×{n} board: the first call, place(row=0), will try each column of row 0.",
           "ko": f"빈 {n}×{n} 판입니다. 첫 호출 place(row=0)에서 0행의 열을 하나씩 시도합니다."},
          call_marks={"lit": [0]}, moves=[move(dst=at("stack", 0))])

    def place(row):
        if row == n:
            boards.append(["." * c + "Q" + "." * (n - c - 1) for c in queens])
            found.append(list(queens))
            frame({"en": f"place(row={row}) is past the last row: every row has a queen, so columns "
                         f"{driver_list(queens)} are an arrangement.",
                   "ko": f"place(row={row})에서는 마지막 행을 지났습니다. 모든 행에 퀸이 있으니 열 {driver_list(queens)} 배치가 "
                         f"답에 들어갑니다."},
                  marks={"good": [[i, c] for i, c in enumerate(queens)]}, call_marks={"good": [row]},
                  moves=[move(at("stack", row), at("result", len(found) - 1), value=driver_list(queens))])
            return
        for column in range(n):
            if column in columns or row - column in diagonals or row + column in anti_diagonals:
                continue
            queens.append(column)
            columns.add(column)
            diagonals.add(row - column)
            anti_diagonals.add(row + column)
            board[row][column] = "Q"
            stack[row] = call("place", row=row, note={"en": f"queen at col {column}", "ko": f"{column}열에 퀸"})
            stack.append(call("place", row=row + 1))
            frame({"en": f"Row {row}, column {column} is not attacked: place a queen there and call "
                         f"place(row={row + 1}).",
                   "ko": f"{row}행 {column}열은 공격받지 않으므로 퀸을 두고 다음 행의 호출 place(row={row + 1})에 넘깁니다."},
                  marks={"good": [[row, column]]}, call_marks={"lit": [row + 1]},
                  moves=[move(at("stack", row), at("board", [row, column]), value="Q"),
                         move(at("board", [row, column]), at("stack", row + 1), value=f"row={row + 1}")])
            before = len(found)
            place(row + 1)
            queens.pop()
            columns.remove(column)
            diagonals.remove(row - column)
            anti_diagonals.remove(row + column)
            board[row][column] = ""
            if row + 1 == n:
                why = {"en": f"place(row={row + 1}) returns with its arrangement",
                       "ko": f"place(row={row + 1}) 호출이 배치를 남기고 돌아갑니다"}
                mark = "dim"
            else:
                more = len(found) - before
                why = ({"en": f"Every square of row {row + 1} is attacked or tried, so place(row={row + 1}) returns"
                              + (f" with {more} {plural(more, 'arrangement', 'arrangements')} found below it" if more else ""),
                        "ko": f"{row + 1}행은 모든 칸이 공격받거나 시도되었으므로 place(row={row + 1}) 호출이 "
                              + (f"아래에서 찾은 배치 {more}개를 남기고 " if more else "") + "돌아갑니다"})
                mark = "dim" if more else "bad"
            then = ({"en": "to try further right", "ko": "더 오른쪽을 시도합니다"} if column < n - 1 else
                    {"en": "with no column left to its right", "ko": "오른쪽에 남은 열이 없습니다"})
            frame({"en": why["en"] + f"; row {row} lifts its queen from column {column} {then['en']}.",
                   "ko": why["ko"] + f". {row}행은 {column}열의 퀸을 들어 올리고, " + then["ko"] + "."},
                  marks={"bad": [[row, column]]}, call_marks={mark: [row + 1]},
                  moves=[move(at("board", [row, column]), value="Q")])
            stack.pop()
            stack[row] = call("place", row=row)

    place(0)
    stack.pop()
    boards.sort()
    printed = json.dumps(boards, separators=(",", ":"))
    k = len(found)
    if k:
        frame({"en": f"Every call has returned: {k} {plural(k, 'way', 'ways')} to place {n} queens, each chip listing "
                     f"the queens' columns row by row.",
               "ko": f"모든 호출이 끝났습니다. 퀸 {n}개를 두는 방법은 {k}가지이고, 칩마다 행 순서대로 퀸의 열이 적혀 "
                     f"있습니다."},
              done=True, answer=printed)
    else:
        frame({"en": f"Every call has returned without reaching past the last row: no way to place {n} queens, so the "
                     f"answer is [].",
               "ko": f"모든 호출이 마지막 행을 지나지 못하고 끝났습니다. 퀸 {n}개를 둘 방법이 없으므로 답은 빈 목록 "
                     f"[]입니다."},
              done=True, answer=printed)
    return printed


for number, sample in enumerate(sample_cases(SLUG), start=1):
    n = int(sample["input"])
    run = sample_run(wt, number, sample, input=f"n = {n}")
    solve(n, run)
wt.write(walkthrough_path(SLUG))
