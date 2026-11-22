#!/usr/bin/env python3.12
"""interleave-clip-chain's Walkthrough: the reference solution (scripts/replay-solutions/interleave-clip-chain.py), in
three passes on each sample Test Case: slow and fast find the middle, the arrow after it is cut and the second half
reversed (prev and curr turning one arrow per frame), then first and second weave the two halves, one re-pointed
arrow per frame. The clips keep their places in the row, so the woven order shows in the arrows, and the list read
from head after the call is the answer.

    CODEBITE_DB=<database> scripts/walkthroughs/interleave-clip-chain.py

writes common/src/main/resources/walkthroughs/interleave-clip-chain.json.
"""
import json
import os
import sys
from functools import partial

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import ListNode, driver_list, josa, node_object, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, linked_list, move, node_id  # noqa: E402

SLUG = "interleave-clip-chain"

wt = Walkthrough(
    {"en": "Interleave Clip Chain", "ko": "클립 체인 교차하기"},
    {"en": "Three passes over the arrows: slow and fast find the middle, the second half is cut off and reversed so it "
           "runs from the last clip back, and then the two halves are woven, one clip from each in turn.",
     "ko": "화살표를 세 번 다룹니다. slow와 fast로 가운데를 찾고, 뒤쪽 절반을 잘라 마지막 클립부터 거꾸로 이어지게 "
           "뒤집은 다음, 두 절반에서 클립을 하나씩 번갈아 엮습니다."},
    views=[
        {"id": "clips", "type": "linkedlist", "title": {"en": "clips from head", "ko": "head부터의 클립"},
         "empty": {"en": "no clips", "ko": "클립 없음"}},
        {"id": "result", "type": "output", "title": {"en": "answer", "ko": "답"},
         "empty": {"en": "not read yet", "ko": "아직 없음"}},
    ],
)


def solve(values, run):
    """Solution.interleaveClips with a frame per step. Returns the answer as the Driver prints it."""
    order = [ListNode(v) for v in values]
    for a, b in zip(order, order[1:]):
        a.next = b
    head = order[0]

    nid = partial(node_id, order)

    def ro(node):
        return "null로" if node is None else josa(node.val, "(으)로")

    def to(node):
        return "null" if node is None else str(node.val)

    def frame(caption, ptr, marks, link=None, cut=None, moves=None, result=(), **answer):
        state = {**linked_list(order), "pointers": {"head": 0, **{k: nid(v) for k, v in ptr.items()}},
                 "marks": marks}
        if link is not None:
            state["linkMarks"] = {"good": [nid(link)]}
        if cut is not None and cut[1] is not None:
            state["cut"] = {nid(cut[0]): nid(cut[1])}
        run.frame(caption, clips=state, result={"values": list(result), "marks": {"path": list(range(len(result)))}},
                  moves=moves, **answer)

    n = len(order)
    frame({"en": f"{n} clips from {head.val} to {order[-1].val}. To find the middle, slow and fast both start at the "
                 f"head {head.val}.",
           "ko": f"클립 {n}개가 {head.val}부터 {order[-1].val}까지 이어집니다. 가운데를 찾기 위해 slow와 fast 모두 head "
                 f"{head.val}에서 시작합니다."},
          {"slow": head, "fast": head}, {"lit": [0]})
    slow = fast = head
    while fast.next and fast.next.next:
        slow, fast = slow.next, fast.next.next
        if fast.next and fast.next.next:
            more = {"en": "fast can jump two more.", "ko": "fast가 두 칸 더 갈 수 있습니다."}
        else:
            more = {"en": f"fast can't jump two more, so slow ({slow.val}) ends the first half.",
                    "ko": f"fast가 더는 두 칸을 갈 수 없으므로 slow가 선 {josa(slow.val, '이가')} 앞쪽 절반의 끝입니다."}
        frame({"en": f"slow steps to {slow.val} and fast jumps two to {fast.val}; {more['en']}",
               "ko": f"slow는 {josa(slow.val, '(으)로')} 한 칸, fast는 {josa(fast.val, '(으)로')} 두 칸 갑니다. {more['ko']}"},
              {"slow": slow, "fast": fast}, {"lit": [nid(slow), nid(fast)]})
    prev, curr = None, slow.next
    frame({"en": f"The second half starts at slow.next: curr = {curr.val}, and prev = null.",
           "ko": f"뒤쪽 절반은 slow.next에서 시작합니다. curr = {curr.val}, prev = null입니다."},
          {"slow": slow, "curr": curr}, {"lit": [nid(curr)]})
    old = slow.next
    slow.next = None
    frame({"en": f"slow.next = null: the arrow from {slow.val} to {old.val} is cut, so the first half ends at {slow.val}.",
           "ko": f"slow.next = null: {slow.val}의 화살표를 끊어 앞쪽 절반이 {slow.val}에서 끝납니다."},
          {"slow": slow, "curr": curr}, {"lit": [nid(slow)]}, link=slow, cut=(slow, old))
    while curr:
        nxt = curr.next
        curr.next = prev
        if prev is None:
            turned = {"en": f"turn {curr.val}'s arrow to prev, which is null.",
                      "ko": f"{curr.val}의 화살표를 prev(null) 쪽으로 돌립니다."}
        else:
            turned = {"en": f"turn {curr.val}'s arrow back to prev ({prev.val}).",
                      "ko": f"{curr.val}의 화살표를 prev({prev.val}) 쪽으로 돌립니다."}
        if nxt is None:
            saved = {"en": "Save nxt = null (the last clip)", "ko": "nxt = null을 기억해 두고"}
        else:
            saved = {"en": f"Save nxt = {nxt.val}", "ko": f"nxt = {josa(nxt.val, '을를')} 기억해 두고"}
        frame({"en": f"{saved['en']}, then {turned['en']}", "ko": f"{saved['ko']} {turned['ko']}"},
              {"slow": slow, "prev": prev, "curr": curr, "nxt": nxt}, {"lit": [nid(curr)]}, link=curr,
              cut=(curr, nxt))
        prev, curr = curr, nxt
        if curr:
            step = {"en": f"Step forward: prev = {prev.val}, curr = {curr.val}.",
                    "ko": f"한 칸 나아가 prev = {prev.val}, curr = {josa(curr.val, '이가')} 됩니다."}
        else:
            step = {"en": f"Step forward: prev = {prev.val} and curr is null, so the second half is reversed and "
                          f"starts at {prev.val}.",
                    "ko": f"한 칸 나아가 prev = {prev.val}, curr = null이 되어, 뒤쪽 절반이 {prev.val}부터 거꾸로 "
                          f"이어집니다."}
        frame(step, {"slow": slow, "prev": prev, "curr": curr}, {"lit": [nid(prev)]})
    first, second = head, prev
    frame({"en": f"Now weave: first = head ({first.val}) runs down the first half and second = prev ({second.val}) "
                 f"down the reversed second half.",
           "ko": f"이제 엮습니다. first는 head({first.val})에서 앞쪽 절반을, second는 prev({second.val})에서 뒤집힌 "
                 f"뒤쪽 절반을 따라갑니다."},
          {"first": first, "second": second}, {"lit": [nid(first), nid(second)]})
    while second:
        next1, next2 = first.next, second.next
        old = first.next
        first.next = second
        frame({"en": f"Save next1 = {to(next1)} and next2 = {to(next2)}, then first.next = second: {first.val} now "
                     f"points to {second.val}.",
               "ko": f"next1 = {to(next1)}, next2 = {ro(next2)} 기억해 두고, first.next = second로 {first.val}의 화살표가 "
               f"{node_object(second)} 가리킵니다."},
              {"first": first, "second": second, "next1": next1, "next2": next2}, {"lit": [nid(first)]},
              link=first, cut=(first, old))
        old = second.next
        second.next = next1
        frame({"en": f"second.next = next1: {second.val} now points to {to(next1)}"
                     + (", so the middle clip comes last." if next1 is not None and next1.next is None and next2 is None
                        else "."),
               "ko": f"second.next = next1: {second.val}의 화살표가 {node_object(next1)} 가리킵니다."},
              {"first": first, "second": second, "next1": next1, "next2": next2}, {"lit": [nid(second)]},
              link=second, cut=(second, old))
        first, second = next1, next2
        if second is None:
            step = {"en": f"first = next1 ({to(first)}), second = next2, which is null: the weave is done.",
                    "ko": f"first = next1({to(first)}), second = next2인데 null이므로 엮기가 끝났습니다."}
        else:
            step = {"en": f"first = next1 ({first.val}), second = next2 ({second.val}).",
                    "ko": f"first는 next1({first.val}), second는 next2({second.val}) 자리로 옮깁니다."}
        frame(step, {"first": first, "second": second},
              {"lit": [nid(x) for x in (first, second) if x is not None]})
    result, node, chain = [], head, []
    while node:
        result.append(node.val)
        chain.append(node)
        node = node.next
    printed = driver_list(result)
    frame({"en": f"The method returns, and reading from head gives {printed}.",
           "ko": f"메서드가 끝나고, head부터 읽으면 {printed}입니다."},
          {}, {"path": [nid(c) for c in chain]}, result=result,
          moves=[move(at("clips", nid(c)), at("result", i)) for i, c in enumerate(chain)], answer=printed)
    return printed


for number, sample in enumerate(sample_cases(SLUG), start=1):
    values = json.loads(sample["input"])
    run = sample_run(wt, number, sample, input=f"head = {driver_list(values)}")
    solve(values, run)
wt.write(walkthrough_path(SLUG))
