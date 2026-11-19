#!/usr/bin/env python3.12
"""bump-takeout-number's Walkthrough: the reference solution (scripts/replay-solutions/bump-takeout-number.py), +1
from the last digit leftward, recording one frame per digit the 1 reaches (a 9 becomes 0 and passes the 1 left)
and one for a new leading 1 on each sample Test Case, plus an extra run, [9,9], where every digit carries. The
digits are tagged 10^k, highest place first, as the number is written; each +1 moves in from the digit that passed
it on.

    CODEBITE_DB=<database> scripts/walkthroughs/bump-takeout-number.py

writes common/src/main/resources/walkthroughs/bump-takeout-number.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import driver_list, josa, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move  # noqa: E402

SLUG = "bump-takeout-number"
SUPERSCRIPT = str.maketrans("0123456789", "⁰¹²³⁴⁵⁶⁷⁸⁹")
EXTRA = [9, 9]

wt = Walkthrough(
    {"en": "Bump Takeout Number", "ko": "포장 번호 하나 올리기"},
    {"en": "Add 1 to the last digit. A digit below 9 takes it and the number is done; a 9 becomes 0 and passes the 1 "
           "one place left. If the 1 passes the first digit, it becomes a new leading 1.",
     "ko": "마지막 자릿수에 1을 더합니다. 9보다 작은 자릿수는 1을 받고 끝나고, 9는 0이 되며 1을 한 자리 왼쪽으로 "
           "넘깁니다. 1이 첫 자릿수를 넘어가면 맨 앞에 새로 1이 붙습니다."},
    views=[
        {"id": "digits", "type": "array", "title": {"en": "result (tag: place)", "ko": "result (결과, 태그: 자리)"}},
    ],
)


def solve(digits, run):
    """Solution.bumpParcelCode with a frame per digit the 1 reaches. Returns the digits."""
    result = digits[:]
    i = None

    def frame(caption, good=(), lit=(), path=False, moves=None, **answer):
        n = len(result)
        run.frame(caption,
                  digits={"values": list(result), "pointers": {"i": i},
                          "tags": [[n - 1 - k, f"10{str(k).translate(SUPERSCRIPT)}"] for k in range(n)],
                          "marks": {"path": list(range(n))} if path else {"good": list(good), "lit": list(lit)}},
                  moves=moves, **answer)

    number = "".join(map(str, digits))
    frame({"en": f"result starts as a copy of {driver_list(digits)}, the number {number}. The 1 goes into the last digit first.",
           "ko": f"result는 {driver_list(digits)}의 복사본, 곧 {number}에서 시작합니다. 1은 먼저 마지막 자릿수에 더합니다."})
    for i in range(len(result) - 1, -1, -1):
        src = None if i == len(result) - 1 else at("digits", i + 1)
        came = ({"en": "", "ko": ""} if src is None else
                {"en": "The 1 passed on reaches it. ", "ko": "넘어온 1이 이 자리에 닿습니다. "})
        if result[i] < 9:
            result[i] += 1
            frame({"en": f"{came['en']}result[{i}] = {result[i] - 1} is below 9, so it becomes {result[i]} and the number is done.",
                   "ko": f"{came['ko']}result[{i}] = {result[i] - 1}: 9보다 작으니 {josa(result[i], '이가')} 되고 끝납니다."},
                  good=[i], moves=[move(src, at("digits", i), value="+1")])
            break
        result[i] = 0
        frame({"en": f"{came['en']}result[{i}] is 9: 9 + 1 = 10, so it becomes 0 and the 1 passes one place left.",
               "ko": f"{came['ko']}result[{i}] = 9: 9 + 1 = 10이므로 0이 되고 1을 한 자리 왼쪽으로 넘깁니다."},
              good=[i], moves=[move(src, at("digits", i), value="+1")])
    else:
        i = None
        result.insert(0, 1)
        frame({"en": "The 1 passed the first digit, so it becomes a new leading 1.",
               "ko": "1이 첫 자릿수를 넘어갔으므로 맨 앞에 새로 1이 붙습니다."},
              good=[0], moves=[move(at("digits", 1), at("digits", 0), value="+1")])
    i = None
    answer = driver_list(result)
    frame({"en": f"{number} + 1 = {''.join(map(str, result))}: answer {answer}.",
           "ko": f"{number} + 1 = {''.join(map(str, result))}, 답은 {answer}입니다."},
          path=True, answer=answer)
    return result


for number, sample in enumerate(sample_cases(SLUG), start=1):
    digits = json.loads(sample["input"])
    solve(digits, sample_run(wt, number, sample, input=f"digits = {driver_list(digits)}"))
solve(EXTRA, wt.run({"en": "Extra: every digit carries", "ko": "추가: 모든 자리에서 올림"},
                    input=f"digits = {driver_list(EXTRA)}", expected="[1,0,0]", extra=True))
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
