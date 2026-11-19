#!/usr/bin/env python3.12
"""non-decreasing-with-one-change's Walkthrough: the reference solution
(scripts/replay-solutions/non-decreasing-with-one-change.py), one pass over each neighbouring pair that spends the
one change on the first drop, lowering the earlier element when that keeps order behind it and raising the later
one otherwise, and fails on a second drop, recording one frame per pair and one per change on each sample Test Case.

The array is the solution's own copy, so the change writes into it: a move from the element whose value is copied
into the one changed, which is tagged `changed`. The pair compared is lit, a drop `bad`.

    CODEBITE_DB=<database> scripts/walkthroughs/non-decreasing-with-one-change.py

writes common/src/main/resources/walkthroughs/non-decreasing-with-one-change.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import josa, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move  # noqa: E402

SLUG = "non-decreasing-with-one-change"

wt = Walkthrough(
    {"en": "Non-Decreasing With One Change", "ko": "한 번 바꿔 비감소 만들기"},
    {"en": "Walk the neighbouring pairs. The first drop spends the one change: lower the earlier element to the later "
           "one, unless that would put it below the element before it; then raise the later one instead. A second "
           "drop means false.",
     "ko": "이웃한 두 원소를 차례로 비교합니다. 처음 줄어드는 곳에서 한 번의 변경을 씁니다. 앞 원소를 뒤 원소로 "
           "낮추되, 그러면 그 앞 원소보다 작아질 때는 대신 뒤 원소를 높입니다. 두 번째로 줄어드는 곳이 나오면 false입니다."},
    views=[
        {"id": "nums", "type": "array", "title": {"en": "nums", "ko": "nums"}},
    ],
)

CHANGED = {"en": "changed", "ko": "바꿈"}


def solve(original, run):
    """Solution.canBeNonDecreasing with a frame per pair and per change. Returns the answer as the Driver prints it."""
    nums = list(original)
    n = len(nums)
    tags = []

    def frame(caption, i=None, lit=(), good=(), bad=(), path=(), moves=None, **answer):
        run.frame(caption,
                  nums={"values": list(nums), "pointers": {"i": i}, "tags": list(tags),
                        "marks": {"path": list(path), "bad": list(bad), "good": list(good), "lit": list(lit)}},
                  moves=moves, **answer)

    frame({"en": f"{n} numbers, and one change to spend. Compare each number with the one before it.",
           "ko": f"숫자가 {n}개이고, 바꿀 수 있는 기회는 한 번입니다. 각 숫자를 바로 앞 숫자와 비교합니다."})
    changed = False
    for i in range(1, n):
        a, b = nums[i - 1], nums[i]
        if b >= a:
            frame({"en": f"{a} ≤ {b}: in order.", "ko": f"{a} ≤ {b}: 순서가 맞습니다."}, i=i, lit=[i - 1, i])
            continue
        if changed:
            frame({"en": f"{a} > {b}: a second drop, and the one change is already spent. Answer: false.",
                   "ko": f"{a} > {b}: 두 번째로 줄어드는 곳인데 변경은 이미 썼습니다. 답은 false입니다."},
                  i=i, bad=[i - 1, i], answer="false")
            return
        frame({"en": f"{a} > {b}: the first drop, so spend the one change here.",
               "ko": f"{a} > {b}: 처음 줄어드는 곳이므로 여기서 한 번의 변경을 씁니다."},
              i=i, bad=[i - 1, i])
        changed = True
        if i >= 2 and b < nums[i - 2]:
            before = nums[i - 2]
            nums[i] = a
            tags.append([i, CHANGED])
            frame({"en": f"Lowering {a} to {b} would put it below {before} before it, so raise {b} to {a} instead.",
                   "ko": f"{josa(a, '을를')} {josa(b, '(으)로')} 낮추면 그 앞의 {before}보다 작아지므로, 대신 "
                         f"{josa(b, '을를')} {josa(a, '(으)로')} 높입니다."},
                  i=i, lit=[i - 2, i - 1], good=[i], moves=[move(at("nums", i - 1), at("nums", i), value=a)])
        else:
            nums[i - 1] = b
            tags.append([i - 1, CHANGED])
            why_en = "nothing comes before it" if i == 1 else f"{nums[i - 2]} before it is still ≤ {b}"
            why_ko = "그 앞에 아무것도 없으므로" if i == 1 else f"그 앞의 {josa(nums[i - 2], '이가')} {b} 이하이므로"
            frame({"en": f"Lower {a} to {b}: {why_en}, so order behind it holds, and later numbers only have to "
                         f"beat {b}.",
                   "ko": f"{why_ko} {josa(a, '을를')} {josa(b, '(으)로')} 낮춥니다. 이러면 뒤의 숫자는 {b} 이상이기만 "
                         "하면 됩니다."},
                  i=i, lit=[i], good=[i - 1], moves=[move(at("nums", i), at("nums", i - 1), value=b)])
    fixed = json.dumps(nums, separators=(",", ":"))
    frame({"en": f"Every pair is in order{' after one change' if changed else ''}: {fixed}. Answer: true.",
           "ko": f"{'한 번 바꾼 뒤 ' if changed else ''}모든 쌍의 순서가 맞습니다: {fixed}. 답은 true입니다."},
          path=range(n), answer="true")


for number, sample in enumerate(sample_cases(SLUG), start=1):
    nums = json.loads(sample["input"])
    run = sample_run(wt, number, sample, input=f"nums = {sample['input']}")
    solve(nums, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
