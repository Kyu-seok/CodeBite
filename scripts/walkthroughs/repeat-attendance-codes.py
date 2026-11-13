#!/usr/bin/env python3.12
"""repeat-attendance-codes' Walkthrough: the reference solution
(scripts/replay-solutions/repeat-attendance-codes.py), which marks code c as seen by making
codes[c-1] negative, recording one frame per scan on each sample Test Case.

    CODEBITE_DB=<database> scripts/walkthroughs/repeat-attendance-codes.py

writes common/src/main/resources/walkthroughs/repeat-attendance-codes.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import driver_list, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough  # noqa: E402

SLUG = "repeat-attendance-codes"

wt = Walkthrough(
    {"en": "Repeat Attendance Codes", "ko": "두 번 찍힌 출석 코드"},
    {"en": "Codes run 1..n, so slot c-1 can stand for code c: the first scan of c makes that slot negative, "
           "and finding it already negative means c was scanned before.",
     "ko": "코드가 1..n이므로 c-1번 칸이 코드 c를 맡습니다. c를 처음 읽으면 그 칸을 음수로 바꾸고, "
           "이미 음수라면 c는 앞에서 한 번 찍힌 것입니다."},
    views=[
        {"id": "codes", "type": "array", "title": {"en": "codes (tag: the code a slot stands for)",
                                                   "ko": "codes (태그: 칸이 맡은 코드)"}},
        {"id": "state", "type": "vars"},
    ],
)


def solve(codes, run):
    """Solution.listRepeatedCodes with a frame per scan. Returns the answer as the Driver prints it."""
    n = len(codes)
    repeated = []
    i = slot = None

    def frame(caption, lit=(), good=(), path=(), repeated_mark=None, **answer):
        run.frame(caption,
                  codes={"values": codes, "pointers": {"i": i, "c-1": slot},
                         "tags": [[j, f"#{j + 1}"] for j in range(n)],
                         "marks": {"path": list(path), "good": list(good), "lit": list(lit)}},
                  state={"items": [{"label": {"en": "repeated", "ko": "repeated (두 번 찍힌 코드)"},
                                    "value": list(repeated), "empty": {"en": "none yet", "ko": "아직 없음"},
                                    "mark": repeated_mark}]},
                  **answer)

    frame({"en": f"{n} scans of codes 1..{n}. Slot c-1 stands for code c (its tag). Read the scans left to right; "
                 f"a negative slot will mean its code was already scanned.",
           "ko": f"코드 1..{n}의 스캔 {n}개입니다. c-1번 칸이 코드 c를 맡습니다(태그). 스캔을 왼쪽부터 읽고, "
                 f"음수인 칸은 그 코드가 이미 찍혔다는 뜻입니다."})
    for i, code in enumerate(codes):
        c = abs(code)  # an earlier flip may have made this scan negative; its code is still |codes[i]|
        slot = c - 1
        read = f"|codes[{i}]| = {c}" if code < 0 else f"codes[{i}] = {c}"
        if codes[slot] < 0:
            repeated.append(c)
            frame({"en": f"{read}, and slot {slot} is already negative ({codes[slot]}): code {c} was scanned "
                         f"before. Add {c} to repeated.",
                   "ko": f"{read}: {slot}번 칸이 이미 음수({codes[slot]})이므로 {c}번 코드는 앞에서 찍혔습니다. "
                         f"repeated에 추가: {c}."},
                  lit=[i] if i != slot else [], path=[slot], repeated_mark="good")
        else:
            before = codes[slot]
            codes[slot] = -codes[slot]
            frame({"en": f"{read}, and slot {slot} is positive: the first scan of code {c}. "
                         f"Flip it, {before} → {codes[slot]}.",
                   "ko": f"{read}: {slot}번 칸이 양수이므로 {c}번 코드의 첫 스캔입니다. "
                         f"부호를 바꿉니다, {before} → {codes[slot]}."},
                  lit=[i] if i != slot else [], good=[slot])
    i = slot = None
    result = sorted(repeated)
    answer = driver_list(result)
    if result:
        listed = ", ".join(map(str, result))
        frame({"en": f"Every scan read. The codes that met a negative slot were scanned twice: {listed}. "
                     f"Answer {answer}.",
               "ko": f"모든 스캔을 읽었습니다. 음수 칸을 만난 코드가 두 번 찍힌 코드입니다: {listed}. "
                     f"답은 {answer}입니다."},
              path=[c - 1 for c in result], repeated_mark="good", answer=answer)
    else:
        frame({"en": f"Every scan read and each one found its slot positive: no code was scanned twice. "
                     f"Answer {answer}.",
               "ko": f"모든 스캔을 읽는 동안 음수 칸을 만난 적이 없으므로 두 번 찍힌 코드가 없습니다. "
                     f"답은 {answer}입니다."},
              answer=answer)


for number, sample in enumerate(sample_cases(SLUG), start=1):
    codes = json.loads(sample["input"])
    run = sample_run(wt, number, sample, input=f"codes = {sample['input']}")
    solve(codes, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
