#!/usr/bin/env python3.12
"""longest-level-up-path's Walkthrough: the reference solution (scripts/replay-solutions/longest-level-up-path.py), the
longest climbing path starting at each tile, worked out from the highest score down so every higher neighbour's path
is already known, recording one frame per tile on each sample Test Case.

The board is drawn as the description's Diagram draws it, each tile tagged with its turn in the visiting order once
visited; beside it the `longest` table, a grid of the board's shape starting at 1. A tile's value moves in from the
higher neighbour with the longest path; the last frame follows the path from the tile holding the answer.

    CODEBITE_DB=<database> scripts/walkthroughs/longest-level-up-path.py

writes common/src/main/resources/walkthroughs/longest-level-up-path.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import josa, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move  # noqa: E402

SLUG = "longest-level-up-path"

wt = Walkthrough(
    {"en": "Longest Level-Up Path", "ko": "가장 긴 레벨업 경로"},
    {"en": "A path from a tile continues through a strictly higher neighbour, so visit tiles from the highest score "
           "down: each tile's longest path is 1 + the longest among its higher neighbours, which are already done.",
     "ko": "경로는 점수가 더 높은 이웃으로만 이어지므로 점수가 높은 타일부터 방문합니다. 각 타일의 최장 경로는 이미 구한 "
           "더 높은 이웃들의 최장 경로 중 가장 긴 것에 1을 더한 값입니다."},
    views=[
        {"id": "scores", "type": "grid", "title": {"en": "scores", "ko": "scores (점수)"}},
        {"id": "longest", "type": "grid", "title": {"en": "longest path starting here", "ko": "여기서 시작하는 최장 경로"}},
    ],
)


def solve(scores, run):
    """Solution.longestIncreasingPath with a frame per tile. Returns the answer as the Driver prints it."""
    rows, cols = len(scores), len(scores[0])
    cells = sorted(((scores[r][c], r, c) for r in range(rows) for c in range(cols)), reverse=True)
    longest = [[1] * cols for _ in range(rows)]
    tags = []

    def frame(caption, score_marks=None, long_marks=None, moves=None, **answer):
        run.frame(caption, scores={"cells": scores, "marks": score_marks or {}, "tags": tags},
                  longest={"cells": longest, "marks": long_marks or {}}, moves=moves, **answer)

    frame({"en": f"A {rows} × {cols} board. Every tile is a path of 1 on its own; visit them from the highest score, "
                 f"{cells[0][0]}, down.",
           "ko": f"{rows} × {cols} 보드입니다. 타일 하나만으로도 길이 1인 경로이므로 모두 1로 시작하고, 가장 높은 점수 "
                 f"{cells[0][0]}부터 내려가며 방문합니다."})
    for turn, (value, r, c) in enumerate(cells, 1):
        tags.append([r, c, f"#{turn}"])
        higher = [(nr, nc) for nr, nc in ((r - 1, c), (r + 1, c), (r, c - 1), (r, c + 1))
                  if 0 <= nr < rows and 0 <= nc < cols and scores[nr][nc] > value]
        if not higher:
            frame({"en": f"Score {value}: no neighbour is higher, so a path from here stops at once: 1.",
                   "ko": f"점수 {value}: 더 높은 이웃이 없으므로 여기서 시작하는 경로는 바로 끝납니다: 1."},
                  score_marks={"lit": [[r, c]]}, long_marks={"lit": [[r, c]]})
            continue
        best = max(higher, key=lambda p: longest[p[0]][p[1]])
        longest[r][c] = longest[best[0]][best[1]] + 1
        listed = ", ".join(f"{scores[nr][nc]} ({longest[nr][nc]})" for nr, nc in higher)
        frame({"en": f"Score {value}: higher neighbours {listed}, with their paths in brackets. Step to "
                     f"{scores[best[0]][best[1]]}: {longest[best[0]][best[1]]} + 1 = {longest[r][c]}.",
               "ko": f"점수 {value}: 더 높은 이웃(괄호 안은 경로 길이)은 {listed}입니다. "
                     f"{josa(scores[best[0]][best[1]], '(으)로')} 가면 {longest[best[0]][best[1]]} + 1 = "
                     f"{longest[r][c]}입니다."},
              score_marks={"lit": [[r, c]] + [list(p) for p in higher]},
              long_marks={"lit": [list(p) for p in higher], "good": [[r, c]]},
              moves=[move(at("longest", list(best)), at("longest", [r, c]), value=f"{longest[best[0]][best[1]]}+1")])
    answer = max(max(row) for row in longest)
    start = next((r, c) for r in range(rows) for c in range(cols) if longest[r][c] == answer)
    path, (r, c) = [list(start)], start
    while longest[r][c] > 1:
        r, c = next((nr, nc) for nr, nc in ((r - 1, c), (r + 1, c), (r, c - 1), (r, c + 1))
                    if 0 <= nr < rows and 0 <= nc < cols and scores[nr][nc] > scores[r][c]
                    and longest[nr][nc] == longest[r][c] - 1)
        path.append([r, c])
    climb = " → ".join(str(scores[r][c]) for r, c in path)
    frame({"en": f"The longest path anywhere is {answer} tiles; one starts at score {scores[start[0]][start[1]]}: {climb}. "
                 f"Answer: {answer}." if answer > 1 else "No tile has a higher neighbour, so every path is 1 tile. "
                                                          "Answer: 1.",
           "ko": f"가장 긴 경로는 점수 {scores[start[0]][start[1]]}에서 시작하는 {answer}칸입니다: {climb}. "
                 f"답은 {answer}입니다." if answer > 1 else "더 높은 이웃이 있는 타일이 없어 모든 경로가 1칸입니다. "
                                                         "답은 1입니다."},
          score_marks={"path": path}, long_marks={"path": [list(start)]}, answer=str(answer))


for number, sample in enumerate(sample_cases(SLUG), start=1):
    scores = json.loads(sample["input"])
    run = sample_run(wt, number, sample, input=f"scores = {sample['input']}")
    solve(scores, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
