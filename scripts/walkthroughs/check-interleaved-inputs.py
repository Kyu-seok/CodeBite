#!/usr/bin/env python3.12
"""check-interleaved-inputs' Walkthrough: the reference solution (scripts/replay-solutions/check-interleaved-inputs.py),
the table of whether controllerA[:i] and controllerB[:j] interleave into merged[:i + j], one frame per cell in row
order, on each sample Test Case.

The solution keeps one row (`ok`); the Walkthrough draws the whole table it rolls through, as min-cheat-code-edits
draws its: a grid whose first column holds A's letters and whose first row B's (∅ for the empty prefix), each cell ✓
or ✗. merged is an array beside it, `k` on the letter the cell must place, merged[i + j - 1]. A ✓ moves in from the
cell it extends (above when A's letter is placed, left when B's), a ✗ from the cell above (left on the first row), and
the last frame walks back along the ✓ cells to the order the letters were taken in.

    CODEBITE_DB=<database> scripts/walkthroughs/check-interleaved-inputs.py

writes common/src/main/resources/walkthroughs/check-interleaved-inputs.json.
"""
import os
import string
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move  # noqa: E402

SLUG = "check-interleaved-inputs"
EMPTY, CORNER, UNSET, YES, NO = "∅", "", " ", "T", "F"
LETTER = {"tone": "a"}

wt = Walkthrough(
    {"en": "Check Interleaved Inputs", "ko": "두 입력 교차 병합 검사"},
    {"en": "Fill a table of whether A's first i letters and B's first j letters weave into merged's first i + j. A cell "
           "is ✓ when merged's letter there is A's next letter and the cell above is ✓, or B's next letter and the "
           "cell to the left is ✓.",
     "ko": "A의 앞 i글자와 B의 앞 j글자로 merged의 앞 i + j글자를 만들 수 있는지 표로 채웁니다. 그 자리의 merged 글자가 "
           "A의 다음 글자이고 위 칸이 ✓이거나, B의 다음 글자이고 왼쪽 칸이 ✓이면 ✓입니다."},
    views=[
        {"id": "table", "type": "grid",
         "title": {"en": "A prefix (rows) × B prefix (columns) weave into merged?",
                   "ko": "A 앞부분(행) × B 앞부분(열)로 merged를 만들 수 있는가"},
         "values": {**{ch: LETTER for ch in string.ascii_lowercase}, EMPTY: LETTER,
                    YES: {"glyph": "✓", "tone": "c"}, NO: {"glyph": "✗", "tone": "plain"},
                    CORNER: {"glyph": "", "tone": "plain"}, UNSET: {"glyph": "", "tone": "empty"}}},
        {"id": "merged", "type": "array", "title": {"en": "merged", "ko": "merged (병합 기록)"},
         "empty": {"en": "empty", "ko": "비어 있음"}},
    ],
)


def mark(ok):
    return YES if ok else NO


def solve(a_text, b_text, merged, run):
    """Solution.isInterleaving with a frame per cell, the whole table drawn. Returns the answer as the Driver prints it.
    Table cell (i, j) is grid cell (i + 1, j + 1)."""
    n, m = len(a_text), len(b_text)
    grid = [[CORNER, EMPTY] + list(b_text)] + [[EMPTY] + [UNSET] * (m + 1)]
    grid += [[ch] + [UNSET] * (m + 1) for ch in a_text]
    letters = list(merged)

    def frame(caption, marks=None, k=None, merged_marks=None, moves=None, **answer):
        run.frame(caption, table={"cells": grid, "marks": marks or {}},
                  merged={"values": letters, "pointers": {"k": k}, "marks": merged_marks or {}},
                  moves=moves, **answer)

    def cell(i, j):
        return [i + 1, j + 1]

    if n + m != len(merged):
        frame({"en": f"A has {n} letters and B {m}, but merged has {len(merged)}: it can't use each exactly once. "
                     "Answer: false.",
               "ko": f"A는 {n}글자, B는 {m}글자인데 merged는 {len(merged)}글자이므로 모든 글자를 한 번씩 쓸 수 없습니다. "
                     "답은 false입니다."}, answer="false")
        return
    ok = {(0, 0): True}
    grid[1][1] = YES
    frame({"en": f"A = \"{a_text}\", B = \"{b_text}\", merged = \"{merged}\": {n} + {m} = {len(merged)} letters, so "
                 "the lengths fit. Two empty prefixes make the empty merged prefix: ✓.",
           "ko": f"A = \"{a_text}\", B = \"{b_text}\", merged = \"{merged}\": {n} + {m} = {len(merged)}글자로 길이가 "
                 "맞습니다. 빈 앞부분 둘은 빈 merged 앞부분을 만듭니다: ✓."},
          marks={"good": [cell(0, 0)]})
    for i in range(n + 1):
        for j in range(m + 1):
            if (i, j) == (0, 0):
                continue
            k = i + j - 1
            letter = merged[k]
            from_a = i > 0 and ok[(i - 1, j)] and a_text[i - 1] == letter
            from_b = j > 0 and ok[(i, j - 1)] and b_text[j - 1] == letter
            ok[(i, j)] = from_a or from_b
            grid[i + 1][j + 1] = mark(ok[(i, j)])
            reads, parts_en, parts_ko = [], [], []
            if i > 0:
                a = a_text[i - 1]
                reads += [cell(i - 1, j), [i + 1, 0]]
                parts_en.append(f"above is {'✓' if ok[(i - 1, j)] else '✗'} and A's next letter is '{a}'")
                parts_ko.append(f"위 칸은 {'✓' if ok[(i - 1, j)] else '✗'}, A의 다음 글자는 '{a}'")
            if j > 0:
                b = b_text[j - 1]
                reads += [cell(i, j - 1), [0, j + 1]]
                parts_en.append(f"left is {'✓' if ok[(i, j - 1)] else '✗'} and B's next letter is '{b}'")
                parts_ko.append(f"왼쪽 칸은 {'✓' if ok[(i, j - 1)] else '✗'}, B의 다음 글자는 '{b}'")
            if from_a:
                src, verdict_en, verdict_ko = cell(i - 1, j), f"A's '{letter}' goes here: ✓", f"A의 '{letter}' 글자를 놓을 수 있어 ✓"
            elif from_b:
                src, verdict_en, verdict_ko = cell(i, j - 1), f"B's '{letter}' goes here: ✓", f"B의 '{letter}' 글자를 놓을 수 있어 ✓"
            else:
                src = cell(i - 1, j) if i > 0 else cell(i, j - 1)
                verdict_en, verdict_ko = "neither gives it: ✗", "어느 쪽으로도 만들 수 없어 ✗"
            frame({"en": f"merged[{k}] = '{letter}': {'; '.join(parts_en)}. So {verdict_en}.",
                   "ko": f"merged[{k}] = '{letter}': {', '.join(parts_ko)}입니다. 따라서 {verdict_ko}입니다."},
                  marks={"lit": reads, "good" if ok[(i, j)] else "bad": [cell(i, j)]}, k=k, merged_marks={"lit": [k]},
                  moves=[move(at("table", src), at("table", cell(i, j)), value="✓" if ok[(i, j)] else "✗",
                              mark=None if ok[(i, j)] else "bad")])
    if not ok[(n, m)]:
        frame({"en": f"The corner is ✗: no way of taking A's and B's letters in order spells \"{merged}\". Answer: false.",
               "ko": f"오른쪽 아래 칸이 ✗입니다. A와 B의 글자를 순서대로 어떻게 가져와도 \"{merged}\" 문자열이 되지 "
                     "않으므로 답은 false입니다."},
              marks={"bad": [cell(n, m)]}, answer="false")
        return
    # walk back along the ✓ cells: each step up placed A's letter, each step left B's
    path, taken, (i, j) = [cell(n, m)], [], (n, m)
    while (i, j) != (0, 0):
        letter = merged[i + j - 1]
        if i > 0 and ok[(i - 1, j)] and a_text[i - 1] == letter:
            taken.append(("A", letter))
            i -= 1
        else:
            taken.append(("B", letter))
            j -= 1
        path.append(cell(i, j))
    taken.reverse()
    if taken:
        order = ", ".join(f"{ch} ({side})" for side, ch in taken)
        caption = {"en": f"The corner is ✓. Walking back along the ✓ cells gives the order the letters were taken: "
                         f"{order}. Answer: true.",
                   "ko": f"오른쪽 아래 칸이 ✓입니다. ✓ 칸을 거슬러 가면 글자를 가져온 순서가 나옵니다: {order}. "
                         "답은 true입니다."}
    else:
        caption = {"en": "All three strings are empty, and two empty inputs weave into an empty merge. Answer: true.",
                   "ko": "세 문자열이 모두 비어 있고, 빈 입력 둘은 빈 병합 기록을 만듭니다. 답은 true입니다."}
    frame(caption, marks={"path": path}, merged_marks={"path": list(range(len(merged)))}, answer="true")


for number, sample in enumerate(sample_cases(SLUG), start=1):
    a_text, b_text, merged = (sample["input"].split("\n") + ["", "", ""])[:3]
    run = sample_run(wt, number, sample,
                     input=f"controllerA = \"{a_text}\", controllerB = \"{b_text}\", merged = \"{merged}\"")
    solve(a_text, b_text, merged, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
