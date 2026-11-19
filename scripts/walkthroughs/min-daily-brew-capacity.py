#!/usr/bin/env python3.12
"""min-daily-brew-capacity's Walkthrough: the reference solution
(scripts/replay-solutions/min-daily-brew-capacity.py), a binary search over the answer, the daily capacity,
recording two frames per capacity tried on each sample Test Case: one that brews the queue at that capacity
(each day a span over the drinks it brews, the day count moving into the days needed), and one that compares
the days with the limit and cuts the range of capacities still possible, drawn as one interval on a number
line of capacities.

    CODEBITE_DB=<database> scripts/walkthroughs/min-daily-brew-capacity.py

writes common/src/main/resources/walkthroughs/min-daily-brew-capacity.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import josa, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move, span  # noqa: E402

SLUG = "min-daily-brew-capacity"

wt = Walkthrough(
    {"en": "Min Daily Brew Capacity", "ko": "최소 일일 추출 용량"},
    {"en": "Binary search over the answer: a bigger capacity never needs more days, so for any capacity one pass "
           "over the queue says whether it is enough, and each try halves the range of capacities still possible.",
     "ko": "답 위에서 하는 이분 탐색입니다. 용량이 클수록 필요한 날은 늘지 않으므로, 용량마다 대기열을 한 번 훑으면 충분한지 "
           "알 수 있고, 시도할 때마다 가능한 용량의 범위가 절반으로 줄어듭니다."},
    views=[
        {"id": "volumes", "type": "array",
         "title": {"en": "volumes (each day a span at capacity c)", "ko": "volumes (음료 양, 용량 c일 때 하루씩 묶음)"}},
        {"id": "caps", "type": "intervals", "title": {"en": "capacities still possible", "ko": "아직 가능한 용량"}},
        {"id": "needed", "type": "output", "title": {"en": "days needed at c", "ko": "c일 때 필요한 날 수"}},
        {"id": "state", "type": "vars"},
    ],
)


def pack(volumes, capacity):
    """days_needed from the reference, keeping each day's [first, last] drink."""
    groups = [[0, 0]]
    load = 0
    for i, volume in enumerate(volumes):
        if load + volume > capacity:
            groups.append([i, i])
            load = 0
        load += volume
        groups[-1][1] = i
    return groups


def solve(volumes, days, run):
    """Solution.minDailyCapacity with two frames per capacity tried. Returns the answer as the Driver prints it."""
    low, high = max(volumes), sum(volumes)
    cap = None
    groups = None
    needed = None
    most = [0]

    def frame(caption, range_mark=None, moves=None, done=False, **answer):
        spans = {}
        for k in range(most[0]):
            spans[f"day{k + 1}"] = (span(groups[k][0], groups[k][1], {"en": f"day {k + 1}", "ko": f"{k + 1}일"})
                                    if groups and k < len(groups) else None)
        points = [{"at": cap, "label": "c", "mark": "lit"}] if cap is not None and not done else []
        run.frame(caption,
                  volumes={"values": volumes, "spans": spans},
                  caps={"groups": [{"label": {"en": "possible", "ko": "가능"}, "intervals": [[low, high]],
                                    "marks": {"path" if done else (range_mark or "lit"): [0]} if done or range_mark else {}}],
                        "points": points},
                  needed={"values": [] if needed is None else [needed]},
                  state={"items": [{"label": {"en": "days (limit)", "ko": "days (제한 일수)"}, "value": days}]},
                  moves=moves, **answer)

    frame({"en": f"The capacity must hold the largest drink, {low}, and {high}, the whole queue, does it in one day, "
                 f"so the answer is in [{low}, {high}].",
           "ko": f"용량은 가장 큰 음료 {josa(low, '을를')} 담아야 하고, 대기열 전체 합 {josa(high, '은는')} 하루에 다 담기므로 "
                 f"답은 [{low}, {high}] 범위에 있습니다."})
    while low < high:
        cap = (low + high) // 2
        groups = pack(volumes, cap)
        most[0] = max(most[0], len(groups))
        needed = len(groups)
        last = groups[-1][1]
        frame({"en": f"Try the middle capacity c = ({low} + {high}) // 2 = {cap}: brewing the queue in order, each day "
                     f"takes drinks until the next would pass {cap}, which takes {needed} days.",
               "ko": f"가운데 용량 c = ({low} + {high}) // 2 = {josa(cap, '을를')} 시도합니다. 대기열 순서대로 하루 합이 {josa(cap, '을를')} "
                     f"넘기 전까지 추출하면 {needed}일이 걸립니다."},
              moves=[move(at("volumes", last), at("needed", 0), value=f"{needed}")])
        if needed <= days:
            high = cap
            frame({"en": f"{needed} ≤ {days} days, so c = {cap} is enough and so is any bigger capacity: keep {cap} "
                         f"as the top of the range, [{low}, {high}].",
                   "ko": f"{needed} ≤ {days}일이므로 c = {josa(cap, '은는')} 충분하고, 더 큰 용량도 마찬가지입니다. "
                         f"{josa(cap, '을를')} 범위의 위 끝으로 두어 [{low}, {high}]입니다."},
                  range_mark="good", moves=[move(at("needed", 0), at("caps", [0, 0]), value=f"{needed} ≤ {days}")])
        else:
            low = cap + 1
            frame({"en": f"{needed} > {days} days, so c = {cap} is too small and so is any smaller capacity: the "
                         f"range starts above it, [{low}, {high}].",
                   "ko": f"{needed} > {days}일이므로 c = {josa(cap, '은는')} 너무 작고, 더 작은 용량도 마찬가지입니다. "
                         f"범위는 그 위부터인 [{low}, {high}]입니다."},
                  range_mark="good", moves=[move(at("needed", 0), at("caps", [0, 0]), value=f"{needed} > {days}")])
    cap = low
    groups = pack(volumes, low)
    needed = len(groups)
    most[0] = max(most[0], len(groups))
    frame({"en": f"The range closed on one capacity, [{low}, {high}]: c = {low} is the smallest that brews every "
                 f"drink within {days} days (it takes {needed}).",
           "ko": f"범위가 [{low}, {high}] 구간으로 좁혀져 용량이 하나만 남았습니다. {days}일 안에 모두 추출하는 가장 작은 "
                 f"용량은 c = {low}입니다({needed}일 걸림)."},
          moves=[move(at("volumes", groups[-1][1]), at("needed", 0), value=f"{needed}")],
          done=True, answer=str(low))


for number, sample in enumerate(sample_cases(SLUG), start=1):
    lines = sample["input"].split("\n")
    volumes, days = json.loads(lines[0]), int(lines[1])
    run = sample_run(wt, number, sample, input=f"volumes = {lines[0].strip()}, days = {days}",
                     setup={"caps": {"domain": [max(volumes), sum(volumes)]}})
    solve(volumes, days, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
