#!/usr/bin/env python3.12
"""kth-top-score-stream's Walkthrough: the reference solution (scripts/replay-solutions/kth-top-score-stream.py), a
min-heap that keeps the k highest scores so far, run on each sample's list of calls, with heapq's heapify, pop, push
and replace written out as the textbook sift-down and sift-up, one swap per frame. The calls are a table, one row per
call, the current call lit and the calls before it faded; the heap is a tree, each node tagged with its array index,
and each call's return value moves into the returned list.

    CODEBITE_DB=<database> scripts/walkthroughs/kth-top-score-stream.py

writes common/src/main/resources/walkthroughs/kth-top-score-stream.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import driver_list, josa, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, level_order_tree, move, swap  # noqa: E402

SLUG = "kth-top-score-stream"

wt = Walkthrough(
    {"en": "K-th Top Score Stream", "ko": "실시간 K번째 최고 점수"},
    {"en": "Keep only the k highest scores in a min-heap: its root is the lowest of them, the k-th highest. A new "
           "score that beats the root replaces it; one that doesn't can't be among the k highest, so the root stays.",
     "ko": "가장 높은 점수 k개만 최소 힙에 둡니다. 루트가 그중 가장 낮은 점수, 곧 k번째로 높은 점수입니다. 새 점수가 루트보다 "
           "높으면 루트를 밀어내고, 아니면 높은 k개에 들 수 없으므로 루트가 그대로입니다."},
    views=[
        {"id": "calls", "type": "table", "title": {"en": "calls", "ko": "호출"}},
        {"id": "heap", "type": "tree", "arity": 2,
         "title": {"en": "min-heap of the k highest ([i]: array index)", "ko": "높은 점수 k개의 최소 힙 ([i]: 배열 인덱스)"},
         "empty": {"en": "empty", "ko": "비어 있음"}},
        {"id": "result", "type": "output", "title": {"en": "returned", "ko": "반환값"}},
    ],
)


def solve(ops, args, run):
    """The Driver's loop over TopKStream's calls with heapq written out, a frame per step. Returns the printed list."""
    rows = [{"label": str(i), "cells": [op, f"{a[0]}, {driver_list(a[1])}" if op == "TopKStream" else str(a[0])]}
            for i, (op, a) in enumerate(zip(ops, args))]
    heap = []
    result = []
    st = {"row": 0, "draw": None, "k": None}
    drawn = [0]

    def frame(caption, marks=None, moves=None, done=False, **answer):
        r = st["row"]
        fresh = list(range(drawn[0], len(result)))
        drawn[0] = len(result)
        shown = st["draw"] if st["draw"] is not None else heap
        node_marks = {"path": [0]} if done and shown else (marks or {})
        run.frame(caption,
                  calls={"columns": [{"en": "call", "ko": "호출"}, {"en": "argument", "ko": "인자"}], "rows": rows,
                         "marks": {} if done else {"dim": [[i, c] for i in range(r) for c in (0, 1)],
                                                   "lit": [[r, 0], [r, 1]]}},
                  heap={**level_order_tree(list(shown)), "tags": [[j, f"[{j}]"] for j in range(len(shown))],
                        "nodeMarks": node_marks},
                  result={"values": list(result),
                          "marks": {"path": list(range(len(result)))} if done else {"good": fresh}},
                  moves=moves, **answer)

    def sift_down(j):
        """Swap the score at j down to its lower child while that child is lower."""
        while True:
            low = j
            for c in (2 * j + 1, 2 * j + 2):
                if c < len(heap) and heap[c] < heap[low]:
                    low = c
            if low == j:
                return
            a, b = heap[j], heap[low]
            heap[j], heap[low] = b, a
            frame({"en": f"Sift down: {a} at [{j}] is higher than its lower child {b} at [{low}], so they swap.",
                   "ko": f"아래로 내리기: [{j}]의 {josa(a, '은는')} 더 낮은 자식 [{low}]의 {b}보다 높으므로 자리를 바꿉니다."},
                  marks={"good": [j], "lit": [low]}, moves=swap("heap", j, low, a, b))
            j = low

    def sift_up(j):
        """Swap the score at j up while it is lower than its parent."""
        while j > 0:
            p = (j - 1) // 2
            if heap[j] >= heap[p]:
                return
            a, b = heap[j], heap[p]
            heap[j], heap[p] = b, a
            frame({"en": f"Sift up: {a} at [{j}] is lower than its parent {b} at [{p}], so they swap.",
                   "ko": f"위로 올리기: [{j}]의 {josa(a, '은는')} 부모 [{p}]의 {b}보다 낮으므로 자리를 바꿉니다."},
                  marks={"good": [p], "lit": [j]}, moves=swap("heap", j, p, a, b))
            j = p

    def returns_root(caption):
        top = heap[0]
        result.append(str(top))
        frame(caption, marks={"lit": [0]}, moves=[move(at("heap", 0), at("result", len(result) - 1))])

    for row, (op, arg) in enumerate(zip(ops, args)):
        st["row"] = row
        if op == "TopKStream":
            k, scores = arg
            st["k"] = k
            frame({"en": f"TopKStream({k}, {driver_list(scores)}): k = {k}, so the heap will keep the {k} highest "
                         f"scores, and its root, the lowest of them, is the k-th highest.",
                   "ko": f"TopKStream({k}, {driver_list(scores)}): k = {k}이므로 힙에 가장 높은 점수 {k}개를 두고, "
                         f"그중 가장 낮은 루트가 {k}번째로 높은 점수입니다."})
            if scores:
                heap.extend(scores)
                frame({"en": f"self.heap = list(scores): the {len(scores)} starting scores go into the heap list "
                             f"in their order; heapify will put the lowest on top.",
                       "ko": f"self.heap = list(scores): 처음 점수 {len(scores)}개를 순서대로 힙 리스트에 넣습니다. "
                             f"heapify가 가장 낮은 점수를 맨 위로 올립니다."},
                      marks={"good": list(range(len(heap)))},
                      moves=[move(at("calls", [row, 1]), at("heap", j), value=str(v)) for j, v in enumerate(heap)])
                for j in reversed(range(len(heap) // 2)):
                    sift_down(j)
            while len(heap) > k:
                top = heap[0]
                frame({"en": f"The heap holds {len(heap)}, more than k = {k}: pop the root {top}, the lowest, "
                             f"which can't be among the {k} highest.",
                       "ko": f"힙에 {len(heap)}개가 있어 k = {k}보다 많으므로, 가장 낮은 루트 {josa(top, '을를')} "
                             f"꺼냅니다. 높은 {k}개에 들 수 없습니다."},
                      marks={"bad": [0]}, moves=[move(at("heap", 0), mark="bad")])
                last = heap.pop()
                if heap:
                    n = len(heap)
                    heap[0] = last
                    st["draw"] = heap + [last]
                    frame({"en": f"The last node {last} at [{n}] fills the empty root.",
                           "ko": f"마지막 노드 [{n}]의 {josa(last, '이가')} 빈 루트를 채웁니다."},
                          marks={"good": [0]}, moves=[move(at("heap", n), at("heap", 0))])
                    st["draw"] = None
                    sift_down(0)
            result.append("null")
            frame({"en": f"The heap holds the {len(heap)} highest starting scores; the constructor returns null.",
                   "ko": f"힙에 처음 점수 중 가장 높은 {len(heap)}개가 있습니다. 생성자는 null을 반환합니다."},
                  moves=[move(at("calls", [row, 0]), at("result", 0), value="null")])
        else:
            val = arg[0]
            k = st["k"]
            if len(heap) < k:
                heap.append(val)
                j = len(heap) - 1
                frame({"en": f"record({val}): the heap holds {j}, fewer than k = {k}, so {val} goes in at the end, "
                             f"[{j}].",
                       "ko": f"record({val}): 힙에 {j}개뿐이라 k = {k}보다 적으므로 {josa(val, '이가')} 맨 끝 "
                             f"[{j}]에 들어갑니다."},
                      marks={"good": [j]}, moves=[move(at("calls", [row, 1]), at("heap", j))])
                sift_up(j)
            elif val > heap[0]:
                old = heap[0]
                heap[0] = val
                kids = [c for c in (1, 2) if c < len(heap)]
                low = min(kids, key=lambda c: heap[c]) if kids else None
                rest = ({"en": f" It is higher than its lower child {heap[low]}, so it sifts down.",
                         "ko": f" 더 낮은 자식 {heap[low]}보다 높으므로 아래로 내립니다."}
                        if low is not None and heap[low] < val else
                        {"en": " No child is lower, so it stays.", "ko": " 더 낮은 자식이 없으므로 그대로 둡니다."})
                frame({"en": f"record({val}): {val} beats the root {old}, so {old} leaves and {val} takes the "
                             f"root.{rest['en']}",
                       "ko": f"record({val}): {josa(val, '이가')} 루트 {old}보다 높으므로 {josa(old, '은는')} 빠지고 "
                             f"{josa(val, '이가')} 루트에 들어갑니다.{rest['ko']}"},
                      marks={"good": [0]},
                      moves=[move(at("heap", 0), value=str(old), mark="bad"),
                             move(at("calls", [row, 1]), at("heap", 0))])
                sift_down(0)
            else:
                frame({"en": f"record({val}): {val} is not higher than the root {heap[0]}, and the heap already "
                             f"holds {k} scores at least {heap[0]}, so {val} can't be among them: skip it.",
                       "ko": f"record({val}): {josa(val, '은는')} 루트 {heap[0]}보다 높지 않고, 힙에는 이미 "
                             f"{heap[0]} 이상인 점수가 {k}개 있으므로 건너뜁니다."},
                      marks={"lit": [0]}, moves=[move(at("calls", [row, 1]), mark="bad")])
            returns_root({"en": f"record({val}) returns the root, {heap[0]}: the k-th highest score so far.",
                          "ko": f"record({val}) 호출은 루트 {josa(heap[0], '을를')} 반환합니다. 지금까지 {k}번째로 높은 "
                                f"점수입니다."})

    printed = "[" + ",".join(result) + "]"
    st["row"] = len(ops)
    frame({"en": f"Every call has run; the returned values, one per call, are {printed}.",
           "ko": f"모든 호출이 끝났습니다. 호출마다 하나씩 반환한 값은 {printed}입니다."},
          done=True, answer=printed)
    return printed


for number, sample in enumerate(sample_cases(SLUG), start=1):
    lines = sample["input"].split("\n")
    ops, args = json.loads(lines[0]), json.loads(lines[1])
    run = sample_run(wt, number, sample, input=f"{driver_list(ops)}\n{driver_list(args)}")
    solve(ops, args, run)
wt.write(walkthrough_path(SLUG))
