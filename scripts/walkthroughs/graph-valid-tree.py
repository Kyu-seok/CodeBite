#!/usr/bin/env python3.12
"""graph-valid-tree's Walkthrough: the reference solution (scripts/replay-solutions/graph-valid-tree.py), on each
sample Test Case: first the edge count against n - 1, then union-find over the edges in order, a frame for each
edge's two finds and one for each union. The graph is drawn as the description's graph Diagram draws it, each node
tagged with the root of its group, and the parent array is the forest. No sample reaches the cycle check (the one with
a cycle has too many edges), so an extra run has n - 1 edges and a cycle.

    CODEBITE_DB=<database> scripts/walkthroughs/graph-valid-tree.py

writes common/src/main/resources/walkthroughs/graph-valid-tree.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import driver_list, josa, node_order, plural, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move  # noqa: E402

SLUG = "graph-valid-tree"

wt = Walkthrough(
    {"en": "Graph Valid Tree", "ko": "유효한 트리 판별"},
    {"en": "A tree on n nodes has exactly n - 1 edges. With that many, it is a tree unless an edge joins two nodes "
           "already connected (a cycle), which union-find sees as both ends sharing a root.",
     "ko": "노드 n개짜리 트리는 간선이 정확히 n - 1개입니다. 간선 수가 맞으면, 이미 이어진 두 노드를 잇는 간선(사이클)이 "
           "없는 한 트리이며, 유니온 파인드에서는 두 끝의 루트가 같은 것으로 보입니다."},
    views=[
        {"id": "graph", "type": "graph", "directed": False,
         "title": {"en": "edges (tag: root of the group)", "ko": "간선 (태그: 그룹의 루트)"}},
        {"id": "parent", "type": "array", "title": {"en": "parent (index: node)", "ko": "parent (인덱스: 노드)"}},
    ],
)


def solve(n, edges, run):
    """Solution.validTree with a frame per step. Returns the answer as the Driver prints it."""
    parent = list(range(n))
    m = len(edges)

    def root_of(x):
        """The root of x's group, without the halving find does: for the graph's tags only."""
        while parent[x] != x:
            x = parent[x]
        return x

    def find(x, writes, visited):
        """The reference's find, recording each node it stands on and each parent it rewrites."""
        visited.append(x)
        while parent[x] != x:
            jumped = parent[parent[x]]
            if jumped != parent[x]:
                writes.append((parent[x], x, jumped))  # (read from, written cell, new value)
            parent[x] = jumped
            x = parent[x]
            visited.append(x)
        return x

    def frame(caption, edge=None, done=0, edge_marks=None, node_marks=None, lit_cells=(), good_cells=(),
              pointers=None, moves=None, **answer):
        em = edge_marks if edge_marks is not None else {"dim": list(range(done + (1 if edge is not None else 0), m))}
        nm = node_marks or {}
        if edge is not None and edge_marks is None:
            em["lit"] = [edge]
            nm = {"lit": list(edges[edge])}
        run.frame(caption,
                  graph={"nodes": [{"id": v, "tag": {"en": f"root {root_of(v)}", "ko": f"루트 {root_of(v)}"}}
                                   for v in node_order(edges, range(n))],
                         "edgeMarks": em, "nodeMarks": nm},
                  parent={"values": list(parent), "pointers": pointers or {},
                          "marks": {"lit": list(lit_cells), "good": list(good_cells)}},
                  moves=moves, **answer)

    if m != n - 1:
        more = m > n - 1
        frame({"en": f"{n} nodes but {m} {plural(m, 'edge', 'edges')}, and a tree on {n} nodes has exactly {n - 1}. "
                     + ("So many edges must close a cycle: false." if more
                        else "So few edges can't connect every node: false."),
               "ko": f"노드는 {n}개인데 간선이 {m}개이고, 노드 {n}개짜리 트리의 간선은 정확히 {n - 1}개입니다. "
                     + ("간선이 이만큼 많으면 사이클이 생기므로 false입니다." if more
                        else "간선이 이만큼 적으면 모든 노드를 이을 수 없으므로 false입니다.")},
              edge_marks={"bad": list(range(m))}, answer="false")
        return
    frame({"en": f"{n} nodes and {m} {plural(m, 'edge', 'edges')}, exactly n - 1: the count fits a tree. Each node "
                 f"starts as its own group (parent[v] = v); now join the groups edge by edge.",
           "ko": f"노드 {n}개에 간선 {m}개로 정확히 n - 1개이니 개수는 트리와 맞습니다. 노드마다 자기 그룹으로 "
                 f"시작하며(parent[v] = v), 이제 간선마다 그룹을 합칩니다."},
          edge_marks={"lit": list(range(m))})
    for k, (u, v) in enumerate(edges):
        writes_u, seen_u, writes_v, seen_v = [], [], [], []
        ru = find(u, writes_u, seen_u)
        rv = find(v, writes_v, seen_v)
        writes = writes_u + writes_v

        def climb(x, seen):
            if len(seen) == 1:
                return {"en": f"{x} is a root", "ko": f"{x}번은 루트"}
            return {"en": f"find({x}) climbs {' → '.join(map(str, seen))}",
                    "ko": f"{x}번에서 {''.join(f'{w} → ' for w in seen[:-1])}{josa(seen[-1], '(으)로')} 올라감"}
        cu, cv = climb(u, seen_u), climb(v, seen_v)
        halved = halved_ko = ""
        if writes:
            halved = "; on the way, " + ", ".join(f"parent[{x}] jumps to {w}" for _, x, w in writes)
            halved_ko = " (올라가는 길에 건너뜀: " + ", ".join(f"parent[{x}] = {w}" for _, x, w in writes) + ")"
        halving = [move(at("parent", src), at("parent", x), value=str(w)) for src, x, w in writes] or None
        if ru == rv:
            frame({"en": f"Edge [{u},{v}]: {cu['en']}, {cv['en']}{halved}. Both roots are {ru}: {u} and {v} are "
                         f"already connected, so this edge closes a cycle: false.",
                   "ko": f"간선 [{u},{v}]: {cu['ko']}, {cv['ko']}{halved_ko}. 두 루트가 모두 {ru}번이라 {u}번과 "
                         f"{v}번은 이미 이어져 있으므로 이 간선이 사이클을 닫습니다: false."},
                  edge_marks={"dim": list(range(k + 1, m)), "bad": [k]}, node_marks={"bad": [u, v]},
                  lit_cells=sorted(set(seen_u + seen_v)), good_cells=[x for _, x, _ in writes],
                  pointers={"root": ru}, moves=halving, answer="false")
            return
        frame({"en": f"Edge [{u},{v}]: {cu['en']}, {cv['en']}{halved}. Roots {ru} and {rv} differ: two groups.",
               "ko": f"간선 [{u},{v}]: {cu['ko']}, {cv['ko']}{halved_ko}. 루트 {josa(ru, '과와')} {josa(rv, '이가')} "
                     f"달라 서로 다른 두 그룹입니다."},
              edge=k, done=k, lit_cells=sorted(set(seen_u + seen_v)), good_cells=[x for _, x, _ in writes],
              pointers={"root a": ru, "root b": rv}, moves=halving)
        parent[ru] = rv
        frame({"en": f"parent[{ru}] = {rv}: group {ru} joins group {rv}.",
               "ko": f"parent[{ru}] = {rv}: {ru}번 그룹이 {rv}번 그룹에 합쳐집니다."},
              edge=k, done=k, good_cells=[ru], moves=[move(at("parent", rv), at("parent", ru))])
    root = root_of(0)
    frame({"en": f"All {m} edges joined two different groups, so no cycle: every node now has root {root}, one "
                 f"connected group. It is a tree: true.",
           "ko": f"간선 {m}개가 모두 서로 다른 두 그룹을 합쳐 사이클이 없고, 모든 노드의 루트가 {root}번인 한 그룹입니다. "
                 f"트리이므로 true입니다."},
          edge_marks={"path": list(range(m))}, node_marks={"path": list(range(n))}, answer="true")


for number, sample in enumerate(sample_cases(SLUG), start=1):
    lines = sample["input"].split("\n")
    n, edges = int(lines[0]), json.loads(lines[1])
    setup = {"graph": {"edges": [{"from": x, "to": y} for x, y in edges]}}
    run = sample_run(wt, number, sample, input=f"n = {n}, edges = {lines[1].strip()}", setup=setup)
    solve(n, edges, run)
n, edges = 4, [[0, 1], [1, 2], [2, 0]]
run = wt.run({"en": "Extra: n - 1 edges, with a cycle", "ko": "추가: 간선 n - 1개, 사이클 있음"},
             input=f"n = {n}, edges = {driver_list(edges)}", expected="false", extra=True,
             setup={"graph": {"edges": [{"from": x, "to": y} for x, y in edges]}})
solve(n, edges, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
