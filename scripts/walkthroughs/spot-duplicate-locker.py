#!/usr/bin/env python3.12
"""spot-duplicate-locker's Walkthrough: the reference solution
(scripts/replay-solutions/spot-duplicate-locker.py), one pass with a set of numbers seen, recording one
frame per locker number on each sample Test Case.

    CODEBITE_DB=<database> scripts/walkthroughs/spot-duplicate-locker.py

writes common/src/main/resources/walkthroughs/spot-duplicate-locker.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import driver_list, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough  # noqa: E402

SLUG = "spot-duplicate-locker"

wt = Walkthrough(
    {"en": "Spot the Duplicate Locker", "ko": "사물함 번호 중복 찾기"},
    {"en": "One pass with a set: a number already in the set is a repeat; otherwise add it and move on.",
     "ko": "집합으로 한 번 훑기: 이미 집합에 있는 번호면 중복이고, 없으면 넣고 다음으로 넘어갑니다."},
    views=[
        {"id": "lockers", "type": "array", "title": "lockers"},
        {"id": "seen", "type": "table", "title": {"en": "seen (set)", "ko": "본 번호 (집합)"}},
    ],
)


def solve(lockers, run):
    """Solution.detectClash with a frame per number. Returns the answer as the Driver prints it."""
    seen = set()
    first_at = {}  # number -> the index it was first seen at, so the last frame can mark both copies
    i = None

    def frame(caption, lit=(), good=(), path=(), dim=(), seen_marks=None, **answer):
        run.frame(caption,
                  lockers={"values": lockers, "pointers": {"i": i},
                           "marks": {"lit": list(lit), "good": list(good), "path": list(path), "dim": list(dim)}},
                  seen={"rows": [{"label": {"en": "set", "ko": "집합"}, "cells": list(first_at)}],
                        "marks": seen_marks or {}},
                  **answer)

    frame({"en": "Read the numbers left to right, keeping a set of every number seen so far.",
           "ko": "번호를 왼쪽부터 읽으며, 지금까지 본 번호를 모두 집합에 담습니다."})
    for i, number in enumerate(lockers):
        if number in seen:
            j = first_at[number]
            frame({"en": f"Locker {i} is {number}, and {number} is already in the set: index {j} has it too. "
                         f"A repeat, so the answer is true without reading further.",
                   "ko": f"인덱스 {i}의 {number}번은 이미 집합에 있습니다. 인덱스 {j}에도 같은 번호가 있으니 "
                         f"중복입니다. 더 읽지 않고 답은 true입니다."},
                  path=[j, i], dim=range(i + 1, len(lockers)), seen_marks={"path": [[0, list(first_at).index(number)]]}, answer="true")
            return
        seen.add(number)
        first_at[number] = i
        frame({"en": f"Locker {i} is {number}, not in the set yet. Add it.",
               "ko": f"인덱스 {i}의 {number}번은 아직 집합에 없습니다. 집합에 넣습니다."},
              lit=[i], dim=range(i + 1, len(lockers)), seen_marks={"good": [[0, len(first_at) - 1]]})
    i = None
    frame({"en": f"All {len(lockers)} numbers read and none was in the set when it came up: "
                 f"every number is distinct. Answer false.",
           "ko": f"번호 {len(lockers)}개를 모두 읽는 동안 집합에 이미 있던 번호가 하나도 없었으니 "
                 f"모두 서로 다릅니다. 답은 false입니다."},
          path=range(len(lockers)),
          seen_marks={"path": [[0, c] for c in range(len(first_at))]}, answer="false")


for number, sample in enumerate(sample_cases(SLUG), start=1):
    lockers = json.loads(sample["input"])
    run = sample_run(wt, number, sample, input=f"lockers = {driver_list(lockers)}")
    solve(lockers, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
