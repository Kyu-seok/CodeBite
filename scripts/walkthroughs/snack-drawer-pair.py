#!/usr/bin/env python3.12
"""snack-drawer-pair's Walkthrough: the reference solution (scripts/replay-solutions/snack-drawer-pair.py),
one pass with a hash map from calories to index. Each snack looks its partner up in the map, a probe that hits or
misses; a miss moves the snack into the map, and the hit moves the pair's indexes into the answer, on each sample
Test Case.

    CODEBITE_DB=<database> scripts/walkthroughs/snack-drawer-pair.py

writes common/src/main/resources/walkthroughs/snack-drawer-pair.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import driver_list, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move  # noqa: E402

SLUG = "snack-drawer-pair"

wt = Walkthrough(
    {"en": "Snack Drawer Pair", "ko": "간식 서랍 짝 찾기"},
    {"en": "One pass with a hash map: each snack asks whether its partner (target − calories) "
           "was seen already, and is stored by its calories otherwise.",
     "ko": "해시 맵으로 한 번 훑기: 간식마다 짝(target − 칼로리)을 이미 본 적이 있는지 묻고, "
           "없으면 자기 칼로리로 저장합니다."},
    views=[
        {"id": "snacks", "type": "array", "title": {"en": "snacks (calories)", "ko": "snacks (칼로리)"}},
        {"id": "seen", "type": "map", "title": {"en": "seen: calories → index", "ko": "seen: 칼로리 → 인덱스"},
         "empty": {"en": "empty", "ko": "비어 있음"}},
        {"id": "result", "type": "output", "title": {"en": "answer", "ko": "답"}, "empty": {"en": "empty", "ko": "비어 있음"}},
        {"id": "state", "type": "vars"},
    ],
)


def solve(snacks, target, run):
    """Solution.findPairIndices with a frame per snack. Returns the answer as the Driver prints it."""
    n = len(snacks)
    seen = {}
    result = []

    def frame(caption, i=None, probe=None, marks=None, seen_marks=None, moves=None, **answer):
        run.frame(caption,
                  snacks={"values": snacks, "pointers": {"i": i},
                          "unread": list(range(0 if i is None else i + 1, n)),
                          "marks": marks or ({"lit": [i]} if i is not None else {})},
                  # an index, not a count: text, so it isn't drawn as dots
                  seen={"entries": [{"key": c, "value": f"i={j}"} for c, j in seen.items()],
                        "marks": seen_marks or {}, **({"probe": probe} if probe else {})},
                  result={"values": result},
                  state={"items": [{"label": {"en": "target", "ko": "target (목표 칼로리)"}, "value": target}]},
                  moves=moves, **answer)

    frame({"en": f"Walk the drawer once with an empty map. For each snack, its partner is the one that "
                 f"brings the sum to {target}.",
           "ko": f"빈 맵으로 서랍을 한 번 훑습니다. 간식마다 더해서 {target}칼로리가 되는 간식이 그 짝입니다."})
    for i, calories in enumerate(snacks):
        partner = target - calories
        # looked up before this snack is stored, so a snack that is its own partner still misses
        probe = {"key": partner, "label": f"{target} − {calories} = {partner}", "hit": partner in seen}
        if partner in seen:
            j = seen[partner]
            result[:] = [j, i]
            answer = driver_list(result)
            frame({"en": f"Snack {i} has {calories}, so it needs {target} − {calories} = {partner}. "
                         f"{partner} is in the map at index {j}, so snacks {j} and {i} sum to {target}: "
                         f"answer {answer}.",
                   "ko": f"인덱스 {i}의 간식은 {calories}칼로리라서 {target} − {calories} = {partner}칼로리가 필요합니다. "
                         f"맵의 인덱스 {j}에 {partner}칼로리가 있으니 간식 {j}, {i}의 합이 {target}칼로리이고, "
                         f"답은 {answer}입니다."},
                  i, probe, {"path": [j, i]}, {"path": [partner]},
                  [move(at("seen", partner), at("result", 0), value=j), move(at("snacks", i), at("result", 1), value=i)],
                  answer=answer)
            return
        seen[calories] = i
        frame({"en": f"Snack {i} has {calories}, so it needs {target} − {calories} = {partner}. "
                     f"No snack so far has {partner}, so store {calories} → {i}.",
               "ko": f"인덱스 {i}의 간식은 {calories}칼로리라서 {target} − {calories} = {partner}칼로리가 필요합니다. "
                     f"지금까지 {partner}칼로리 간식이 없으니 {calories} → {i} 항목을 저장합니다."},
              i, probe, seen_marks={"good": [calories]}, moves=[move(at("snacks", i), at("seen", calories))])
    raise SystemExit("no pair found; the problem promises exactly one")


for number, sample in enumerate(sample_cases(SLUG), start=1):
    lines = sample["input"].split("\n")
    snacks, target = json.loads(lines[0]), int(lines[1])
    run = sample_run(wt, number, sample, input=f"snacks = {json.dumps(snacks)}, target = {target}")
    solve(snacks, target, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
