#!/usr/bin/env python3.12
"""desk-notes-overlap's Walkthrough: the reference solution (scripts/replay-solutions/desk-notes-overlap.py), the
longest-common-subsequence table of left prefixes against right prefixes, one frame per cell in row order, on each
sample Test Case.

The solution keeps only the previous row (`previous`, `current`); the Walkthrough draws the whole table those rows
roll through, as min-cheat-code-edits does: a grid whose first row holds right's letters and whose first column
left's (∅ for the empty prefix), so the two letters a cell compares are lit beside it. Each cell's value moves in from
the neighbour it was taken from (the diagonal plus one on a match, else the larger of above and left), and the last
frame walks back along those choices to one longest common subsequence.

    CODEBITE_DB=<database> scripts/walkthroughs/desk-notes-overlap.py

writes common/src/main/resources/walkthroughs/desk-notes-overlap.json.
"""
import os
import string
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import josa, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move  # noqa: E402

SLUG = "desk-notes-overlap"
EMPTY = "∅"   # the empty prefix's header
CORNER = ""   # the corner, above left's letters and left of right's letters
UNSET = " "   # a cell not filled yet

LETTER = {"tone": "a"}
wt = Walkthrough(
    {"en": "Desk Notes Overlap", "ko": "겹치는 필기 길이"},
    {"en": "Fill a table of the longest common subsequence of each left prefix and each right prefix. When the two "
           "last letters match, it is the diagonal + 1; otherwise one of them is left out, so take the larger of the "
           "cell above and the cell to the left.",
     "ko": "left의 각 앞부분과 right의 각 앞부분의 최장 공통 부분 수열 길이를 표로 채웁니다. 두 마지막 글자가 같으면 "
           "대각선 값 + 1, 다르면 둘 중 하나를 빼야 하므로 위 칸과 왼쪽 칸 중 큰 값을 씁니다."},
    views=[
        {"id": "table", "type": "grid",
         "title": {"en": "common length: left prefix (rows) × right prefix (columns)",
                   "ko": "공통 길이: left 앞부분(행) × right 앞부분(열)"},
         "values": {**{ch: LETTER for ch in string.ascii_lowercase}, EMPTY: LETTER,
                    CORNER: {"glyph": "", "tone": "plain"}, UNSET: {"glyph": "", "tone": "empty"}}},
    ],
)


def solve(left, right, run):
    """Solution.longestCommonSubsequence with a frame per cell, the whole table drawn. Returns the answer as the Driver
    prints it. Table cell (i, j), the answer for left[:i] and right[:j], is grid cell (i + 1, j + 1)."""
    n, m = len(left), len(right)
    grid = [[CORNER, EMPTY] + list(right), [EMPTY] + [0] * (m + 1)]
    grid += [[a, 0] + [UNSET] * m for a in left]
    came = {}  # (i, j) -> the cell its value was taken from

    def cell(i, j):
        return [i + 1, j + 1]

    def frame(caption, marks=None, moves=None, **answer):
        run.frame(caption, table={"cells": grid, "marks": marks or {}}, moves=moves, **answer)

    frame({"en": f"Compare \"{left}\" with \"{right}\". An empty prefix shares nothing with anything, so the first row "
                 "and column are 0.",
           "ko": f"\"{left}\" 문자열과 \"{right}\" 문자열을 비교합니다. 빈 앞부분은 어떤 문자열과도 공통 글자가 없으므로 첫 행과 첫 "
                 "열은 0입니다."},
          marks={"good": [cell(0, j) for j in range(m + 1)] + [cell(i, 0) for i in range(1, n + 1)]})
    previous = [0] * (m + 1)
    for i, a in enumerate(left, 1):
        current = [0]
        for j, b in enumerate(right, 1):
            letters = [[i + 1, 0], [0, j + 1]]
            if a == b:
                value = previous[j - 1] + 1
                came[(i, j)] = (i - 1, j - 1)
                current.append(value)
                grid[i + 1][j + 1] = value
                frame({"en": f"'{a}' = '{b}': both prefixes can end on this shared letter, so take the diagonal + 1: "
                             f"{previous[j - 1]} + 1 = {value}.",
                       "ko": f"'{a}' = '{b}': 두 앞부분 모두 이 공통 글자로 끝낼 수 있으므로 대각선 값에 1을 더합니다: "
                             f"{previous[j - 1]} + 1 = {value}."},
                      marks={"lit": letters + [cell(i - 1, j - 1)], "good": [cell(i, j)]},
                      moves=[move(at("table", cell(i - 1, j - 1)), at("table", cell(i, j)),
                                  value=f"{previous[j - 1]}+1")])
            else:
                up, lt = previous[j], current[j - 1]
                value = max(up, lt)
                src = (i - 1, j) if up >= lt else (i, j - 1)
                came[(i, j)] = src
                current.append(value)
                grid[i + 1][j + 1] = value
                frame({"en": f"'{a}' ≠ '{b}': drop one of them. Above (without '{a}') is {up}, left (without '{b}') "
                             f"is {lt}; keep the larger, {value}.",
                       "ko": f"'{a}' ≠ '{b}': 둘 중 하나를 뺍니다. 위('{a}' 없이)는 {up}, 왼쪽('{b}' 없이)은 "
                             f"{lt}이므로 큰 값 {josa(value, '을를')} 씁니다."},
                      marks={"lit": letters + [cell(i - 1, j), cell(i, j - 1)], "good": [cell(i, j)]},
                      moves=[move(at("table", cell(*src)), at("table", cell(i, j)))])
        previous = current
    answer = previous[-1]
    # walk back along where each value came from: the diagonals taken are the shared letters
    path, shared, (i, j) = [], [], (n, m)
    while i > 0 and j > 0:
        path.append(cell(i, j))
        pi, pj = came[(i, j)]
        if (pi, pj) == (i - 1, j - 1):
            shared.append((i, j))
        i, j = pi, pj
    path.append(cell(i, j))
    shared.reverse()
    word = "".join(left[i - 1] for i, _ in shared)
    headers = [[i + 1, 0] for i, _ in shared] + [[0, j + 1] for _, j in shared]
    if answer:
        caption = {"en": f"The corner holds {answer}, the answer. Walking back along where each value came from, the "
                         f"diagonal steps spell one longest common subsequence: \"{word}\".",
                   "ko": f"오른쪽 아래 칸의 {josa(answer, '이가')} 답입니다. 각 값이 온 칸을 거슬러 가면 대각선으로 "
                         f"온 칸들이 최장 공통 부분 수열 하나를 이룹니다: \"{word}\"."}
    else:
        caption = {"en": "No letter of left appears in right, so every cell stayed 0. Answer: 0.",
                   "ko": "left의 어떤 글자도 right에 없어 모든 칸이 0으로 남았습니다. 답은 0입니다."}
    frame(caption, marks={"path": path + headers}, answer=str(answer))


for number, sample in enumerate(sample_cases(SLUG), start=1):
    left, right = sample["input"].split("\n")
    run = sample_run(wt, number, sample, input=f"left = \"{left}\", right = \"{right}\"")
    solve(left, right, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
