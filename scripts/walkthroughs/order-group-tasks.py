#!/usr/bin/env python3.12
"""order-group-tasks' Walkthrough: the reference solution
(scripts/replay-solutions/order-group-tasks.py), Kahn's topological order by in-degree, recording one frame
per prerequisite counted, per task taken into the order, per waiting count lowered and per task that becomes
ready on each sample Test Case. The graph is drawn as the description's Diagram draws it (an arrow from a task
to the task it waits on, nodes in the order the edges name them), each node's number under it is how many
tasks it still waits on, the ready tasks are a queue, and each task taken moves into the order returned. The
judge prints VALID for a right order, so every run's answer is VALID.

    CODEBITE_DB=<database> scripts/walkthroughs/order-group-tasks.py

writes common/src/main/resources/walkthroughs/order-group-tasks.json.
"""
import json
import os
import sys
from collections import deque
from functools import partial

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import driver_list, josa, plural, sample_cases, sample_run, task_frame, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move  # noqa: E402

SLUG = "order-group-tasks"

wt = Walkthrough(
    {"en": "Order the Group Tasks", "ko": "조별 과제 순서 정하기"},
    {"en": "Count what each task waits on; a task waiting on nothing is ready to go next in the order, and placing it "
           "lowers the count of every task that waits on it. The order holds every task exactly when no cycle holds "
           "some of them waiting.",
     "ko": "과제마다 기다리는 선행 과제 수를 셉니다. 기다리는 것이 없는 과제는 순서의 다음 자리에 올 수 있고, 그 과제를 "
           "놓으면 그것을 기다리는 과제들의 수가 줄어듭니다. 사이클이 없을 때만 모든 과제가 순서에 들어갑니다."},
    views=[
        {"id": "tasks", "type": "graph", "directed": True,
         "title": {"en": "tasks (arrow: waits on; under: how many)", "ko": "과제 (화살표: 기다림, 아래: 기다리는 수)"}},
        {"id": "ready", "type": "queue", "title": {"en": "ready", "ko": "ready (준비된 과제)"},
         "empty": {"en": "empty", "ko": "비어 있음"}},
        {"id": "done", "type": "output", "title": {"en": "order", "ko": "order (순서)"},
         "empty": {"en": "none yet", "ko": "아직 없음"}},
    ],
)


def solve(n, prereqs, run):
    """Solution.findTaskOrder with a frame per step. Returns the answer as the Driver prints it."""
    unlocks = [[] for _ in range(n)]
    waiting = [0] * n
    edge_index = {(a, b): i for i, (a, b) in enumerate(prereqs)}
    finished = []
    ready = deque()

    frame = partial(task_frame, run, n, prereqs, waiting, finished, ready)

    m = len(prereqs)
    frame({"en": f"{n} {plural(n, 'task', 'tasks')} and {m} {plural(m, 'prerequisite', 'prerequisites')}: an arrow "
                 f"a → b means task a waits on b. First count what each task waits on.",
           "ko": f"과제 {n}개와 선행 관계 {m}개이며, 화살표 a → b는 과제 a가 b를 기다린다는 뜻입니다. "
                 f"먼저 과제마다 기다리는 수를 셉니다."})
    for task, before in prereqs:
        unlocks[before].append(task)
        waiting[task] += 1
        frame({"en": f"[{task},{before}]: task {task} waits on {before}, so it now waits on "
                     f"{waiting[task]} {plural(waiting[task], 'task', 'tasks')}.",
               "ko": f"[{task},{before}]: 과제 {josa(task, '이가')} 과제 {josa(before, '을를')} 기다리므로 이제 "
                     f"{waiting[task]}개를 기다립니다."},
              edge_lit=[edge_index[(task, before)]], node_good=[task],
              moves=[move(at("tasks", [task, before]), at("tasks", task), value="+1")])
    for task in range(n):
        if waiting[task] == 0:
            ready.append(task)
    if ready:
        names = ", ".join(map(str, ready))
        frame({"en": f"Task{'s' if len(ready) > 1 else ''} {names} wait{'' if len(ready) > 1 else 's'} on nothing, "
                     f"so {'they join' if len(ready) > 1 else 'it joins'} the ready queue.",
               "ko": f"과제 {names}: 기다리는 것이 없으므로 ready 큐에 들어갑니다."},
              queue_good=range(len(ready)),
              moves=[move(at("tasks", t), at("ready", q), value=str(t)) for q, t in enumerate(ready)])
    else:
        frame({"en": "Every task waits on another, so nothing is ready to start.",
               "ko": "모든 과제가 다른 과제를 기다리므로 시작할 수 있는 과제가 없습니다."},
              node_bad=range(n))
    while ready:
        task = ready.popleft()
        finished.append(task)
        frame({"en": f"Take task {task} from the front of ready and append it to the order: "
                     f"{len(finished)} of {n} placed.",
               "ko": f"ready 앞에서 과제 {josa(task, '을를')} 꺼내 order 끝에 붙입니다. {n}개 중 {len(finished)}개를 놓았습니다."},
              queue_lit=[0], node_lit=[task], moves=[move(at("ready", 0), at("done", len(finished) - 1))],
              leaving=task)  # the front, drawn for the frame it leaves
        if not unlocks[task]:
            continue
        for unlocked in unlocks[task]:
            waiting[unlocked] -= 1
            left = waiting[unlocked]
            frame({"en": f"Task {unlocked} waited on {task}, so it waits on one fewer: {left} left."
                         + (" It can start now." if left == 0 else ""),
                   "ko": f"과제 {josa(unlocked, '이가')} 과제 {josa(task, '을를')} 기다렸으므로 기다리는 수가 하나 줄어 "
                         f"{left}개입니다." + (" 이제 시작할 수 있습니다." if left == 0 else "")},
                  edge_lit=[edge_index[(unlocked, task)]], node_good=[unlocked],
                  moves=[move(at("tasks", [unlocked, task]), at("tasks", unlocked), value="−1")])
            if left == 0:
                ready.append(unlocked)
                frame({"en": f"Task {unlocked} waits on nothing now: it joins the back of ready.",
                       "ko": f"과제 {josa(unlocked, '은는')} 이제 기다리는 것이 없어 ready 뒤에 들어갑니다."},
                      queue_good=[len(ready) - 1],
                      moves=[move(at("tasks", unlocked), at("ready", len(ready) - 1), value=str(unlocked))])
    if len(finished) == n:
        frame({"en": f"ready is empty and all {n} tasks are placed: return {driver_list(finished)}. Each task comes "
                     f"after the tasks it waits on, so the judge prints VALID.",
               "ko": f"ready가 비었고 과제 {n}개를 모두 놓았으므로 {driver_list(finished)} 순서를 반환합니다. 모든 과제가 "
                     f"기다리는 과제보다 뒤에 오므로 채점기는 VALID를 출력합니다."},
              node_path=range(n), answer="VALID")
    else:
        stuck = [v for v in range(n) if waiting[v] > 0]
        cycle_edges = [i for i, (a, b) in enumerate(prereqs) if a in stuck and b in stuck]
        frame({"en": f"ready is empty with only {len(finished)} of {n} tasks placed: tasks "
                     f"{', '.join(map(str, stuck))} wait on each other in a cycle, so return []. The judge finds the "
                     f"cycle too and prints VALID.",
               "ko": f"ready가 비었지만 과제 {n}개 중 {len(finished)}개만 놓았습니다. 과제 {', '.join(map(str, stuck))}: "
                     f"서로를 사이클로 기다리므로 빈 배열을 반환하고, 채점기도 사이클을 확인해 VALID를 출력합니다."},
              node_bad=stuck, edge_bad=cycle_edges, answer="VALID")

for number, sample in enumerate(sample_cases(SLUG), start=1):
    lines = sample["input"].split("\n")
    n, prereqs = int(lines[0]), json.loads(lines[1])
    run = sample_run(wt, number, sample, input=f"numTasks = {n}, prereqs = {lines[1].strip()}",
                     setup={"tasks": {"edges": [{"from": a, "to": b} for a, b in prereqs]}})
    solve(n, prereqs, run)
# No sample has a cycle: an extra run where tasks 2 and 3 wait on each other, so the order stops at 2 of 4.
n, prereqs = 4, [[1, 0], [2, 1], [3, 2], [2, 3]]
run = wt.run({"en": "Extra: with a cycle", "ko": "추가: 사이클이 있을 때"}, input=f"numTasks = {n}, prereqs = {driver_list(prereqs)}",
             expected="VALID", extra=True, setup={"tasks": {"edges": [{"from": a, "to": b} for a, b in prereqs]}})
solve(n, prereqs, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
