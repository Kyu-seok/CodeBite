#!/usr/bin/env python3.12
"""cover-aquarium-zones' Walkthrough: the reference solution (scripts/replay-solutions/cover-aquarium-zones.py), a
greedy sweep over the zones by end that drops a pellet at the end of each zone the last pellet missed, recording one
frame per zone on each sample Test Case.

The sorted zones and the pellets are groups on one number line, as peak-table-demand places visits into tables: each
pellet is a group holding the zones it feeds, so the answer is how many pellet groups there are. The last pellet's
position is the one point on the axis, which each zone's start is compared with.

    CODEBITE_DB=<database> scripts/walkthroughs/cover-aquarium-zones.py

writes common/src/main/resources/walkthroughs/cover-aquarium-zones.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import driver_list, josa, plural, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move  # noqa: E402

SLUG = "cover-aquarium-zones"
SORTED = {"en": "zones, by end", "ko": "끝 순으로 정렬한 구간"}
LAST = {"en": "last pellet", "ko": "마지막 알갱이"}

wt = Walkthrough(
    {"en": "Cover Aquarium Zones", "ko": "수조 구역 덮기"},
    {"en": "Sort the zones by end. The zone ending first needs a pellet somewhere inside it, and its end is the spot "
           "that also reaches the most zones after it: drop one there, and skip every zone that pellet already feeds.",
     "ko": "구간을 끝 순으로 정렬합니다. 가장 먼저 끝나는 구간에는 반드시 알갱이가 하나 필요하고, 그 끝 위치가 뒤 "
           "구간까지 가장 많이 덮습니다. 거기에 알갱이를 두고, 그 알갱이가 이미 덮는 구간은 건너뜁니다."},
    views=[
        {"id": "line", "type": "intervals", "empty": {"en": "none yet", "ko": "아직 없음"}},
    ],
)


def pellet(p, x):
    return {"en": f"pellet {p + 1} at {x}", "ko": f"알갱이 {p + 1}: 위치 {x}"}


def solve(zones, run):
    """Solution.minPellets with a frame per zone. Returns the answer as the Driver prints it."""
    ordered = sorted(zones, key=lambda z: z[1])
    pellets = []  # (position, zones it feeds)
    last_drop = None

    def frame(caption, read=None, done=0, pellet_marks=None, point=True, moves=None, **answer):
        sorted_marks = {"dim": list(range(done))}
        if read is not None:
            sorted_marks["lit"] = [read]
        groups = [{"label": SORTED, "intervals": ordered, "marks": sorted_marks}]
        for p, (x, fed) in enumerate(pellets):
            groups.append({"label": pellet(p, x), "intervals": fed, "marks": (pellet_marks or {}).get(p, {})})
        line = {"groups": groups}
        if point and last_drop is not None:
            line["points"] = [{"at": last_drop, "label": LAST, "mark": "lit"}]
        run.frame(caption, line=line, moves=moves, **answer)

    listed = ", ".join(driver_list(z) for z in ordered)
    frame({"en": f"Sort the {len(ordered)} zones by end: {listed}. No pellet is dropped yet.",
           "ko": f"구간 {len(ordered)}개를 끝 순으로 정렬합니다: {listed}. 아직 알갱이가 없습니다."})
    for i, (start, end) in enumerate(ordered):
        zone = driver_list([start, end])
        if last_drop is None or start > last_drop:
            if last_drop is None:
                why_en, why_ko = "no pellet is down yet", "아직 알갱이가 없으므로"
            else:
                why_en = f"it starts at {start}, past the last pellet at {last_drop}, so nothing feeds it"
                why_ko = f"{start}에서 시작해 마지막 알갱이 위치 {last_drop}보다 뒤이므로 먹이를 못 받습니다. 그래서"
            last_drop = end
            pellets.append((end, [[start, end]]))
            p = len(pellets) - 1
            frame({"en": f"{zone}: {why_en}. Drop pellet {p + 1} at its end, {end}, as late as it can go.",
                   "ko": f"{zone} 구간: {why_ko} 끝 위치 {end}에 알갱이 {josa(p + 1, '을를')} 둡니다. 가장 늦게 "
                         "둘 수 있는 자리입니다."},
                  read=i, done=i, pellet_marks={p: {"good": [0]}},
                  moves=[move(at("line", [0, i]), at("line", [1 + p, 0]))])
        else:
            p = len(pellets) - 1
            fed = pellets[p][1]
            fed.append([start, end])
            frame({"en": f"{zone} starts at {start} ≤ the last pellet at {last_drop}, and ends at {end} ≥ it, since the "
                         f"zones are sorted by end: pellet {p + 1} already feeds it.",
                   "ko": f"{zone} 구간은 {start}에서 시작해 마지막 알갱이 위치 {last_drop} 이하이고, 끝 순으로 "
                         f"정렬했으니 끝 {end}도 그 이상입니다. 알갱이 {josa(p + 1, '이가')} 이미 덮습니다."},
                  read=i, done=i, pellet_marks={p: {"good": [len(fed) - 1]}},
                  moves=[move(at("line", [0, i]), at("line", [1 + p, len(fed) - 1]))])
    k = len(pellets)
    spots = ", ".join(str(x) for x, _ in pellets)
    frame({"en": f"Every zone is fed by {k} {plural(k, 'pellet', 'pellets')}, at {spots}. Answer: {k}.",
           "ko": f"알갱이 {k}개({spots})로 모든 구간이 먹이를 받습니다. 답은 {k}입니다."},
          done=len(ordered), point=False,
          pellet_marks={p: {"path": list(range(len(fed)))} for p, (_, fed) in enumerate(pellets)}, answer=str(k))


for number, sample in enumerate(sample_cases(SLUG), start=1):
    zones = json.loads(sample["input"])
    values = [v for z in zones for v in z]
    run = sample_run(wt, number, sample, input=f"zones = {sample['input']}",
                     setup={"line": {"domain": [min(values), max(values)]}})
    solve(zones, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
