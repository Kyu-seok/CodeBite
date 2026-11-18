#!/usr/bin/env python3.12
"""running-median-timer's Walkthrough: the reference solution (scripts/replay-solutions/running-median-timer.py), a
max-heap of the lower half and a min-heap of the upper half, run on each sample's list of calls, with heapq's push
and pop written out as the textbook sift-up and sift-down, one swap per frame. The calls are a table, one row per
call, the current call lit and the calls before it faded; the two heaps are trees side by side, each node tagged with
its array index, and each call's result moves from its row into the answer.

record pushes into low, moves low's top into high, and moves high's top back when high has grown bigger; the tracer
appends the top to the other heap before it refills the root it left, which the two heaps don't share, so the
result is the reference solution's.

    CODEBITE_DB=<database> scripts/walkthroughs/running-median-timer.py

writes common/src/main/resources/walkthroughs/running-median-timer.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import josa, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, level_order_tree, move, swap  # noqa: E402

SLUG = "running-median-timer"

wt = Walkthrough(
    {"en": "Running Median Timer", "ko": "실시간 중앙값 추적"},
    {"en": "Split the numbers into two halves: low, a max-heap of the lower half, and high, a min-heap of the upper "
           "half, with low holding the extra one when the count is odd. The median is then low's top, or the average "
           "of the two tops.",
     "ko": "수를 두 절반으로 나눕니다. low는 아래쪽 절반의 최대 힙, high는 위쪽 절반의 최소 힙이고, 개수가 홀수면 low가 하나 "
           "더 가집니다. 그러면 중앙값은 low의 맨 위 값이거나 두 맨 위 값의 평균입니다."},
    views=[
        {"id": "calls", "type": "table", "title": {"en": "calls", "ko": "호출"}},
        {"id": "low", "type": "tree", "arity": 2,
         "title": {"en": "low: lower half, max on top", "ko": "low: 아래쪽 절반 (맨 위가 최대)"},
         "empty": {"en": "empty", "ko": "비어 있음"}},
        {"id": "high", "type": "tree", "arity": 2,
         "title": {"en": "high: upper half, min on top", "ko": "high: 위쪽 절반 (맨 위가 최소)"},
         "empty": {"en": "empty", "ko": "비어 있음"}},
        {"id": "result", "type": "output", "title": {"en": "answer, one value per call", "ko": "답 (호출마다 하나)"},
         "empty": {"en": "none yet", "ko": "아직 없음"}},
    ],
)

NAMES = {"low": {"en": "low", "ko": "low"}, "high": {"en": "high", "ko": "high"}}


def text(value):
    """A result as the Driver prints it: null, a whole float with one decimal, else as Python prints it."""
    if value is None:
        return "null"
    if value == int(value):
        return f"{value:.1f}"
    return str(value)


def solve(cmds, args, run):
    """The Driver's loop over StreamMedian with a frame per step. Returns the answer as the Driver prints it."""
    heaps = {"low": [], "high": []}
    result = []
    rows = [{"label": str(i), "cells": [c, str(a[0]) if a else ""]} for i, (c, a) in enumerate(zip(cmds, args))]
    state = {"row": 0, "draw": {}}

    def above(name, child, parent):
        """Whether `child` belongs above `parent` in heap `name`: higher in low (a max-heap), lower in high."""
        return child > parent if name == "low" else child < parent

    def frame(caption, marks=None, moves=None, done=False, **answer):
        r = state["row"]
        cell_marks = {"dim": [[i, j] for i in range(r) for j in (0, 1)], "lit": [[r, 0], [r, 1]]} if not done else {}
        answered = any(m.get("to", {}).get("view") == "result" for m in moves or [])
        views = {}
        for name, heap in heaps.items():
            shown = list(state["draw"].get(name, heap))
            node_marks = (marks or {}).get(name, {})
            if done and shown:
                node_marks = {"path": [0]}
            views[name] = {**level_order_tree(shown), "tags": [[j, f"[{j}]"] for j in range(len(shown))],
                           "nodeMarks": node_marks}
        run.frame(caption,
                  calls={"columns": [{"en": "call", "ko": "호출"}, {"en": "num", "ko": "num (수)"}], "rows": rows,
                         "marks": cell_marks},
                  result={"values": [text(v) for v in result],
                          "marks": {"path": list(range(len(result)))} if done else
                          {"good": [len(result) - 1]} if answered else {}},
                  moves=moves, **views, **answer)

    def answer(value, src=None):
        result.append(value)
        if src is None:
            return [move(at("calls", [state["row"], 0]), at("result", len(result) - 1), value=text(value))]
        return [move(s, at("result", len(result) - 1)) for s in src]

    def sift_up(name, j):
        heap = heaps[name]
        while j > 0:
            p = (j - 1) // 2
            if not above(name, heap[j], heap[p]):
                return
            a, b = heap[j], heap[p]
            heap[j], heap[p] = b, a
            word = {"en": "higher", "ko": "높으므로"} if name == "low" else {"en": "lower", "ko": "낮으므로"}
            frame({"en": f"Sift up in {name}: {a} at [{j}] is {word['en']} than its parent {b} at [{p}], so they swap.",
                   "ko": f"{name}에서 위로 올리기: [{j}]의 {josa(a, '은는')} 부모 [{p}]의 {b}보다 {word['ko']} "
                         f"자리를 바꿉니다."},
                  marks={name: {"good": [p], "lit": [j]}}, moves=swap(name, j, p, a, b))
            j = p

    def sift_down(name, j):
        heap = heaps[name]
        while True:
            best = j
            for c in (2 * j + 1, 2 * j + 2):
                if c < len(heap) and above(name, heap[c], heap[best]):
                    best = c
            if best == j:
                return
            a, b = heap[j], heap[best]
            heap[j], heap[best] = b, a
            word = ({"en": "lower than its higher child", "ko": "더 높은 자식"} if name == "low" else
                    {"en": "higher than its lower child", "ko": "더 낮은 자식"})
            cmp = "낮으므로" if name == "low" else "높으므로"
            frame({"en": f"Sift down in {name}: {a} at [{j}] is {word['en']} {b} at [{best}], so they swap.",
                   "ko": f"{name}에서 아래로 내리기: [{j}]의 {josa(a, '은는')} {word['ko']} [{best}]의 {b}보다 {cmp} "
                         f"자리를 바꿉니다."},
                  marks={name: {"good": [j], "lit": [best]}}, moves=swap(name, j, best, a, b))
            j = best

    def push(name, value, src, why):
        """Append `value` to heap `name`, moving in from `src`, then sift it up."""
        heap = heaps[name]
        heap.append(value)
        j = len(heap) - 1
        p = (j - 1) // 2
        if j == 0:
            rest = {"en": "it is the top.", "ko": "맨 위가 됩니다."}
        elif above(name, value, heap[p]):
            rest = {"en": "it sifts up past its parent.", "ko": "부모보다 위로 올라가야 합니다."}
        else:
            rest = {"en": f"its parent {heap[p]} stays above it.", "ko": f"부모 {josa(heap[p], '은는')} 그대로 위에 둡니다."}
        frame({"en": why["en"] + f" {value} goes in at the end of {name}, [{j}]; " + rest["en"],
               "ko": why["ko"] + f" {josa(value, '은는')} {name}의 맨 끝 [{j}]에 들어가고, " + rest["ko"]},
              marks={name: {"good": [j]}}, moves=[move(src, at(name, j), value=str(value))])
        sift_up(name, j)

    def move_top(src, dst, why):
        """Pop src's top onto the end of dst, refill src's root from its last node, and sift both."""
        h = heaps[src]
        top = h[0]
        heaps[dst].append(top)
        j = len(heaps[dst]) - 1
        p = (j - 1) // 2
        stays = j == 0 or not above(dst, top, heaps[dst][p])
        # src is drawn with its top still at the root, the step it leaves
        frame({"en": why["en"] + f" {src}'s top {top} leaves it for the end of {dst}, [{j}]" +
                     ("." if stays else ", where it will sift up."),
               "ko": why["ko"] + f" {src}의 맨 위 {josa(top, '이가')} 빠져 {dst}의 맨 끝 [{j}]로 갑니다" +
                     ("." if stays else ". 거기서 위로 올릴 차례입니다.")},
              marks={src: {"lit": [0]}, dst: {"good": [j]}},
              moves=[move(at(src, 0), at(dst, j))])
        last = h.pop()
        if h:
            k = len(h)  # the index `last` sat at, drawn the step it leaves
            h[0] = last
            state["draw"] = {src: h + [last]}
            frame({"en": f"{src}'s last node {last} at [{k}] fills its empty top.",
                   "ko": f"{src}의 마지막 노드 [{k}]의 {josa(last, '이가')} 빈 맨 위를 채웁니다."},
                  marks={src: {"good": [0]}}, moves=[move(at(src, k), at(src, 0))])
            state["draw"] = {}
            sift_down(src, 0)
        sift_up(dst, j)

    for row, (cmd, arg) in enumerate(zip(cmds, args)):
        state["row"] = row
        if cmd == "StreamMedian":
            frame({"en": "StreamMedian() starts with both halves empty and returns null.",
                   "ko": "StreamMedian()은 두 절반이 모두 빈 채로 시작하고 null을 반환합니다."}, moves=answer(None))
        elif cmd == "record":
            num = arg[0]
            push("low", num, at("calls", [row, 1]),
                 {"en": f"record({num}): every number goes into low first.",
                  "ko": f"record({num}): 모든 수는 먼저 low에 들어갑니다."})
            move_top("low", "high",
                     {"en": "low's largest belongs in the upper half if anything does:",
                      "ko": "low의 가장 큰 값이 위쪽 절반에 들어갈 후보이므로,"})
            if len(heaps["high"]) > len(heaps["low"]):
                n_low, n_high = len(heaps["low"]), len(heaps["high"])
                move_top("high", "low",
                         {"en": f"high has {n_high} and low {n_low}, but low must hold at least as many:",
                          "ko": f"high는 {n_high}개, low는 {n_low}개인데 low가 적어도 같은 수를 가져야 하므로,"})
            low, high = heaps["low"], heaps["high"]
            frame({"en": f"record({num}) returns null. low holds {len(low)} and high {len(high)}, and every number "
                         f"in low is at most every number in high.",
                   "ko": f"record({num})는 null을 반환합니다. low에 {len(low)}개, high에 {len(high)}개가 있고, low의 "
                         f"모든 수는 high의 어떤 수보다 크지 않습니다."},
                  moves=answer(None))
        else:
            low, high = heaps["low"], heaps["high"]
            if len(low) > len(high):
                value = float(low[0])
                frame({"en": f"median(): low holds one more than high, so the middle number is low's top: "
                             f"{text(value)}.",
                       "ko": f"median(): low가 high보다 하나 더 많으므로 가운데 수는 low의 맨 위 값 "
                             f"{text(value)}입니다."},
                      marks={"low": {"lit": [0]}}, moves=answer(value, [at("low", 0)]))
            else:
                value = (low[0] + high[0]) / 2
                frame({"en": f"median(): both halves hold {len(low)}, so the median is the average of the two tops: "
                             f"({low[0]} + {high[0]}) / 2 = {text(value)}.",
                       "ko": f"median(): 두 절반이 {len(low)}개씩이므로 중앙값은 두 맨 위 값의 평균 "
                             f"({low[0]} + {high[0]}) / 2 = {text(value)}입니다."},
                      marks={"low": {"lit": [0]}, "high": {"lit": [0]}},
                      moves=answer(value, [at("low", 0), at("high", 0)]))

    printed = "[" + ",".join(text(v) for v in result) + "]"
    state["row"] = len(cmds)
    frame({"en": f"Every call has run; the answer lists one value per call: {printed}.",
           "ko": f"모든 호출이 끝났습니다. 답은 호출마다 값 하나씩입니다: {printed}."}, done=True, answer=printed)
    return printed


for number, sample in enumerate(sample_cases(SLUG), start=1):
    lines = sample["input"].split("\n")
    cmds, args = json.loads(lines[0]), json.loads(lines[1])
    run = sample_run(wt, number, sample, input=f"{json.dumps(cmds, separators=(',', ':'))}\n"
                                               f"{json.dumps(args, separators=(',', ':'))}")
    solve(cmds, args, run)
wt.write(walkthrough_path(SLUG))
