#!/usr/bin/env python3.12
"""connect-water-bowls's Walkthrough: the reference solution (scripts/replay-solutions/connect-water-bowls.py), Prim's
algorithm on the complete graph of bowls, recording a frame per bowl joining the tree and one per hose it offers a
bowl still outside, on each sample Test Case. The bowls are drawn as the description's graph Diagram draws them, every
pair joined by a hose labelled with its length; `best` is the cost array indexed by bowl, and the total an `output` of
one chip each joining bowl's cost moves into.

    CODEBITE_DB=<database> scripts/walkthroughs/connect-water-bowls.py

writes common/src/main/resources/walkthroughs/connect-water-bowls.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import josa, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move  # noqa: E402

SLUG = "connect-water-bowls"
INF = float("inf")

wt = Walkthrough(
    {"en": "Connect Water Bowls", "ko": "물그릇 연결"},
    {"en": "Prim's algorithm: grow one network from bowl 0. Each step joins the outside bowl with the shortest hose to "
           "the network, then lets that bowl offer shorter hoses to the bowls still outside.",
     "ko": "프림 알고리즘: 물그릇 0에서 연결망 하나를 키웁니다. 매 단계 연결망까지 호스가 가장 짧은 바깥 그릇을 잇고, "
           "새로 이은 그릇이 아직 바깥에 있는 그릇들에 더 짧은 호스를 제안합니다."},
    views=[
        {"id": "bowls", "type": "graph", "directed": False,
         "title": {"en": "bowls and hoses (length)", "ko": "물그릇과 호스 (길이)"}},
        {"id": "best", "type": "array",
         "title": {"en": "best: shortest hose to the network (index: bowl)",
                   "ko": "best: 연결망까지 가장 짧은 호스 (인덱스: 그릇)"}},
        {"id": "total", "type": "output", "title": {"en": "total hose length", "ko": "호스 총 길이"}},
    ],
)


def show(x):
    return "∞" if x == INF else x


def solve(bowls, run):
    """Solution.minHoseLength with a frame per bowl joined and per hose offered. Returns the answer as printed."""
    n = len(bowls)
    best = [INF] * n
    best[0] = 0
    in_tree = [False] * n
    via = [None] * n  # the network bowl whose hose set best[v]: for the drawing only
    total = 0
    hoses = [(a, b) for a in range(n) for b in range(a + 1, n)]

    def hose(a, b):
        return hoses.index((min(a, b), max(a, b)))

    def frame(caption, lit_nodes=(), good_nodes=(), lit_edge=None, good_edge=None, best_marks=None, path=False,
              moves=None, **answer):
        joined = [v for v in range(n) if in_tree[v]]
        tree_edges = [hose(v, via[v]) for v in joined if via[v] is not None]
        edge_marks = {"path": tree_edges}
        if lit_edge is not None:
            edge_marks["lit"] = [lit_edge]
        if good_edge is not None:
            edge_marks["good"] = [good_edge]
        marks = {"path": joined, "lit": list(lit_nodes), "good": list(good_nodes)}
        run.frame(caption,
                  bowls={"nodeMarks": marks, "edgeMarks": edge_marks},
                  best={"values": [show(c) for c in best], "marks": best_marks or {"path": joined}},
                  total={"values": [total], "marks": {"path": [0]} if path else {}},
                  moves=moves, **answer)

    pts = ", ".join(f"{v} at ({x},{y})" for v, (x, y) in enumerate(bowls))
    frame({"en": f"{n} {'bowl' if n == 1 else 'bowls'}: {pts}; a hose's length is |dx| + |dy|. "
                 "best[0] = 0 starts the network at bowl 0, and every other bowl is ∞ away.",
           "ko": f"물그릇 {n}개: " + ", ".join(f"{v}번 ({x},{y})" for v, (x, y) in enumerate(bowls)) +
                 "이고 호스 길이는 |dx| + |dy|입니다. best[0] = 0으로 그릇 0에서 연결망을 시작하고, 나머지는 모두 ∞입니다."},
          best_marks={"lit": [0]})
    for _ in range(n):
        node = min((i for i in range(n) if not in_tree[i]), key=best.__getitem__)
        in_tree[node] = True
        added = best[node]
        total += added
        if via[node] is None:
            how = {"en": f"Bowl {node} has the smallest best, {added}: it starts the network",
                   "ko": f"best가 {josa(added, '(으)로')} 가장 작은 그릇 {node}번이 연결망을 시작합니다"}
        else:
            how = {"en": f"Of the bowls outside, bowl {node} has the smallest best, {added}: it joins by the hose "
                         f"from bowl {via[node]}",
                   "ko": f"바깥 그릇 중 best가 {josa(added, '(으)로')} 가장 작은 그릇 {node}번을 그릇 {via[node]}번에서 오는 호스로 "
                         "잇습니다"}
        frame({"en": f"{how['en']}, and the total grows by {added} to {total}.",
               "ko": f"{how['ko']}. 총 길이는 {added}만큼 늘어 {josa(total, '이가')} 됩니다."},
              good_nodes=[node], best_marks={"path": [v for v in range(n) if in_tree[v] and v != node], "lit": [node]},
              moves=[move(at("best", node), at("total", 0), value=f"+{added}")])
        for i in range(n):
            if in_tree[i]:
                continue
            x, y = bowls[node]
            cost = abs(x - bowls[i][0]) + abs(y - bowls[i][1])
            e = hose(node, i)
            calc = f"|{x} − {bowls[i][0]}| + |{y} − {bowls[i][1]}| = {cost}"
            if cost < best[i]:
                old = best[i]
                best[i] = cost
                via[i] = node
                frame({"en": f"Hose {node}–{i}: {calc}, shorter than best[{i}] = {show(old)}, so best[{i}] becomes {cost}.",
                       "ko": f"호스 {node}–{i}: {calc}. best[{i}] = {show(old)}보다 짧으므로 best[{i}] 값을 "
                             f"{josa(cost, '(으)로')} 바꿉니다."},
                      lit_nodes=[node], good_nodes=[i], good_edge=e,
                      best_marks={"path": [v for v in range(n) if in_tree[v]], "good": [i]},
                      moves=[move(at("bowls", [node, i]), at("best", i), value=cost)])
            else:
                frame({"en": f"Hose {node}–{i}: {calc}, not shorter than best[{i}] = {best[i]} (from bowl {via[i]}), "
                             f"so best[{i}] stays.",
                       "ko": f"호스 {node}–{i}: {calc}. best[{i}] = {best[i]}(그릇 {via[i]}번에서 오는 호스)보다 짧지 "
                             f"않으므로 best[{i}] 값은 그대로입니다."},
                      lit_nodes=[node, i], lit_edge=e,
                      best_marks={"path": [v for v in range(n) if in_tree[v]], "lit": [i]},
                      moves=[move(at("bowls", [node, i]), value=cost)])
    if n == 1:
        frame({"en": "A single bowl needs no hose: answer 0.",
               "ko": "물그릇이 하나뿐이라 호스가 필요 없습니다. 답은 0입니다."}, path=True, answer="0")
        return
    used = " + ".join(str(best[v]) for v in range(1, n))
    frame({"en": f"Every bowl is in the network; the {n - 1} {'hose' if n == 2 else 'hoses'} it used add up to "
                 f"{used} = {total}: answer {total}.",
           "ko": f"모든 그릇이 연결망에 들어왔습니다. 쓴 호스 {n - 1}개의 길이 합은 {used} = {total}, "
                 f"답은 {total}입니다."},
          path=True, answer=str(total))


for number, sample in enumerate(sample_cases(SLUG), start=1):
    bowls = json.loads(sample["input"])
    n = len(bowls)
    setup = {"bowls": {"nodes": [{"id": v, "tag": f"({x},{y})"} for v, (x, y) in enumerate(bowls)],
                       "edges": [{"from": a, "to": b,
                                  "label": abs(bowls[a][0] - bowls[b][0]) + abs(bowls[a][1] - bowls[b][1])}
                                 for a in range(n) for b in range(a + 1, n)]}}
    run = sample_run(wt, number, sample, input=f"bowls = {sample['input']}", setup=setup)
    solve(bowls, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
