#!/usr/bin/env python3.12
"""count-cipher-decodings' Walkthrough: the reference solution (scripts/replay-solutions/count-cipher-decodings.py),
two rolling values, the ways to split the digits up to the one before last read and up to the last read, recording
one frame per digit on each sample Test Case.

The ways are an array over prefix lengths 0 to n, each filled when the loop reaches it; the two values the solution
keeps are the cells tagged `before` and `current`, and the prefixes behind them fade. Each digit's count moves in
from `current` when the digit stands as its own part, and from `before` when it pairs with the digit before it
(drawn as a span over the two) into a number from 10 to 26.

    CODEBITE_DB=<database> scripts/walkthroughs/count-cipher-decodings.py

writes common/src/main/resources/walkthroughs/count-cipher-decodings.json.
"""
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import josa, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move, span  # noqa: E402

SLUG = "count-cipher-decodings"
UNSEEN = "?"

wt = Walkthrough(
    {"en": "Count Cipher Decodings", "ko": "암호 해독 방법 세기"},
    {"en": "A split's last part is the last digit alone (if it isn't 0) or the last two digits (if they make 10 to "
           "26), so the ways for a prefix are the ways one digit shorter plus the ways two digits shorter, each "
           "counted only when its part is allowed.",
     "ko": "분할의 마지막 조각은 0이 아닌 마지막 숫자 하나이거나 10에서 26 사이가 되는 마지막 두 숫자입니다. 그래서 "
           "앞부분의 방법 수는 한 자리 짧은 앞부분의 수와 두 자리 짧은 앞부분의 수를, 그 조각이 허용될 때만 더한 "
           "값입니다."},
    views=[
        {"id": "digits", "type": "array", "title": {"en": "digits", "ko": "digits (숫자 문자열)"}},
        {"id": "ways", "type": "array",
         "title": {"en": "ways to split the first k digits", "ko": "앞 k자리를 나누는 방법 수"}},
    ],
)
BEFORE = {"en": "before", "ko": "이전"}
CURRENT = {"en": "current", "ko": "현재"}


def first(k):
    """The prefix of k digits, as the captions name it."""
    if k == 0:
        return {"en": "the empty prefix", "ko": "빈 앞부분"}
    return {"en": "the first digit" if k == 1 else f"the first {k} digits", "ko": f"앞 {k}자리"}


def pair_josa(pair, particle):
    """The two-digit part `pair` (it may start with 0, as "06") with the particle that fits how it is read."""
    number = int(pair)
    return pair + josa(number, particle)[len(str(number)):]


def solve(digits, run):
    """Solution.countDecodings with a frame per digit. Returns the answer as the Driver prints it."""
    n = len(digits)
    chars = list(digits)
    ways = [1, 1] + [UNSEEN] * (n - 1)

    def frame(caption, k, i=None, pair=None, digit_marks=None, way_marks=None, moves=None, done=False, **answer):
        spans = {"pair": pair} if pair else {}
        run.frame(caption,
                  digits={"values": chars, "pointers": {"i": i}, "spans": spans, "marks": digit_marks or {},
                          "unread": [] if done else list(range((i if i is not None else 0) + 1, n))},
                  ways={"values": ways, "tags": [[k - 1, BEFORE], [k, CURRENT]],
                        "marks": {"dim": list(range(k - 1)), **(way_marks or {})},
                        "unread": list(range(k + 1, n + 1))},
                  moves=moves, **answer)

    if digits[0] == "0":
        ways[1] = 0
        frame({"en": f"The first digit is 0, and no part may start with 0, so no split works. Answer: 0.",
               "ko": "첫 숫자가 0인데 어떤 조각도 0으로 시작할 수 없으므로 가능한 분할이 없습니다. 답은 0입니다."},
              1, i=0, digit_marks={"bad": [0]}, way_marks={"bad": [1]}, done=True, answer="0")
        return
    frame({"en": f"{n} digits. The empty prefix has 1 way, splitting nothing. The first digit {digits[0]} is not 0, "
                 "so it is a part on its own: 1 way.",
           "ko": f"숫자가 {n}개입니다. 빈 앞부분은 아무것도 나누지 않는 1가지입니다. 첫 숫자 "
                 f"{josa(int(digits[0]), '은는')} 0이 아니라 혼자 한 조각이 되므로 1가지입니다."},
          1, i=0, digit_marks={"lit": [0]}, way_marks={"good": [0, 1]})
    before, current = 1, 1
    for i in range(1, n):
        d = digits[i]
        pair = digits[i - 1:i + 1]
        one = d != "0"
        two = 10 <= int(pair) <= 26
        count = (current if one else 0) + (before if two else 0)
        moves = []
        if one:
            moves.append(move(at("ways", i), at("ways", i + 1), value=str(current)))
        if two:
            moves.append(move(at("ways", i - 1), at("ways", i + 1), value=str(before)))
        if not moves:
            moves.append(move(None, at("ways", i + 1), value="0", mark="bad"))
        ways[i + 1] = count
        alone_en = (f"{d} alone ends a split of {first(i)["en"]} ({current})" if one else
                    "0 can't be a part alone")
        alone_ko = (f"{d} 혼자 {first(i)["ko"]}의 분할 뒤에 붙고({current}가지)" if one else
                    "0은 혼자 조각이 될 수 없고")
        pair_en = (f"{pair} is 10 to 26, so it ends a split of {first(i - 1)["en"]} ({before})" if two else
                   f"{pair} is not 10 to 26")
        pair_ko = (f"{pair_josa(pair, '은는')} 10~26이라 {first(i - 1)["ko"]}의 분할 뒤에 붙습니다({before}가지)" if two else
                   f"{pair_josa(pair, '은는')} 10~26이 아닙니다")
        if pair[0] == "0":
            pair_en = f"{pair} starts with 0"
            pair_ko = f"{pair_josa(pair, '은는')} 0으로 시작합니다"
        parts = [str(current)] * one + [str(before)] * two
        total = " + ".join(parts) + f" = {count}" if len(parts) == 2 else str(count)
        before, current = current, count
        frame({"en": f"Digit {i} is {d}: {alone_en}, and {pair_en}. The first {i + 1} digits split {total} "
                     f"{'way' if count == 1 else 'ways'}.",
               "ko": f"{i}번 숫자 {d}: {alone_ko}, {pair_ko}. 앞 {i + 1}자리를 나누는 방법은 {total}가지입니다."},
              i + 1, i=i,
              pair=span(i - 1, i, pair, mark="good" if two else "bad"),
              digit_marks={"lit": [i]} if one else {"bad": [i]},
              way_marks={"lit": [c for c, used in ((i, one), (i - 1, two)) if used],
                         ("good" if count else "bad"): [i + 1]},
              moves=moves)
    frame({"en": f"Every digit read: the whole string of {n} digits splits {current} "
                 f"{'way' if current == 1 else 'ways'}. Answer: {current}.",
           "ko": f"모든 숫자를 읽었습니다. {n}자리 전체를 나누는 방법은 {current}가지입니다. 답은 {current}입니다."},
          n, done=True, way_marks={("path" if current else "bad"): [n]}, answer=str(current))


for number, sample in enumerate(sample_cases(SLUG), start=1):
    digits = sample["input"].strip()
    run = sample_run(wt, number, sample, input=f"digits = \"{digits}\"")
    solve(digits, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
