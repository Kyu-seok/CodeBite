#!/usr/bin/env python3.12
"""calm-number's Walkthrough: the reference solution (scripts/replay-solutions/calm-number.py), the digit-square
chain with a set of the numbers seen, recording three frames per pass (the number looked up and added to seen, split
into its digits with each square under its digit, the squares summed into the next number) on each sample Test Case.
The number is a one-cell array, so it is an address the digits come from and the sum goes back into.

    CODEBITE_DB=<database> scripts/walkthroughs/calm-number.py

writes common/src/main/resources/walkthroughs/calm-number.json.
"""
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import josa, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move, probe  # noqa: E402

SLUG = "calm-number"

wt = Walkthrough(
    {"en": "Calm Number", "ko": "차분한 수"},
    {"en": "Replace the number with the sum of its digits' squares until it is 1 (calm) or repeats one already seen "
           "(a loop that never reaches 1); a set of the numbers seen catches the repeat.",
     "ko": "수를 각 자릿수 제곱의 합으로 바꾸기를 1이 되거나(차분함) 이미 본 수가 다시 나올 때까지(1에 닿지 않는 "
           "고리) 반복합니다. 본 수를 담은 집합이 반복을 잡아냅니다."},
    views=[
        {"id": "reading", "type": "array", "title": "reading"},
        {"id": "digits", "type": "array", "title": {"en": "digits (under: square)", "ko": "자릿수 (아래: 제곱)"},
         "empty": {"en": "not split yet", "ko": "아직 나누지 않음"}},
        {"id": "seen", "type": "set", "title": {"en": "seen", "ko": "seen (본 수)"},
         "empty": {"en": "nothing yet", "ko": "아직 없음"}},
    ],
)


def solve(reading, run):
    """Solution.isCalm with three frames per pass. Returns the answer as the Driver prints it."""
    seen = []
    digits = []

    def frame(caption, reading_mark=None, digit_marks=None, seen_marks=None, probes=(), moves=None, **answer):
        run.frame(caption,
                  reading={"values": [reading], "marks": {reading_mark: [0]} if reading_mark else {}},
                  digits={"values": list(digits), "under": [[i, str(d * d)] for i, d in enumerate(digits)],
                          "marks": digit_marks or {}},
                  seen={"members": list(seen), "probes": list(probes), "marks": seen_marks or {}},
                  moves=moves, **answer)

    frame({"en": f"Start from reading = {reading} with seen empty.",
           "ko": f"reading = {reading}에서 시작하고, seen은 비어 있습니다."})
    while reading != 1 and reading not in seen:
        seen.append(reading)
        frame({"en": f"{reading} is not 1 and not in seen, so add it to seen and go on.",
               "ko": f"{josa(reading, '은는')} 1이 아니고 seen에도 없으므로 seen에 넣고 계속합니다."},
              reading_mark="lit", seen_marks={"good": [reading]}, probes=[probe(reading, hit=False)],
              moves=[move(at("reading", 0), at("seen", reading))])
        digits = [int(c) for c in str(reading)]
        squares = " + ".join(f"{d}²" for d in digits)
        frame({"en": f"Split {reading} into its digits and square each: {squares}.",
               "ko": f"{josa(reading, '을를')} 자릿수로 나누어 각각 제곱합니다: {squares}."},
              digit_marks={"good": list(range(len(digits)))},
              moves=[move(at("reading", 0), at("digits", i), value=str(d)) for i, d in enumerate(digits)])
        total = sum(d * d for d in digits)
        before = reading
        reading = total
        sums = " + ".join(str(d * d) for d in digits) if len(digits) > 1 else f"{digits[0]}²"
        frame({"en": f"reading = {sums} = {total}, the next number after {before}.",
               "ko": f"reading = {sums} = {total}, {before} 다음 수입니다."},
              reading_mark="good", digit_marks={"lit": list(range(len(digits)))},
              moves=[move(at("digits", i), at("reading", 0), value=f"+{d * d}") for i, d in enumerate(digits)])
    chain = " → ".join(str(v) for v in seen + [reading])
    if reading == 1:
        en = f"reading is 1, so the chain {chain} reached 1: answer true." if seen else "reading is already 1: answer true."
        ko = f"reading이 1이므로 {chain} 순서로 1에 닿았습니다. 답은 true입니다." if seen else "reading이 처음부터 1입니다. 답은 true입니다."
        frame({"en": en, "ko": ko}, reading_mark="path", seen_marks={"path": list(seen)}, answer="true")
        return "true"
    frame({"en": f"{reading} is already in seen: the chain {chain} has looped without reaching 1, and it would go round "
                 "forever. Answer false.",
           "ko": f"{josa(reading, '은는')} 이미 seen에 있습니다. {chain} 순서로 1에 닿지 못한 채 고리를 이루었으니 "
                 "끝없이 돕니다. 답은 false입니다."},
          reading_mark="bad", seen_marks={"bad": [reading]}, probes=[probe(reading, hit=True)], answer="false")
    return "false"


for number, sample in enumerate(sample_cases(SLUG), start=1):
    reading = int(sample["input"])
    run = sample_run(wt, number, sample, input=f"reading = {reading}")
    solve(reading, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
