#!/usr/bin/env python3.12
"""timestamp-value-store's Walkthrough: the reference solution
(scripts/replay-solutions/timestamp-value-store.py), a list of write times per key, kept in order because
timestamps only grow, with readAt a binary search (bisect_right) over those times, driven by the sample's
list of calls.

The call-list pattern (add-walkthrough views.md): the calls are a table, the current row lit and those before
it faded, each call's return value moves into an `output` of what the Driver prints. The key's writes are an
array of their times, each value under its time; a write moves its time and value in from the call's
argument, and each probe of the binary search is a frame of its own, the range still searched a span with lo
and mid as pointers. bisect_right is written out here, the same search the reference calls.

Every sample writes to one key, so one array draws the store; the tracer refuses a sample with two.

    CODEBITE_DB=<database> scripts/walkthroughs/timestamp-value-store.py

writes common/src/main/resources/walkthroughs/timestamp-value-store.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import driver_list, driver_value, josa, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move, span  # noqa: E402

SLUG = "timestamp-value-store"

wt = Walkthrough(
    {"en": "Timestamped Value Store", "ko": "타임스탬프 값 저장소"},
    {"en": "Writes to a key arrive in time order, so its times form a sorted list: readAt binary-searches it for "
           "the first time after the one asked, and the write just before that is the latest at or before it.",
     "ko": "한 키에 대한 기록은 시점 순서대로 들어오므로 시점 목록은 정렬되어 있습니다. readAt은 이 목록에서 물어본 시점보다 "
           "늦은 첫 시점을 이분 탐색으로 찾고, 그 바로 앞 기록이 그 시점 이하인 가장 최근 값입니다."},
    views=[
        {"id": "calls", "type": "table", "title": {"en": "calls", "ko": "호출"}},
        {"id": "times", "type": "array",
         "title": {"en": "the key's write times (value under each)", "ko": "키의 기록 시점 (아래: 값)"}},
        {"id": "result", "type": "output", "title": {"en": "returned", "ko": "반환값"}},
    ],
)


def solve(ops, args, run):
    """The Driver's loop over the calls with the reference store inside, frames per call. Returns the printed list."""
    keys = {a[0] for op, a in zip(ops, args) if op != "TimestampedStore"}
    if len(keys) > 1:
        raise SystemExit(f"{SLUG}: a sample with keys {sorted(keys)}; draw one array per key first")
    rows = [{"label": str(i), "cells": [op, ", ".join(driver_value(x) for x in a)]}
            for i, (op, a) in enumerate(zip(ops, args))]
    times, values = [], []
    result = []
    drawn = [0]
    i = 0
    probe = {}  # lo, hi and mid of the search on screen

    def frame(caption, cell_marks=None, path=False, moves=None, **answer):
        fresh = list(range(drawn[0], len(result)))
        drawn[0] = len(result)
        spans, pointers = {}, {}
        if probe:
            lo, hi, mid = probe["lo"], probe["hi"], probe.get("mid")
            if lo < hi:
                spans["range"] = span(lo, hi - 1, {"en": "range", "ko": "범위"}, fade=True)
            pointers = {"lo": lo if lo < len(times) else None, "mid": mid}
        run.frame(caption,
                  calls={"columns": [{"en": "call", "ko": "호출"}, {"en": "argument", "ko": "인자"}], "rows": rows,
                         "marks": {} if path else {"dim": [[r, c] for r in range(i) for c in (0, 1)],
                                                    "lit": [[i, 0], [i, 1]]}},
                  times={"values": list(times), "under": [[j, driver_value(v)] for j, v in enumerate(values)],
                         "spans": spans, "pointers": pointers, "marks": cell_marks or {}},
                  result={"values": list(result),
                          "marks": {"path": list(range(len(result)))} if path else {"good": fresh}},
                  moves=moves, **answer)

    def returned(text):
        result.append(text)
        return len(result) - 1

    returned("null")
    frame({"en": "TimestampedStore() starts an empty store: no key has a write yet. It returns null.",
           "ko": "TimestampedStore(): 빈 저장소를 만듭니다. 아직 기록된 키가 없고, null을 반환합니다."})
    for i in range(1, len(ops)):
        op, a = ops[i], args[i]
        if op == "write":
            key, value, ts = a
            times.append(ts)
            values.append(value)
            j = len(times) - 1
            k = returned("null")
            frame({"en": f"write({driver_value(key)}, {driver_value(value)}, {ts}): time {ts} goes on the end of "
                         f"{key}'s times, later than any before it, so the list stays sorted. It returns null.",
                   "ko": f"write({driver_value(key)}, {driver_value(value)}, {ts}): 시점 {josa(ts, '이가')} {key} 키의 "
                         f"시점 목록 끝에 붙고, 앞의 어느 시점보다 늦어 목록은 정렬된 채입니다. null을 반환합니다."},
                  cell_marks={"good": [j]},
                  moves=[move(at("calls", [i, 1]), at("times", j), value=f"{ts}: {driver_value(value)}"),
                         move(at("calls", [i, 0]), at("result", k), value="null")])
        elif op == "readAt":
            key, ts = a
            lo, hi = 0, len(times)
            while lo < hi:
                mid = (lo + hi) // 2
                probe.update(lo=lo, hi=hi, mid=mid)
                if ts < times[mid]:
                    hi = mid
                    en = f"{ts} < {times[mid]}, so that write is too late: the search keeps the times left of mid."
                    ko = f"{ts} < {times[mid]}: 그 기록은 너무 늦으므로 mid 왼쪽 시점들만 남깁니다."
                else:
                    lo = mid + 1
                    en = f"{times[mid]} ≤ {ts}, so that write counts: the search keeps the times right of mid."
                    ko = f"{times[mid]} ≤ {ts}: 그 기록은 해당되므로 mid 오른쪽 시점들만 남깁니다."
                frame({"en": f"readAt({driver_value(key)}, {ts}): mid = {mid}, time {times[mid]}. {en}",
                       "ko": f"readAt({driver_value(key)}, {ts}): mid = {mid}, 시점 {times[mid]}. {ko}"},
                      cell_marks={"lit": [mid]})
            probe.clear()
            probe.update(lo=lo, hi=hi)
            if lo:
                k = returned(driver_value(values[lo - 1]))
                if lo < len(times):
                    en = (f"The first time after {ts} is at index {lo}, so the write before it, at time "
                          f"{times[lo - 1]}, is the latest at or before {ts}: it returns {result[k]}.")
                    ko = (f"{ts}보다 늦은 첫 시점은 인덱스 {lo}에 있으므로, 그 앞 시점 {times[lo - 1]}의 기록이 {ts} 이하에서 "
                          f"가장 최근입니다. {result[k]} 값을 반환합니다.")
                else:
                    en = (f"No time is after {ts} (lo = {lo} is past the end), so the last write, at time "
                          f"{times[lo - 1]}, is the latest at or before {ts}: it returns {result[k]}.")
                    ko = (f"{ts}보다 늦은 시점이 없으므로(lo = {lo}, 목록 끝) 마지막 시점 {times[lo - 1]}의 기록이 "
                          f"{ts} 이하에서 가장 최근입니다. {result[k]} 값을 반환합니다.")
                frame({"en": en, "ko": ko}, cell_marks={"good": [lo - 1]},
                      moves=[move(at("times", lo - 1), at("result", k), value=result[k])])
            else:
                k = returned('""')
                frame({"en": f"lo = 0: even the first write, at time {times[0] if times else '-'}, is after {ts}, so "
                             f"{key} had no value yet and readAt returns \"\".",
                       "ko": f"lo = 0: 첫 기록조차 {ts}보다 늦으므로 그 시점에는 {key} 키에 값이 없었습니다. "
                             f"\"\" 값을 반환합니다."},
                      cell_marks={"bad": [0]} if times else {},
                      moves=[move(at("calls", [i, 0]), at("result", k), value='""')])
            probe.clear()
        else:
            raise ValueError(op)
    printed = driver_list([json.loads(v) for v in result])
    frame({"en": f"Every call is answered, in order: {printed}.",
           "ko": f"모든 호출의 반환값을 차례로 모았습니다. 답은 {printed}입니다."},
          path=True, answer=printed)


for number, sample in enumerate(sample_cases(SLUG), start=1):
    ops_line, args_line = sample["input"].split("\n")
    run = sample_run(wt, number, sample, input=sample["input"])
    solve(json.loads(ops_line), json.loads(args_line), run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
