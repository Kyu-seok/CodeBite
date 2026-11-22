#!/usr/bin/env python3.12
"""redundant-friendship's Walkthrough: the reference solution (scripts/replay-solutions/redundant-friendship.py),
union-find over the friendships in order, recording a frame for each friendship's two finds and one for its union,
on each sample Test Case. The parent array is the forest; the friendships are the graph, each student tagged with
the root of its group, so the friendship whose two students already share a root shows as the one closing the cycle.

    CODEBITE_DB=<database> scripts/walkthroughs/redundant-friendship.py

writes common/src/main/resources/walkthroughs/redundant-friendship.json.
"""
import json
import os
import sys
from functools import partial

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import driver_list, halving_find, josa, sample_cases, sample_run, union_root, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move  # noqa: E402

SLUG = "redundant-friendship"

wt = Walkthrough(
    {"en": "Redundant Friendship", "ko": "불필요한 친구 관계 찾기"},
    {"en": "Union-find: each friendship joins its two students' groups; the first one whose students already "
           "share a root closes the cycle, and it is the last of the cycle's friendships in links.",
     "ko": "유니온 파인드: 친구 관계마다 두 학생의 그룹을 합치고, 두 학생의 루트가 이미 같은 첫 친구 관계가 "
           "순환을 닫으며, 그것이 links에서 순환의 친구 관계 중 가장 나중 것입니다."},
    views=[
        {"id": "friends", "type": "graph", "directed": False,
         "title": {"en": "friendships (tag: root of the group)", "ko": "친구 관계 (태그: 그룹의 루트)"}},
        {"id": "parent", "type": "array",
         "title": {"en": "parent (index: student)", "ko": "parent (인덱스: 학생)"}},
    ],
)


def solve(links, run):
    """Solution.spotRedundantLink with a frame per pair of finds and per union. Returns the link."""
    n = len(links)
    parent = list(range(n + 1))
    students = list(range(1, n + 1))

    root_of = partial(union_root, parent)

    find = partial(halving_find, parent)

    def frame(caption, link=None, done=0, lit_cells=(), good_cells=(), pointers=None, path=False, moves=None,
              **answer):
        edge_marks = {"dim": list(range(done + (1 if link is not None else 0), n))}
        node_marks = {}
        if link is not None:
            edge_marks["path" if path else "lit"] = [link]
            node_marks["path" if path else "lit"] = list(links[link])
        run.frame(caption,
                  friends={"nodes": [{"id": s, "tag": {"en": f"root {root_of(s)}", "ko": f"루트 {root_of(s)}"}} for s in students],
                           "edgeMarks": edge_marks, "nodeMarks": node_marks},
                  parent={"values": parent, "tags": [[0, {"en": "unused", "ko": "안 씀"}]],
                          "pointers": pointers or {},
                          "marks": {"dim": [0], "lit": list(lit_cells), "good": list(good_cells)}},
                  moves=moves, **answer)

    frame({"en": f"{n} students, each its own group: parent[s] = s, so every student is a root. "
                 "Each friendship joins two groups; one whose students are already in the same group closes the cycle.",
           "ko": f"학생 {n}명이 각자 자기 그룹이라 parent[s] = s이고, 모두 루트입니다. "
                 "친구 관계마다 두 그룹을 합치며, 두 학생이 이미 같은 그룹이면 그 관계가 순환을 닫습니다."})
    for k, (a, b) in enumerate(links):
        writes_a, seen_a, writes_b, seen_b = [], [], [], []
        root_a = find(a, writes_a, seen_a)
        root_b = find(b, writes_b, seen_b)
        writes = writes_a + writes_b

        def climb(x, seen, root):
            if len(seen) == 1:
                return {"en": f"{x} is a root", "ko": f"{x}번은 루트"}
            return {"en": f"find({x}) climbs {' → '.join(map(str, seen))}",
                    "ko": f"{x}번에서 {''.join(f'{v} → ' for v in seen[:-1])}{josa(seen[-1], '(으)로')} 올라감"}
        ca, cb = climb(a, seen_a, root_a), climb(b, seen_b, root_b)
        halved = ""
        halved_ko = ""
        if writes:
            halved = "; on the way, " + ", ".join(f"parent[{x}] jumps to {v}" for _, x, v in writes)
            halved_ko = " (올라가는 길에 건너뜀: " + ", ".join(f"parent[{x}] = {v}" for _, x, v in writes) + ")"
        same = root_a == root_b
        if same:
            verdict = {"en": f"Both roots are {root_a}: {a} and {b} are already in one group.",
                       "ko": f"두 루트가 모두 {root_a}번이라 {a}번과 {b}번은 이미 같은 그룹입니다."}
        else:
            verdict = {"en": f"Roots {root_a} and {root_b} differ.",
                       "ko": f"루트 {josa(root_a, '과와')} {josa(root_b, '이가')} 다릅니다."}
        frame({"en": f"Friendship [{a},{b}]: {ca['en']}, {cb['en']}{halved}. {verdict['en']}",
               "ko": f"친구 관계 [{a},{b}]: {ca['ko']}, {cb['ko']}{halved_ko}. {verdict['ko']}"},
              link=k, done=k, lit_cells=sorted(set(seen_a + seen_b)), good_cells=[x for _, x, _ in writes],
              pointers={"root a": root_a, "root b": root_b} if not same else {"root": root_a},
              moves=[move(at("parent", src), at("parent", x), value=str(v)) for src, x, v in writes] or None)
        if same:
            rest = n - k - 1
            later = ", ".join(driver_list(link) for link in links[k + 1:])
            tail = ({"en": f"; {'the friendship' if rest == 1 else 'the friendships'} after it ({later}) "
                           f"{'is' if rest == 1 else 'are'} never read",
                     "ko": f"이고, 뒤의 {later} 관계는 읽지 않습니다"}
                    if rest else {"en": "", "ko": ""})
            frame({"en": f"Joining them would close a cycle, so [{a},{b}] is the friendship to remove{tail['en']}. "
                         f"Answer {driver_list([a, b])}.",
                   "ko": f"합치면 순환이 생기므로 없앨 친구 관계는 [{a},{b}]{tail['ko'] or '입니다'}. "
                         f"답은 {driver_list([a, b])}입니다."},
                  link=k, done=k, path=True, answer=driver_list([a, b]))
            return [a, b]
        parent[root_a] = root_b
        frame({"en": f"parent[{root_a}] = {root_b}: group {root_a} joins group {root_b}, so {a} and {b} are now in one group.",
               "ko": f"parent[{root_a}] = {root_b}: {root_a} 그룹이 {root_b} 그룹에 합쳐져 {a}번과 {b}번이 같은 그룹이 됩니다."},
              link=k, done=k, good_cells=[root_a],
              moves=[move(at("parent", root_b), at("parent", root_a))])
    raise AssertionError("no redundant friendship")


for number, sample in enumerate(sample_cases(SLUG), start=1):
    links = json.loads(sample["input"])
    setup = {"friends": {"edges": [{"from": x, "to": y} for x, y in links]}}
    run = sample_run(wt, number, sample, input=f"links = {sample['input']}", setup=setup)
    solve(links, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
