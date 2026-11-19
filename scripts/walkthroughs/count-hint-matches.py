#!/usr/bin/env python3.12
"""count-hint-matches' Walkthrough: the reference solution (scripts/replay-solutions/count-hint-matches.py), the
table of how many ways each notes prefix spells each target prefix, one frame per cell in row order, on each sample
Test Case.

The solution keeps one row (`ways`), updated right to left as each note letter is read; the Walkthrough draws the
whole table those updates roll through, as min-cheat-code-edits does: a grid whose first column holds the notes'
letters and whose first row the target's (∅ for the empty prefix). Each cell moves in from the cell above (the ways
that skip this note letter) and, when the letters match, from the diagonal too (the ways that use it).

    CODEBITE_DB=<database> scripts/walkthroughs/count-hint-matches.py

writes common/src/main/resources/walkthroughs/count-hint-matches.json.
"""
import os
import string
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import josa, plural, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move  # noqa: E402

SLUG = "count-hint-matches"
EMPTY, CORNER, UNSET = "∅", "", " "
LETTER = {"tone": "a"}

wt = Walkthrough(
    {"en": "Count Hint Matches", "ko": "노트 매칭 개수 세기"},
    {"en": "Fill a table of how many ways the first i note letters spell the first j hint letters. A cell keeps the ways "
           "from above, which skip this note letter, and when the letters match adds the diagonal's, which use it.",
     "ko": "notes의 앞 i글자로 target의 앞 j글자를 만드는 방법 수를 표로 채웁니다. 각 칸은 이 notes 글자를 건너뛰는 "
           "위 칸의 방법 수를 이어받고, 두 글자가 같으면 이 글자를 쓰는 대각선 칸의 방법 수를 더합니다."},
    views=[
        {"id": "table", "type": "grid",
         "title": {"en": "ways: notes prefix (rows) spelling target prefix (columns)",
                   "ko": "방법 수: notes 앞부분(행)으로 target 앞부분(열) 만들기"},
         "values": {**{ch: LETTER for ch in string.ascii_lowercase}, EMPTY: LETTER,
                    CORNER: {"glyph": "", "tone": "plain"}, UNSET: {"glyph": "", "tone": "empty"}}},
    ],
)


def solve(notes, target, run):
    """Solution.countHintMatches with a frame per cell, the whole table drawn. Returns the answer as the Driver prints
    it. Table cell (i, j) is grid cell (i + 1, j + 1)."""
    n, m = len(notes), len(target)
    grid = [[CORNER, EMPTY] + list(target), [EMPTY, 1] + [0] * m]
    grid += [[ch, 1] + [UNSET] * m for ch in notes]
    ways = [[1] + [0] * m]

    def cell(i, j):
        return [i + 1, j + 1]

    def frame(caption, marks=None, moves=None, **answer):
        run.frame(caption, table={"cells": grid, "marks": marks or {}}, moves=moves, **answer)

    frame({"en": f"Count \"{target}\" in \"{notes}\". The empty hint is spelled one way by any prefix (pick nothing), "
                 "and an empty prefix spells no longer hint: the first column is 1, the first row 0.",
           "ko": f"notes \"{notes}\" 안에서 target \"{target}\" 문자열을 셉니다. 빈 target은 어떤 앞부분으로도 한 가지"
                 "(아무것도 고르지 않기)로 만들고, 빈 앞부분으로는 더 긴 target을 못 만듭니다: 첫 열은 1, 첫 행은 0입니다."},
          marks={"good": [cell(i, 0) for i in range(n + 1)] + [cell(0, j) for j in range(1, m + 1)]})
    for i, letter in enumerate(notes, 1):
        row = [1]
        for j, want in enumerate(target, 1):
            above = ways[i - 1][j]
            moves = [move(at("table", cell(i - 1, j)), at("table", cell(i, j)), value=str(above))]
            lit = [[i + 1, 0], [0, j + 1], cell(i - 1, j)]
            if letter == want:
                diag = ways[i - 1][j - 1]
                value = above + diag
                moves.append(move(at("table", cell(i - 1, j - 1)), at("table", cell(i, j)), value=f"+{diag}"))
                lit.append(cell(i - 1, j - 1))
                caption = {"en": f"'{letter}' = '{want}': {above} {plural(above, 'way skips', 'ways skip')} this letter "
                                 f"(above) and {diag} end the hint's '{want}' on it (diagonal): {above} + {diag} = {value}.",
                           "ko": f"'{letter}' = '{want}': 이 글자를 건너뛰는 방법(위) {above}가지와 이 글자로 target의 "
                                 f"'{want}' 글자를 맞추는 방법(대각선) {diag}가지를 더해 {above} + {diag} = {value}입니다."}
            else:
                value = above
                caption = {"en": f"'{letter}' ≠ '{want}': this letter can't be the hint's '{want}', so only the {above} "
                                 f"{plural(above, 'way', 'ways')} skipping it (above) count: {value}.",
                           "ko": f"'{letter}' ≠ '{want}': 이 글자로는 target의 '{want}' 글자를 맞출 수 없으므로 "
                                 f"건너뛰는 방법(위) {above}가지만 셉니다: {value}."}
            row.append(value)
            grid[i + 1][j + 1] = value
            frame(caption, marks={"lit": lit, "good": [cell(i, j)]}, moves=moves)
        ways.append(row)
    answer = ways[n][m]
    frame({"en": f"The corner holds {answer}: every way to pick \"{target}\" from \"{notes}\" in order. "
                 f"Answer: {answer}.",
           "ko": f"오른쪽 아래 칸의 {josa(answer, '이가')} notes에서 target을 순서대로 고르는 모든 방법의 수입니다. "
                 f"답은 {answer}입니다."},
          marks={"path": [cell(n, m)]}, answer=str(answer))


for number, sample in enumerate(sample_cases(SLUG), start=1):
    notes, target = sample["input"].split("\n")
    run = sample_run(wt, number, sample, input=f"notes = \"{notes}\", target = \"{target}\"")
    solve(notes, target, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
