#!/usr/bin/env python3.12
"""add-score-lists' Walkthrough: the reference solution (scripts/replay-solutions/add-score-lists.py), column addition
from the ones digit, recording on each sample Test Case one frame per digit written (the digits under score1 and
score2 move into a new node at the end of the sum, the carry kept for the next column) and one per step of tail onto
it. The sum list starts at a dummy node and grows to the right, and the list read from dummy.next is the answer.

    CODEBITE_DB=<database> scripts/walkthroughs/add-score-lists.py

writes common/src/main/resources/walkthroughs/add-score-lists.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import ListNode, driver_list, josa, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, linked_list, move, node_id  # noqa: E402

SLUG = "add-score-lists"

wt = Walkthrough(
    {"en": "Add Score Lists", "ko": "점수 합산 연결 리스트"},
    {"en": "Add the way you would on paper, from the ones digit: each column's digits plus the carry give one digit of "
           "the sum, written into a new node at its end, and a carry of 1 for the next column when the total reaches "
           "10. A carry left after both lists end becomes one more node.",
     "ko": "종이에 더하듯 일의 자리부터 더합니다. 각 자리의 두 숫자와 올림을 더해 합의 한 자리를 새 노드에 적어 끝에 붙이고, "
           "합이 10 이상이면 다음 자리로 1을 올립니다. 두 리스트가 끝난 뒤에도 올림이 남으면 노드가 하나 더 붙습니다."},
    views=[
        {"id": "score1", "type": "linkedlist", "title": {"en": "score1, ones digit first", "ko": "score1 (일의 자리부터)"}},
        {"id": "score2", "type": "linkedlist", "title": {"en": "score2, ones digit first", "ko": "score2 (일의 자리부터)"}},
        {"id": "state", "type": "vars"},
        {"id": "sum", "type": "linkedlist", "title": {"en": "sum from dummy", "ko": "dummy부터의 합"}},
        {"id": "result", "type": "output", "title": {"en": "answer", "ko": "답"},
         "empty": {"en": "not read yet", "ko": "아직 없음"}},
    ],
)


def build(values):
    nodes = [ListNode(v) for v in values]
    for a, b in zip(nodes, nodes[1:]):
        a.next = b
    return nodes


def number(values):
    """The score a ones-digit-first list spells, as text: [3,1,7] is 713."""
    return "".join(str(v) for v in reversed(values))


def solve(v1, v2, run):
    """Solution.addScoreLists with a frame per step. Returns the answer as the Driver prints it."""
    n1, n2 = build(v1), build(v2)
    dummy = ListNode("")  # the solution's dummy holds 0; its value is never read, so it is drawn empty
    out = [dummy]
    s1, s2, tail = n1[0], n2[0], dummy
    carry = 0

    def frame(caption, lit1=(), lit2=(), sum_marks=None, link=None, moves=None, result=(), **answer):
        def side(nodes, ptr, name, lit):
            return {**linked_list(nodes), "pointers": {name: node_id(nodes, ptr)},
                    "marks": {"lit": [node_id(nodes, n) for n in lit]}}
        total = {**linked_list(out), "pointers": {"dummy": 0, "tail": node_id(out, tail)}, "marks": sum_marks or {}}
        if link is not None:
            total["linkMarks"] = {"good": [node_id(out, link)]}
        run.frame(caption, score1=side(n1, s1, "score1", lit1), score2=side(n2, s2, "score2", lit2), sum=total,
                  result={"values": list(result), "marks": {"path": list(range(len(result)))}},
                  state={"items": [{"label": {"en": "carry", "ko": "carry (올림)"}, "value": carry}]},
                  moves=moves, **answer)

    a, b = number(v1), number(v2)
    frame({"en": f"score1 spells {a} and score2 spells {b}, each read from its last node back. The sum starts at a "
                 f"dummy node, with tail on it and carry 0.",
           "ko": f"마지막 노드부터 읽으면 score1은 {a}, score2는 {b}입니다. 합은 dummy 노드에서 시작하고, tail은 거기에, "
           f"carry는 0입니다."})
    column = 0
    while s1 or s2 or carry:
        column += 1
        read1, read2 = s1, s2
        was = carry
        total = carry
        parts = []
        if s1:
            total += s1.val
            parts.append(str(s1.val))
            s1 = s1.next
        if s2:
            total += s2.val
            parts.append(str(s2.val))
            s2 = s2.next
        carry, digit = divmod(total, 10)
        node = ListNode(digit)
        tail.next = node
        out.append(node)
        new = node_id(out, node)
        moves = [move(at(name, node_id(nodes, r)), at("sum", new)) for name, nodes, r in
                 (("score1", n1, read1), ("score2", n2, read2)) if r is not None]
        if not moves:
            moves = [move(None, at("sum", new), value=str(digit))]
        sum_txt = " + ".join(parts + [f"carry {was}"])
        if parts:
            if carry:
                rest = {"en": f"so the digit is {digit} and carry is 1.", "ko": f"자리 숫자는 {digit}, carry는 1입니다."}
            else:
                rest = {"en": f"so the digit is {digit} and carry is 0.", "ko": f"자리 숫자는 {digit}, carry는 0입니다."}
            cap = {"en": f"Column {column}: {sum_txt} = {total}, {rest['en']} tail.next = a new node {digit}.",
                   "ko": f"{column}번째 자리: {sum_txt} = {total}, {rest['ko']} tail.next에 새 노드 {josa(digit, '을를')} "
                   f"붙입니다."}
        else:
            cap = {"en": f"Both lists have ended, but carry is {was}: tail.next = a new node {digit}, and carry is 0.",
                   "ko": f"두 리스트는 끝났지만 carry가 {josa(was, '이가')} 남아, tail.next에 새 노드 {josa(digit, '을를')} "
                         f"붙이고 carry는 0이 됩니다."}
        frame(cap, lit1=[read1] if read1 else [], lit2=[read2] if read2 else [], sum_marks={"good": [new]},
              link=tail, moves=moves)
        tail = node
        frame({"en": f"tail = tail.next: tail moves to the new {digit}.",
               "ko": f"tail = tail.next: tail이 새 노드 {josa(digit, '(으)로')} 옮깁니다."},
              sum_marks={"lit": [new]})
    result = [n.val for n in out[1:]]
    printed = driver_list(result)
    total_txt = number(result)
    frame({"en": f"Both lists have ended and carry is 0. {a} + {b} = {total_txt}, and reading from dummy.next gives "
                 f"{printed}.",
           "ko": f"두 리스트가 끝났고 carry도 0입니다. {a} + {b} = {total_txt}이고, dummy.next부터 읽으면 {printed}입니다."},
          sum_marks={"path": list(range(1, len(out))), "dim": [0]}, result=result,
          moves=[move(at("sum", i), at("result", i - 1)) for i in range(1, len(out))], answer=printed)
    return printed


for number_, sample in enumerate(sample_cases(SLUG), start=1):
    lines = sample["input"].split("\n")
    v1, v2 = json.loads(lines[0]), json.loads(lines[1])
    run = sample_run(wt, number_, sample, input=f"score1 = {driver_list(v1)}, score2 = {driver_list(v2)}")
    solve(v1, v2, run)
wt.write(walkthrough_path(SLUG))
