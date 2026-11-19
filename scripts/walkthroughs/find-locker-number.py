#!/usr/bin/env python3.12
"""find-locker-number's Walkthrough: the reference solution
(scripts/replay-solutions/find-locker-number.py), a binary search over the indices of a sorted array,
recording one frame per probe of mid on each sample Test Case. The search range is a span over
lockers[low..high] with the cells outside it faded; the side kept after comparing lockers[mid] with target
is a dashed span under it, and the next frame shows the range shrunk to that side.

    CODEBITE_DB=<database> scripts/walkthroughs/find-locker-number.py

writes common/src/main/resources/walkthroughs/find-locker-number.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import josa, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, span  # noqa: E402

SLUG = "find-locker-number"

wt = Walkthrough(
    {"en": "Find Locker Number", "ko": "사물함 위치 찾기"},
    {"en": "Binary search over indices: the lockers are sorted, so comparing the middle number with target "
           "says which side of mid target must be on, and each probe throws away half the range.",
     "ko": "인덱스 위의 이분 탐색입니다. 사물함 번호가 정렬되어 있으므로 가운데 번호를 target과 비교하면 target이 mid의 "
           "어느 쪽에 있어야 하는지 알 수 있고, 한 번 볼 때마다 범위가 절반으로 줄어듭니다."},
    views=[
        {"id": "lockers", "type": "array", "title": {"en": "lockers", "ko": "lockers (사물함 번호)"}},
        {"id": "state", "type": "vars"},
    ],
)


def solve(lockers, target, run):
    """Solution.findLocker with a frame per probe. Returns the answer as the Driver prints it."""
    n = len(lockers)
    low, high = 0, n - 1
    mid = None

    def frame(caption, kept=None, lit=(), path=(), done=False, **answer):
        spans = {}
        if low <= high and not done:
            spans["range"] = span(low, high, {"en": f"range {high - low + 1}", "ko": f"범위 {high - low + 1}"},
                                  fade=True)
        if kept:
            a, b = kept
            spans["kept"] = span(a, b, {"en": "kept", "ko": "남김"}, below=True, mark="good")
        if done and path:
            pointers = {}
        elif done:  # the empty range: high just left of low, where target would go
            pointers = {"high": high if high >= 0 else None, "low": low if low < n else None}
        else:
            pointers = {"low": low, "mid": mid, "high": high}
        run.frame(caption,
                  lockers={"values": lockers, "pointers": pointers, "spans": spans,
                           "marks": {"path": list(path), "lit": list(lit),
                                     "dim": [i for i in range(n) if i not in lit] if done and not path else []}},
                  state={"items": [{"label": {"en": "target", "ko": "target (목표)"}, "value": target}]},
                  **answer)

    frame({"en": f"Look for locker {target} among {n} lockers: the range starts as the whole array, low = 0 and "
                 f"high = {n - 1}.",
           "ko": f"사물함 {n}개에서 {target}번을 찾습니다. 범위는 처음에 배열 전체입니다: low = 0, high = {n - 1}."})
    while low <= high:
        mid = (low + high) // 2
        value = lockers[mid]
        if value == target:
            frame({"en": f"mid = ({low} + {high}) // 2 = {mid}, and lockers[{mid}] = {value} is target: the answer "
                         f"is position {mid}.",
                   "ko": f"mid = ({low} + {high}) // 2 = {mid}, lockers[{mid}] = {value}: target과 같습니다. 답은 "
                         f"{mid}번 위치입니다."},
                  path=[mid], done=True, answer=str(mid))
            return
        old_low, old_high = low, high
        if value < target:
            low = mid + 1
            kept = (low, old_high) if low <= old_high else None
            en = (f"mid = ({old_low} + {old_high}) // 2 = {mid}: {value} < {target}, so target can only be right "
                  f"of mid: low = {low}.")
            ko = (f"mid = ({old_low} + {old_high}) // 2 = {mid}: {value} < {target}, 그러니 target은 mid의 오른쪽에만 "
                  f"있을 수 있습니다. low = {low}.")
        else:
            high = mid - 1
            kept = (old_low, high) if old_low <= high else None
            en = (f"mid = ({old_low} + {old_high}) // 2 = {mid}: {value} > {target}, so target can only be left "
                  f"of mid: high = {high}.")
            ko = (f"mid = ({old_low} + {old_high}) // 2 = {mid}: {value} > {target}, 그러니 target은 mid의 왼쪽에만 "
                  f"있을 수 있습니다. high = {high}.")
        # the frame shows the range this probe split, before it shrinks
        new_low, new_high = low, high
        low, high = old_low, old_high
        frame({"en": en, "ko": ko}, kept=kept, lit=[mid])
        low, high = new_low, new_high
    mid = None
    where_en = (f"it would sit between lockers[{high}] = {lockers[high]} and lockers[{low}] = {lockers[low]}"
                if 0 <= high and low < n else
                ("it would come before every locker" if high < 0 else "it would come after every locker"))
    where_ko = (f"있다면 lockers[{high}] = {lockers[high]}, lockers[{low}] = {lockers[low]} 사이에 옵니다"
                if 0 <= high and low < n else
                ("있다면 모든 사물함 앞에 옵니다" if high < 0 else "있다면 모든 사물함 뒤에 옵니다"))
    frame({"en": f"low = {low} passed high = {high}, so the range is empty: no locker is numbered {target} "
                 f"({where_en}). The answer is -1.",
           "ko": f"low = {low}, high = {high}: low가 high를 지나쳐 범위가 비었습니다. {target}번 사물함은 없으니"
                 f"({where_ko}) 답은 -1입니다."},
          lit=[i for i in (high, low) if 0 <= i < n], done=True, answer="-1")


for number, sample in enumerate(sample_cases(SLUG), start=1):
    lines = sample["input"].split("\n")
    lockers, target = json.loads(lines[0]), int(lines[1])
    run = sample_run(wt, number, sample, input=f"lockers = {lines[0].strip()}, target = {target}")
    solve(lockers, target, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
