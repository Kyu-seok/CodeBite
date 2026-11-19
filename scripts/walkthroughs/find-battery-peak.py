#!/usr/bin/env python3.12
"""find-battery-peak's Walkthrough: the reference solution (scripts/replay-solutions/find-battery-peak.py),
a binary search over indices that climbs toward the higher neighbour, recording one frame per probe of mid on
each sample Test Case. The readings are bars, so the climb shows; the search range is a span over
readings[low..high] with the bars outside it faded, readings[mid] and readings[mid + 1] are lit as the pair
compared, and the side kept is a dashed span under the range.

    CODEBITE_DB=<database> scripts/walkthroughs/find-battery-peak.py

writes common/src/main/resources/walkthroughs/find-battery-peak.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, span  # noqa: E402

SLUG = "find-battery-peak"

wt = Walkthrough(
    {"en": "Find Battery Peak", "ko": "정점 값 찾기"},
    {"en": "Binary search over indices: compare readings[mid] with its right neighbour. If the neighbour is "
           "higher, climbing right must reach a peak before the −∞ past the end, so keep the right; if not, mid "
           "itself or something left of it is a peak.",
     "ko": "인덱스 위의 이분 탐색입니다. readings[mid] 값을 오른쪽 이웃과 비교합니다. 이웃이 더 높으면 오른쪽으로 오르다 배열 끝의 "
           "−∞에 닿기 전에 반드시 정점을 만나므로 오른쪽을 남기고, 아니면 mid 자신이나 그 왼쪽에 정점이 있습니다."},
    views=[
        {"id": "readings", "type": "array", "display": "bars",
         "title": {"en": "readings", "ko": "readings (배터리 잔량)"}},
    ],
)


def solve(readings, run):
    """Solution.pinpointPeak with a frame per probe. Returns the answer as the Driver prints it."""
    n = len(readings)
    low, high = 0, n - 1
    mid = None

    def frame(caption, kept=None, lit=(), path=(), done=False, **answer):
        spans = {}
        if not done:
            spans["range"] = span(low, high, {"en": f"range {high - low + 1}", "ko": f"범위 {high - low + 1}"},
                                  fade=True)
        if kept:
            spans["kept"] = span(kept[0], kept[1], {"en": "kept", "ko": "남김"}, below=True, mark="good")
        pointers = {"low": low, "high": high}
        if mid is not None and not done:
            pointers["mid"] = mid
        run.frame(caption,
                  readings={"values": readings, "pointers": pointers, "spans": spans,
                            "marks": {"lit": list(lit), "path": list(path),
                                      "dim": [i for i in range(n) if i not in path] if done else []}},
                  **answer)

    frame({"en": f"Look for a peak among {n} readings, treating the places past either end as −∞: the range "
                 f"starts as the whole log, low = 0 and high = {n - 1}.",
           "ko": f"배터리 잔량 {n}개에서 정점을 찾습니다(양 끝 바깥은 −∞). 범위는 처음에 로그 전체입니다: "
                 f"low = 0, high = {n - 1}."})
    while low < high:
        mid = (low + high) // 2
        old_low, old_high = low, high
        a, b = readings[mid], readings[mid + 1]
        head = f"mid = ({low} + {high}) // 2 = {mid}: readings[{mid}] = {a}"
        if a < b:
            low = mid + 1
            kept = (low, old_high)
            en = (f"{head} < readings[{mid + 1}] = {b}, so the log climbs to the right and a peak lies there: "
                  f"low = {low}.")
            ko = (f"{head} < readings[{mid + 1}] = {b}, 그러니 오른쪽으로 오르는 중이고 정점은 그쪽에 있습니다. "
                  f"low = {low}.")
        else:
            high = mid
            kept = (old_low, high)
            en = (f"{head} > readings[{mid + 1}] = {b}, so the log falls after mid: mid or something left of it "
                  f"is a peak, high = {high}.")
            ko = (f"{head} > readings[{mid + 1}] = {b}, 그러니 mid 다음에 내려가므로 mid이거나 그 왼쪽에 정점이 "
                  f"있습니다. high = {high}.")
        new_low, new_high = low, high
        low, high = old_low, old_high
        frame({"en": en, "ko": ko}, kept=kept, lit=[mid, mid + 1])
        low, high = new_low, new_high
    mid = None
    left = f"readings[{low - 1}] = {readings[low - 1]}" if low > 0 else "−∞"
    right = f"readings[{low + 1}] = {readings[low + 1]}" if low + 1 < n else "−∞"
    frame({"en": f"low = high = {low}: the range is one reading, and readings[{low}] = {readings[low]} beats both "
                 f"neighbours, {left} and {right}. The answer is index {low}.",
           "ko": f"low = high = {low}: 범위가 한 칸이고, readings[{low}] = {readings[low]}의 양 이웃 {left}, {right}보다 "
                 f"큽니다. 답은 인덱스 {low}입니다."},
          path=[low], done=True, answer=str(low))


for number, sample in enumerate(sample_cases(SLUG), start=1):
    line = sample["input"].split("\n")[0]
    run = sample_run(wt, number, sample, input=f"readings = {line.strip()}")
    solve(json.loads(line), run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
