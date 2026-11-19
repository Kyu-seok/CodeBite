#!/usr/bin/env python3.12
"""dog-street-walk's Walkthrough: the reference solution (scripts/replay-solutions/dog-street-walk.py), Hierholzer's
algorithm with a stack, always taking the smallest street left, recording a frame per street walked and per zone
finished, on each sample Test Case.

Each zone's streets out are a map card, sorted largest first so that pop() from the end takes the smallest. A street
walked is faded on its card rather than removed: the card keeps the order the pops follow, and the faded chips are
the streets the list has lost. A zone with no street left is popped off the stack onto the walk, which is built
backwards, so the last frame reverses it into the answer.

    CODEBITE_DB=<database> scripts/walkthroughs/dog-street-walk.py

writes common/src/main/resources/walkthroughs/dog-street-walk.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import driver_list, node_order, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move, stack  # noqa: E402

SLUG = "dog-street-walk"

wt = Walkthrough(
    {"en": "Dog Street Walk", "ko": "강아지 동네 산책"},
    {"en": "Hierholzer's algorithm: walk the smallest street left from the zone on top of the stack; a zone with no "
           "street left is finished and goes onto the walk. Zones finish in reverse order, so the walk reversed is "
           "the answer, and a dead end taken too early simply finishes first.",
     "ko": "히어홀저 알고리즘: 스택 맨 위 구역에서 남은 길 중 가장 작은 길로 걷습니다. 남은 길이 없는 구역은 끝난 것이라 "
           "산책 경로에 붙입니다. 구역은 거꾸로 끝나므로 경로를 뒤집으면 답이고, 너무 일찍 들어간 막다른 길은 그냥 먼저 "
           "끝납니다."},
    views=[
        {"id": "zones", "type": "graph", "directed": True, "title": {"en": "streets", "ko": "길"}},
        {"id": "out", "type": "map",
         "title": {"en": "streets out, largest first (faded: walked)", "ko": "나가는 길, 큰 것부터 (흐림: 걸은 길)"},
         "empty": {"en": "empty", "ko": "비어 있음"}},
        {"id": "trail", "type": "stack", "title": {"en": "stack", "ko": "스택"},
         "empty": {"en": "empty", "ko": "비어 있음"}},
        {"id": "walk", "type": "output", "title": {"en": "walk, built backwards", "ko": "산책 경로 (거꾸로 쌓임)"},
         "empty": {"en": "empty", "ko": "비어 있음"}},
        {"id": "result", "type": "output", "title": {"en": "answer", "ko": "답"},
         "empty": {"en": "not yet", "ko": "아직 없음"}},
    ],
)


def solve(routes, run):
    """Solution.planWalk with a frame per street walked and per zone finished. Returns the answer as printed."""
    full = {}  # zone -> its streets as sorted(routes, reverse=True) appends them: what the card draws
    for start, end in sorted(routes, reverse=True):
        full.setdefault(start, []).append(end)
    left = {z: len(v) for z, v in full.items()}  # how many of the card's chips the list still holds
    used = set()  # route indexes walked
    walk, trail, answer = [], [], []
    st = {"built": False}

    def edge(a, b):
        return next(k for k, r in enumerate(routes) if r == [a, b] and k not in used)

    def frame(caption, out_marks=None, node_marks=None, lit_edge=None, trail_marks=None, walk_marks=None,
              result_marks=None, moves=None, **answer_):
        edge_marks = {"dim": sorted(used)}
        if lit_edge is not None:
            edge_marks["lit"] = [lit_edge]
        if answer_:
            edge_marks = {"path": list(range(len(routes)))}
        cards = []
        if st["built"]:
            for z, ends in full.items():
                c = {"key": z, "value": list(ends)}
                if left[z] < len(ends):
                    c["marks"] = {"dim": list(range(left[z], len(ends)))}
                cards.append(c)
        run.frame(caption,
                  zones={"nodeMarks": node_marks or {}, "edgeMarks": edge_marks},
                  out={"entries": cards, "marks": out_marks or {}},
                  trail={**stack(trail), "marks": trail_marks or {}},
                  walk={"values": list(walk), "marks": walk_marks or {}},
                  result={"values": list(answer), "marks": result_marks or {}},
                  moves=moves, **answer_)

    frame({"en": f"{len(routes)} one-way {'street' if len(routes) == 1 else 'streets'}; the walk starts at HUB and "
                 "must use each exactly once.",
           "ko": f"일방통행 길 {len(routes)}개가 있습니다. 산책은 HUB에서 출발해 길마다 정확히 한 번씩 써야 합니다."},
          node_marks={"lit": ["HUB"]})
    st["built"] = True
    order = sorted(routes, reverse=True)
    frame({"en": "Sort the streets largest first and file each under its start zone, so each card ends with its "
                 "smallest street, the one pop() takes.",
           "ko": "길을 큰 것부터 정렬해 출발 구역별로 넣습니다. 그래서 카드마다 가장 작은 길이 끝에 오고, pop() 호출이 그 길을 "
                 "꺼냅니다."},
          moves=[move(at("zones", [a, b]), at("out", a), value=b) for a, b in order])
    trail.append("HUB")
    frame({"en": "The stack starts with HUB, where the dog is.",
           "ko": "스택은 강아지가 있는 HUB 하나로 시작합니다."},
          node_marks={"lit": ["HUB"]}, trail_marks={"good": [0]},
          moves=[move(at("zones", "HUB"), at("trail", 0), value="HUB")])
    while trail:
        top = trail[-1]
        if left.get(top, 0):
            nxt = full[top][left[top] - 1]
            k = edge(top, nxt)
            left[top] -= 1
            others = full[top][:left[top]]
            why = ({"en": f" (smaller than {', '.join(reversed(others))})", "ko": f" ({', '.join(reversed(others))}보다 작음)"}
                   if others else {"en": "", "ko": ""})
            used.add(k)
            trail.append(nxt)
            frame({"en": f"{top} still has a street out: pop its smallest, {nxt}{why['en']}, walk {top} → {nxt}, and "
                         f"push {nxt}.",
                   "ko": f"{top} 구역에 남은 길이 있습니다. 가장 작은 {nxt}{why['ko']} 길을 꺼내 {top} → {nxt} 방향으로 걷고 "
                         f"{nxt} 구역을 스택에 넣습니다."},
                  out_marks={"lit": [top]}, node_marks={"lit": [top], "good": [nxt]}, lit_edge=k,
                  trail_marks={"good": [len(trail) - 1]},
                  moves=[move(at("out", top), at("trail", len(trail) - 1), value=nxt)])
        else:
            walk.append(top)
            rest = len(routes) - len(used)
            if rest:
                cap = {"en": f"{top} has no street left, yet {rest} {'street is' if rest == 1 else 'streets are'} still "
                             "unwalked: it was entered too early, so it must end the walk. Pop it onto the walk, which "
                             "puts it last.",
                       "ko": f"{top} 구역에는 남은 길이 없는데 아직 걷지 않은 길이 {rest}개 있습니다. 너무 일찍 들어온 "
                             "막다른 구역이라 산책의 마지막이어야 하므로, 스택에서 빼 산책 경로에 붙입니다(거꾸로 쌓으니 "
                             "맨 끝이 됩니다)."}
            else:
                cap = {"en": f"{top} has no street left, so it is finished: pop it off the stack onto the walk.",
                       "ko": f"{top} 구역에는 남은 길이 없으므로 끝났습니다. 스택에서 빼 산책 경로에 붙입니다."}
            frame(cap,
                  node_marks={"lit": [top]}, trail_marks={"lit": [len(trail) - 1]},
                  walk_marks={"good": [len(walk) - 1]},
                  moves=[move(at("trail", len(trail) - 1), at("walk", len(walk) - 1))])
            trail.pop()
    answer.extend(walk[::-1])
    printed = driver_list(answer)
    frame({"en": "The stack is empty and every street is walked. Zones were finished last-first, so the walk "
                 "reversed is the route.",
           "ko": "스택이 비었고 모든 길을 걸었습니다. 구역은 마지막 것부터 끝났으므로 경로를 뒤집으면 산책 순서입니다."},
          walk_marks={"lit": list(range(len(walk)))}, result_marks={"good": list(range(len(answer)))},
          moves=[move(at("walk", j), at("result", len(walk) - 1 - j)) for j in range(len(walk))])
    frame({"en": f"Answer {printed}: " + " → ".join(answer) + f", using all {len(routes)} streets once.",
           "ko": f"답은 {printed}입니다. " + " → ".join(answer) + f" 순서로 길 {len(routes)}개를 한 번씩 씁니다."},
          node_marks={"path": list(full) + [z for z in answer if z not in full]},
          result_marks={"path": list(range(len(answer)))}, answer=printed)


for number, sample in enumerate(sample_cases(SLUG), start=1):
    routes = json.loads(sample["input"])
    setup = {"zones": {"nodes": [{"id": z, **({"tag": {"en": "home", "ko": "집"}} if z == "HUB" else {})}
                                 for z in node_order(routes)],
                       "edges": [{"from": a, "to": b} for a, b in routes]}}
    run = sample_run(wt, number, sample, input=f"routes = {sample['input']}", setup=setup)
    solve(routes, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
