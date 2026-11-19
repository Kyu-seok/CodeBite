#!/usr/bin/env python3.12
"""four-tray-sum's Walkthrough: the reference solution (scripts/replay-solutions/four-tray-sum.py), trays
sorted, then each pair of values a, b fixed in turn while two pointers low and high walk in from both ends of
what follows b, recording one frame per sum taken and one per repeat skipped on each sample Test Case. The four
values move into the sum box, where it is compared with demand; a quadruplet that hits it moves into the answer,
and a value equal to the one just used is stepped over so no quadruplet is listed twice.

    CODEBITE_DB=<database> scripts/walkthroughs/four-tray-sum.py

writes common/src/main/resources/walkthroughs/four-tray-sum.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import driver_list, josa, plural, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move, span  # noqa: E402

SLUG = "four-tray-sum"

wt = Walkthrough(
    {"en": "Four Tray Sum", "ko": "네 트레이 합 맞추기"},
    {"en": "Sort first. Fix two values a and b, then find the pairs after b that make up the rest with two pointers "
           "from both ends: a sum below demand moves low up, above it moves high down. Stepping over a value equal "
           "to the one just used at the same place keeps every quadruplet listed once.",
     "ko": "먼저 정렬합니다. 두 값 a, b를 고정하고, b 뒤에서 나머지를 채우는 짝을 양 끝의 두 포인터로 찾습니다. "
           "합이 demand보다 작으면 low를 올리고, 크면 high를 내립니다. 같은 자리에서 방금 쓴 값과 같은 값은 "
           "건너뛰어 같은 조합을 한 번만 셉니다."},
    views=[
        {"id": "nums", "type": "array", "title": {"en": "nums (trays sorted)", "ko": "nums (정렬한 trays)"}},
        {"id": "sum", "type": "output",
         "title": {"en": "a + b + low + high vs demand", "ko": "a + b + low + high (합) vs demand"},
         "empty": {"en": "nothing added yet", "ko": "아직 없음"}},
        {"id": "quads", "type": "output", "title": {"en": "quadruplets found", "ko": "찾은 조합"},
         "empty": {"en": "none yet", "ko": "아직 없음"}},
        {"id": "state", "type": "vars"},
    ],
)


def solve(trays, demand, run):
    """Solution.fourTraySum with a frame per sum and per repeat skipped. Returns the answer as the Driver prints it."""
    nums = sorted(trays)
    n = len(nums)
    quads = []
    a = b = low = high = None
    chip = None  # the sum box's chip

    def frame(caption, lit=(), bad=(), good=(), sum_mark=None, quad_mark=None, moves=None, done=False, **answer):
        spans = {}
        if low is not None and low < high and not done:
            spans["pair"] = span(low, high, {"en": "low..high", "ko": "low..high"})
        dim = [] if done or a is None else list(range(a)) if b is None else [j for j in range(b) if j != a]
        pointers = {}
        if not done and a is not None:
            pointers = {"a": a, "b": b,
                        "low": low if low is not None and low < n else None,
                        "high": high if high is not None and high != low else None}
        run.frame(caption,
                  nums={"values": nums, "spans": spans, "pointers": pointers,
                        "marks": {"dim": dim, "bad": list(bad), "good": list(good), "lit": list(lit)}},
                  sum={"values": [] if chip is None else [chip],
                       "marks": {sum_mark: [0]} if sum_mark and chip else {}},
                  quads={"values": [driver_list(q) for q in quads],
                         "marks": {"path": list(range(len(quads)))} if done else
                         {quad_mark: [len(quads) - 1]} if quad_mark else {}},
                  state={"items": [{"label": {"en": "demand", "ko": "demand (요구량)"}, "value": demand}]},
                  moves=moves, **answer)

    frame({"en": f"trays sorted: {driver_list(nums)}. Sorted, a sum can be steered: moving low up raises it, "
                 f"moving high down lowers it.",
           "ko": f"trays를 정렬하면 {driver_list(nums)}입니다. 정렬되어 있으니 low를 올리면 합이 커지고, "
                 f"high를 내리면 작아집니다."})
    for a in range(n - 3):
        if a > 0 and nums[a] == nums[a - 1]:
            b = low = high = None
            frame({"en": f"a = {a}: nums[{a}] = {nums[a]} is the value a just had, so every quadruplet it starts "
                         f"was already found. Skip it.",
                   "ko": f"a = {a}: nums[{a}] = {josa(nums[a], '은는')} 직전 a와 같은 값이라, 이 값으로 시작하는 "
                         f"조합은 이미 다 찾았습니다. 건너뜁니다."},
                  bad=[a])
            continue
        for b in range(a + 1, n - 2):
            if b > a + 1 and nums[b] == nums[b - 1]:
                low = high = None
                frame({"en": f"b = {b}: nums[{b}] = {nums[b]} is the value b just had with this a, so it would only "
                             f"repeat quadruplets. Skip it.",
                       "ko": f"b = {b}: nums[{b}] = {josa(nums[b], '은는')} 이 a에서 직전 b와 같은 값이라 같은 조합만 "
                             f"반복됩니다. 건너뜁니다."},
                      bad=[b])
                continue
            low, high = b + 1, n - 1
            lead_en = f"a = {a} and b = {b} fix {nums[a]} and {nums[b]}, with low = {low} and high = {high}. "
            lead_ko = f"a = {a}, b = {b}({nums[a]}, {nums[b]} 고정), low = {low}, high = {high}. "
            while low < high:
                four = [nums[a], nums[b], nums[low], nums[high]]
                total = sum(four)
                sign = "<" if total < demand else ">" if total > demand else "="
                chip = f"{total} {sign} {demand}"
                adds = [move(at("nums", j), at("sum", 0), value=nums[j], mark="good") for j in (a, b, low, high)]
                said = " + ".join(str(v) for v in four) + f" = {total}"
                if total < demand:
                    frame({"en": f"{lead_en}{said} < {demand}: too small, so low moves up.",
                           "ko": f"{lead_ko}{said} < {demand}, 너무 작으므로 low를 올립니다."},
                          lit=[a, b, low, high], moves=adds)
                    low += 1
                elif total > demand:
                    frame({"en": f"{lead_en}{said} > {demand}: too big, so high moves down.",
                           "ko": f"{lead_ko}{said} > {demand}, 너무 크므로 high를 내립니다."},
                          lit=[a, b, low, high], moves=adds)
                    high -= 1
                else:
                    quads.append(four)
                    frame({"en": f"{lead_en}{said}, the demand: {driver_list(four)} joins the answer, and both low "
                                 f"and high move inward.",
                           "ko": f"{lead_ko}{said}, demand와 같으므로 {driver_list(four)} 조합을 답에 넣고 low와 "
                                 f"high를 모두 안쪽으로 옮깁니다."},
                          good=[a, b, low, high], sum_mark="good", quad_mark="good",
                          moves=adds + [move(at("nums", j), at("quads", len(quads) - 1), value=nums[j])
                                        for j in (a, b, low, high)])
                    low += 1
                    skipped = []
                    while low < high and nums[low] == nums[low - 1]:
                        skipped.append(low)
                        low += 1
                    high -= 1
                    if skipped:
                        where = f"nums[{skipped[0]}]" if len(skipped) == 1 else f"nums[{skipped[0]}..{skipped[-1]}]"
                        crossed = low > high
                        frame({"en": f"{where} is another {four[2]}, the value low just used: the same quadruplet "
                                     f"would come back, so low steps over it to {low}."
                                     f"{f' Now low has passed high, which moved down to {high}.' if crossed else ''}",
                               "ko": f"{where}의 값도 방금 low가 쓴 값과 같아 같은 조합이 다시 나오므로, low가 "
                                     f"건너뛰어 {low}번으로 갑니다."
                                     f"{f' 이제 low가 {high}번으로 내려온 high를 지나쳤습니다.' if crossed else ''}"},
                              bad=skipped)
                lead_en = lead_ko = ""
    b = low = high = None
    result = sorted(sorted(q) for q in quads)
    if quads:
        caption = {"en": f"Every a and b was tried: {len(quads)} {plural(len(quads), 'quadruplet sums', 'quadruplets sum')} "
                         f"to {demand}, {driver_list(result)}.",
                   "ko": f"모든 a, b를 다 해 봤습니다. 합이 {josa(demand, '이가')} 되는 조합은 {len(quads)}개, "
                         f"{driver_list(result)}입니다."}
    else:
        caption = {"en": f"Every a and b was tried, and no sum ever hit {demand}: the answer is [].",
                   "ko": f"모든 a, b를 다 해 봤지만 합이 {josa(demand, '이가')} 된 적이 없어 답은 []입니다."}
    frame(caption, done=True, answer=driver_list(result))


for number, sample in enumerate(sample_cases(SLUG), start=1):
    lines = sample["input"].split("\n")
    trays, demand = json.loads(lines[0]), int(lines[1])
    run = sample_run(wt, number, sample, input=f"trays = {lines[0].strip()}, demand = {demand}")
    solve(trays, demand, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
