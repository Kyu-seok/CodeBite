#!/usr/bin/env python3.12
"""decode-roman-floor's Walkthrough: the reference solution (scripts/replay-solutions/decode-roman-floor.py), one
pass left to right, recording one frame per symbol on each sample Test Case: the symbol is compared with the next,
and its value moves into the total as +v, or as −v when a larger symbol follows. Each symbol is tagged with its
value, and the signed amount it added stays under it.

    CODEBITE_DB=<database> scripts/walkthroughs/decode-roman-floor.py

writes common/src/main/resources/walkthroughs/decode-roman-floor.json.
"""
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import josa, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move  # noqa: E402

SLUG = "decode-roman-floor"
VALUES = {"I": 1, "V": 5, "X": 10, "L": 50, "C": 100, "D": 500, "M": 1000}

wt = Walkthrough(
    {"en": "Decode Roman Floor", "ko": "로마 숫자 층 해독"},
    {"en": "Add each symbol's value, except that a symbol smaller than the one right after it is subtracted "
           "(the I of IV, the C of CM).",
     "ko": "기호마다 값을 더하되, 바로 다음 기호보다 작은 기호는 뺍니다(IV의 I, CM의 C)."},
    views=[
        {"id": "numeral", "type": "array",
         "title": {"en": "numeral (tag: value, under: added)", "ko": "numeral (태그: 값, 아래: 더한 값)"}},
        {"id": "total", "type": "output", "title": "total"},
    ],
)


def solve(numeral, run):
    """Solution.decodeZoneNumeral with a frame per symbol. Returns the total."""
    n = len(numeral)
    total = 0
    under = []
    i = None

    def frame(caption, lit=(), good=(), path=False, moves=None, **answer):
        run.frame(caption,
                  numeral={"values": list(numeral), "tags": [[k, str(VALUES[s])] for k, s in enumerate(numeral)],
                           "under": list(under), "pointers": {"i": i},
                           "marks": {"path": list(range(n))} if path else {"lit": list(lit), "good": list(good)}},
                  total={"values": [total], "marks": {"path": [0]} if path else {"good": [0]} if moves else {}},
                  moves=moves, **answer)

    frame({"en": f"numeral = \"{numeral}\": {n} symbols, read left to right. total starts at 0.",
           "ko": f"numeral = \"{numeral}\": 기호 {n}개를 왼쪽부터 읽습니다. total은 0에서 시작합니다."})
    for i, symbol in enumerate(numeral):
        value = VALUES[symbol]
        before = total
        if i + 1 < n and value < VALUES[numeral[i + 1]]:
            nxt = numeral[i + 1]
            total -= value
            under.append([i, f"−{value}"])
            frame({"en": f"{symbol} = {value} is smaller than the next symbol, {nxt} = {VALUES[nxt]}, so it is subtracted: "
                         f"total = {before} − {value} = {total}.",
                   "ko": f"{symbol} = {josa(value, '은는')} 다음 기호 {nxt} = {VALUES[nxt]}보다 작으므로 뺍니다. "
                         f"total = {before} − {value} = {josa(total, '이가')} 됩니다."},
                  lit=[i, i + 1], good=[i],
                  moves=[move(at("numeral", i), at("total", 0), value=f"−{value}", mark="good")])
        else:
            total += value
            under.append([i, f"+{value}"])
            if i + 1 < n:
                nxt = numeral[i + 1]
                why = {"en": f"is not smaller than the next symbol, {nxt} = {VALUES[nxt]}, so it is added",
                       "ko": f"다음 기호 {nxt} = {VALUES[nxt]}보다 작지 않으므로 더합니다"}
            else:
                why = {"en": "is the last symbol, so it is added", "ko": "마지막 기호이므로 더합니다"}
            frame({"en": f"{symbol} = {value} {why['en']}: total = {before} + {value} = {total}.",
                   "ko": f"{symbol} = {josa(value, '은는')} {why['ko']}. total = {before} + {value} = {josa(total, '이가')} 됩니다."},
                  lit=[i] + ([i + 1] if i + 1 < n else []), good=[i],
                  moves=[move(at("numeral", i), at("total", 0), value=f"+{value}", mark="good")])
    i = None
    frame({"en": f"Every symbol is read: \"{numeral}\" = {total}, answer {total}.",
           "ko": f"모든 기호를 읽었습니다. \"{numeral}\" = {total}, 답은 {total}입니다."},
          path=True, answer=str(total))
    return total


for number, sample in enumerate(sample_cases(SLUG), start=1):
    numeral = sample["input"].strip()
    solve(numeral, sample_run(wt, number, sample, input=f"numeral = \"{numeral}\""))
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
