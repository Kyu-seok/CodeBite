#!/usr/bin/env python3.12
"""cafe-price-ratios' Walkthrough: the reference solution (scripts/replay-solutions/cafe-price-ratios.py), a search
with a stack per query that multiplies the ratios along the way, on each sample Test Case. The items are drawn as the
description's graph Diagram draws them (an arrow A → B labelled with A / B, nodes in the order the arrows name them),
each item the current search reached carrying its ratio start / item under it; the queries are a table, and each
answer moves into the answers.

    CODEBITE_DB=<database> scripts/walkthroughs/cafe-price-ratios.py

writes common/src/main/resources/walkthroughs/cafe-price-ratios.json.
"""
import json
import os
import sys
from collections import defaultdict

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import plural, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move  # noqa: E402

SLUG = "cafe-price-ratios"

wt = Walkthrough(
    {"en": "Cafe Price Ratios", "ko": "가격 비율 계산하기"},
    {"en": "Each ratio A / B = k is an edge both ways: × k from A to B, × 1/k back. For each query, search from its "
           "first item with a stack, carrying the product of the ratios along the way; reaching the second item, the "
           "product is the answer.",
     "ko": "비율 A / B = k마다 양방향 간선을 둡니다: A에서 B로는 × k, 거꾸로는 × 1/k입니다. 질의마다 첫 품목에서 스택으로 "
           "찾으며 지나온 비율의 곱을 들고 가고, 두 번째 품목에 닿으면 그 곱이 답입니다."},
    views=[
        {"id": "prices", "type": "graph", "directed": True,
         "title": {"en": "ratios (arrow A → B: A / B; under: start / item)",
                   "ko": "비율 (화살표 A → B: A / B, 아래: 시작 / 품목)"}},
        {"id": "queries", "type": "table", "title": {"en": "queries", "ko": "queries (질의)"},
         "columns": [{"en": "query", "ko": "질의"}]},
        {"id": "stack", "type": "stack", "title": {"en": "stack (tag: start / item)", "ko": "스택 (태그: 시작 / 품목)"},
         "empty": {"en": "empty", "ko": "비어 있음"}},
        {"id": "result", "type": "output", "title": {"en": "answers", "ko": "답"},
         "empty": {"en": "none yet", "ko": "아직 없음"}},
    ],
)


def num(x):
    """A ratio as the drawing writes it: up to 5 decimals, trailing zeros dropped (12, 0.25, 0.08333)."""
    text = f"{x:.5f}".rstrip("0").rstrip(".")
    return text if text != "-0" else "0"


def graph(ratios, values):
    """The items as the description's graph Diagram draws them: an arrow per ratio, nodes in the order the arrows
    name them."""
    order = []
    for a, b in ratios:
        for v in (a, b):
            if v not in order:
                order.append(v)
    return {"prices": {"nodes": [{"id": v} for v in order],
                       "edges": [{"from": a, "to": b, "label": f"{k}"} for (a, b), k in zip(ratios, values)]}}


def solve(ratios, values, queries, run):
    """Solution.resolvePriceRatios with a frame per step. Returns nothing; the last frame carries the answer."""
    adj = defaultdict(list)     # item -> [(neighbour, ratio, the drawn edge)]
    for (a, b), k in zip(ratios, values):
        adj[a].append((b, k, [a, b]))
        adj[b].append((a, 1 / k, [a, b]))
    reached = {}    # item -> start / item, for the current search
    todo = []       # the stack, bottom first: (item, product)
    leaving = []    # the entry popped this frame, still drawn on top
    answers = []
    current = None  # the query row being answered

    def frame(caption, lit=(), good=(), bad=(), path=(), edge_lit=(), edge_path=(), stack_marks=None,
              result_marks=None, moves=None, **answer):
        shown = todo + leaving
        rows = [{"cells": [f"{c} / {d}"]} for c, d in queries]
        row_marks = {"dim": [[i, 0] for i in range(len(answers)) if i != current]} if "answer" not in answer else {}
        if current is not None and "answer" not in answer:
            row_marks["lit"] = [[current, 0]]
        edges = [list(e) for e in ratios]
        run.frame(caption,
                  prices={"values": {v: num(p) for v, p in reached.items()},
                          "nodeMarks": {"path": list(path), "bad": list(bad), "good": list(good), "lit": list(lit)},
                          "edgeMarks": {"path": [edges.index(e) for e in edge_path],
                                        "lit": [edges.index(e) for e in edge_lit]}},
                  queries={"rows": rows, "marks": row_marks},
                  stack={"values": [v for v, _ in shown], "tags": [[i, num(p)] for i, (_, p) in enumerate(shown)],
                         "marks": stack_marks or {}},
                  result={"values": list(answers), "marks": result_marks or {}},
                  moves=moves, **answer)

    r, q = len(ratios), len(queries)
    frame({"en": f"{r} known {plural(r, 'ratio', 'ratios')} and {q} {plural(q, 'query', 'queries')}. Each ratio can "
                 f"be walked both ways: along its arrow × the ratio, against it ÷ the ratio.",
           "ko": f"알려진 비율 {r}개와 질의 {q}개가 있습니다. 비율은 양방향으로 쓸 수 있어서, 화살표 방향으로는 비율을 곱하고 "
                 f"반대 방향으로는 비율로 나눕니다."})

    for j, (c, d) in enumerate(queries):
        current = j
        missing = [v for v in dict.fromkeys((c, d)) if v not in adj]
        # the last search's values leave, except c's, which a search starting there writes over with 1
        clear = [move(at("prices", v), mark="bad") for v in reached if v != c or missing]
        reached.clear()
        todo.clear()
        if missing:
            answers.append(f"{-1.0:.5f}")
            frame({"en": f"Query {j + 1}, {c} / {d}: {' and '.join(missing)} never "
                         f"{plural(len(missing), 'appears', 'appear')} in the ratios, so the answer is -1.",
                   "ko": f"질의 {j + 1}, {c} / {d}: {', '.join(missing)} 품목은 비율에 한 번도 나오지 않으므로 답은 "
                         f"-1입니다."},
                  result_marks={"good": [j]},
                  moves=clear + [move(at("queries", [j, 0]), at("result", j), value=answers[-1])])
            continue
        reached[c] = 1.0
        todo.append((c, 1.0))
        frame({"en": f"Query {j + 1}, {c} / {d}: start at {c}, whose ratio to itself is 1, and push it.",
               "ko": f"질의 {j + 1}, {c} / {d}: {c} 품목에서 시작합니다. 자기 자신과의 비율은 1이고, 스택에 넣습니다."},
              lit=[c], good=[c], stack_marks={"good": [0]},
              moves=clear + [move(at("queries", [j, 0]), at("prices", c), value="1"),
                             move(at("prices", c), at("stack", 0), value=c)])
        found = None
        while todo:
            node, product = todo.pop()
            leaving[:] = [(node, product)]
            top = len(todo)
            if node == d:
                found = product
                answers.append(f"{product:.5f}")
                frame({"en": f"Pop {d}: it is the item the query asks for, so {c} / {d} = {num(product)}.",
                       "ko": f"{d} 품목을 꺼냅니다. 질의가 찾는 품목이므로 {c} / {d} = {num(product)}입니다."},
                      lit=[d], path=[d], stack_marks={"lit": [top]}, result_marks={"good": [j]},
                      moves=[move(at("prices", d), at("result", j), value=answers[-1])])
                leaving.clear()
                break
            new = [(v, k, e) for v, k, e in adj[node] if v not in reached]
            if not new:
                frame({"en": f"Pop {node}: every item next to it was already reached in this search.",
                       "ko": f"{node} 품목을 꺼냅니다. 이웃한 품목은 모두 이번 탐색에서 이미 닿았습니다."},
                      lit=[node], stack_marks={"lit": [top]}, moves=[move(at("stack", top))])
                leaving.clear()
                continue
            steps_en, steps_ko = [], []
            for v, k, e in new:
                reached[v] = product * k
                way = f"× {num(k)}" if e[0] == node else f"÷ {num(1 / k)}"
                steps_en.append(f"{v} = {num(product)} {way} = {num(product * k)}")
            frame({"en": f"Pop {node}, at {num(product)}: {'; '.join(steps_en)}.",
                   "ko": f"{num(product)}인 {node} 품목을 꺼냅니다: {'; '.join(steps_en)}."},
                  lit=[node], good=[v for v, _, _ in new], edge_lit=[e for _, _, e in new],
                  stack_marks={"lit": [top]},
                  moves=[move(at("prices", e), at("prices", v), value=num(product * k)) for v, k, e in new])
            leaving.clear()
            for v, k, _ in new:
                todo.append((v, product * k))
            n = len(new)
            names = ", ".join(v for v, _, _ in new)
            frame({"en": f"Push {names}, to search on from {plural(n, 'it', 'them')}.",
                   "ko": f"{names} 품목을 스택에 넣어, 거기서 계속 찾습니다."},
                  good=[v for v, _, _ in new], stack_marks={"good": list(range(top, len(todo)))},
                  moves=[move(at("prices", v), at("stack", top + i), value=v) for i, (v, _, _) in enumerate(new)])
        if found is None:
            answers.append(f"{-1.0:.5f}")
            frame({"en": f"The stack is empty and {d} was never reached: {c} and {d} are not linked, so the answer "
                         f"is -1.",
                   "ko": f"스택이 비었는데 {d} 품목에 닿지 못했습니다. {c} 품목과 이어져 있지 않으므로 답은 -1입니다."},
                  result_marks={"good": [j]},
                  moves=[move(at("queries", [j, 0]), at("result", j), value=answers[-1])])
    current = None
    result = "[" + ",".join(answers) + "]"
    frame({"en": f"Every query is answered, rounded to 5 decimals: {result}.",
           "ko": f"모든 질의에 소수점 아래 5자리로 답했습니다: {result}."},
          result_marks={"path": list(range(len(answers)))}, answer=result)


for number, sample in enumerate(sample_cases(SLUG), start=1):
    raw_ratios, raw_values, raw_queries = sample["input"].split("\n")
    ratios, values, queries = json.loads(raw_ratios), json.loads(raw_values), json.loads(raw_queries)
    run = sample_run(wt, number, sample, setup=graph(ratios, values),
                     input=f"ratios = {raw_ratios.strip()}, values = {raw_values.strip()}, "
                           f"queries = {raw_queries.strip()}")
    solve(ratios, values, queries, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
