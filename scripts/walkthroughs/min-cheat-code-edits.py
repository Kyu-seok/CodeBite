#!/usr/bin/env python3.12
"""min-cheat-code-edits' Walkthrough: the reference solution (scripts/replay-solutions/min-cheat-code-edits.py), the
edit-distance table of source prefixes against target prefixes, one frame per cell in row order, on each sample
Test Case.

The solution keeps only the previous row (`previous`, `current`); the Walkthrough draws the whole table those rows
roll through, since each cell reads the cell diagonally up-left, the one above and the one to the left. It is a grid
whose first row holds the target's letters and whose first column the source's (∅ for the empty prefix), so the
two letters a cell compares are lit beside it; a grid scales down at 390px where a table this wide would be clipped.
Each cell's value moves in from the neighbour it was taken from, and the tracer keeps that choice so the last
frame marks the cells the cheapest edit script runs through.

    CODEBITE_DB=<database> scripts/walkthroughs/min-cheat-code-edits.py

writes common/src/main/resources/walkthroughs/min-cheat-code-edits.json.
"""
import os
import string
import sys
from functools import partial

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import plural, sample_cases, sample_run, table_cell, table_frame, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move  # noqa: E402

SLUG = "min-cheat-code-edits"
EMPTY = "∅"   # the empty prefix's header
CORNER = ""   # the corner, above the source letters and left of the target letters
UNSET = " "   # a cell not filled yet

LETTER = {"tone": "a"}
wt = Walkthrough(
    {"en": "Min Cheat Code Edits", "ko": "치트 코드 최소 편집"},
    {"en": "Fill a table of the fewest keystrokes turning each source prefix into each target prefix. Matching "
           "letters cost nothing more than the diagonal; otherwise it is 1 + the cheapest of replace (diagonal), "
           "delete (above) and insert (left).",
     "ko": "source의 각 앞부분을 target의 각 앞부분으로 바꾸는 최소 키 입력 수를 표로 채웁니다. 두 글자가 같으면 "
           "대각선 값 그대로, 다르면 바꾸기(대각선), 지우기(위), 끼워 넣기(왼쪽) 중 가장 작은 값에 1을 더합니다."},
    views=[
        {"id": "table", "type": "grid",
         "title": {"en": "keystrokes: source prefix (rows) → target prefix (columns)",
                   "ko": "키 입력 수: source 앞부분(행) → target 앞부분(열)"},
         "values": {**{ch: LETTER for ch in string.ascii_lowercase}, EMPTY: LETTER,
                    CORNER: {"glyph": "", "tone": "plain"}, UNSET: {"glyph": "", "tone": "empty"}}},
    ],
)

EDITS = {"replace": {"en": "replace", "ko": "바꾸기"}, "delete": {"en": "delete", "ko": "지우기"},
         "insert": {"en": "insert", "ko": "끼워 넣기"}}


def solve(source, target, run):
    """Solution.minCheatCodeEdits with a frame per cell, the whole table drawn. Returns the answer as the Driver prints
    it. Table cell (i, j), the cost of source[:i] → target[:j], is grid cell (i + 1, j + 1)."""
    n, m = len(source), len(target)
    grid = [[CORNER, EMPTY] + list(target), [EMPTY] + [UNSET] * (m + 1)]
    grid += [[a] + [UNSET] * (m + 1) for a in source]
    came = {}  # (i, j) -> (i', j') the cell its value was taken from

    frame = partial(table_frame, run, grid)

    previous = list(range(m + 1))
    for j, v in enumerate(previous):
        grid[1][j + 2 - 1] = v
    for i in range(1, n + 1):
        grid[i + 1][1] = i
    frame({"en": f"Turn \"{source}\" into \"{target}\". The top row is building each target prefix from nothing "
                 "(that many inserts); the left column is erasing each source prefix (that many deletes).",
           "ko": f"\"{source}\" → \"{target}\": 맨 윗행은 빈 코드에서 target 앞부분을 만드는 수(그만큼 "
                 "끼워 넣기), 맨 왼쪽 열은 source 앞부분을 모두 지우는 수(그만큼 지우기)입니다."},
          marks={"good": [table_cell(0, j) for j in range(m + 1)] + [table_cell(i, 0) for i in range(1, n + 1)]})
    for i, a in enumerate(source, 1):
        current = [i]
        for j, b in enumerate(target, 1):
            diag, up = previous[j - 1], previous[j]
            letters = [[i + 1, 0], [0, j + 1]]
            if a == b:
                current.append(diag)
                came[(i, j)] = (i - 1, j - 1)
                grid[i + 1][j + 1] = diag
                frame({"en": f"'{a}' = '{b}': the letters match, so this costs no keystroke beyond the diagonal: "
                             f"{diag}.",
                       "ko": f"'{a}' = '{b}': 두 글자가 같으므로 대각선 값에서 키 입력이 더 들지 않습니다: {diag}."},
                      marks={"lit": letters + [table_cell(i - 1, j - 1)], "good": [table_cell(i, j)]},
                      moves=[move(at("table", table_cell(i - 1, j - 1)), at("table", table_cell(i, j)), value=str(diag))])
            else:
                left = current[j - 1]
                best = min(diag, up, left)
                current.append(1 + best)
                src, edit = next((s, e) for s, e, v in (((i - 1, j - 1), "replace", diag), ((i - 1, j), "delete", up),
                                                        ((i, j - 1), "insert", left)) if v == best)
                came[(i, j)] = src
                grid[i + 1][j + 1] = 1 + best
                frame({"en": f"'{a}' ≠ '{b}': replace ↖ {diag}, delete ↑ {up} or insert ← {left}; the cheapest is "
                             f"{EDITS[edit]['en']}, {best} + 1 = {best + 1}.",
                       "ko": f"'{a}' ≠ '{b}': 바꾸기 ↖ {diag}, 지우기 ↑ {up}, 끼워 넣기 ← {left} 중 가장 작은 "
                             f"{EDITS[edit]['ko']}에 1을 더해 {best} + 1 = {best + 1}입니다."},
                      marks={"lit": letters + [table_cell(i - 1, j - 1), table_cell(i - 1, j), table_cell(i, j - 1)],
                             "good": [table_cell(i, j)]},
                      moves=[move(at("table", table_cell(*src)), at("table", table_cell(i, j)), value=f"{best}+1")])
        previous = current
    answer = previous[-1]
    # walk back from the corner along the cells each value came from: the cheapest edit script
    path, steps, (i, j) = [], [], (n, m)
    while (i, j) != (0, 0):
        path.append(table_cell(i, j))
        if i == 0:
            steps.append(("insert", target[j - 1]))
            i, j = i, j - 1
        elif j == 0:
            steps.append(("delete", source[i - 1]))
            i, j = i - 1, j
        else:
            pi, pj = came[(i, j)]
            if (pi, pj) == (i - 1, j - 1) and source[i - 1] != target[j - 1]:
                steps.append(("replace", f"{source[i - 1]}→{target[j - 1]}"))
            elif (pi, pj) == (i - 1, j):
                steps.append(("delete", source[i - 1]))
            elif (pi, pj) == (i, j - 1):
                steps.append(("insert", target[j - 1]))
            i, j = pi, pj
    path.append(table_cell(0, 0))
    steps.reverse()
    script_en = ", ".join(f"{EDITS[e]['en']} '{x}'" for e, x in steps)
    script_ko = ", ".join(f"'{x}' {EDITS[e]['ko']}" for e, x in steps)
    frame({"en": f"The corner holds {answer} {plural(answer, 'keystroke', 'keystrokes')}. Walking back along where "
                 f"each value came from gives one cheapest script: {script_en}.",
           "ko": f"오른쪽 아래 칸의 값은 {answer}입니다. 각 값이 온 칸을 거슬러 가면 가장 싼 편집 하나가 나옵니다: "
                 f"{script_ko}."},
          marks={"path": path}, answer=str(answer))


for number, sample in enumerate(sample_cases(SLUG), start=1):
    source, target = sample["input"].split("\n")
    run = sample_run(wt, number, sample, input=f"source = \"{source}\", target = \"{target}\"")
    solve(source, target, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
