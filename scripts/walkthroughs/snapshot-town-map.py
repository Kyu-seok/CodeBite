#!/usr/bin/env python3.12
"""snapshot-town-map's Walkthrough: the reference solution (scripts/replay-solutions/snapshot-town-map.py), a
depth-first copy with a stack of originals and a map from each original to its copy, on each sample Test Case. The
map is drawn as the description's graph Diagram draws it; the copy beside it has every spot's place from the start,
faded until its copy is made, and gains one arrow per neighbor appended, so each undirected edge ends as two arrows.

    CODEBITE_DB=<database> scripts/walkthroughs/snapshot-town-map.py

writes common/src/main/resources/walkthroughs/snapshot-town-map.json.
"""
import json
import os
import sys
from collections import deque

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import driver_list, josa, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move  # noqa: E402

SLUG = "snapshot-town-map"

wt = Walkthrough(
    {"en": "Snapshot the Town Map", "ko": "맵 스냅샷 뜨기"},
    {"en": "Keep a map from each spot to its copy: a neighbor with no copy yet gets one and goes on the stack to be "
           "visited, and one that has a copy is only linked, so every spot is copied exactly once.",
     "ko": "장소마다 복사본을 기록해 둡니다. 복사본이 아직 없는 이웃은 새로 만들어 스택에 넣어 나중에 방문하고, "
           "이미 있는 이웃은 잇기만 하므로 모든 장소가 정확히 한 번 복사됩니다."},
    views=[
        {"id": "town", "type": "graph", "directed": False, "title": {"en": "original map", "ko": "원본 지도"}},
        {"id": "stack", "type": "stack", "title": {"en": "stack: spots to visit", "ko": "스택: 방문할 장소"},
         "empty": {"en": "empty", "ko": "비어 있음"}},
        {"id": "copy", "type": "graph", "directed": True,
         "title": {"en": "copy (faded: not made yet; arrow: in neighbors)",
                   "ko": "복사본 (흐림: 아직 없음, 화살표: neighbors에 있음)"}},
    ],
)


class Node:
    def __init__(self, val=0, neighbors=None):
        self.val = val
        self.neighbors = neighbors if neighbors is not None else []


def build_graph(adj):
    """The map as the Driver builds it: spot i + 1's neighbors in adjList order; returns the spot with val 1."""
    nodes = [None] + [Node(i + 1) for i in range(len(adj))]
    for i, neighbors in enumerate(adj):
        for nbr in neighbors:
            nodes[i + 1].neighbors.append(nodes[nbr])
    return nodes[1]


def to_adj_list(node):
    """The copy as the Driver writes it: every spot reached from node, by val, each with its neighbors' vals."""
    if not node:
        return []
    visited = {node.val: node}
    queue = deque([node])
    while queue:
        curr = queue.popleft()
        for nbr in curr.neighbors:
            if nbr.val not in visited:
                visited[nbr.val] = nbr
                queue.append(nbr)
    return [[nbr.val for nbr in visited[v].neighbors] for v in sorted(visited)]


def undirected_edges(adj):
    """Each edge once, smaller spot first, in the order adjList names it: the description's Diagram edges."""
    edges = []
    for i, neighbors in enumerate(adj):
        for nbr in neighbors:
            if i + 1 < nbr:
                edges.append((i + 1, nbr))
    return edges


def node_order(adj, edges):
    order = []
    for a, b in edges:
        for v in (a, b):
            if v not in order:
                order.append(v)
    return order + [v for v in range(1, len(adj) + 1) if v not in order]


def solve(adj, run):
    """Solution.cloneMap with a frame per step."""
    edges = undirected_edges(adj)
    node = build_graph(adj)
    copies = {}
    arrows = []     # the copy's links as (from val, to val), in the order appended
    todo = []       # the stack of originals, bottom first
    leaving = []    # the original popped this frame, still drawn on top

    def frame(caption, lit=(), good=(), path=False, edge_lit=None, arrow_good=False, stack_marks=None, moves=None,
              **answer):
        made = {o.val for o in copies}
        copy_marks = {"dim": [v for v in range(1, len(adj) + 1) if v not in made]}
        arrow_marks = {}
        if path:
            copy_marks["path"] = sorted(made)
            arrow_marks["path"] = list(range(len(arrows)))
        else:
            copy_marks["good"] = list(good)
        if arrow_good:
            arrow_marks["good"] = [len(arrows) - 1]
        run.frame(caption,
                  town={"nodeMarks": {"lit": list(lit)},
                        "edgeMarks": {"lit": [] if edge_lit is None else [edge_lit]}},
                  stack={"values": [o.val for o in todo + leaving], "marks": stack_marks or {}},
                  copy={"edges": [{"from": a, "to": b} for a, b in arrows], "nodeMarks": copy_marks,
                        "edgeMarks": arrow_marks},
                  moves=moves, **answer)

    def edge_index(a, b):
        return edges.index((min(a, b), max(a, b)))

    n = len(adj)
    frame({"en": f"{n} spots; node is spot 1. Copy it first and put it on the stack of spots to visit.",
           "ko": f"장소가 {n}개이고 node는 장소 1입니다. 먼저 이 장소를 복사하고 방문할 스택에 넣습니다."})
    copies[node] = Node(node.val)
    todo.append(node)
    frame({"en": "copies[1] = a new spot 1, with no neighbors yet; push spot 1.",
           "ko": "copies[1]에 이웃이 아직 없는 새 장소 1을 만들고, 장소 1을 스택에 넣습니다."},
          lit=[1], good=[1], stack_marks={"good": [0]},
          moves=[move(at("town", 1), at("copy", 1)), move(at("town", 1), at("stack", 0))])
    while todo:
        original = todo.pop()
        leaving[:] = [original]
        top = len(todo)
        v = original.val
        names = ", ".join(str(nb.val) for nb in original.neighbors)
        frame({"en": f"Pop spot {v}: link its copy to the copies of its neighbors {names}, in order.",
               "ko": f"장소 {josa(v, '을를')} 꺼냅니다. 그 복사본을 이웃 {names}의 복사본과 차례로 잇습니다."},
              lit=[v], stack_marks={"lit": [top]}, moves=[move(at("stack", top), at("town", v))])
        leaving.clear()
        for neighbor in original.neighbors:
            w = neighbor.val
            if neighbor not in copies:
                copies[neighbor] = Node(neighbor.val)
                todo.append(neighbor)
                frame({"en": f"Spot {w} has no copy yet: make one, and push spot {w} to visit it later.",
                       "ko": f"장소 {josa(w, '은는')} 아직 복사본이 없으므로 새로 만들고, 나중에 방문하도록 스택에 넣습니다."},
                      lit=[v, w], good=[w], edge_lit=edge_index(v, w), stack_marks={"good": [len(todo) - 1]},
                      moves=[move(at("town", w), at("copy", w)), move(at("town", w), at("stack", len(todo) - 1))])
                had = {"en": "", "ko": ""}
            else:
                had = {"en": f"Spot {w} already has a copy, so it is only linked: ",
                       "ko": f"장소 {josa(w, '은는')} 이미 복사본이 있어 잇기만 합니다. "}
            copies[original].neighbors.append(copies[neighbor])
            arrows.append((v, w))
            frame({"en": f"{had['en']}copy {v}'s neighbors gets copy {w}.",
                   "ko": f"{had['ko']}복사본 {v}의 neighbors에 복사본 {josa(w, '이가')} 들어갑니다."},
                  lit=[v, w], edge_lit=edge_index(v, w), arrow_good=True,
                  moves=[move(at("town", [v, w]), at("copy", w))])
    result = to_adj_list(copies[node])
    m = len(arrows)
    frame({"en": f"The stack is empty: all {n} spots are copied, with {m} neighbor links, two for each road. "
                 f"Written as an adjacency list: {driver_list(result)}.",
           "ko": f"스택이 비었습니다. 장소 {n}개가 모두 복사되었고 이웃 연결은 도로마다 두 개씩 {m}개입니다. "
                 f"인접 리스트로 적으면 {driver_list(result)}입니다."},
          path=True, answer=driver_list(result))


for number, sample in enumerate(sample_cases(SLUG), start=1):
    adj = json.loads(sample["input"])
    if not adj:
        run = sample_run(wt, number, sample, input=f"adjList = {sample['input']}")
        run.frame({"en": "The map is empty, so node is null and there is nothing to copy: return null, written [].",
                   "ko": "지도가 비어 있으므로 node는 null이고 복사할 것이 없습니다. null을 반환하며 []로 적힙니다."},
                  stack={"values": []}, answer="[]")
        continue
    edges = undirected_edges(adj)
    nodes = [{"id": v} for v in node_order(adj, edges)]
    run = sample_run(wt, number, sample, input=f"adjList = {sample['input']}",
                     setup={"town": {"nodes": nodes, "edges": [{"from": a, "to": b} for a, b in edges]},
                            "copy": {"nodes": nodes}})
    solve(adj, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
