#!/usr/bin/env python3.12
"""pick-snack-haul's Walkthrough: the reference solution (scripts/replay-solutions/pick-snack-haul.py), two
rolling values, the best haul with the machine just passed skipped and with it taken, recording one frame per
machine on each sample Test Case.

The two values are a two-cell array; each machine rewrites both at once, as the solution's tuple assignment does:
the larger old value moves into `skip`, and the old `skip` plus the machine's snacks into `take`. Beside them the
tracer keeps the machines each value picked, so the last frame marks the haul the answer took.

    CODEBITE_DB=<database> scripts/walkthroughs/pick-snack-haul.py

writes common/src/main/resources/walkthroughs/pick-snack-haul.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import josa, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move  # noqa: E402

SLUG = "pick-snack-haul"
SKIP, TAKE = 0, 1

wt = Walkthrough(
    {"en": "Pick Snack Haul", "ko": "간식 털이 최대화"},
    {"en": "Only two numbers carry over from machine to machine: the best haul with the last machine skipped, "
           "and with it taken. Skipping keeps the larger; taking adds the snacks to the skipped one.",
     "ko": "자판기마다 넘겨받는 수는 둘뿐입니다: 직전 자판기를 건너뛴 최대 합과 고른 최대 합. 건너뛰면 둘 중 큰 "
           "값을, 고르면 건너뛴 합에 간식 수를 더한 값을 씁니다."},
    views=[
        {"id": "snacks", "type": "array", "title": {"en": "snacks", "ko": "snacks (자판기별 간식)"}},
        {"id": "best", "type": "array", "title": {"en": "best haul so far", "ko": "지금까지의 최대 합"}},
    ],
)
BEST_TAGS = [[SKIP, {"en": "skip", "ko": "건너뜀"}], [TAKE, {"en": "take", "ko": "고름"}]]


def picks_text(picks, snacks):
    return " + ".join(str(snacks[i]) for i in picks) if picks else "0"


def solve(snacks, run):
    """Solution.maxSnackHaul with a frame per machine. Returns the answer as the Driver prints it."""
    n = len(snacks)
    skipped, taken = 0, 0
    skipped_picks, taken_picks = [], []  # the machines behind each value, for the last frame

    def frame(caption, i=None, unread=None, snack_marks=None, best_marks=None, moves=None, **answer):
        run.frame(caption,
                  snacks={"values": snacks, "pointers": {"i": i}, "marks": snack_marks or {},
                          "unread": list(range(n)) if unread is None else unread},
                  best={"values": [skipped, taken], "tags": BEST_TAGS, "marks": best_marks or {}},
                  moves=moves, **answer)

    frame({"en": f"{n} machines. Before any machine, both the haul with the last one skipped and with it "
                 "taken are 0.",
           "ko": f"자판기가 {n}대입니다. 아직 아무 자판기도 보지 않았으니 건너뛴 합과 고른 합 모두 0입니다."})
    for i, haul in enumerate(snacks):
        old_skip, old_take = skipped, taken
        skipped, taken = max(skipped, taken), skipped + haul
        skip_from = SKIP if old_skip >= old_take else TAKE
        skipped_picks, taken_picks = (skipped_picks if skip_from == SKIP else taken_picks), skipped_picks + [i]
        moves = [move(at("snacks", i), at("best", TAKE), value=str(haul)),
                 move(at("best", SKIP), at("best", TAKE), value=str(old_skip))]
        if skip_from == TAKE:
            moves.insert(0, move(at("best", TAKE), at("best", SKIP), value=str(old_take)))
        changed = [c for c, (a, b) in enumerate([(old_skip, skipped), (old_take, taken)]) if a != b]
        frame({"en": f"Machine {i} has {haul}: skipping it keeps the larger of {old_skip} and {old_take}, {skipped}. "
                     f"Taking it adds {haul} to the skipped haul, {old_skip} + {haul} = {taken}, since machine "
                     f"{i - 1} must then be skipped." if i > 0 else
                     f"Machine 0 has {haul}: skipping it keeps {skipped}, and taking it gives 0 + {haul} = {taken}.",
               "ko": f"자판기 {i}에는 {haul}개가 있습니다. 건너뛰면 {josa(old_skip, '과와')} {old_take} 중 큰 값 {skipped}, "
                     f"고르면 자판기 {josa(i - 1, '을를')} 건너뛰어야 하므로 "
                     f"{old_skip} + {haul} = {taken}입니다." if i > 0 else
                     f"자판기 0에는 {haul}개가 있습니다. 건너뛰면 {skipped}, 고르면 0 + {haul} = {taken}입니다."},
              i=i, unread=list(range(i + 1, n)), snack_marks={"lit": [i]}, best_marks={"good": changed}, moves=moves)
    best = max(skipped, taken)
    picks = taken_picks if taken >= skipped else skipped_picks
    winner = TAKE if taken >= skipped else SKIP
    names = ", ".join(str(i) for i in picks)
    frame({"en": f"Every machine is passed. The answer is the larger of the two, {best}: machines {names}, "
                 f"{picks_text(picks, snacks)} = {best}.",
           "ko": f"모든 자판기를 지났습니다. 답은 둘 중 큰 값 {best}이고, 자판기 {names}번의 "
                 f"{picks_text(picks, snacks)} = {best}입니다."},
          snack_marks={"path": picks, "dim": [i for i in range(n) if i not in picks]},
          unread=[], best_marks={"path": [winner]}, answer=str(best))


for number, sample in enumerate(sample_cases(SLUG), start=1):
    snacks = json.loads(sample["input"])
    run = sample_run(wt, number, sample, input=f"snacks = {sample['input']}")
    solve(snacks, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
