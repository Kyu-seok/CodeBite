#!/usr/bin/env python3.12
"""pick-circular-donuts' Walkthrough: the reference solution (scripts/replay-solutions/pick-circular-donuts.py),
two lines solved with two rolling values each: the donuts without the first one, then without the last one, as
the solution calls best_in_line on tastiness[1:] and then on tastiness[:-1]. One frame per donut on each sample
Test Case.

The line being solved is a span over the tray that fades the donut left out. Its two rolling values, the best
total with the donut just passed skipped and with it taken, are a two-cell array rewritten each donut as in
pick-snack-haul. A finished line's best stays on the tray as a span below it, and the last frame marks the donuts
the larger line took.

    CODEBITE_DB=<database> scripts/walkthroughs/pick-circular-donuts.py

writes common/src/main/resources/walkthroughs/pick-circular-donuts.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import josa, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move, span  # noqa: E402

SLUG = "pick-circular-donuts"
SKIP, TAKE = 0, 1

wt = Walkthrough(
    {"en": "Pick Circular Donuts", "ko": "원형 도넛 고르기"},
    {"en": "The first and last donuts can't both be taken, so leave one of them out: that turns the circle into a "
           "line, solved with two rolling totals (last donut skipped, last donut taken). Do it both ways and keep "
           "the larger.",
     "ko": "첫 도넛과 마지막 도넛은 함께 고를 수 없으니 둘 중 하나를 뺍니다. 그러면 원이 한 줄이 되고, 직전 도넛을 "
           "건너뛴 합과 고른 합 두 값으로 풉니다. 두 가지로 모두 풀어 큰 쪽을 답으로 합니다."},
    views=[
        {"id": "tray", "type": "array", "title": {"en": "tastiness", "ko": "tastiness (도넛별 맛 점수)"}},
        {"id": "best", "type": "array", "title": {"en": "best total in this line so far", "ko": "이 줄의 지금까지 최대 합"}},
    ],
)
BEST_TAGS = [[SKIP, {"en": "skip", "ko": "건너뜀"}], [TAKE, {"en": "take", "ko": "고름"}]]


def without(d):
    return {"en": f"without donut {d}", "ko": f"{d}번 도넛 제외"}


def picks_text(picks, values):
    return " + ".join(str(values[i]) for i in picks) if picks else "0"


def solve(tastiness, run):
    """Solution.maxTastiness with a frame per donut. Returns the answer as the Driver prints it."""
    n = len(tastiness)
    if n == 1:
        run.frame({"en": f"A single donut has no neighbors, so it can be taken: {tastiness[0]}.",
                   "ko": f"도넛이 하나뿐이면 이웃이 없어 고를 수 있습니다. 답은 {tastiness[0]}입니다."},
                  tray={"values": tastiness, "marks": {"path": [0]}}, answer=str(tastiness[0]))
        return
    lines = [(1, n - 1, 0), (0, n - 2, n - 1)]  # (first, last, the donut left out), in the solution's call order
    skipped = taken = 0
    done = {}  # finished line number -> span below it
    state = {"line": 0, "i": None}

    def frame(caption, tray_marks=None, best_marks=None, moves=None, show_line=True, **answer):
        first, last, out = lines[state["line"]]
        spans = dict(done)
        if show_line:
            spans["line"] = span(first, last, without(out), fade=True)
        run.frame(caption,
                  tray={"values": tastiness, "pointers": {"i": state["i"]}, "spans": spans,
                        "marks": tray_marks or {}},
                  best={"values": [skipped, taken], "tags": BEST_TAGS, "marks": best_marks or {}},
                  moves=moves, **answer)

    results = []
    for number, (first, last, out) in enumerate(lines):
        state["line"], state["i"] = number, None
        other = n - 1 if out == 0 else 0
        if number == 0:
            frame({"en": f"{n} donuts in a circle, so donuts 0 and {n - 1} are neighbors. First leave out donut 0 "
                         f"and solve donuts 1 to {n - 1} as a line; skip and take start at 0.",
                   "ko": f"도넛 {n}개가 원형으로 놓여 0번과 {n - 1}번 도넛이 이웃입니다. 먼저 0번 도넛을 빼고 "
                         f"1번부터 {n - 1}번까지를 한 줄로 풀고, 건너뜀과 고름은 0에서 시작합니다."},
                  tray_marks={"bad": [out]})
        else:
            skipped = taken = 0
            frame({"en": f"Now leave out donut {out} instead and solve donuts 0 to {last}; skip and take start "
                         "over at 0.",
                   "ko": f"이번에는 {out}번 도넛을 빼고 0번부터 {last}번까지를 풉니다. 건너뜀과 고름은 다시 "
                         "0에서 시작합니다."},
                  tray_marks={"bad": [out]}, best_marks={"good": [SKIP, TAKE]},
                  moves=[move(None, at("best", SKIP), value="0"), move(None, at("best", TAKE), value="0")])
        skipped_picks, taken_picks = [], []
        for i in range(first, last + 1):
            haul = tastiness[i]
            old_skip, old_take = skipped, taken
            skipped, taken = max(skipped, taken), skipped + haul
            skip_from = SKIP if old_skip >= old_take else TAKE
            skipped_picks, taken_picks = (skipped_picks if skip_from == SKIP else taken_picks), skipped_picks + [i]
            moves = [move(at("tray", i), at("best", TAKE), value=str(haul)),
                     move(at("best", SKIP), at("best", TAKE), value=str(old_skip))]
            if skip_from == TAKE:
                moves.insert(0, move(at("best", TAKE), at("best", SKIP), value=str(old_take)))
            changed = [c for c, (a, b) in enumerate([(old_skip, skipped), (old_take, taken)]) if a != b]
            state["i"] = i
            if i == first:
                en = f"Donut {i} has {haul}: skipping it keeps 0, and taking it gives 0 + {haul} = {taken}."
                ko = f"{i}번 도넛은 {haul}점입니다. 건너뛰면 0, 고르면 0 + {haul} = {taken}입니다."
            else:
                en = (f"Donut {i} has {haul}: skipping it keeps the larger of {old_skip} and {old_take}, {skipped}. "
                      f"Taking it adds {haul} to the skipped total: {old_skip} + {haul} = {taken}.")
                ko = (f"{i}번 도넛은 {haul}점입니다. 건너뛰면 {josa(old_skip, '과와')} {old_take} 중 큰 값 "
                      f"{skipped}, 고르면 건너뛴 합에 더해 {old_skip} + {haul} = {taken}입니다.")
            frame({"en": en, "ko": ko}, tray_marks={"lit": [i], "bad": [out]}, best_marks={"good": changed},
                  moves=moves)
        best = max(skipped, taken)
        picks = taken_picks if taken >= skipped else skipped_picks
        results.append((best, picks, SKIP if skipped > taken else TAKE))
        state["i"] = None
        done[f"done{number}"] = span(first, last, {"en": f"without {out}: {best}", "ko": f"{out}번 제외: {best}"},
                                     mark="good", below=True)
        if number == 0:
            frame({"en": f"Without donut 0 the best is the larger of skip and take: {best}, from donuts "
                         f"{', '.join(map(str, picks))} ({picks_text(picks, tastiness)}).",
                   "ko": f"0번 도넛을 뺀 줄의 최댓값은 건너뜀과 고름 중 큰 값 {best}이며, "
                         f"{', '.join(map(str, picks))}번 도넛({picks_text(picks, tastiness)})에서 나옵니다."},
                  tray_marks={"good": picks}, best_marks={"lit": [results[0][2]]}, show_line=False)
    (first_best, first_picks, _), (second_best, second_picks, second_winner) = results
    answer = max(first_best, second_best)
    winner = 0 if first_best >= second_best else 1
    picks = first_picks if winner == 0 else second_picks
    left_out = lines[winner][2]
    done[f"done{winner}"]["mark"] = "path"
    del done[f"done{1 - winner}"]  # one span below at a time: the two lines overlap
    frame({"en": f"Without donut {n - 1} the best is {second_best}, and without donut 0 it was "
                 f"{first_best}. The answer is the larger, without donut "
                 f"{left_out}: donuts {', '.join(map(str, picks))}, {picks_text(picks, tastiness)} = {answer}.",
           "ko": f"{n - 1}번 도넛을 뺀 줄의 최댓값은 {second_best}, 0번 도넛을 뺀 줄의 최댓값은 {first_best}입니다. "
                 f"답은 더 큰 쪽인 {left_out}번 제외 줄의 "
                 f"{', '.join(map(str, picks))}번 도넛으로, {picks_text(picks, tastiness)} = {answer}입니다."},
          tray_marks={"path": picks, "dim": [i for i in range(n) if i not in picks]},
          best_marks={"lit": [second_winner]}, show_line=False, answer=str(answer))


for number, sample in enumerate(sample_cases(SLUG), start=1):
    tastiness = json.loads(sample["input"])
    run = sample_run(wt, number, sample, input=f"tastiness = {sample['input']}")
    solve(tastiness, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
