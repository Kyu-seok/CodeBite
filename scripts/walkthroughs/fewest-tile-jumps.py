#!/usr/bin/env python3.12
"""fewest-tile-jumps' Walkthrough: the reference solution (scripts/replay-solutions/fewest-tile-jumps.py), one pass
keeping the farthest tile reachable so far and counting a jump each time the read reaches the end of the tiles the
jumps so far can land on, recording one frame per tile read and one per jump on each sample Test Case.

The tiles each jump count can land on are spans below the tiles (`start`, `jump 1`, `jump 2`…), so the answer is how
many jump spans there are. The farthest reach is a span above, as in finish-the-level: each tile read writes its own
reach under it, and a reach that grows moves from the tile to the tile it lands on.

    CODEBITE_DB=<database> scripts/walkthroughs/fewest-tile-jumps.py

writes common/src/main/resources/walkthroughs/fewest-tile-jumps.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import josa, plural, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move, span  # noqa: E402

SLUG = "fewest-tile-jumps"

wt = Walkthrough(
    {"en": "Fewest Tile Jumps", "ko": "타일 최소 점프"},
    {"en": "Read the tiles in order, keeping how far any tile read so far can reach. The tiles one more jump can land "
           "on end at that reach, so when the read passes the last tile the jumps so far can land on, count a jump "
           "and move that end out to the farthest reach.",
     "ko": "타일을 차례로 읽으며 지금까지 읽은 타일에서 닿는 가장 먼 곳을 기억합니다. 점프를 한 번 더 하면 그곳까지 "
           "내려설 수 있으므로, 지금까지의 점프로 내려설 수 있는 마지막 타일을 읽으면 점프를 하나 세고 그 끝을 가장 먼 "
           "곳으로 옮깁니다."},
    views=[
        {"id": "tiles", "type": "array", "title": {"en": "maxJump by tile", "ko": "타일별 maxJump (최대 점프)"}},
    ],
)


def solve(max_jump, run):
    """Solution.minJumps with a frame per tile read and per jump. Returns the answer as the Driver prints it."""
    n = len(max_jump)
    last = n - 1
    jumps = 0
    current_end = 0
    farthest = 0
    reach = []  # [tile, text] under every tile read: how far a jump from it can land
    layers = {"start": span(0, 0, {"en": "start", "ko": "출발"}, below=True)}

    def frame(caption, i=None, lit=(), good=(), path=(), reach_mark=None, show_reach=True, moves=None, **answer):
        spans = dict(layers)
        if show_reach:
            spans["reach"] = span(0, min(farthest, last), {"en": f"farthest {farthest}", "ko": f"최대 도달 {farthest}"},
                                  mark=reach_mark)
        run.frame(caption,
                  tiles={"values": max_jump, "pointers": {"i": i}, "under": list(reach), "spans": spans,
                         "marks": {"path": list(path), "good": list(good), "lit": list(lit)}},
                  moves=moves, **answer)

    frame({"en": f"{n} tiles, the last is tile {last}. You stand on tile 0 with 0 jumps made, and the farthest reach so "
                 "far is 0.",
           "ko": f"타일이 {n}개이고 마지막은 타일 {last}입니다. 점프 0번으로 타일 0에 서 있고, 지금까지의 최대 도달 "
                 "거리는 0입니다."},
          lit=[0])
    for i in range(n - 1):
        jump = max_jump[i]
        lands = i + jump
        reach.append([i, f"→{lands}"])
        if lands > farthest:
            before = farthest
            farthest = lands
            frame({"en": f"Tile {i} jumps up to {jump}: {i} + {jump} = {lands} beats {before}, so the farthest reach "
                         f"grows to {lands}.",
                   "ko": f"타일 {i}에서는 최대 {jump}칸 뜁니다: {i} + {jump} = {lands} > {before}이므로 최대 도달 거리가 "
                         f"{josa(lands, '(으)로')} 늘어납니다."},
                  i=i, lit=[i], good=[min(lands, last)], reach_mark="good",
                  moves=[move(at("tiles", i), at("tiles", min(lands, last)), value=f"{i}+{jump}")])
        else:
            frame({"en": f"Tile {i} jumps up to {jump}: {i} + {jump} = {lands} doesn't pass {farthest}, so the "
                         "farthest reach stays.",
                   "ko": f"타일 {i}에서는 최대 {jump}칸 뜁니다: {i} + {jump} = {josa(lands, '은는')} {farthest}보다 "
                         "멀지 않아 최대 도달 거리는 그대로입니다."},
                  i=i, lit=[i])
        if i == current_end:
            jumps += 1
            first = current_end + 1
            current_end = farthest
            to = min(current_end, last)
            layers[f"jump{jumps}"] = span(first, to, {"en": f"jump {jumps}", "ko": f"점프 {jumps}"}, below=True,
                                          mark="good")
            lands_en = f"tile {to}" if first == to else f"tiles {first} to {to}"
            lands_ko = f"타일 {to}" if first == to else f"타일 {first}부터 {to}까지"
            if jumps == 1:
                en = (f"Tile 0 is the only tile 0 jumps reach, and it is read: jump 1 can land on {lands_en}, up to "
                      f"the farthest reach.")
                ko = (f"점프 0번으로 닿는 타일은 타일 0뿐이고 다 읽었습니다. 점프 1번이면 최대 도달 거리까지, 곧 "
                      f"{lands_ko} 내려설 수 있습니다.")
            else:
                en = (f"Tile {i} is the last tile {jumps - 1} {plural(jumps - 1, 'jump', 'jumps')} can land on, so "
                      f"every tile they reach has been read: jump {jumps} can land on {lands_en}.")
                ko = (f"타일 {josa(i, '은는')} 점프 {jumps - 1}번으로 내려설 수 있는 마지막 타일이라 그 안의 타일을 "
                      f"다 읽었습니다. 점프 {jumps}번이면 {lands_ko} 내려설 수 있습니다.")
            frame({"en": en, "ko": ko}, i=i, lit=[i], good=[to],
                  moves=[move(at("tiles", i), at("tiles", to), value="+1")])
            layers[f"jump{jumps}"] = span(first, to, {"en": f"jump {jumps}", "ko": f"점프 {jumps}"}, below=True)
    for name in layers:
        if name != "start":
            layers[name]["mark"] = "path"
    if jumps:
        en = (f"The read stops before the last tile, {last}, which jump {jumps}'s tiles include: the fewest jumps is "
              f"{jumps}. Answer: {jumps}.")
        ko = (f"마지막 타일 {last} 앞에서 읽기를 멈추고, 타일 {josa(last, '은는')} 점프 {jumps}번으로 내려설 수 있는 "
              f"타일에 들어 있습니다. 최소 점프는 {jumps}번이고 답은 {jumps}입니다.")
    else:
        en, ko = "The level is one tile, and you are already on it. Answer: 0.", "타일이 하나뿐이라 이미 도착했습니다. 답은 0입니다."
    frame({"en": en, "ko": ko}, path=[last], show_reach=False, answer=str(jumps))


for number, sample in enumerate(sample_cases(SLUG), start=1):
    max_jump = json.loads(sample["input"])
    run = sample_run(wt, number, sample, input=f"maxJump = {sample['input']}")
    solve(max_jump, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
