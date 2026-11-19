#!/usr/bin/env python3.12
"""combine-bags-to-match-target's Walkthrough: the reference solution
(scripts/replay-solutions/combine-bags-to-match-target.py), one pass over the bags that skips any bag with a reading
above target's and notes, for each position, whether a usable bag hits target's reading there, recording one frame
per bag on each sample Test Case.

The bags are a `table`, one row per bag (an `array` cell can't hold a triple), target an `array` of its three
readings, and `reached` an `array` of three marks that each usable bag's matching reading moves into. A bag over the
target in any position is dimmed, its reading over the cap `bad`.

    CODEBITE_DB=<database> scripts/walkthroughs/combine-bags-to-match-target.py

writes common/src/main/resources/walkthroughs/combine-bags-to-match-target.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import josa, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move  # noqa: E402

SLUG = "combine-bags-to-match-target"

wt = Walkthrough(
    {"en": "Combine Bags to Match Target", "ko": "봉투를 합쳐 목표 맞추기"},
    {"en": "Combining takes the largest reading in each position, so taking every bag that stays within target never "
           "hurts. Skip the bags over target anywhere; the rest match target exactly when each position's target "
           "reading appears in one of them.",
     "ko": "합치면 자리마다 가장 큰 값을 가지므로, target을 넘지 않는 봉투는 모두 골라도 손해가 없습니다. 어느 자리든 "
           "target을 넘는 봉투는 건너뛰고, 남은 봉투들 중 어딘가에 자리마다 target의 값이 있으면 정확히 target이 "
           "됩니다."},
    views=[
        {"id": "bags", "type": "table", "title": {"en": "bags", "ko": "bags (봉투)"}},
        {"id": "target", "type": "array", "title": {"en": "target", "ko": "target (목표)"}},
        {"id": "reached", "type": "array",
         "title": {"en": "reached: target's reading hit by a usable bag", "ko": "reached: 쓸 수 있는 봉투가 target 값에 닿음"}},
    ],
)

NO, YES = "✗", "✓"


def solve(bags, target, run):
    """Solution.canMatchTarget with a frame per bag. Returns the answer as the Driver prints it."""
    reached = [False, False, False]
    first_hit = [None, None, None]  # the bag that first reached each position
    blocked = []  # rows of bags over target

    def frame(caption, row=None, cells=None, target_marks=None, reached_marks=None, moves=None, **answer):
        marks = {"dim": [[r, c] for r in blocked for c in range(3) if r != row]}
        for k, v in (cells or {}).items():
            marks[k] = v
        run.frame(caption,
                  bags={"columns": ["[0]", "[1]", "[2]"],
                        "rows": [{"label": {"en": f"bag {r}", "ko": f"봉투 {r}"}, "cells": list(b)}
                                 for r, b in enumerate(bags)],
                        "marks": marks},
                  target={"values": target, "marks": target_marks or {}},
                  reached={"values": [YES if x else NO for x in reached], "marks": reached_marks or {}},
                  moves=moves, **answer)

    t = json.dumps(target, separators=(",", ":"))
    frame({"en": f"{len(bags)} bags and target {t}. No position has been reached yet.",
           "ko": f"봉투가 {len(bags)}개이고 target은 {t}입니다. 아직 닿은 자리가 없습니다."})
    for r, bag in enumerate(bags):
        b = json.dumps(bag, separators=(",", ":"))
        over = [c for c in range(3) if bag[c] > target[c]]
        if over:
            blocked.append(r)
            c = over[0]
            frame({"en": f"Bag {r}, {b}: {bag[c]} in position {c} is above target's {target[c]}, so any group with "
                         "it is too large there. Skip it.",
                   "ko": f"봉투 {r} {b}: {c}번 자리의 {josa(bag[c], '이가')} target의 {target[c]}보다 커서, 이 봉투가 "
                         "들어간 묶음은 그 자리가 너무 커집니다. 건너뜁니다."},
                  row=r, cells={"bad": [[r, c] for c in over], "lit": [[r, c] for c in range(3) if c not in over]},
                  target_marks={"bad": over})
            continue
        hits = [c for c in range(3) if bag[c] == target[c]]
        for c in hits:
            reached[c] = True
            if first_hit[c] is None:
                first_hit[c] = r
        moves = [move(at("bags", [r, c]), at("reached", c), value=YES) for c in hits]
        if hits:
            where_en = " and ".join(str(c) for c in hits)
            where_ko = ", ".join(str(c) for c in hits)
            en = (f"Bag {r}, {b}, stays within target, so take it: it hits target's reading in "
                  f"{'position' if len(hits) == 1 else 'positions'} {where_en}.")
            ko = f"봉투 {r} {b}: target을 넘지 않으니 고릅니다. {where_ko}번 자리에서 target 값에 닿습니다."
        else:
            en = f"Bag {r}, {b}, stays within target, so take it, though it hits no target reading."
            ko = f"봉투 {r} {b}: target을 넘지 않으니 고르지만, target 값에 닿는 자리는 없습니다."
        frame({"en": en, "ko": ko}, row=r,
              cells={"good": [[r, c] for c in hits], "lit": [[r, c] for c in range(3) if c not in hits]},
              target_marks={"lit": hits}, reached_marks={"good": hits}, moves=moves)
    if all(reached):
        users = sorted(set(first_hit))
        names = ", ".join(str(u) for u in users)
        frame({"en": f"Every position is reached: combining the usable bags gives exactly {t} (bags {names} alone "
                     "already do). Answer: true.",
               "ko": f"모든 자리에 닿았으므로 쓸 수 있는 봉투를 합치면 정확히 target {t} 값이 됩니다(봉투 {names}만으로도 "
                     "됩니다). 답은 true입니다."},
              cells={"path": [[first_hit[c], c] for c in range(3)]}, target_marks={"path": [0, 1, 2]},
              reached_marks={"path": [0, 1, 2]}, answer="true")
    else:
        missing = [c for c in range(3) if not reached[c]]
        where = ", ".join(str(c) for c in missing)
        frame({"en": f"No usable bag reaches target in {'position' if len(missing) == 1 else 'positions'} {where}, so no group can match {t}. Answer: false.",
               "ko": f"{where}번 자리에서 target 값에 닿는 쓸 수 있는 봉투가 없으므로 target {t} 값을 만들 수 없습니다. "
                     "답은 false입니다."},
              target_marks={"bad": missing}, reached_marks={"bad": missing}, answer="false")


for number, sample in enumerate(sample_cases(SLUG), start=1):
    bags_line, target_line = sample["input"].split("\n")
    bags, target = json.loads(bags_line), json.loads(target_line)
    run = sample_run(wt, number, sample, input=f"bags = {bags_line}, target = {target_line}")
    solve(bags, target, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
