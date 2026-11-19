#!/usr/bin/env python3.12
"""sort-latte-squared's Walkthrough: the reference solution (scripts/replay-solutions/sort-latte-squared.py),
two pointers at the ends of drifts and a slot walking result from the back, recording one frame per slot
filled on each sample Test Case. The biggest square is always at one of the two ends, so whichever end is
further from 0 has its square move into the slot, and that pointer moves in. The drifts still to place are a
span between the pointers.

    CODEBITE_DB=<database> scripts/walkthroughs/sort-latte-squared.py

writes common/src/main/resources/walkthroughs/sort-latte-squared.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import driver_list, josa, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move, span  # noqa: E402

SLUG = "sort-latte-squared"

wt = Walkthrough(
    {"en": "Sort Latte Squared", "ko": "라떼 온도 편차 정렬"},
    {"en": "In a sorted array the biggest square sits at one of the two ends, the one further from 0. So fill "
           "result from the back: each step the larger end's square takes the last free slot, and that end moves in.",
     "ko": "정렬된 배열에서 가장 큰 제곱은 양 끝 중 0에서 더 먼 쪽에 있습니다. 그래서 result를 뒤에서부터 채웁니다. "
           "매번 더 큰 쪽 끝의 제곱이 남은 마지막 칸에 들어가고, 그쪽 포인터가 안으로 옵니다."},
    views=[
        {"id": "drifts", "type": "array", "title": "drifts"},
        {"id": "result", "type": "array", "title": {"en": "result", "ko": "result (결과)"}},
    ],
)


def solve(drifts, run):
    """Solution.sortedSquaredDrifts with a frame per slot filled. Returns the answer as the Driver prints it."""
    n = len(drifts)
    result = [""] * n
    left, right = 0, n - 1
    slot = None

    def frame(caption, lit=(), good=(), moves=None, done=False, **answer):
        live = left <= right and not done
        filled_from = n if slot is None else slot
        run.frame(caption,
                  drifts={"values": drifts,
                          "spans": {"left": span(left, right, {"en": "to place", "ko": "남은 값"}, fade=True)
                                    if live else None},
                          "pointers": {"left": left if live else None,
                                       "right": right if live and right != left else None},
                          "marks": {"lit": list(lit)}},
                  result={"values": result, "unread": list(range(filled_from)),
                          "pointers": {} if done or slot is None else {"slot": slot},
                          "marks": {"path": list(range(n))} if done else {"good": list(good)}},
                  moves=moves, **answer)

    frame({"en": f"{n} drifts, sorted. result has {n} empty slots, filled from the back; left and right start at "
                 f"the two ends of drifts.",
           "ko": f"정렬된 drifts {n}개입니다. result의 빈칸 {n}개를 뒤에서부터 채우며, left와 right는 drifts의 "
                 f"양 끝에서 시작합니다."})
    for slot in range(n - 1, -1, -1):
        a, b = drifts[left], drifts[right]
        if abs(a) > abs(b):
            i, side, why_en, why_ko = left, "left", f"|{a}| > |{b}|", f"|{a}| > |{b}|"
        else:
            i, side = right, "right"
            why_en = f"|{b}| ≥ |{a}|" if abs(a) != abs(b) else f"|{a}| = |{b}|, a tie that right takes"
            why_ko = f"|{b}| ≥ |{a}|" if abs(a) != abs(b) else f"|{a}| = |{b}|(같으면 right)"
        v = drifts[i]
        sq = f"({v})²" if v < 0 else f"{v}²"
        result[slot] = v * v
        same = left == right
        if same:
            caption = {"en": f"Only drifts[{i}] = {v} is left: {sq} = {v * v} takes the first slot.",
                       "ko": f"drifts[{i}] = {v} 하나만 남았습니다. {sq} = {josa(v * v, '이가')} 첫 칸에 들어갑니다."}
        else:
            caption = {"en": f"{why_en}, so the {side} end is further from 0: {sq} = {v * v} is the biggest square "
                             f"left and takes slot {slot}. {side} moves in.",
                       "ko": f"{why_ko}, {side} 쪽이 0에서 더 멉니다. {sq} = {josa(v * v, '이가')} 남은 제곱 중 가장 커서 "
                             f"{slot}번 칸에 들어가고, {side} 포인터가 안으로 옵니다."}
        frame(caption, lit=[left, right] if not same else [i], good=[slot],
              moves=[move(at("drifts", i), at("result", slot), value=f"{v * v}")])
        if i == left:
            left += 1
        else:
            right -= 1
    frame({"en": f"Every slot is filled, smallest square first: {driver_list(result)}.",
           "ko": f"모든 칸이 채워져 제곱이 작은 것부터 놓였습니다: {driver_list(result)}."},
          done=True, answer=driver_list(result))


for number, sample in enumerate(sample_cases(SLUG), start=1):
    drifts = json.loads(sample["input"])
    run = sample_run(wt, number, sample, input=f"drifts = {sample['input'].strip()}")
    solve(drifts, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
