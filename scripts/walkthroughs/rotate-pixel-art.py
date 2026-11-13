#!/usr/bin/env python3.12
"""rotate-pixel-art's Walkthrough: the reference solution (scripts/replay-solutions/rotate-pixel-art.py),
transpose then reverse each row, in place, recording one frame per swap across the diagonal and one
per row reversed on each sample Test Case.

    CODEBITE_DB=<database> scripts/walkthroughs/rotate-pixel-art.py

writes common/src/main/resources/walkthroughs/rotate-pixel-art.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough  # noqa: E402

SLUG = "rotate-pixel-art"

wt = Walkthrough(
    {"en": "Rotate Pixel Art", "ko": "픽셀 아트 회전"},
    {"en": "A clockwise turn is two in-place flips: transpose (swap across the diagonal), "
           "then reverse each row.",
     "ko": "시계 방향 90도 회전은 제자리 뒤집기 두 번입니다: 대각선을 기준으로 맞바꾸는 전치, "
           "그다음 각 행 뒤집기."},
    views=[
        {"id": "image", "type": "grid",
         "title": {"en": "image (tag: the pixel's starting cell)", "ko": "이미지 (태그: 픽셀의 처음 칸)"}},
        {"id": "state", "type": "vars"},
    ],
)


def solve(image, run):
    """Solution.rotateImage with a frame per swap and per row. Returns nothing; image is rotated in place."""
    n = len(image)
    origin = [[(r, c) for c in range(n)] for r in range(n)]  # where each pixel started, moved with it

    def frame(caption, step, value, lit=(), good=(), path=(), **answer):
        run.frame(caption,
                  image={"cells": image,
                         "tags": [[r, c, f"{origin[r][c][0]},{origin[r][c][1]}"] for r in range(n) for c in range(n)],
                         "marks": {"lit": [list(p) for p in lit], "good": [list(p) for p in good],
                                   "path": [list(p) for p in path]}},
                  state={"items": [{"label": step, "value": value}]},
                  **answer)

    transpose = {"en": "1. transpose: swap", "ko": "1. 전치: 맞바꾸기"}
    reverse = {"en": "2. reverse row", "ko": "2. 행 뒤집기"}
    diagonal = [(i, i) for i in range(n)]
    frame({"en": f"A {n}×{n} image. Step 1 mirrors it across the diagonal: the pixel at r,c swaps with "
                 "the one at c,r, and the diagonal stays put.",
           "ko": f"{n}×{n} 이미지입니다. 1단계는 대각선을 기준으로 뒤집습니다: r,c 칸의 픽셀이 c,r 칸의 픽셀과 "
                 "자리를 바꾸고, 대각선은 그대로입니다."},
          {"en": "diagonal (stays)", "ko": "대각선 (그대로)"}, f"0,0 … {n - 1},{n - 1}", lit=diagonal)
    for i in range(n):
        for j in range(i + 1, n):
            a, b = image[i][j], image[j][i]
            image[i][j], image[j][i] = image[j][i], image[i][j]
            origin[i][j], origin[j][i] = origin[j][i], origin[i][j]
            frame({"en": f"Swap {a} at {i},{j} with {b} at {j},{i}.",
                   "ko": f"{i},{j} 칸과 {j},{i} 칸의 픽셀을 맞바꿉니다 ({a} ↔ {b})."},
                  transpose, f"{i},{j} ↔ {j},{i}", lit=diagonal, good=[(i, j), (j, i)])
    for r, row in enumerate(image):
        before = list(row)
        row.reverse()
        origin[r].reverse()
        first = r == 0
        frame({"en": f"Reverse row {r}: {before} becomes {row}." + (
                   " Step 2 mirrors the transposed image left to right." if first else ""),
               "ko": f"{r}행을 뒤집습니다: {before} → {row}." + (
                   " 2단계는 전치한 이미지를 좌우로 뒤집습니다." if first else "")},
              reverse, r, good=[(r, c) for c in range(n)])
    answer = json.dumps(image, separators=(",", ":"))
    frame({"en": f"Done in place: the pixel from r,c is now at c,{n - 1}−r, which is a clockwise turn. "
                 f"Answer {answer}.",
           "ko": f"제자리에서 끝났습니다: r,c 칸의 픽셀이 이제 c,{n - 1}−r 칸에 있으므로 시계 방향 회전입니다. "
                 f"답은 {answer}입니다."},
          {"en": "turned clockwise", "ko": "시계 방향 회전"}, "90°", path=[(r, c) for r in range(n) for c in range(n)], answer=answer)


for number, sample in enumerate(sample_cases(SLUG), start=1):
    image = json.loads(sample["input"])
    run = sample_run(wt, number, sample, input=f"image = {sample['input']}")
    solve(image, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
