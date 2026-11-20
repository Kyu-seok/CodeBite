#!/usr/bin/env python3.12
"""merge-cafe-queues' Walkthrough: the reference solution (scripts/replay-solutions/merge-cafe-queues.py), a min-heap
of each queue's front node, run on each sample Test Case with heapq's heapify, push and pop written out as the textbook
sift-down and sift-up (the heap pops the same entries in the same order). A pop or a push is one frame together with
its sift, as is heapify (#388): the heap is drawn as the sift leaves it, each entry it moved going from its old node
to its new one, and the caption names the entries the sift passed. Every node keeps its
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
from walkthrough_trace import Walkthrough, at, level_order_tree, linked_list, move, node_id  # noqa: E402

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
    drawn = []  # the heap list as the last frame drew it

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
        drawn[:] = heap

    def sifted(fresh=None):
        """A move for each entry a sift put somewhere new since the last frame: from the node it was at, or, when
        that node is gone (the last entry lifted to the top by a pop), into its node. `fresh` is the entry a push
        added, which the caller moves in from its list node."""
        out = []
        for j, e in enumerate(heap):
            if (j < len(drawn) and drawn[j] is e) or e is fresh:
                continue
            i = next((k for k, d in enumerate(drawn) if d is e), None)
            out.append(move(at("heap", i), at("heap", j), value=str(e[0])) if i is not None and i < len(heap)
                       else move(dst=at("heap", j), value=str(e[0])))
        return out

    def less(x, y):
        return (x[0], x[1]) < (y[0], y[1])

    def sift_down(j):
        """Swap the entry at j down to its smaller child while that child is smaller; the entries it passed."""
        passed = []
        while True:
            best = j
            for c in (2 * j + 1, 2 * j + 2):
                if c < len(heap) and less(heap[c], heap[best]):
                    best = c
            if best == j:
                return passed
            heap[j], heap[best] = heap[best], heap[j]
            passed.append(heap[j][0])
            j = best

    def sift_up(j):
        """Swap the entry at j up while it is smaller than its parent; the entries it passed."""
        passed = []
        while j > 0:
            p = (j - 1) // 2
            if not less(heap[j], heap[p]):
                return passed
            heap[j], heap[p] = heap[p], heap[j]
            passed.append(heap[j][0])
            j = p
        return passed

    def past(values):
        return ", ".join(str(v) for v in values)

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
    swaps = sum(len(sift_down(j)) for j in reversed(range(len(heap) // 2)))
    if swaps:
        moved = sifted()
        frame({"en": f"heapify sifts each parent down, drawn as one step: after {swaps} "
                     f"{'swap' if swaps == 1 else 'swaps'} the smallest front, {heap[0][0]} from {q(heap[0][1])}, is "
                     f"on top.",
               "ko": f"heapify가 부모를 차례로 아래로 내리는 과정을 한 단계로 그립니다. 자리 바꿈 {swaps}번 끝에 가장 작은 "
                     f"앞 노드인 {q(heap[0][1])}의 {josa(heap[0][0], '이가')} 맨 위에 옵니다."},
              list_marks={"lit": [nid(heap[0][2])]}, heap_marks={"good": [m["to"]["at"] for m in moved]}, moves=moved)
    tail = dummy
    while heap:
        top = heap[0]
        node = top[2]
        popped = move(at("heap", 0), at("nodes", nid(node)), value=str(top[0]))
        last = heap.pop()
        if heap:
            heap[0] = last
            passed = sift_down(0)
            if passed:
                then = {"en": f"The last entry, {last[0]}, takes the top and sifts down past {past(passed)} in the "
                              f"same step.",
                        "ko": f"마지막 항목 {josa(last[0], '이가')} 맨 위를 채운 뒤 같은 단계에서 {past(passed)} 아래로 "
                              f"내려갑니다."}
            else:
                then = {"en": f"The last entry, {last[0]}, takes the top and stays there.",
                        "ko": f"마지막 항목 {josa(last[0], '이가')} 맨 위를 채우고 그대로 있습니다."}
            moved = sifted()
            frame({"en": f"heappop: the top, {top[0]} from {q(top[1])}, is the earliest front left. {then['en']}",
                   "ko": f"heappop: 맨 위의 {q(top[1])}의 {josa(top[0], '이가')} 남은 앞 노드 중 가장 이릅니다. "
                         f"{then['ko']}"},
                  list_marks={"lit": [nid(node)]}, heap_marks={"good": [m["to"]["at"] for m in moved]},
                  moves=[popped] + moved)
        else:
            st["draw"] = [top]
            frame({"en": f"heappop: the top, {top[0]} from {q(top[1])}, is the only front left, so the heap is empty "
                         f"after it.",
                   "ko": f"heappop: 맨 위의 {q(top[1])}의 {josa(top[0], '이가')} 하나 남은 앞 노드이므로, 꺼내면 힙이 "
                         f"빕니다."},
                  list_marks={"lit": [nid(node)]}, heap_marks={"lit": [0]}, moves=[popped])
            st["draw"] = None
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
            entry = (nxt.val, top[1], nxt)
            heap.append(entry)
            passed = sift_up(len(heap) - 1)
            j = heap.index(entry)
            if passed:
                where = {"en": f"at the end of the heap and sifts it up past {past(passed)} in the same step",
                         "ko": f"힙의 맨 끝에 넣고 같은 단계에서 {past(passed)} 위로 올립니다"}
            elif j:
                where = {"en": f"at the end of the heap, where it stays under {heap[(j - 1) // 2][0]}",
                         "ko": f"힙의 맨 끝에 넣고, {heap[(j - 1) // 2][0]} 아래 그대로 둡니다"}
            else:
                where = {"en": "into the empty heap", "ko": "빈 힙에 넣습니다"}
            frame({"en": f"{node.val} has a next in {q(top[1])}, {nxt.val}, so heappush puts {nxt.val} "
                         f"{where['en']}.",
                   "ko": f"{q(top[1])}에서 {node.val} 뒤에 {josa(nxt.val, '이가')} 있으므로 heappush로 "
                         f"{where['ko']}."},
                  list_marks={"lit": [nid(nxt)]}, heap_marks={"good": [j]},
                  moves=[move(at("nodes", nid(nxt)), at("heap", j), value=str(nxt.val))] + sifted(fresh=entry))
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
