#!/usr/bin/env python3.12
"""cheapest-courier-route's Walkthrough: the reference solution
(scripts/replay-solutions/cheapest-courier-route.py), Bellman-Ford limited to maxStops + 1 rounds,
recording one frame per leg relaxed on each sample Test Case: last round's cost goes up onto the
link it travels, and the sum comes down into this round's cost when it beats it.

    CODEBITE_DB=<database> scripts/walkthroughs/cheapest-courier-route.py

writes common/src/main/resources/walkthroughs/cheapest-courier-route.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import driver_list, plural, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move  # noqa: E402

SLUG = "cheapest-courier-route"
INF = float("inf")

wt = Walkthrough(
    {"en": "Cheapest Courier Route", "ko": "가장 싼 배송 경로"},
    {"en": "Bellman-Ford limited to maxStops + 1 rounds: each round reads only last round's costs, "
           "so round r finds the cheapest route of at most r legs.",
     "ko": "maxStops + 1번으로 제한한 벨만-포드: 각 라운드는 지난 라운드의 비용만 읽으므로, "
           "r번째 라운드는 구간 r개 이하로 가는 가장 싼 경로를 찾습니다."},
    views=[
        {"id": "cafes", "type": "graph", "title": {"en": "cafes and links (cost)", "ko": "카페와 링크 (비용)"},
         "directed": True},
        {"id": "last", "type": "array", "title": {"en": "last round (cost, by cafe)", "ko": "지난 라운드 (비용, 카페별)"}},
        {"id": "now", "type": "array", "title": {"en": "this round (cost, by cafe)", "ko": "이번 라운드 (비용, 카페별)"}},
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
    """Solution.cheapestRoute with a frame per leg. Returns the answer as the Driver prints it."""
    rounds = k + 1
    cost = [INF] * n
    cost[src] = 0
    updated = cost[:]
    last_row = cost  # the table's "last round" row: what this round's legs read
    via = [None] * n          # via[v] = (the cafe before v, the round v got this cost in)
    via_history = [via]       # via as it stood after each round, so a route can be walked back
    cost_history = [cost[:]]  # cost after each round, so the last frame shows what the route used

    def frame(caption, rnd, leg=None, improved=False, path=(), used=None, moves=(), **answer):
        shown = [used[v] if used and v in used else updated[v] for v in range(n)]
        node_marks = {"dim": [v for v in range(n) if shown[v] == INF], "path": list(path)}
        edge_marks = {"path": [i for i, (a, b, _) in enumerate(links)
                               if a in path and b in path and path.index(b) == path.index(a) + 1]}
        # on the last frame, the last-round costs the route left each cafe with, and the answer
        last_marks = {"path": [v for v in path if v != dst and used[v] == last_row[v]]} if path else {}
        now_marks = {"path": [dst]} if path else {}
        if leg is not None:
            a, b, _ = links[leg]
            edge_marks["good" if improved else "lit"] = [leg]
            node_marks["lit"] = [a]
            last_marks["lit"] = [a]
            if improved:
                node_marks["good"] = [b]
                now_marks["good"] = [b]
        run.frame(caption,
                  cafes={"values": {str(v): show(shown[v]) for v in range(n)},
                         "nodeMarks": node_marks, "edgeMarks": edge_marks},
                  last={"values": [show(c) for c in last_row], "marks": last_marks},
                  now={"values": [show(c) for c in updated], "marks": now_marks},
                  state={"items": [{"label": {"en": "round", "ko": "라운드"}, "value": f"{rnd} / {rounds}"},
                                   {"label": {"en": "legs allowed", "ko": "허용 구간 수"}, "value": rounds}]},
                  moves=list(moves), **answer)

    frame({"en": f"Before any leg only cafe {src} is reached: cost 0 there, ∞ elsewhere. "
                 f"maxStops = {k} allows {rounds} {plural(rounds, 'leg', 'legs')}, so {rounds} "
                 f"{plural(rounds, 'round', 'rounds')}, {'each adding' if rounds > 1 else 'which adds'} at most one leg.",
           "ko": f"아직 구간을 하나도 쓰지 않았으니 카페 {src}만 비용 0이고 나머지는 ∞입니다. "
                 f"maxStops = {k}일 때 구간을 {rounds}개까지 쓸 수 있으므로, 구간을 하나씩 더하는 라운드를 {rounds}번 돕니다."},
          0)
    for rnd in range(1, rounds + 1):
        last_row = cost
        updated = cost[:]
        new_via = via[:]
        frame({"en": f"Round {rnd}: copy last round's row into this round's. Every leg reads only the last-round "
                     f"row, so a route can grow by one leg this round, never two.",
               "ko": f"{rnd}라운드: 지난 라운드 행을 이번 라운드 행에 복사합니다. 모든 구간은 지난 라운드 행만 읽으므로 "
                     f"이번 라운드에 경로는 구간 하나만 늘어날 수 있고, 두 개는 안 됩니다."},
              rnd, moves=[move(at("now", v), at("last", v)) for v in range(n) if cost[v] != INF])
        for i, (a, b, w) in enumerate(links):
            if cost[a] == INF:
                if updated[a] != INF:
                    caption = {"en": f"Link {a}→{b}: cafe {a} was ∞ last round. Its {updated[a]} is from this round, "
                                     f"and using it would chain two legs in one round, so skip.",
                               "ko": f"링크 {a}→{b}: 카페 {a}의 지난 라운드 비용은 ∞입니다. 지금 보이는 값({updated[a]})은 이번 라운드에 "
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
                       "ko": f"링크 {a}→{b}: {cost[a]} + {w} = {updated[b]}. 기존 값 {show(old)}보다 작으므로 "
                             f"카페 {b}의 비용을 이 값으로 바꿉니다."},
                      rnd, leg=i, improved=True,
                      moves=[move(at("last", a), at("cafes", [a, b])),
                             move(at("cafes", [a, b]), at("now", b), value=updated[b])])
            else:
                frame({"en": f"Link {a}→{b}: {cost[a]} + {w} = {cost[a] + w} doesn't beat {show(updated[b])}, "
                             f"so cafe {b} keeps it.",
                       "ko": f"링크 {a}→{b}: {cost[a]} + {w} = {cost[a] + w}. 기존 값 {show(updated[b])}보다 작지 않으므로 "
                             f"카페 {b}의 비용은 그대로입니다."},
                      rnd, leg=i,
                      moves=[move(at("last", a), at("cafes", [a, b])), move(at("cafes", [a, b]), value=cost[a] + w)])
        cost, via = updated, new_via
        via_history.append(via)
        cost_history.append(cost[:])

    if cost[dst] == INF:
        frame({"en": f"After {rounds} {plural(rounds, 'round', 'rounds')} cafe {dst} is still ∞: no route "
                     f"with at most {k} {plural(k, 'stop', 'stops')}, answer -1.",
               "ko": f"{rounds}라운드가 끝나도 카페 {dst}의 비용은 ∞입니다: 경유지 {k}곳 이하로 가는 경로가 없으므로 답은 -1입니다."},
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
    ko = f"{rounds}라운드 뒤 카페 {dst}의 비용은 {cost[dst]}, 경로는 {arrow(path)}(구간 {legs}개)이므로 답은 {cost[dst]}입니다."
    for v in path:
        if used[v] != cost[v]:
            # the route left v earlier, at the cost a shorter prefix gave it; its final cost needs more legs
            better, _ = walk_back(v, rounds)
            more = len(better) - 1
            en += (f" Cafe {v} shows {used[v]}, its cost when the route left it: its final {cost[v]} takes {more} "
                   f"legs ({arrow(better)}), and the leg on from cafe {v} would make {more + 1}, more than "
                   f"the {rounds} legs maxStops = {k} allows.")
            ko += (f" 카페 {v}에 보이는 값({used[v]})은 경로가 그 카페를 떠날 때의 비용이고, 최종 비용({cost[v]})은 "
                   f"구간 {more}개({arrow(better)})가 필요해 카페 {v}에서 한 구간 더 가면 {more + 1}개로 "
                   f"maxStops = {k}일 때 허용되는 {rounds}개를 넘습니다.")
    cheaper, route = cheapest_any_legs(n, links, src, dst)
    if cheaper < cost[dst] and not any(used[v] != cost[v] for v in path):
        more = len(route) - 1
        en += (f" The cheaper {arrow(route)} ({cheaper}) takes {more} legs, more than the {rounds} "
               f"{plural(rounds, 'leg', 'legs')} maxStops = {k} allows.")
        ko += (f" 더 싼 경로 {arrow(route)}(비용 {cheaper})의 경우 구간 {more}개가 필요해 maxStops = {k}일 때 허용되는 "
               f"{rounds}개를 넘습니다.")
    # a cafe the route left earlier shows the cost it left with: from the last-round row when that holds it
    shows = [move(at("last", v), at("cafes", v)) if used[v] == last_row[v] else move(dst=at("cafes", v), value=show(used[v]))
             for v in path if used[v] != updated[v]]
    frame({"en": en, "ko": ko}, rounds, path=path, used=used, moves=shows, answer=str(cost[dst]))


for number, sample in enumerate(sample_cases(SLUG), start=1):
    # the Driver reads five lines: n, links (JSON), src, dst, maxStops
    lines = sample["input"].split("\n")
    n, links, src, dst, k = int(lines[0]), json.loads(lines[1]), int(lines[2]), int(lines[3]), int(lines[4])
    setup = {"cafes": {"nodes": [{"id": v, **({"tag": {"en": "src", "ko": "출발"}} if v == src else
                                               {"tag": {"en": "dst", "ko": "도착"}} if v == dst else {})}
                                 for v in range(n)],
                       "edges": [{"from": a, "to": b, "label": w} for a, b, w in links]}}
    run = sample_run(wt, number, sample, setup=setup,
                     input=f"n = {n}, links = {driver_list(links)}, "
                           f"src = {src}, dst = {dst}, maxStops = {k}")
    solve(n, links, src, dst, k, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
