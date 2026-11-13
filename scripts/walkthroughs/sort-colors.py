#!/usr/bin/env python3.12
"""sort-colors' Walkthrough: the reference solution (scripts/replay-solutions/sort-colors.py), the
Dutch national flag partition with low, mid and high, recording one frame per value mid reads on each
sample Test Case. The settled 0s, 1s and 2s are spans over nums, the cells mid has yet to read are dashed, and
each swap is two moves between cells.

    CODEBITE_DB=<database> scripts/walkthroughs/sort-colors.py

writes common/src/main/resources/walkthroughs/sort-colors.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import driver_list, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, span, swap  # noqa: E402

SLUG = "sort-colors"

wt = Walkthrough(
    {"en": "Sort Colors", "ko": "색깔 정렬"},
    {"en": "Three pointers: everything before low is 0, everything after high is 2, and mid reads the "
           "unsorted middle, swapping each 0 down to low and each 2 up to high.",
     "ko": "포인터 세 개: low 앞은 모두 0, high 뒤는 모두 2입니다. mid가 가운데의 정렬 안 된 칸을 읽으며 "
           "0은 low 쪽으로, 2는 high 쪽으로 맞바꿉니다."},
    views=[
        {"id": "nums", "type": "array", "title": "nums"},
    ],
)


def solve(nums, run):
    """Solution.sortColors with a frame per value mid reads. Returns nothing; the last frame carries
    the sorted array as the Driver prints it."""
    n = len(nums)
    low, mid, high = 0, 0, n - 1

    def frame(caption, lit=(), good=(), path=(), moves=None, **answer):
        spans = {"zeros": span(0, low - 1, {"en": "0s", "ko": "0"}) if low > 0 else None,
                 "ones": span(low, mid - 1, {"en": "1s", "ko": "1"}) if mid > low else None,
                 "twos": span(high + 1, n - 1, {"en": "2s", "ko": "2"}) if high < n - 1 else None}
        if path:
            spans = {}
        run.frame(caption,
                  nums={"values": nums, "spans": spans,
                        "unread": [] if path else list(range(mid, high + 1)),
                        "pointers": {} if path else {"low": low, "mid": mid if mid < n else None, "high": high},
                        "marks": {"lit": list(lit), "good": list(good), "path": list(path)}},
                  moves=moves, **answer)

    frame({"en": f"low and mid start at 0, high at {n - 1}. Every cell from mid to high is still unread.",
           "ko": f"low와 mid는 0, high는 {n - 1}에서 시작합니다. mid부터 high까지는 아직 읽지 않은 칸입니다."})
    while mid <= high:
        m, v = mid, nums[mid]
        if v == 0:
            lo = low
            nums[low], nums[mid] = nums[mid], nums[low]
            low += 1
            mid += 1
            if lo == m:
                frame({"en": f"nums[{m}] = 0, and it is already at low. Both low and mid step right.",
                       "ko": f"nums[{m}] = 0: 이미 low 자리에 있습니다. low와 mid가 함께 오른쪽으로 한 칸 갑니다."},
                      good=[m])
            else:
                frame({"en": f"nums[{m}] = 0: swap it with nums[{lo}] at low, so the 0 joins the 0s and the 1 "
                             f"moves up to index {m}. Both low and mid step right.",
                       "ko": f"nums[{m}] = 0: low 자리의 nums[{lo}] 값과 맞바꿔 0을 앞쪽 0들에 붙이고, 1은 인덱스 "
                             f"{m}의 칸으로 옮깁니다. low와 mid가 함께 오른쪽으로 한 칸 갑니다."},
                      good=[lo, m], moves=swap("nums", lo, m, nums[m], nums[lo]))
        elif v == 2:
            hi = high
            nums[mid], nums[high] = nums[high], nums[mid]
            high -= 1
            if hi == m:
                frame({"en": f"nums[{m}] = 2, and it is already at high. high steps left.",
                       "ko": f"nums[{m}] = 2: 이미 high 자리에 있습니다. high가 왼쪽으로 한 칸 갑니다."},
                      good=[m])
            else:
                frame({"en": f"nums[{m}] = 2: swap it with nums[{hi}] at high, so the 2 joins the 2s. high steps "
                             f"left; mid stays, because the {nums[m]} that came back hasn't been read.",
                       "ko": f"nums[{m}] = 2: high 자리의 nums[{hi}] 값과 맞바꿔 2를 뒤쪽 2들에 붙이고, high는 왼쪽으로 "
                             f"한 칸 갑니다. 맞바꿔 온 nums[{m}] = {nums[m]}: 아직 읽지 않은 값이라 mid는 그대로입니다."},
                      good=[m, hi], moves=swap("nums", m, hi, nums[hi], nums[m]))
        else:
            mid += 1
            frame({"en": f"nums[{m}] = 1: a 1 belongs between the 0s and the 2s, where it already is. "
                         f"Only mid steps right.",
                   "ko": f"nums[{m}] = 1: 1은 0들과 2들 사이에 있어야 하고, 지금 그 자리에 있습니다. "
                         f"mid만 오른쪽으로 한 칸 갑니다."},
                  lit=[m])
    answer = driver_list(nums)
    frame({"en": f"mid passed high: no unread cell is left. The 0s are before low, the 2s after high and "
                 f"the 1s between, so nums is {answer}.",
           "ko": f"mid가 high를 지나 읽지 않은 칸이 없습니다. low 앞은 0, high 뒤는 2, 그 사이는 1이므로 "
                 f"nums는 {answer}입니다."},
          path=range(n), answer=answer)


for number, sample in enumerate(sample_cases(SLUG), start=1):
    nums = json.loads(sample["input"])
    run = sample_run(wt, number, sample, input=f"nums = {driver_list(nums)}")
    solve(nums, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
