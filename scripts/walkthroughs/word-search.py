#!/usr/bin/env python3.12
"""word-search's Walkthrough: the reference solution (scripts/replay-solutions/word-search.py). It first checks the
board holds every letter of the word often enough (and would walk the word backwards from its rarer end), then tries
each cell as a start: search(r, c, i) matches word[i] on the cell, marks it "#" so the trace can't reuse it, and asks
its four neighbours for word[i + 1]; a cell whose neighbours all fail gives its letter back and returns false.

The recursion walks the board, so the board is the drawing (views.md, recursion): the cell the current call matched
lit, the open calls' cells shaded and tagged with the index of the letter they matched, and the word below with `i` on
the letter wanted. One frame per cell matched and one per call backing out, not per neighbour asked.

    CODEBITE_DB=<database> scripts/walkthroughs/word-search.py

writes common/src/main/resources/walkthroughs/word-search.json.
"""
import json
import os
import sys
from collections import Counter

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move  # noqa: E402

SLUG = "word-search"

wt = Walkthrough(
    {"en": "Word Search", "ko": "단어 찾기"},
    {"en": "Try every cell as the first letter and walk depth-first: a call matches one letter, marks its cell used, and "
           "asks each neighbour for the next letter; when all four fail it frees the cell and backs out.",
     "ko": "모든 칸을 첫 글자로 시도하며 깊이 우선으로 걷습니다. 호출 하나가 글자 하나를 맞추고 그 칸을 사용 중으로 표시한 뒤 이웃 "
           "칸에 다음 글자를 묻고, 네 이웃이 모두 실패하면 칸을 풀어 주고 되돌아갑니다."},
    views=[
        {"id": "board", "type": "grid"},
        {"id": "word", "type": "array", "title": {"en": "word", "ko": "word (단어)"}},
    ],
)


def cell(r, c):
    return f"({r},{c})"


def solve(board, word, run):
    """Solution.exist with a frame per cell matched and per call backing out. Returns the answer as the Driver prints
    it."""
    rows, cols = len(board), len(board[0])
    letters = [row[:] for row in board]  # drawn: a cell on the trace keeps its letter, shaded, not its "#"
    path = []                            # open calls: (r, c, i)

    def frame(caption, lit=None, bad=(), want=None, under=None, word_marks=None, moves=None, done=None, **answer):
        marks = {"bad": [list(x) for x in bad]}
        if lit is not None:
            marks["lit"] = [list(lit)]
        if done:
            marks = {"path": [[r, c] for r, c, _ in path]}
        matched = [i for _, _, i in path]
        wmarks = word_marks or ({"path": matched} if done else {"good": matched})
        run.frame(caption,
                  board={"cells": [row[:] for row in letters], "marks": marks,
                         "shade": [] if done else [[r, c] for r, c, _ in path],
                         "tags": [[r, c, f"i={i}"] for r, c, i in path]},
                  word={"values": list(word), "marks": wmarks,
                        "pointers": {"i": want} if want is not None and want < len(word) else {},
                        "under": under or []},
                  moves=moves, **answer)

    available = Counter(letter for row in board for letter in row)
    short = [k for k, ch in enumerate(word) if available[ch] < Counter(word)[ch]]
    under = [[k, f"×{available[ch]}"] for k, ch in enumerate(word)]
    if short:
        ch = word[short[0]]
        frame({"en": f"First count the board's letters (under each letter of the word): '{ch}' is needed "
                     f"{Counter(word)[ch]} times but the board has {available[ch]}, so the answer is false without a search.",
               "ko": f"먼저 보드의 글자 수를 셉니다(단어의 글자 아래). '{ch}' 글자는 {Counter(word)[ch]}번 필요하지만 보드에는 "
                     f"{available[ch]}개뿐이므로 탐색 없이 답은 false입니다."},
              under=under, word_marks={"bad": short}, done=False, answer="false")
        return "false"
    if available[word[0]] > available[word[-1]]:
        raise SystemExit(f"{SLUG}: a sample walks its word backwards; draw the reversal before using it")
    frame({"en": f"First count the board's letters (under each letter of \"{word}\"): every one is there often enough. "
                 f"'{word[0]}' is no more common than '{word[-1]}', so the search starts from the front.",
           "ko": f"먼저 보드의 글자 수를 셉니다(\"{word}\" 단어의 글자 아래). 모든 글자가 충분히 있고, '{word[0]}' 글자가 "
                 f"'{word[-1]}' 글자보다 흔하지 않으니 앞에서부터 찾습니다."},
          want=0, under=under)

    skipped = []

    def search(r, c, i):
        if i == len(word):
            return True
        if not (0 <= r < rows and 0 <= c < cols) or board[r][c] != word[i]:
            return False
        path.append((r, c, i))
        moves = [move(at("word", i), at("board", [r, c]), value=word[i])]
        if not path[:-1]:
            skip = ({"en": f"The scan passes {len(skipped)} cells that aren't '{word[0]}'; ",
                     "ko": f"보드를 훑으며 '{word[0]}' 글자가 아닌 칸 {len(skipped)}개를 지나고, "} if skipped else
                    {"en": "", "ko": ""})
            skipped.clear()
            head = {"en": skip["en"] + f"{cell(r, c)} holds '{word[0]}', word[0]: start a trace there and mark it \"#\".",
                    "ko": skip["ko"] + f"{cell(r, c)} 칸에 word[0]인 '{word[0]}' 글자가 있으니 여기서 시작해 \"#\" 표시를 "
                                       f"합니다."}
        else:
            pr, pc, _ = path[-2]
            head = {"en": f"The neighbour {cell(r, c)} of {cell(pr, pc)} holds '{word[i]}', word[{i}]: step onto it and "
                          f"mark it \"#\".",
                    "ko": f"{cell(pr, pc)} 칸의 이웃 {cell(r, c)} 칸에 word[{i}]인 '{word[i]}' 글자가 있으니 그 칸으로 가서 "
                          f"\"#\" 표시를 합니다."}
        if i + 1 == len(word):
            head = {"en": head["en"][:-1] + f"; that was the last letter, so search(i={i + 1}) returns true.",
                    "ko": head["ko"] + f" 마지막 글자이므로 search(i={i + 1}) 호출이 true를 반환합니다."}
        frame(head, lit=(r, c), want=i, moves=moves)
        board[r][c] = "#"
        found = (search(r + 1, c, i + 1) or search(r - 1, c, i + 1)
                 or search(r, c + 1, i + 1) or search(r, c - 1, i + 1))
        board[r][c] = word[i]
        if not found:
            frame({"en": f"No neighbour of {cell(r, c)} holds '{word[i + 1]}', word[{i + 1}], so this call frees the cell "
                         f"and returns false.",
                   "ko": f"{cell(r, c)} 칸의 이웃에 word[{i + 1}]인 '{word[i + 1]}' 글자가 없으므로 이 호출은 칸을 풀어 주고 "
                         f"false를 반환합니다."},
                  bad=[(r, c)], want=i + 1, word_marks={"good": [k for _, _, k in path], "bad": [i + 1]})
            path.pop()
        return found

    for r in range(rows):
        for c in range(cols):
            if search(r, c, 0):
                frame({"en": f"true comes back up through every open call, so \"{word}\" can be traced: the answer is "
                             f"true.",
                       "ko": f"true가 열린 호출을 모두 거쳐 돌아오므로 \"{word}\" 단어를 따라 그릴 수 있고, 답은 true입니다."},
                      done=True, answer="true")
                return "true"
            if board[r][c] != word[0]:
                skipped.append((r, c))
    frame({"en": f"Every cell has been tried as the start and every trace failed, so \"{word}\" can't be traced: false.",
           "ko": f"모든 칸을 시작점으로 시도했지만 모두 실패했으므로 \"{word}\" 단어는 만들 수 없고, 답은 false입니다."},
          word_marks={}, done=False, answer="false")
    return "false"


for number, sample in enumerate(sample_cases(SLUG), start=1):
    lines = sample["input"].split("\n")
    board, word = json.loads(lines[0]), lines[1].strip()
    run = sample_run(wt, number, sample, input=f"board = {json.dumps(board, separators=(',', ':'))}, word = \"{word}\"")
    solve(board, word, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
