#!/usr/bin/env python3.12
"""slowest-snack-rate's Walkthrough: the reference solution
(scripts/replay-solutions/slowest-snack-rate.py), a binary search over the answer, the eating rate k,
recording two frames per rate tried on each sample Test Case: one that eats every pile at that rate (each
pile's hours under it, moving into the hours needed), and one that compares the hours with the limit and
cuts the range of rates still possible, drawn as one interval on a number line of rates.

    CODEBITE_DB=<database> scripts/walkthroughs/slowest-snack-rate.py

writes common/src/main/resources/walkthroughs/slowest-snack-rate.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import josa, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move  # noqa: E402

SLUG = "slowest-snack-rate"

wt = Walkthrough(
    {"en": "Slowest Snack Rate", "ko": "가장 느린 간식 속도"},
    {"en": "Binary search over the answer: a faster rate never needs more hours, so for any rate k one pass over "
           "the piles says whether k is fast enough, and each try halves the range of rates still possible.",
     "ko": "답 위에서 하는 이분 탐색입니다. 속도가 빠를수록 시간은 늘지 않으므로, 속도 k마다 더미를 한 번 훑으면 k가 충분히 "
           "빠른지 알 수 있고, 시도할 때마다 가능한 속도의 범위가 절반으로 줄어듭니다."},
    views=[
        {"id": "piles", "type": "array",
         "title": {"en": "piles (hours each at k, under)", "ko": "piles (아래: k일 때 더미별 시간)"}},
        {"id": "rates", "type": "intervals", "title": {"en": "rates still possible", "ko": "아직 가능한 속도"}},
        {"id": "needed", "type": "output", "title": {"en": "hours needed at k", "ko": "k일 때 필요한 시간"}},
        {"id": "state", "type": "vars"},
    ],
)


def solve(piles, hours, run):
    """Solution.minEatingRate with two frames per rate tried. Returns the answer as the Driver prints it."""
    top = max(piles)
    low, high = 1, top
    speed = None
    per_pile = None
    needed = None

    def frame(caption, range_mark=None, pile_lit=(), moves=None, done=False, **answer):
        points = [{"at": speed, "label": "k", "mark": "lit"}] if speed is not None and not done else []
        run.frame(caption,
                  piles={"values": piles, "under": [[i, str(h)] for i, h in enumerate(per_pile)] if per_pile else [],
                         "marks": {"lit": list(pile_lit)}},
                  rates={"groups": [{"label": {"en": "possible", "ko": "가능"}, "intervals": [[low, high]],
                                     "marks": {"path" if done else (range_mark or "lit"): [0]} if done or range_mark else {}}],
                         "points": points},
                  needed={"values": [] if needed is None else [needed]},
                  state={"items": [{"label": {"en": "hours (limit)", "ko": "hours (제한 시간)"}, "value": hours}]},
                  moves=moves, **answer)

    frame({"en": f"k can't usefully pass the largest pile, {top} (every pile then takes one hour), and it is at least "
                 f"1, so the answer is in [1, {top}].",
           "ko": f"가장 큰 더미가 {top}개라서 k가 그보다 커도 소용없고(모든 더미가 한 시간), k는 1 이상이므로 답은 "
                 f"[1, {top}] 범위에 있습니다."})
    while low < high:
        speed = (low + high) // 2
        per_pile = [(pile + speed - 1) // speed for pile in piles]
        needed = sum(per_pile)
        parts = " + ".join(map(str, per_pile))
        frame({"en": f"Try the middle rate k = ({low} + {high}) // 2 = {speed}: pile p takes ⌈p / {speed}⌉ hours, "
                     f"{parts} = {needed} in all.",
               "ko": f"가운데 속도 k = ({low} + {high}) // 2 = {josa(speed, '을를')} 시도합니다. 더미 p는 ⌈p / {speed}⌉시간이 걸려 "
                     f"모두 {parts} = {needed}시간입니다."},
              pile_lit=range(len(piles)),
              moves=[move(at("piles", i), at("needed", 0), value=str(h)) for i, h in enumerate(per_pile)])
        if needed <= hours:
            high = speed
            frame({"en": f"{needed} ≤ {hours} hours, so k = {speed} is fast enough and so is any faster rate: "
                         f"keep k = {speed} as the top of the range, [{low}, {high}].",
                   "ko": f"{needed} ≤ {hours}시간이므로 k = {josa(speed, '은는')} 충분히 빠르고, 더 빠른 속도도 마찬가지입니다. "
                         f"k = {josa(speed, '을를')} 범위의 위 끝으로 두어 [{low}, {high}]입니다."},
                  range_mark="good", moves=[move(at("needed", 0), at("rates", [0, 0]), value=f"{needed} ≤ {hours}")])
        else:
            low = speed + 1
            frame({"en": f"{needed} > {hours} hours, so k = {speed} is too slow and so is any slower rate: "
                         f"the range starts above it, [{low}, {high}].",
                   "ko": f"{needed} > {hours}시간이므로 k = {josa(speed, '은는')} 너무 느리고, 더 느린 속도도 마찬가지입니다. "
                         f"범위는 그 위부터인 [{low}, {high}]입니다."},
                  range_mark="good", moves=[move(at("needed", 0), at("rates", [0, 0]), value=f"{needed} > {hours}")])
    speed = low
    frame({"en": f"The range closed on one rate, [{low}, {high}]: k = {low} is the slowest rate that finishes "
                 f"within {hours} hours.",
           "ko": f"범위가 [{low}, {high}] 구간으로 좁혀져 속도가 하나만 남았습니다. {hours}시간 안에 다 먹는 가장 느린 속도는 k = {low}입니다."},
          done=True, answer=str(low))


for number, sample in enumerate(sample_cases(SLUG), start=1):
    lines = sample["input"].split("\n")
    piles, hours = json.loads(lines[0]), int(lines[1])
    run = sample_run(wt, number, sample, input=f"piles = {lines[0].strip()}, hours = {hours}",
                     setup={"rates": {"domain": [1, max(piles)]}})
    solve(piles, hours, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
