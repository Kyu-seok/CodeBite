#!/usr/bin/env python3.12
"""open-all-rooms' Walkthrough: the reference solution (scripts/replay-solutions/open-all-rooms.py), a search with a
stack from room 0 that takes every key in each room it enters, on each sample Test Case. The rooms are drawn as the
description's graph Diagram draws them (an arrow from a room to each room its keys open, nodes in the order the
arrows name them), with the visited set and the stack beside them: a frame per room popped that finds new keys (and
one for pushing their rooms), and one for each run of pops that find none.

    CODEBITE_DB=<database> scripts/walkthroughs/open-all-rooms.py

writes common/src/main/resources/walkthroughs/open-all-rooms.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import josa, plural, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move  # noqa: E402

SLUG = "open-all-rooms"

wt = Walkthrough(
    {"en": "Open All Rooms", "ko": "모든 방 열 수 있는지"},
    {"en": "Search from room 0 with a stack: entering a room takes its keys, and each key to a room not visited yet "
           "marks that room visited and pushes it. Every room is visited exactly when every room can be opened.",
     "ko": "방 0에서 스택으로 찾습니다. 방에 들어가면 열쇠를 모두 얻고, 아직 방문하지 않은 방의 열쇠마다 그 방을 방문한 것으로 "
           "표시해 스택에 넣습니다. 모든 방이 방문되면 모든 방을 열 수 있습니다."},
    views=[
        {"id": "rooms", "type": "graph", "directed": True,
         "title": {"en": "rooms (arrow: a key inside opens that room)", "ko": "방 (화살표: 안의 열쇠로 그 방을 엶)"}},
        {"id": "visited", "type": "set", "title": {"en": "visited", "ko": "visited (방문한 방)"},
         "hit": {"en": "visited", "ko": "방문함"}, "miss": {"en": "new", "ko": "새 방"}},
        {"id": "stack", "type": "stack", "title": {"en": "stack: rooms to enter", "ko": "스택: 들어갈 방"},
         "empty": {"en": "empty", "ko": "비어 있음"}},
    ],
)


def graph(rooms):
    """The rooms as the description's graph Diagram draws them: an edge per key, nodes in the order the edges name
    them, then the rest."""
    edges = [(i, k) for i, keys in enumerate(rooms) for k in keys]
    order = []
    for a, b in edges:
        for v in (a, b):
            if v not in order:
                order.append(v)
    order += [v for v in range(len(rooms)) if v not in order]
    return edges, {"rooms": {"nodes": [{"id": v} for v in order],
                             "edges": [{"from": a, "to": b} for a, b in edges]}}


def keys_text(keys):
    return ", ".join(str(k) for k in keys)


def keys_josa(keys, particle):
    """The numbers listed, the Korean particle after the last: "2, 1을"."""
    return ", ".join([str(k) for k in keys[:-1]] + [josa(keys[-1], particle)])


def solve(rooms, run):
    """Solution.checkKeyReachability with a frame per step. Returns nothing; the last frame carries the answer."""
    n = len(rooms)
    edges, _ = graph(rooms)
    edge_index = {e: i for i, e in enumerate(edges)}
    visited = [0]   # the set, in the order rooms went in
    todo = [0]      # the stack, bottom first
    leaving = []    # the rooms popped this frame, still drawn on top, first popped on top

    def frame(caption, lit=(), good=(), bad=(), path=(), edge_lit=(), probes=(), set_marks=None, stack_marks=None,
              moves=None, **answer):
        run.frame(caption,
                  rooms={"nodeMarks": {"dim": [v for v in range(n) if v not in visited] if not (path or bad) else [],
                                       "path": list(path), "bad": list(bad), "good": list(good), "lit": list(lit)},
                         "edgeMarks": {"lit": [edge_index[e] for e in edge_lit]}},
                  visited={"members": list(visited), "probes": list(probes), "marks": set_marks or {}},
                  stack={"values": todo + leaving[::-1], "marks": stack_marks or {}},
                  moves=moves, **answer)

    frame({"en": f"{n} {plural(n, 'room', 'rooms')}, and only room 0 is open: it starts visited and on the stack. "
                 f"Rooms not visited yet are faded.",
           "ko": f"방이 {n}개 있고 방 0만 열려 있으므로, 방 0을 방문한 것으로 표시하고 스택에 넣고 시작합니다. 아직 방문하지 "
                 f"않은 방은 흐리게 그립니다."},
          lit=[0], stack_marks={"good": [0]})

    def flush():
        """One frame for the rooms popped in a row that held no new key."""
        if not leaving:
            return
        k = len(leaving)
        base = len(todo)
        held = [key for r in leaving for key in rooms[r]]
        en, ko = [], []
        for r in leaving:
            if rooms[r]:
                many = len(rooms[r]) > 1
                en.append(f"room {r}'s {plural(len(rooms[r]), 'key', 'keys')} {keys_text(rooms[r])} "
                          f"{'open' if many else 'opens'} only rooms already visited")
                ko.append(f"방 {r}의 열쇠 {keys_text(rooms[r])}의 방은 이미 방문했고")
            else:
                en.append(f"room {r} holds no key")
                ko.append(f"방 {r}에는 열쇠가 없고")
        ko_text = ", ".join(ko)
        ko_text = ko_text[:-1] + "습니다"  # the last clause ends the sentence
        frame({"en": f"Pop {plural(k, 'room', 'rooms')} {', '.join(str(r) for r in leaving)}: {'; '.join(en)}.",
               "ko": f"방 {keys_josa(leaving, '을를')} {'차례로 ' if k > 1 else ''}꺼냅니다. {ko_text}."},
              lit=list(leaving), edge_lit=[(r, key) for r in leaving for key in rooms[r]],
              probes=[{"value": key, "hit": True} for key in held],
              stack_marks={"lit": list(range(base, base + k))},
              moves=[move(at("stack", base + i)) for i in range(k)])
        leaving.clear()

    while todo:
        room = todo.pop()
        new = [key for key in rooms[room] if key not in visited]
        if not new:
            leaving.append(room)
            if not todo:
                flush()
            continue
        todo.append(room)   # still on the stack while the pops before it are drawn
        flush()
        todo.pop()
        old = [key for key in rooms[room] if key in visited]
        visited.extend(new)
        leaving.append(room)
        top = len(todo)
        k = len(new)
        seen_en = (f" {plural(len(old), 'Key', 'Keys')} {keys_text(old)} {plural(len(old), 'opens a room', 'open rooms')} "
                   f"already visited." if old else "")
        seen_ko = f"하고, 열쇠 {keys_text(old)}의 방은 이미 방문했습니다" if old else "합니다"
        frame({"en": f"Pop room {room}: its {plural(k, 'key', 'keys')} {keys_text(new)} {plural(k, 'opens a room', 'open rooms')} "
                     f"not visited yet, so mark {plural(k, 'it', 'them')} visited.{seen_en}",
               "ko": f"방 {josa(room, '을를')} 꺼냅니다. 열쇠 {keys_text(new)}의 방은 아직 방문하지 않았으므로 방문한 것으로 "
                     f"표시{seen_ko}."},
              lit=[room], good=new, edge_lit=[(room, key) for key in rooms[room]],
              probes=[{"value": key, "hit": key in old} for key in rooms[room]],
              set_marks={"good": new}, stack_marks={"lit": [top]},
              moves=[move(at("rooms", [room, key]), at("visited", key), value=str(key)) for key in new])
        leaving.clear()
        todo.extend(new)
        frame({"en": f"Push {plural(k, 'room', 'rooms')} {keys_text(new)}, to enter {plural(k, 'it', 'them')} later.",
               "ko": f"방 {keys_josa(new, '을를')} 스택에 넣어 나중에 들어갑니다."},
              good=new, stack_marks={"good": list(range(top, len(todo)))},
              moves=[move(at("rooms", key), at("stack", top + i), value=str(key)) for i, key in enumerate(new)])

    v = len(visited)
    if v == n:
        frame({"en": f"The stack is empty and all {n} rooms were visited: answer true.",
               "ko": f"스택이 비었고 방 {n}개를 모두 방문했으므로 답은 true입니다."},
              path=list(range(n)), answer="true")
    else:
        locked = [r for r in range(n) if r not in visited]
        frame({"en": f"The stack is empty after {v} of {n} rooms: the keys to {plural(len(locked), 'room', 'rooms')} "
                     f"{keys_text(locked)} are only inside rooms never opened. Answer: false.",
               "ko": f"방 {n}개 중 {v}개만 방문하고 스택이 비었습니다. 방 {keys_text(locked)}의 열쇠는 열리지 않은 방 안에만 "
                     f"있으므로 답은 false입니다."},
              bad=locked, answer="false")


for number, sample in enumerate(sample_cases(SLUG), start=1):
    rooms = json.loads(sample["input"])
    run = sample_run(wt, number, sample, setup=graph(rooms)[1], input=f"rooms = {sample['input']}")
    solve(rooms, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
