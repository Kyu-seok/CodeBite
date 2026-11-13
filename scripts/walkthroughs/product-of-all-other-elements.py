#!/usr/bin/env python3.12
"""product-of-all-other-elements' Walkthrough: the reference solution
(scripts/replay-solutions/product-of-all-other-elements.py), a left-to-right pass writing each position's
prefix product and a right-to-left pass multiplying in its suffix product, one frame per position per pass
on each sample Test Case. The running product is a span over the nums it multiplies, labelled with its value, and
moves from the span's nearest cell into answer[i].

    CODEBITE_DB=<database> scripts/walkthroughs/product-of-all-other-elements.py

writes common/src/main/resources/walkthroughs/product-of-all-other-elements.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import driver_list, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move, span  # noqa: E402

SLUG = "product-of-all-other-elements"

wt = Walkthrough(
    {"en": "Product of All Other Elements", "ko": "자기 자신을 제외한 모든 원소의 곱"},
    {"en": "answer[i] is the product of everything left of i times the product of everything right of i: "
           "one pass left to right writes the left products, one pass right to left multiplies in the right ones.",
     "ko": "answer[i]는 i 왼쪽 원소들의 곱 × i 오른쪽 원소들의 곱입니다. 왼쪽에서 오른쪽으로 한 번 훑으며 "
           "왼쪽 곱을 적고, 오른쪽에서 왼쪽으로 한 번 더 훑으며 오른쪽 곱을 곱해 넣습니다."},
    views=[
        {"id": "nums", "type": "array", "title": {"en": "nums", "ko": "nums"}},
        {"id": "result", "type": "array", "title": {"en": "answer", "ko": "answer"}},
    ],
)


def product_text(values):
    """'2 × 3 × 5', with negatives in parentheses."""
    return " × ".join(f"({v})" if v < 0 else str(v) for v in values)


def solve(nums, run):
    """Solution.productOfAllOtherElements with a frame per position in each pass.
    Returns the answer as the Driver prints it."""
    n = len(nums)
    result = [1] * n
    written = [False] * n  # positions the first pass has reached, so unwritten ones show blank
    prefix = suffix = 1

    def frame(caption, at_i=None, side=None, good=(), path=(), moves=None, **answer):
        """side: the running product this step uses, ("prefix", value) over nums[0..i-1] or ("suffix", value)
        over nums[i+1..n-1]; it is a span only when it covers a cell."""
        spans = {}
        if side and side[0] == "prefix" and at_i > 0:
            spans["prefix"] = span(0, at_i - 1, f"prefix = {side[1]}")
        if side and side[0] == "suffix" and at_i < n - 1:
            spans["suffix"] = span(at_i + 1, n - 1, f"suffix = {side[1]}")
        run.frame(caption,
                  nums={"values": nums, "pointers": {"i": at_i}, "spans": spans},
                  result={"values": [v if w else "" for v, w in zip(result, written)], "pointers": {"i": at_i},
                          "marks": {"good": list(good), "path": list(path)}},
                  moves=moves, **answer)

    frame({"en": "Without division, answer[i] is (product of everything left of i) × (product of everything "
                 "right of i). First pass: walk left to right, carrying the left product in prefix, which starts at 1.",
           "ko": "나눗셈 없이, answer[i]는 (i 왼쪽 원소들의 곱) × (i 오른쪽 원소들의 곱)입니다. 첫 번째 단계는 "
                 "왼쪽에서 오른쪽으로 훑으며 왼쪽 곱을 prefix에 들고 가는데, prefix는 1에서 시작합니다."})
    for i in range(n):
        result[i] = prefix
        written[i] = True
        left = product_text(nums[:i])
        old = prefix
        prefix *= nums[i]
        if i == 0:
            en = f"Nothing is left of index 0, so answer[0] = prefix = 1."
            ko = f"인덱스 0의 왼쪽에는 아무것도 없으므로 answer[0] = prefix = 1입니다."
        else:
            en = f"answer[{i}] = prefix = {left} = {old}, the product of everything left of index {i}."
            ko = f"answer[{i}] = prefix = {left} = {old}, 인덱스 {i} 왼쪽 원소들의 곱입니다."
        en += f" Then prefix takes in nums[{i}]: {old} × {product_text([nums[i]])} = {prefix}."
        ko += f" 그다음 prefix에 nums[{i}]의 값을 곱합니다: {old} × {product_text([nums[i]])} = {prefix}."
        flow = move(at("nums", i - 1) if i > 0 else None, at("result", i), value=old)
        frame({"en": en, "ko": ko}, at_i=i, side=("prefix", old), good=[i], moves=[flow])
    frame({"en": "Every answer[i] now holds its left product. Second pass: walk right to left, carrying the "
                 "right product in suffix, which starts at 1, and multiply it in.",
           "ko": "이제 모든 answer[i]에 왼쪽 곱이 들어 있습니다. 두 번째 단계는 오른쪽에서 왼쪽으로 훑으며 "
                 "1에서 시작하는 suffix에 오른쪽 곱을 들고 가서 곱해 넣습니다."})
    for i in range(n - 1, -1, -1):
        old_answer = result[i]
        result[i] *= suffix
        old = suffix
        suffix *= nums[i]
        right = product_text(nums[i + 1:])
        if i == n - 1:
            en = (f"Nothing is right of index {i}, so suffix = 1 and answer[{i}] stays "
                  f"{old_answer} × 1 = {result[i]}.")
            ko = (f"인덱스 {i}의 오른쪽에는 아무것도 없어 suffix = 1이므로 answer[{i}] = "
                  f"{old_answer} × 1 = {result[i]} 그대로입니다.")
        else:
            en = (f"suffix = {right} = {old}, the product of everything right of index {i}: "
                  f"answer[{i}] = {old_answer} × {product_text([old])} = {result[i]}.")
            ko = (f"suffix = {right} = {old}, 인덱스 {i} 오른쪽 원소들의 곱입니다: "
                  f"answer[{i}] = {old_answer} × {product_text([old])} = {result[i]}.")
        en += f" Then suffix takes in nums[{i}]: {old} × {product_text([nums[i]])} = {suffix}."
        ko += f" 그다음 suffix에 nums[{i}]의 값을 곱합니다: {old} × {product_text([nums[i]])} = {suffix}."
        flow = move(at("nums", i + 1) if i < n - 1 else None, at("result", i), value=f"×{product_text([old])}")
        frame({"en": en, "ko": ko}, at_i=i, side=("suffix", old), good=[i], moves=[flow])
    answer = driver_list(result)
    frame({"en": f"Both passes are done: each answer[i] is its left product times its right product, "
                 f"with nums[i] itself never multiplied in. Answer {answer}.",
           "ko": f"두 단계가 끝나 각 answer[i]는 왼쪽 곱 × 오른쪽 곱이고, nums[i] 자신은 한 번도 곱해지지 "
                 f"않았습니다. 답은 {answer}입니다."},
          path=range(n), answer=answer)
    return answer


for number, sample in enumerate(sample_cases(SLUG), start=1):
    nums = json.loads(sample["input"])
    run = sample_run(wt, number, sample, input=f"nums = {sample['input']}")
    solve(nums, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
