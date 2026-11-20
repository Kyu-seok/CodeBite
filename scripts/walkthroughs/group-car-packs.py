#!/usr/bin/env python3.12
"""group-car-packs's Walkthrough: the reference solution (scripts/replay-solutions/group-car-packs.py), the cars
read nearest the booth first with a stack of the packs' arrival times, recording one frame per car on each sample
Test Case. The stack is drawn upright on a fixed base, each pack its arrival time tagged with the kilometer of the
car that leads it: a car arriving later than the pack on top moves onto the stack as a new pack; one arriving no
later catches that pack before the booth and moves into it.

    CODEBITE_DB=<database> scripts/walkthroughs/group-car-packs.py

writes common/src/main/resources/walkthroughs/group-car-packs.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import plural, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move, stack  # noqa: E402

SLUG = "group-car-packs"

wt = Walkthrough(
    {"en": "Group Car Packs", "ko": "자동차 팩 묶기"},
    {"en": "Read the cars nearest the booth first and work out when each would arrive alone. A car that would "
           "arrive no later than the pack ahead catches it and joins it; a later one starts a new pack on the stack.",
     "ko": "톨게이트에 가까운 차부터 읽으며 혼자 달릴 때의 도착 시간을 구합니다. 앞 팩보다 늦지 않게 도착할 차는 그 팩을 "
           "따라잡아 합류하고, 더 늦은 차는 스택에 새 팩으로 올라갑니다."},
    views=[
        {"id": "cars", "type": "array",
         "title": {"en": "cars by km, nearest the booth first", "ko": "자동차 (km, 톨게이트에 가까운 순)"}},
        {"id": "packs", "type": "stack", "title": {"en": "packs (arrival)", "ko": "팩 (도착 시간)"},
         "empty": {"en": "empty", "ko": "비어 있음"}},
    ],
)


def hours(t):
    """An arrival time as drawn: whole hours plainly, else two decimals at most."""
    if t == int(t):
        return f"{int(t)}h"
    return f"{round(t, 2):g}h"


def hours_ko(t):
    return hours(t)[:-1] + "시간"


def approx(t):
    return "=" if round(t, 2) == t else "≈"


def solve(target, position, speed, run):
    """Solution.countCarPacks with a frame per car. Returns the answer as the Driver prints it."""
    cars = sorted(zip(position, speed), reverse=True)
    n = len(cars)
    kms = [p for p, _ in cars]
    speed_tags = [[j, {"en": f"{s}km/h", "ko": f"시속 {s}km"}] for j, (_, s) in enumerate(cars)]
    arrivals = {}
    packs = []  # (arrival, index of the car leading the pack), nearest pack at the bottom
    leaders = []
    i = None

    def frame(caption, lit=(), path=(), pack_marks=None, moves=None, **answer):
        run.frame(caption,
                  cars={"values": kms, "tags": speed_tags, "pointers": {"car": i},
                        "under": [[j, hours(t)] for j, t in arrivals.items()],
                        "unread": list(range(i + 1, n)) if i is not None else [],
                        "marks": {"path": list(path), "lit": list(lit)}},
                  packs={**stack(packs, value=lambda p: hours(p[0]),
                                 tag=lambda p: {"en": f"km {kms[p[1]]}", "ko": f"{kms[p[1]]}km"}),
                         "marks": pack_marks or {}},
                  moves=moves, **answer)

    frame({"en": f"{n} {plural(n, 'car', 'cars')} head for the booth at km {target}, sorted by kilometer, nearest the "
                 f"booth first. The stack of packs starts empty.",
           "ko": f"자동차 {n}대가 {target}km 지점의 톨게이트로 향합니다. 톨게이트에 가까운 차부터 정렬했고, 팩의 스택은 "
                 f"비어 있습니다."})
    for i, (start, pace) in enumerate(cars):
        arrival = (target - start) / pace
        arrivals[i] = arrival
        sum_en = f"({target} − {start}) ÷ {pace} {approx(arrival)} {hours(arrival)}"
        sum_ko = f"({target} − {start}) ÷ {pace} {approx(arrival)} {hours_ko(arrival)}"
        if not packs or arrival > packs[-1][0]:
            if packs:
                ahead = packs[-1][0]
                why = {"en": f"later than the pack on top ({hours(ahead)}), so it never catches it: a new pack",
                       "ko": f"맨 위 팩({hours_ko(ahead)})보다 늦게 도착하므로 따라잡지 못해 새 팩이 됩니다"}
            else:
                why = {"en": "no pack is ahead of it, so it leads the first pack",
                       "ko": "앞에 팩이 없으므로 첫 팩을 이끕니다"}
            packs.append((arrival, i))
            leaders.append(i)
            frame({"en": f"The car at km {start} drives {pace} km/h: {sum_en} to the booth, {why['en']}.",
                   "ko": f"{start}km 지점의 차는 시속 {pace}km로 {sum_ko}이 걸립니다. {why['ko']}."},
                  lit=[i], pack_marks={"good": [len(packs) - 1]},
                  moves=[move(at("cars", i), at("packs", len(packs) - 1), value=hours(arrival))])
        else:
            ahead = packs[-1][0]
            frame({"en": f"The car at km {start} drives {pace} km/h: {sum_en}, no later than the pack on top "
                         f"({hours(ahead)}). "
                         f"It catches that pack before the booth and joins it.",
                   "ko": f"{start}km 지점의 차는 시속 {pace}km로 {sum_ko}이 걸려 맨 위 팩({hours_ko(ahead)})보다 늦지 않습니다. "
                         f"톨게이트 전에 그 팩을 따라잡아 합류합니다."},
                  lit=[i], pack_marks={"lit": [len(packs) - 1]},
                  moves=[move(at("cars", i), at("packs", len(packs) - 1), value=hours(arrival))])
    i = None
    k = len(packs)
    frame({"en": f"Every car is read: {k} {plural(k, 'pack reaches', 'packs reach')} the booth, one per entry on the "
                 f"stack.",
           "ko": f"모든 차를 읽었습니다. 스택에 남은 팩마다 하나씩, 팩 {k}개가 톨게이트에 도착합니다."},
          path=leaders, pack_marks={"path": list(range(k))}, answer=str(k))
    return str(k)


for number, sample in enumerate(sample_cases(SLUG), start=1):
    target_line, position_line, speed_line = sample["input"].split("\n")
    target, position, speed = int(target_line), json.loads(position_line), json.loads(speed_line)
    run = sample_run(wt, number, sample, input=f"target = {target}, position = {position_line}, speed = {speed_line}")
    solve(target, position, speed, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
