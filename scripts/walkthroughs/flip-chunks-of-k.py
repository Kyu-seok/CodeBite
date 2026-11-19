#!/usr/bin/env python3.12
"""flip-chunks-of-k's Walkthrough: the reference solution (scripts/replay-solutions/flip-chunks-of-k.py), a dummy node
before the head and a pointer `before` to the node ahead of each chunk, recording on each sample Test Case one frame
for end walking k nodes to find the chunk, one per arrow the chunk's reversal turns (each node's next back to prev,
where prev starts at the node after the chunk), and one for before's arrow re-pointed to the chunk's new first node,
with before stepping to its new last. The nodes keep their places in the row; only the arrows turn, and the list read
from dummy.next is the answer.

    CODEBITE_DB=<database> scripts/walkthroughs/flip-chunks-of-k.py

writes common/src/main/resources/walkthroughs/flip-chunks-of-k.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import ListNode, driver_list, josa, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, linked_list, move, node_id  # noqa: E402

SLUG = "flip-chunks-of-k"

wt = Walkthrough(
    {"en": "Flip Chunks of K", "ko": "k개씩 묶어 뒤집기"},
    {"en": "Walk k nodes from before to find the chunk's end; if the list runs out first, the rest stays. Otherwise "
           "reverse the chunk's arrows, starting prev at the node after the chunk so the chunk's old first node "
           "points out of it, then point before at the chunk's old last node and move before to the old first.",
     "ko": "before에서 노드 k개를 걸어 묶음의 끝을 찾습니다. 그 전에 리스트가 끝나면 나머지는 그대로 둡니다. 그렇지 않으면 "
           "prev를 묶음 다음 노드에서 시작해 묶음의 화살표를 뒤집으므로 원래 첫 노드가 묶음 밖을 가리키게 되고, before가 "
           "원래 마지막 노드를 가리키게 한 뒤 before를 원래 첫 노드로 옮깁니다."},
    views=[
        {"id": "list", "type": "linkedlist", "title": {"en": "list from dummy", "ko": "dummy부터의 리스트"},
         "empty": {"en": "empty list", "ko": "빈 리스트"}},
        {"id": "result", "type": "output", "title": {"en": "answer", "ko": "답"},
         "empty": {"en": "not read yet", "ko": "아직 없음"}},
        {"id": "state", "type": "vars"},
    ],
)


def solve(values, k, run):
    """Solution.flipChunks with a frame per step. Returns the answer as the Driver prints it."""
    nodes = [ListNode(v) for v in values]
    for a, b in zip(nodes, nodes[1:]):
        a.next = b
    dummy = ListNode("")  # the solution's dummy holds 0; its value is never read, so it is drawn empty
    dummy.next = nodes[0]
    order = [dummy] + nodes

    def nid(node):
        return node_id(order, node)

    def frame(caption, ptr, marks, link=None, cut=None, moves=None, result=(), **answer):
        state = {**linked_list(order), "pointers": {name: nid(v) for name, v in ptr.items()}, "marks": marks}
        if link is not None:
            state["linkMarks"] = {"good": [nid(link)]}
        if cut is not None and cut[1] is not None:
            state["cut"] = {nid(cut[0]): nid(cut[1])}
        run.frame(caption, list=state, result={"values": list(result), "marks": {"path": list(range(len(result)))}},
                  state={"items": [{"label": "k", "value": k}]}, moves=moves, **answer)

    def name(node):
        return "dummy" if node is dummy else str(node.val)

    def val(node, null="null"):
        return null if node is None else str(node.val)

    def obj(node):
        """`node` as the object of a Korean verb: null을, or the value with 을/를."""
        return "null을" if node is None else josa(node.val, "을를")

    frame({"en": f"{len(nodes)} nodes from {nodes[0].val} to {nodes[-1].val}, and k = {k}. dummy goes before the head, "
                 f"and before starts there.",
           "ko": f"노드 {len(nodes)}개가 {nodes[0].val}부터 {nodes[-1].val}까지 있고 k = {k}입니다. head 앞에 dummy를 두고, "
                 f"before는 거기서 시작합니다."},
          {"dummy": dummy, "before": dummy}, {"lit": [0]})
    before = dummy
    chunk_no = 0
    while True:
        end = before
        walked = []
        for _ in range(k):
            end = end.next
            if end is None:
                break
            walked.append(end)
        if end is None:
            result, node, chain = [], dummy.next, []
            while node:
                result.append(node.val)
                chain.append(node)
                node = node.next
            printed = driver_list(result)
            if walked:
                short = {"en": f"end walks only {len(walked)} {'node' if len(walked) == 1 else 'nodes'} "
                               f"({', '.join(str(n.val) for n in walked)}) before null: fewer than {k}, so they stay.",
                         "ko": f"end가 null에 닿기 전에 노드 {len(walked)}개({', '.join(str(n.val) for n in walked)})만 "
                               f"지나가므로 {k}개보다 적어 그대로 둡니다."}
            else:
                short = {"en": f"before.next is null: no nodes are left after {name(before)}.",
                         "ko": f"before.next가 null이라 {name(before)} 뒤에 남은 노드가 없습니다."}
            frame({"en": f"{short['en']} Reading from dummy.next gives {printed}.",
                   "ko": f"{short['ko']} dummy.next부터 읽으면 {printed}입니다."},
                  {"dummy": dummy}, {"path": [nid(c) for c in chain], "dim": [0]}, result=result,
                  moves=[move(at("list", nid(c)), at("result", i)) for i, c in enumerate(chain)], answer=printed)
            return printed
        chunk_no += 1
        first, after = before.next, end.next
        chunk = ", ".join(str(n.val) for n in walked)
        after_txt = {"en": "null" if after is None else str(after.val), "ko": "null" if after is None else str(after.val)}
        frame({"en": f"end walks {k} {'node' if k == 1 else 'nodes'} from {name(before)} to {end.val}: chunk "
                     f"{chunk_no} is ({chunk}). first = {first.val}, after = {after_txt['en']}; prev starts at after "
                     f"and node at first.",
               "ko": f"end가 {name(before)}에서 노드 {k}개를 걸어 {end.val}에 닿으므로 {chunk_no}번째 묶음은 ({chunk})입니다. "
                     f"first = {first.val}, after = {after_txt['ko']}이고, prev는 after에서, node는 first에서 시작합니다."},
              {"dummy": dummy, "before": before, "end": end, "first": first, "after": after, "prev": after,
               "node": first},
              {"lit": [nid(n) for n in walked]})
        prev, node = after, first
        while node is not after:
            old = node.next
            node.next, prev, node = prev, node, node.next
            turned = prev
            if old is turned.next:
                what = {"en": f"{turned.val}'s next is already {val(turned.next)}, so its arrow stays",
                        "ko": f"{turned.val}의 화살표는 이미 {obj(turned.next)} 가리키므로 그대로입니다"}
            else:
                what = {"en": f"{turned.val}'s arrow turns to {val(turned.next)}",
                        "ko": f"{turned.val}의 화살표가 {val(turned.next)} 쪽으로 돌아갑니다"}
            if node is after:
                step = {"en": "node reaches after, so the chunk is reversed.",
                        "ko": "node가 after에 닿았으니 묶음이 뒤집혔습니다."}
            else:
                step = {"en": f"prev = {turned.val}, node = {node.val}.", "ko": f"prev = {turned.val}, node = {node.val}."}
            frame({"en": f"node.next = prev: {what['en']}; {step['en']}",
                   "ko": f"node.next = prev: {what['ko']}. {step['ko']}"},
                  {"dummy": dummy, "before": before, "end": end, "first": first, "after": after, "prev": prev,
                   "node": node},
                  {"lit": [nid(turned)]}, link=turned if old is not turned.next else None,
                  cut=(turned, old) if old is not turned.next else None)
        old = before.next
        before.next = end
        if old is end:
            linked = {"en": f"{name(before)} already points to {end.val}",
                      "ko": f"{name(before)}의 화살표는 이미 묶음의 새 첫 노드 {josa(end.val, '을를')} 가리킵니다"}
        else:
            linked = {"en": f"{name(before)} now points to {end.val}",
                      "ko": f"이제 {name(before)}의 화살표가 묶음의 새 첫 노드 {josa(end.val, '을를')} 가리킵니다"}
        frame({"en": f"before.next = end: {linked['en']}, the chunk's new first. before = first: before moves to "
                     f"{first.val}, the chunk's new last.",
               "ko": f"before.next = end: {linked['ko']}. before = first: before가 묶음의 새 마지막 "
                     f"노드 {josa(first.val, '(으)로')} 옮깁니다."},
              {"dummy": dummy, "before": first}, {"lit": [nid(before), nid(end)]},
              link=before if old is not end else None, cut=(before, old) if old is not end else None)
        before = first


for number, sample in enumerate(sample_cases(SLUG), start=1):
    lines = sample["input"].split("\n")
    values, k = json.loads(lines[0]), int(lines[1])
    run = sample_run(wt, number, sample, input=f"head = {driver_list(values)}, k = {k}")
    solve(values, k, run)
wt.write(walkthrough_path(SLUG))
