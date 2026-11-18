#!/usr/bin/env python3.12
"""search-rotated-catalog's Walkthrough: the reference solution
(scripts/replay-solutions/search-rotated-catalog.py), a binary search over the indices of a rotated
sorted catalog, recording one frame per probe of mid on each sample Test Case. The search range is a span
over catalog[low..high] with the cells outside it faded; the half that is sorted is a dashed span under it,
and the caption says whether target falls inside that half, which decides the half kept.

    CODEBITE_DB=<database> scripts/walkthroughs/search-rotated-catalog.py

writes common/src/main/resources/walkthroughs/search-rotated-catalog.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import josa, plural, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, span  # noqa: E402

SLUG = "search-rotated-catalog"

wt = Walkthrough(
    {"en": "Search Rotated Catalog", "ko": "회전된 카탈로그 검색"},
    {"en": "Binary search over indices: of the two halves around mid, at least one is sorted, and comparing its "
           "ends with target says whether target can be in it, so each probe throws away half the range.",
     "ko": "인덱스 위의 이분 탐색입니다. mid를 기준으로 나눈 두 절반 중 적어도 하나는 정렬되어 있고, 그 양 끝을 target과 "
           "비교하면 target이 그 안에 있을 수 있는지 알 수 있어, 한 번 볼 때마다 범위가 절반으로 줄어듭니다."},
    views=[
        {"id": "catalog", "type": "array", "title": {"en": "catalog", "ko": "catalog (카탈로그)"}},
        {"id": "state", "type": "vars"},
    ],
)


def solve(catalog, target, run):
    """Solution.spotCatalogTarget with a frame per probe. Returns the answer as the Driver prints it."""
    n = len(catalog)
    low, high = 0, n - 1
    mid = None

    def frame(caption, sorted_half=None, kept=None, lit=(), path=(), done=False, **answer):
        spans = {}
        if low <= high and not done:
            spans["range"] = span(low, high, {"en": f"range {high - low + 1}", "ko": f"범위 {high - low + 1}"},
                                  fade=True)
        if sorted_half:
            a, b = sorted_half
            spans["sorted"] = span(a, b, {"en": "sorted", "ko": "정렬됨"}, below=True,
                                   mark="good" if kept else None)
        pointers = {} if done else {"low": low if 0 <= low < n and low <= high and low != mid else None,
                                    "mid": mid,
                                    "high": high if 0 <= high < n and low <= high else None}
        run.frame(caption,
                  catalog={"values": catalog, "pointers": pointers, "spans": spans,
                           "marks": {"path": list(path), "lit": list(lit), "dim": list(range(n)) if done and not path else []}},
                  state={"items": [{"label": "target", "value": target}]},
                  **answer)

    frame({"en": f"Look for target = {target} in {n} {plural(n, 'entry', 'entries')}: the range starts as the whole "
                 f"catalog, low = 0 and high = {n - 1}.",
           "ko": f"항목 {n}개에서 target = {josa(target, '을를')} 찾습니다. 범위는 카탈로그 전체로, low = 0, high = {n - 1}에서 시작합니다."})
    while low <= high:
        mid = (low + high) // 2
        if catalog[mid] == target:
            frame({"en": f"mid = ({low} + {high}) // 2 = {mid}, and catalog[{mid}] = {catalog[mid]} is target: "
                         f"the answer is index {mid}.",
                   "ko": f"mid = ({low} + {high}) // 2 = {mid}이고 catalog[{mid}] = {catalog[mid]}: target입니다. "
                         f"답은 인덱스 {mid}입니다."},
                  path=[mid], done=True, answer=str(mid))
            return
        probe = {"en": f"mid = {mid}: {catalog[mid]} ≠ {target}.", "ko": f"mid = {mid}: {catalog[mid]} ≠ {target},"}
        if catalog[low] <= catalog[mid]:
            half = (low, mid)
            inside = catalog[low] <= target < catalog[mid]
            where_en = f"catalog[{low}..{mid}] runs {catalog[low]}..{catalog[mid]} sorted ({catalog[low]} ≤ {catalog[mid]})"
            where_ko = f"catalog[{low}..{mid}] 구간은 {catalog[low]}..{catalog[mid]}로 정렬되어 있고({catalog[low]} ≤ {catalog[mid]})"
            span_en = f"[{catalog[low]}, {catalog[mid]})"
            old_low, old_high = low, high
            if inside:
                high = mid - 1
            else:
                low = mid + 1
        else:
            half = (mid, high)
            inside = catalog[mid] < target <= catalog[high]
            where_en = f"catalog[{mid}..{high}] runs {catalog[mid]}..{catalog[high]} sorted ({catalog[mid]} > {catalog[low]} fails)"
            where_ko = f"catalog[{mid}..{high}] 구간은 {catalog[mid]}..{catalog[high]}로 정렬되어 있고(왼쪽 끝 {josa(catalog[low], '이가')} 더 큼)"
            span_en = f"({catalog[mid]}, {catalog[high]}]"
            old_low, old_high = low, high
            if inside:
                low = mid + 1
            else:
                high = mid - 1
        side_en = "left" if high < mid else "right"
        side_ko = "왼쪽" if high < mid else "오른쪽"
        new = (f"low = {low}" if low != old_low else f"high = {high}")
        verdict_en = (f"{target} is in {span_en}, so keep that half" if inside
                      else f"{target} is outside {span_en}, so it can only be in the other half")
        verdict_ko = (f"target이 {span_en} 안에 있어 그 절반을 남깁니다" if inside
                      else f"target이 {span_en} 밖이라 다른 절반에만 있을 수 있습니다")
        # the frame shows the range this probe split, before it shrinks
        low, high, after_low, after_high = old_low, old_high, low, high
        frame({"en": f"{probe['en']} {where_en}; {verdict_en}: search the {side_en}, {new}.",
               "ko": f"{probe['ko']} {where_ko}, {verdict_ko}. {side_ko}을 찾습니다: {new}."},
              sorted_half=half, kept=inside, lit=[mid])
        low, high = after_low, after_high
    mid = None
    frame({"en": f"low = {low} passed high = {high}: the range is empty, so {target} isn't in the catalog: -1.",
           "ko": f"low = {low}, high = {high}: low가 high를 지나쳐 범위가 비었습니다. target이 카탈로그에 없으니 답은 -1입니다."},
          done=True, answer="-1")


for number, sample in enumerate(sample_cases(SLUG), start=1):
    lines = sample["input"].split("\n")
    catalog, target = json.loads(lines[0]), int(lines[1])
    run = sample_run(wt, number, sample, input=f"catalog = {lines[0].strip()}, target = {target}")
    solve(catalog, target, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
