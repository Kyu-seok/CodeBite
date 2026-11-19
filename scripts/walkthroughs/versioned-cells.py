#!/usr/bin/env python3.12
"""versioned-cells's Walkthrough: the reference solution (scripts/replay-solutions/versioned-cells.py), a history per
cell of (snapshot id, value) entries, driven by the sample's list of calls, recording one frame per call on each
sample Test Case.

The call-list pattern (add-walkthrough views.md): the calls are a table, one row per call, the current one lit and
those before it faded, each call's return value moves into an `output` (the Driver's printed list), and the
histories change underneath: a table with one row per cell, one column per entry of its history.

    CODEBITE_DB=<database> scripts/walkthroughs/versioned-cells.py

writes common/src/main/resources/walkthroughs/versioned-cells.json.
"""
import bisect
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import driver_list, josa, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move  # noqa: E402

SLUG = "versioned-cells"

wt = Walkthrough(
    {"en": "Versioned Cell Array", "ko": "버전 관리 셀"},
    {"en": "Never copy the row: each cell keeps a history of (snapshot id, value) entries, one per snapshot it changed "
           "in, and readAt binary-searches that history for the last entry at or before the snapshot asked for.",
     "ko": "행을 통째로 복사하지 않습니다. 셀마다 (스냅샷 id, 값) 항목의 기록을 두되 바뀐 스냅샷마다 하나씩만 두고, "
           "readAt은 그 기록에서 요청한 스냅샷 이하인 마지막 항목을 이진 탐색으로 찾습니다."},
    views=[
        {"id": "calls", "type": "table", "title": {"en": "calls", "ko": "호출"}},
        {"id": "history", "type": "table",
         "title": {"en": "history per cell (snapshot id, value)", "ko": "셀별 기록 (스냅샷 id, 값)"}},
        {"id": "state", "type": "vars"},
        {"id": "result", "type": "output", "title": {"en": "returned", "ko": "반환값"}},
    ],
)


def pair(e):
    return f"({e[0]}, {e[1]})"


def solve(ops, args, run):
    """The Driver's loop over the calls with the reference VersionedCells inside, a frame per call. Returns the
    printed list."""
    n = len(ops)
    rows = [{"label": str(i), "cells": [op, ", ".join(str(x) for x in a)]} for i, (op, a) in enumerate(zip(ops, args))]
    length = args[0][0]
    history = [[(-1, 0)] for _ in range(length)]
    snap_id = 0
    # as many entry columns as the longest history the run builds
    width = 1 + max(sum(1 for op, a in zip(ops, args) if op == "set" and a[0] == c) for c in range(length))
    result = []
    drawn = [0]
    i = 0

    def frame(caption, cell_marks=None, path=False, moves=None, **answer):
        fresh = list(range(drawn[0], len(result)))
        drawn[0] = len(result)
        run.frame(caption,
                  calls={"columns": [{"en": "call", "ko": "호출"}, {"en": "arguments", "ko": "인자"}], "rows": rows,
                         "marks": {} if path else {"dim": [[r, c] for r in range(i) for c in (0, 1)],
                                                    "lit": [[i, 0], [i, 1]]}},
                  history={"rows": [{"label": {"en": f"cell {c}", "ko": f"셀 {c}"},
                                     "cells": [pair(e) for e in h] + [""] * (width - len(h))}
                                    for c, h in enumerate(history)],
                           "marks": cell_marks or {}},
                  state={"items": [{"label": {"en": "snap_id", "ko": "snap_id (다음 스냅샷 id)"}, "value": snap_id}]},
                  result={"values": result, "marks": {"path": list(range(len(result)))} if path else {"good": fresh}},
                  moves=moves, **answer)

    def returned(value):
        result.append(json.dumps(value))
        return len(result) - 1

    returned(None)
    cells = "the cell starts" if length == 1 else f"each of the {length} cells starts"
    frame({"en": f"VersionedCells({length}): {cells} with one entry, (-1, 0), value 0 from before any snapshot. "
                 "snap_id = 0 is the id the first commit will freeze; it returns null.",
           "ko": f"VersionedCells({length}): 셀 {length}개가 모두 어떤 스냅샷보다 앞선 값 0을 뜻하는 (-1, 0) 항목 하나로 "
                 "시작하고, null을 반환합니다. snap_id = 0은 첫 commit이 동결할 id입니다."})
    for i in range(1, n):
        op, a = ops[i], args[i]
        if op == "set":
            index, val = a
            cell = history[index]
            last = cell[-1]
            if last[0] == snap_id:
                cell[-1] = (snap_id, val)
                frame({"en": f"set({index}, {val}): cell {index}'s last entry {pair(last)} already belongs to snapshot "
                             f"{snap_id}, which isn't frozen yet, so it is overwritten with {pair(cell[-1])}. "
                             "It returns null.",
                       "ko": f"set({index}, {val}): 셀 {index}의 마지막 항목 {pair(last)}: 아직 동결되지 않은 스냅샷 "
                             f"{snap_id}의 항목이므로 {pair(cell[-1])} 항목으로 덮어씁니다. null을 반환합니다."},
                      cell_marks={"good": [[index, len(cell) - 1]]},
                      moves=[move(at("calls", [i, 1]), at("history", [index, len(cell) - 1]), value=pair(cell[-1])),
                             move(at("calls", [i, 0]), at("result", returned(None)), value="null")])
            else:
                cell.append((snap_id, val))
                frame({"en": f"set({index}, {val}): cell {index}'s last entry {pair(last)} is from before snapshot "
                             f"{snap_id}, so a new entry {pair(cell[-1])} is appended, leaving the frozen one as it was. "
                             "It returns null.",
                       "ko": f"set({index}, {val}): 셀 {index}의 마지막 항목 {pair(last)}: 스냅샷 {snap_id}보다 앞의 "
                             f"항목이므로 그대로 두고 {pair(cell[-1])} 항목을 새로 붙입니다. null을 반환합니다."},
                      cell_marks={"lit": [[index, len(cell) - 2]], "good": [[index, len(cell) - 1]]},
                      moves=[move(at("calls", [i, 1]), at("history", [index, len(cell) - 1]), value=pair(cell[-1])),
                             move(at("calls", [i, 0]), at("result", returned(None)), value="null")])
        elif op == "commit":
            snap_id += 1
            k = returned(snap_id - 1)
            frame({"en": f"commit(): snap_id goes from {snap_id - 1} to {snap_id}, which freezes every entry with id "
                         f"{snap_id - 1}: nothing is copied. It returns {snap_id - 1}, the frozen snapshot's id.",
                   "ko": f"commit(): snap_id가 {snap_id - 1}에서 {josa(snap_id, '(으)로')} 올라 id가 {snap_id - 1}인 "
                         f"항목이 모두 동결됩니다. 아무것도 복사하지 않고, 동결된 스냅샷의 id {josa(snap_id - 1, '을를')} "
                         "반환합니다."},
                  moves=[move(at("calls", [i, 0]), at("result", k), value=str(snap_id - 1))])
        elif op == "readAt":
            index, snap = a
            cell = history[index]
            j = bisect.bisect_right(cell, (snap, float("inf")))
            got = cell[j - 1]
            k = returned(got[1])
            later = [c for c in range(j, len(cell))]
            skip = ({"en": f"; {', '.join(pair(cell[c]) for c in later)} came later", "ko":
                     f" ({', '.join(pair(cell[c]) for c in later)} 항목은 그 뒤의 것)"} if later else {"en": "", "ko": ""})
            frame({"en": f"readAt({index}, {snap}): bisect finds the last entry in cell {index}'s history with id at most "
                         f"{snap}, {pair(got)}{skip['en']}. It returns {got[1]}.",
                   "ko": f"readAt({index}, {snap}): 셀 {index}의 기록에서 id가 {snap} 이하인 마지막 항목을 이진 탐색으로 "
                         f"찾으면 {pair(got)} 항목입니다{skip['ko']}. {josa(got[1], '을를')} 반환합니다."},
                  cell_marks={"lit": [[index, j - 1]], "dim": [[index, c] for c in later]},
                  moves=[move(at("history", [index, j - 1]), at("result", k), value=str(got[1]))])
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
