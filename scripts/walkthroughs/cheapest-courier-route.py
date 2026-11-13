#!/usr/bin/env python3.12
"""cheapest-courier-route's Walkthrough: the reference solution
(scripts/replay-solutions/cheapest-courier-route.py), Bellman-Ford limited to maxHops + 1 rounds,
recording one frame per leg relaxed on each sample Test Case.

    CODEBITE_DB=<database> scripts/walkthroughs/cheapest-courier-route.py

writes common/src/main/resources/walkthroughs/cheapest-courier-route.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import driver_list, plural, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough  # noqa: E402

SLUG = "cheapest-courier-route"
INF = float("inf")

wt = Walkthrough(
    {"en": "Cheapest Courier Route", "ko": "가장 싼 배송 경로"},
    {"en": "Bellman-Ford limited to maxHops + 1 rounds: each round reads only last round's costs, "
           "so round r finds the cheapest route of at most r legs.",
     "ko": "maxHops + 1번으로 제한한 벨만-포드: 각 라운드는 지난 라운드의 비용만 읽으므로, "
           "r번째 라운드는 구간 r개 이하로 가는 가장 싼 경로를 찾습니다."},
    views=[
        {"id": "cafes", "type": "graph", "title": {"en": "cafes and links (minutes)", "ko": "카페와 링크 (분)"},
         "directed": True},
        {"id": "costs", "type": "table", "title": {"en": "cheapest minutes so far", "ko": "지금까지의 최소 분"}},
        {"id": "state", "type": "vars"},
    ],
)


def show(x):
    return "∞" if x == INF else x


def arrow(route):
    return " → ".join(map(str, route))


def cheapest_any_legs(n, links, src, dst):
    """The cheapest route to dst with no limit on legs (n - 1 rounds) and its cost, for the last
    caption: a cheaper route in the picture that the answer passes over needs saying why."""
    cost, via = [INF] * n, [None] * n
    cost[src] = 0
    for _ in range(n - 1):
        updated, new_via = cost[:], via[:]
        for a, b, w in links:
            if cost[a] + w < updated[b]:
                updated[b], new_via[b] = cost[a] + w, a
        cost, via = updated, new_via
    if cost[dst] == INF:
        return INF, []
    route, v = [dst], dst
    while v != src:
        v = via[v]
        route.append(v)
    return cost[dst], route[::-1]


def solve(n, links, src, dst, k, run):
    """Solution.relayDispatchCost with a frame per leg. Returns the answer as the Driver prints it."""
    rounds = k + 1
    cost = [INF] * n
    cost[src] = 0
    updated = cost[:]
    last_row = cost  # the table's "last round" row: what this round's legs read
    via = [None] * n          # via[v] = (the cafe before v, the round v got this cost in)
    via_history = [via]       # via as it stood after each round, so a route can be walked back
    cost_history = [cost[:]]  # cost after each round, so the last frame shows what the route used

    def frame(caption, rnd, leg=None, improved=False, path=(), used=None, **answer):
        shown = [used[v] if used and v in used else updated[v] for v in range(n)]
        node_marks = {"dim": [v for v in range(n) if shown[v] == INF], "path": list(path)}
        edge_marks = {"path": [i for i, (a, b, _) in enumerate(links)
                               if a in path and b in path and path.index(b) == path.index(a) + 1]}
        # on the last frame, the last-round costs the route left each cafe with, and the answer
        cell_marks = {"path": [[0, v] for v in path if v != dst and used[v] == last_row[v]] + [[1, dst]]
                      if path else []}
        if leg is not None:
            a, b, _ = links[leg]
            edge_marks["good" if improved else "lit"] = [leg]
            node_marks["lit"] = [a]
            cell_marks["lit"] = [[0, a]]
            if improved:
                node_marks["good"] = [b]
                cell_marks["good"] = [[1, b]]
        run.frame(caption,
                  cafes={"values": {str(v): show(shown[v]) for v in range(n)},
                         "nodeMarks": node_marks, "edgeMarks": edge_marks},
                  costs={"columns": [{"en": f"cafe {v}", "ko": f"카페 {v}"} for v in range(n)],
                         "rows": [{"label": {"en": "last round", "ko": "지난 라운드"}, "cells": [show(c) for c in last_row]},
                                  {"label": {"en": "this round", "ko": "이번 라운드"}, "cells": [show(c) for c in updated]}],
                         "marks": cell_marks},
                  state={"items": [{"label": {"en": "round", "ko": "라운드"}, "value": f"{rnd} / {rounds}"},
                                   {"label": {"en": "legs allowed", "ko": "허용 구간 수"}, "value": rounds}]},
                  **answer)

    frame({"en": f"Before any leg only cafe {src} is reached: 0 minutes there, ∞ elsewhere. "
                 f"maxHops = {k} allows {rounds} {plural(rounds, 'leg', 'legs')}, so {rounds} "
                 f"{plural(rounds, 'round', 'rounds')}, {'each adding' if rounds > 1 else 'which adds'} at most one leg.",
           "ko": f"아직 구간을 하나도 쓰지 않았으니 카페 {src}만 0분이고 나머지는 ∞입니다. "
                 f"maxHops = {k}일 때 구간을 {rounds}개까지 쓸 수 있으므로, 구간을 하나씩 더하는 라운드를 {rounds}번 돕니다."},
          0)
    for rnd in range(1, rounds + 1):
        last_row = cost
        updated = cost[:]
        new_via = via[:]
        frame({"en": f"Round {rnd}: copy last round's row into this round's. Every leg reads only the last-round "
                     f"row, so a route can grow by one leg this round, never two.",
               "ko": f"{rnd}라운드: 지난 라운드 행을 이번 라운드 행에 복사합니다. 모든 구간은 지난 라운드 행만 읽으므로 "
                     f"이번 라운드에 경로는 구간 하나만 늘어날 수 있고, 두 개는 안 됩니다."},
              rnd)
        for i, (a, b, w) in enumerate(links):
            if cost[a] == INF:
                if updated[a] != INF:
                    caption = {"en": f"Link {a}→{b}: cafe {a} was ∞ last round. Its {updated[a]} is from this round, "
                                     f"and using it would chain two legs in one round, so skip.",
                               "ko": f"링크 {a}→{b}: 카페 {a}의 지난 라운드 비용은 ∞입니다. 지금 보이는 {updated[a]}분은 이번 라운드에 "
                                     f"생긴 값이라, 쓰면 한 라운드에 구간 두 개를 잇게 되므로 건너뜁니다."}
                else:
                    caption = {"en": f"Link {a}→{b}: cafe {a} wasn't reached last round, so skip.",
                               "ko": f"링크 {a}→{b}: 지난 라운드까지 카페 {a}에 닿지 못했으므로 건너뜁니다."}
                frame(caption, rnd, leg=i)
            elif cost[a] + w < updated[b]:
                old = updated[b]
                updated[b] = cost[a] + w
                new_via[b] = (a, rnd)
                frame({"en": f"Link {a}→{b}: {cost[a]} + {w} = {updated[b]} beats {show(old)}, "
                             f"so cafe {b} costs {updated[b]} now.",
                       "ko": f"링크 {a}→{b}: {cost[a]} + {w} = {updated[b]}분이 기존 {show(old)}보다 짧으므로 "
                             f"카페 {b}의 비용을 {updated[b]}분으로 바꿉니다."},
                      rnd, leg=i, improved=True)
            else:
                frame({"en": f"Link {a}→{b}: {cost[a]} + {w} = {cost[a] + w} doesn't beat {show(updated[b])}, "
                             f"so cafe {b} keeps it.",
                       "ko": f"링크 {a}→{b}: {cost[a]} + {w} = {cost[a] + w}분이 기존 {show(updated[b])}보다 짧지 않으므로 "
                             f"카페 {b}의 비용은 그대로입니다."},
                      rnd, leg=i)
        cost, via = updated, new_via
        via_history.append(via)
        cost_history.append(cost[:])

    if cost[dst] == INF:
        frame({"en": f"After {rounds} {plural(rounds, 'round', 'rounds')} cafe {dst} is still ∞: no route "
                     f"within {k} intermediate {plural(k, 'cafe', 'cafes')}, answer -1.",
               "ko": f"{rounds}라운드가 끝나도 카페 {dst}의 비용은 ∞입니다: 경유 카페 {k}개 이하로 가는 경로가 없으므로 답은 -1입니다."},
              rounds, answer="-1")
        return

    def walk_back(v, after_round):
        """The route behind v's cost after round `after_round`, and the cost each earlier cafe on it had
        when the route left it: a cafe reached in round r was left with its cost after round r - 1."""
        route, used, back = [v], {}, via_history[after_round]
        while v != src:
            prev, set_in = back[v]
            used[prev] = cost_history[set_in - 1][prev]
            back = via_history[set_in - 1]
            v = prev
            route.append(v)
        return route[::-1], used

    path, used = walk_back(dst, rounds)
    used[dst] = cost[dst]
    legs = len(path) - 1
    en = (f"After {rounds} {plural(rounds, 'round', 'rounds')} cafe {dst} costs {cost[dst]}, by {arrow(path)} "
          f"({legs} {plural(legs, 'leg', 'legs')}): answer {cost[dst]}.")
    ko = f"{rounds}라운드 뒤 카페 {dst}의 비용은 {cost[dst]}분, 경로는 {arrow(path)}(구간 {legs}개)이므로 답은 {cost[dst]}입니다."
    for v in path:
        if used[v] != cost[v]:
            # the route left v earlier, at the cost a shorter prefix gave it; its final cost needs more legs
            better, _ = walk_back(v, rounds)
            more = len(better) - 1
            en += (f" Cafe {v} shows {used[v]}, its cost when the route left it: its final {cost[v]} takes {more} "
                   f"legs ({arrow(better)}), and the leg on from cafe {v} would make {more + 1}, more than "
                   f"the {rounds} legs maxHops = {k} allows.")
            ko += (f" 카페 {v}의 {used[v]}분은 경로가 그 카페를 떠날 때의 비용이고, 최종 {cost[v]}분은 "
                   f"구간 {more}개({arrow(better)})가 필요해 카페 {v}에서 한 구간 더 가면 {more + 1}개로 "
                   f"maxHops = {k}일 때 허용되는 {rounds}개를 넘습니다.")
    cheaper, route = cheapest_any_legs(n, links, src, dst)
    if cheaper < cost[dst] and not any(used[v] != cost[v] for v in path):
        more = len(route) - 1
        en += (f" The cheaper {arrow(route)} ({cheaper}) takes {more} legs, more than the {rounds} "
               f"{plural(rounds, 'leg', 'legs')} maxHops = {k} allows.")
        ko += (f" 더 싼 {arrow(route)}({cheaper}분)은 구간 {more}개가 필요해 maxHops = {k}일 때 허용되는 "
               f"{rounds}개를 넘습니다.")
    frame({"en": en, "ko": ko}, rounds, path=path, used=used, answer=str(cost[dst]))


for number, sample in enumerate(sample_cases(SLUG), start=1):
    # the Driver reads five lines: n, links (JSON), src, dst, maxHops
    lines = sample["input"].split("\n")
    n, links, src, dst, k = int(lines[0]), json.loads(lines[1]), int(lines[2]), int(lines[3]), int(lines[4])
    setup = {"cafes": {"nodes": [{"id": v, **({"tag": {"en": "src", "ko": "출발"}} if v == src else
                                               {"tag": {"en": "dst", "ko": "도착"}} if v == dst else {})}
                                 for v in range(n)],
                       "edges": [{"from": a, "to": b, "label": w} for a, b, w in links]}}
    run = sample_run(wt, number, sample, setup=setup,
                     input=f"n = {n}, links = {driver_list(links)}, "
                           f"src = {src}, dst = {dst}, maxHops = {k}")
    solve(n, links, src, dst, k, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
