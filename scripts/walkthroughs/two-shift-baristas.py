#!/usr/bin/env python3.12
"""two-shift-baristas' Walkthrough: the reference solution (scripts/replay-solutions/two-shift-baristas.py), a
two-colouring with a stack from each barista not placed yet, on each sample Test Case. The conflicts are drawn as the
description's graph Diagram draws them, each barista's shift under it; a frame per group started, per barista popped
that places new ones (and one for pushing them), one for each run of pops that place nobody, and one for a conflict
inside a shift.

    CODEBITE_DB=<database> scripts/walkthroughs/two-shift-baristas.py

writes common/src/main/resources/walkthroughs/two-shift-baristas.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import josa, listed, plural, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move  # noqa: E402

SLUG = "two-shift-baristas"

wt = Walkthrough(
    {"en": "Two Shift Baristas", "ko": "바리스타 두 교대 나누기"},
    {"en": "Put the first barista of each group on shift 0, then every barista in conflict with a placed one on the "
           "other shift, through a stack. A conflict between two baristas on the same shift means no split works.",
     "ko": "무리마다 첫 바리스타를 교대 0에 넣고, 스택으로 배치된 바리스타와 충돌하는 바리스타를 모두 다른 교대에 넣습니다. "
           "같은 교대의 두 바리스타가 충돌하면 어떤 분할도 불가능합니다."},
    views=[
        {"id": "baristas", "type": "graph", "directed": False,
         "title": {"en": "conflicts (under: shift)", "ko": "충돌 (아래: 교대)"}},
        {"id": "stack", "type": "stack", "title": {"en": "stack: baristas to check", "ko": "스택: 살펴볼 바리스타"},
         "empty": {"en": "empty", "ko": "비어 있음"}},
    ],
)


def graph(conflicts):
    """The conflicts as the description's graph Diagram draws them: each pair once, in the order the lists name it,
    nodes in the order the edges name them, then the rest."""
    edges = []
    for i, others in enumerate(conflicts):
        for j in others:
            if (j, i) not in edges and (i, j) not in edges:
                edges.append((i, j))
    order = []
    for a, b in edges:
        for v in (a, b):
            if v not in order:
                order.append(v)
    order += [v for v in range(len(conflicts)) if v not in order]
    return edges, {"baristas": {"nodes": [{"id": v} for v in order],
                                "edges": [{"from": a, "to": b} for a, b in edges]}}


def listed_josa(nums, particle):
    """The numbers listed, the Korean particle after the last: "1, 2를"."""
    return ", ".join([str(v) for v in nums[:-1]] + [josa(nums[-1], particle)])


def solve(conflicts, run):
    """Solution.splitIntoTwoShifts with a frame per step. Returns nothing; the last frame carries the answer."""
    n = len(conflicts)
    edges, _ = graph(conflicts)
    edge_index = {}
    for i, (a, b) in enumerate(edges):
        edge_index[(a, b)] = edge_index[(b, a)] = i
    shift = [-1] * n
    todo = []       # the stack, bottom first
    leaving = []    # the baristas popped this frame, still drawn on top, first popped on top

    def frame(caption, lit=(), good=(), bad=(), path=(), edge_lit=(), edge_bad=(), stack_marks=None, moves=None,
              **answer):
        run.frame(caption,
                  baristas={"values": {str(v): shift[v] for v in range(n) if shift[v] != -1},
                            "nodeMarks": {"path": list(path), "bad": list(bad), "good": list(good), "lit": list(lit)},
                            "edgeMarks": {"bad": [edge_index[e] for e in edge_bad],
                                          "lit": [edge_index[e] for e in edge_lit]}},
                  stack={"values": todo + leaving[::-1], "marks": stack_marks or {}},
                  moves=moves, **answer)

    k = len(edges)
    frame({"en": f"{n} {plural(n, 'barista', 'baristas')} and {k} {plural(k, 'conflict', 'conflicts')}. Nobody is on "
                 f"a shift yet.",
           "ko": f"바리스타 {n}명과 충돌 {k}개가 있습니다. 아직 아무도 교대에 배치되지 않았습니다."})

    def flush():
        """One frame for the baristas popped in a row that placed nobody new."""
        if not leaving:
            return
        c = len(leaving)
        base = len(todo)
        checked = [(v, o) for v in leaving for o in conflicts[v]]
        why = ({"en": "every conflict is already with the other shift", "ko": "충돌하는 바리스타는 모두 이미 다른 교대에 "
                "있습니다"} if checked else {"en": f"{plural(c, 'this barista has', 'these baristas have')} no conflict",
                                         "ko": "충돌하는 바리스타가 없습니다"})
        frame({"en": f"Pop {plural(c, 'barista', 'baristas')} {listed(leaving)}: {why['en']}.",
               "ko": f"바리스타 {listed_josa(leaving, '을를')} 꺼냅니다. {why['ko']}."},
              lit=list(leaving), edge_lit=checked, stack_marks={"lit": list(range(base, base + c))},
              moves=[move(at("stack", base + i)) for i in range(c)])
        leaving.clear()

    for start in range(n):
        if shift[start] != -1:
            continue
        shift[start] = 0
        todo.append(start)
        frame({"en": f"Barista {start} is on no shift yet, so a new group starts: put {start} on shift 0 and push "
                     f"it.",
               "ko": f"바리스타 {josa(start, '은는')} 아직 교대가 없으므로 새 무리를 시작합니다. 교대 0에 넣고 스택에 "
                     f"넣습니다."},
              good=[start], stack_marks={"good": [len(todo) - 1]},
              moves=[move(None, at("baristas", start), value="0"),
                     move(at("baristas", start), at("stack", len(todo) - 1), value=str(start))])
        while todo:
            node = todo.pop()
            placed, clash = [], None
            for other in conflicts[node]:
                if shift[other] == -1:
                    placed.append(other)
                    shift[other] = 1 - shift[node]
                elif shift[other] == shift[node]:
                    clash = other
                    break
            if not placed and clash is None:
                leaving.append(node)
                if not todo:
                    flush()
                continue
            todo.append(node)   # still on the stack while the pops before it are drawn
            for v in placed:
                shift[v] = -1   # drawn from the frame that pops node
            flush()
            for v in placed:
                shift[v] = 1 - shift[node]
            todo.pop()
            leaving.append(node)
            top = len(todo)
            s = shift[node]
            if placed:
                p = len(placed)
                frame({"en": f"Pop barista {node}, on shift {s}: {listed(placed)} {plural(p, 'conflicts', 'conflict')} "
                             f"with {node} and {plural(p, 'has', 'have')} no shift yet, so {plural(p, 'it goes', 'they go')} "
                             f"on shift {1 - s}.",
                       "ko": f"교대 {s}의 바리스타 {josa(node, '을를')} 꺼냅니다. 충돌하면서 아직 교대가 없는 바리스타 "
                             f"{listed_josa(placed, '은는')} 교대 {1 - s}에 들어갑니다."},
                      lit=[node], good=placed, edge_lit=[(node, v) for v in placed], stack_marks={"lit": [top]},
                      moves=[move(at("baristas", [node, v]), at("baristas", v), value=str(1 - s)) for v in placed])
            if clash is not None:
                if placed:
                    leaving.clear()
                then = "Still on" if placed else "Pop"
                frame({"en": f"{then} barista {node}: {clash} conflicts with {node} but is on the same shift {s}, so no "
                             f"split into two shifts works: answer false.",
                       "ko": f"바리스타 {josa(clash, '은는')} {node}번과 충돌하는데 같은 교대 {s}에 있으므로, 두 교대로 "
                             f"나눌 수 없습니다: 답은 false입니다."},
                      bad=[node, clash], edge_bad=[(node, clash)],
                      stack_marks={"lit": [top]} if leaving else None,
                      moves=[move(at("stack", top))] if leaving else None, answer="false")
                return
            leaving.clear()
            todo.extend(placed)
            frame({"en": f"Push {listed(placed)}, to check {plural(len(placed), 'its', 'their')} conflicts in turn.",
                   "ko": f"바리스타 {listed_josa(placed, '을를')} 스택에 넣어, 차례로 그 충돌을 살핍니다."},
                  good=placed, stack_marks={"good": list(range(top, len(todo)))},
                  moves=[move(at("baristas", v), at("stack", top + i), value=str(v)) for i, v in enumerate(placed)])
    zero = [v for v in range(n) if shift[v] == 0]
    one = [v for v in range(n) if shift[v] == 1]
    split = (f"shift 0 takes {listed(zero)}" + (f" and shift 1 takes {listed(one)}" if one else ", shift 1 is empty"))
    split_ko = (f"교대 0에 {listed(zero)}" + (f", 교대 1에 {listed(one)}" if one else ", 교대 1은 비어 있음"))
    frame({"en": f"Every barista is placed and no conflict is inside a shift: {split}. Answer: true.",
           "ko": f"모든 바리스타가 배치되었고 같은 교대 안의 충돌이 없습니다({split_ko}). 답은 true입니다."},
          path=list(range(n)), answer="true")


for number, sample in enumerate(sample_cases(SLUG), start=1):
    conflicts = json.loads(sample["input"])
    run = sample_run(wt, number, sample, setup=graph(conflicts)[1], input=f"conflicts = {sample['input']}")
    solve(conflicts, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
