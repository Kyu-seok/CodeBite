#!/usr/bin/env python3.12
"""rotate-pixel-art's Walkthrough: a clockwise turn in place, ring by ring from the outside in, four
cells at a time through one temp: temp <- top, top <- left, left <- bottom, bottom <- right,
right <- temp. One frame per assignment, each a move, on each sample Test Case.

The reference solution (scripts/replay-solutions/rotate-pixel-art.py) transposes and then reverses
each row; this tracer runs the ring rotation instead, which ends on the same image.

    CODEBITE_DB=<database> scripts/walkthroughs/rotate-pixel-art.py

writes common/src/main/resources/walkthroughs/rotate-pixel-art.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import driver_list, josa, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move  # noqa: E402

SLUG = "rotate-pixel-art"

wt = Walkthrough(
    {"en": "Rotate Pixel Art", "ko": "픽셀 아트 회전"},
    {"en": "A clockwise turn moves every pixel one side along its ring: top to right, right to bottom, bottom "
           "to left, left to top. Go ring by ring from the outside in, rotating four cells at a time through one "
           "temp.",
     "ko": "시계 방향 회전은 픽셀마다 자기 테두리를 따라 한 변씩 옮깁니다: 위는 오른쪽, 오른쪽은 아래, "
           "아래는 왼쪽, 왼쪽은 위로. 바깥 테두리부터 안쪽으로, 칸 네 개씩 temp 하나를 거쳐 돌립니다."},
    views=[
        {"id": "image", "type": "grid",
         "title": {"en": "image (tag: the pixel's starting cell)", "ko": "이미지 (태그: 픽셀의 처음 칸)"}},
        {"id": "temp", "type": "array", "title": {"en": "temp", "ko": "temp (임시 칸)"}},
    ],
)

SIDES = {"top": "위", "left": "왼쪽", "bottom": "아래", "right": "오른쪽"}


def solve(image, run):
    """Rotates image clockwise in place, a frame per assignment. Returns nothing; the last frame has the answer."""
    n = len(image)
    origin = [[f"{r},{c}" for c in range(n)] for r in range(n)]  # where each pixel started, copied with it
    temp, temp_from = [""], [""]

    def frame(caption, lit=(), good=(), temp_good=False, path=(), moves=(), **answer):
        run.frame(caption,
                  image={"cells": image,
                         "tags": [[r, c, origin[r][c]] for r in range(n) for c in range(n)],
                         "marks": {"lit": [list(p) for p in lit if p not in good], "good": [list(p) for p in good],
                                   "path": [list(p) for p in path]}},
                  temp={"values": temp, "tags": [[0, temp_from[0]]] if temp_from[0] else [],
                        "marks": {"good": [0] if temp_good else []}},
                  moves=list(moves), **answer)

    rings = n // 2
    frame({"en": f"A {n}×{n} image has {rings} {'ring' if rings == 1 else 'rings'} to turn, the outer one first. "
                 "Each pixel moves one side clockwise, so four cells trade places at a time through temp.",
           "ko": f"{n}×{n} 이미지에는 돌릴 테두리가 {rings}개 있고, 바깥 테두리부터 돌립니다. 픽셀마다 시계 방향으로 "
                 "한 변씩 옮기므로, 칸 네 개가 temp를 거쳐 한 번에 자리를 바꿉니다."})
    for layer in range(rings):
        first, last = layer, n - 1 - layer
        for i in range(first, last):
            offset = i - first
            cells = {"top": (first, i), "left": (last - offset, first),
                     "bottom": (last, last - offset), "right": (i, last)}
            group = list(cells.values())
            ring = f"ring {layer}" if rings > 1 else "the ring"
            ring_ko = f"{layer}번 테두리" if rings > 1 else "테두리"
            (tr, tc) = cells["top"]
            temp[0], temp_from[0] = image[tr][tc], origin[tr][tc]
            frame({"en": f"In {ring}, the four cells {', '.join(f'{r},{c}' for r, c in group)} turn together. "
                         f"temp ← top: save {image[tr][tc]} from {tr},{tc} before it is overwritten.",
                   "ko": f"{ring_ko}에서 칸 네 개({', '.join(f'{r},{c}' for r, c in group)})가 함께 돕니다. "
                         f"temp ← 위: {tr},{tc} 칸의 {josa(image[tr][tc], '을를')} 덮어쓰기 전에 temp에 둡니다."},
                  lit=group, temp_good=True, moves=[move(at("image", [tr, tc]), at("temp", 0))])
            for dst, src in (("top", "left"), ("left", "bottom"), ("bottom", "right")):
                (dr, dc), (sr, sc) = cells[dst], cells[src]
                v = image[sr][sc]
                image[dr][dc], origin[dr][dc] = v, origin[sr][sc]
                frame({"en": f"{dst} ← {src}: {v} moves from {sr},{sc} up to {dr},{dc}." if dst == "top" else
                             f"{dst} ← {src}: {v} moves from {sr},{sc} to {dr},{dc}.",
                       "ko": f"{SIDES[dst]} ← {SIDES[src]}: {sr},{sc} 칸의 {josa(v, '이가')} {dr},{dc} 칸으로 옮겨 갑니다."},
                      lit=group, good=[(dr, dc)], moves=[move(at("image", [sr, sc]), at("image", [dr, dc]))])
            (rr, rc) = cells["right"]
            image[rr][rc], origin[rr][rc] = temp[0], temp_from[0]
            frame({"en": f"right ← temp: the saved {temp[0]} lands on {rr},{rc}, and these four pixels have each "
                         "moved one side clockwise.",
                   "ko": f"오른쪽 ← temp: 두었던 {josa(temp[0], '이가')} {rr},{rc} 칸에 놓이고, 이 네 픽셀이 "
                         "모두 시계 방향으로 한 변씩 옮겨 갔습니다."},
                  lit=group, good=[(rr, rc)], moves=[move(at("temp", 0), at("image", [rr, rc]))])
    answer = driver_list(image)
    frame({"en": f"Every ring has turned in place: the pixel from r,c is now at c,{n - 1}−r, a clockwise turn. "
                 f"Answer {answer}.",
           "ko": f"모든 테두리가 제자리에서 돌았습니다: r,c 칸의 픽셀이 이제 c,{n - 1}−r 칸에 있으므로 시계 방향 "
                 f"회전입니다. 답은 {answer}입니다."},
          path=[(r, c) for r in range(n) for c in range(n)], answer=answer)


for number, sample in enumerate(sample_cases(SLUG), start=1):
    image = json.loads(sample["input"])
    run = sample_run(wt, number, sample, input=f"image = {sample['input']}")
    solve(image, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
