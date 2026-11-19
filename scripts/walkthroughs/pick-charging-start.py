#!/usr/bin/env python3.12
"""pick-charging-start's Walkthrough: the reference solution (scripts/replay-solutions/pick-charging-start.py), a
check that the charges cover the drives in all, then one pass keeping the battery from the current start, which
moves past any stop where the battery would go below 0, recording one frame per stop on each sample Test Case.

The totals are spans over energy and drain. The battery after each stop's drive is a `tank` array filled stop by
stop, each cell moving in from that stop's charge and drain and the cell before it; the drive from the current start
is a span over it with a `start` pointer. Neither sample moves the start, so an extra run does.

    CODEBITE_DB=<database> scripts/walkthroughs/pick-charging-start.py

writes common/src/main/resources/walkthroughs/pick-charging-start.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import josa, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move, span  # noqa: E402

SLUG = "pick-charging-start"

wt = Walkthrough(
    {"en": "Pick Charging Start", "ko": "출발 휴게소 고르기"},
    {"en": "If the charges cover the drives in all, some start works. Drive from stop 0; whenever the battery would go "
           "below 0, no stop up to here can be the start, so start again from the next stop with an empty battery.",
     "ko": "충전량의 합이 운전에 드는 양의 합 이상이면 출발할 수 있는 휴게소가 있습니다. 휴게소 0부터 달리다가 배터리가 "
           "0 미만이 되면 여기까지의 어느 휴게소도 출발점이 될 수 없으므로, 다음 휴게소에서 빈 배터리로 다시 출발합니다."},
    views=[
        {"id": "energy", "type": "array", "title": {"en": "energy (charge at each stop)", "ko": "energy (휴게소별 충전량)"}},
        {"id": "drain", "type": "array", "title": {"en": "drain (drive to the next stop)", "ko": "drain (다음 휴게소까지 소모량)"}},
        {"id": "tank", "type": "array", "title": {"en": "battery after the drive", "ko": "운전 후 배터리"}},
    ],
)


def solve(energy, drain, run):
    """Solution.pickStartStop with a frame for the totals and one per stop. Returns the answer as the Driver prints it."""
    n = len(energy)
    tank_cells = [""] * n
    total_in, total_out = sum(energy), sum(drain)
    start = 0
    tank = 0
    dead = []  # tank cells of starts given up

    def frame(caption, i=None, totals=None, totals_mark=None, drive_to=None, drive_mark=None, lit=(), good=(),
              bad=(), path=(), moves=None, **answer):
        e_spans, d_spans, t_spans = {}, {}, {}
        if totals:
            e_spans["total"] = span(0, n - 1, {"en": f"total {total_in}", "ko": f"합 {total_in}"}, mark=totals_mark)
            d_spans["total"] = span(0, n - 1, {"en": f"total {total_out}", "ko": f"합 {total_out}"}, mark=totals_mark)
        if drive_to is not None:
            t_spans["drive"] = span(start, drive_to, {"en": f"from stop {start}", "ko": f"휴게소 {start}부터"},
                                    mark=drive_mark)
        read = [i] if i is not None else []
        run.frame(caption,
                  energy={"values": energy, "pointers": {"i": i}, "spans": e_spans,
                          "marks": {"lit": read, "path": list(path)}},
                  drain={"values": drain, "spans": d_spans, "marks": {"lit": read}},
                  tank={"values": tank_cells, "pointers": {"start": start if start < n else None}, "spans": t_spans,
                        "unread": [j for j in range(n) if tank_cells[j] == ""],
                        "marks": {"dim": list(dead), "path": list(path), "bad": list(bad), "good": list(good),
                                  "lit": list(lit)}},
                  moves=moves, **answer)

    frame({"en": f"{n} stops on the loop. The battery starts empty at the stop you pick.",
           "ko": f"순환 도로에 휴게소가 {n}개 있습니다. 고른 휴게소에서 빈 배터리로 출발합니다."})
    if total_in < total_out:
        frame({"en": f"The stops charge {total_in} in all, but the drives use {total_out}: whichever stop you start "
                     "from, the battery goes below 0 before the loop ends. Answer: -1.",
               "ko": f"충전량은 모두 합쳐 {total_in}인데 운전에 {total_out}만큼 듭니다. 어느 휴게소에서 출발해도 한 "
                     "바퀴를 돌기 전에 배터리가 0 미만이 되므로 답은 -1입니다."},
              totals=True, totals_mark="bad", answer="-1")
        return
    frame({"en": f"The stops charge {total_in} in all and the drives use {total_out}, no more, so some start works. "
                 "Try stop 0 first.",
           "ko": f"충전량은 모두 합쳐 {total_in}이고 운전에는 {total_out}만큼 들어 충전량이 모자라지 않으므로, 출발할 수 "
                 "있는 휴게소가 있습니다. 먼저 휴게소 0부터 달려 봅니다."},
          totals=True, totals_mark="good")
    for i, (gain, use) in enumerate(zip(energy, drain)):
        before = tank
        tank += gain - use
        tank_cells[i] = tank
        moves = [move(at("energy", i), at("tank", i), value=f"+{gain}"),
                 move(at("drain", i), at("tank", i), value=f"−{use}")]
        if i > start:
            moves.insert(0, move(at("tank", i - 1), at("tank", i), value=str(before)))
        sums = f"{before} + {gain} − {use} = {tank}"
        sums_ko = f"{before} + {gain} − {use} = {josa(tank, '(으)로')}"
        if tank < 0:
            frame({"en": f"Stop {i}: {sums}, below 0. The drive from stop {start} fails here.",
                   "ko": f"휴게소 {i}: {sums_ko} 0 미만입니다. 휴게소 {start}에서 출발하면 여기서 멈춥니다."},
                  i=i, drive_to=i, drive_mark="bad", bad=[i], moves=moves)
            dead.extend(range(start, i + 1))
            old = start
            start = i + 1
            tank = 0
            if old == i:
                why_en = f"Stop {i} can't even reach the next stop on its own"
                why_ko = f"휴게소 {josa(i, '은는')} 혼자서도 다음 휴게소까지 갈 수 없으니"
            else:
                stops_en = f"Stop {i} was" if old + 1 == i else f"Each stop from {old + 1} to {i} was"
                stops_ko = f"휴게소 {josa(i, '은는')}" if old + 1 == i else f"휴게소 {old + 1}부터 {i}까지는"
                why_en = f"{stops_en} reached with a battery of 0 or more, so starting there empty is no better"
                why_ko = f"{stops_ko} 0 이상의 배터리를 들고 도착했으므로, 거기서 빈 배터리로 출발해도 나을 게 없으니"
            frame({"en": f"{why_en}: start again from stop {start} with an empty battery.",
                   "ko": f"{why_ko} 휴게소 {start}에서 빈 배터리로 다시 출발합니다."},
                  moves=[move(at("tank", i), at("tank", start), value="0", mark="bad")])
        else:
            frame({"en": f"Stop {i}: {sums}, not below 0, so the drive from stop {start} goes on.",
                   "ko": f"휴게소 {i}: {sums_ko} 0 미만이 아니므로 휴게소 {start}에서 출발한 운전이 이어집니다."},
                  i=i, drive_to=i, good=[i], moves=moves)
    deficit = sum(energy[:start]) - sum(drain[:start])
    if start:
        tail_en = (f", and the {tank} left there covers the {-deficit} the stops before it run short (the totals "
                   "said it would)")
        tail_ko = (f", 끝에 남은 {josa(tank, '이가')} 앞 휴게소들에서 모자란 {josa(-deficit, '을를')} 메웁니다(전체 "
                   "합이 보장합니다)")
    else:
        tail_en = tail_ko = ""
    frame({"en": f"From stop {start} the battery never went below 0 to the end of the road{tail_en}. Answer: {start}."
           if start else
           f"From stop 0 the battery never went below 0 around the whole loop. Answer: 0.",
           "ko": f"휴게소 {start}부터 도로 끝까지 배터리가 0 미만이 된 적이 없고{tail_ko}. 답은 {start}입니다."
           if start else "휴게소 0에서 출발해 한 바퀴를 도는 동안 배터리가 0 미만이 된 적이 없습니다. 답은 0입니다."},
          drive_to=n - 1, drive_mark="path", path=range(start, n), answer=str(start))


for number, sample in enumerate(sample_cases(SLUG), start=1):
    energy_line, drain_line = sample["input"].split("\n")
    energy, drain = json.loads(energy_line), json.loads(drain_line)
    run = sample_run(wt, number, sample, input=f"energy = {energy_line}, drain = {drain_line}")
    solve(energy, drain, run)

# Neither sample moves the start (example 2 stops at the totals), so this extra run gives up two starts.
energy, drain = [2, 3, 1, 6, 4], [3, 1, 4, 2, 3]
run = wt.run({"en": "Extra: the start moves", "ko": "추가: 출발점이 바뀜"},
             input=f"energy = {json.dumps(energy, separators=(',', ':'))}, drain = {json.dumps(drain, separators=(',', ':'))}",
             expected="3", extra=True)
solve(energy, drain, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
