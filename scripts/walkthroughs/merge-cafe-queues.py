#!/usr/bin/env python3.12
"""merge-cafe-queues' Walkthrough: the reference solution (scripts/replay-solutions/merge-cafe-queues.py), a min-heap
of each queue's front node, run on each sample Test Case with heapq's heapify, push and pop written out as the textbook
sift-down and sift-up, one swap per frame (the heap pops the same entries in the same order). Every node keeps its
place in one row, the queues one after another behind a dummy node; each pop re-points tail's arrow at the smallest
front and moves tail there, and that node's next joins the heap. The heap is a tree, each entry its time tagged with
its queue, and the list read from dummy.next is the answer.

    CODEBITE_DB=<database> scripts/walkthroughs/merge-cafe-queues.py

writes common/src/main/resources/walkthroughs/merge-cafe-queues.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import ListNode, driver_list, josa, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, level_order_tree, linked_list, move, node_id, swap  # noqa: E402

SLUG = "merge-cafe-queues"

wt = Walkthrough(
    {"en": "Merge Cafe Queues", "ko": "카페 주문 큐 합치기"},
    {"en": "A min-heap holds the front node of every queue, so its top is the earliest pickup left. Each step pops it, "
           "links it after tail, and pushes the node behind it in its queue, until the heap is empty.",
     "ko": "최소 힙에 각 큐의 맨 앞 노드를 넣어 두면, 힙의 맨 위가 남은 것 중 가장 이른 픽업입니다. 매 단계 그 노드를 꺼내 "
           "tail 뒤에 잇고, 같은 큐에서 그 뒤에 있던 노드를 힙에 넣습니다. 힙이 빌 때까지 반복합니다."},
    views=[
        {"id": "nodes", "type": "linkedlist",
         "title": {"en": "dummy, then each queue's nodes", "ko": "dummy와 각 큐의 노드"},
         "empty": {"en": "no nodes", "ko": "노드 없음"}},
        {"id": "heap", "type": "tree", "arity": 2,
         "title": {"en": "heap: the smallest front on top", "ko": "힙: 맨 위가 가장 작은 앞 노드"},
         "empty": {"en": "empty", "ko": "비어 있음"}},
        {"id": "result", "type": "output", "title": {"en": "answer", "ko": "답"},
         "empty": {"en": "not read yet", "ko": "아직 없음"}},
    ],
)


def solve(queues, run):
    """Solution.mergeCafeQueues with a frame per step. Returns the answer as the Driver prints it."""
    heads, order = [], []
    dummy = ListNode("")  # the solution's dummy holds 0; its value is never read, so it is drawn empty
    order.append(dummy)
    for values in queues:
        nodes = [ListNode(v) for v in values]
        for a, b in zip(nodes, nodes[1:]):
            a.next = b
        order.extend(nodes)
        heads.append(nodes[0] if nodes else None)
    heap = []
    st = {"tail": dummy, "draw": None}

    def nid(node):
        return node_id(order, node)

    def q(i):
        return f"q{i}"

    def frame(caption, list_marks=None, heap_marks=None, link=None, cut=None, moves=None, result=(), done=False,
              **answer):
        shown = st["draw"] if st["draw"] is not None else heap
        tree = {**level_order_tree([e[0] for e in shown]), "tags": [[j, q(e[1])] for j, e in enumerate(shown)],
                "nodeMarks": heap_marks or {}}
        ptrs = {"dummy": 0} if done else {"dummy": 0, "tail": nid(st["tail"])}
        state = {**linked_list(order), "pointers": ptrs, "marks": list_marks or {}}
        if link is not None:
            state["linkMarks"] = {"good": [nid(link)]}
        if cut is not None and cut[1] is not None:
            state["cut"] = {nid(cut[0]): nid(cut[1])}
        run.frame(caption, nodes=state, heap=tree,
                  result={"values": list(result), "marks": {"path": list(range(len(result)))}}, moves=moves, **answer)

    def less(x, y):
        return (x[0], x[1]) < (y[0], y[1])

    def sift_down(j):
        while True:
            best = j
            for c in (2 * j + 1, 2 * j + 2):
                if c < len(heap) and less(heap[c], heap[best]):
                    best = c
            if best == j:
                return
            a, b = heap[j], heap[best]
            heap[j], heap[best] = b, a
            frame({"en": f"Sift down: {a[0]} at the top is larger than its child {b[0]}, so they swap.",
                   "ko": f"아래로 내리기: 위에 있는 {josa(a[0], '이가')} 자식 {b[0]}보다 크므로 자리를 바꿉니다."},
                  list_marks={"lit": [nid(b[2])]}, heap_marks={"good": [j], "lit": [best]},
                  moves=swap("heap", j, best, str(a[0]), str(b[0])))
            j = best

    def sift_up(j):
        while j > 0:
            p = (j - 1) // 2
            if not less(heap[j], heap[p]):
                return
            a, b = heap[j], heap[p]
            heap[j], heap[p] = b, a
            frame({"en": f"Sift up: {a[0]} is smaller than its parent {b[0]}, so they swap.",
                   "ko": f"위로 올리기: {josa(a[0], '이가')} 부모 {b[0]}보다 작으므로 자리를 바꿉니다."},
                  heap_marks={"good": [p], "lit": [j]}, moves=swap("heap", j, p, str(a[0]), str(b[0])))
            j = p

    k = len(queues)
    shown = "; ".join(f"{q(i)} {driver_list(v)}" for i, v in enumerate(queues))
    frame({"en": f"{k} queues: {shown}. They sit in one row behind a dummy node, with tail on dummy.",
           "ko": f"큐 {k}개를 dummy 노드 뒤에 한 줄로 놓습니다({shown}). tail은 dummy에 있습니다."},
          list_marks={"lit": [0]})
    for i, h in enumerate(heads):
        if h:
            heap.append((h.val, i, h))
    frame({"en": f"The heap list starts with each queue's front node, in queue order: "
                 f"{', '.join(str(e[0]) for e in heap)}, tagged with its queue.",
           "ko": f"각 큐의 맨 앞 노드를 어느 큐에서 왔는지 표시해 큐 순서대로 힙 리스트에 넣습니다: "
                 f"{', '.join(str(e[0]) for e in heap)}."},
          list_marks={"lit": [nid(e[2]) for e in heap]}, heap_marks={"good": list(range(len(heap)))},
          moves=[move(at("nodes", nid(e[2])), at("heap", j)) for j, e in enumerate(heap)])
    for j in reversed(range(len(heap) // 2)):
        sift_down(j)
    tail = dummy
    while heap:
        top = heap[0]
        node = top[2]
        frame({"en": f"heappop: the top, {top[0]} from {q(top[1])}, is the earliest front left.",
               "ko": f"heappop: 맨 위의 {q(top[1])}의 {josa(top[0], '이가')} 남은 앞 노드 중 가장 이릅니다."},
              list_marks={"lit": [nid(node)]}, heap_marks={"lit": [0]},
              moves=[move(at("heap", 0), at("nodes", nid(node)))])
        last = heap.pop()
        if heap:
            k_last = len(heap)
            heap[0] = last
            st["draw"] = heap + [last]
            frame({"en": f"The heap's last entry, {last[0]}, fills its empty top.",
                   "ko": f"힙의 마지막 항목 {josa(last[0], '이가')} 빈 맨 위를 채웁니다."},
                  heap_marks={"good": [0]}, moves=[move(at("heap", k_last), at("heap", 0))])
            st["draw"] = None
            sift_down(0)
        old = tail.next
        tail.next = node
        prev_tail = tail
        tail = node
        st["tail"] = tail
        name = "dummy" if prev_tail is dummy else str(prev_tail.val)
        if old is node:
            linked = {"en": f"{name} already points to {node.val}", "ko": f"{name}의 화살표는 이미 {josa(node.val, '을를')} 가리킵니다"}
        else:
            linked = {"en": f"{name} now points to {node.val}", "ko": f"이제 {name}의 화살표가 {josa(node.val, '을를')} 가리킵니다"}
        frame({"en": f"tail.next = {node.val}: {linked['en']}. tail = {node.val}.",
               "ko": f"tail.next = {node.val}: {linked['ko']}. tail도 {josa(node.val, '(으)로')} 옮깁니다."},
              list_marks={"lit": [nid(node)]}, link=prev_tail if old is not node else None,
              cut=(prev_tail, old) if old is not node else None)
        if node.next:
            nxt = node.next
            heap.append((nxt.val, top[1], nxt))
            j = len(heap) - 1
            frame({"en": f"{node.val} has a next in {q(top[1])}, {nxt.val}, so {nxt.val} goes in at the end of the heap.",
                   "ko": f"{q(top[1])}에서 {node.val} 뒤에 {josa(nxt.val, '이가')} 있으므로 힙의 맨 끝에 넣습니다."},
                  list_marks={"lit": [nid(nxt)]}, heap_marks={"good": [j]},
                  moves=[move(at("nodes", nid(nxt)), at("heap", j))])
            sift_up(j)
        elif heap:
            frame({"en": f"{node.val} is the last of {q(top[1])}, so nothing joins the heap.",
                   "ko": f"{josa(node.val, '은는')} {q(top[1])}의 마지막이라 힙에 넣을 것이 없습니다."},
                  list_marks={"lit": [nid(node)]})
    result, node, chain = [], dummy.next, []
    while node:
        result.append(node.val)
        chain.append(node)
        node = node.next
    printed = driver_list(result)
    frame({"en": f"The heap is empty, so every node is linked. Reading from dummy.next gives {printed}.",
           "ko": f"힙이 비었으니 모든 노드가 이어졌습니다. dummy.next부터 읽으면 {printed}입니다."},
          list_marks={"path": [nid(c) for c in chain], "dim": [0]}, result=result, done=True,
          moves=[move(at("nodes", nid(c)), at("result", i)) for i, c in enumerate(chain)], answer=printed)
    return printed


for number, sample in enumerate(sample_cases(SLUG), start=1):
    queues = json.loads(sample["input"])
    run = sample_run(wt, number, sample, input=f"queues = {driver_list(queues)}")
    solve(queues, run)
wt.write(walkthrough_path(SLUG))
