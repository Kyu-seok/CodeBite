#!/usr/bin/env python3.12
"""click-tally-window's Walkthrough: the reference solution (scripts/replay-solutions/click-tally-window.py), a queue
of click timestamps, oldest at the front, driven by the sample's list of calls, recording one frame per call and one
per click dropped from the front, on each sample Test Case.

The call-list pattern (add-walkthrough views.md): the calls are a table, one row per call, the current one lit and
those before it faded, each call's return value moves into an `output` (the Driver's printed list), and the queue
changes underneath.

    CODEBITE_DB=<database> scripts/walkthroughs/click-tally-window.py

writes common/src/main/resources/walkthroughs/click-tally-window.json.
"""
import json
import os
import sys
from collections import deque

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import driver_list, josa, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move  # noqa: E402

SLUG = "click-tally-window"

wt = Walkthrough(
    {"en": "Click Tally Window", "ko": "클릭 윈도 카운터"},
    {"en": "Timestamps only grow, so the clicks sit in a queue oldest first: countSince drops from the front every "
           "click at or before timestamp − 300, and what is left is the count.",
     "ko": "시각은 줄지 않으므로 클릭을 오래된 순으로 큐에 둡니다. countSince는 timestamp − 300 이하인 클릭을 앞에서부터 "
           "빼고, 남은 개수가 답입니다."},
    views=[
        {"id": "calls", "type": "table", "title": {"en": "calls", "ko": "호출"}},
        {"id": "clicks", "type": "queue", "title": {"en": "clicks (timestamps, oldest at the front)",
                                                    "ko": "clicks (클릭 시각, 오래된 것이 앞)"},
         "empty": {"en": "empty", "ko": "비어 있음"}},
        {"id": "result", "type": "output", "title": {"en": "returned", "ko": "반환값"}},
    ],
)


def solve(ops, args, run):
    """The Driver's loop over the calls with the reference ClickTally inside, a frame per call and per click dropped.
    Returns the printed list."""
    n = len(ops)
    rows = [{"label": str(i), "cells": [op, ", ".join(str(x) for x in a)]} for i, (op, a) in enumerate(zip(ops, args))]
    clicks = deque()
    result = []
    drawn = [0]
    i = 0

    def frame(caption, queue_marks=None, path=False, moves=None, **answer):
        fresh = list(range(drawn[0], len(result)))
        drawn[0] = len(result)
        run.frame(caption,
                  calls={"columns": [{"en": "call", "ko": "호출"}, {"en": "timestamp", "ko": "timestamp"}],
                         "rows": rows,
                         "marks": {} if path else {"dim": [[r, c] for r in range(i) for c in (0, 1)],
                                                    "lit": [[i, 0], [i, 1]]}},
                  clicks={"values": list(clicks), "marks": queue_marks or {}},
                  result={"values": result, "marks": {"path": list(range(len(result)))} if path else {"good": fresh}},
                  moves=moves, **answer)

    def returned(value):
        result.append(json.dumps(value))
        return len(result) - 1

    returned(None)
    frame({"en": "ClickTally() starts with an empty queue of clicks. It returns null.",
           "ko": "ClickTally(): 빈 클릭 큐로 시작합니다. null을 반환합니다."})
    for i in range(1, n):
        op, t = ops[i], args[i][0]
        if op == "record":
            clicks.append(t)
            frame({"en": f"record({t}): the click joins the back of the queue; times never go down, so the queue "
                         "stays oldest first. It returns null.",
                   "ko": f"record({t}): 클릭을 큐 뒤에 넣고 null을 반환합니다. 시각은 줄지 않으므로 큐는 계속 오래된 "
                         "순입니다."},
                  queue_marks={"good": [len(clicks) - 1]},
                  moves=[move(at("calls", [i, 1]), at("clicks", len(clicks) - 1), value=str(t)),
                         move(at("calls", [i, 0]), at("result", returned(None)), value="null")])
        elif op == "countSince":
            cut = t - 300
            while clicks and clicks[0] <= cut:
                front = clicks[0]
                frame({"en": f"countSince({t}): the window is [{t - 299}, {t}]. The front click, {front}, is at or "
                             f"before {t} − 300 = {cut}, so it leaves.",
                       "ko": f"countSince({t}): 윈도는 [{t - 299}, {t}] 구간입니다. 맨 앞 클릭 시각 {front}: "
                             f"{t} − 300 = {cut} 이하이므로 큐에서 뺍니다."},
                      queue_marks={"bad": [0]}, moves=[move(at("clicks", 0))])
                clicks.popleft()
            count = len(clicks)
            if clicks:
                why = {"en": f"the front click, {clicks[0]}, is after {cut}, so every click left is inside "
                             f"[{t - 299}, {t}]",
                       "ko": f"맨 앞 클릭 시각 {josa(clicks[0], '이가')} {cut}보다 뒤이므로 남은 클릭은 모두 "
                             f"[{t - 299}, {t}] 구간 안에 있습니다"}
            else:
                why = {"en": "the queue is empty", "ko": "큐가 비어 있습니다"}
            frame({"en": f"countSince({t}): {why['en']}. It returns the queue's length, {count}.",
                   "ko": f"countSince({t}): {why['ko']}. 큐의 길이 {josa(count, '을를')} 반환합니다."},
                  queue_marks={"lit": list(range(count))},
                  moves=[move(at("calls", [i, 0]), at("result", returned(count)), value=str(count))])
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
