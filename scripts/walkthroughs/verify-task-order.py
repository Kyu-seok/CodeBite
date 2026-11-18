#!/usr/bin/env python3.12
"""verify-task-order's Walkthrough: the reference solution
(scripts/replay-solutions/verify-task-order.py), Kahn's topological order by in-degree, recording one frame
per prerequisite counted, per task finished, per waiting count lowered and per task that becomes ready on
each sample Test Case. The graph is drawn as the description's Diagram draws it (an arrow from a task to the
task it needs, nodes in the order the edges name them), each node's number under it is how many tasks it
still waits for, the ready tasks are a queue, and each finished task moves into the done list.

    CODEBITE_DB=<database> scripts/walkthroughs/verify-task-order.py

writes common/src/main/resources/walkthroughs/verify-task-order.json.
"""
import json
import os
import sys
from collections import deque

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import josa, plural, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move  # noqa: E402

SLUG = "verify-task-order"

wt = Walkthrough(
    {"en": "Verify Task Order", "ko": "작업 순서 검증"},
    {"en": "Count what each task waits for; a task waiting for nothing is ready, and finishing it lowers the count "
           "of every task that needs it. Every task gets finished exactly when no cycle holds some of them waiting.",
     "ko": "작업마다 기다리는 선행 작업 수를 셉니다. 기다리는 것이 없는 작업은 준비된 것이고, 그 작업을 끝내면 그것이 필요한 "
           "작업들의 수가 줄어듭니다. 순환이 없을 때만 모든 작업이 끝납니다."},
    views=[
        {"id": "tasks", "type": "graph", "directed": True,
         "title": {"en": "tasks (arrow: needs; under: waiting for)", "ko": "작업 (화살표: 필요함, 아래: 기다리는 수)"}},
        {"id": "ready", "type": "queue", "title": {"en": "ready", "ko": "ready (준비된 작업)"},
         "empty": {"en": "empty", "ko": "비어 있음"}},
        {"id": "done", "type": "output", "title": {"en": "finished, in order", "ko": "끝낸 작업 (순서대로)"},
         "empty": {"en": "none yet", "ko": "아직 없음"}},
    ],
)


def node_order(n, prereqs):
    """The nodes as the description's graph Diagram places them: in the order the edges name them, then the rest."""
    order = []
    for a, b in prereqs:
        for v in (a, b):
            if v not in order:
                order.append(v)
    return order + [v for v in range(n) if v not in order]


def solve(n, prereqs, run):
    """Solution.canFinishAllTasks with a frame per step. Returns the answer as the Driver prints it."""
    unlocks = [[] for _ in range(n)]
    waiting = [0] * n
    edge_index = {(a, b): i for i, (a, b) in enumerate(prereqs)}
    finished = []
    ready = deque()
    leaving = None  # the front, drawn for the frame it leaves

    def frame(caption, node_lit=(), node_good=(), node_bad=(), node_path=(), edge_lit=(), edge_bad=(),
              queue_lit=(), queue_good=(), moves=None, **answer):
        shown = ([leaving] if leaving is not None else []) + list(ready)
        run.frame(caption,
                  tasks={"nodes": [{"id": v, "tag": {"en": f"#{finished.index(v) + 1}", "ko": f"{finished.index(v) + 1}번째"}}
                                   if v in finished else {"id": v} for v in node_order(n, prereqs)],
                         "values": {str(v): waiting[v] for v in range(n)},
                         "nodeMarks": {"dim": list(finished) if not node_path else [], "path": list(node_path),
                                       "bad": list(node_bad), "good": list(node_good), "lit": list(node_lit)},
                         "edgeMarks": {"bad": list(edge_bad), "lit": list(edge_lit)}},
                  ready={"values": shown, "marks": {"lit": list(queue_lit), "good": list(queue_good)}},
                  done={"values": list(finished), "marks": {"path": list(range(len(finished)))} if node_path else {}},
                  moves=moves, **answer)

    m = len(prereqs)
    frame({"en": f"{n} {plural(n, 'task', 'tasks')} and {m} {plural(m, 'prerequisite', 'prerequisites')}: an arrow "
                 f"a → b means task a needs b finished first. First count what each task waits for.",
           "ko": f"작업 {n}개와 선행 조건 {m}개이며, 화살표 a → b는 작업 a가 b를 먼저 끝내야 한다는 뜻입니다. "
                 f"먼저 작업마다 기다리는 수를 셉니다."})
    for task, before in prereqs:
        unlocks[before].append(task)
        waiting[task] += 1
        frame({"en": f"[{task},{before}]: task {task} needs {before}, so it now waits for "
                     f"{waiting[task]} {plural(waiting[task], 'task', 'tasks')}.",
               "ko": f"[{task},{before}]: 작업 {josa(task, '이가')} {josa(before, '을를')} 필요로 하므로 이제 "
                     f"{waiting[task]}개를 기다립니다."},
              edge_lit=[edge_index[(task, before)]], node_good=[task],
              moves=[move(at("tasks", [task, before]), at("tasks", task), value="+1")])
    for task in range(n):
        if waiting[task] == 0:
            ready.append(task)
    if ready:
        names = ", ".join(map(str, ready))
        frame({"en": f"Task{'s' if len(ready) > 1 else ''} {names} wait{'' if len(ready) > 1 else 's'} for nothing, "
                     f"so {'they join' if len(ready) > 1 else 'it joins'} the ready queue.",
               "ko": f"작업 {names}: 기다리는 것이 없으므로 준비 큐에 들어갑니다."},
              queue_good=range(len(ready)),
              moves=[move(at("tasks", t), at("ready", q), value=str(t)) for q, t in enumerate(ready)])
    else:
        frame({"en": "Every task waits for another, so nothing is ready to start.",
               "ko": "모든 작업이 다른 작업을 기다리므로 시작할 수 있는 작업이 없습니다."},
              node_bad=range(n))
    while ready:
        task = ready.popleft()
        leaving = task
        finished.append(task)
        frame({"en": f"Take task {task} from the front of ready and finish it: "
                     f"{len(finished)} of {n} done.",
               "ko": f"ready 앞에서 작업 {josa(task, '을를')} 꺼내 끝냅니다: {n}개 중 {len(finished)}개 완료."},
              queue_lit=[0], node_lit=[task], moves=[move(at("ready", 0), at("done", len(finished) - 1))])
        leaving = None
        if not unlocks[task]:
            continue
        for unlocked in unlocks[task]:
            waiting[unlocked] -= 1
            left = waiting[unlocked]
            frame({"en": f"Task {unlocked} needed {task}, so it waits for one fewer: {left} left."
                         + (" It can start now." if left == 0 else ""),
                   "ko": f"작업 {josa(unlocked, '이가')} {josa(task, '을를')} 필요로 했으므로 기다리는 수가 하나 줄어 "
                         f"{left}개입니다." + (" 이제 시작할 수 있습니다." if left == 0 else "")},
                  edge_lit=[edge_index[(unlocked, task)]], node_good=[unlocked],
                  moves=[move(at("tasks", [unlocked, task]), at("tasks", unlocked), value="−1")])
            if left == 0:
                ready.append(unlocked)
                frame({"en": f"Task {unlocked} waits for nothing now: it joins the back of ready.",
                       "ko": f"작업 {josa(unlocked, '은는')} 이제 기다리는 것이 없어 ready 뒤에 들어갑니다."},
                      queue_good=[len(ready) - 1],
                      moves=[move(at("tasks", unlocked), at("ready", len(ready) - 1), value=str(unlocked))])
    if len(finished) == n:
        order = " → ".join(map(str, finished))
        frame({"en": f"ready is empty and all {n} tasks are finished, in the order {order}: true.",
               "ko": f"ready가 비었고 작업 {n}개를 모두 {order} 순서로 끝냈습니다: true."},
              node_path=range(n), answer="true")
    else:
        stuck = [v for v in range(n) if waiting[v] > 0]
        cycle_edges = [i for i, (a, b) in enumerate(prereqs) if a in stuck and b in stuck]
        frame({"en": f"ready is empty with only {len(finished)} of {n} tasks finished: tasks "
                     f"{', '.join(map(str, stuck))} wait on each other in a cycle, so they can never start: false.",
               "ko": f"ready가 비었지만 작업 {n}개 중 {len(finished)}개만 끝났습니다. 작업 {', '.join(map(str, stuck))}: "
                     f"서로를 순환으로 기다려 영영 시작할 수 없으므로 false입니다."},
              node_bad=stuck, edge_bad=cycle_edges, answer="false")


for number, sample in enumerate(sample_cases(SLUG), start=1):
    lines = sample["input"].split("\n")
    n, prereqs = int(lines[0]), json.loads(lines[1])
    run = sample_run(wt, number, sample, input=f"numTasks = {n}, prereqs = {lines[1].strip()}",
                     setup={"tasks": {"edges": [{"from": a, "to": b} for a, b in prereqs]}})
    solve(n, prereqs, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
