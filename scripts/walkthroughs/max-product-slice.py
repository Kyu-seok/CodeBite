#!/usr/bin/env python3.12
"""max-product-slice's Walkthrough: the reference solution (scripts/replay-solutions/max-product-slice.py), rolling
values carried along the array: the largest and the smallest product of a slice ending on the number just read,
and the best product so far, recording one frame per number on each sample Test Case.

The three values are a three-cell array (`high`, `low`, `best`). Each number rewrites high and low at once, as the
solution's tuple assignment does, and each moves in from the candidate it took: the number alone, or high or low
times it (a negative number turns the smallest into the largest). The slices behind high and low are spans on the
numbers, high above and low below, so a slice that starts over or swaps sides shows. The tracer keeps the slice
behind best, which the last frame marks.

    CODEBITE_DB=<database> scripts/walkthroughs/max-product-slice.py

writes common/src/main/resources/walkthroughs/max-product-slice.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import josa, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move, span  # noqa: E402

SLUG = "max-product-slice"
HIGH, LOW, BEST = 0, 1, 2

wt = Walkthrough(
    {"en": "Max Product Slice", "ko": "곱이 가장 큰 구간"},
    {"en": "A negative number turns the smallest product into the largest, so carry both: the largest and smallest "
           "product of a slice ending here are the number alone or the previous largest or smallest times it.",
     "ko": "음수를 곱하면 가장 작은 곱이 가장 큰 곱이 되므로 둘 다 들고 갑니다. 여기서 끝나는 구간의 최대·최소 곱은 "
           "이 수 하나, 또는 직전 최대 곱이나 최소 곱에 이 수를 곱한 값 중에서 나옵니다."},
    views=[
        {"id": "nums", "type": "array", "title": {"en": "nums", "ko": "nums (정수 배열)"}},
        {"id": "vals", "type": "array",
         "title": {"en": "products of slices ending here, and the best", "ko": "여기서 끝나는 구간의 최대(high)·최소(low) 곱과 최고 곱(best)"}},
    ],
)
TAGS = [[HIGH, {"en": "high", "ko": "high"}], [LOW, {"en": "low", "ko": "low"}],
        [BEST, {"en": "best", "ko": "best"}]]


def paren(v):
    return f"({v})" if v < 0 else str(v)


def solve(nums, run):
    """Solution.maxProduct with a frame per number. Returns the answer as the Driver prints it."""
    n = len(nums)
    best = high = low = nums[0]
    high_from = low_from = best_from = best_to = 0

    def frame(caption, i, num_marks=None, val_marks=None, moves=None, slices=True, **answer):
        spans = {}
        if slices:
            spans = {"high": span(high_from, i, {"en": "high", "ko": "high (최대 곱)"}, mark="good"),
                     "low": span(low_from, i, {"en": "low", "ko": "low (최소 곱)"}, below=True)}
        run.frame(caption,
                  nums={"values": nums, "pointers": {"i": i if slices else None}, "spans": spans,
                        "marks": num_marks or {}, "unread": list(range(i + 1, n)) if slices else []},
                  vals={"values": [high, low, best], "tags": TAGS, "marks": val_marks or {}},
                  moves=moves, **answer)

    frame({"en": f"{n} numbers. The only slice ending on {paren(nums[0])} is [{nums[0]}], so high, low and best all "
                 f"start at {nums[0]}.",
           "ko": f"수가 {n}개입니다. 첫 수에서 끝나는 구간은 [{nums[0]}] 하나뿐이라 high, low, best 모두 "
                 f"{josa(nums[0], '(으)로')} 시작합니다."},
          0, num_marks={"lit": [0]}, val_marks={"good": [HIGH, LOW, BEST]})
    for i in range(1, n):
        v = nums[i]
        old_high, old_low, old_best = high, low, best
        candidates = (v, old_high * v, old_low * v)
        hi, lo = max(candidates), min(candidates)
        hi_pick, lo_pick = candidates.index(hi), candidates.index(lo)  # max and min keep the first of a tie
        froms = (i, high_from, low_from)
        high, low = hi, lo
        high_from, low_from = froms[hi_pick], froms[lo_pick]
        texts = (str(v), f"{paren(old_high)}×{paren(v)}", f"{paren(old_low)}×{paren(v)}")
        sources = (at("nums", i), at("vals", HIGH), at("vals", LOW))
        moves = []
        for target, pick in ((HIGH, hi_pick), (LOW, lo_pick)):
            src = sources[pick]
            if src == at("vals", target):  # the same cell times v: the number flies in carrying the product
                src = at("nums", i)
            moves.append(move(src, at("vals", target), value=texts[pick]))
        best = max(old_best, high)
        changed = [c for c, (a, b) in enumerate([(old_high, high), (old_low, low), (old_best, best)]) if a != b]
        if best != old_best:
            best_from, best_to = high_from, i
            moves.append(move(at("vals", HIGH), at("vals", BEST), value=str(best)))
        options = f"{v}, {old_high} × {paren(v)} = {old_high * v}, {old_low} × {paren(v)} = {old_low * v}"
        why_en = why_ko = ""
        if v < 0 and hi_pick == 2:
            why_en = f" {v} is negative, so the smallest, {old_low}, became the largest."
            why_ko = f" {josa(v, '은는')} 음수라 가장 작던 {josa(old_low, '이가')} 가장 커졌습니다."
        elif hi_pick == 0 and v != 0:
            why_en = f" {v} alone beats both, so the high slice starts over."
            why_ko = f" {v} 하나가 둘보다 커서 high 구간이 새로 시작합니다."
        best_en = f"best becomes {best}." if best != old_best else f"best stays {best}."
        best_ko = f"best는 {best}입니다." if best != old_best else f"best는 {best} 그대로입니다."
        frame({"en": f"{v}: the options are {options}, so high = {high} and low = {low}; {best_en}{why_en}",
               "ko": f"{v}: 후보는 {options}이므로 high = {high}, low = {low}이고 {best_ko}{why_ko}"},
              i, num_marks={"lit": [i]}, val_marks={"good": changed}, moves=moves)
    slice_ = json.dumps(nums[best_from:best_to + 1], separators=(",", ":"))
    frame({"en": f"Every number read: the best product is {best}, from the slice {slice_} (indices {best_from} to "
                 f"{best_to}). Answer: {best}." if best_from != best_to else
                 f"Every number read: the best product is {best}, from the slice [{nums[best_from]}] alone. "
                 f"Answer: {best}.",
           "ko": f"모든 수를 읽었습니다. 가장 큰 곱은 인덱스 {best_from}부터 {best_to}까지의 {slice_} 구간에서 나온 "
                 f"{best}이고, 답은 {best}입니다." if best_from != best_to else
                 f"모든 수를 읽었습니다. 가장 큰 곱은 [{nums[best_from]}] 한 칸짜리 구간의 {best}이고, "
                 f"답은 {best}입니다."},
          n - 1, slices=False,
          num_marks={"path": list(range(best_from, best_to + 1)),
                     "dim": [j for j in range(n) if not best_from <= j <= best_to]},
          val_marks={"path": [BEST]}, answer=str(best))


for number, sample in enumerate(sample_cases(SLUG), start=1):
    nums = json.loads(sample["input"])
    run = sample_run(wt, number, sample, input=f"nums = {sample['input']}")
    solve(nums, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
