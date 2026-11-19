#!/usr/bin/env python3.12
"""zero-sum-trio's Walkthrough: the reference solution (scripts/replay-solutions/zero-sum-trio.py), deltas
sorted, then each value i fixed in turn while two pointers walk in from both ends of what follows it,
recording one frame per sum taken and one per repeat skipped on each sample Test Case. The three values move
into the sum box, where it is compared with 0; a trio that hits 0 moves into the answer, and a value equal to
the one just used is stepped over so no trio is listed twice.

    CODEBITE_DB=<database> scripts/walkthroughs/zero-sum-trio.py

writes common/src/main/resources/walkthroughs/zero-sum-trio.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import driver_list, josa, plural, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move, span  # noqa: E402

SLUG = "zero-sum-trio"

wt = Walkthrough(
    {"en": "Zero Sum Trio", "ko": "합이 0인 삼인방"},
    {"en": "Sort first. Then fix each value i in turn and find the pairs after it that cancel it with two "
           "pointers from both ends: a sum below 0 moves left up, above 0 moves right down. Stepping over a value "
           "equal to the one just used keeps every trio listed once.",
     "ko": "먼저 정렬합니다. 그다음 값 i를 하나씩 고정하고, 그 뒤에서 i를 상쇄하는 짝을 양 끝의 두 포인터로 찾습니다. "
           "합이 0보다 작으면 left를 올리고, 크면 right를 내립니다. 방금 쓴 값과 같은 값은 건너뛰어 같은 삼인방을 "
           "한 번만 셉니다."},
    views=[
        {"id": "nums", "type": "array", "title": {"en": "nums (deltas sorted)", "ko": "nums (정렬한 deltas)"}},
        {"id": "sum", "type": "output", "title": {"en": "i + left + right vs 0", "ko": "i + left + right (합) vs 0"},
         "empty": {"en": "nothing added yet", "ko": "아직 없음"}},
        {"id": "trios", "type": "output", "title": {"en": "trios found", "ko": "찾은 삼인방"},
         "empty": {"en": "none yet", "ko": "아직 없음"}},
    ],
)


def solve(deltas, run):
    """Solution.zeroSumTrios with a frame per sum and per repeat skipped. Returns the answer as the Driver prints it."""
    nums = sorted(deltas)
    n = len(nums)
    trios = []
    i = left = right = None
    chip = None  # the sum box's chip

    def frame(caption, lit=(), bad=(), good=(), path=(), sum_mark=None, trio_mark=None, moves=None, done=False,
              **answer):
        spans = {}
        if left is not None and left < right and not done:
            spans["pair"] = span(left, right, {"en": "left..right", "ko": "left..right"})
        dim = list(range(i)) if i is not None and not done else []
        run.frame(caption,
                  nums={"values": nums, "spans": spans,
                        "pointers": {} if done or i is None else
                        {"i": i, "left": left if left is not None and left < n else None,
                         "right": right if right is not None and right != left else None},
                        "marks": {"dim": dim, "path": list(path), "bad": list(bad), "good": list(good),
                                  "lit": list(lit)}},
                  sum={"values": [] if chip is None else [chip],
                       "marks": {sum_mark: [0]} if sum_mark and chip else {}},
                  trios={"values": [driver_list(t) for t in trios],
                         "marks": {"path": list(range(len(trios)))} if done else
                         {trio_mark: [len(trios) - 1]} if trio_mark else {}},
                  moves=moves, **answer)

    frame({"en": f"deltas sorted: {driver_list(nums)}. Sorted, a sum can be steered: moving left up raises it, "
                 f"moving right down lowers it.",
           "ko": f"deltas를 정렬하면 {driver_list(nums)}입니다. 정렬되어 있으니 left를 올리면 합이 커지고, "
                 f"right를 내리면 작아집니다."})
    for i in range(n - 2):
        if i > 0 and nums[i] == nums[i - 1]:
            left = right = None
            frame({"en": f"i = {i}: nums[{i}] = {nums[i]} is the value i just had, so every trio it starts "
                         f"was already found. Skip it.",
                   "ko": f"i = {i}: nums[{i}] = {josa(nums[i], '은는')} 직전 i와 같은 값이라, 이 값으로 "
                         f"시작하는 삼인방은 이미 다 찾았습니다. 건너뜁니다."},
                  bad=[i])
            continue
        left, right = i + 1, n - 1
        lead_en = f"i = {i} fixes {nums[i]}, with left = {left} and right = {right}. "
        lead_ko = f"i = {i}({nums[i]} 고정), left = {left}, right = {right}. "
        while left < right:
            a, b, c = nums[i], nums[left], nums[right]
            total = a + b + c
            sign = "<" if total < 0 else ">" if total > 0 else "="
            chip = f"{total} {sign} 0"
            adds = [move(at("nums", j), at("sum", 0), value=nums[j], mark="good") for j in (i, left, right)]
            said = f"{a} + {b} + {c} = {total}"
            if total < 0:
                frame({"en": f"{lead_en}{said} < 0: too small, so left moves up.",
                       "ko": f"{lead_ko}{said} < 0, 너무 작으므로 left를 올립니다."},
                      lit=[i, left, right], moves=adds)
                left += 1
            elif total > 0:
                frame({"en": f"{lead_en}{said} > 0: too big, so right moves down.",
                       "ko": f"{lead_ko}{said} > 0, 너무 크므로 right를 내립니다."},
                      lit=[i, left, right], moves=adds)
                right -= 1
            else:
                trios.append([a, b, c])
                frame({"en": f"{lead_en}{said}, a trio: [{a},{b},{c}] joins the answer, and both left and "
                             f"right move inward.",
                       "ko": f"{lead_ko}{said}, 합이 {josa(0, '이가')} 되었으므로 [{a},{b},{c}] 삼인방을 답에 넣고 left와 right를 "
                             f"모두 안쪽으로 옮깁니다."},
                      good=[i, left, right], sum_mark="good", trio_mark="good",
                      moves=adds + [move(at("nums", j), at("trios", len(trios) - 1), value=nums[j])
                                    for j in (i, left, right)])
                left += 1
                skipped = []
                while left < right and nums[left] == nums[left - 1]:
                    skipped.append(left)
                    left += 1
                right -= 1
                if skipped:
                    where = (f"nums[{skipped[0]}]" if len(skipped) == 1 else f"nums[{skipped[0]}..{skipped[-1]}]")
                    frame({"en": f"{where} is another {b}, the value left just used: the same trio would come back, "
                                 f"so left steps over it to {left}."
                                 f"{' Now left has passed right, which moved down to ' + str(right) + '.' if left > right else ''}",
                           "ko": f"{where}의 값도 방금 left가 쓴 값과 같아 같은 삼인방이 다시 나오므로, left가 "
                                 f"건너뛰어 {left}번으로 갑니다."
                                 f"{' 이제 left가 ' + str(right) + '번으로 내려온 right를 지나쳤습니다.' if left > right else ''}"},
                          bad=skipped)
            lead_en = lead_ko = ""
    left = right = None
    result = sorted(sorted(t) for t in trios)
    if trios:
        caption = {"en": f"i has no two values after it left: {len(trios)} {plural(len(trios), 'trio', 'trios')} "
                         f"sum to 0, {driver_list(result)}.",
                   "ko": f"i 뒤에 값이 두 개 남지 않아 끝났습니다. 합이 0인 삼인방은 {len(trios)}개, "
                         f"{driver_list(result)}입니다."}
    else:
        caption = {"en": "i has no two values after it left, and no sum ever hit 0: the answer is [].",
                   "ko": "i 뒤에 값이 두 개 남지 않아 끝났고, 합이 0이 된 적이 없어 답은 []입니다."}
    frame(caption, done=True, answer=driver_list(result))


for number, sample in enumerate(sample_cases(SLUG), start=1):
    deltas = json.loads(sample["input"])
    run = sample_run(wt, number, sample, input=f"deltas = {sample['input'].strip()}")
    solve(deltas, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
