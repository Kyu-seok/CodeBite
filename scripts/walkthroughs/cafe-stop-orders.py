#!/usr/bin/env python3.12
"""cafe-stop-orders's Walkthrough: the reference solution (scripts/replay-solutions/cafe-stop-orders.py),
backtracking one stop per call: build() appends each cafe not yet used to the order, calls itself, and takes it back
off; a full order is one answer. The calls are drawn as a recursion tree grown one call per frame (views.md,
recursion): one node per call holding its order so far, the edge into it labelled with the cafe added; the calls still
open are shaded and each full order moves into the answer. On the stops, the cafes already in the current order are
faded, so the ones the call may still add stand out.

    CODEBITE_DB=<database> scripts/walkthroughs/cafe-stop-orders.py

writes common/src/main/resources/walkthroughs/cafe-stop-orders.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import driver_list, plural, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Tree, Walkthrough, at, move  # noqa: E402

SLUG = "cafe-stop-orders"

wt = Walkthrough(
    {"en": "Cafe Stop Orders", "ko": "카페 투어 순서 짜기"},
    {"en": "Build each order one stop at a time: a call adds each cafe the order doesn't hold yet, calls itself for the "
           "next stop, then takes that cafe back off to try the next. Every full order is one answer: n! of them.",
     "ko": "방문 순서를 한 곳씩 만듭니다. 호출마다 아직 순서에 없는 카페를 하나 붙이고 다음 곳을 위해 자신을 호출한 뒤, 그 카페를 "
           "다시 빼고 다음 카페를 시도합니다. 다 찬 순서가 답 하나이며, 모두 n!개입니다."},
    views=[
        {"id": "stops", "type": "array", "title": {"en": "stops", "ko": "stops (카페 ID)"}},
        {"id": "calls", "type": "tree", "title": {"en": "calls (the order so far)", "ko": "호출 (지금까지의 순서)"}},
        {"id": "result", "type": "output", "title": {"en": "visit orders", "ko": "방문 순서"},
         "empty": {"en": "none yet", "ko": "아직 없음"}},
    ],
)


def listed(values):
    return ", ".join(map(str, values))


def solve(stops, run):
    """Solution.listVisitOrders with a frame per call. Returns the answer as the Driver prints it."""
    tree, orders, open_calls = Tree(), [], []
    order, used = [], [False] * len(stops)
    full = []

    def frame(caption, lit=None, moves=None, done=False, **answer):
        run.frame(caption,
                  stops={"values": stops, "marks": {} if done else {"dim": [i for i, u in enumerate(used) if u]}},
                  calls={**tree.state(), "nodeMarks": {"path": list(full)} if done else {"good": list(full), "lit": [lit]},
                         "shade": [] if done else list(open_calls)},
                  result={"values": [driver_list(o) for o in orders],
                          "marks": {"path": list(range(len(orders)))} if done else
                          {"good": [len(orders) - 1]} if any(m.get("to", {}).get("view") == "result" for m in moves or [])
                          else {}},
                  moves=moves, **answer)

    def build(parent, taken):
        node = tree.add(driver_list(order), parent=parent, label=None if taken is None else str(stops[taken]))
        open_calls.append(node)
        moves = [move(dst=at("calls", node))] if taken is None else [move(at("stops", taken), at("calls", node))]
        left = [s for i, s in enumerate(stops) if not used[i]]
        if taken is None:
            head = {"en": "The first call starts with an empty order",
                    "ko": "첫 호출은 빈 순서에서 시작합니다"}
        else:
            head = {"en": f"Add cafe {stops[taken]}: the order is {driver_list(order)}",
                    "ko": f"{stops[taken]}번 카페를 붙입니다(순서 {driver_list(order)})"}
        if len(order) == len(stops):
            orders.append(order.copy())
            full.append(node)
            moves.append(move(at("calls", node), at("result", len(orders) - 1)))
            frame({"en": head["en"] + (", every cafe is in it" if stops else ", which already holds every cafe (none)")
                         + ", so it is a full visit order and goes into the answer.",
                   "ko": head["ko"] + ". 모든 카페가 들어 있는 완성된 순서이므로 답에 넣습니다."},
                  node, moves)
            open_calls.pop()
            return
        if len(left) == 1:
            frame({"en": head["en"] + f"; only cafe {left[0]} is left, so it adds that.",
                   "ko": head["ko"] + f". 남은 카페는 {left[0]}번뿐이니 그 카페를 붙입니다."},
                  node, moves)
        else:
            frame({"en": head["en"] + f"; it will try cafes {listed(left)} in turn for the next stop.",
                   "ko": head["ko"] + f". 다음 곳으로 {listed(left)}번 카페를 차례로 붙여 봅니다."},
                  node, moves)
        for i, stop in enumerate(stops):
            if used[i]:
                continue
            used[i] = True
            order.append(stop)
            build(node, i)
            order.pop()
            used[i] = False
        open_calls.pop()

    build(None, None)
    printed = json.dumps(sorted(orders), separators=(",", ":"))
    n, k = len(orders), len(stops)
    frame({"en": f"Every call has returned: {n} {plural(n, 'order', 'orders')} of {k} {plural(k, 'cafe', 'cafes')}, "
                 f"{k}! = {n}, one per leaf of the tree.",
           "ko": f"모든 호출이 끝났습니다. 카페 {k}곳의 방문 순서는 {k}! = {n}가지로, 트리의 잎 하나가 순서 하나입니다."},
          done=True, answer=printed)
    return printed


for number, sample in enumerate(sample_cases(SLUG), start=1):
    stops = json.loads(sample["input"])
    run = sample_run(wt, number, sample, input=f"stops = {driver_list(stops)}")
    solve(stops, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
