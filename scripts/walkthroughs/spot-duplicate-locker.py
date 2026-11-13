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
from walkthrough_trace import Walkthrough, at, move, probe  # noqa: E402

SLUG = "spot-duplicate-locker"

wt = Walkthrough(
    {"en": "Spot the Duplicate Locker", "ko": "사물함 번호 중복 찾기"},
    {"en": "One pass with a set: a number already in the set is a repeat; otherwise add it and move on.",
     "ko": "집합으로 한 번 훑기: 이미 집합에 있는 번호면 중복이고, 없으면 넣고 다음으로 넘어갑니다."},
    views=[
        {"id": "lockers", "type": "array", "title": {"en": "lockers", "ko": "lockers (사물함 번호)"}},
        {"id": "seen", "type": "set", "title": {"en": "seen (set)", "ko": "본 번호 (집합)"},
         "empty": {"en": "empty", "ko": "비어 있음"}},
    ],
)


def solve(lockers, run):
    """Solution.detectClash with a frame per number. Returns the answer as the Driver prints it."""
    seen = set()
    order = []  # the set's members in the order they went in, as the view draws them
    first_at = {}  # number -> the index it was first seen at, so the last frame can mark both copies
    i = None

    def frame(caption, marks=None, seen_marks=None, probes=(), moves=None, **answer):
        run.frame(caption,
                  lockers={"values": lockers, "pointers": {"i": i}, "marks": marks or {},
                           "unread": list(range(0 if i is None else i + 1, len(lockers)))},
                  seen={"members": list(order), "marks": seen_marks or {}, "probes": list(probes)},
                  moves=moves, **answer)

    listed = ", ".join(map(str, lockers))
    frame({"en": f"Read the {len(lockers)} numbers ({listed}) left to right, looking each one up in a set of every "
                 f"number seen so far, which starts empty.",
           "ko": f"번호 {len(lockers)}개({listed})를 왼쪽부터 읽으며, 하나씩 지금까지 본 번호의 집합에서 찾아봅니다. "
                 f"집합은 처음에 비어 있습니다."})
    for i, number in enumerate(lockers):
        if number in seen:
            j = first_at[number]
            frame({"en": f"Locker {i} is {number}, and looking it up finds {number} in the set: index {j} put it "
                         f"there. A repeat, so the answer is true without reading further.",
                   "ko": f"인덱스 {i}의 {number}번을 찾아보니 집합에 이미 있습니다(인덱스 {j}에서 넣은 번호). "
                         f"중복이므로 더 읽지 않고 답은 true입니다."},
                  marks={"path": [j, i]}, seen_marks={"path": [number]}, probes=[probe(number)], answer="true")
            return
        seen.add(number)
        order.append(number)
        first_at[number] = i
        frame({"en": f"Locker {i} is {number}, not in the set yet. It goes in.",
               "ko": f"인덱스 {i}의 {number}번은 아직 집합에 없습니다. 집합에 넣습니다."},
              marks={"lit": [i]}, seen_marks={"good": [number]}, probes=[probe(number, hit=False)],
              moves=[move(at("lockers", i), at("seen", number))])
    i = None
    frame({"en": f"All {len(lockers)} numbers read and none was in the set when it came up: "
                 f"every number is distinct. Answer false.",
           "ko": f"번호 {len(lockers)}개를 모두 읽는 동안 집합에 이미 있던 번호가 하나도 없었으니 "
                 f"모두 서로 다릅니다. 답은 false입니다."},
          marks={"path": list(range(len(lockers)))}, seen_marks={"path": list(order)}, answer="false")


for number, sample in enumerate(sample_cases(SLUG), start=1):
    lockers = json.loads(sample["input"])
    run = sample_run(wt, number, sample, input=f"lockers = {driver_list(lockers)}")
    solve(lockers, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
