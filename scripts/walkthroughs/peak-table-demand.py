#!/usr/bin/env python3.12
"""peak-table-demand's Walkthrough: the reference solution (scripts/replay-solutions/peak-table-demand.py), a sweep
over the visits by arrival with a min-heap of the minutes the tables in use free up, recording one frame per visit
on each sample Test Case.

The visits and the tables are groups on one number line: each table is a group holding the visits seated there, so
the heap's values are the tables' last leave minutes, drawn on the data. Each arrival is a point on the axis beside
the earliest leave (the heap's top); the visit moves into the table that frees up first, or opens a new one.

    CODEBITE_DB=<database> scripts/walkthroughs/peak-table-demand.py

writes common/src/main/resources/walkthroughs/peak-table-demand.json.
"""
import heapq
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import josa, plural, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move  # noqa: E402

SLUG = "peak-table-demand"
SORTED = {"en": "visits, by arrival", "ko": "도착 순으로 정렬한 방문"}
ARRIVE = {"en": "arrive", "ko": "도착"}

wt = Walkthrough(
    {"en": "Peak Table Demand", "ko": "피크 시간 테이블 수요"},
    {"en": "Seat the groups in order of arrival, keeping the minute each table in use frees up: a group takes the "
           "table that frees up first if it is free by then, and opens a new table otherwise.",
     "ko": "도착 순으로 팀을 앉히며 사용 중인 테이블마다 비는 시각을 기억합니다. 가장 먼저 비는 테이블이 도착 "
           "시각까지 비면 그 자리에 앉히고, 아니면 테이블을 하나 더 씁니다."},
    views=[
        {"id": "line", "type": "intervals", "empty": {"en": "none yet", "ko": "아직 없음"}},
    ],
)


def table(t):
    return {"en": f"table {t + 1}", "ko": f"테이블 {t + 1}"}


def iv(w):
    return f"[{w[0]},{w[1]}]"


def solve(visits, run):
    """Solution.minTables with a frame per visit. Returns the answer as the Driver prints it."""
    ordered = sorted(visits)
    leaving = []  # (leave minute, table): the solution's heap of leave minutes, with the table each one is
    tables = []   # the visits seated at each table

    def frame(caption, read=None, done=0, table_marks=None, points=(), moves=None, **answer):
        sorted_marks = {"dim": list(range(done))}
        if read is not None:
            sorted_marks["lit"] = [read]
        groups = [{"label": SORTED, "intervals": ordered, "marks": sorted_marks}]
        for t, seated in enumerate(tables):
            groups.append({"label": table(t), "intervals": seated, "marks": (table_marks or {}).get(t, {})})
        run.frame(caption, line={"groups": groups, "points": [
            {"at": at_, "label": label, "mark": mark} for at_, label, mark in points]}, moves=moves, **answer)

    if not ordered:
        frame({"en": "No visits, so no tables are needed. Answer: 0.",
               "ko": "방문한 팀이 없으므로 테이블이 필요 없습니다. 답은 0입니다."}, answer="0")
        return
    frame({"en": f"Sort the {len(ordered)} visits by arrival: {', '.join(iv(v) for v in ordered)}. "
                 "No table is in use yet.",
           "ko": f"방문 {len(ordered)}개를 도착 시각 순으로 정렬합니다: {', '.join(iv(v) for v in ordered)}. "
                 "아직 사용 중인 테이블이 없습니다."})
    for i, (arrive, leave) in enumerate(ordered):
        visit = iv((arrive, leave))
        if leaving and leaving[0][0] <= arrive:
            free_at, t = leaving[0]
            heapq.heapreplace(leaving, (leave, t))
            tables[t].append([arrive, leave])
            frame({"en": f"{visit} arrives at {arrive}. The first table to free up, {table(t)['en']}, is free from "
                         f"{free_at} ≤ {arrive}, so the group takes it.",
                   "ko": f"{visit} 팀이 {arrive}분에 도착합니다. 가장 먼저 비는 테이블 {josa(t + 1, '이가')} {free_at}분에 비어 "
                         f"{arrive}분 이전이므로 그 자리에 앉습니다."},
                  read=i, done=i, table_marks={t: {"lit": [len(tables[t]) - 2], "good": [len(tables[t]) - 1]}},
                  points=[(arrive, ARRIVE, "lit")],
                  moves=[move(at("line", [0, i]), at("line", [1 + t, len(tables[t]) - 1]))])
        else:
            t = len(tables)
            if leaving:
                free_at = leaving[0][0]
                why_en = f"Even the first table to free up is busy until {free_at} > {arrive}"
                why_ko = f"가장 먼저 비는 테이블도 {free_at}분까지 차 있어 {arrive}분보다 늦으므로"
                busy = leaving[0][1]
                marks = {busy: {"bad": [len(tables[busy]) - 1]}}
            else:
                why_en = "No table is in use yet"
                why_ko = "아직 사용 중인 테이블이 없으므로"
                marks = {}
            heapq.heappush(leaving, (leave, t))
            peak_at = arrive  # the last table opened: from here every table is in use at once
            tables.append([[arrive, leave]])
            frame({"en": f"{visit} arrives at {arrive}. {why_en}, so it opens {table(t)['en']}.",
                   "ko": f"{visit} 팀이 {arrive}분에 도착합니다. {why_ko} 테이블 {josa(t + 1, '을를')} 새로 씁니다."},
                  read=i, done=i, table_marks={**marks, t: {"good": [0]}}, points=[(arrive, ARRIVE, "lit")],
                  moves=[move(at("line", [0, i]), at("line", [1 + t, 0]))])
    k = len(leaving)
    if k == 1:
        caption = {"en": "Every group is seated at table 1: each one arrived after the one before had left. Answer: 1.",
                   "ko": "모든 팀이 테이블 1에 앉았습니다. 앞 팀이 떠난 뒤에 다음 팀이 왔기 때문입니다. 답은 1입니다."}
        points = []
    else:
        caption = {"en": f"Every group is seated, at {k} {plural(k, 'table', 'tables')}: from minute {peak_at}, all "
                         f"of them were in use at once. Answer: {k}.",
                   "ko": f"모든 팀이 테이블 {k}개에 앉았고, {peak_at}분부터는 {k}개 모두 동시에 쓰였습니다. "
                         f"답은 {k}입니다."}
        points = [(peak_at, {"en": f"{k} at once", "ko": f"동시에 {k}개"}, "path")]
    frame(caption, done=len(ordered), points=points,
          table_marks={t: {"path": list(range(len(s)))} for t, s in enumerate(tables)}, answer=str(k))

for number, sample in enumerate(sample_cases(SLUG), start=1):
    visits = json.loads(sample["input"])
    values = [v for w in visits for v in w]
    run = sample_run(wt, number, sample, input=f"visits = {sample['input']}",
                     setup={"line": {"domain": [min(values), max(values)]}} if values else None)
    solve(visits, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
