#!/usr/bin/env python3.12
"""finish-the-level's Walkthrough: the reference solution (scripts/replay-solutions/finish-the-level.py), one
pass keeping the farthest tile reachable so far, recording one frame per tile read on each sample Test Case.
The reachable tiles are a span over jumps[0..farthest]; each tile read writes its own reach, tile + jump, under
it, and a reach that beats farthest moves from the tile to the tile it lands on.

    CODEBITE_DB=<database> scripts/walkthroughs/finish-the-level.py

writes common/src/main/resources/walkthroughs/finish-the-level.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import josa, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move, span  # noqa: E402

SLUG = "finish-the-level"

wt = Walkthrough(
    {"en": "Finish the Level", "ko": "레벨 끝까지 가기"},
    {"en": "Every tile up to the farthest reach so far can be landed on, so one pass is enough: on each reachable "
           "tile push the reach to tile + jump, and stop when a tile lies past it.",
     "ko": "지금까지의 최대 도달 거리 안의 타일은 모두 밟을 수 있으므로 한 번 훑으면 됩니다. 밟을 수 있는 타일마다 "
           "도달 거리를 타일 + 점프로 늘리고, 그 너머의 타일이 나오면 멈춥니다."},
    views=[
        {"id": "jumps", "type": "array", "title": {"en": "jumps by tile", "ko": "타일별 jumps (점프 거리)"}},
    ],
)


def solve(jumps, run):
    """Solution.canFinishLevel with a frame per tile read. Returns the answer as the Driver prints it."""
    n = len(jumps)
    last = n - 1
    farthest = 0
    reach = []  # [tile, text] under every tile read: how far a jump from it can land

    def frame(caption, tile=None, lit=(), good=(), bad=(), path=(), reach_mark=None, moves=None, **answer):
        end = min(farthest, last)
        run.frame(caption,
                  jumps={"values": jumps,
                         "pointers": {"tile": tile},
                         "under": reach,
                         "spans": {"reach": span(0, end, {"en": f"farthest {farthest}", "ko": f"최대 도달 {farthest}"},
                                                 mark=reach_mark, fade=True)},
                         "marks": {"path": list(path), "bad": list(bad), "good": list(good), "lit": list(lit)}},
                  moves=moves, **answer)

    frame({"en": f"{n} tiles, the last is tile {last}. Start on tile 0, so the farthest tile reachable so far is 0.",
           "ko": f"타일이 {n}개이고 마지막은 타일 {last}입니다. 타일 0에서 출발하므로 지금까지 도달할 수 있는 가장 먼 "
                 f"타일은 0입니다."},
          lit=[0])
    for tile, jump in enumerate(jumps):
        if tile > farthest:
            frame({"en": f"Tile {tile} lies past the farthest reach, {farthest}: no tile before it can jump this far, "
                         "so the last tile can't be reached either. Answer: false.",
                   "ko": f"타일 {josa(tile, '은는')} 최대 도달 거리 {farthest}보다 멀어서, 앞의 어느 "
                         "타일에서도 여기까지 뛸 수 없습니다. 그러니 마지막 타일에도 갈 수 없어 답은 false입니다."},
                  tile=tile, bad=range(tile, n), reach_mark="bad", answer="false")
            return
        lands = tile + jump
        reach.append([tile, f"→{lands}"])
        if lands > farthest:
            before = farthest
            farthest = lands
            lands_on = min(lands, last)
            past = "" if lands <= last else {"en": f", past the last tile {last}", "ko": f"(마지막 타일 {last} 너머)"}
            frame({"en": f"Tile {tile} is reachable and jumps up to {jump}: {tile} + {jump} = {lands} beats {before}, "
                         f"so the farthest reach grows to {lands}{past and past['en']}.",
                   "ko": f"타일 {tile}에는 갈 수 있고 최대 {jump}칸 뜁니다: {tile} + {jump} = {lands} > {before}이므로 "
                         f"최대 도달 거리가 {josa(lands, '(으)로')} 늘어납니다{past and past['ko']}."},
                  tile=tile, lit=[tile], good=[lands_on], reach_mark="good",
                  moves=[move(at("jumps", tile), at("jumps", lands_on), value=f"{tile}+{jump}")])
        else:
            frame({"en": f"Tile {tile} is reachable, but {tile} + {jump} = {lands} doesn't pass {farthest}: "
                         "the farthest reach stays.",
                   "ko": f"타일 {tile}에는 갈 수 있지만 {tile} + {jump} = {josa(lands, '은는')} "
                         f"{farthest}보다 멀지 않아 최대 도달 거리는 그대로입니다."},
                  tile=tile, lit=[tile])
    frame({"en": f"Every tile was within reach, and the farthest reach, {farthest}, covers the last tile {last}. "
                 "Answer: true.",
           "ko": f"모든 타일이 도달 거리 안에 있었고, 최대 도달 거리 {josa(farthest, '이가')} "
                 f"마지막 타일 {last}까지 닿습니다. 답은 true입니다."},
          path=[last], reach_mark="path", answer="true")


for number, sample in enumerate(sample_cases(SLUG), start=1):
    jumps = json.loads(sample["input"])
    run = sample_run(wt, number, sample, input=f"jumps = {sample['input']}")
    solve(jumps, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
