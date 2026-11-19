#!/usr/bin/env python3.12
"""reverse-savefile-flags's Walkthrough: the reference solution (scripts/replay-solutions/reverse-savefile-flags.py),
each 1 bit i of statusWord set at position 31 - i of the result, recording one frame per 1 bit on each sample Test
Case (a 0 bit sets nothing, so the caption names the 0s passed over). Both words are a grid of bits, one row per
byte, the highest byte first, each bit tagged with its number, so a bit's mirror is the cell at the same place
read from the other end.

    CODEBITE_DB=<database> scripts/walkthroughs/reverse-savefile-flags.py

writes common/src/main/resources/walkthroughs/reverse-savefile-flags.json.
"""
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import josa, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move  # noqa: E402

SLUG = "reverse-savefile-flags"
BITS = {"1": {"label": {"en": "set", "ko": "켜짐"}, "tone": "a"},
        "0": {"label": {"en": "clear", "ko": "꺼짐"}, "tone": "plain"}}

wt = Walkthrough(
    {"en": "Reverse Save File Flags", "ko": "세이브 파일 플래그 뒤집기"},
    {"en": "Walk the 32 bits of statusWord from bit 0 up; each 1 at bit i sets bit 31 − i of the result.",
     "ko": "statusWord의 32비트를 0번부터 차례로 보며, i번 비트가 1이면 결과의 31 − i번 비트를 켭니다."},
    views=[
        {"id": "word", "type": "grid", "values": BITS,
         "title": {"en": "statusWord, one byte per row (tag: bit)", "ko": "statusWord, 행마다 1바이트 (태그: 비트 번호)"}},
        {"id": "result", "type": "grid", "values": BITS,
         "title": {"en": "result (tag: bit)", "ko": "result (결과, 태그: 비트 번호)"}},
    ],
)


def cell(bit):
    p = 31 - bit
    return [p // 8, p % 8]


def grid(v):
    return [[(v >> (31 - (8 * r + c))) & 1 for c in range(8)] for r in range(4)]


TAGS = [[*cell(b), str(b)] for b in range(32)]


def zeros(lo, hi):
    """The caption's words for bits lo..hi, all 0, passed over."""
    if lo > hi:
        return None
    if lo == hi:
        return {"en": f"Bit {lo} is 0 and sets", "ko": f"{lo}번 비트는 0"}
    return {"en": f"Bits {lo} to {hi} are 0 and set", "ko": f"{lo}~{hi}번 비트는 0"}


def solve(word, run):
    """Solution.reverseFlags with a frame per 1 bit. Returns the result."""
    result = 0

    def frame(caption, lit=None, good=None, path=False, moves=None, **answer):
        ones = [b for b in range(32) if word >> b & 1]
        run.frame(caption,
                  word={"cells": grid(word), "tags": TAGS,
                        "marks": {"lit": [cell(lit)] if lit is not None else [],
                                  "path": [cell(b) for b in ones] if path else []}},
                  result={"cells": grid(result), "tags": TAGS,
                          "marks": {"good": [cell(good)] if good is not None else [],
                                    "path": [cell(31 - b) for b in ones] if path else []}},
                  moves=moves, **answer)

    frame({"en": f"statusWord = {word}. result starts at 0, all 32 bits clear.",
           "ko": f"statusWord = {word}입니다. result는 0에서, 32비트가 모두 꺼진 채로 시작합니다."})
    after = 0  # the lowest bit not yet walked
    for i in range(32):
        if not word >> i & 1:
            continue
        result |= 1 << (31 - i)
        skipped = zeros(after, i - 1)
        lead = {"en": f"{skipped['en']} nothing. ", "ko": f"{skipped['ko']}이라 켜는 비트가 없고, "} if skipped else {"en": "", "ko": ""}
        frame({"en": f"{lead['en']}Bit {i} is 1, so result's bit 31 − {i} = {31 - i} is set: result = {result}.",
               "ko": f"{lead['ko']}{i}번 비트가 1이므로 result의 31 − {i} = {31 - i}번 비트를 켭니다. result = {josa(result, '이가')} 됩니다."},
              lit=i, good=31 - i,
              moves=[move(at("word", cell(i)), at("result", cell(31 - i)))])
        after = i + 1
    skipped = zeros(after, 31)
    tail = {"en": f"{skipped['en']} nothing more. ", "ko": f"{skipped['ko']}이라 더 켤 비트가 없습니다. "} if skipped else {"en": "", "ko": ""}
    terms = " + ".join(f"2^{31 - b}" for b in range(32) if word >> b & 1) or "0"
    frame({"en": f"{tail['en']}result = {terms} = {result}: answer {result}.",
           "ko": f"{tail['ko']}result = {terms} = {result}, 답은 {result}입니다."},
          path=True, answer=str(result))
    return result


for number, sample in enumerate(sample_cases(SLUG), start=1):
    word = int(sample["input"])
    run = sample_run(wt, number, sample, input=f"statusWord = {word}")
    solve(word, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
