#!/usr/bin/env python3.12
"""two-menu-sum's Walkthrough: the reference solution (scripts/replay-solutions/two-menu-sum.py), two
pointers walking in from both ends of the sorted menu, recording one frame per pair added up on each sample
Test Case. Both prices move into the sum box; a sum under the budget moves left right (the only way up), one
over it moves right left, and the prices passed over fade outside the span still in play. The pair that
hits the budget moves into the answer as its two menu numbers (1-indexed, tagged on each cell).

    CODEBITE_DB=<database> scripts/walkthroughs/two-menu-sum.py

writes common/src/main/resources/walkthroughs/two-menu-sum.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import driver_list, josa, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move, span  # noqa: E402

SLUG = "two-menu-sum"

wt = Walkthrough(
    {"en": "Two Menu Sum", "ko": "예산 맞춰 두 메뉴 고르기"},
    {"en": "The menu is sorted, so one pointer at each end can steer the sum: too small, and only moving left "
           "right can raise it; too big, and only moving right left can lower it. Each move rules out one price "
           "for good.",
     "ko": "메뉴가 정렬되어 있어 양 끝의 두 포인터로 합을 조절할 수 있습니다. 합이 작으면 left를 오른쪽으로, "
           "크면 right를 왼쪽으로 옮기는 것만이 방법이고, 한 번 옮길 때마다 가격 하나가 후보에서 완전히 빠집니다."},
    views=[
        {"id": "menu", "type": "array",
         "title": {"en": "menuPrice (tag: menu number)", "ko": "menuPrice (태그: 메뉴 번호)"}},
        {"id": "sum", "type": "output", "title": {"en": "left + right vs budget", "ko": "left + right (합) vs 예산"},
         "empty": {"en": "nothing added yet", "ko": "아직 없음"}},
        {"id": "result", "type": "output", "title": {"en": "answer", "ko": "답"},
         "empty": {"en": "empty", "ko": "비어 있음"}},
        {"id": "state", "type": "vars"},
    ],
)


def solve(prices, budget, run):
    """Solution.findMenuPair with a frame per pair added up. Returns the answer as the Driver prints it."""
    n = len(prices)
    left, right = 0, n - 1
    total = None
    result = []
    tags = [[i, f"#{i + 1}"] for i in range(n)]

    def frame(caption, lit=(), path=(), sum_mark=None, moves=None, done=False, **answer):
        run.frame(caption,
                  menu={"values": prices, "tags": tags,
                        "spans": {"live": None if done else
                                  span(left, right, {"en": "still in play", "ko": "남은 후보"}, fade=True)},
                        "pointers": {"left": None if done else left, "right": None if done else right},
                        "marks": {"path": list(path), "lit": list(lit)}},
                  sum={"values": [] if total is None else
                       [f"{total} {'<' if total < budget else '>' if total > budget else '='} {budget}"],
                       "marks": {sum_mark: [0]} if sum_mark and total is not None else {}},
                  result={"values": result, "marks": {"path": list(range(len(result)))} if done else {}},
                  state={"items": [{"label": {"en": "budget", "ko": "budget (예산)"}, "value": budget}]},
                  moves=moves, **answer)

    frame({"en": f"{n} prices, sorted from cheapest. left starts at the cheapest (#1) and right at the dearest "
                 f"(#{n}); the two must add up to the budget, {budget}.",
           "ko": f"가격 {n}개가 싼 것부터 정렬되어 있습니다. left는 가장 싼 #1, right는 가장 비싼 #{n}에서 시작하며, "
                 f"두 가격의 합이 예산 {josa(budget, '과와')} 같아야 합니다."})
    while left < right:
        a, b = prices[left], prices[right]
        total = a + b
        adds = [move(at("menu", left), at("sum", 0), value=a, mark="good"),
                move(at("menu", right), at("sum", 0), value=b, mark="good")]
        said = f"#{left + 1} + #{right + 1}: {a} + {b} = {total}"
        if total == budget:
            frame({"en": f"{said}, exactly the budget.",
                   "ko": f"{said}, 예산과 정확히 같습니다."},
                  lit=[left, right], sum_mark="good", moves=adds)
            result = [left + 1, right + 1]
            frame({"en": f"The pair is menu numbers {left + 1} and {right + 1} (1-indexed), so the answer is "
                         f"{driver_list(result)}.",
                   "ko": f"짝은 메뉴 번호 {left + 1}번과 {right + 1}번(1부터 셈)이고, 답은 {driver_list(result)}입니다."},
                  path=[left, right], sum_mark="path", done=True,
                  moves=[move(at("menu", left), at("result", 0), value=left + 1),
                         move(at("menu", right), at("result", 1), value=right + 1)],
                  answer=driver_list(result))
            return
        if total < budget:
            frame({"en": f"{said} < {budget}. Too small: even the dearest price left can't lift {a} enough, so "
                         f"{a} is out and left steps right.",
                   "ko": f"{said} < {budget}, 너무 작습니다. {a}에 남은 가장 비싼 가격을 더해도 모자라므로 "
                         f"{josa(a, '은는')} 빠지고 left가 오른쪽으로 갑니다."},
                  lit=[left, right], sum_mark="bad", moves=adds)
            left += 1
        else:
            frame({"en": f"{said} > {budget}. Too big: even the cheapest price left is too much with {b}, so "
                         f"{b} is out and right steps left.",
                   "ko": f"{said} > {budget}, 너무 큽니다. {b}에 남은 가장 싼 가격을 더해도 넘치므로 "
                         f"{josa(b, '은는')} 빠지고 right가 왼쪽으로 갑니다."},
                  lit=[left, right], sum_mark="bad", moves=adds)
            right -= 1
    raise SystemExit(f"{SLUG}: no pair adds up to {budget}")


for number, sample in enumerate(sample_cases(SLUG), start=1):
    lines = sample["input"].split("\n")
    prices, budget = json.loads(lines[0]), int(lines[1])
    run = sample_run(wt, number, sample, input=f"menuPrice = {lines[0].strip()}, budget = {budget}")
    solve(prices, budget, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
