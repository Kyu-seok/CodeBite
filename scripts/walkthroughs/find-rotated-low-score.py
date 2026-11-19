#!/usr/bin/env python3.12
"""find-rotated-low-score's Walkthrough: the reference solution
(scripts/replay-solutions/find-rotated-low-score.py), a binary search over the indices of a rotated sorted
array for its smallest value, recording one frame per probe of mid on each sample Test Case. The search
range is a span over scores[low..high] with the cells outside it faded; scores[mid] and scores[high] are lit
as the two values compared, and the side kept is a dashed span under the range.

    CODEBITE_DB=<database> scripts/walkthroughs/find-rotated-low-score.py

writes common/src/main/resources/walkthroughs/find-rotated-low-score.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, span  # noqa: E402

SLUG = "find-rotated-low-score"

wt = Walkthrough(
    {"en": "Find the Rotated Low Score", "ko": "회전된 리더보드 최저 점수"},
    {"en": "Binary search over indices: compare scores[mid] with the range's last value, scores[high]. If mid's "
           "is bigger, the drop to the smallest value lies right of mid; if not, mid..high is sorted and the "
           "smallest is at mid or left of it.",
     "ko": "인덱스 위의 이분 탐색입니다. scores[mid] 값을 범위의 마지막 값 scores[high]와 비교합니다. mid 쪽이 크면 가장 작은 "
           "값으로 떨어지는 곳이 mid 오른쪽에 있고, 아니면 mid..high가 정렬되어 있어 가장 작은 값은 mid이거나 그 왼쪽입니다."},
    views=[
        {"id": "scores", "type": "array", "title": {"en": "scores", "ko": "scores (점수)"}},
    ],
)


def solve(scores, run):
    """Solution.findLowestScore with a frame per probe. Returns the answer as the Driver prints it."""
    n = len(scores)
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
                  scores={"values": scores, "pointers": pointers, "spans": spans,
                          "marks": {"lit": list(lit), "path": list(path),
                                    "dim": [i for i in range(n) if i not in path] if done else []}},
                  **answer)

    frame({"en": f"The smallest of {n} scores is somewhere in the whole array: low = 0, high = {n - 1}.",
           "ko": f"점수 {n}개 중 가장 작은 값은 배열 어딘가에 있습니다. 범위는 처음에 전체입니다: low = 0, high = {n - 1}."})
    while low < high:
        mid = (low + high) // 2
        old_low, old_high = low, high
        a, b = scores[mid], scores[high]
        head_en = f"mid = ({low} + {high}) // 2 = {mid}: scores[{mid}] = {a}"
        head_ko = f"mid = ({low} + {high}) // 2 = {mid}: scores[{mid}] = {a}"
        if a > b:
            low = mid + 1
            kept = (low, old_high)
            en = (f"{head_en} > scores[{old_high}] = {b}, so the values drop somewhere right of mid, and the "
                  f"smallest is there: low = {low}.")
            ko = (f"{head_ko} > scores[{old_high}] = {b}, 그러니 mid 오른쪽 어딘가에서 값이 떨어지고 가장 작은 값은 그쪽에 "
                  f"있습니다. low = {low}.")
        else:
            high = mid
            kept = (old_low, high)
            en = (f"{head_en} < scores[{old_high}] = {b}, so scores[{mid}..{old_high}] is sorted and nothing right "
                  f"of mid is smaller: high = {high}.")
            ko = (f"{head_ko} < scores[{old_high}] = {b}, 그러니 scores[{mid}..{old_high}] 구간은 정렬되어 있어 mid 오른쪽에 "
                  f"더 작은 값이 없습니다. high = {high}.")
        new_low, new_high = low, high
        low, high = old_low, old_high
        frame({"en": en, "ko": ko}, kept=kept, lit=[mid, high])
        low, high = new_low, new_high
    mid = None
    frame({"en": f"low = high = {low}: the range is one cell, so scores[{low}] = {scores[low]} is the smallest "
                 f"score.",
           "ko": f"low = high = {low}: 범위가 한 칸이므로 가장 작은 점수는 scores[{low}] = {scores[low]}입니다."},
          path=[low], done=True, answer=str(scores[low]))


for number, sample in enumerate(sample_cases(SLUG), start=1):
    line = sample["input"].split("\n")[0]
    run = sample_run(wt, number, sample, input=f"scores = {line.strip()}")
    solve(json.loads(line), run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
