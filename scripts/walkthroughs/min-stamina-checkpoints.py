#!/usr/bin/env python3.12
"""min-stamina-checkpoints' Walkthrough: the reference solution (scripts/replay-solutions/min-stamina-checkpoints.py),
two rolling values, the least stamina spent to stand on the checkpoint two back and one back, recording one frame
per position from checkpoint 2 to past the end on each sample Test Case.

The checkpoints are an array with one more cell, past the end, where pointer `i` can stand on the last step. Each
step reads the two ways in (from one back paying its cost, from two back paying its cost), writes each sum under
the cost it pays, and rewrites both rolling values at once, as the solution's tuple assignment does: the old
`one_back` moves into `two_back`, and the cheaper sum into `one_back`. Beside them the tracer keeps the checkpoints
each value stood on, so the last frame marks the answer's checkpoints `path`.

    CODEBITE_DB=<database> scripts/walkthroughs/min-stamina-checkpoints.py

writes common/src/main/resources/walkthroughs/min-stamina-checkpoints.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import josa, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move  # noqa: E402

SLUG = "min-stamina-checkpoints"
TWO, ONE = 0, 1

wt = Walkthrough(
    {"en": "Min Stamina Checkpoints", "ko": "체크포인트 최소 스태미나"},
    {"en": "Only two numbers carry over: the least stamina spent to stand on the checkpoint two back and one "
           "back. A checkpoint is reached from one of them, paying that checkpoint's cost, so take the cheaper.",
     "ko": "넘겨받는 수는 둘뿐입니다: 두 칸 전과 한 칸 전 체크포인트에 서기까지 쓴 최소 스태미나. 어느 체크포인트든 "
           "그 둘 중 하나에서 그 칸의 비용을 내고 오므로, 더 싼 쪽을 고릅니다."},
    views=[
        {"id": "cost", "type": "array",
         "title": {"en": "cost, then past the end", "ko": "cost (체크포인트별 비용), 그리고 끝 너머"}},
        {"id": "best", "type": "array",
         "title": {"en": "least stamina to stand there", "ko": "그 칸에 서기까지의 최소 스태미나"}},
    ],
)
BEST_TAGS = [[TWO, {"en": "2 back", "ko": "두 칸 전"}], [ONE, {"en": "1 back", "ko": "한 칸 전"}]]


def where(i, n):
    return ({"en": "past the end", "ko": "끝 너머"} if i == n else
            {"en": f"checkpoint {i}", "ko": f"체크포인트 {i}"})


def solve(cost, run):
    """Solution.minStaminaToFinish with a frame per position. Returns nothing; the last frame has the answer."""
    n = len(cost)
    cells = cost + [""]
    end_tag = [n, {"en": "end", "ko": "끝"}]
    two_back, one_back = 0, 0
    two_picks, one_picks = [], []  # the checkpoints stood on behind each value

    def frame(caption, i=None, unread=None, cost_marks=None, under=(), best_marks=None, moves=None, **answer):
        run.frame(caption,
                  cost={"values": cells, "pointers": {"i": i}, "marks": cost_marks or {}, "tags": [end_tag],
                        "under": list(under), "unread": [] if unread is None else unread},
                  best={"values": [two_back, one_back], "tags": BEST_TAGS, "marks": best_marks or {}},
                  moves=moves, **answer)

    frame({"en": f"{n} checkpoints. You start on checkpoint 0 or 1 for free, so standing on either costs 0 so far: "
                 "2 back = 0 and 1 back = 0.",
           "ko": f"체크포인트가 {n}개입니다. 0번이나 1번에서 공짜로 시작하므로 둘 중 어디에 서든 지금까지 0입니다: "
                 "두 칸 전 = 0, 한 칸 전 = 0."},
          unread=list(range(n + 1)))
    for i in range(2, n + 1):
        old_two, old_one = two_back, one_back
        via_one, via_two = old_one + cost[i - 1], old_two + cost[i - 2]
        two_back, one_back = one_back, min(via_one, via_two)
        from_one = via_one <= via_two  # min keeps the first on a tie
        two_picks, one_picks = one_picks, (one_picks + [i - 1] if from_one else two_picks + [i - 2])
        moves = [move(at("best", ONE), at("best", TWO), value=str(old_one))]
        if from_one:
            moves.append(move(at("cost", i - 1), at("best", ONE), value=f"{old_one}+{cost[i - 1]}"))
        else:
            moves += [move(at("best", TWO), at("best", ONE), value=str(old_two)),
                      move(at("cost", i - 2), at("best", ONE), value=f"+{cost[i - 2]}")]
        here = where(i, n)
        tie_en = " (a tie: the first one wins)" if via_one == via_two else ""
        tie_ko = "(같으면 앞의 것)" if via_one == via_two else ""
        frame({"en": f"{here['en'].capitalize()} is reached from checkpoint {i - 1} ({old_one} + {cost[i - 1]} = "
                     f"{via_one}) or checkpoint {i - 2} ({old_two} + {cost[i - 2]} = {via_two}). The cheaper, "
                     f"{one_back}{tie_en}, becomes 1 back, and the old 1 back, {old_one}, becomes 2 back.",
               "ko": f"{here['ko']}에는 체크포인트 {i - 1}에서({old_one} + {cost[i - 1]} = {via_one}) 또는 체크포인트 "
                     f"{i - 2}에서({old_two} + {cost[i - 2]} = {via_two}) 옵니다. 더 싼 쪽{tie_ko}의 "
                     f"{josa(one_back, '이가')} "
                     f"한 칸 전이 되고, 이전 한 칸 전 {josa(old_one, '은는')} 두 칸 전이 됩니다."},
              i=i, unread=list(range(i + 1, n + 1)),
              cost_marks={"lit": [i - 1, i - 2]},
              under=[[i - 1, f"{old_one}+{cost[i - 1]}"], [i - 2, f"{old_two}+{cost[i - 2]}"]],
              best_marks={"good": [c for c, (a, b) in enumerate([(old_two, two_back), (old_one, one_back)])
                                   if a != b]},
              moves=moves)
    picks = one_picks
    paid = " + ".join(str(cost[p]) for p in picks)
    names = ", ".join(str(p) for p in picks)
    frame({"en": f"Getting past the end takes {one_back}: stand on checkpoints {names}, {paid} = {one_back}.",
           "ko": f"끝을 지나가려면 {josa(one_back, '이가')} "
                 f"듭니다. 체크포인트 {names}번에 서면 {paid} = {one_back}입니다."},
          cost_marks={"path": picks, "dim": [p for p in range(n) if p not in picks]},
          best_marks={"path": [ONE]}, answer=str(one_back))


for number, sample in enumerate(sample_cases(SLUG), start=1):
    cost = json.loads(sample["input"])
    run = sample_run(wt, number, sample, input=f"cost = {sample['input']}")
    solve(cost, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
