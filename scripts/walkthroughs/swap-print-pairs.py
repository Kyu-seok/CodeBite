#!/usr/bin/env python3.12
"""swap-print-pairs' Walkthrough: the reference solution (scripts/replay-solutions/swap-print-pairs.py), a dummy node
before the head and a pointer `before` to the node ahead of each pair, recording one frame per line of the loop on each
sample Test Case: naming the pair, the three arrows it re-points (first past second, second back to first, before to
second) and before stepping on. The jobs keep their places in the row, so the swapped order shows in the arrows, and
the list read from dummy.next is the answer.

    CODEBITE_DB=<database> scripts/walkthroughs/swap-print-pairs.py

writes common/src/main/resources/walkthroughs/swap-print-pairs.json.
"""
import json
import os
import sys
from functools import partial

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import ListNode, driver_list, josa, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, linked_list, move, node_id  # noqa: E402

SLUG = "swap-print-pairs"

wt = Walkthrough(
    {"en": "Swap Print Pairs", "ko": "인쇄 작업 짝 바꾸기"},
    {"en": "A dummy node stands before the head, so every pair has a node before it. For each pair, three arrows "
           "change: first skips past second, second points back to first, and the node before points to second.",
     "ko": "head 앞에 dummy 노드를 두어 모든 짝 앞에 노드가 하나씩 있게 합니다. 짝마다 화살표 세 개가 바뀝니다. first는 "
           "second를 건너뛰고, second는 first를 가리키고, 짝 앞의 노드는 second를 가리킵니다."},
    views=[
        {"id": "jobs", "type": "linkedlist", "title": {"en": "print queue from dummy", "ko": "dummy부터의 인쇄 큐"},
         "empty": {"en": "empty queue", "ko": "빈 큐"}},
        {"id": "result", "type": "output", "title": {"en": "answer", "ko": "답"},
         "empty": {"en": "not read yet", "ko": "아직 없음"}},
    ],
)


def solve(values, run):
    """Solution.swapQueuePartners with a frame per line. Returns the answer as the Driver prints it."""
    nodes = [ListNode(v) for v in values]
    for a, b in zip(nodes, nodes[1:]):
        a.next = b
    head = nodes[0] if nodes else None
    dummy = ListNode("")  # the solution's dummy holds 0; its value is never read, so it is drawn empty
    dummy.next = head
    order = [dummy] + nodes
    ptr = {"dummy": dummy, "before": dummy}

    nid = partial(node_id, order)

    def frame(caption, lit=(), link=None, cut=None, marks=None, moves=None, result=(), **answer):
        state = {**linked_list(order), "pointers": {k: nid(v) for k, v in ptr.items()},
                 "marks": marks if marks is not None else {"lit": [nid(n) for n in lit]}}
        if link is not None:
            state["linkMarks"] = {"good": [nid(link)]}
        if cut is not None and cut[1] is not None:
            state["cut"] = {nid(cut[0]): nid(cut[1])}
        run.frame(caption, jobs=state, result={"values": list(result), "marks": {"path": list(range(len(result)))}},
                  moves=moves, **answer)

    if head is None:
        start = {"en": "The queue is empty: dummy.next is null, so there is no pair to swap.",
                 "ko": "큐가 비어 있습니다. dummy.next가 null이므로 바꿀 짝이 없습니다."}
    else:
        start = {"en": f"{len(nodes)} jobs from {head.val} to {nodes[-1].val}. dummy goes before the head {head.val}, "
                       f"and before starts at dummy.",
                 "ko": f"작업 {len(nodes)}개가 {head.val}부터 {nodes[-1].val}까지 이어집니다. head {head.val} 앞에 dummy를 "
                       f"두고, before는 dummy에서 시작합니다."}
    frame(start, lit=[dummy])
    before = dummy
    while before.next and before.next.next:
        first, second = before.next, before.next.next
        ptr.update(first=first, second=second)
        frame({"en": f"before.next and the node after it both exist: the next pair is first = {first.val}, "
                     f"second = {second.val}.",
               "ko": f"before.next와 그다음 노드가 모두 있으므로 다음 짝은 first = {first.val}, second = {second.val}입니다."},
              lit=[first, second])
        after = second.next
        first.next = second.next
        if after is None:
            to = {"en": "null, the end of the queue", "ko": "큐의 끝인 null을 가리킵니다."}
        else:
            to = {"en": str(after.val), "ko": f"{josa(after.val, '을를')} 가리킵니다."}
        frame({"en": f"first.next = second.next: {first.val} now skips {second.val} and points to {to['en']}.",
               "ko": f"first.next = second.next: {josa(first.val, '은는')} {josa(second.val, '을를')} 건너뛰어 "
                     f"{to['ko']}"},
              lit=[first], link=first, cut=(first, second))
        second.next = first
        frame({"en": f"second.next = first: {second.val} now points back to {first.val}.",
               "ko": f"second.next = first: {josa(second.val, '은는')} 이제 {josa(first.val, '을를')} 가리킵니다."},
              lit=[second], link=second, cut=(second, after))
        before.next = second
        name = "dummy" if before is dummy else str(before.val)
        frame({"en": f"before.next = second: {name} now points to {second.val}, so the pair reads {second.val}, "
                     f"{first.val}.",
               "ko": f"before.next = second: {name}의 화살표가 {josa(second.val, '을를')} 가리키므로 이 짝은 "
                     f"{second.val}, {first.val} 순서가 됩니다."},
              lit=[before], link=before, cut=(before, first))
        before = first
        ptr["before"] = before
        if before.next is None:
            left = {"en": "nothing is left after it.", "ko": "그 뒤에는 남은 작업이 없습니다."}
        elif before.next.next is None:
            left = {"en": f"only {before.next.val} is left after it, with no partner.",
                    "ko": f"그 뒤에는 짝이 없는 작업 {before.next.val}만 남았습니다."}
        else:
            left = {"en": f"the next pair starts at {before.next.val}.",
                    "ko": f"다음 짝은 {before.next.val}부터 시작합니다."}
        frame({"en": f"before = first: before steps to {first.val}, now the second of its pair; {left['en']}",
               "ko": f"before = first: before가 이제 짝의 뒤쪽인 {josa(first.val, '(으)로')} 옮깁니다. "
                     f"{left['ko']}"},
              lit=[first])
    result, node = [], dummy.next
    while node:
        result.append(node.val)
        node = node.next
    printed = driver_list(result)
    chain = list(iter_from(dummy.next))
    for name in ("before", "first", "second"):
        ptr.pop(name, None)
    frame({"en": f"No full pair is left, so the loop ends. Reading from dummy.next gives {printed}.",
           "ko": f"온전한 짝이 더 없으므로 반복이 끝납니다. dummy.next부터 읽으면 {printed}입니다."},
          marks={"path": [nid(n) for n in chain], "dim": [0]}, result=result,
          moves=[move(at("jobs", nid(n)), at("result", i)) for i, n in enumerate(chain)], answer=printed)
    return printed


def iter_from(node):
    while node:
        yield node
        node = node.next


for number, sample in enumerate(sample_cases(SLUG), start=1):
    values = json.loads(sample["input"])
    run = sample_run(wt, number, sample, input=f"head = {driver_list(values)}")
    solve(values, run)
wt.write(walkthrough_path(SLUG))
