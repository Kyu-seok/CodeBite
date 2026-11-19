#!/usr/bin/env python3.12
"""lru-cache's Walkthrough: the reference solution (scripts/replay-solutions/lru-cache.py), a hash map from key to
node and a doubly linked list of the nodes between two sentinels, head (least recently used side) and tail (most
recently used side), driven by each sample's list of calls. One frame per lookup and per list operation: a node
unlinked (its neighbour's arrow skips it), a node appended before tail, and the least recently used node evicted.

The call-list pattern (add-walkthrough views.md): the calls are a table, one row per call, the current one lit and
those before it faded; each call's return value moves into an `output` (the Driver's printed list), and the map and
the list change underneath. The list view draws each node's next above the row and its prev under it (the linked-list
view's second link), each re-pointed arrow marked and the arrow it replaced drawn faded. Nodes stand in the order they
were made, so a next arrow over the row, or a long prev arc under it, is a node moved to the end.

    CODEBITE_DB=<database> scripts/walkthroughs/lru-cache.py

writes common/src/main/resources/walkthroughs/lru-cache.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import josa, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move  # noqa: E402

SLUG = "lru-cache"

wt = Walkthrough(
    {"en": "LRU Cache", "ko": "LRU 캐시"},
    {"en": "A hash map finds a key's node in O(1), and a doubly linked list keeps the nodes in order of use, from head "
           "(least recent) to tail (most recent). Every use unlinks the node and appends it before tail; when the "
           "cache grows past capacity, the node after head is evicted.",
     "ko": "해시 맵으로 키의 노드를 O(1)에 찾고, 이중 연결 리스트로 노드를 사용한 순서대로 head(가장 오래됨)부터 "
           "tail(가장 최근)까지 둡니다. 사용할 때마다 노드를 떼어 tail 앞에 붙이고, 용량을 넘으면 head 바로 뒤의 노드를 "
           "제거합니다."},
    views=[
        {"id": "list", "type": "linkedlist",
         "title": {"en": "key=value nodes: next above, prev below", "ko": "key=value 노드: 위는 next, 아래는 prev"}},
        {"id": "map", "type": "map", "title": {"en": "nodes: key → node's value", "ko": "nodes: 키 → 노드의 값"},
         "empty": {"en": "empty", "ko": "비어 있음"}},
        {"id": "calls", "type": "table", "title": {"en": "calls", "ko": "호출"}},
        {"id": "result", "type": "output", "title": {"en": "returned", "ko": "반환값"}},
        {"id": "state", "type": "vars"},
    ],
)


class Node:
    def __init__(self, key=None, value=None):
        self.key, self.value = key, value
        self.prev = self.next = None


def solve(ops, args, run):
    """The Driver's loop over the calls with the reference LRUCache inside. Returns the printed list."""
    rows = [{"label": str(i), "cells": [op, ", ".join(str(x) for x in a)]} for i, (op, a) in enumerate(zip(ops, args))]
    capacity = args[0][0]
    head, tail = Node(), Node()
    head.next, tail.prev = tail, head
    nodes = {}  # key -> Node, in insertion order, as the reference's dict
    made = []  # live nodes in the order they were made: the row's order between the sentinels
    result = []
    st = {"row": 0, "drawn": 0}

    def nid(node):
        return "head" if node is head else "tail" if node is tail else node.key

    def frame(caption, list_marks=None, link=(), cut=None, back=(), back_cut=None, map_marks=None, probe=None,
              struck=(), moves=None, done=False, **answer):
        r = st["row"]
        fresh = list(range(st["drawn"], len(result)))
        st["drawn"] = len(result)
        order = [head] + made + [tail]
        lst = {"nodes": [{"id": nid(n), "value": "" if n in (head, tail) else f"{n.key}={n.value}"} for n in order],
               "next": {nid(n): nid(n.next) for n in order if n.next is not None},
               "links": {"prev": {nid(n): None if n.prev is None else nid(n.prev) for n in order}},
               "pointers": {"head": "head", "tail": "tail"}, "marks": list_marks or {}}
        if link or back:
            lst["linkMarks"] = {"good": [nid(n) for n in link] + [["prev", nid(n)] for n in back]}
        if cut:
            lst["cut"] = {nid(a): nid(b) for a, b in cut}
        if back_cut:
            lst["linkCuts"] = {"prev": {nid(a): nid(b) for a, b in back_cut}}
        mp = {"entries": [{"key": k, "value": str(n.value)} for k, n in nodes.items()], "marks": map_marks or {}}
        if struck:
            mp["struck"] = list(struck)
        if probe is not None:
            mp["probe"] = probe
        run.frame(caption,
                  calls={"columns": [{"en": "call", "ko": "호출"}, {"en": "arguments", "ko": "인자"}], "rows": rows,
                         "marks": {} if done else {"dim": [[i, c] for i in range(r) for c in (0, 1)],
                                                   "lit": [[r, 0], [r, 1]]}},
                  map=mp, list=lst,
                  result={"values": list(result), "marks": {"path": list(range(len(result)))} if done
                          else {"good": fresh}},
                  state={"items": [{"label": {"en": "capacity", "ko": "capacity (용량)"}, "value": capacity}]},
                  moves=moves, **answer)

    def ret(value, src):
        result.append("null" if value is None else str(value))
        k = len(result) - 1
        if src is None:
            return [move(at("calls", [st["row"], 0]), at("result", k), value=result[-1])]
        return [move(src, at("result", k))]

    def name(node):
        return "head" if node is head else "tail" if node is tail else f"{node.key}={node.value}"

    def unlink(node, why, moves=None, map_marks=None, probe=None):
        before, after = node.prev, node.next
        before.next = after
        after.prev = before
        frame({"en": f"{why['en']} Unlink it: {name(before)}'s next skips it to {name(after)}, and {name(after)}'s "
                     f"prev comes back to {name(before)}.",
               "ko": f"{why['ko']} 이 노드를 떼어 내면 {name(before)}의 next는 이 노드를 건너 {name(after)} 노드를, "
                     f"{name(after)}의 prev는 {name(before)} 노드를 가리킵니다."},
              list_marks={"lit": [nid(node)]}, link=[before], cut=[(before, node)], back=[after],
              back_cut=[(after, node)], moves=moves, map_marks=map_marks, probe=probe)

    def append(node, why, moves=None):
        last = tail.prev
        old_next, old_prev = node.next, node.prev
        last.next = node
        node.prev = last
        node.next = tail
        tail.prev = node
        cut = [(last, tail)]
        if old_next is not None and old_next is not tail:
            cut.append((node, old_next))
        back_cut = [(tail, last)]
        if old_prev is not None and old_prev is not last:
            back_cut.append((node, old_prev))
        frame({"en": f"{why['en']} Append {name(node)} before tail: {name(last)}'s next is now this node and its next "
                     f"is tail; its prev is {name(last)} and tail's prev is this node, so it is the most recently used.",
               "ko": f"{why['ko']} {name(node)} 노드를 tail 앞에 붙입니다. {name(last)}의 next와 tail의 prev가 이 노드, "
                     f"이 노드의 next가 tail, prev가 {name(last)} 노드가 되어 가장 최근에 사용한 노드가 됩니다."},
              list_marks={"good": [nid(node)]}, link=[last, node], cut=cut, back=[tail, node], back_cut=back_cut,
              moves=moves)

    for row, (op, arg) in enumerate(zip(ops, args)):
        st["row"] = row
        if op == "LRUCache":
            frame({"en": f"LRUCache({capacity}): an empty map, and the sentinels head and tail linked to each other. "
                         f"Returns null.",
                   "ko": f"LRUCache({capacity}): 빈 맵과 서로 이어진 sentinel 노드 head, tail로 시작하고 null을 "
                         f"반환합니다."},
                  moves=ret(None, None))
        elif op == "get":
            key = arg[0]
            node = nodes.get(key)
            if node is None:
                frame({"en": f"get({key}): key {key} is not in the map, so it returns -1 and nothing moves.",
                       "ko": f"get({key}): 맵에 키 {josa(key, '이가')} 없으므로 -1을 반환하고 아무것도 옮기지 않습니다."},
                      probe={"key": key, "hit": False}, moves=ret(-1, None))
                continue
            unlink(node, {"en": f"get({key}): the map finds node {name(node)}.",
                          "ko": f"get({key}): 맵에서 {name(node)} 노드를 찾습니다."},
                   probe={"key": key, "hit": True})
            append(node, {"en": f"get({key}) is a use, and returns {node.value}.",
                          "ko": f"get({key})도 사용이므로 {josa(node.value, '을를')} 반환하고,"},
                   moves=ret(node.value, at("list", nid(node))))
        else:
            key, value = arg
            node = nodes.get(key)
            if node is not None:
                node.value = value
                unlink(node, {"en": f"put({key}, {value}): key {key} is in the map; its node's value becomes {value}.",
                              "ko": f"put({key}, {value}): 맵에 키 {josa(key, '이가')} 있어 노드의 값을 "
                                    f"{josa(value, '(으)로')} 바꿉니다."},
                       probe={"key": key, "hit": True}, map_marks={"good": [key]},
                       moves=[move(at("calls", [row, 1]), at("map", key), value=str(value)),
                              move(at("calls", [row, 1]), at("list", key), value=f"{key}={value}")])
            else:
                node = Node(key, value)
                nodes[key] = node
                made.append(node)
                frame({"en": f"put({key}, {value}): key {key} is not in the map, so a new node {key}={value} is made "
                             f"and the map points key {key} to it.",
                       "ko": f"put({key}, {value}): 맵에 키 {josa(key, '이가')} 없으므로 새 노드 {key}={josa(value, '을를')} 만들고 "
                             f"맵의 키 {josa(key, '이가')} 그 노드를 가리킵니다."},
                      probe={"key": key, "hit": False}, list_marks={"good": [key]}, map_marks={"good": [key]},
                      moves=[move(at("calls", [row, 1]), at("map", key), value=str(value)),
                             move(at("calls", [row, 1]), at("list", key), value=f"{key}={value}")])
            evict = len(nodes) > capacity
            if evict:
                why = {"en": f"put({key}, {value}) is a use.", "ko": f"put({key}, {value})도 사용이므로"}
            else:
                why = {"en": f"put({key}, {value}) is a use, and returns null.",
                       "ko": f"put({key}, {value})도 사용이므로 null을 반환하고,"}
            append(node, why, moves=None if evict else ret(None, None))
            if evict:
                lru = head.next
                lru.prev.next = lru.next
                lru.next.prev = lru.prev
                frame({"en": f"The map holds {len(nodes)} keys, more than capacity {capacity}, so head.next, "
                             f"{name(lru)}, the least recently used, is unlinked and key {lru.key} deleted from the "
                             f"map. Returns null.",
                       "ko": f"맵의 키가 {len(nodes)}개로 용량 {josa(capacity, '을를')} 넘으므로, 가장 오래 사용하지 "
                             f"않은 head.next의 {name(lru)} 노드를 떼어 내고 맵에서 키 {josa(lru.key, '을를')} "
                             f"지웁니다. null을 반환합니다."},
                      list_marks={"bad": [nid(lru)]}, link=[head], cut=[(head, lru)], back=[lru.next],
                      back_cut=[(lru.next, lru)], map_marks={"bad": [lru.key]},
                      struck=[lru.key],
                      moves=[move(at("map", lru.key), mark="bad"), move(at("list", nid(lru)), mark="bad")]
                      + ret(None, None))
                del nodes[lru.key]
                made.remove(lru)
    printed = "[" + ",".join(result) + "]"
    frame({"en": f"Every call has run. The returned values, as the Driver prints them, are {printed}.",
           "ko": f"모든 호출이 끝났습니다. 반환값을 Driver가 출력하는 대로 모으면 {printed}입니다."},
          done=True, answer=printed)
    return printed


for number, sample in enumerate(sample_cases(SLUG), start=1):
    lines = sample["input"].split("\n")
    ops, args = json.loads(lines[0]), json.loads(lines[1])
    run = sample_run(wt, number, sample, input=f"{lines[0]}\n{lines[1]}")
    solve(ops, args, run)
wt.write(walkthrough_path(SLUG))
