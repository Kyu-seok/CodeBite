#!/usr/bin/env python3.12
"""brawler-lane-collision's Walkthrough: the reference solution
(scripts/replay-solutions/brawler-lane-collision.py), a stack of the fighters still standing read left to right,
recording one frame per collision and one per fighter pushed on each sample Test Case. The stack is drawn upright on
a fixed base, each fighter tagged with its index: a fighter that stands moves from its cell onto the top, and a
left-mover meeting a right-mover on top knocks out the weaker, which leaves the stack (or its cell) marked bad.

    CODEBITE_DB=<database> scripts/walkthroughs/brawler-lane-collision.py

writes common/src/main/resources/walkthroughs/brawler-lane-collision.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import driver_list, josa, plural, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move, stack  # noqa: E402

SLUG = "brawler-lane-collision"

wt = Walkthrough(
    {"en": "Brawler Lane Collision", "ko": "투사 차선 충돌"},
    {"en": "Read the fighters left to right, keeping those still standing on a stack. Only a left-mover arriving "
           "while a right-mover is on top collides: the weaker is knocked out, and a winning left-mover keeps "
           "fighting down the stack.",
     "ko": "투사를 왼쪽부터 읽으며 살아남은 투사를 스택에 쌓습니다. 맨 위가 오른쪽으로 가는 투사일 때 왼쪽으로 가는 투사가 "
           "오면 충돌해 약한 쪽이 쓰러지고, 이긴 왼쪽 투사는 스택 아래로 계속 싸웁니다."},
    views=[
        {"id": "fighters", "type": "array", "title": {"en": "fighters", "ko": "fighters (투사)"}},
        {"id": "standing", "type": "stack", "title": {"en": "standing", "ko": "살아남은 투사"},
         "empty": {"en": "empty", "ko": "비어 있음"}},
    ],
)


def direction(v):
    return "→" if v > 0 else "←"


def solve(fighters, run):
    """Solution.resolveLaneCrashes with a frame per collision and per push. Returns the answer as the Driver
    prints it."""
    n = len(fighters)
    tags = [[j, direction(v)] for j, v in enumerate(fighters)]
    standing = []  # indexes of the fighters standing, bottom first (the solution keeps their powers)
    out = []
    i = None

    def frame(caption, leaving=None, lit=(), bad=(), path=(), stand_marks=None, moves=None, **answer):
        shown = standing + ([leaving] if leaving is not None else [])
        run.frame(caption,
                  fighters={"values": fighters, "tags": tags, "pointers": {"i": i},
                            "unread": list(range(i + 1, n)) if i is not None else [],
                            "marks": {"dim": list(out), "path": list(path), "bad": list(bad), "lit": list(lit)}},
                  standing={**stack(shown, value=lambda j: fighters[j], tag=lambda j: f"[{j}]"),
                            "marks": stand_marks or {}},
                  moves=moves, **answer)

    frame({"en": f"{n} {plural(n, 'fighter', 'fighters')}: a positive power moves right (→), a negative one left (←). "
                 f"The stack of fighters still standing starts empty.",
           "ko": f"투사 {n}명입니다. 힘이 양수면 오른쪽(→), 음수면 왼쪽(←)으로 갑니다. 살아남은 투사의 스택은 비어 "
                 f"있습니다."})
    for i, fighter in enumerate(fighters):
        alive = True
        while alive and fighter < 0 and standing and fighters[standing[-1]] > 0:
            j = standing[-1]
            top = len(standing) - 1
            rival = fighters[j]
            meet = {"en": f"fighters[{i}] = {fighter} moves left into {rival} on top, moving right",
                    "ko": f"왼쪽으로 가는 fighters[{i}] = {fighter}, 오른쪽으로 가는 맨 위의 {rival}: 둘이 충돌합니다"}
            if rival < -fighter:
                standing.pop()
                out.append(j)
                frame({"en": f"{meet['en']}: {rival} is weaker than {-fighter} and is knocked out.",
                       "ko": f"{meet['ko']}. {josa(rival, '이가')} {-fighter}보다 약해 쓰러집니다."},
                      leaving=j, lit=[i], bad=[j], stand_marks={"bad": [top]},
                      moves=[move(at("standing", top))])
            elif rival == -fighter:
                standing.pop()
                alive = False
                out += [j, i]
                frame({"en": f"{meet['en']}: both have power {rival}, so both are knocked out.",
                       "ko": f"{meet['ko']}. 세기가 {josa(rival, '(으)로')} 같아 둘 다 쓰러집니다."},
                      leaving=j, bad=[i, j], stand_marks={"bad": [top]},
                      moves=[move(at("standing", top))])
            else:
                alive = False
                out.append(i)
                frame({"en": f"{meet['en']}: {rival} is stronger than {-fighter}, so {fighter} is knocked out and "
                             f"{rival} stays.",
                       "ko": f"{meet['ko']}. {josa(rival, '이가')} {-fighter}보다 세서 {josa(fighter, '이가')} 쓰러지고 "
                             f"{josa(rival, '은는')} 남습니다."},
                      bad=[i], stand_marks={"lit": [top]})
        if not alive:
            continue
        if fighter > 0:
            why = {"en": "moves right, so nothing it has passed can meet it", "ko": "오른쪽으로 가므로 지나온 투사와 만나지 않습니다"}
        elif not standing:
            why = {"en": "moves left and nobody standing is ahead of it", "ko": "왼쪽으로 가지만 앞에 살아남은 투사가 없습니다"}
        else:
            why = {"en": f"moves left, and the top, {fighters[standing[-1]]}, moves left too, so they never meet",
                   "ko": f"왼쪽으로 가고 맨 위의 {fighters[standing[-1]]}도 왼쪽으로 가므로 만나지 않습니다"}
        standing.append(i)
        frame({"en": f"fighters[{i}] = {fighter} {why['en']}: push it on top, still standing.",
               "ko": f"fighters[{i}] = {fighter}: {why['ko']}. 살아남은 투사로 맨 위에 넣습니다."},
              lit=[i], stand_marks={"good": [len(standing) - 1]},
              moves=[move(at("fighters", i), at("standing", len(standing) - 1))])
    i = None
    result = [fighters[j] for j in standing]
    printed = driver_list(result)
    k = len(standing)
    frame({"en": f"Every fighter is read: {k} {plural(k, 'is', 'are')} still standing, bottom to top in their "
                 f"left-to-right order: {printed}.",
           "ko": f"모든 투사를 읽었습니다. 살아남은 {k}명이 스택 아래부터 원래 왼쪽부터의 순서대로 있습니다: {printed}."},
          path=standing, stand_marks={"path": list(range(k))}, answer=printed)
    return printed


for number, sample in enumerate(sample_cases(SLUG), start=1):
    fighters = json.loads(sample["input"])
    run = sample_run(wt, number, sample, input=f"fighters = {sample['input']}")
    solve(fighters, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
