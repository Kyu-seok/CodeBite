#!/usr/bin/env python3.12
"""merge-leaderboard-runs' Walkthrough: the reference solution (scripts/replay-solutions/merge-leaderboard-runs.py), a
dummy node and a tail pointer, recording one frame per line of the loop on each sample Test Case: tail's arrow
re-pointed to the smaller front node (with that run's pointer stepping on), then tail moving to it, and at the end
tail's arrow pointed at whatever run is left. Every node keeps its place in one row, runA's nodes then runB's, so the
merged order shows as arrows weaving between the two runs, and the list read from dummy.next is the answer.

    CODEBITE_DB=<database> scripts/walkthroughs/merge-leaderboard-runs.py

writes common/src/main/resources/walkthroughs/merge-leaderboard-runs.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import ListNode, build_list, driver_list, josa, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, linked_list, move, node_id  # noqa: E402

SLUG = "merge-leaderboard-runs"

wt = Walkthrough(
    {"en": "Merge Leaderboard Runs", "ko": "리더보드 기록 합치기"},
    {"en": "tail is the last node of the merged list, starting at a dummy node. Each step points tail's arrow at the "
           "smaller of the two front times and moves tail there; when one run is used up, tail's arrow takes the rest "
           "of the other as it is.",
     "ko": "tail은 합친 리스트의 마지막 노드이고 dummy 노드에서 시작합니다. 매 단계 tail의 화살표를 두 리스트의 맨 앞 기록 "
           "중 작은 쪽으로 돌리고 tail을 그리로 옮깁니다. 한쪽이 바닥나면 tail의 화살표가 다른 쪽의 나머지를 그대로 "
           "가리킵니다."},
    views=[
        {"id": "runs", "type": "linkedlist",
         "title": {"en": "dummy, then runA's nodes, then runB's", "ko": "dummy, runA의 노드, runB의 노드"},
         "empty": {"en": "no nodes", "ko": "노드 없음"}},
        {"id": "result", "type": "output", "title": {"en": "answer", "ko": "답"},
         "empty": {"en": "not read yet", "ko": "아직 없음"}},
    ],
)


def solve(a_values, b_values, run):
    """Solution.mergeRuns with a frame per line. Returns the answer as the Driver prints it."""
    a_nodes, b_nodes = build_list(a_values), build_list(b_values)
    dummy = ListNode("")  # the solution's dummy holds 0; its value is never read, so it is drawn empty
    order = [dummy] + a_nodes + b_nodes
    run_a = a_nodes[0] if a_nodes else None
    run_b = b_nodes[0] if b_nodes else None
    tail = dummy
    ptr = {}

    def nid(node):
        return node_id(order, node)

    def frame(caption, marks, link=None, cut=None, moves=None, result=(), **answer):
        ptr.update(dummy=dummy, tail=tail, runA=run_a, runB=run_b)
        state = {**linked_list(order), "pointers": {k: nid(v) for k, v in ptr.items()}, "marks": marks}
        if link is not None:
            state["linkMarks"] = {"good": [nid(link)]}
        if cut is not None and cut[1] is not None:
            state["cut"] = {nid(cut[0]): nid(cut[1])}
        run.frame(caption, runs=state, result={"values": list(result), "marks": {"path": list(range(len(result)))}},
                  moves=moves, **answer)

    def describe(name, nodes):
        if not nodes:
            return {"en": f"{name} is empty (null)", "ko": f"{name} 리스트는 비어 있고(null)"}
        return {"en": f"{name} holds {driver_list([n.val for n in nodes])}",
                "ko": f"{name} = {driver_list([n.val for n in nodes])}"}

    def name(node):
        return "dummy" if node is dummy else str(node.val)

    da, db = describe("runA", a_nodes), describe("runB", b_nodes)
    frame({"en": f"{da['en']} and {db['en']}. tail starts at a new dummy node, whose arrow is null.",
           "ko": f"{da['ko']}{'' if not a_nodes else ','} {db['ko']}입니다. tail은 화살표가 null인 새 dummy 노드에서 시작합니다."},
          {"lit": [0]})
    while run_a and run_b:
        old = tail.next
        if run_a.val <= run_b.val:
            took, side, other = run_a, "runA", run_b
            cmp = {"en": f"{run_a.val} ≤ {run_b.val}", "ko": f"{run_a.val} ≤ {run_b.val}"}
            tail.next, run_a = run_a, run_a.next
            stepped = run_a
        else:
            took, side, other = run_b, "runB", run_a
            cmp = {"en": f"{run_a.val} > {run_b.val}", "ko": f"{run_a.val} > {run_b.val}"}
            tail.next, run_b = run_b, run_b.next
            stepped = run_b
        if stepped is None:
            on = {"en": f"{side} steps off its end to null", "ko": f"{side} 포인터는 끝을 지나 null이 됩니다"}
        else:
            on = {"en": f"{side} steps to {stepped.val}", "ko": f"{side} 포인터는 {josa(stepped.val, '(으)로')} 갑니다"}
        frame({"en": f"{cmp['en']}, so {took.val} from {side} is next: tail.next = {took.val}, and {on['en']}.",
               "ko": f"{cmp['ko']}이므로 {side}의 {josa(took.val, '이가')} 다음입니다. tail.next = {took.val}이고, "
                     f"{on['ko']}."},
              {"lit": [nid(took), nid(other)]}, link=tail, cut=(tail, old) if old is not took else None)
        tail = tail.next
        frame({"en": f"tail = tail.next: tail moves to {tail.val}, the end of the merged list so far.",
               "ko": f"tail = tail.next: tail이 지금까지 합친 리스트의 끝인 {josa(tail.val, '(으)로')} 옮깁니다."},
              {"lit": [nid(tail)]})
    rest = run_a or run_b
    old = tail.next
    tail.next = rest
    side = "runA" if run_a else "runB"
    if rest is None:
        last = {"en": "Both runs are used up, so tail.next = null.", "ko": "두 리스트가 모두 바닥나 tail.next = null입니다."}
    elif old is rest:
        last = {"en": f"{'runA' if side == 'runB' else 'runB'} is null, so tail.next = {side}: "
                      f"{name(tail)} already points to {rest.val}, and the rest of {side} follows as it is.",
                "ko": f"{'runA' if side == 'runB' else 'runB'} 포인터가 null이므로 tail.next = {side}입니다. {name(tail)}의 "
                      f"화살표는 이미 {josa(rest.val, '을를')} 가리키고, {side}의 나머지가 그대로 이어집니다."}
    else:
        last = {"en": f"{'runA' if side == 'runB' else 'runB'} is null, so tail.next = {side}: "
                      f"{name(tail)} now points to {rest.val}, and the rest of {side} follows as it is.",
                "ko": f"{'runA' if side == 'runB' else 'runB'} 포인터가 null이므로 tail.next = {side}입니다. 이제 "
                      f"{name(tail)}의 화살표가 {josa(rest.val, '을를')} 가리키고, {side}의 나머지가 그대로 이어집니다."}
    frame(last, {"lit": [nid(tail)] + ([nid(rest)] if rest else [])}, link=tail if old is not rest else None,
          cut=(tail, old) if old is not rest else None)
    result, node, chain = [], dummy.next, []
    while node:
        result.append(node.val)
        chain.append(node)
        node = node.next
    printed = driver_list(result)
    tail = run_a = run_b = None
    ptr.clear()
    frame({"en": f"Reading from dummy.next gives the merged list {printed}.",
           "ko": f"dummy.next부터 읽으면 합친 리스트 {printed}입니다."},
          {"path": [nid(c) for c in chain], "dim": [0]}, result=result,
          moves=[move(at("runs", nid(c)), at("result", i)) for i, c in enumerate(chain)], answer=printed)
    return printed


for number, sample in enumerate(sample_cases(SLUG), start=1):
    lines = sample["input"].split("\n")
    a, b = json.loads(lines[0]), json.loads(lines[1])
    run = sample_run(wt, number, sample, input=f"runA = {driver_list(a)}, runB = {driver_list(b)}")
    solve(a, b, run)
wt.write(walkthrough_path(SLUG))
