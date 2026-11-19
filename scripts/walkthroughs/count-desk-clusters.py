#!/usr/bin/env python3.12
"""count-desk-clusters' Walkthrough: the reference solution (scripts/replay-solutions/count-desk-clusters.py),
a row-by-row scan that starts a cluster at each desk not seen yet and floods it with a stack, on each sample Test
Case. The board is drawn as the description's grid Diagram draws it, each seen desk tagged with its cluster's number;
a frame per cluster started, per desk popped off the stack and per batch of desks pushed onto it.

    CODEBITE_DB=<database> scripts/walkthroughs/count-desk-clusters.py

writes common/src/main/resources/walkthroughs/count-desk-clusters.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import plural, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move, stack  # noqa: E402

SLUG = "count-desk-clusters"

wt = Walkthrough(
    {"en": "Count Desk Clusters", "ko": "책상 그룹 세기"},
    {"en": "Scan row by row; a desk no cluster holds yet starts a new one, and a stack floods it through every desk "
           "it touches, so the scan never starts the same cluster twice; finished clusters are drawn faded.",
     "ko": "한 줄씩 훑다가 아직 어느 그룹에도 없는 책상을 만나면 새 그룹을 시작하고, 스택으로 맞닿은 책상을 모두 "
           "채워 넣으므로 같은 그룹을 두 번 세지 않습니다. 끝난 그룹은 흐리게 그립니다."},
    views=[
        {"id": "board", "type": "grid", "title": {"en": "board (tag: cluster)", "ko": "board (태그: 그룹)"},
         "showValues": False,
         "values": {"0": {"label": {"en": "empty", "ko": "빈 칸"}, "tone": "empty"},
                    "1": {"label": {"en": "desk", "ko": "책상"}, "tone": "a", "glyph": "●"}}},
        {"id": "stack", "type": "stack", "title": {"en": "stack: desks to visit", "ko": "스택: 둘러볼 책상"},
         "empty": {"en": "empty", "ko": "비어 있음"}},
        {"id": "clusters", "type": "output", "title": {"en": "clusters", "ko": "그룹"},
         "empty": {"en": "none yet", "ko": "아직 없음"}},
    ],
)


def name(p):
    return f"{p[0]},{p[1]}"


def cluster_tag(k):
    return f"#{k}"


def solve(board, run):
    """Solution.countClusters with a frame per step. Returns the answer as the Driver prints it."""
    rows = len(board)
    cols = len(board[0]) if board else 0
    seen = {}       # (r, c) -> the cluster that holds it, in the order seen
    todo = []       # the stack, bottom first
    leaving = []    # the desks popped this frame, still drawn on top
    found = []      # the clusters started, as output chips
    current = 0     # the cluster being flooded; the ones before it are finished and drawn dim

    def frame(caption, lit=(), good=(), path=(), stack_marks=None, found_marks=None, moves=None, **answer):
        run.frame(caption,
                  board={"cells": board, "tags": [[r, c, cluster_tag(k)] for (r, c), k in seen.items()],
                         "marks": {"dim": [list(p) for p, k in seen.items() if k < current and not path],
                                   "lit": [list(p) for p in lit], "good": [list(p) for p in good],
                                   "path": [list(p) for p in path]}},
                  stack={**stack(todo + leaving, value=name), "marks": stack_marks or {}},
                  clusters={"values": list(found), "marks": found_marks or {}},
                  moves=moves, **answer)

    desks = sum(row.count("1") for row in board)
    frame({"en": f"A {rows}×{cols} board with {desks} {plural(desks, 'desk', 'desks')}. Scan it row by row; "
                 f"a desk no cluster holds yet starts a new cluster.",
           "ko": f"{rows}×{cols} 격자에 책상이 {desks}개 있습니다. 한 줄씩 훑으며, 아직 어느 그룹에도 없는 책상을 "
                 f"만나면 새 그룹을 시작합니다."})
    clusters = 0
    for r in range(rows):
        for c in range(cols):
            if board[r][c] != "1" or (r, c) in seen:
                continue
            clusters += 1
            current = clusters
            seen[(r, c)] = clusters
            todo.append((r, c))
            found.append(cluster_tag(clusters))
            k = clusters
            frame({"en": f"The scan reaches ({name((r, c))}), a desk no cluster holds yet: cluster {k} starts here, "
                         f"and the desk goes on the stack.",
                   "ko": f"훑다가 ({name((r, c))}) 책상에 닿았는데 아직 어느 그룹에도 없으므로 그룹 {k}번이 여기서 "
                         f"시작되고, 이 책상을 스택에 넣습니다."},
                  good=[(r, c)], stack_marks={"good": [len(todo) - 1]}, found_marks={"good": [k - 1]},
                  moves=[move(at("board", [r, c]), at("stack", len(todo) - 1), value=name((r, c))),
                         move(at("board", [r, c]), at("clusters", k - 1), value=cluster_tag(k))])
            while todo:
                y, x = todo.pop()
                leaving[:] = [(y, x)]
                added = []
                for ny, nx in ((y + 1, x), (y - 1, x), (y, x + 1), (y, x - 1)):
                    if 0 <= ny < rows and 0 <= nx < cols and board[ny][nx] == "1" and (ny, nx) not in seen:
                        seen[(ny, nx)] = clusters
                        added.append((ny, nx))
                top = len(todo)
                here = name((y, x))
                if not added:
                    done = "" if todo else f" The stack is empty, so cluster {k} is complete."
                    done_ko = "" if todo else f" 스택이 비었으므로 그룹 {k}번이 완성됩니다."
                    frame({"en": f"Pop ({here}): every desk next to it is already in cluster {k}."
                                 + done,
                           "ko": f"({here}) 책상을 꺼냅니다. 맞닿은 책상은 모두 이미 그룹 {k}번에 있습니다." + done_ko},
                          lit=[(y, x)], stack_marks={"lit": [top]}, moves=[move(at("stack", top))])
                    leaving.clear()
                    continue
                n = len(added)
                listed = ", ".join(f"({name(p)})" for p in added)
                frame({"en": f"Pop ({here}): {n} {plural(n, 'desk', 'desks')} next to it, {listed}, "
                             f"{plural(n, 'joins', 'join')} cluster {k}.",
                       "ko": f"({here}) 책상을 꺼냅니다. 맞닿은 책상 {n}개가 그룹 {k}번에 들어갑니다: {listed}."},
                      lit=[(y, x)], good=added, stack_marks={"lit": [top]},
                      moves=[move(at("stack", top), at("board", list(p))) for p in added])
                leaving.clear()
                todo.extend(added)
                frame({"en": f"{plural(n, 'It goes', 'They go')} on the stack, to look at {plural(n, 'its', 'their')} "
                             f"neighbours in turn.",
                       "ko": f"새로 들어온 책상 {n}개를 스택에 넣어, 차례로 그 이웃을 살핍니다."},
                      good=added, stack_marks={"good": list(range(top, len(todo)))},
                      moves=[move(at("board", list(p)), at("stack", top + i), value=name(p))
                             for i, p in enumerate(added)])
    frame({"en": f"The scan passed every cell and started {clusters} {plural(clusters, 'cluster', 'clusters')}: "
                 f"answer {clusters}.",
           "ko": f"모든 칸을 훑는 동안 그룹 {clusters}개를 시작했으므로 답은 {clusters}입니다."},
          path=list(seen), answer=str(clusters))


for number, sample in enumerate(sample_cases(SLUG), start=1):
    board = json.loads(sample["input"])
    run = sample_run(wt, number, sample, input=f"board = {sample['input']}")
    solve(board, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
