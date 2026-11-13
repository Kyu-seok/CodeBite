#!/usr/bin/env python3.12
"""next-speaker-order's Walkthrough: the reference solution
(scripts/replay-solutions/next-speaker-order.py), next permutation in place: find the rightmost value
that can grow, swap it with the smallest bigger value to its right, reverse the tail. One frame per
comparison, the swap and the reverse on each sample Test Case.

    CODEBITE_DB=<database> scripts/walkthroughs/next-speaker-order.py

writes common/src/main/resources/walkthroughs/next-speaker-order.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import driver_list, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough  # noqa: E402

SLUG = "next-speaker-order"

wt = Walkthrough(
    {"en": "Next Speaker Order", "ko": "다음 발표 순서"},
    {"en": "A tail that only falls is already its largest arrangement, so the change goes just left of it: "
           "bump that id to the next bigger one from the tail, then reverse the tail so it rises.",
     "ko": "내려가기만 하는 꼬리는 이미 가장 큰 배치이므로, 바꿀 곳은 꼬리 바로 왼쪽입니다. 그 ID를 꼬리에서 "
           "바로 다음으로 큰 ID와 맞바꾸고, 꼬리를 뒤집어 오름차순으로 만듭니다."},
    views=[
        {"id": "order", "type": "array", "title": "shotOrder"},
        {"id": "state", "type": "vars"},
    ],
)


def solve(nums, run):
    """Solution.advanceShotOrder with a frame per comparison, the swap and the reverse."""
    n = len(nums)
    i = n - 2
    j = None
    tail_from = n - 1  # the falling tail found so far starts here

    def frame(caption, lit=(), good=(), path=(), **answer):
        tail = nums[tail_from:] if tail_from < n else []
        run.frame(caption,
                  order={"values": nums,
                         "pointers": {"i": i if 0 <= i < n else None, "j": j},
                         "tags": [[k, {"en": "tail", "ko": "꼬리"}] for k in range(tail_from, n)],
                         "marks": {"lit": list(lit), "good": list(good), "path": list(path)}},
                  state={"items": [
                      {"label": {"en": "falling tail", "ko": "내려가는 꼬리"}, "value": list(tail),
                       "empty": {"en": "none", "ko": "없음"}},
                  ]},
                  **answer)

    frame({"en": f"Look from the right of {driver_list(nums)} for the first id smaller than its right neighbour. "
                 f"The last id, {nums[-1]}, alone is a falling tail.",
           "ko": f"{driver_list(nums)}에서 오른쪽부터 오른쪽 이웃보다 작은 첫 ID를 찾습니다. 마지막 ID인 {nums[-1]}번 "
                 f"하나는 그 자체로 내려가는 꼬리입니다."})
    while i >= 0 and nums[i] >= nums[i + 1]:
        tail_from = i
        frame({"en": f"shotOrder[{i}] = {nums[i]} ≥ shotOrder[{i + 1}] = {nums[i + 1]}: the tail still only "
                     f"falls, and a falling tail has no bigger arrangement. Move i left.",
               "ko": f"shotOrder[{i}] = {nums[i]} ≥ shotOrder[{i + 1}] = {nums[i + 1]}: 꼬리는 여전히 내려가기만 "
                     f"하고, 내려가는 꼬리는 더 크게 배치할 수 없습니다. i를 왼쪽으로 옮깁니다."},
              lit=[i, i + 1])
        i -= 1
    if i >= 0:
        frame({"en": f"shotOrder[{i}] = {nums[i]} < shotOrder[{i + 1}] = {nums[i + 1]}: index {i} is the rightmost "
                     f"place that can grow. Now find the id from the tail to put there.",
               "ko": f"shotOrder[{i}] = {nums[i]} < shotOrder[{i + 1}] = {nums[i + 1]}: 인덱스 {i}의 자리가 "
                     f"커질 수 있는 가장 오른쪽 자리입니다. 이제 꼬리에서 이 자리에 올 ID를 찾습니다."},
              lit=[i, i + 1])
        j = n - 1
        while nums[j] <= nums[i]:
            frame({"en": f"shotOrder[{j}] = {nums[j]} ≤ {nums[i]}: not bigger, so j moves left.",
                   "ko": f"shotOrder[{j}] = {nums[j]} ≤ {nums[i]}: 더 크지 않으니 j를 왼쪽으로 옮깁니다."},
                  lit=[i, j])
            j -= 1
        frame({"en": f"shotOrder[{j}] = {nums[j]} > {nums[i]}: the rightmost bigger id. The tail falls, so it "
                     f"is also the smallest id in the tail bigger than {nums[i]}.",
               "ko": f"shotOrder[{j}] = {nums[j]} > {nums[i]}: 더 큰 ID 중 가장 오른쪽입니다. 꼬리가 내려가므로 "
                     f"꼬리에서 {nums[i]}보다 큰 ID 중 가장 작은 ID이기도 합니다."},
              lit=[i, j])
        a, b = nums[i], nums[j]
        nums[i], nums[j] = nums[j], nums[i]
        frame({"en": f"Swap them: index {i} grows from {a} to {b}, the smallest step up. The tail still falls.",
               "ko": f"둘을 맞바꾸면 인덱스 {i}의 ID가 {a}번에서 {b}번으로, 가장 작은 폭으로 커집니다. "
               f"꼬리는 여전히 내려갑니다."},
              good=[i, j])
        j = None
    else:
        frame({"en": "i ran past the left end: the whole lineup only falls, so it is already the largest "
                     "arrangement. It resets to the smallest.",
               "ko": "i가 왼쪽 끝을 지났습니다. 라인업 전체가 내려가기만 하니 이미 가장 큰 순열이고, 가장 작은 "
                     "순열로 초기화됩니다."})
    start = i + 1
    nums[start:] = reversed(nums[start:])
    tail_from = n
    answer = driver_list(nums)
    if i >= 0:
        frame({"en": f"Reverse the tail from index {start}: falling becomes rising, its smallest arrangement. "
                     f"The next lineup is {answer}.",
               "ko": f"인덱스 {start}부터의 꼬리를 뒤집으면 내려가던 꼬리가 올라가는, 가장 작은 배치가 됩니다. "
                     f"다음 라인업은 {answer}입니다."},
              good=range(start, n), path=[i], answer=answer)
    else:
        frame({"en": f"Reverse the whole lineup: falling becomes rising, the smallest arrangement. "
                     f"The lineup resets to {answer}.",
               "ko": f"라인업 전체를 뒤집으면 내려가던 순서가 올라가는, 가장 작은 순열이 됩니다. "
               f"초기화된 라인업은 {answer}입니다."},
              path=range(n), answer=answer)


for number, sample in enumerate(sample_cases(SLUG), start=1):
    order = json.loads(sample["input"])
    run = sample_run(wt, number, sample, input=f"shotOrder = {driver_list(order)}")
    solve(order, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
