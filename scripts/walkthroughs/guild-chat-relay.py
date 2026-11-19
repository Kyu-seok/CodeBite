#!/usr/bin/env python3.12
"""guild-chat-relay's Walkthrough: the reference solution (scripts/replay-solutions/guild-chat-relay.py), Dijkstra with
a min-heap of (minute, player) entries, recording a frame per pop and one for the relays each new player pushes, on
each sample Test Case. The heap is drawn as the tree of heapq's own list: a pop is one frame with the root lit, and
the pushes that follow are one frame showing the heap as heapq leaves it, each new entry moving in from its relay
(heapq's sifts are not drawn one by one; the heap is not the lesson here, the order it pops in is).

    CODEBITE_DB=<database> scripts/walkthroughs/guild-chat-relay.py

writes common/src/main/resources/walkthroughs/guild-chat-relay.json.
"""
import heapq
import json
import os
import sys
from collections import defaultdict

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import driver_list, josa, node_order, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, level_order_tree, move  # noqa: E402

SLUG = "guild-chat-relay"

wt = Walkthrough(
    {"en": "Guild Chat Relay", "ko": "길드 공지 전파 시간"},
    {"en": "Dijkstra: a min-heap hands out (minute, player) entries soonest first, so the first entry popped for a "
           "player is the minute the message really reaches them; later entries for that player are stale.",
     "ko": "다익스트라: 최소 힙이 (분, 플레이어) 항목을 가장 이른 것부터 꺼내므로, 어떤 플레이어의 항목이 처음 꺼내지는 "
           "시각이 그 플레이어가 실제로 메시지를 받는 시각입니다. 그 뒤에 나오는 같은 플레이어의 항목은 지난 것입니다."},
    views=[
        {"id": "players", "type": "graph", "directed": True,
         "title": {"en": "relays (minutes); under a player: minute reached",
                   "ko": "중계 (분); 플레이어 아래: 받은 시각"}},
        {"id": "heap", "type": "tree", "arity": 2,
         "title": {"en": "min-heap (minute, player): soonest on top", "ko": "최소 힙 (분, 플레이어): 가장 이른 것이 맨 위"},
         "empty": {"en": "empty", "ko": "비어 있음"}},
    ],
)


def solve(links, n, src, run):
    """Solution.minutesToReachAll with a frame per pop and per batch of pushes. Returns the answer as printed."""
    graph = defaultdict(list)
    for source, target, minutes in links:
        graph[source].append((target, minutes))
    arrival = {}
    via = {}  # player -> the player whose relay brought the entry that was popped first: for the last frame only
    heap = [[0, src, 0]]  # heapq orders these by (minute, player); the third, who pushed it (0: none), only breaks a tie
    # between equal entries, which are interchangeable

    def edge(a, b):
        return next(k for k, (s, t, _) in enumerate(links) if (s, t) == (a, b))

    drawn = []  # the heap list as the last frame drew it

    def resorted(fresh=()):
        """A move for each entry heapq put somewhere new since the last frame: from the node it was at, or, when that
        node is gone (the last entry lifted to the root after a pop), into its node with its text. `fresh` entries
        are moved in by the caller, from their relays."""
        out = []
        for j, e in enumerate(heap):
            if (j < len(drawn) and drawn[j] is e) or any(e is f for f in fresh):
                continue
            i = next((k for k, d in enumerate(drawn) if d is e), None)
            text = f"({e[0]}, {e[1]})"
            out.append(move(at("heap", i), at("heap", j), value=text) if i is not None and i < len(heap)
                       else move(dst=at("heap", j), value=text))
        return out

    def frame(caption, heap_marks=None, lit=(), good=(), lit_edges=(), good_edges=(), end=None, moves=None, **answer):
        node_marks, edge_marks = {"lit": list(lit), "good": list(good)}, {"lit": [edge(*e) for e in lit_edges],
                                                                         "good": [edge(*e) for e in good_edges]}
        if end is not None:
            node_marks.update(end[0])
            edge_marks.update(end[1])
        run.frame(caption,
                  players={"values": {str(p): t for p, t in arrival.items()}, "nodeMarks": node_marks,
                           "edgeMarks": edge_marks},
                  heap={**level_order_tree([f"({t}, {p})" for t, p, _ in heap]),
                        "nodeMarks": heap_marks or {}},
                  moves=moves, **answer)
        drawn[:] = heap

    def settle():
        """After a pop that pushes nothing: heappop lifted the last entry to the root and sifted it down."""
        if heap:
            frame({"en": "heappop moved the last entry up to the root and sifted it down: the soonest entry is on top "
                         "again.",
                   "ko": "heappop이 마지막 항목을 루트로 올린 뒤 아래로 내려 보냈습니다. 다시 가장 이른 항목이 맨 위에 "
                         "있습니다."},
                  heap_marks={"good": [m["to"]["at"] for m in resorted()]}, moves=resorted())

    frame({"en": f"Player {src} has the message at minute 0: the heap starts with the one entry (0, {src}).",
           "ko": f"플레이어 {josa(src, '은는')} 0분에 메시지를 가지고 있습니다. 힙은 항목 (0, {src}) 하나로 시작합니다."})
    while heap:
        entry = heap[0]
        time, player, sender = entry
        if player in arrival:
            frame({"en": f"Pop ({time}, {player}): player {player} already got the message at minute "
                         f"{arrival[player]}, so this later entry is stale and is skipped.",
                   "ko": f"({time}, {player}) 항목을 꺼냅니다. 플레이어 {josa(player, '은는')} 이미 {arrival[player]}분에 받았으므로 "
                         "이 늦은 항목은 지난 것이라 건너뜁니다."},
                  heap_marks={"bad": [0]}, lit=[player], moves=[move(at("heap", 0))])
            heapq.heappop(heap)
            settle()
            continue
        arrival[player] = time
        if sender:
            via[player] = sender
        frame({"en": f"Pop ({time}, {player}), the soonest entry: player {player} first gets the message at minute "
                     f"{time}. No later entry can beat it, since every relay adds minutes.",
               "ko": f"가장 이른 ({time}, {player}) 항목을 꺼내니 플레이어 {josa(player, '은는')} {time}분에 처음 메시지를 "
                     "받습니다. 중계는 시간을 더하기만 하므로 더 이른 항목은 나올 수 없습니다."},
              heap_marks={"lit": [0]}, good=[player], good_edges=[(sender, player)] if sender else (),
              moves=[move(at("heap", 0), at("players", player), value=str(time))])
        heapq.heappop(heap)
        pushed = []
        skipped = []
        for target, minutes in graph[player]:
            if target not in arrival:
                e = [time + minutes, target, player]
                heapq.heappush(heap, e)
                pushed.append((e, minutes))
            else:
                skipped.append(target)
        if not pushed:
            if graph[player]:
                frame({"en": f"Player {player}'s relays all lead to players who already have the message, so "
                             "nothing is pushed.",
                       "ko": f"플레이어 {player}번의 중계는 모두 이미 메시지를 받은 플레이어에게 가므로 아무것도 "
                             "넣지 않습니다."},
                      lit=[player] + skipped, lit_edges=[(player, t) for t in skipped],
                      heap_marks={"good": [m["to"]["at"] for m in resorted()]}, moves=resorted())
            else:
                settle()
            continue
        parts_en = ", ".join(f"({e[0]}, {e[1]}) as {time} + {m} = {e[0]}" for e, m in pushed)
        parts_ko = ", ".join(f"플레이어 {e[1]}에게 {time} + {m} = {e[0]}분" for e, m in pushed)
        skip_en = (f"; {', '.join(map(str, skipped))} already {'has' if len(skipped) == 1 else 'have'} it"
                   if skipped else "")
        skip_ko = f" {', '.join(map(str, skipped))}번 플레이어는 이미 받았습니다." if skipped else ""
        idx = [next(k for k, h in enumerate(heap) if h is e) for e, _ in pushed]
        frame({"en": f"Player {player} relays on at once: push {parts_en}{skip_en}. heapq re-sorts so the soonest entry "
                     "is on top.",
               "ko": f"플레이어 {josa(player, '이가')} 바로 중계합니다: {parts_ko} 항목을 힙에 넣습니다.{skip_ko} heapq가 가장 이른 "
                     "항목을 맨 위에 둡니다."},
              heap_marks={"good": idx}, lit=[player], lit_edges=[(player, e[1]) for e, _ in pushed],
              moves=[m for (e, _), k in zip(pushed, idx) for m in
                     (move(at("players", player), at("players", [player, e[1]]), value=str(time)),
                      move(at("players", [player, e[1]]), at("heap", k), value=f"({e[0]}, {e[1]})"))] +
              resorted(fresh=[e for e, _ in pushed]))
    if len(arrival) == n:
        last = max(arrival, key=lambda p: (arrival[p], p))
        route = [last]
        while route[-1] in via:
            route.append(via[route[-1]])
        route.reverse()
        arrow = " → ".join(map(str, route))
        frame({"en": f"The heap is empty and all {n} players have the message. The last is player {last} at minute "
                     f"{arrival[last]}, by {arrow}: answer {arrival[last]}.",
               "ko": f"힙이 비었고 플레이어 {n}명이 모두 메시지를 받았습니다. 가장 늦게 받는 것은 {last}번 플레이어로 "
                     f"{arrival[last]}분, 경로는 {arrow}이고 답은 {arrival[last]}입니다."},
              end=({"path": route}, {"path": [edge(a, b) for a, b in zip(route, route[1:])]}),
              answer=str(arrival[last]))
    else:
        missing = [p for p in range(1, n + 1) if p not in arrival]
        frame({"en": f"The heap is empty, but only {len(arrival)} of {n} players got the message: "
                     f"{', '.join(map(str, missing))} never {'does' if len(missing) == 1 else 'do'}. Answer -1.",
               "ko": f"힙이 비었지만 플레이어 {n}명 중 {len(arrival)}명만 받았습니다. 플레이어 "
                     f"{', '.join(map(str, missing))}번은 끝내 받지 못하므로 답은 -1입니다."},
              end=({"bad": missing}, {}), answer="-1")


for number, sample in enumerate(sample_cases(SLUG), start=1):
    lines = sample["input"].split("\n")
    links, n, src = json.loads(lines[0]), int(lines[1]), int(lines[2])
    setup = {"players": {"nodes": [{"id": p, **({"tag": {"en": "src", "ko": "출발"}} if p == src else {})}
                                   for p in node_order(links, range(1, n + 1))],
                         "edges": [{"from": a, "to": b, "label": m} for a, b, m in links]}}
    run = sample_run(wt, number, sample, setup=setup,
                     input=f"links = {driver_list(links)}, n = {n}, src = {src}")
    solve(links, n, src, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
