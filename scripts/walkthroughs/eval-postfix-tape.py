#!/usr/bin/env python3.12
"""eval-postfix-tape's Walkthrough: the reference solution
(scripts/replay-solutions/eval-postfix-tape.py), an operand stack fed by the tokens left to right,
recording one frame per number pushed and two per operator (the two numbers it pops, then its result
pushed) on each sample Test Case. The stack is drawn upright on a fixed base: a number moves from its token
onto the top, and an operator's result moves from the operator's token into the place a held.

    CODEBITE_DB=<database> scripts/walkthroughs/eval-postfix-tape.py

writes common/src/main/resources/walkthroughs/eval-postfix-tape.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import josa, plural, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move  # noqa: E402

SLUG = "eval-postfix-tape"
OPS = ("+", "-", "*", "/")
SHOWN = {"+": "+", "-": "−", "*": "×", "/": "÷"}

wt = Walkthrough(
    {"en": "Eval Postfix Tape", "ko": "후위 표기식 계산"},
    {"en": "Read the tokens left to right with a stack: a number goes on top, and an operator pops the top two "
           "(b, then a under it) and pushes a op b, so the number pushed earlier is the left operand.",
     "ko": "토큰을 왼쪽부터 읽으며 스택을 씁니다. 수는 맨 위에 넣고, 연산자는 맨 위의 두 수(b, 그 아래 a)를 꺼내 "
           "a op b를 넣습니다. 먼저 넣은 수가 왼쪽 피연산자입니다."},
    views=[
        {"id": "tokens", "type": "array", "title": {"en": "tokens", "ko": "tokens (토큰)"}},
        {"id": "stack", "type": "stack", "title": {"en": "stack", "ko": "스택"},
         "empty": {"en": "empty", "ko": "비어 있음"}},
    ],
)


def solve(tokens, run):
    """Solution.evalPostfix with a frame per push and two per operator. Returns the answer as the Driver prints it."""
    n = len(tokens)
    stack = []
    i = None

    def frame(caption, tok_lit=(), stack_lit=(), stack_good=(), stack_tags=(), path=False, moves=None, **answer):
        run.frame(caption,
                  tokens={"values": tokens, "pointers": {"i": i},
                          "unread": list(range(i + 1, n)) if i is not None else [],
                          "marks": {"lit": list(tok_lit), "dim": [] if i is None else list(range(i))}},
                  stack={"values": stack, "tags": list(stack_tags),
                         "marks": {"path": [0] if path else [], "good": list(stack_good), "lit": list(stack_lit)}},
                  moves=moves, **answer)

    numbers = sum(t not in OPS for t in tokens)
    frame({"en": f"{n} {plural(n, 'token', 'tokens')}: {numbers} {plural(numbers, 'number', 'numbers')} and "
                 f"{n - numbers} {plural(n - numbers, 'operator', 'operators')}. The stack starts empty.",
           "ko": f"토큰 {n}개: 수 {numbers}개와 연산자 {n - numbers}개입니다. 스택은 비어 있습니다."})
    for i, token in enumerate(tokens):
        if token not in OPS:
            stack.append(int(token))
            frame({"en": f"tokens[{i}] = {token} is a number: push it on top.",
                   "ko": f"tokens[{i}] = {token}: 수이므로 맨 위에 넣습니다."},
                  tok_lit=[i], stack_good=[len(stack) - 1],
                  moves=[move(at("tokens", i), at("stack", len(stack) - 1))])
            continue
        top = len(stack) - 1
        right, left = stack[top], stack[top - 1]
        frame({"en": f"tokens[{i}] = {token} is an operator: pop b = {right} from the top, then a = {left} under it.",
               "ko": f"tokens[{i}] = {token}: 연산자이므로 맨 위의 b = {right}, 그 아래 a = {josa(left, '을를')} 꺼냅니다."},
              tok_lit=[i], stack_lit=[top - 1, top], stack_tags=[[top - 1, "a"], [top, "b"]])
        stack.pop()
        stack.pop()
        match token:
            case "+":
                result = left + right
            case "-":
                result = left - right
            case "*":
                result = left * right
            case _:
                result = int(left / right)  # truncates toward zero
        stack.append(result)
        sign = SHOWN[token]
        note = {"en": "", "ko": ""}
        if token == "/" and left % right != 0:
            note = {"en": f" ({left / right:.2f} truncated toward zero)", "ko": f"({left / right:.2f}의 소수 부분은 0 쪽으로 버림)"}
        frame({"en": f"a {sign} b = {left} {sign} {right} = {result}{note['en']}: push it where a was.",
               "ko": f"a {sign} b = {left} {sign} {right} = {result}{note['ko']}. 이 값을 a가 있던 자리에 넣습니다."},
              tok_lit=[i], stack_good=[len(stack) - 1],
              moves=[move(at("tokens", i), at("stack", len(stack) - 1), value=f"{left}{sign}{right}")])
    i = None
    frame({"en": f"Every token is read and one number is left on the stack: the expression is {stack[0]}.",
           "ko": f"모든 토큰을 읽었고 스택에 수 하나가 남았습니다: 식의 값은 {stack[0]}입니다."},
          path=True, answer=str(stack[0]))


for number, sample in enumerate(sample_cases(SLUG), start=1):
    tokens = json.loads(sample["input"])
    run = sample_run(wt, number, sample, input=f"tokens = {sample['input']}")
    solve(tokens, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
