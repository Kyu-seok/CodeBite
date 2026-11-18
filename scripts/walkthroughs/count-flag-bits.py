#!/usr/bin/env python3.12
"""count-flag-bits's Walkthrough: the reference solution (scripts/replay-solutions/count-flag-bits.py), each count
built from a smaller one, recording one frame per i on each sample Test Case. i & (i - 1) clears i's lowest 1 bit,
so its count is already in the array: it moves into cell i with one added.

    CODEBITE_DB=<database> scripts/walkthroughs/count-flag-bits.py

writes common/src/main/resources/walkthroughs/count-flag-bits.json.
"""
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import driver_list, josa, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move  # noqa: E402

SLUG = "count-flag-bits"

wt = Walkthrough(
    {"en": "Count Flag Bits", "ko": "비트 플래그 개수 세기"},
    {"en": "i & (i − 1) is i with its lowest 1 bit cleared, a smaller number already counted, "
           "so flagCounts[i] = flagCounts[i & (i − 1)] + 1.",
     "ko": "i & (i − 1)은 i에서 가장 낮은 1 비트를 끈 더 작은 수라 이미 세어 두었으므로, "
           "flagCounts[i] = flagCounts[i & (i − 1)] + 1입니다."},
    views=[
        {"id": "counts", "type": "array",
         "title": {"en": "flagCounts (tag: i in binary)", "ko": "flagCounts (태그: i의 이진수)"}},
    ],
)


def solve(upper, run):
    """Solution.tallyPriorityFlags with a frame per i. Returns the counts."""
    width = max(1, upper.bit_length())

    def bits(v):
        return format(v, f"0{width}b")

    counts = [0] * (upper + 1)

    def frame(caption, i=None, j=None, path=False, **answer):
        filled = upper if path else (i if i is not None else 0)
        marks = {"path": list(range(upper + 1))} if path else {"good": [i] if i is not None else [], "lit": [j] if j is not None else []}
        run.frame(caption,
                  counts={"values": counts,
                          "tags": [[k, bits(k)] for k in range(upper + 1)],
                          "unread": list(range(filled + 1, upper + 1)),
                          "pointers": {"i": i, "i & (i−1)": j},
                          "marks": marks},
                  moves=[move(at("counts", j), at("counts", i), value=f"{counts[j]} + 1")] if i is not None else None,
                  **answer)

    frame({"en": f"upperId = {upper}: one count for each i from 0 to {upper}. "
                 "flagCounts[0] = 0, since 0 has no 1 bits; every later i builds on a smaller one.",
           "ko": f"upperId = {upper}이므로 0부터 {upper}까지 i마다 개수를 하나씩 셉니다. "
                 "0에는 1 비트가 없어 flagCounts[0] = 0이고, 그다음 i는 모두 더 작은 수에서 이어 갑니다."})
    for i in range(1, upper + 1):
        j = i & (i - 1)
        counts[i] = counts[j] + 1
        frame({"en": f"i = {i} = {bits(i)}. {i} & {i - 1} = {bits(j)} = {j} clears its lowest 1, "
                     f"so flagCounts[{i}] = flagCounts[{j}] + 1 = {counts[i]}.",
               "ko": f"i = {i} = {bits(i)}입니다. {i} & {i - 1} = {bits(j)} = {josa(j, '은는')} 가장 낮은 1을 끈 수이므로 "
                     f"flagCounts[{i}] = flagCounts[{j}] + 1 = {counts[i]}입니다."},
              i=i, j=j)
    if upper == 0:
        why = {"en": "Only 0 is asked for, and it has no 1 bits", "ko": "0 하나만 세면 되고, 0에는 1 비트가 없습니다"}
    else:
        why = {"en": f"Every i up to {upper} is counted", "ko": f"{upper}까지 모든 i를 셌습니다"}
    frame({"en": f"{why['en']}: answer {driver_list(counts)}.",
           "ko": f"{why['ko']}. 답은 {driver_list(counts)}입니다."},
          path=True, answer=driver_list(counts))
    return counts


for number, sample in enumerate(sample_cases(SLUG), start=1):
    upper = int(sample["input"])
    run = sample_run(wt, number, sample, input=f"upperId = {upper}")
    solve(upper, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
