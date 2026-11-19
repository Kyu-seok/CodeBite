#!/usr/bin/env python3.12
"""walls-and-gates' Walkthrough: the reference solution (scripts/replay-solutions/walls-and-gates.py), a multi-source
BFS from every gate at once, on each sample Test Case. The rooms are drawn as the description's grid Diagram draws
them (INF for an empty room), with the queue beside them: a frame per room leaving the front that fills a neighbour,
one per batch joining the back, and one for each run of rooms leaving that fill nothing.

    CODEBITE_DB=<database> scripts/walkthroughs/walls-and-gates.py

writes common/src/main/resources/walkthroughs/walls-and-gates.json.
"""
import copy
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import cell_name, driver_list, josa, listed_cells, plural, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move  # noqa: E402

SLUG = "walls-and-gates"
EMPTY = 2147483647

wt = Walkthrough(
    {"en": "Walls and Gates", "ko": "벽과 문 거리 채우기"},
    {"en": "Multi-source BFS: every gate starts in the queue, so each room is first reached from its nearest gate, "
           "and it takes the distance of the room that reached it plus 1.",
     "ko": "다중 출발 BFS: 문이 모두 큐에서 시작하므로 각 방은 가장 가까운 문에서 처음 닿고, 자신에게 닿은 칸의 거리에 "
           "1을 더한 값을 받습니다."},
    views=[
        {"id": "rooms", "type": "grid", "title": {"en": "rooms", "ko": "rooms (방)"},
         "values": {"-1": {"label": {"en": "wall", "ko": "벽"}, "tone": "wall", "glyph": ""},
                    "0": {"label": {"en": "gate", "ko": "문"}, "tone": "b"},
                    str(EMPTY): {"label": {"en": "empty room (INF)", "ko": "빈 방 (INF)"}, "tone": "empty",
                                 "glyph": "INF"}}},
        {"id": "queue", "type": "queue", "title": {"en": "queue (tag: distance)", "ko": "큐 (태그: 거리)"},
         "empty": {"en": "empty", "ko": "비어 있음"}},
    ],
)


def solve(rooms, run):
    """Solution.wallsAndGates with a frame per step. Returns the rooms as the Driver prints them."""
    rows, cols = len(rooms), len(rooms[0])
    queue = []      # front first, as the solution's deque
    leaving = 0     # how many at the front are leaving this frame, still drawn

    def frame(caption, lit=(), good=(), path=(), queue_marks=None, moves=None, **answer):
        run.frame(caption,
                  rooms={"cells": rooms,
                         "marks": {"lit": [list(p) for p in lit], "good": [list(p) for p in good],
                                   "path": [list(p) for p in path]}},
                  queue={"values": [cell_name(p) for p in queue],
                         "tags": [[i, str(rooms[p[0]][p[1]])] for i, p in enumerate(queue)],
                         "marks": queue_marks or {}},
                  moves=moves, **answer)

    gates = [(r, c) for r in range(rows) for c in range(cols) if rooms[r][c] == 0]
    empty = sum(row.count(EMPTY) for row in rooms)
    queue = list(gates)
    g = len(gates)
    if not gates:
        frame({"en": f"A {rows}×{cols} grid with {empty} empty {plural(empty, 'room', 'rooms')} and no gate, so the "
                     f"queue starts empty.",
               "ko": f"{rows}×{cols} 격자에 빈 방이 {empty}개 있지만 문이 없어서 큐가 빈 채로 시작합니다."})
    else:
        frame({"en": f"A {rows}×{cols} grid with {empty} empty {plural(empty, 'room', 'rooms')}. Every gate, "
                     f"{listed_cells(gates)}, joins the queue at distance 0.",
               "ko": f"{rows}×{cols} 격자에 빈 방이 {empty}개 있습니다. 문 {g}개, {listed_cells(gates)} 칸이 모두 거리 0으로 "
                     f"큐에 들어갑니다."},
              lit=gates, queue_marks={"good": list(range(g))},
              moves=[move(at("rooms", list(p)), at("queue", i), value=cell_name(p)) for i, p in enumerate(gates)])

    def flush():
        """One frame for the rooms in a row at the front that filled nothing."""
        nonlocal leaving
        if not leaving:
            return
        k = leaving
        gone = queue[:k]
        end = {"en": " The queue is empty.", "ko": " 큐가 비었습니다."} if k == len(queue) else {"en": "", "ko": ""}
        frame({"en": f"{listed_cells(gone)} {plural(k, 'leaves', 'leave')} the front: every neighbour is a wall, "
                     f"a gate or already filled." + end["en"],
               "ko": f"{listed_cells(gone)} 칸이 큐 앞에서 나오지만, 이웃이 모두 벽이거나 문이거나 이미 채워졌습니다."
                     + end["ko"]},
              lit=gone, queue_marks={"lit": list(range(k))}, moves=[move(at("queue", i)) for i in range(k)])
        del queue[:k]
        leaving = 0

    i = 0
    while i < len(queue):
        r, c = queue[i]
        added = []
        for nr, nc in ((r + 1, c), (r - 1, c), (r, c + 1), (r, c - 1)):
            if 0 <= nr < rows and 0 <= nc < cols and rooms[nr][nc] == EMPTY and (nr, nc) not in added:
                added.append((nr, nc))
        if not added:
            leaving += 1
            i += 1
            continue
        flush()
        d = rooms[r][c] + 1
        for nr, nc in added:
            rooms[nr][nc] = d
        n = len(added)
        frame({"en": f"({cell_name((r, c))}) leaves the front at distance {rooms[r][c]}: {listed_cells(added)} "
                     f"{plural(n, 'is an empty room', 'are empty rooms')}, so {plural(n, 'it gets', 'they get')} "
                     f"{rooms[r][c]} + 1 = {d}.",
               "ko": f"거리 {rooms[r][c]}인 ({cell_name((r, c))}) 칸이 큐 앞에서 나옵니다. 빈 방 {listed_cells(added)} 칸은 "
                     f"거리 {rooms[r][c]} + 1 = {josa(d, '을를')} 받습니다."},
              lit=[(r, c)], good=added, queue_marks={"lit": [0]},
              moves=[move(at("queue", 0), at("rooms", list(p)), value=str(d)) for p in added])
        queue.pop(0)
        back = len(queue)
        queue.extend(added)
        frame({"en": f"{plural(n, 'It joins', 'They join')} the back of the queue, after every room at distance "
                     f"{d - 1}.",
               "ko": f"새로 채운 방 {n}개가 거리 {d - 1}의 칸들 뒤로 큐에 들어갑니다."},
              good=added, queue_marks={"good": list(range(back, len(queue)))},
              moves=[move(at("rooms", list(p)), at("queue", back + j), value=cell_name(p)) for j, p in enumerate(added)])
        i = 0
    flush()
    result = driver_list(rooms)
    left = [(r, c) for r in range(rows) for c in range(cols) if rooms[r][c] == EMPTY]
    filled = [(r, c) for r in range(rows) for c in range(cols) if rooms[r][c] not in (EMPTY, -1, 0)]
    if not gates:
        frame({"en": f"With no gate, no room is reached: all {empty} stay INF (2147483647). Answer: {result}.",
               "ko": f"문이 없으니 어떤 방에도 닿지 않아 {empty}개 모두 INF(2147483647)로 남습니다. 답은 {result}입니다."},
              lit=left, answer=result)
    else:
        unreached = ({"en": f", and {listed_cells(left)} stayed INF", "ko": f"고 {listed_cells(left)} 칸은 INF로 남았습니다"}
                     if left else {"en": "", "ko": ""})
        frame({"en": f"Every room reachable now holds its distance to the nearest gate"
                     f"{unreached['en']}. Answer: {result}.",
               "ko": f"닿을 수 있는 방마다 가장 가까운 문까지의 거리가 채워졌{unreached['ko'] or '습니다'}. 답은 {result}입니다."},
              path=filled, answer=result)


for number, sample in enumerate(sample_cases(SLUG), start=1):
    rooms = json.loads(sample["input"])
    run = sample_run(wt, number, sample, input=f"rooms = {sample['input']}")
    solve(copy.deepcopy(rooms), run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
