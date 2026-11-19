#!/usr/bin/env python3.12
"""largest-rectangle-histogram's Walkthrough: the reference solution
(scripts/replay-solutions/largest-rectangle-histogram.py), a stack of bar indexes with rising heights, read left to
right with a 0-height bar at the end, recording one frame per bar popped and one per bar pushed on each sample Test
Case. The stack is drawn upright on a fixed base, each entry its bar's height tagged with its index. A popped bar is
the height of the widest rectangle it supports, drawn as a span over the bars it covers; the best is a span below.

    CODEBITE_DB=<database> scripts/walkthroughs/largest-rectangle-histogram.py

writes common/src/main/resources/walkthroughs/largest-rectangle-histogram.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import plural, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move, span, stack  # noqa: E402

SLUG = "largest-rectangle-histogram"

wt = Walkthrough(
    {"en": "Largest Rectangle in Histogram", "ko": "히스토그램 최대 직사각형"},
    {"en": "Keep a stack of bars with rising heights. A bar no taller than the top pops it: the popped bar's "
           "rectangle reaches right up to the new bar and left to the bar under it on the stack.",
     "ko": "높이가 올라가는 막대들을 스택에 둡니다. 맨 위보다 높지 않은 막대가 오면 맨 위를 꺼내고, 꺼낸 막대 높이의 "
           "직사각형은 오른쪽으로 새 막대 앞까지, 왼쪽으로 스택에서 그 아래 막대 바로 다음까지 닿습니다."},
    views=[
        {"id": "heights", "type": "array", "display": "bars",
         "title": {"en": "heights, then a 0 at the end", "ko": "heights (높이), 끝에 0 하나"}},
        {"id": "stack", "type": "stack", "title": {"en": "stack (rising)", "ko": "스택 (높이 오름차순)"},
         "empty": {"en": "empty", "ko": "비어 있음"}},
    ],
)


def solve(heights, run):
    """Solution.largestRectangleArea with a frame per pop and per push. Returns the answer as the Driver prints it."""
    bars = heights + [0]
    n = len(heights)
    end_tag = [[n, {"en": "end", "ko": "끝"}]]
    best = 0
    best_span = None
    held = []
    i = None

    def frame(caption, leaving=None, lit=(), path=(), rect=None, best_mark=None, stack_marks=None, moves=None,
              done=False, **answer):
        shown = held + ([leaving] if leaving is not None else [])
        spans = {}
        if rect is not None:
            spans["rect"] = rect
        if best_span is not None:
            a, b = best_span
            spans["best"] = span(a, b, {"en": f"best = {best}", "ko": f"best (최대 넓이) = {best}"},
                                 mark="path" if done else best_mark, below=True)
        run.frame(caption,
                  heights={"values": bars, "tags": end_tag, "pointers": {"i": i},
                           "unread": list(range(i + 1, n + 1)) if i is not None else [],
                           "spans": spans, "marks": {"path": list(path), "lit": list(lit)}},
                  stack={**stack(shown, value=lambda j: bars[j], tag=lambda j: f"[{j}]"), "marks": stack_marks or {}},
                  moves=moves, **answer)

    frame({"en": f"{n} {plural(n, 'bar', 'bars')}, read left to right, with a 0-high bar at the end that pops "
                 f"whatever is left. The stack starts empty.",
           "ko": f"막대 {n}개를 왼쪽부터 읽고, 끝에는 남은 막대를 모두 꺼낼 높이 0 막대를 하나 둡니다. 스택은 비어 있습니다."})
    for i, height in enumerate(bars):
        while held and bars[held[-1]] >= height:
            top = len(held) - 1
            j = held.pop()
            tall = bars[j]
            left = held[-1] + 1 if held else 0
            width = i - left
            area = tall * width
            beats = area > best
            if beats:
                best, best_span = area, (left, i - 1)
            where = ({"en": f"the stack below it is empty, so it reaches back to bar 0",
                      "ko": "그 아래 스택이 비어 있어 0번 막대까지 닿습니다"} if not held else
                     {"en": f"bar {held[-1]} under it is lower, so it starts at bar {left}",
                      "ko": f"그 아래 {held[-1]}번 막대가 더 낮아 {left}번 막대부터 시작합니다"})
            verdict = ({"en": f"a new best, {area}", "ko": "새 best (최대 넓이)입니다"} if beats else
                       {"en": f"not more than best, {best}", "ko": f"best (최대 넓이) {best}보다 크지 않습니다"})
            frame({"en": f"Bar {i} ({height}) is not taller than bar {j} ({tall}) on top: pop it. Its rectangle ends "
                         f"at bar {i - 1}; {where['en']}: {tall} × {width} = {area}, {verdict['en']}.",
                   "ko": f"{i}번 막대({height})가 맨 위 {j}번 막대({tall})보다 높지 않아 꺼냅니다. 직사각형은 "
                         f"{i - 1}번 막대에서 끝나고 {where['ko']}. 넓이 {tall} × {width} = {area}: {verdict['ko']}."},
                  leaving=j, lit=[i], stack_marks={"lit": [top]},
                  rect=span(left, i - 1, f"{tall}×{width} = {area}", mark="good" if beats else None),
                  best_mark="good" if beats else None,
                  moves=[move(at("stack", top), at("heights", j), value=f"{tall}×{width}")])
        held.append(i)
        if len(held) == 1:
            why = {"en": "The stack is empty", "ko": "스택이 비어 있으므로"}
        else:
            below = held[-2]
            why = {"en": f"Bar {below} ({bars[below]}) on top is lower", "ko": f"맨 위 {below}번 막대({bars[below]})가 더 낮으므로"}
        last = {"en": " The end bar has nothing left to pop.", "ko": " 끝 막대 뒤에는 꺼낼 것이 없습니다."} if i == n else \
            {"en": "", "ko": ""}
        frame({"en": f"{why['en']}: push bar {i} ({height}) on top.{last['en']}",
               "ko": f"{why['ko']} {i}번 막대({height})를 맨 위에 넣습니다.{last['ko']}"},
              lit=[i], stack_marks={"good": [len(held) - 1]},
              moves=[move(at("heights", i), at("stack", len(held) - 1))])
    i = None
    a, b = best_span
    frame({"en": f"Every bar is read. The largest rectangle covers bars {a} to {b}: area {best}.",
           "ko": f"모든 막대를 읽었습니다. 가장 큰 직사각형은 {a}번부터 {b}번 막대까지 덮고, 넓이는 {best}입니다."},
          path=range(a, b + 1), done=True, answer=str(best))
    return str(best)


for number, sample in enumerate(sample_cases(SLUG), start=1):
    heights = json.loads(sample["input"])
    run = sample_run(wt, number, sample, input=f"heights = {sample['input']}")
    solve(heights, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
