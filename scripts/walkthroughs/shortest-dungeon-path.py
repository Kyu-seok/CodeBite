#!/usr/bin/env python3.12
"""shortest-dungeon-path's Walkthrough: the reference solution (scripts/replay-solutions/shortest-dungeon-path.py),
a BFS from (0, 0) over the 8 neighbours of each tile, on each sample Test Case. The board is drawn as the
description's grid Diagram draws it, each tile reached tagged with the tiles on its shortest path so far (the
solution's `tiles`), with the queue beside it: a frame per tile leaving the front that reaches new tiles, one per
batch joining the back, and one for each run of tiles leaving that reach nothing.

    CODEBITE_DB=<database> scripts/walkthroughs/shortest-dungeon-path.py

writes common/src/main/resources/walkthroughs/shortest-dungeon-path.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import cell_name, josa, listed_cells, plural, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move  # noqa: E402

SLUG = "shortest-dungeon-path"

wt = Walkthrough(
    {"en": "Shortest Dungeon Path", "ko": "최단 던전 경로"},
    {"en": "BFS from (0, 0), stepping to all 8 neighbours: tiles leave the queue in order of how many tiles their "
           "path has, so the first time the far corner leaves the front, its count is the shortest path.",
     "ko": "(0, 0)에서 8방향 이웃으로 BFS를 합니다. 칸은 경로의 칸 수 순서대로 큐에서 나오므로, 반대편 모서리가 처음 큐 앞에서 "
           "나올 때의 칸 수가 가장 짧은 경로입니다."},
    views=[
        {"id": "board", "type": "grid",
         "title": {"en": "board (tag: tiles on the path so far)", "ko": "board (태그: 지금까지 경로의 칸 수)"},
         "values": {"0": {"label": {"en": "walkable", "ko": "통과 가능"}, "tone": "plain"},
                    "1": {"label": {"en": "blocked", "ko": "막힘"}, "tone": "wall"}}},
        {"id": "queue", "type": "queue", "title": {"en": "queue (tag: tiles)", "ko": "큐 (태그: 칸 수)"},
         "empty": {"en": "empty", "ko": "비어 있음"}},
    ],
)


def solve(board, run):
    """Solution.shortestPathLength with a frame per step. Returns nothing; the last frame carries the answer."""
    n = len(board)
    tiles = {}      # (r, c) -> tiles on the shortest path to it, in the order reached
    parent = {}     # (r, c) -> the tile that reached it, for the path the last frame marks
    queue = []      # front first, as the solution's deque
    leaving = 0     # how many at the front are leaving this frame, still drawn

    def frame(caption, lit=(), good=(), bad=(), path=(), queue_marks=None, moves=None, **answer):
        run.frame(caption,
                  board={"cells": board, "tags": [[r, c, str(t)] for (r, c), t in tiles.items()],
                         "marks": {"path": [list(p) for p in path], "bad": [list(p) for p in bad],
                                   "good": [list(p) for p in good], "lit": [list(p) for p in lit]}},
                  queue={"values": [cell_name(p) for p in queue], "tags": [[i, str(tiles[p])] for i, p in enumerate(queue)],
                         "marks": queue_marks or {}},
                  moves=moves, **answer)

    end = (n - 1, n - 1)
    frame({"en": f"A {n}×{n} board. Walk from (0,0) to ({cell_name(end)}), stepping to any of the 8 tiles around, "
                 f"and count the tiles on the shortest path.",
           "ko": f"{n}×{n} 보드입니다. 주변 8칸 중 어디로든 걸어 (0,0)에서 ({cell_name(end)})까지 가며, 가장 짧은 경로의 "
                 f"칸 수를 셉니다."})
    blocked = [p for p in ((0, 0), end) if board[p[0]][p[1]]]
    if blocked:
        frame({"en": f"{listed_cells(blocked)} is blocked, so no path can use it: answer -1.",
               "ko": f"{listed_cells(blocked)} 칸이 막혀 있어 어떤 경로도 지날 수 없습니다: 답은 -1입니다."},
              bad=blocked, answer="-1")
        return
    tiles[(0, 0)] = 1
    queue.append((0, 0))
    frame({"en": "Both corners are walkable. (0,0) starts a path of 1 tile and joins the queue.",
           "ko": "두 모서리 모두 통과할 수 있습니다. (0,0) 칸이 칸 수 1인 경로로 시작해 큐에 들어갑니다."},
          good=[(0, 0)], queue_marks={"good": [0]},
          moves=[move(None, at("board", [0, 0]), value="1"), move(at("board", [0, 0]), at("queue", 0), value="0,0")])

    def flush():
        """One frame for the tiles in a row at the front that reached nothing new."""
        nonlocal leaving
        if not leaving:
            return
        k = leaving
        gone = queue[:k]
        frame({"en": f"{listed_cells(gone)} {plural(k, 'leaves', 'leave')} the front: no tile around "
                     f"{plural(k, 'it', 'them')} is walkable and not reached yet.",
               "ko": f"{listed_cells(gone)} 칸이 큐 앞에서 나오지만, 주변에 통과 가능하면서 아직 닿지 않은 칸이 없습니다."},
              lit=gone, queue_marks={"lit": list(range(k))}, moves=[move(at("queue", i)) for i in range(k)])
        del queue[:k]
        leaving = 0

    i = 0
    while i < len(queue):
        r, c = queue[i]
        if (r, c) == end:
            flush()
            t = tiles[end]
            route = [end]
            while route[-1] in parent:
                route.append(parent[route[-1]])
            route.reverse()
            frame({"en": f"({cell_name(end)}) leaves the front: it is the far corner, reached on a path of {t} tiles, "
                         f"{' → '.join(f'({cell_name(p)})' for p in route)}. Answer: {t}.",
                   "ko": f"({cell_name(end)}) 칸이 큐 앞에서 나옵니다. 반대편 모서리이고 {' → '.join(f'({cell_name(p)})' for p in route)} "
                         f"경로의 칸 {t}개로 닿았으므로 답은 {t}입니다."},
                  path=route, queue_marks={"path": [0]}, answer=str(t))
            return
        added = []
        for dr in (-1, 0, 1):
            for dc in (-1, 0, 1):
                nr, nc = r + dr, c + dc
                if 0 <= nr < n and 0 <= nc < n and board[nr][nc] == 0 and (nr, nc) not in tiles \
                        and (nr, nc) not in added:
                    added.append((nr, nc))
        if not added:
            leaving += 1
            i += 1
            continue
        flush()
        t = tiles[(r, c)]
        for p in added:
            tiles[p] = t + 1
            parent[p] = (r, c)
        k = len(added)
        frame({"en": f"({cell_name((r, c))}) leaves the front with {t} {plural(t, 'tile', 'tiles')}: {listed_cells(added)} "
                     f"{plural(k, 'is', 'are')} walkable and not reached yet, so {plural(k, 'it gets', 'they get')} "
                     f"{t} + 1 = {t + 1}.",
               "ko": f"칸 수 {t}인 ({cell_name((r, c))}) 칸이 큐 앞에서 나옵니다. 통과 가능하고 아직 닿지 않은 "
                     f"{listed_cells(added)} 칸은 {t} + 1 = {josa(t + 1, '을를')} 받습니다."},
              lit=[(r, c)], good=added, queue_marks={"lit": [0]},
              moves=[move(at("queue", 0), at("board", list(p)), value=str(t + 1)) for p in added])
        queue.pop(0)
        back = len(queue)
        queue.extend(added)
        frame({"en": f"{plural(k, 'It joins', 'They join')} the back of the queue, after every tile with {t} "
                     f"{plural(t, 'tile', 'tiles')}.",
               "ko": f"새로 닿은 칸 {k}개가 칸 수 {t}인 칸들 뒤로 큐에 들어갑니다."},
              good=added, queue_marks={"good": list(range(back, len(queue)))},
              moves=[move(at("board", list(p)), at("queue", back + j), value=cell_name(p)) for j, p in enumerate(added)])
        i = 0
    flush()
    frame({"en": f"The queue is empty and ({cell_name(end)}) was never reached: answer -1.",
           "ko": f"큐가 비었는데 ({cell_name(end)}) 칸에 끝내 닿지 못했으므로 답은 -1입니다."},
          bad=[end], answer="-1")


for number, sample in enumerate(sample_cases(SLUG), start=1):
    board = json.loads(sample["input"])
    run = sample_run(wt, number, sample, input=f"board = {sample['input']}")
    solve(board, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
