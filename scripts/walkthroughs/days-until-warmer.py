#!/usr/bin/env python3.12
"""days-until-warmer's Walkthrough: the reference solution
(scripts/replay-solutions/days-until-warmer.py), a monotonic stack of the days still waiting for a warmer
reading, recording one frame per day popped and one per day pushed on each sample Test Case. The stack is
an array, top on the right, each entry its day's reading tagged with the day; a day popped by a warmer
reading moves into its wait slot as the gap in days, and each day read moves onto the top.

    CODEBITE_DB=<database> scripts/walkthroughs/days-until-warmer.py

writes common/src/main/resources/walkthroughs/days-until-warmer.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import driver_list, josa, plural, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move  # noqa: E402

SLUG = "days-until-warmer"

wt = Walkthrough(
    {"en": "Days Until Warmer", "ko": "기온이 오를 때까지 며칠?"},
    {"en": "A stack keeps the days still waiting, their readings falling from bottom to top: a warmer day pops "
           "every cooler day off the top, and each popped day's wait is the gap between the two days.",
     "ko": "아직 기다리는 날들을 스택에 두면 기온이 아래에서 위로 내려갑니다. 더 따뜻한 날이 오면 맨 위의 더 추운 날들을 "
           "꺼내고, 꺼낸 날의 wait는 두 날의 차이입니다."},
    views=[
        {"id": "readings", "type": "array", "title": {"en": "readings", "ko": "readings (기온)"}},
        {"id": "pending", "type": "array",
         "title": {"en": "pending stack (top on the right)", "ko": "기다리는 날 스택 (오른쪽이 맨 위)"}},
        {"id": "wait", "type": "array", "title": {"en": "wait", "ko": "wait (기다린 날수)"}},
    ],
)


def day_tag(d):
    return {"en": f"day {d}", "ko": f"{d}일차"}


def solve(readings, run):
    """Solution.daysUntilWarmer with a frame per pop and per push. Returns the answer as the Driver prints it."""
    n = len(readings)
    waits = [0] * n
    pending = []
    day = None

    def frame(caption, leaving=None, read_lit=(), stack_lit=(), stack_good=(), wait_good=(), wait_path=(),
              moves=None, **answer):
        shown = pending + ([leaving] if leaving is not None else [])
        run.frame(caption,
                  readings={"values": readings, "pointers": {"day": day},
                            "unread": list(range(day + 1, n)) if day is not None else [],
                            "marks": {"lit": list(read_lit)}},
                  pending={"values": [readings[d] for d in shown], "tags": [[p, day_tag(d)] for p, d in enumerate(shown)],
                           "marks": {"good": list(stack_good), "lit": list(stack_lit)}},
                  wait={"values": waits, "marks": {"path": list(wait_path), "good": list(wait_good)}},
                  moves=moves, **answer)

    frame({"en": f"{n} {plural(n, 'day', 'days')}. Every wait starts at 0, and the stack of days still waiting "
                 f"for a warmer reading starts empty.",
           "ko": f"{n}일입니다. wait는 모두 0에서 시작하고, 더 따뜻한 날을 기다리는 날들의 스택은 비어 있습니다."})
    for day, reading in enumerate(readings):
        while pending and readings[pending[-1]] < reading:
            earlier = pending.pop()
            waits[earlier] = day - earlier
            top = len(pending)
            frame({"en": f"Day {day}'s {reading} is warmer than day {earlier}'s {readings[earlier]} on top: pop day "
                         f"{earlier}, which waited {day} − {earlier} = {waits[earlier]} "
                         f"{plural(waits[earlier], 'day', 'days')}.",
                   "ko": f"{day}일차 {josa(reading, '은는')} 맨 위 {earlier}일차의 {readings[earlier]}보다 따뜻합니다. "
                         f"{earlier}일차를 꺼내며, 기다린 날수는 {day} − {earlier} = {waits[earlier]}일입니다."},
                  leaving=earlier, read_lit=[day], stack_lit=[top], wait_good=[earlier],
                  moves=[move(at("pending", top), at("wait", earlier), value=f"{day}−{earlier}")])
        if not pending:
            why = {"en": "The stack is empty", "ko": "스택이 비었으므로"}
        else:
            below = pending[-1]
            why = {"en": f"Day {below}'s {readings[below]} on top is not cooler than {reading}, so it stops there",
                   "ko": f"맨 위 {below}일차의 기온 {readings[below]}도 {reading}보다 낮지 않아 여기서 멈추므로"}
        pending.append(day)
        frame({"en": f"{why['en']}: push day {day} ({reading}) on top to wait for a warmer reading.",
               "ko": f"{why['ko']} {day}일차({reading})를 맨 위에 넣어 더 따뜻한 날을 기다리게 합니다."},
              stack_good=[len(pending) - 1],
              moves=[move(at("readings", day), at("pending", len(pending) - 1))])
    day = None
    left = ", ".join(str(d) for d in pending)
    frame({"en": f"Every day is read. Day{'s' if len(pending) > 1 else ''} {left} still on the stack never saw a "
                 f"warmer day, so {'their waits stay' if len(pending) > 1 else 'its wait stays'} 0: "
                 f"{driver_list(waits)}.",
           "ko": f"모든 날을 읽었습니다. 스택에 남은 {left}일차는 더 따뜻한 날을 만나지 못해 wait가 0으로 남습니다: "
                 f"{driver_list(waits)}."},
          stack_lit=range(len(pending)), wait_path=range(n), answer=driver_list(waits))


for number, sample in enumerate(sample_cases(SLUG), start=1):
    readings = json.loads(sample["input"])
    run = sample_run(wt, number, sample, input=f"readings = {sample['input']}")
    solve(readings, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
