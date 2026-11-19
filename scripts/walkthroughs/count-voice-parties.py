#!/usr/bin/env python3.12
"""count-voice-parties' Walkthrough: the reference solution (scripts/replay-solutions/count-voice-parties.py),
union-find over the relays in order, on each sample Test Case: a frame for each relay's two finds and one for each
union. The relays are drawn as the description's graph Diagram draws them, each player tagged with the root of its
party; the parent array is the forest, and the parties are one chip per player, a chip fading when its player stops being a
root at a union, so the answer is how many chips are still bright.

    CODEBITE_DB=<database> scripts/walkthroughs/count-voice-parties.py

writes common/src/main/resources/walkthroughs/count-voice-parties.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import josa, plural, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move  # noqa: E402

SLUG = "count-voice-parties"

wt = Walkthrough(
    {"en": "Count Voice Relay Parties", "ko": "음성 릴레이 파티 세기"},
    {"en": "Union-find: every player starts as a party of one; a relay between two different parties joins them, "
           "so each union leaves one party fewer, and the parties left are the answer.",
     "ko": "유니온 파인드: 플레이어마다 혼자서 한 파티로 시작합니다. 서로 다른 두 파티를 잇는 릴레이는 둘을 합치므로 "
           "합칠 때마다 파티가 하나 줄고, 남은 파티 수가 답입니다."},
    views=[
        {"id": "players", "type": "graph", "directed": False,
         "title": {"en": "relays (tag: root of the party)", "ko": "릴레이 (태그: 파티의 루트)"}},
        {"id": "parent", "type": "array", "title": {"en": "parent (index: player)", "ko": "parent (인덱스: 플레이어)"}},
        {"id": "parties", "type": "output", "title": {"en": "parties, by root (faded: joined another)", "ko": "파티 (루트 번호, 흐림: 다른 파티에 합쳐짐)"},
         "empty": {"en": "none", "ko": "없음"}},
    ],
)


def solve(n, relays, run):
    """Solution.countParties with a frame per pair of finds and per union. Returns the answer."""
    parent = list(range(n))
    roots = list(range(n))  # the parties, by root, in player order
    gone = []               # the roots that stopped being roots, drawn faded

    def root_of(x):
        """The root of x's party, without the halving find does: for the graph's tags only."""
        while parent[x] != x:
            x = parent[x]
        return x

    def find(x, writes, visited):
        """The reference's find, recording each player it stands on and each parent it rewrites."""
        visited.append(x)
        while parent[x] != x:
            jumped = parent[parent[x]]
            if jumped != parent[x]:
                writes.append((parent[x], x, jumped))  # (read from, written cell, new value)
            parent[x] = jumped
            x = parent[x]
            visited.append(x)
        return x

    def frame(caption, relay=None, done=0, lit_cells=(), good_cells=(), pointers=None, party_marks=None, moves=None,
              **answer):
        edge_marks = {"dim": list(range(done + (1 if relay is not None else 0), len(relays)))}
        node_marks = {}
        if relay is not None:
            edge_marks["lit"] = [relay]
            node_marks["lit"] = list(relays[relay])
        run.frame(caption,
                  players={"nodes": [{"id": p, "tag": {"en": f"root {root_of(p)}", "ko": f"루트 {root_of(p)}"}}
                                     for p in range(n)],
                           "edgeMarks": edge_marks, "nodeMarks": node_marks},
                  parent={"values": list(parent), "pointers": pointers or {},
                          "marks": {"lit": list(lit_cells), "good": list(good_cells)}},
                  parties={"values": [str(r) for r in range(n)],
                           "marks": {"dim": list(gone), **(party_marks or {})}},
                  moves=moves, **answer)

    m = len(relays)
    frame({"en": f"{n} players, each its own party: parent[p] = p, so every player is a root, and there are {n} "
                 f"parties. Now read the {m} {plural(m, 'relay', 'relays')}.",
           "ko": f"플레이어 {n}명이 각자 한 파티라 parent[p] = p이고, 모두 루트이므로 파티는 {n}개입니다. 이제 릴레이 "
                 f"{m}개를 읽습니다."})
    for k, (a, b) in enumerate(relays):
        writes_a, seen_a, writes_b, seen_b = [], [], [], []
        ra = find(a, writes_a, seen_a)
        rb = find(b, writes_b, seen_b)
        writes = writes_a + writes_b

        def climb(x, seen):
            if len(seen) == 1:
                return {"en": f"{x} is a root", "ko": f"{x}번은 루트"}
            return {"en": f"find({x}) climbs {' → '.join(map(str, seen))}",
                    "ko": f"{x}번에서 {''.join(f'{v} → ' for v in seen[:-1])}{josa(seen[-1], '(으)로')} 올라감"}
        ca, cb = climb(a, seen_a), climb(b, seen_b)
        halved = halved_ko = ""
        if writes:
            halved = "; on the way, " + ", ".join(f"parent[{x}] jumps to {v}" for _, x, v in writes)
            halved_ko = " (올라가는 길에 건너뜀: " + ", ".join(f"parent[{x}] = {v}" for _, x, v in writes) + ")"
        same = ra == rb
        verdict = ({"en": f"Both roots are {ra}: one party already, so nothing changes.",
                    "ko": f"두 루트가 모두 {ra}번이라 이미 한 파티이므로 바뀌는 것이 없습니다."} if same else
                   {"en": f"Roots {ra} and {rb} differ: two parties.",
                    "ko": f"루트 {josa(ra, '과와')} {josa(rb, '이가')} 달라 서로 다른 두 파티입니다."})
        frame({"en": f"Relay [{a},{b}]: {ca['en']}, {cb['en']}{halved}. {verdict['en']}",
               "ko": f"릴레이 [{a},{b}]: {ca['ko']}, {cb['ko']}{halved_ko}. {verdict['ko']}"},
              relay=k, done=k, lit_cells=sorted(set(seen_a + seen_b)), good_cells=[x for _, x, _ in writes],
              pointers={"root a": ra, "root b": rb} if not same else {"root": ra},
              moves=[move(at("parent", src), at("parent", x), value=str(v)) for src, x, v in writes] or None)
        if same:
            continue
        parent[ra] = rb
        left = len(roots) - 1
        frame({"en": f"parent[{ra}] = {rb}: party {ra} joins party {rb}, so the party with root {ra} is gone: "
                     f"{left} {plural(left, 'party', 'parties')} left.",
               "ko": f"parent[{ra}] = {rb}: {ra}번 파티가 {rb}번 파티에 합쳐져 루트 {ra}의 파티가 사라지고, "
                     f"파티는 {left}개 남습니다."},
              relay=k, done=k, good_cells=[ra], party_marks={"bad": [ra]},
              moves=[move(at("parent", rb), at("parent", ra)), move(at("parties", ra), mark="bad")])
        roots.remove(ra)
        gone.append(ra)
    c = len(roots)
    frame({"en": f"Every relay is read. {c} {plural(c, 'root is', 'roots are')} left "
                 f"({', '.join(map(str, roots))}), one per party: answer {c}.",
           "ko": f"릴레이를 모두 읽었습니다. 남은 루트는 {', '.join(map(str, roots))}, {c}개이므로 답은 {c}입니다."},
          done=m, party_marks={"good": list(roots)}, answer=str(c))


for number, sample in enumerate(sample_cases(SLUG), start=1):
    lines = sample["input"].split("\n")
    n, relays = int(lines[0]), json.loads(lines[1])
    setup = {"players": {"edges": [{"from": x, "to": y} for x, y in relays]}}
    run = sample_run(wt, number, sample, input=f"n = {n}, relays = {lines[1].strip()}", setup=setup)
    solve(n, relays, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
