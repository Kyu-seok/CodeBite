#!/usr/bin/env python3.12
"""nearest-cafe-stops' Walkthrough: the reference solution (scripts/replay-solutions/nearest-cafe-stops.py), a
max-heap of the k nearest stops so far keyed by squared distance (heapq on negated distances, drawn with the
distances themselves), with heapq's push and replace written out as the textbook sift-up and sift-down, one swap per
frame. The stops are a table, each stop's x² + y² written beside it as it is read; the heap is a tree, each node its
squared distance tagged with its array index and its stop, and the stops left in the heap at the end are the answer,
printed sorted as the Driver prints them.

    CODEBITE_DB=<database> scripts/walkthroughs/nearest-cafe-stops.py

writes common/src/main/resources/walkthroughs/nearest-cafe-stops.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import driver_list, josa, plural, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, level_order_tree, move, swap  # noqa: E402

SLUG = "nearest-cafe-stops"

wt = Walkthrough(
    {"en": "Nearest Cafe Stops", "ko": "가장 가까운 카페 배달지"},
    {"en": "Keep the k nearest stops so far in a max-heap by x² + y² (the square keeps the order of the distances, "
           "with no square root): its root is the farthest of them, so a nearer stop replaces it and a farther one "
           "can't be among the k nearest.",
     "ko": "지금까지 가장 가까운 배달지 k개를 x² + y² 기준 최대 힙에 둡니다(제곱해도 거리의 순서는 같아 제곱근이 필요 "
           "없습니다). 루트가 그중 가장 먼 배달지이므로, 더 가까운 배달지는 루트를 밀어내고 더 먼 배달지는 k개에 들 수 "
           "없습니다."},
    views=[
        {"id": "stops", "type": "table", "title": {"en": "stops", "ko": "stops (배달지)"}},
        {"id": "heap", "type": "tree", "arity": 2,
         "title": {"en": "max-heap of x² + y², farthest on top", "ko": "x² + y²의 최대 힙 (맨 위가 가장 멂)"},
         "empty": {"en": "empty", "ko": "비어 있음"}},
        {"id": "result", "type": "output", "title": {"en": "answer", "ko": "답"},
         "empty": {"en": "not yet", "ko": "아직 없음"}},
        {"id": "state", "type": "vars"},
    ],
)


def sq(v):
    return f"({v})²" if v < 0 else f"{v}²"


def pt(x, y):
    return f"({x},{y})"


def solve(stops, k, run):
    """Solution.selectNearestStops with heapq written out, a frame per stop read and per swap. Returns the answer
    as the Driver prints it."""
    n = len(stops)
    rows = [{"label": str(i), "cells": [str(x), str(y), ""]} for i, (x, y) in enumerate(stops)]
    heap = []   # entries (d, x, y, i), the farthest on top
    out = []
    st = {"i": None, "row_mark": "lit", "dropped": []}

    def above(a, b):
        """heapq's order on (-d, x, y): a sits above b when it is farther, or as far with a smaller x, then y."""
        return (-a[0], a[1], a[2]) < (-b[0], b[1], b[2])

    def frame(caption, marks=None, moves=None, done=False, **answer):
        i = st["i"]
        cell = {"dim": [[r, c] for r in st["dropped"] for c in (0, 1, 2)]}
        if i is not None and not done:
            cell[st["row_mark"]] = [[i, 0], [i, 1], [i, 2]]
        if done:
            cell = {"dim": cell["dim"], "path": [[e[3], c] for e in heap for c in (0, 1, 2)]}
        run.frame(caption,
                  stops={"columns": ["x", "y", "x² + y²"], "rows": rows, "marks": cell},
                  heap={**level_order_tree([e[0] for e in heap]),
                        "tags": [[j, f"[{j}] {pt(e[1], e[2])}"] for j, e in enumerate(heap)],
                        "nodeMarks": {"path": list(range(len(heap)))} if done else (marks or {})},
                  result={"values": list(out), "marks": {"path": list(range(len(out)))}},
                  state={"items": [{"label": "k", "value": k}]},
                  moves=moves, **answer)

    def sift_up(j):
        while j > 0:
            p = (j - 1) // 2
            if not above(heap[j], heap[p]):
                return
            a, b = heap[j], heap[p]
            heap[j], heap[p] = b, a
            frame({"en": f"Sift up: {a[0]} at [{j}] is farther than its parent {b[0]} at [{p}], so they swap.",
                   "ko": f"위로 올리기: [{j}]의 {josa(a[0], '이가')} 부모 [{p}]의 {b[0]}보다 멀므로 자리를 바꿉니다."},
                  marks={"good": [p], "lit": [j]}, moves=swap("heap", j, p, str(a[0]), str(b[0])))
            j = p

    def sift_down(j):
        while True:
            big = j
            for c in (2 * j + 1, 2 * j + 2):
                if c < len(heap) and above(heap[c], heap[big]):
                    big = c
            if big == j:
                return
            a, b = heap[j], heap[big]
            heap[j], heap[big] = b, a
            frame({"en": f"Sift down: {a[0]} at [{j}] is nearer than its farther child {b[0]} at [{big}], so they "
                         f"swap.",
                   "ko": f"아래로 내리기: [{j}]의 {josa(a[0], '이가')} 더 먼 자식 [{big}]의 {b[0]}보다 가까우므로 "
                         f"자리를 바꿉니다."},
                  marks={"good": [j], "lit": [big]}, moves=swap("heap", j, big, str(a[0]), str(b[0])))
            j = big

    frame({"en": f"{n} {plural(n, 'stop', 'stops')}, k = {k}. The max-heap will hold the {k} nearest read so far, "
                 f"keyed by x² + y², so its root is the farthest of them.",
           "ko": f"배달지 {n}개, k = {k}입니다. 최대 힙에 지금까지 읽은 것 중 가장 가까운 {k}개를 x² + y² 기준으로 두므로, "
                 f"루트는 그중 가장 먼 배달지입니다."})
    for i, (x, y) in enumerate(stops):
        st["i"] = i
        st["row_mark"] = "lit"
        d = x * x + y * y
        rows[i]["cells"][2] = str(d)
        calc = f"{sq(x)} + {sq(y)} = {d}"
        entry = (d, x, y, i)
        written = move(at("stops", [i, 0]), at("stops", [i, 2]), value=str(d))
        if len(heap) < k:
            heap.append(entry)
            j = len(heap) - 1
            p = (j - 1) // 2
            if j == 0:
                rest = {"en": "it is the root.", "ko": "루트가 됩니다."}
            elif above(entry, heap[p]):
                rest = {"en": f"it is farther than its parent {heap[p][0]}, so it sifts up.",
                        "ko": f"부모 {heap[p][0]}보다 멀므로 위로 올립니다."}
            else:
                rest = {"en": f"its parent {heap[p][0]} is farther, so it stays.",
                        "ko": f"부모 {josa(heap[p][0], '이가')} 더 멀므로 그대로 둡니다."}
            frame({"en": f"Stop {i} {pt(x, y)}: {calc}. The heap holds {j} of {k}, so it goes in at the end, [{j}]; "
                         + rest["en"],
                   "ko": f"배달지 {i} {pt(x, y)}: {calc}. 힙에 {j}개뿐이라 맨 끝 [{j}]에 넣고, " + rest["ko"]},
                  marks={"good": [j]}, moves=[written, move(at("stops", [i, 2]), at("heap", j))])
            sift_up(j)
        elif above(heap[0], entry):
            old = heap[0]
            st["dropped"].append(old[3])
            heap[0] = entry
            kids = [c for c in (1, 2) if c < len(heap)]
            big = max(kids, key=lambda c: (heap[c][0], -heap[c][1], -heap[c][2])) if kids else None
            rest = ({"en": f" Its child {heap[big][0]} is farther, so it sifts down.",
                     "ko": f" 자식 {heap[big][0]}보다 가까우므로 아래로 내립니다."}
                    if big is not None and above(heap[big], entry) else
                    {"en": " No child is farther, so it stays.", "ko": " 더 먼 자식이 없으므로 그대로 둡니다."})
            frame({"en": f"Stop {i} {pt(x, y)}: {calc}, nearer than the root {old[0]}, the farthest kept: "
                         f"{pt(old[1], old[2])} leaves and {pt(x, y)} takes the root.{rest['en']}",
                   "ko": f"배달지 {i} {pt(x, y)}: {calc}. 남겨 둔 것 중 가장 먼 루트 {old[0]}보다 가까우므로 "
                         f"{pt(old[1], old[2])} 배달지가 빠지고 {pt(x, y)} 배달지가 루트에 들어갑니다.{rest['ko']}"},
                  marks={"good": [0]},
                  moves=[written, move(at("heap", 0), at("stops", [old[3], 2]), value=str(old[0]), mark="bad"),
                         move(at("stops", [i, 2]), at("heap", 0))])
            sift_down(0)
        else:
            st["row_mark"] = "bad"
            st["dropped"].append(i)
            frame({"en": f"Stop {i} {pt(x, y)}: {calc}, not nearer than the root {heap[0][0]}, and the heap already "
                         f"holds {k} {plural(k, 'stop', 'stops')} at most that far: skip it.",
                   "ko": f"배달지 {i} {pt(x, y)}: {calc}. 루트 {heap[0][0]}보다 가깝지 않고, 힙에는 이미 그보다 멀지 않은 "
                         f"배달지가 {k}개 있으므로 건너뜁니다."},
                  marks={"lit": [0]}, moves=[written, move(at("stops", [i, 2]), mark="bad")])
    kept = sorted(heap, key=lambda e: (e[1], e[2]))
    answer = [[e[1], e[2]] for e in kept]
    printed = driver_list(answer)
    out.extend(driver_list(p) for p in answer)
    st["i"] = None
    frame({"en": f"Every stop is read. The heap holds the {k} nearest; sorted as the Driver prints them, the answer "
                 f"is {printed}.",
           "ko": f"모든 배달지를 읽었습니다. 힙에 가장 가까운 {k}개가 남았고, 출력할 때처럼 정렬하면 답은 {printed}입니다."},
          moves=[move(at("heap", heap.index(e)), at("result", r), value=out[r]) for r, e in enumerate(kept)],
          done=True, answer=printed)
    return printed


for number, sample in enumerate(sample_cases(SLUG), start=1):
    lines = sample["input"].split("\n")
    stops, k = json.loads(lines[0]), int(lines[1])
    run = sample_run(wt, number, sample, input=f"stops = {driver_list(stops)}, k = {k}")
    solve(stops, k, run)
wt.write(walkthrough_path(SLUG))
