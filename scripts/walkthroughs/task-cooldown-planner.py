#!/usr/bin/env python3.12
"""task-cooldown-planner's Walkthrough: the reference solution (scripts/replay-solutions/task-cooldown-planner.py),
slot by slot: a max-heap of each label's jobs left (heapq on negated counts, drawn with the counts, the earlier label
first on a tie) picks what prints, and a printed label waits in a cooldown queue, tagged with the slot it may print
again. heapq's heapify, push and pop are written out as the textbook sift-down and sift-up, one swap per frame; a pop
is one frame, the root leaving and the last node filling it at once, as heappop does. Each slot's job, or an idle
slot, joins the schedule, and the answer is how many slots it took.

    CODEBITE_DB=<database> scripts/walkthroughs/task-cooldown-planner.py

writes common/src/main/resources/walkthroughs/task-cooldown-planner.json.
"""
import json
import os
import sys
from collections import deque

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import driver_list, josa, plural, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, level_order_tree, map_entries, move, swap  # noqa: E402

SLUG = "task-cooldown-planner"
IDLE = "–"

wt = Walkthrough(
    {"en": "Task Cooldown Planner", "ko": "작업 쿨다운 플래너"},
    {"en": "Fill the slots one at a time: print the label with the most jobs left among those not cooling down (a "
           "max-heap of counts), and park it in a queue until n slots have passed. A slot with nothing ready sits "
           "idle; the slots used are the answer.",
     "ko": "슬롯을 하나씩 채웁니다. 쿨다운 중이 아닌 라벨 중 남은 작업이 가장 많은 라벨(개수의 최대 힙)을 인쇄하고, n "
           "슬롯이 지날 때까지 큐에 세워 둡니다. 준비된 라벨이 없는 슬롯은 비워 두고, 쓴 슬롯 수가 답입니다."},
    views=[
        {"id": "jobs", "type": "array", "title": {"en": "jobs", "ko": "jobs (작업)"}},
        {"id": "counts", "type": "map", "title": {"en": "jobs per label", "ko": "라벨별 작업 수"},
         "empty": {"en": "empty", "ko": "비어 있음"}},
        {"id": "heap", "type": "tree", "arity": 2,
         "title": {"en": "max-heap: most jobs left on top (label:count)",
                   "ko": "최대 힙: 남은 작업이 가장 많은 라벨이 맨 위 (라벨:개수)"},
         "empty": {"en": "empty", "ko": "비어 있음"}},
        {"id": "cooldown", "type": "queue",
         "title": {"en": "cooling down (tag: slot it may print again)", "ko": "쿨다운 중 (태그: 다시 인쇄할 수 있는 슬롯)"},
         "empty": {"en": "empty", "ko": "비어 있음"}},
        {"id": "schedule", "type": "output",
         "title": {"en": "slots so far (– idle)", "ko": "지금까지의 슬롯 (– 빈칸)"},
         "empty": {"en": "none yet", "ko": "아직 없음"}},
        {"id": "result", "type": "output", "title": {"en": "answer", "ko": "답"},
         "empty": {"en": "not yet", "ko": "아직 없음"}},
        {"id": "state", "type": "vars"},
    ],
)


def solve(jobs, n, run):
    """Solution.minPrintSlots with heapq written out, a frame per step. Returns the answer as printed."""
    counts = {}
    heap = []          # [count, label], most jobs left on top
    waiting = deque()  # (ready slot, count, label)
    schedule = []
    out = []
    st = {"draw": None, "drawq": None, "jobs": {}, "map": {}, "fresh": False}

    def above(a, b):
        """heapq's order on (-count, label): more jobs left first, then the earlier label."""
        return (-a[0], a[1]) < (-b[0], b[1])

    def name(e):
        return f"{e[1]}:{e[0]}"

    def kname(e, particle):
        """name(e) followed by the Korean particle its count takes."""
        return f"{e[1]}:{josa(e[0], particle)}"

    def frame(caption, marks=None, qmarks=None, moves=None, done=False, **answer):
        shown = st["draw"] if st["draw"] is not None else heap
        q = st["drawq"] if st["drawq"] is not None else list(waiting)
        sched_marks = ({"path": list(range(len(schedule)))} if done else
                       {"good": [len(schedule) - 1]} if st["fresh"] else {})
        run.frame(caption,
                  jobs={"values": jobs, "marks": st["jobs"]},
                  counts={"entries": map_entries(counts), "marks": st["map"]},
                  heap={**level_order_tree([name(e) for e in shown]),
                        "tags": [[j, f"[{j}]"] for j in range(len(shown))], "nodeMarks": marks or {}},
                  cooldown={"values": [f"{w[2]}:{w[1]}" for w in q],
                            "tags": [[i, {"en": f"slot {w[0]}", "ko": f"{w[0]}번 슬롯"}] for i, w in enumerate(q)],
                            "marks": qmarks or {}},
                  schedule={"values": list(schedule), "marks": sched_marks},
                  result={"values": list(out), "marks": {"path": [0]} if out else {}},
                  state={"items": [{"label": "n", "value": n}]},
                  moves=moves, **answer)
        st["fresh"] = False

    def sift_down(j):
        while True:
            best = j
            for c in (2 * j + 1, 2 * j + 2):
                if c < len(heap) and above(heap[c], heap[best]):
                    best = c
            if best == j:
                return
            a, b = heap[j], heap[best]
            heap[j], heap[best] = b, a
            why = ({"en": "has more jobs left than", "ko": "남은 작업이 더 많으므로"} if a[0] != b[0] else
                   {"en": "ties with, and comes before,", "ko": "개수가 같고 알파벳이 앞서므로"})
            frame({"en": f"Sift down: its child {name(b)} at [{best}] {why['en']} {name(a)} at [{j}], so they swap.",
                   "ko": f"아래로 내리기: 자식 [{best}]의 {kname(b, '이가')} [{j}]의 {name(a)}보다 {why['ko']} 자리를 "
                         f"바꿉니다."},
                  marks={"good": [j], "lit": [best]}, moves=swap("heap", j, best, name(a), name(b)))
            j = best

    def sift_up(j):
        while j > 0:
            p = (j - 1) // 2
            if not above(heap[j], heap[p]):
                return
            a, b = heap[j], heap[p]
            heap[j], heap[p] = b, a
            why = ({"en": "has more jobs left than", "ko": "남은 작업이 더 많으므로"} if a[0] != b[0] else
                   {"en": "ties with, and comes before,", "ko": "개수가 같고 알파벳이 앞서므로"})
            frame({"en": f"Sift up: {name(a)} at [{j}] {why['en']} its parent {name(b)} at [{p}], so they swap.",
                   "ko": f"위로 올리기: [{j}]의 {kname(a, '이가')} 부모 [{p}]의 {name(b)}보다 {why['ko']} 자리를 바꿉니다."},
                  marks={"good": [p], "lit": [j]}, moves=swap("heap", j, p, name(a), name(b)))
            j = p

    frame({"en": f"{len(jobs)} jobs, n = {n}: two jobs with the same label need at least {n} "
                 f"{plural(n, 'slot', 'slots')} between them. First count each label's jobs.",
           "ko": f"작업 {len(jobs)}개, n = {n}: 라벨이 같은 두 작업 사이에는 슬롯이 {n}개 이상 있어야 합니다. 먼저 라벨마다 "
                 f"작업 수를 셉니다."})
    for job in jobs:
        counts[job] = counts.get(job, 0) + 1
    st["jobs"] = {"lit": list(range(len(jobs)))}
    st["map"] = {"good": list(counts)}
    frame({"en": "Counter(jobs): each job moves into its label's card. " +
                 ", ".join(f"{k} has {v}" for k, v in counts.items()) + ".",
           "ko": "Counter(jobs): 작업마다 자기 라벨 카드로 들어갑니다. " +
                 ", ".join(f"{k} {v}개" for k, v in counts.items()) + "."},
          moves=[move(at("jobs", i), at("counts", job)) for i, job in enumerate(jobs)])
    st["jobs"] = {"dim": list(range(len(jobs)))}
    st["map"] = {}
    heap.extend([c, label] for label, c in counts.items())
    frame({"en": "Each label goes into the heap list with its count, in the map's order; heapify then sifts each "
                 "parent down, so the label with the most jobs is on top.",
           "ko": "라벨마다 작업 수와 함께 맵의 순서대로 힙 리스트에 넣습니다. 이어서 heapify가 부모를 차례로 아래로 내려, "
                 "작업이 가장 많은 라벨이 맨 위에 옵니다."},
          marks={"good": list(range(len(heap)))},
          moves=[move(at("counts", e[1]), at("heap", j), value=name(e)) for j, e in enumerate(heap)])
    st["map"] = {"dim": list(counts)}
    for j in reversed(range(len(heap) // 2)):
        sift_down(j)

    slot = 0
    while heap or waiting:
        if waiting and waiting[0][0] == slot:
            ready, c, label = waiting[0]
            st["drawq"] = list(waiting)
            heap.append([c, label])
            j = len(heap) - 1
            frame({"en": f"Slot {slot}: {label} has cooled down, so {label}:{c} leaves the queue's front and goes in "
                         f"at the heap's end, [{j}].",
                   "ko": f"{slot}번 슬롯: {label}의 쿨다운이 끝났으므로 {label}:{josa(c, '이가')} 큐 맨 앞에서 나와 힙의 맨 끝 "
                         f"[{j}]에 들어갑니다."},
                  marks={"good": [j]}, qmarks={"lit": [0]},
                  moves=[move(at("cooldown", 0), at("heap", j))])
            waiting.popleft()
            st["drawq"] = None
            sift_up(j)
        if heap:
            top = heap[0]
            c, label = top
            schedule.append(label)
            st["fresh"] = True
            moves = [move(at("heap", 0), at("schedule", len(schedule) - 1), value=label)]
            if c - 1 > 0:
                waiting.append((slot + n + 1, c - 1, label))
                moves.append(move(at("heap", 0), at("cooldown", len(waiting) - 1), value=f"{label}:{c - 1}"))
                then = {"en": f" {c - 1} left, so it waits in the queue until slot {slot + n + 1}.",
                        "ko": f" {c - 1}개가 남아 {slot + n + 1}번 슬롯까지 큐에서 기다립니다."}
            else:
                then = {"en": f" That was {label}'s last job.", "ko": f" {label}의 마지막 작업이었습니다."}
            last = heap.pop()
            if heap:
                k = len(heap)
                heap[0] = last
                st["draw"] = heap + [last]
                moves.append(move(at("heap", k), at("heap", 0)))
                fill = {"en": f" The last node {name(last)} fills the root.",
                        "ko": f" 마지막 노드 {kname(last, '이가')} 루트를 채웁니다."}
                marks = {"good": [0]}
            else:
                st["draw"] = [top]
                fill = {"en": "", "ko": ""}
                marks = {"lit": [0]}
            frame({"en": f"Slot {slot}: the heap's top is {name(top)}, the most jobs left among labels ready, so "
                         f"{label} prints.{then['en']}{fill['en']}",
                   "ko": f"{slot}번 슬롯: 힙의 맨 위 {kname(top, '이가')} 준비된 라벨 중 남은 작업이 가장 많으므로 {label} 작업을 "
                         f"인쇄합니다.{then['ko']}{fill['ko']}"},
                  marks=marks, qmarks={"good": [len(waiting) - 1]} if c - 1 > 0 else {}, moves=moves)
            st["draw"] = None
            sift_down(0)
        else:
            schedule.append(IDLE)
            st["fresh"] = True
            w = waiting[0]
            frame({"en": f"Slot {slot}: the heap is empty, since every label left is cooling down (the next is "
                         f"{w[2]}, at slot {w[0]}), so the slot sits idle.",
                   "ko": f"{slot}번 슬롯: 남은 라벨이 모두 쿨다운 중이라 힙이 비었으므로(다음은 {w[0]}번 슬롯의 "
                         f"{w[2]}) 슬롯을 비워 둡니다."},
                  qmarks={"lit": [0]}, moves=[move(None, at("schedule", len(schedule) - 1), value=IDLE)])
        slot += 1
    out.append(str(slot))
    idle = schedule.count(IDLE)
    frame({"en": f"The heap and the queue are both empty: every job is printed. The schedule used {slot} "
                 f"{plural(slot, 'slot', 'slots')} ({len(jobs)} jobs and {idle} idle), so the answer is {slot}.",
           "ko": f"힙과 큐가 모두 비어 모든 작업을 인쇄했습니다. 슬롯 {slot}개(작업 {len(jobs)}개, 빈칸 {idle}개)를 "
                 f"썼으므로 답은 {slot}입니다."},
          moves=[move(at("schedule", slot - 1), at("result", 0), value=str(slot))], done=True, answer=str(slot))
    return slot


for number, sample in enumerate(sample_cases(SLUG), start=1):
    lines = sample["input"].split("\n")
    jobs, n = json.loads(lines[0]), int(lines[1])
    run = sample_run(wt, number, sample, input=f"jobs = {driver_list(jobs)}, n = {n}")
    solve(jobs, n, run)
wt.write(walkthrough_path(SLUG))
