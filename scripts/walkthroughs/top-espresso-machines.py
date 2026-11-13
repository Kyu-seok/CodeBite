#!/usr/bin/env python3.12
"""top-espresso-machines' Walkthrough: the reference solution (scripts/replay-solutions/top-espresso-machines.py),
a count per machine in a hash map and then the k highest counts, recording one frame per check-in on each
sample Test Case.

    CODEBITE_DB=<database> scripts/walkthroughs/top-espresso-machines.py

writes common/src/main/resources/walkthroughs/top-espresso-machines.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import driver_list, plural, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough  # noqa: E402

SLUG = "top-espresso-machines"

wt = Walkthrough(
    {"en": "Top Espresso Machines", "ko": "가장 바빴던 머신 목록"},
    {"en": "Count every machine's check-ins in a hash map in one pass; the k machines with the highest counts are the answer.",
     "ko": "한 번 훑으며 머신마다 사용 횟수를 해시 맵에 세고, 횟수가 가장 큰 머신 k개가 답입니다."},
    views=[
        {"id": "log", "type": "array", "title": {"en": "checkIns", "ko": "checkIns"}},
        {"id": "counts", "type": "table", "title": {"en": "uses per machine (hash map)", "ko": "머신별 사용 횟수 (해시 맵)"}},
        {"id": "state", "type": "vars"},
    ],
)


def solve(check_ins, k, run):
    """Solution.busiestMachines (Counter(checkIns).most_common(k)) with a frame per check-in.
    Returns the answer as the Driver prints it (sorted)."""
    counts = {}  # machine -> uses, in first-seen order as Counter keeps them
    top = []

    def frame(caption, at=None, row_marks=None, **answer):
        machines = list(counts)
        marks = {name: [[machines.index(m), 0] for m in ms] for name, ms in (row_marks or {}).items()}
        run.frame(caption,
                  log={"values": check_ins, "pointers": {"i": at},
                       "marks": {"lit": [at] if at is not None else []}},
                  counts={"columns": [{"en": "uses", "ko": "사용 횟수"}],
                          "rows": [{"label": {"en": f"machine {m}", "ko": f"머신 {m}"}, "cells": [c]}
                                   for m, c in counts.items()],
                          "marks": marks},
                  state={"items": [
                      {"label": "k", "value": k},
                      {"label": {"en": "whiteboard", "ko": "화이트보드"}, "value": top,
                       "empty": {"en": "empty", "ko": "비어 있음"}, "mark": "path" if top else None}]},
                  **answer)

    frame({"en": f"Walk the {len(check_ins)} check-ins once and count each machine's uses in a hash map; "
                 f"then post the {k} machines with the most uses.",
           "ko": f"체크인 {len(check_ins)}개를 한 번 훑으며 머신마다 사용 횟수를 해시 맵에 셉니다. "
                 f"그다음 가장 많이 쓰인 머신 {k}개를 적습니다."})
    for i, machine in enumerate(check_ins):
        before = counts.get(machine, 0)
        counts[machine] = before + 1
        if before:
            caption = {"en": f"checkIns[{i}] is machine {machine}, already in the map: its count goes "
                             f"{before} → {before + 1}.",
                       "ko": f"checkIns[{i}] = {machine}: 이미 맵에 있는 머신이므로 "
                             f"사용 횟수를 1 늘립니다 ({before} → {before + 1})."}
        else:
            caption = {"en": f"checkIns[{i}] is machine {machine}, not in the map yet: add it with count 1.",
                       "ko": f"checkIns[{i}] = {machine}: 아직 맵에 없는 머신이므로 사용 횟수 1로 추가합니다."}
        frame(caption, at=i, row_marks={"good": [machine]})
    ranked = sorted(counts.items(), key=lambda mc: mc[1], reverse=True)
    top = [m for m, _ in ranked[:k]]
    answer = driver_list(sorted(top))
    order = ", ".join(f"{m} ({c})" for m, c in ranked)
    picked = ", ".join(str(m) for m in top)
    frame({"en": f"Every check-in is counted, and ranked by uses they are {order}. The top {k} "
                 f"{plural(k, 'is', 'are')} {picked}: answer {answer}.",
           "ko": f"체크인을 모두 세어 사용 횟수 순으로 놓으면 {order}입니다. 상위 {k}개는 머신 {picked}이므로 "
                 f"답은 {answer}입니다."},
          row_marks={"path": top, "dim": [m for m, _ in ranked[k:]]}, answer=answer)


for number, sample in enumerate(sample_cases(SLUG), start=1):
    nums_line, k_line = sample["input"].split("\n")
    check_ins, k = json.loads(nums_line), int(k_line)
    run = sample_run(wt, number, sample, input=f"checkIns = {nums_line}, k = {k}")
    solve(check_ins, k, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
