#!/usr/bin/env python3.12
"""valid-brackets's Walkthrough: the reference solution (scripts/replay-solutions/valid-brackets.py), a stack of
the openers still open, recording one frame per bracket read on each sample Test Case. The stack is drawn upright on
a fixed base, each opener tagged with its index: an opener moves from its cell onto the top, and a closer pops the
top, which moves to the closer it is checked against.

    CODEBITE_DB=<database> scripts/walkthroughs/valid-brackets.py

writes common/src/main/resources/walkthroughs/valid-brackets.json.
"""
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import plural, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move, stack  # noqa: E402

SLUG = "valid-brackets"
OPENER_OF = {")": "(", "]": "[", "}": "{"}

wt = Walkthrough(
    {"en": "Valid Brackets", "ko": "괄호 중첩 검사하기"},
    {"en": "Keep the openers still open on a stack: each closer pops the top, the most recent opener, and the two "
           "must be the same type. At the end the stack must be empty.",
     "ko": "아직 열린 여는 괄호를 스택에 쌓습니다. 닫는 괄호는 맨 위의 가장 최근 여는 괄호를 꺼내고, 둘의 종류가 같아야 "
           "합니다. 끝까지 읽었을 때 스택은 비어 있어야 합니다."},
    views=[
        {"id": "brackets", "type": "array", "title": {"en": "brackets", "ko": "brackets (괄호)"}},
        {"id": "open", "type": "stack", "title": {"en": "open brackets", "ko": "열린 괄호"},
         "empty": {"en": "empty", "ko": "비어 있음"}},
    ],
)


def index_tag(i):
    return f"[{i}]"


def solve(brackets, run):
    """Solution.isValidBrackets with a frame per bracket read. Returns the answer as the Driver prints it."""
    chars = list(brackets)
    n = len(chars)
    opened = []  # indexes of the openers still open, bottom first (the solution keeps the characters)
    closed = []  # indexes of brackets already matched
    i = None

    def frame(caption, leaving=None, lit=(), good=(), bad=(), path=(), open_marks=None, moves=None, **answer):
        shown = opened + ([leaving] if leaving is not None else [])
        run.frame(caption,
                  brackets={"values": chars, "pointers": {"i": i},
                            "unread": list(range(i + 1, n)) if i is not None else [],
                            "marks": {"dim": list(closed), "path": list(path), "good": list(good),
                                      "bad": list(bad), "lit": list(lit)}},
                  open={**stack(shown, value=lambda j: chars[j], tag=index_tag), "marks": open_marks or {}},
                  moves=moves, **answer)

    frame({"en": f"{n} {plural(n, 'bracket', 'brackets')} to read, left to right. The stack of open brackets starts "
                 f"empty.",
           "ko": f"괄호 {n}개를 왼쪽부터 읽습니다. 열린 괄호의 스택은 비어 있습니다."})
    for i, ch in enumerate(chars):
        if ch not in OPENER_OF:
            opened.append(i)
            frame({"en": f"brackets[{i}] = {ch} is an opener: push it on top, as the most recent open bracket.",
                   "ko": f"brackets[{i}] = {ch}: 여는 괄호이므로 가장 최근에 열린 괄호로 스택 맨 위에 넣습니다."},
                  lit=[i], open_marks={"good": [len(opened) - 1]},
                  moves=[move(at("brackets", i), at("open", len(opened) - 1))])
            continue
        if not opened:
            frame({"en": f"brackets[{i}] = {ch} is a closer, but the stack is empty: nothing is open for it to close, "
                         f"so the answer is false.",
                   "ko": f"brackets[{i}] = {ch}: 닫는 괄호인데 스택이 비어 있어 닫을 괄호가 없습니다. 답은 false입니다."},
                  bad=[i], answer="false")
            return "false"
        top = len(opened) - 1
        j = opened.pop()
        if chars[j] != OPENER_OF[ch]:
            frame({"en": f"brackets[{i}] = {ch} pops the top, {chars[j]} from index {j}: a {ch} can't close a "
                         f"{chars[j]}, so the answer is false.",
                   "ko": f"brackets[{i}] = {ch}: 맨 위에서 꺼낸 괄호는 {j}번 칸의 {chars[j]} 괄호입니다. {ch} 괄호로는 "
                         f"{chars[j]} 괄호를 닫을 수 없으므로 답은 false입니다."},
                  leaving=j, bad=[i, j], open_marks={"bad": [top]},
                  moves=[move(at("open", top), at("brackets", i), mark="bad")], answer="false")
            return "false"
        closed += [j, i]
        frame({"en": f"brackets[{i}] = {ch} pops the top, {chars[j]} from index {j}: the same type, so the pair "
                     f"closes.",
               "ko": f"brackets[{i}] = {ch}: 맨 위에서 꺼낸 괄호는 {j}번 칸의 {chars[j]} 괄호입니다. 종류가 같으므로 "
                     f"한 쌍으로 닫힙니다."},
              leaving=j, good=[i, j], open_marks={"lit": [top]},
              moves=[move(at("open", top), at("brackets", i))])
    i = None
    if opened:
        left = len(opened)
        frame({"en": f"Every bracket is read, but {left} {plural(left, 'opener is', 'openers are')} still open on the "
                     f"stack, so the answer is false.",
               "ko": f"모든 괄호를 읽었지만 스택에 열린 괄호가 {left}개 남아 있으므로 답은 false입니다."},
              bad=opened, open_marks={"bad": list(range(left))}, answer="false")
        return "false"
    frame({"en": "Every bracket is read and the stack is empty: every closer matched the most recent opener, so the "
                 "answer is true.",
           "ko": "모든 괄호를 읽었고 스택이 비었습니다. 모든 닫는 괄호가 가장 최근에 열린 괄호와 짝이 맞았으므로 답은 "
                 "true입니다."},
          path=range(n), answer="true")
    return "true"


for number, sample in enumerate(sample_cases(SLUG), start=1):
    brackets = sample["input"].strip()
    run = sample_run(wt, number, sample, input=f'brackets = "{brackets}"')
    solve(brackets, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
