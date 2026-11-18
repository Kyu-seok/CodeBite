#!/usr/bin/env python3.12
"""trapping-rain-water's Walkthrough: the reference solution
(scripts/replay-solutions/trapping-rain-water.py), two pointers moving toward each other over the bars,
recording one frame per bar settled on each sample Test Case. The lower side moves: its running max
(a tag on the bar that set it) is the water level there, since the other side holds a bar at least as
tall. Each bar's water fills above it and moves into the running total.

    CODEBITE_DB=<database> scripts/walkthroughs/trapping-rain-water.py

writes common/src/main/resources/walkthroughs/trapping-rain-water.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import josa, plural, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move  # noqa: E402

SLUG = "trapping-rain-water"

wt = Walkthrough(
    {"en": "Trapping Rain Water", "ko": "빗물 가두기"},
    {"en": "Two pointers move toward each other, always moving the lower side: the other side already holds a bar "
           "at least as tall, so the lower side's running max is the water level over the bar it settles.",
     "ko": "두 포인터가 양 끝에서 서로를 향해 오며, 항상 더 낮은 쪽을 움직입니다. 반대쪽에 그만큼 높은 막대가 이미 있으므로, "
           "낮은 쪽의 지금까지 최댓값이 그 막대 위의 물 높이입니다."},
    views=[
        {"id": "bars", "type": "array", "display": "bars",
         "title": {"en": "height (bars) and water", "ko": "height (막대)와 물"}},
        {"id": "water", "type": "output", "title": {"en": "water trapped", "ko": "갇힌 물"}},
    ],
)


def solve(height, run):
    """Solution.trap with a frame per bar settled. Returns the answer as the Driver prints it."""
    n = len(height)
    fill = [0] * n
    left, right = 0, n - 1
    left_max = right_max = water = 0
    left_at = right_at = None  # the bar that set each running max

    def frame(caption, lit=(), good=(), path=(), dim=(), moves=None, done=False, **answer):
        tags = []
        if left_at is not None:
            tags.append([left_at, {"en": f"L max {left_max}", "ko": f"L 최대 {left_max}"}])
        if right_at is not None:
            if right_at == left_at:
                tags[-1] = [left_at, {"en": f"max {left_max}", "ko": f"최대 {left_max}"}]
            else:
                tags.append([right_at, {"en": f"R max {right_max}", "ko": f"R 최대 {right_max}"}])
        run.frame(caption,
                  bars={"values": height, "fill": fill, "tags": tags,
                        "pointers": {"L": None if done else left, "R": None if done or right == left else right},
                        "marks": {"dim": list(dim), "path": list(path), "good": list(good), "lit": list(lit)}},
                  water={"values": [water], "marks": {"path": [0]} if done else {}},
                  moves=moves, **answer)

    frame({"en": f"{n} bars. L starts at bar 0 and R at bar {n - 1}; the water above a bar is limited by the "
                 f"shorter of the tallest bars on its two sides.",
           "ko": f"막대 {n}개이고, L은 0번, R은 {n - 1}번 막대에서 시작합니다. 막대 위의 물은 양쪽에서 가장 높은 막대 중 "
                 f"낮은 쪽까지만 찹니다."})
    while left < right:
        if height[left] < height[right]:
            i, side, other = left, "L", right
            new_max = height[i] > left_max
            if new_max:
                left_max, left_at = height[i], i
            level = left_max
            held = left_max - height[i]
            left += 1
            why_en = f"{height[i]} < {height[other]} at R, so the left side is lower and its max decides the level"
            why_ko = f"{josa(height[i], '은는')} R의 {height[other]}보다 낮아 왼쪽이 낮은 쪽이고, 왼쪽 최댓값이 물 높이를 정합니다"
        else:
            i, side, other = right, "R", left
            new_max = height[i] > right_max
            if new_max:
                right_max, right_at = height[i], i
            level = right_max
            held = right_max - height[i]
            right -= 1
            why_en = f"{height[i]} ≤ {height[other]} at L, so the right side is lower and its max decides the level"
            why_ko = f"{josa(height[i], '은는')} L의 {height[other]}보다 높지 않아 오른쪽이 낮은 쪽이고, 오른쪽 최댓값이 물 높이를 정합니다"
        if new_max:
            frame({"en": f"{side} at bar {i}: {why_en}. Height {height[i]} is the new {side} max, so this bar holds no water.",
                   "ko": f"{side}({i}번 막대): {why_ko}. 높이 {josa(height[i], '이가')} 새 {side} 최댓값이라 이 막대 위에는 물이 없습니다."},
                  lit=[other], good=[i])
        elif held == 0:
            frame({"en": f"{side} at bar {i}: {why_en}. Height {height[i]} is no lower than the {side} max {level}, "
                         f"so this bar holds no water.",
                   "ko": f"{side}({i}번 막대): {why_ko}. 높이 {josa(height[i], '이가')} {side} 최댓값 {level}보다 낮지 않아 "
                         f"이 막대 위에는 물이 없습니다."},
                  lit=[i, other])
        else:
            fill[i] = held
            water += held
            frame({"en": f"{side} at bar {i}: {why_en}. Level {level} − height {height[i]} = {held} "
                         f"over this bar, so the total is {water}.",
                   "ko": f"{side}({i}번 막대): {why_ko}. 물 높이 {level} − 높이 {height[i]} = {held}칸이 이 막대 위에 고여 "
                         f"총 {josa(water, '이가')} 됩니다."},
                  lit=[other], good=[i],
                  moves=[move(at("bars", i), at("water", 0), value=f"+{held}")])
    filled = [j for j in range(n) if fill[j]]
    frame({"en": f"L and R met at bar {left}: every bar is settled. Water sits over {len(filled)} "
                 f"{plural(len(filled), 'bar', 'bars')}, {water} units in total.",
           "ko": f"L과 R이 {left}번 막대에서 만나 모든 막대를 처리했습니다. 물은 막대 {len(filled)}개 위에 고였고, "
                 f"모두 {water}칸입니다."},
          path=filled, done=True, answer=str(water))


for number, sample in enumerate(sample_cases(SLUG), start=1):
    height = json.loads(sample["input"])
    run = sample_run(wt, number, sample, input=f"height = {sample['input']}")
    solve(height, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
