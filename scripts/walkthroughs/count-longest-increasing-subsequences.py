#!/usr/bin/env python3.12
"""count-longest-increasing-subsequences' Walkthrough: the reference solution
(scripts/replay-solutions/count-longest-increasing-subsequences.py), two tables over the indexes, the longest
increasing run ending at each index and how many runs reach it, recording one frame per pair (j, i) with
nums[j] < nums[i] on each sample Test Case.

The pairs where nums[j] is not smaller change nothing and get no frame of their own: in each frame the cells
before i that are not smaller than nums[i] are dimmed, and an index with no smaller value before it gets one frame
saying so. A longer run moves length[j] + 1 into length[i] and copies count[j]; an equal one adds count[j] into
count[i]. The last frame marks the indexes holding the longest length and moves each one's count into the
answer.

    CODEBITE_DB=<database> scripts/walkthroughs/count-longest-increasing-subsequences.py

writes common/src/main/resources/walkthroughs/count-longest-increasing-subsequences.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import josa, plural, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move  # noqa: E402

SLUG = "count-longest-increasing-subsequences"

wt = Walkthrough(
    {"en": "Count Longest Increasing Subsequences", "ko": "가장 긴 증가 부분수열의 개수"},
    {"en": "For each index keep the longest increasing subsequence ending there and how many reach that length. "
           "Every smaller value before it can come just before it: a longer run replaces the count, an equal one "
           "adds to it.",
     "ko": "인덱스마다 그곳에서 끝나는 가장 긴 증가 부분수열의 길이와, 그 길이인 부분수열의 개수를 둡니다. 앞에 있는 "
           "더 작은 값은 모두 바로 앞에 올 수 있습니다. 더 길면 개수를 바꾸고, 같으면 개수를 더합니다."},
    views=[
        {"id": "nums", "type": "array", "title": "nums"},
        {"id": "length", "type": "array",
         "title": {"en": "length: longest ending here", "ko": "length (여기서 끝나는 최장 길이)"}},
        {"id": "count", "type": "array",
         "title": {"en": "count: how many reach it", "ko": "count (그 길이인 부분수열 수)"}},
        {"id": "result", "type": "output", "title": {"en": "answer", "ko": "답"}, "empty": {"en": "none yet", "ko": "아직 없음"}},
    ],
)


def solve(nums, run):
    """Solution.countLongestIncreasing with a frame per pair it compares with a smaller value."""
    n = len(nums)
    length = [1] * n
    count = [1] * n

    def frame(caption, i=None, j=None, nums_marks=None, length_marks=None, count_marks=None, result=(),
              moves=None, **answer):
        unread = list(range(i + 1, n)) if i is not None else ([] if answer else list(range(n)))
        tables = {"unread": unread}
        run.frame(caption,
                  nums={"values": nums, "pointers": {"j": j, "i": i}, "marks": nums_marks or {}, "unread": unread},
                  length={"values": list(length), "marks": length_marks or {}, **tables},
                  count={"values": list(count), "marks": count_marks or {}, **tables},
                  result={"values": list(result), "marks": {"good": [0]} if result else {}},
                  moves=moves, **answer)

    frame({"en": f"{n} numbers. On its own, each index is an increasing subsequence of length 1, and there is 1 of "
                 "it, so every length and count starts at 1.",
           "ko": f"수가 {n}개입니다. 각 인덱스 하나만으로 길이 1인 증가 부분수열이 1개 있으므로, length와 count는 모두 "
                 "1에서 시작합니다."})
    for i in range(n):
        not_smaller = [j for j in range(i) if nums[j] >= nums[i]]
        smaller = [j for j in range(i) if nums[j] < nums[i]]
        if not smaller:
            if i == 0:
                en = f"Index 0 ({nums[0]}) has nothing before it: length 1, count 1."
                ko = f"인덱스 0({nums[0]}) 앞에는 아무것도 없습니다: 길이 1, 개수 1."
            else:
                en = (f"No value before index {i} is smaller than {nums[i]}, so nothing can come before it: "
                      "it stays length 1, count 1.")
                ko = (f"인덱스 {i} 앞에 {nums[i]}보다 작은 값이 없어 앞에 올 수 있는 것이 없습니다: 길이 1, "
                      "개수 1 그대로입니다.")
            frame({"en": en, "ko": ko}, i=i, nums_marks={"lit": [i], "dim": not_smaller},
                  length_marks={"lit": [i]}, count_marks={"lit": [i]})
            continue
        for j in smaller:
            lj, cj, li, ci = length[j], count[j], length[i], count[i]
            head_en = f"nums[{j}] = {nums[j]} < nums[{i}] = {nums[i]}, so {nums[i]} can follow runs ending at index {j}"
            head_ko = (f"nums[{j}] = {nums[j]} < nums[{i}] = {nums[i]}: 인덱스 {j}에서 끝나는 부분수열 뒤에 "
                       f"nums[{i}] 값을 붙일 수 있습니다")
            if lj + 1 > li:
                length[i], count[i] = lj + 1, cj
                frame({"en": f"{head_en}: length {lj} + 1 = {lj + 1}, longer than {li}. Length becomes {lj + 1}, "
                             f"and its {cj} {plural(cj, 'way replaces', 'ways replace')} the count.",
                       "ko": f"{head_ko}. 길이 {lj} + 1 = {josa(lj + 1, '은는')} {li}보다 길어 length는 {lj + 1}, "
                             f"count는 그 개수 {josa(cj, '(으)로')} 바뀝니다."},
                      i=i, j=j, nums_marks={"lit": [j, i], "dim": not_smaller},
                      length_marks={"lit": [j], "good": [i]}, count_marks={"lit": [j], "good": [i]},
                      moves=[move(at("length", j), at("length", i), value=f"{lj}+1"),
                             move(at("count", j), at("count", i), value=str(cj))])
            elif lj + 1 == li:
                count[i] += cj
                frame({"en": f"{head_en}: length {lj} + 1 = {li}, the same as now, so these runs are more ways to "
                             f"reach it. Count becomes {ci} + {cj} = {count[i]}.",
                       "ko": f"{head_ko}. 길이 {lj} + 1 = {josa(li, '(으)로')} 지금과"
                             f" 같아 그 길이를 만드는 방법이 늘어나므로 count는 {ci} + {cj} = "
                             f"{josa(count[i], '이가')} 됩니다."},
                      i=i, j=j, nums_marks={"lit": [j, i], "dim": not_smaller},
                      length_marks={"lit": [j, i]}, count_marks={"lit": [j], "good": [i]},
                      moves=[move(at("count", j), at("count", i), value=f"+{cj}")])
            else:
                frame({"en": f"{head_en}, but that gives length {lj} + 1 = {lj + 1}, shorter than {li}. "
                             "Nothing changes.",
                       "ko": f"{head_ko}. 하지만 길이 {lj} + 1 = {josa(lj + 1, '이가')} {li}보다 짧아 바뀌는 것이 "
                             "없습니다."},
                      i=i, j=j, nums_marks={"lit": [j, i], "dim": not_smaller},
                      length_marks={"lit": [j, i]}, count_marks={"lit": [j]})
    longest = max(length)
    ends = [k for k in range(n) if length[k] == longest]
    total = sum(count[k] for k in ends)
    parts = " + ".join(str(count[k]) for k in ends)
    where_en = ", ".join(map(str, ends))
    if len(ends) > 1:
        sum_en, sum_ko = f"Their counts add up to {parts} = {total}.", f"그 개수를 더하면 {parts} = {total}입니다."
    else:
        sum_en, sum_ko = f"Its count, {total}, is the answer.", f"그 개수 {josa(total, '이가')} 답입니다."
    frame({"en": f"The longest length is {longest}, ending at {plural(len(ends), 'index', 'indexes')} {where_en}. "
                 + sum_en,
           "ko": f"가장 긴 길이는 {longest}이고 인덱스 {where_en}에서 끝납니다. " + sum_ko},
          nums_marks={"path": ends}, length_marks={"path": ends}, count_marks={"path": ends}, result=[total],
          moves=[move(at("count", k), at("result", 0), value=f"+{count[k]}") for k in ends], answer=str(total))


for number, sample in enumerate(sample_cases(SLUG), start=1):
    nums = json.loads(sample["input"])
    run = sample_run(wt, number, sample, input=f"nums = {sample['input']}")
    solve(nums, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
