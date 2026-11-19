#!/usr/bin/env python3.12
"""rising-water-path's Walkthrough: the reference solution (scripts/replay-solutions/rising-water-path.py), a walk
that always steps onto the lowest tile bordering the explored area (a min-heap of (height, row, col)), recording a
frame per pop and one for the neighbours each step pushes, on each sample Test Case. The heap is drawn as the tree of
heapq's own list: a pop is one frame with the root lit, and the pushes that follow are one frame showing the heap as
heapq leaves it, each new entry moving in from its tile (the sifts are not drawn one by one). The highest tile
stepped on so far is an `output` of one chip, which each higher tile moves into; it ends as the answer.

    CODEBITE_DB=<database> scripts/walkthroughs/rising-water-path.py

writes common/src/main/resources/walkthroughs/rising-water-path.json.
"""
import heapq
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import josa, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, level_order_tree, move  # noqa: E402

SLUG = "rising-water-path"

wt = Walkthrough(
    {"en": "Rising Water Path", "ko": "물에 잠기는 통로 건너기"},
    {"en": "Always step onto the lowest tile bordering the explored area (a min-heap): the highest tile stepped on "
           "by the time the walk reaches the corner is the earliest time a route exists.",
     "ko": "탐색한 영역에 맞닿은 타일 중 가장 낮은 타일로 늘 먼저 올라섭니다(최소 힙). 오른쪽 아래 모서리에 닿을 때까지 "
           "밟은 가장 높은 타일의 높이가 경로가 생기는 가장 이른 시각입니다."},
    views=[
        {"id": "elevation", "type": "grid",
         "title": {"en": "elevation (shaded: stepped on; tag: in the heap)",
                   "ko": "elevation (음영: 밟은 타일, 태그: 힙에 있음)"}},
        {"id": "heap", "type": "tree", "arity": 2,
         "title": {"en": "min-heap (height, row, col): lowest on top", "ko": "최소 힙 (높이, 행, 열): 가장 낮은 것이 맨 위"},
         "empty": {"en": "empty", "ko": "비어 있음"}},
        {"id": "highest", "type": "output", "title": {"en": "highest tile so far", "ko": "지금까지 가장 높은 타일"}},
    ],
)


def solve(elevation, run):
    """Solution.earliestCrossingTime with a frame per pop and per batch of pushes. Returns the answer as printed."""
    n = len(elevation)
    seen = {(0, 0)}
    heap = [(elevation[0][0], 0, 0)]
    highest = 0
    stepped = []          # tiles popped, in order
    came_from = {}        # tile -> the tile whose step pushed it: for the last frame's route only

    drawn = []  # the heap list as the last frame drew it

    def resorted(fresh=()):
        """A move for each entry heapq put somewhere new since the last frame: from the node it was at, or, when that
        node is gone (the last entry lifted to the root after a pop), into its node with its text. `fresh` entries
        are moved in by the caller, from their tiles."""
        out = []
        for j, e in enumerate(heap):
            if (j < len(drawn) and drawn[j] is e) or any(e is f for f in fresh):
                continue
            i = next((k for k, d in enumerate(drawn) if d is e), None)
            text = f"({e[0]}, {e[1]}, {e[2]})"
            out.append(move(at("heap", i), at("heap", j), value=text) if i is not None and i < len(heap)
                       else move(dst=at("heap", j), value=text))
        return out

    def frame(caption, cell_marks=None, heap_marks=None, high_marks=None, moves=None, **answer):
        queued = [(r, c) for _, r, c in heap]
        run.frame(caption,
                  elevation={"cells": elevation, "marks": cell_marks or {}, "shade": [list(t) for t in stepped],
                             "tags": [[r, c, {"en": "heap", "ko": "힙"}] for r, c in queued]},
                  heap={**level_order_tree([f"({h}, {r}, {c})" for h, r, c in heap]), "nodeMarks": heap_marks or {}},
                  highest={"values": [highest], "marks": high_marks or {}},
                  moves=moves, **answer)
        drawn[:] = heap

    frame({"en": f"A {n} × {n} grid: start at (0, 0), height {elevation[0][0]}, the only tile in the heap. The "
                 "highest tile stepped on starts at 0.",
           "ko": f"{n} × {n} 격자의 높이 {elevation[0][0]}인 (0, 0)에서 출발하며, 힙에는 이 타일 하나만 있습니다. "
                 "밟은 가장 높은 타일은 0에서 시작합니다."},
          cell_marks={"lit": [[0, 0]]})
    while heap:
        height, r, c = heap[0]
        raised = height > highest
        old = highest
        highest = max(highest, height)
        stepped.append((r, c))
        moves = [move(at("heap", 0), at("elevation", [r, c]), value=str(height))]
        if raised:
            moves.append(move(at("elevation", [r, c]), at("highest", 0), value=str(height)))
            rise = {"en": f"{height} is higher than {old}, so the highest tile becomes {height}",
                    "ko": f"{josa(height, '은는')} {old}보다 높으므로 가장 높은 타일이 {josa(height, '이가')} 됩니다"}
        else:
            rise = {"en": f"{height} is no higher than {highest}, so the highest stays {highest}",
                    "ko": f"{josa(height, '은는')} {highest}보다 높지 않으므로 가장 높은 타일은 {highest} 그대로입니다"}
        if (r, c) == (n - 1, n - 1):
            route = [(r, c)]
            while route[-1] in came_from:
                route.append(came_from[route[-1]])
            route.reverse()
            arrow = " → ".join(f"({a},{b})" for a, b in route)
            frame({"en": f"Pop ({height}, {r}, {c}), the lowest tile bordering the explored area: {rise['en']}. "
                         "This is the corner, so the walk is over.",
                   "ko": f"탐색한 영역에 맞닿은 가장 낮은 ({height}, {r}, {c}) 타일은 도착 모서리이므로 꺼내면 걷기가 "
                         f"끝납니다. {rise['ko']}."},
                  cell_marks={"good": [[r, c]]}, heap_marks={"lit": [0]}, high_marks={"good": [0]} if raised else {},
                  moves=moves)
            heapq.heappop(heap)
            frame({"en": f"The walk reached the corner never stepping higher than {highest}, by {arrow}, and every "
                         f"lower tile was tried first: answer {highest}.",
                   "ko": f"{arrow} 경로로 {highest}보다 높이 밟지 않고 모서리에 닿았고, 더 낮은 타일은 모두 먼저 "
                         f"시도했습니다. 답은 {highest}입니다."},
                  cell_marks={"path": [list(t) for t in route]}, high_marks={"path": [0]}, moves=resorted(),
                  answer=str(highest))
            return
        frame({"en": f"Pop ({height}, {r}, {c}), the lowest tile bordering the explored area, and step on it: "
                     f"{rise['en']}.",
               "ko": f"탐색한 영역에 맞닿은 가장 낮은 ({height}, {r}, {c}) 타일을 꺼내 올라섭니다. {rise['ko']}."},
              cell_marks={"good": [[r, c]]}, heap_marks={"lit": [0]}, high_marks={"good": [0]} if raised else {},
              moves=moves)
        heapq.heappop(heap)
        pushed = []
        for nr, nc in ((r + 1, c), (r - 1, c), (r, c + 1), (r, c - 1)):
            if 0 <= nr < n and 0 <= nc < n and (nr, nc) not in seen:
                seen.add((nr, nc))
                entry = (elevation[nr][nc], nr, nc)
                heapq.heappush(heap, entry)
                came_from[(nr, nc)] = (r, c)
                pushed.append(entry)
        if not pushed:
            if heap:
                frame({"en": f"Every neighbour of ({r}, {c}) was seen already, so nothing is pushed. heappop moved the "
                             "last entry up to the root and sifted it down: the lowest is on top again.",
                       "ko": f"({r}, {c})의 이웃은 모두 이미 보았으므로 넣을 것이 없습니다. heappop이 마지막 항목을 루트로 "
                             "올린 뒤 아래로 내려 보내, 다시 가장 낮은 항목이 맨 위에 있습니다."},
                      cell_marks={"lit": [[r, c]]}, heap_marks={"good": [m["to"]["at"] for m in resorted()]},
                      moves=resorted())
            continue
        idx = [heap.index(e) for e in pushed]
        names = ", ".join(f"({h}, {a}, {b})" for h, a, b in pushed)
        frame({"en": f"From ({r}, {c}), the {'neighbour' if len(pushed) == 1 else 'neighbours'} not seen yet "
                     f"{'joins' if len(pushed) == 1 else 'join'} the heap: {names}. heapq re-sorts so the lowest is on top.",
               "ko": f"({r}, {c})에서 아직 보지 않은 이웃 타일을 힙에 넣습니다: {names}. heapq가 가장 낮은 타일을 맨 위에 "
                     "둡니다."},
              cell_marks={"lit": [[r, c]], "good": [[a, b] for _, a, b in pushed]}, heap_marks={"good": idx},
              moves=[move(at("elevation", [a, b]), at("heap", k), value=f"({h}, {a}, {b})")
                     for (h, a, b), k in zip(pushed, idx)] + resorted(fresh=pushed))
    raise AssertionError("the corner is always reached")


for number, sample in enumerate(sample_cases(SLUG), start=1):
    elevation = json.loads(sample["input"])
    run = sample_run(wt, number, sample, input=f"elevation = {sample['input']}")
    solve(elevation, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
