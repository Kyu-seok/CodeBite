#!/usr/bin/env python3.12
"""min-stack's Walkthrough: the reference solution (scripts/replay-solutions/min-stack.py), a value stack with a
second stack beside it whose entry at each level is the smallest value at or below that level, driven by the
sample's list of calls, recording one frame per call on each sample Test Case.

The call-list pattern (add-walkthrough views.md): the calls are a table, one row per call, the current one lit and
those before it faded, each call's return value moves into an `output` (the Driver's printed list), and the two
stacks change underneath, side by side.

    CODEBITE_DB=<database> scripts/walkthroughs/min-stack.py

writes common/src/main/resources/walkthroughs/min-stack.json.
"""
import json
import os
import sys
from functools import partial

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import driver_list, josa, record_return, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move  # noqa: E402

SLUG = "min-stack"

wt = Walkthrough(
    {"en": "Min Stack", "ko": "최솟값 스택"},
    {"en": "Beside the stack of values keep a second stack, lows, whose entry at each level is the smallest value at "
           "or below it. push adds to both, pop removes from both, and getMin reads the top of lows.",
     "ko": "값의 스택 옆에 두 번째 스택 lows를 두고, 각 층에 그 층과 그 아래에서 가장 작은 값을 둡니다. push는 둘 다에 "
           "넣고 pop은 둘 다에서 빼며, getMin은 lows의 맨 위를 읽습니다."},
    views=[
        {"id": "values", "type": "stack", "title": {"en": "values (stack)", "ko": "values (스택)"},
         "empty": {"en": "empty", "ko": "비어 있음"}},
        {"id": "lows", "type": "stack", "title": {"en": "lows (min so far)", "ko": "lows (지금까지 최솟값)"},
         "empty": {"en": "empty", "ko": "비어 있음"}},
        {"id": "calls", "type": "table", "title": {"en": "calls", "ko": "호출"}},
        {"id": "result", "type": "output", "title": {"en": "returned", "ko": "반환값"}},
    ],
)


def solve(ops, args, run):
    """The Driver's loop over the calls with the reference LowTrackStack inside, a frame per call. Returns the
    printed list."""
    n = len(ops)
    rows = [{"label": str(i), "cells": [op, str(a[0]) if a else ""]} for i, (op, a) in enumerate(zip(ops, args))]
    values, lows, result = [], [], []
    i = 0
    drawn = [0]  # how many return values the frame before drew, so only a new one is marked good

    def frame(caption, values_marks=None, lows_marks=None, path=False, moves=None, **answer):
        fresh = list(range(drawn[0], len(result)))
        drawn[0] = len(result)
        run.frame(caption,
                  calls={"columns": [{"en": "call", "ko": "호출"}, {"en": "val", "ko": "val"}], "rows": rows,
                         "marks": {} if path else {"dim": [[r, c] for r in range(i) for c in (0, 1)],
                                                    "lit": [[i, 0], [i, 1]]}},
                  values={"values": list(values), "marks": values_marks or {}},
                  lows={"values": list(lows), "marks": lows_marks or {}},
                  result={"values": list(result), "marks": {"path": list(range(len(result)))} if path
                          else {"good": fresh}},
                  moves=moves, **answer)

    returned = partial(record_return, result)

    returned(None)
    frame({"en": "LowTrackStack() starts with two empty stacks, values and lows, and returns null.",
           "ko": "LowTrackStack(): 빈 스택 values와 lows 두 개로 시작하고 null을 반환합니다."})
    for i in range(1, n):
        op = ops[i]
        if op == "push":
            val = args[i][0]
            below = lows[-1] if lows else None
            low = val if below is None else min(val, below)
            values.append(val)
            lows.append(low)
            k = returned(None)
            top = len(values) - 1
            moves = [move(at("calls", [i, 1]), at("values", top), value=str(val))]
            if below is None:
                why = {"en": f"the stack was empty, so {val} is also the smallest so far",
                       "ko": f"스택이 비어 있었으므로 {josa(val, '이가')} 지금까지의 최솟값입니다"}
                moves.append(move(at("calls", [i, 1]), at("lows", top), value=str(val)))
            elif val < below:
                why = {"en": f"{val} is smaller than the low below it, {below}, so lows gets {val}",
                       "ko": f"{josa(val, '이가')} 아래층의 최솟값 {below}보다 작으므로 lows에 {josa(val, '을를')} 넣습니다"}
                moves.append(move(at("calls", [i, 1]), at("lows", top), value=str(val)))
            else:
                why = {"en": f"{val} is not smaller than the low below it, {below}, so lows repeats {below}",
                       "ko": f"{josa(val, '이가')} 아래층의 최솟값 {below}보다 작지 않으므로 lows에 {josa(below, '을를')} "
                             f"한 번 더 넣습니다"}
                moves.append(move(at("lows", top - 1), at("lows", top), value=str(below)))
            moves.append(move(at("calls", [i, 0]), at("result", k), value="null"))
            frame({"en": f"push({val}): {val} goes on top of values; {why['en']}. push returns null.",
                   "ko": f"push({val}): values 맨 위에 {josa(val, '을를')} 넣고, {why['ko']}. null을 반환합니다."},
                  values_marks={"good": [top]}, lows_marks={"good": [top]}, moves=moves)
        elif op == "pop":
            top = len(values) - 1
            val, low = values[top], lows[top]
            k = returned(None)
            frame({"en": f"pop(): {val} leaves the top of values and {low} the top of lows, so the level below is "
                         f"on top again. pop returns null.",
                   "ko": f"pop(): values 맨 위의 {val}, lows 맨 위의 {josa(low, '이가')} 함께 빠져 아래층이 다시 맨 위가 "
                         f"됩니다. null을 반환합니다."},
                  values_marks={"bad": [top]}, lows_marks={"bad": [top]},
                  moves=[move(at("values", top)), move(at("lows", top)),
                         move(at("calls", [i, 0]), at("result", k), value="null")])
            values.pop()
            lows.pop()
        elif op == "top":
            top = len(values) - 1
            k = returned(values[top])
            frame({"en": f"top(): the top of values is {values[top]}; it returns it and the stack stays.",
                   "ko": f"top(): values의 맨 위 값 {josa(values[top], '을를')} 반환하고 스택은 그대로 둡니다."},
                  values_marks={"lit": [top]}, moves=[move(at("values", top), at("result", k))])
        elif op == "getMin":
            top = len(lows) - 1
            k = returned(lows[top])
            frame({"en": f"getMin(): the top of lows, {lows[top]}, is the smallest value in the stack; it returns it "
                         f"without searching.",
                   "ko": f"getMin(): lows의 맨 위 {josa(lows[top], '이가')} 스택에서 가장 작은 값이므로 찾아볼 필요 없이 "
                         f"반환합니다."},
                  lows_marks={"lit": [top]}, values_marks={"dim": list(range(len(values)))},
                  moves=[move(at("lows", top), at("result", k))])
        else:
            raise ValueError(op)
    printed = driver_list([json.loads(v) for v in result])
    frame({"en": f"Every call is answered, in order: answer {printed}.",
           "ko": f"모든 호출의 반환값을 차례로 모았습니다. 답은 {printed}입니다."},
          path=True, answer=printed)
    return printed


for number, sample in enumerate(sample_cases(SLUG), start=1):
    ops_line, args_line = sample["input"].split("\n")
    run = sample_run(wt, number, sample, input=sample["input"])
    solve(json.loads(ops_line), json.loads(args_line), run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
