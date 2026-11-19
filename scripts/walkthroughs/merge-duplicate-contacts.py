#!/usr/bin/env python3.12
"""merge-duplicate-contacts' Walkthrough: the reference solution
(scripts/replay-solutions/merge-duplicate-contacts.py), union-find over emails, on each sample Test Case. The emails
are drawn as the description's graph Diagram draws them (its short names, an edge from each entry's first email to
each other email in it), each node's value its parent and its tag its owner's name; then each email moves into its
root's group, and each group into the merged entries.

    CODEBITE_DB=<database> scripts/walkthroughs/merge-duplicate-contacts.py

writes common/src/main/resources/walkthroughs/merge-duplicate-contacts.json.
"""
import json
import os
import re
import subprocess
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import ROOT, plural, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move  # noqa: E402

SLUG = "merge-duplicate-contacts"

wt = Walkthrough(
    {"en": "Merge Duplicate Contacts", "ko": "중복 연락처 합치기"},
    {"en": "Union-find over emails: each email joins the group of its entry's first email, so entries that share an "
           "email end up under one root; then each root's emails, sorted, are one person.",
     "ko": "이메일로 유니온 파인드를 합니다. 이메일마다 그 항목의 첫 이메일 그룹에 합쳐지므로, 이메일을 공유하는 항목들은 "
           "한 루트 아래로 모이고, 루트마다 정렬한 이메일이 한 사람입니다."},
    views=[
        {"id": "emails", "type": "graph", "directed": False,
         "title": {"en": "emails (under: parent; tag: owner)", "ko": "이메일 (아래: parent, 태그: 이름)"}},
        {"id": "groups", "type": "map", "title": {"en": "groups (root → emails)", "ko": "groups (루트 → 이메일)"},
         "empty": {"en": "not started", "ko": "아직 없음"}},
        {"id": "merged", "type": "output", "title": {"en": "merged entries", "ko": "합친 항목"},
         "empty": {"en": "none yet", "ko": "아직 없음"}},
    ],
)


def diagram_names(number):
    """The short names the description's graph Diagram under Example `number` gives its nodes, or None."""
    out = subprocess.run([os.path.join(ROOT, "scripts", "db-sql.sh"),
                          f"SELECT description FROM problems WHERE slug = '{SLUG}'"],
                         check=True, capture_output=True, text=True).stdout
    sections = re.split(r"\*\*Example \d+:\*\*", out)
    if number >= len(sections):
        return None
    found = re.search(r"```diagram-graph\n(?:.*\n)*?nodes: (\[.*\])", sections[number].split("**Example")[0])
    return json.loads(found.group(1)) if found else None


def solve(accounts, number, run):
    """Solution.unifyContactIdentities with a frame per step. Returns the answer as the Driver prints it."""
    order = []
    for _, *emails in accounts:
        for e in emails:
            if e not in order:
                order.append(e)
    names = diagram_names(number)
    if names is not None and len(names) != len(order):
        raise SystemExit(f"Example {number}: the Diagram names {len(names)} nodes, the input {len(order)} emails")
    short = dict(zip(order, names)) if names else {e: e.split("@")[0] for e in order}
    edges = []
    for _, first, *rest in accounts:
        for e in rest:
            if (first, e) not in edges and (e, first) not in edges:
                edges.append((first, e))
    run.data["setup"] = {"emails": {"nodes": [{"id": e, "label": short[e]} for e in order],
                                    "edges": [{"from": a, "to": b} for a, b in edges]}}

    parent, owner = {}, {}
    groups = {}
    merged = []

    def frame(caption, lit=(), good=(), path=(), edge=None, group_marks=None, merged_marks=None, moves=None,
              **answer):
        tags = {e: owner[e] for e in owner}
        run.frame(caption,
                  emails={"nodes": [{"id": e, "label": short[e], **({"tag": tags[e]} if e in tags else {})}
                                    for e in order],
                          "values": {e: short[p] for e, p in parent.items()},
                          "nodeMarks": {"dim": [e for e in order if e not in parent], "path": list(path),
                                        "good": list(good), "lit": list(lit)},
                          "edgeMarks": {"lit": [] if edge is None else [edge]}},
                  groups={"entries": [{"key": short[r], "value": [short[e] for e in es]} for r, es in groups.items()],
                          "marks": group_marks or {}},
                  merged={"values": list(merged), "marks": merged_marks or {}},
                  moves=moves, **answer)

    def find(email, moves):
        """The reference's find, recording each parent it rewrites (path halving) as a move."""
        while parent[email] != email:
            jumped = parent[parent[email]]
            if jumped != parent[email]:
                moves.append(move(at("emails", jumped), at("emails", email), value=short[jumped]))
            parent[email] = jumped
            email = parent[email]
        return email

    n = len(accounts)
    frame({"en": f"{n} entries, {len(order)} distinct emails. Each email will point to a parent; an email that is "
                 f"its own parent is a root, and a root stands for one person.",
           "ko": f"항목 {n}개에 서로 다른 이메일이 {len(order)}개 있습니다. 이메일마다 parent를 가리키며, 자기 자신이 "
                 f"parent인 이메일이 루트이고 루트 하나가 한 사람입니다."})
    for k, (name, first, *rest) in enumerate(accounts, start=1):
        for email in (first, *rest):
            s, f = short[email], short[first]
            edge = None if email == first else (edges.index((first, email)) if (first, email) in edges
                                                 else edges.index((email, first)))
            if email not in parent:
                parent.setdefault(email, email)
                owner[email] = name
                frame({"en": f"Entry {k} ({name}): {s} is new, so it starts as its own root, owned by {name}.",
                       "ko": f"항목 {k}({name}): {s} 이메일은 처음 나왔으므로 자기 자신이 루트인 채로 시작하고, "
                             f"주인은 {name}입니다."},
                      lit=[email], good=[email], edge=edge, moves=[move(None, at("emails", email), value=s)])
            else:
                owner[email] = name
            moves = []
            root_e = find(email, moves)
            root_f = find(first, moves)
            if email == first:
                continue
            if root_e == root_f:
                frame({"en": f"Entry {k} ({name}): {s} is already in {f}'s group, under root {short[root_f]}, "
                             f"so nothing changes.",
                       "ko": f"항목 {k}({name}): {s} 이메일은 이미 {f} 이메일과 같은 그룹(루트 {short[root_f]})에 "
                             f"있으므로 바뀌는 것이 없습니다."},
                      lit=[email, first], edge=edge, moves=moves or None)
                parent[root_e] = root_f
                continue
            parent[root_e] = root_f
            moves.append(move(at("emails", root_f), at("emails", root_e), value=short[root_f]))
            frame({"en": f"Entry {k} ({name}): {s} shares the entry with {f}, so parent[{short[root_e]}] = "
                         f"{short[root_f]}: {s}'s group joins {f}'s group, rooted at {short[root_f]}.",
                   "ko": f"항목 {k}({name}): {s} 이메일은 {f} 이메일과 같은 항목이므로 parent[{short[root_e]}] = "
                         f"{short[root_f]}, {s}의 그룹이 루트가 {short[root_f]}인 {f}의 그룹에 합쳐집니다."},
                  lit=[first], good=[root_e], edge=edge, moves=moves)
    for email in parent:
        moves = []
        root = find(email, moves)
        is_new = root not in groups
        groups.setdefault(root, []).append(email)
        s, r = short[email], short[root]
        moves.append(move(at("emails", email), at("groups", r), value=s))
        frame({"en": f"{s}'s root is {r}: " + (f"a new group starts at {r}." if is_new else f"it joins group {r}."),
               "ko": f"{s} 이메일의 루트는 {r}입니다. " + (f"{r} 그룹이 새로 생깁니다." if is_new
                                                        else f"{r} 그룹에 들어갑니다.")},
              lit=[email], group_marks={"good": [r]}, moves=moves)
    result = []
    for root, emails in groups.items():
        entry = [owner[root], *sorted(emails)]
        result.append(entry)
        merged.append(f"{owner[root]}: " + ", ".join(short[e] for e in sorted(emails)))
        r = short[root]
        frame({"en": f"Group {r} is one person, {owner[root]}: {plural(len(emails), "their email follows", f"their {len(emails)} emails, sorted, follow")} the name.",
               "ko": f"{r} 그룹은 한 사람 {owner[root]}입니다. 이름 뒤에 이메일 {len(emails)}개를 사전순으로 붙입니다."},
              lit=emails, group_marks={"lit": [r]}, merged_marks={"good": [len(merged) - 1]},
              moves=[move(at("groups", r), at("merged", len(merged) - 1))])
    result.sort(key=lambda a: a[1])
    printed = json.dumps(result, separators=(",", ":"))
    m = len(result)
    frame({"en": f"{n} entries merge into {m} people. In order of first email, the answer is {printed}.",
           "ko": f"항목 {n}개가 {m}명으로 합쳐집니다. 첫 이메일 순으로 "
                 f"적은 답은 {printed}입니다."},
          path=order, answer=printed)


for number, sample in enumerate(sample_cases(SLUG), start=1):
    accounts = json.loads(sample["input"])
    run = sample_run(wt, number, sample, input=f"accounts = {sample['input']}")
    solve(accounts, number, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
