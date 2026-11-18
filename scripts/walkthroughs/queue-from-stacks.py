#!/usr/bin/env python3.12
"""queue-from-stacks's Walkthrough: the reference solution (scripts/replay-solutions/queue-from-stacks.py), a
queue built from an inbox and an outbox stack, driven by the sample's list of calls, recording one frame per call
and one per value shifted from inbox to outbox, on each sample Test Case.

The call-list pattern (add-walkthrough views.md): the calls are an array with a pointer on the current one, each
call's return value moves into an `output` (the Driver's printed list), and the structure changes underneath.

    CODEBITE_DB=<database> scripts/walkthroughs/queue-from-stacks.py

writes common/src/main/resources/walkthroughs/queue-from-stacks.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import driver_list, josa, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move  # noqa: E402

SLUG = "queue-from-stacks"

wt = Walkthrough(
    {"en": "Queue From Stacks", "ko": "스택으로 큐 만들기"},
    {"en": "push goes onto inbox; pop and peek read outbox's top, and only when outbox is empty does all of inbox "
           "move over, which reverses it so the oldest order ends on top.",
     "ko": "push는 inbox에 쌓고, pop과 peek은 outbox의 맨 위를 읽습니다. outbox가 비었을 때만 inbox 전체를 옮기며, "
           "옮기면 순서가 뒤집혀 가장 오래된 주문이 맨 위에 옵니다."},
    views=[
        {"id": "calls", "type": "array", "title": {"en": "calls (tag: method)", "ko": "calls (태그: 메서드)"}},
        {"id": "inbox", "type": "array", "title": {"en": "inbox (stack, top on the right)", "ko": "inbox (스택, 오른쪽이 맨 위)"},
         "empty": {"en": "empty", "ko": "비어 있음"}},
        {"id": "outbox", "type": "array", "title": {"en": "outbox (stack, top on the right)", "ko": "outbox (스택, 오른쪽이 맨 위)"},
         "empty": {"en": "empty", "ko": "비어 있음"}},
        {"id": "result", "type": "output", "title": {"en": "returned", "ko": "반환값"}},
    ],
)


def shown(value):
    """A return value as the Driver prints it."""
    return json.dumps(value)


def solve(ops, args, run):
    """The Driver's loop over the calls with the reference QueueFromStacks inside, a frame per call and per value
    shifted. Returns the printed list."""
    n = len(ops)
    cells = [str(a[0]) if a else "()" for a in args]
    tags = [[i, "new" if op == "QueueFromStacks" else op] for i, op in enumerate(ops)]
    inbox, outbox, result = [], [], []
    i = 0

    drawn = [0]  # how many return values the frame before drew, so only a new one is marked good

    def frame(caption, inbox_marks=None, outbox_marks=None, path=False, moves=None, **answer):
        fresh = list(range(drawn[0], len(result)))
        drawn[0] = len(result)
        run.frame(caption,
                  calls={"values": cells, "tags": tags, "pointers": {"call": None if path else i},
                         "unread": list(range(i + 1, n)),
                         "marks": {"lit": [] if path else [i], "dim": list(range(n)) if path else list(range(i))}},
                  inbox={"values": inbox, "marks": inbox_marks or {}},
                  outbox={"values": outbox, "marks": outbox_marks or {}},
                  result={"values": result, "marks": {"path": list(range(len(result)))} if path
                          else {"good": fresh}},
                  moves=moves, **answer)

    def returned(value):
        result.append(shown(value))
        return len(result) - 1

    returned(None)
    frame({"en": "QueueFromStacks() starts with two empty stacks, inbox and outbox, and returns null.",
           "ko": "QueueFromStacks()는 빈 스택 inbox와 outbox 두 개로 시작하고 null을 반환합니다."})

    def shift():
        """_shift: when outbox is empty, every value in inbox moves over, one pop and push at a time."""
        if outbox:
            return False
        count = len(inbox)
        moved = 0
        while inbox:
            value = inbox[-1]
            outbox.append(value)
            moved += 1
            if moved == 1:
                cap = {"en": f"{ops[i]}(): outbox is empty, so inbox's {count} {'value moves' if count == 1 else 'values move'} "
                             f"over, top first: {value} goes first.",
                       "ko": f"{ops[i]}(): outbox가 비어 있어 inbox의 값 {count}개를 맨 위부터 옮깁니다. "
                             f"먼저 {josa(value, '이가')} 갑니다."}
            elif moved == count:
                cap = {"en": f"{value} lands last, on top of outbox: the oldest order is now the first one out.",
                       "ko": f"마지막으로 {josa(value, '이가')} outbox 맨 위에 놓여, 가장 오래된 주문이 가장 먼저 나갈 자리에 옵니다."}
            else:
                cap = {"en": f"{value} goes next, on top of {outbox[-2]}.",
                       "ko": f"다음으로 {josa(value, '이가')} {outbox[-2]} 위에 놓입니다."}
            frame(cap, inbox_marks={"lit": [len(inbox) - 1]}, outbox_marks={"good": [len(outbox) - 1]},
                  moves=[move(at("inbox", len(inbox) - 1), at("outbox", len(outbox) - 1))])
            inbox.pop()
        return True

    for i in range(1, n):
        op = ops[i]
        if op == "push":
            x = args[i][0]
            inbox.append(x)
            k = returned(None)
            frame({"en": f"push({x}): {x} goes on top of inbox, the back of the queue; push returns null.",
                   "ko": f"push({x}): {josa(x, '을를')} 큐의 뒤쪽인 inbox 맨 위에 넣고 null을 반환합니다."},
                  inbox_marks={"good": [len(inbox) - 1]},
                  moves=[move(at("calls", i), at("inbox", len(inbox) - 1), value=str(x)),
                         move(at("calls", i), at("result", k), value="null")])
        elif op in ("pop", "peek"):
            shifted = shift()
            top = len(outbox) - 1
            value = outbox[top]
            k = returned(value)
            moves = [move(at("outbox", top), at("result", k))]
            why = ({"en": "", "ko": ""} if shifted else
                   {"en": " outbox isn't empty, so nothing moves over;", "ko": " outbox가 비어 있지 않아 옮기지 않고"})
            if op == "pop":
                frame({"en": f"pop():{why['en']} it takes outbox's top, {value}, the front of the queue, and returns it.",
                       "ko": f"pop():{why['ko']} 큐의 맨 앞인 outbox 맨 위의 {josa(value, '을를')} 꺼내 반환합니다."},
                      outbox_marks={"lit": [top]}, moves=moves)
                outbox.pop()
            else:
                frame({"en": f"peek():{why['en']} outbox's top, {value}, is the front of the queue; it stays.",
                       "ko": f"peek():{why['ko']} 큐의 맨 앞인 outbox 맨 위의 {josa(value, '을를')} 반환하고 그대로 둡니다."},
                      outbox_marks={"lit": [top]}, moves=moves)
        elif op == "empty":
            value = not inbox and not outbox
            k = returned(value)
            if value:
                why = {"en": "both stacks are empty, so the queue is empty: true.",
                       "ko": "두 스택이 모두 비어 있으므로 큐가 비었습니다. true를 반환합니다."}
            else:
                held = len(inbox) + len(outbox)
                why = {"en": f"the stacks still hold {held} {'order' if held == 1 else 'orders'}, so it returns false.",
                       "ko": f"두 스택에 주문이 {held}개 남아 있으므로 false를 반환합니다."}
            frame({"en": f"empty(): {why['en']}", "ko": f"empty(): {why['ko']}"},
                  inbox_marks={"lit": list(range(len(inbox)))}, outbox_marks={"lit": list(range(len(outbox)))},
                  moves=[move(at("calls", i), at("result", k), value=shown(value))])
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
