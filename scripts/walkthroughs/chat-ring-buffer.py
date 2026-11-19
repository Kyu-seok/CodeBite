#!/usr/bin/env python3.12
"""chat-ring-buffer's Walkthrough: the reference solution (scripts/replay-solutions/chat-ring-buffer.py), a queue
of fixed capacity in a circular array of k slots, driven by the sample's list of calls, recording one frame per call
on each sample Test Case.

The call-list pattern (add-walkthrough views.md): the calls are a table, one row per call, the current one lit and those before it faded, each
call's return value moves into an `output` (the Driver's printed list), and the slots change underneath, with head
and rear as pointers and the slots outside the queue dimmed (a pulled message stays in its slot until a push
writes over it).

    CODEBITE_DB=<database> scripts/walkthroughs/chat-ring-buffer.py

writes common/src/main/resources/walkthroughs/chat-ring-buffer.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import driver_list, josa, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move  # noqa: E402

SLUG = "chat-ring-buffer"

wt = Walkthrough(
    {"en": "Chat Ring Buffer", "ko": "채팅 링 버퍼"},
    {"en": "k slots used in a circle: head is the front, size counts the messages, and a push writes at "
           "(head + size) % k, so the rear wraps around to the slots a pull freed.",
     "ko": "k개의 칸을 원형으로 씁니다. head가 맨 앞이고 size가 메시지 수이며, push는 (head + size) % k에 쓰므로 "
           "뒤쪽이 한 바퀴 돌아 pull로 비운 칸을 다시 씁니다."},
    views=[
        {"id": "calls", "type": "table", "title": {"en": "calls", "ko": "호출"}},
        {"id": "slots", "type": "array",
         "title": {"en": "slots (faded: not in the queue)", "ko": "slots (흐린 칸: 큐 밖)"}},
        {"id": "state", "type": "vars"},
        {"id": "result", "type": "output", "title": {"en": "returned", "ko": "반환값"}},
    ],
)


def solve(ops, args, run):
    """The Driver's loop over the calls with the reference FixedRing inside, a frame per call. Returns the printed
    list."""
    n = len(ops)
    rows = [{"label": str(i), "cells": [op, str(a[0]) if a else ""]} for i, (op, a) in enumerate(zip(ops, args))]
    k = args[0][0]
    slots = [0] * k
    head = size = 0
    result = []
    drawn = [0]  # how many return values the frame before drew, so only a new one is marked good
    i = 0

    def live():
        return [(head + j) % k for j in range(size)]

    def frame(caption, slot_marks=None, path=False, moves=None, **answer):
        fresh = list(range(drawn[0], len(result)))
        drawn[0] = len(result)
        marks = {"dim": [s for s in range(k) if s not in live()]}
        marks.update(slot_marks or {})
        run.frame(caption,
                  calls={"columns": [{"en": "call", "ko": "호출"}, {"en": "argument", "ko": "인자"}], "rows": rows,
                         "marks": {} if path else {"dim": [[r, c] for r in range(i) for c in (0, 1)],
                                                    "lit": [[i, 0], [i, 1]]}},
                  slots={"values": slots, "marks": marks,
                         "pointers": {"head": head, "rear": (head + size - 1) % k if size else None}},
                  state={"items": [{"label": "size", "value": size,
                                     "why": "size is the field FixedRing keeps; it counts the slots not faded, which "
                                            "can wrap past the end, so no span can draw it"}]},
                  result={"values": result,
                          "marks": {"path": list(range(len(result)))} if path else {"good": fresh}},
                  moves=moves, **answer)

    def returned(value):
        result.append(json.dumps(value))
        return len(result) - 1

    def back(value):
        """A return value created by the call itself (a boolean, or -1), moving from the call into the output."""
        return move(at("calls", [i, 0]), at("result", returned(value)), value=json.dumps(value))

    returned(None)
    frame({"en": f"FixedRing({k}) makes {k} slots, all 0, with head = 0 and size = 0: an empty queue. It returns null.",
           "ko": f"FixedRing({k}): 0으로 채운 칸 {k}개를 만들고 head = 0, size = 0인 빈 큐로 시작합니다. null을 반환합니다."})
    for i in range(1, n):
        op = ops[i]
        if op == "push":
            value = args[i][0]
            if size == k:
                frame({"en": f"push({value}): size = {size} = k, so the queue is full; nothing is overwritten, and push returns false.",
                       "ko": f"push({value}): size = {size} = k라 큐가 가득 찼습니다. 아무것도 덮어쓰지 않고 false를 반환합니다."},
                      slot_marks={"bad": live()}, moves=[back(False)])
                continue
            slot = (head + size) % k
            slots[slot] = value
            size += 1
            wrap = (head + size - 1) >= k
            where = f"({head} + {size - 1}) % {k} = {slot}"
            frame({"en": f"push({value}): it goes into slot {where}{', wrapping around' if wrap else ''}; "
                         f"size becomes {size}, and push returns true.",
                   "ko": f"push({value}): {where}번 칸에 넣습니다{' (한 바퀴 돌아옴)' if wrap else ''}. "
                         f"size는 {josa(size, '이가')} 되고 true를 반환합니다."},
                  slot_marks={"good": [slot]},
                  moves=[move(at("calls", [i, 1]), at("slots", slot), value=str(value)), back(True)])
        elif op == "pull":
            if size == 0:
                frame({"en": "pull(): size = 0, so the queue is empty and pull returns false.",
                       "ko": "pull(): size = 0이라 큐가 비어 있으므로 false를 반환합니다."},
                      moves=[back(False)])
                continue
            left = head
            head = (head + 1) % k
            size -= 1
            frame({"en": f"pull(): the front message, {slots[left]} in slot {left}, leaves; head moves to {head} "
                         f"and size drops to {size}. The slot keeps its value until a push writes over it; pull returns true.",
                   "ko": f"pull(): {left}번 칸의 맨 앞 메시지 {josa(slots[left], '이가')} 빠지고 head는 {josa(head, '(으)로')}, "
                         f"size는 {josa(size, '(으)로')} 줄어듭니다. 칸의 값은 push가 덮어쓸 때까지 남고, true를 반환합니다."},
                  slot_marks={"lit": [left]}, moves=[back(True)])
        elif op in ("front", "rear"):
            if size == 0:
                frame({"en": f"{op}(): the queue is empty, so it returns -1.",
                       "ko": f"{op}(): 큐가 비어 있으므로 -1을 반환합니다."},
                      moves=[back(-1)])
                continue
            slot = head if op == "front" else (head + size - 1) % k
            value = slots[slot]
            k_out = returned(value)
            word = {"front": ("front", "맨 앞"), "rear": ("rear", "맨 뒤")}[op]
            frame({"en": f"{op}(): the {word[0]} message is {value}, in slot {slot}; it returns {value} and stays.",
                   "ko": f"{op}(): {word[1]} 메시지는 {slot}번 칸의 {value}입니다. {josa(value, '을를')} 반환하고 그대로 둡니다."},
                  slot_marks={"lit": [slot]}, moves=[move(at("slots", slot), at("result", k_out))])
        elif op in ("isEmpty", "isFull"):
            value = size == 0 if op == "isEmpty" else size == k
            compare = f"size = {size}" + ("" if op == "isEmpty" else f", k = {k}")
            frame({"en": f"{op}(): {compare}, so it returns {json.dumps(value)}.",
                   "ko": f"{op}(): {compare}이므로 {json.dumps(value)} 값을 반환합니다."},
                  moves=[back(value)])
        else:
            raise ValueError(op)
    printed = driver_list([json.loads(v) for v in result])
    frame({"en": f"Every call is answered, in order: answer {printed}.",
           "ko": f"모든 호출의 반환값을 차례로 모았습니다. 답은 {printed}입니다."},
          path=True, answer=printed)
    return printed


for number, sample in enumerate(sample_cases(SLUG), start=1):
    ops_line, args_line = sample["input"].split("\n")
    run = sample_run(wt, number, sample, input=sample["input"])
    solve(json.loads(ops_line), json.loads(args_line), run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
