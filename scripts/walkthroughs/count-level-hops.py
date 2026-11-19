#!/usr/bin/env python3.12
"""count-level-hops' Walkthrough: the reference solution (scripts/replay-solutions/count-level-hops.py), two
rolling values, the jump sequences reaching the level before and the level reached, recording one frame per level
on each sample Test Case.

The levels are an array from 0 to n, each filled with its count of sequences when the loop reaches it. The two
values the solution keeps are the two cells tagged `previous` and `current`; the levels behind them fade, since the
solution has forgotten them. Each new level's count moves in from the two cells it adds.

    CODEBITE_DB=<database> scripts/walkthroughs/count-level-hops.py

writes common/src/main/resources/walkthroughs/count-level-hops.json.
"""
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import plural, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move  # noqa: E402

SLUG = "count-level-hops"
UNSEEN = "?"

wt = Walkthrough(
    {"en": "Count Level Hops", "ko": "레벨 뛰는 경우의 수"},
    {"en": "The last jump onto a level is 1 or 2 levels long, so its sequences are those of the level before plus "
           "those of the level two before. Only those two counts need keeping.",
     "ko": "어떤 레벨에 닿는 마지막 점프는 1레벨 또는 2레벨이므로, 그 레벨의 점프 순서 수는 바로 앞 레벨의 수와 두 "
           "레벨 앞의 수를 더한 값입니다. 그 두 수만 들고 가면 됩니다."},
    views=[
        {"id": "ways", "type": "array",
         "title": {"en": "jump sequences reaching each level", "ko": "레벨별 점프 순서의 수"}},
    ],
)
PREVIOUS = {"en": "previous", "ko": "이전"}
CURRENT = {"en": "current", "ko": "현재"}


def solve(n, run):
    """Solution.countHopSequences with a frame per level. Returns the answer as the Driver prints it."""
    ways = [1, 1] + [UNSEEN] * (n - 1)

    def frame(caption, level, marks=None, moves=None, **answer):
        tags = [[level, CURRENT]] if level == 0 else [[level - 1, PREVIOUS], [level, CURRENT]]
        run.frame(caption,
                  ways={"values": ways[:n + 1], "tags": tags, "marks": {"dim": list(range(level - 1)), **(marks or {})},
                        "unread": list(range(level + 1, n + 1))},
                  moves=moves, **answer)

    frame({"en": f"Level 0 is the start: 1 way, no jumps. Level 1 is reached only by one jump of 1, so 1 way, "
                 f"and the goal is level {n}.",
           "ko": f"레벨 0은 출발점이라 점프 없이 1가지입니다. 레벨 1은 1레벨 점프 한 번으로만 가므로 1가지이고, "
                 f"목표는 레벨 {n}입니다."},
          1, marks={"good": [0, 1]})
    previous, current = 1, 1
    for level in range(2, n + 1):
        before_two, before_one = previous, current
        previous, current = current, previous + current
        ways[level] = current
        frame({"en": f"Level {level}: a jump of 1 from level {level - 1} ({before_one} {plural(before_one, "way", "ways")}) or a jump of 2 from "
                     f"level {level - 2} ({before_two}), so {before_one} + {before_two} = {current}.",
               "ko": f"레벨 {level}: 레벨 {level - 1}에서 1레벨 점프({before_one}가지), 또는 레벨 "
                     f"{level - 2}에서 2레벨 점프({before_two}가지)이므로 {before_one} + {before_two} = "
                     f"{current}입니다."},
              level, marks={"lit": [level - 2, level - 1], "good": [level]},
              moves=[move(at("ways", level - 1), at("ways", level), value=str(before_one)),
                     move(at("ways", level - 2), at("ways", level), value=str(before_two))])
    frame({"en": f"Level {n} is reached: {current} jump sequences land exactly on it. Answer: {current}.",
           "ko": f"레벨 {n}에 닿았고, 정확히 레벨 {n}에 도착하는 점프 순서는 {current}가지입니다. "
                 f"답은 {current}입니다."},
          n, marks={"path": [n]}, answer=str(current))


for number, sample in enumerate(sample_cases(SLUG), start=1):
    n = int(sample["input"])
    run = sample_run(wt, number, sample, input=f"n = {n}")
    solve(n, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
