#!/usr/bin/env python3.12
"""recover-tier-order's Walkthrough: the reference solution (scripts/replay-solutions/recover-tier-order.py), which
reads one "a before b" rule from each pair of neighbouring tags, then orders the letters by in-degree with a min-heap
of the letters ready (Kahn's algorithm), recording a frame per pair compared and per letter taken and per rule it
releases, on each sample Test Case, plus an extra run whose rules go in a cycle.

The tags are a table, one row per tag and one column per letter position, so the first position where two neighbours
differ is lit on both rows. The letters are a graph, one arrow per rule found, with each letter's in-degree as its
value; the ready letters are the heap's tree, and the order an `output`.

    CODEBITE_DB=<database> scripts/walkthroughs/recover-tier-order.py

writes common/src/main/resources/walkthroughs/recover-tier-order.json.
"""
import heapq
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import driver_list, josa, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, level_order_tree, move  # noqa: E402

SLUG = "recover-tier-order"

wt = Walkthrough(
    {"en": "Recover Tier List Order", "ko": "티어 순서 복원"},
    {"en": "Each pair of neighbouring tags gives one rule at its first differing letter (a before b). Then take the "
           "letters with nothing left before them, smallest first, each one releasing the letters after it; a letter "
           "never released means the rules go in a cycle.",
     "ko": "이웃한 두 태그는 처음 다른 글자에서 규칙 하나를 줍니다(글자 a가 글자 b보다 앞). 그다음 앞에 남은 글자가 없는 글자를 작은 "
           "것부터 꺼내고, 꺼낸 글자는 뒤따르는 글자를 풀어 줍니다. 끝까지 풀리지 않는 글자가 있으면 규칙이 순환합니다."},
    views=[
        {"id": "tags", "type": "table", "title": {"en": "tags (one letter per cell)", "ko": "tags (칸마다 글자 하나)"}},
        {"id": "letters", "type": "graph", "directed": True,
         "title": {"en": "rules (arrow: comes before); under a letter: in-degree",
                   "ko": "규칙 (화살표: 앞에 옴); 글자 아래: 진입 차수"}},
        {"id": "ready", "type": "tree", "arity": 2,
         "title": {"en": "ready (min-heap of letters)", "ko": "ready (글자 최소 힙)"},
         "empty": {"en": "empty", "ko": "비어 있음"}},
        {"id": "order", "type": "output", "title": {"en": "order", "ko": "순서"},
         "empty": {"en": "empty", "ko": "비어 있음"}},
    ],
)


def solve(tags, run):
    """Solution.recoverTierOrder with a frame per pair and per step of Kahn's algorithm. Returns the answer."""
    width = max(len(t) for t in tags)
    rows = [{"label": str(i), "cells": list(t) + [""] * (width - len(t))} for i, t in enumerate(tags)]
    letters = list(dict.fromkeys(letter for tag in tags for letter in tag))
    after = {letter: [] for letter in letters}
    rules = []  # (a, b) in the order found: the graph's edges
    indegree = None
    ready, order = [], []
    st = {"pair": None}

    def frame(caption, cells=None, node_marks=None, edge_marks=None, ready_marks=None, order_marks=None, moves=None,
              **answer):
        g = {"edges": [{"from": a, "to": b} for a, b in rules], "nodeMarks": node_marks or {},
             "edgeMarks": edge_marks or {}}
        if indegree is not None:
            g["values"] = dict(indegree)
        # the heap and the order come in with Kahn's algorithm, once the in-degrees exist
        kahn = {} if indegree is None else {
            "ready": {**level_order_tree(list(ready)), "nodeMarks": ready_marks or {}},
            "order": {"values": list(order), "marks": order_marks or {}}}
        run.frame(caption, tags={"rows": rows, "marks": cells or {}}, letters=g, moves=moves, **kahn, **answer)

    frame({"en": f"{len(tags)} tags, sorted by the secret order, using {len(letters)} letters: "
                 f"{', '.join(letters)}. Compare each tag with the next one.",
           "ko": f"비밀 순서로 정렬된 태그 {len(tags)}개에 글자 {len(letters)}개가 쓰였습니다: {', '.join(letters)}. "
                 "태그마다 다음 태그와 비교합니다."})
    for k, (first, second) in enumerate(zip(tags, tags[1:])):
        same = [[r, j] for r in (k, k + 1) for j in range(min(len(first), len(second)))]
        for j, (a, b) in enumerate(zip(first, second)):
            if a != b:
                new = b not in after[a]
                if new:
                    after[a].append(b)
                    rules.append((a, b))
                e = rules.index((a, b))
                done = [[r, c] for r in range(k) for c in range(width)]
                frame({"en": f'"{first}" before "{second}": they first differ at position {j}, so {a} comes before {b}'
                             + ("." if new else ", a rule already found."),
                       "ko": f'"{first}" 다음에 "{second}": 위치 {j}에서 처음 다르므로 {a} 글자가 {b} 글자보다 앞입니다'
                             + ("." if new else ". 이미 찾은 규칙입니다.")},
                      cells={"dim": done, "lit": [[k, c] for c in range(j)] + [[k + 1, c] for c in range(j)],
                             "good": [[k, j], [k + 1, j]]},
                      node_marks={"good": [a, b]}, edge_marks={"good": [e]},
                      moves=[move(at("tags", [k, j]), at("letters", [a, b]), value=f"{a} → {b}")] if new else None)
                break
        else:
            if len(first) > len(second):
                frame({"en": f'"{second}" is a prefix of "{first}" but comes after it, which no tier order allows: '
                             'answer "" (empty).',
                       "ko": f'"{second}" 태그는 "{first}" 태그의 접두사인데 뒤에 오므로 어떤 티어 순서로도 불가능합니다. '
                             '답은 ""(빈 문자열)입니다.'},
                      cells={"lit": same, "bad": [[k, c] for c in range(len(second), len(first))]},
                      answer="")
                return
            frame({"en": f'"{first}" is a prefix of "{second}" and comes first, as it should: no rule.',
                   "ko": f'"{first}" 태그는 "{second}" 태그의 접두사이고 앞에 오므로 맞습니다. 규칙은 없습니다.'},
                  cells={"lit": same})
    indegree = dict.fromkeys(letters, 0)
    frame({"en": f"{len(rules)} {'rule' if len(rules) == 1 else 'rules'} found. Each letter's in-degree, how many "
                 "letters must come before it, starts at 0.",
           "ko": f"규칙 {len(rules)}개를 찾았습니다. 글자마다 앞에 와야 하는 글자 수인 진입 차수를 0으로 시작합니다."},
          moves=[move(dst=at("letters", x), value="0") for x in letters])
    for a, b in rules:
        indegree[b] += 1
    frame({"en": "Each rule a → b adds 1 to b's in-degree: " +
                 ", ".join(f"{x} has {indegree[x]}" for x in letters) + ".",
           "ko": "규칙 a → b마다 b의 진입 차수에 1을 더합니다: " +
                 ", ".join(f"{x} {indegree[x]}" for x in letters) + "."},
          node_marks={"good": [b for _, b in rules]},
          moves=[move(at("letters", [a, b]), at("letters", b), value="+1") for a, b in rules])
    ready = [x for x in letters if indegree[x] == 0]
    heapq.heapify(ready)
    if ready:
        frame({"en": f"The letters with in-degree 0 have nothing before them: {', '.join(sorted(ready))} "
                     f"{'goes' if len(ready) == 1 else 'go'} into the ready heap.",
               "ko": f"진입 차수가 0인 글자는 앞에 올 글자가 없으므로 ready 힙에 넣습니다: {', '.join(sorted(ready))}."},
              node_marks={"lit": list(ready)}, ready_marks={"good": list(range(len(ready)))},
              moves=[move(at("letters", x), at("ready", ready.index(x)), value=x) for x in ready])
    while ready:
        letter = ready[0]
        order.append(letter)
        frame({"en": f"Pop {letter}, the smallest ready letter: it is next in the order.",
               "ko": f"ready에서 가장 작은 {letter} 글자를 꺼내 순서의 다음 자리에 둡니다."},
              node_marks={"lit": [letter], "dim": order[:-1]}, ready_marks={"lit": [0]},
              order_marks={"good": [len(order) - 1]},
              moves=[move(at("ready", 0), at("order", len(order) - 1))])
        heapq.heappop(ready)
        for follower in after[letter]:
            indegree[follower] -= 1
            e = rules.index((letter, follower))
            moves = [move(at("letters", [letter, follower]), at("letters", follower), value="−1")]
            if indegree[follower] == 0:
                heapq.heappush(ready, follower)
                moves.append(move(at("letters", follower), at("ready", ready.index(follower)), value=follower))
                tail = {"en": f"reaches 0, so {follower} is ready", "ko": f"0이 되어 {follower} 글자도 ready에 들어갑니다"}
            else:
                tail = {"en": f"is {indegree[follower]}: something else must still come first",
                        "ko": f"{josa(indegree[follower], '이가')} 되어 아직 앞에 올 글자가 남았습니다"}
            frame({"en": f"Rule {letter} → {follower} is met: {follower}'s in-degree {tail['en']}.",
                   "ko": f"{letter} → {follower} 규칙을 만족했으므로 {follower}의 진입 차수가 {tail['ko']}."},
                  node_marks={"lit": [letter], "good": [follower], "dim": order[:-1]},
                  edge_marks={"good": [e], "dim": [rules.index((x, y)) for x in order[:-1] for y in after[x]]},
                  ready_marks={"good": [ready.index(follower)]} if indegree[follower] == 0 else {},
                  moves=moves)
    word = "".join(order)
    if len(order) == len(letters):
        frame({"en": f"Every letter was taken, so the order is {word}: answer {word}.",
               "ko": f"모든 글자를 꺼냈으므로 순서는 {word}입니다. 답은 {word}입니다."},
              node_marks={"path": letters}, edge_marks={"path": list(range(len(rules)))},
              order_marks={"path": list(range(len(order)))}, answer=word)
    else:
        stuck = [x for x in letters if x not in order]
        cycle = [k for k, (a, b) in enumerate(rules) if a in stuck and b in stuck]
        frame({"en": f"The heap is empty with {', '.join(stuck)} never ready: their rules go in a cycle, so no order "
                     'fits. Answer "" (empty).',
               "ko": f"힙이 비었는데 {', '.join(stuck)} 글자는 끝내 준비되지 않았습니다. 규칙이 순환하므로 맞는 순서가 "
                     '없어 답은 ""(빈 문자열)입니다.'},
              node_marks={"bad": stuck, "dim": order}, edge_marks={"bad": cycle}, answer="")


for number, sample in enumerate(sample_cases(SLUG), start=1):
    tags = json.loads(sample["input"])
    run = sample_run(wt, number, sample, input=f"tags = {sample['input']}",
                     setup={"letters": {"nodes": [{"id": x} for x in dict.fromkeys(c for t in tags for c in t)]}})
    solve(tags, run)
# No sample reaches the cycle: every one either has an order or a tag before its own prefix.
tags = ["a", "b", "cc", "cb"]
run = wt.run({"en": "Extra: rules in a cycle", "ko": "추가: 순환하는 규칙"}, input=f"tags = {driver_list(tags)}", expected="",
             extra=True, setup={"letters": {"nodes": [{"id": x} for x in dict.fromkeys(c for t in tags for c in t)]}})
solve(tags, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
