#!/usr/bin/env python3.12
"""top-espresso-machines' Walkthrough: the reference solution (scripts/replay-solutions/top-espresso-machines.py),
a count per machine in a hash map and then the k highest counts. Each check-in moves into its machine's card, a
ranking step badges the cards, and the top k move onto the whiteboard, on each sample Test Case.

    CODEBITE_DB=<database> scripts/walkthroughs/top-espresso-machines.py

writes common/src/main/resources/walkthroughs/top-espresso-machines.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import driver_list, josa, plural, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, map_entries, move  # noqa: E402

SLUG = "top-espresso-machines"
EMPTY = {"en": "empty", "ko": "비어 있음"}

wt = Walkthrough(
    {"en": "Top Espresso Machines", "ko": "가장 바빴던 머신 목록"},
    {"en": "Count every machine's check-ins in a hash map in one pass; the k machines with the highest counts are the answer.",
     "ko": "한 번 훑으며 머신마다 사용 횟수를 해시 맵에 세고, 횟수가 가장 큰 머신 k개가 답입니다."},
    views=[
        {"id": "log", "type": "array", "title": {"en": "checkIns", "ko": "checkIns"}},
        {"id": "uses", "type": "map", "title": {"en": "uses per machine (hash map)", "ko": "머신별 사용 횟수 (해시 맵)"},
         "empty": EMPTY},
        {"id": "board", "type": "output", "title": {"en": "whiteboard", "ko": "화이트보드"}, "empty": EMPTY},
        {"id": "state", "type": "vars"},
    ],
)


def solve(check_ins, k, run):
    """Solution.busiestMachines (Counter(checkIns).most_common(k)) with a frame per check-in and per machine
    posted. Returns the answer as the Driver prints it (sorted)."""
    counts = {}  # machine -> uses, in first-seen order as Counter keeps them
    ranked, board = [], []

    def frame(caption, at_i=None, marks=None, moves=None, **answer):
        run.frame(caption,
                  log={"values": check_ins, "pointers": {"i": at_i},
                       "marks": {"lit": [at_i] if at_i is not None else []}},
                  uses={"entries": map_entries(counts), "marks": marks or {}, **({"ranks": ranked} if ranked else {})},
                  board={"values": board},
                  state={"items": [{"label": "k", "value": k}]},
                  moves=moves, **answer)

    frame({"en": f"Walk the {len(check_ins)} check-ins once and count each machine's uses in a hash map; "
                 f"then post the {k} machines with the most uses.",
           "ko": f"체크인 {len(check_ins)}개를 한 번 훑으며 머신마다 사용 횟수를 해시 맵에 셉니다. "
                 f"그다음 가장 많이 쓰인 머신 {k}개를 화이트보드에 적습니다."})
    for i, machine in enumerate(check_ins):
        before = counts.get(machine, 0)
        counts[machine] = before + 1
        if before:
            caption = {"en": f"checkIns[{i}] is machine {machine}, already in the map: its count goes "
                             f"{before} → {before + 1}.",
                       "ko": f"checkIns[{i}] = {machine}: 이미 맵에 있는 머신이므로 "
                             f"사용 횟수를 1 늘립니다 ({before} → {before + 1})."}
        else:
            caption = {"en": f"checkIns[{i}] is machine {machine}, not in the map yet: it goes in with count 1.",
                       "ko": f"checkIns[{i}] = {machine}: 아직 맵에 없는 머신이므로 사용 횟수 1로 들어갑니다."}
        frame(caption, at_i=i, marks={"good": [machine]}, moves=[move(at("log", i), at("uses", machine))])

    # most_common keeps first-seen order among equal counts, as a stable sort does
    ranked = sorted(counts, key=lambda m: counts[m], reverse=True)
    top, rest = ranked[:k], ranked[k:]
    order = ", ".join(f"{m} ({counts[m]})" for m in ranked)
    frame({"en": f"Every check-in is counted; ranked by uses, the machines are {order}. "
                 f"The top {k} go on the whiteboard.",
           "ko": f"체크인을 모두 세었고, 사용 횟수 순으로 놓으면 {order}입니다. "
                 f"상위 {josa(k, '이가')} 화이트보드에 올라갑니다."},
          marks={"path": top, "dim": rest})
    answer = driver_list(sorted(top))
    for j, machine in enumerate(top):
        board.append(machine)
        last = j == len(top) - 1
        uses = f"{counts[machine]} {plural(counts[machine], 'use', 'uses')}"
        if not last:
            en = f"#{j + 1} is machine {machine} with {uses}: it goes on the whiteboard."
            ko = f"{j + 1}위는 머신 {machine}(사용 횟수 {counts[machine]}회)이므로 화이트보드에 적습니다."
        elif board == sorted(board):
            en = f"#{j + 1} is machine {machine} with {uses}, the last of the top {k}. The whiteboard reads {answer}: the answer."
            ko = f"{j + 1}위는 머신 {machine}(사용 횟수 {counts[machine]}회)으로 상위 {k}개의 마지막입니다. 답은 {answer}입니다."
        else:
            en = f"#{j + 1} is machine {machine} with {uses}, the last of the top {k}. Listed smallest id first, the answer is {answer}."
            ko = f"{j + 1}위는 머신 {machine}(사용 횟수 {counts[machine]}회)으로 상위 {k}개의 마지막입니다. 작은 번호부터 적으면 답은 {answer}입니다."
        frame({"en": en, "ko": ko}, marks={"path": top, "dim": rest},
              moves=[move(at("uses", machine), at("board", j))],
              **({"answer": answer} if last else {}))


for number, sample in enumerate(sample_cases(SLUG), start=1):
    nums_line, k_line = sample["input"].split("\n")
    check_ins, k = json.loads(nums_line), int(k_line)
    run = sample_run(wt, number, sample, input=f"checkIns = {nums_line}, k = {k}")
    solve(check_ins, k, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
