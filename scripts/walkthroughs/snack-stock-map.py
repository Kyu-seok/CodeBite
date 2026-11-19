#!/usr/bin/env python3.12
"""snack-stock-map's Walkthrough: the reference solution (scripts/replay-solutions/snack-stock-map.py), a map built
from 2069 buckets of [key, value] entries (separate chaining), driven by the sample's list of calls, recording one
frame per call on each sample Test Case, plus an extra run where two keys share a bucket.

The call-list pattern (add-walkthrough views.md): the calls are a table, one row per call, the current one lit and
those before it faded, each call's return value moves into an `output` (the Driver's printed list), and the buckets
change underneath: a table with one row per bucket the run's calls touch (the other buckets stay empty), one column
per entry in its chain.

    CODEBITE_DB=<database> scripts/walkthroughs/snack-stock-map.py

writes common/src/main/resources/walkthroughs/snack-stock-map.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import driver_list, josa, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move  # noqa: E402

SLUG = "snack-stock-map"
BUCKETS = 2069

wt = Walkthrough(
    {"en": "Snack Stock Map", "ko": "간식 재고 맵"},
    {"en": f"Each key goes to bucket key % {BUCKETS}, a short list of [key, value] entries: set, lookup and erase "
           "walk only that one list, so keys that share a bucket simply chain one after another.",
     "ko": f"키마다 key % {BUCKETS}번 버킷으로 갑니다. 버킷은 [key, value] 항목의 짧은 리스트이고, set·lookup·erase는 "
           "그 리스트 하나만 훑으므로 같은 버킷에 온 키들은 차례로 이어 붙습니다."},
    views=[
        {"id": "calls", "type": "table", "title": {"en": "calls", "ko": "호출"}},
        {"id": "buckets", "type": "table",
         "title": {"en": f"buckets used, of {BUCKETS} (key: value)",
                   "ko": f"쓰는 버킷, {BUCKETS}개 중 (key: value)"}},
        {"id": "result", "type": "output", "title": {"en": "returned", "ko": "반환값"}},
    ],
)


def entry(e):
    return f"{e[0]}: {e[1]}"


def solve(ops, args, run):
    """The Driver's loop over the calls with the reference ChainedMap inside, a frame per call. Returns the printed
    list."""
    n = len(ops)
    rows = [{"label": str(i), "cells": [op, ", ".join(str(x) for x in a)]} for i, (op, a) in enumerate(zip(ops, args))]
    touched = sorted({a[0] % BUCKETS for op, a in zip(ops, args) if op != "ChainedMap"})
    buckets = {b: [] for b in touched}  # the touched buckets of ChainedMap.buckets; every other one stays []
    # as many entry columns as the longest chain the run builds
    width, held = 1, {b: [] for b in touched}
    for op, a in zip(ops[1:], args[1:]):
        chain = held[a[0] % BUCKETS]
        if op == "set" and a[0] not in chain:
            chain.append(a[0])
        elif op == "erase" and a[0] in chain:
            chain.remove(a[0])
        width = max(width, len(chain))
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
                  buckets={"columns": [{"en": f"entry {c}", "ko": f"항목 {c}"} for c in range(width)],
                           "rows": [{"label": f"[{b}]", "cells": [entry(e) for e in buckets[b]] +
                                     [""] * (width - len(buckets[b]))} for b in touched],
                           "marks": cell_marks or {}},
                  result={"values": result, "marks": {"path": list(range(len(result)))} if path else {"good": fresh}},
                  moves=moves, **answer)

    def returned(value):
        result.append(json.dumps(value))
        return len(result) - 1

    def null():
        return move(at("calls", [i, 0]), at("result", returned(None)), value="null")

    returned(None)
    frame({"en": f"ChainedMap() makes {BUCKETS} empty buckets; only the ones this run's keys land in are drawn. "
                 "It returns null.",
           "ko": f"ChainedMap(): 빈 버킷 {BUCKETS}개를 만들고 null을 반환합니다. 이 실행의 키가 들어가는 버킷만 그립니다."})
    for i in range(1, n):
        op, a = ops[i], args[i]
        key = a[0]
        b = key % BUCKETS
        r = touched.index(b)
        chain = buckets[b]
        where = f"{key} % {BUCKETS} = {b}"
        # the entries the walk reads before it finds the key or runs out: all of them on a miss
        found = next((j for j, e in enumerate(chain) if e[0] == key), None)
        read = list(range(len(chain) if found is None else found + 1))
        passed = ", ".join(entry(chain[j]) for j in read if j != found)
        # the walk to a held key, and the walk past every entry to a miss, in each language
        hit = {"en": f"bucket {where} holds key {key}" + (f", after {passed}" if passed else ""),
               "ko": f"{where}번 버킷에서 " + (f"{passed} 항목 다음의 " if passed else "") + f"키 {key} 항목을 찾아"}
        miss = {"en": f"bucket {where} " + (f"holds {passed} but no key {key}" if passed else "is empty"),
                "ko": f"{where}번 버킷" + (f"에는 {passed} 항목뿐이고 키 {key} 항목이 없으므로" if passed
                                          else "이 비어 있으므로")}
        if op == "set":
            value = a[1]
            if found is not None:
                old = chain[found][1]
                chain[found][1] = value
                frame({"en": f"set({key}, {value}): {hit['en']}, so its count {old} is replaced by {value}. "
                             "It returns null.",
                       "ko": f"set({key}, {value}): {hit['ko']} 수량 {josa(old, '을를')} {josa(value, '(으)로')} "
                             "바꿉니다. null을 반환합니다."},
                      cell_marks={"lit": [[r, j] for j in read if j != found], "good": [[r, found]]},
                      moves=[move(at("calls", [i, 1]), at("buckets", [r, found]), value=str(value)), null()])
            else:
                chain.append([key, value])
                frame({"en": f"set({key}, {value}): {miss['en']}, so [{key}, {value}] is appended to "
                             f"{'the end of its chain' if passed else 'it'}. It returns null.",
                       "ko": f"set({key}, {value}): {miss['ko']} [{key}, {value}] 항목을 "
                             f"{'체인 끝에 ' if passed else ''}붙입니다. null을 반환합니다."},
                      cell_marks={"lit": [[r, j] for j in read], "good": [[r, len(chain) - 1]]},
                      moves=[move(at("calls", [i, 1]), at("buckets", [r, len(chain) - 1]), value=entry([key, value])),
                             null()])
        elif op == "lookup":
            if found is not None:
                value = chain[found][1]
                k = returned(value)
                frame({"en": f"lookup({key}): {hit['en']}; it returns its count, {value}.",
                       "ko": f"lookup({key}): {hit['ko']} 수량 {josa(value, '을를')} 반환합니다."},
                      cell_marks={"lit": [[r, j] for j in read]},
                      moves=[move(at("buckets", [r, found]), at("result", k), value=str(value))])
            else:
                frame({"en": f"lookup({key}): {miss['en']}, so it returns -1.",
                       "ko": f"lookup({key}): {miss['ko']} -1을 반환합니다."},
                      cell_marks={"bad": [[r, j] for j in read] or [[r, 0]]},
                      moves=[move(at("calls", [i, 0]), at("result", returned(-1)), value="-1")])
        elif op == "erase":
            if found is not None:
                if found != len(chain) - 1:
                    # list.pop(found) would shift the entries behind it left, which a table cell can't show leaving
                    raise SystemExit(f"{SLUG}: erase({key}) takes an entry from the middle of its chain; draw the shift")
                left = chain.pop(found)
                frame({"en": f"erase({key}): {hit['en']}, the last entry of its chain, and pops it out. "
                             "It returns null.",
                       "ko": f"erase({key}): {hit['ko']} 뺍니다(체인의 마지막 항목이라 다른 항목은 그대로). "
                             "null을 반환합니다."},
                      cell_marks={"lit": [[r, j] for j in read if j != found], "bad": [[r, found]]},
                      moves=[move(at("buckets", [r, found]), value=entry(left)), null()])
            else:
                frame({"en": f"erase({key}): {miss['en']}, so nothing changes. It returns null.",
                       "ko": f"erase({key}): {miss['ko']} 아무것도 바꾸지 않습니다. null을 반환합니다."},
                      cell_marks={"lit": [[r, j] for j in read] or [[r, 0]]}, moves=[null()])
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
# No sample puts two keys in one bucket: this run chains 2070 behind 1 (2070 % 2069 = 1), so its lookups walk past 1.
ops = ["ChainedMap", "set", "set", "lookup", "erase", "lookup"]
args = [[], [1, 10], [2070, 5], [2070], [2070], [2070]]
run = wt.run({"en": "Extra: two keys, one bucket", "ko": "추가: 한 버킷에 키 두 개"}, input=f"{driver_list(ops)}\n{driver_list(args)}",
             expected="[null,null,null,5,null,-1]", extra=True)
solve(ops, args, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
