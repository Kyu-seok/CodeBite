#!/usr/bin/env python3.12
"""count-task-orderings' Walkthrough: the reference solution (scripts/replay-solutions/count-task-orderings.py),
n! divided by every subtree's size, recording one frame per step that changes something on each sample Test Case.

The parents are drawn as the tree they form, beside four arrays: the input, the breadth-first order (padded with
"" to n), each task's subtree size, and the three numbers the answer is made of (n!, the product of the sizes and
the answer), tagged with their names. The order grows one frame per task with children, each child moving in from
its node; each size adds into its parent's walking that order backwards; the factorial is one frame (the loop has
no place on the data to move from); each size multiplies into the product one frame each; and the last frame
divides, modulo the prime, by multiplying with the product's inverse.

    CODEBITE_DB=<database> scripts/walkthroughs/count-task-orderings.py

writes common/src/main/resources/walkthroughs/count-task-orderings.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import driver_list, josa, plural, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move  # noqa: E402

SLUG = "count-task-orderings"
MOD = 10**9 + 7
FACT, PROD, ANS = 0, 1, 2

wt = Walkthrough(
    {"en": "Count Task Orderings", "ko": "유효한 작업 순서 개수"},
    {"en": "Without the rule there are n! orders. Within each subtree its root must come first, which only 1 in "
           "size of its orders do, and the subtrees' chances are independent: divide n! by every subtree's size.",
     "ko": "규칙이 없으면 순서는 n!가지입니다. 각 서브트리 안에서는 루트가 가장 먼저 와야 하는데, 그런 순서는 "
           "크기분의 1이고 서브트리마다 독립입니다. 그래서 n!을 모든 서브트리 크기로 나눕니다."},
    views=[
        {"id": "parent", "type": "array", "title": {"en": "parent", "ko": "parent (부모 작업)"}},
        {"id": "tasks", "type": "tree", "title": {"en": "the task tree", "ko": "작업 트리"}},
        {"id": "order", "type": "array", "title": {"en": "breadth-first order", "ko": "order (너비 우선 순서)"}},
        {"id": "size", "type": "array", "title": {"en": "subtree size per task", "ko": "size (작업별 서브트리 크기)"}},
        {"id": "calc", "type": "array", "title": {"en": "n! / product of sizes", "ko": "n! / 크기의 곱"}},
    ],
)
CALC_TAGS = [[FACT, "n!"], [PROD, "∏ size"], [ANS, {"en": "answer", "ko": "답"}]]


def solve(parent, run):
    """Solution.countTaskOrders with a frame per change."""
    n = len(parent)
    children = [[] for _ in range(n)]
    for task in range(1, n):
        children[parent[task]].append(task)
    order = [0]
    size = [1] * n
    calc = [1, 1, ""]

    def frame(caption, ptr=None, parent_marks=None, node_marks=None, order_marks=None, size_marks=None,
              calc_marks=None, moves=None, **answer):
        run.frame(caption,
                  parent={"values": parent, "marks": parent_marks or {}},
                  tasks={"nodeMarks": node_marks or {}},
                  order={"values": order + [""] * (n - len(order)), "pointers": {"task": ptr},
                         "marks": order_marks or {}, "unread": list(range(len(order), n))},
                  size={"values": list(size), "marks": size_marks or {}},
                  calc={"values": list(calc), "tags": CALC_TAGS, "marks": calc_marks or {}},
                  moves=moves, **answer)

    frame({"en": f"{n} {plural(n, 'task', 'tasks')}; each parent link is an edge, so they form a tree rooted at "
                 "task 0. Every size starts at 1, the task itself, and both products at 1.",
           "ko": f"작업이 {n}개이고, 부모 관계가 간선이 되어 작업 0을 루트로 하는 트리를 이룹니다. 크기는 모두 "
                 "자기 자신인 1, 두 곱도 1에서 시작합니다."},
          parent_marks={"lit": list(range(n))}, node_marks={"lit": [0]})
    pos = 0
    while pos < len(order):
        task = order[pos]
        kids = children[task]
        start = len(order)
        order.extend(kids)
        if kids:
            names = ", ".join(map(str, kids))
            frame({"en": f"Task {task} is next in the order; its {plural(len(kids), 'child', 'children')} "
                         f"{names} join the end, so parents always come before their children.",
                   "ko": f"순서에서 다음은 작업 {task}입니다. 자식 {names}번이 뒤에 붙으므로 부모가 늘 자식보다 "
                         "앞에 옵니다."},
                  ptr=pos, node_marks={"lit": [task], "good": kids},
                  order_marks={"lit": [pos], "good": list(range(start, len(order)))},
                  moves=[move(at("tasks", k), at("order", start + j), value=str(k)) for j, k in enumerate(kids)])
        pos += 1
    for pos in range(n - 1, 0, -1):
        task = order[pos]
        p = parent[task]
        before = size[p]
        size[p] += size[task]
        frame({"en": f"Walking the order backwards, task {task}'s subtree is complete with size {size[task]}. "
                     f"It adds into its parent, task {p}: {before} + {size[task]} = {size[p]}.",
               "ko": f"순서를 거꾸로 걸으면 작업 {task}의 서브트리는 크기 {josa(size[task], '(으)로')} "
                     f"완성됩니다. 부모인 작업 {p}에 더합니다: {before} + {size[task]} = {size[p]}.",
               },
              ptr=pos, node_marks={"lit": [task], "good": [p]}, order_marks={"lit": [pos]},
              size_marks={"lit": [task], "good": [p]},
              moves=[move(at("size", task), at("size", p), value=f"+{size[task]}")])
    factorial = 1
    for i in range(2, n + 1):
        factorial = factorial * i % MOD
    calc[FACT] = factorial
    steps = "×".join(str(i) for i in range(1, n + 1))
    frame({"en": f"Ignoring the parents, {n} tasks can go in {n}! = {steps} = {factorial} orders "
                 "(kept modulo 10^9 + 7).",
           "ko": f"부모를 무시하면 작업 {n}개의 순서는 {n}! = {steps} = {factorial}가지입니다(10^9 + 7로 나눈 "
                 "나머지로 계산)."},
          calc_marks={"good": [FACT]}, moves=[move(None, at("calc", FACT), value=f"{n}!")])
    for task in range(n):
        before = calc[PROD]
        calc[PROD] = before * size[task] % MOD
        s = size[task]
        if s == 1:
            caption = {"en": f"Task {task}'s subtree is just itself, size 1: it is first among itself in every order. "
                             f"The product of sizes stays {before} × 1 = {calc[PROD]}.",
                       "ko": f"작업 {task}의 서브트리는 자기 자신뿐인 크기 1이라 어느 순서에서나 조건을 만족합니다. "
                             f"크기의 곱은 {before} × 1 = {calc[PROD]} 그대로입니다."}
        else:
            caption = {"en": f"Task {task}'s subtree has {s} tasks, and task {task} must come first among them: "
                             f"1 in {s}. The product of sizes becomes {before} × {s} = {calc[PROD]}.",
                       "ko": f"작업 {task}의 서브트리에는 작업이 {s}개 있고 그중 작업 {josa(task, '이가')} 먼저 와야 "
                             f"하므로 {s}분의 1입니다. 크기의 곱은 {before} × {s} = {calc[PROD]}입니다."}
        frame(caption,
              node_marks={"lit": [task]}, size_marks={"lit": [task]}, calc_marks={"good": [PROD]},
              moves=[move(at("size", task), at("calc", PROD), value=f"×{s}")])
    answer = calc[FACT] * pow(calc[PROD], MOD - 2, MOD) % MOD
    calc[ANS] = answer
    frame({"en": f"Divide: {calc[FACT]} / {calc[PROD]} = {answer}. Modulo the prime 10^9 + 7, dividing is multiplying "
                 f"by {calc[PROD]}^(10^9 + 5), which gives the same {answer}.",
           "ko": f"나눕니다: {calc[FACT]} / {calc[PROD]} = {answer}. 소수 10^9 + 7로 나눈 나머지에서는 "
                 f"{calc[PROD]}의 (10^9 + 5)제곱을 곱하는 것이 나누기와 같아 똑같이 {answer}입니다."},
          calc_marks={"path": [ANS]},
          moves=[move(at("calc", FACT), at("calc", ANS)), move(at("calc", PROD), at("calc", ANS), value=f"/{calc[PROD]}")],
          answer=str(answer))


for number, sample in enumerate(sample_cases(SLUG), start=1):
    parent = json.loads(sample["input"])
    setup = {"tasks": {"nodes": [{"id": t, "value": t} for t in range(len(parent))],
                       "edges": [{"from": parent[t], "to": t} for t in range(1, len(parent))]}}
    run = sample_run(wt, number, sample, input=f"parent = {driver_list(parent)}", setup=setup)
    solve(parent, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
