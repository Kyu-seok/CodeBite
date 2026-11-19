#!/usr/bin/env python3.12
"""balance-brackets-with-wildcards' Walkthrough: the reference solution
(scripts/replay-solutions/balance-brackets-with-wildcards.py), one pass keeping the range [low, high] of how many `(`
can be open after each character, recording one frame per character and one per clamp of low to 0, on each sample
Test Case.

The ranges are an `intervals` view, one row per character read, each moving in from its character, over an axis with
the 0 line drawn, so the range sliding below 0 (failure) or being cut at 0 (a clamp) shows against it. No sample
clamps low, so an extra run does.

    CODEBITE_DB=<database> scripts/walkthroughs/balance-brackets-with-wildcards.py

writes common/src/main/resources/walkthroughs/balance-brackets-with-wildcards.json.
"""
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import josa, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move  # noqa: E402

SLUG = "balance-brackets-with-wildcards"

wt = Walkthrough(
    {"en": "Balance Brackets with Wildcards", "ko": "와일드카드가 있는 괄호 균형 맞추기"},
    {"en": "Keep the range of how many ( can be open so far: ( moves both ends up, ) both down, and * widens it, "
           "since it could close one or open one. Fail when even the top goes below 0; never let the bottom go "
           "below 0; at the end, 0 must be in the range.",
     "ko": "지금까지 열려 있을 수 있는 ( 개수의 범위를 기억합니다. ( 괄호는 양 끝을 올리고, ) 괄호는 양 끝을 내리고, * 와일드카드는 하나를 "
           "닫을 수도 열 수도 있으니 범위를 넓힙니다. 위쪽 끝까지 0 아래로 내려가면 실패이고, 아래쪽 끝은 0 아래로 "
           "내려가지 않게 하며, 끝에서 범위에 0이 들어 있어야 합니다."},
    views=[
        {"id": "brackets", "type": "array", "title": {"en": "brackets", "ko": "brackets (괄호)"}},
        {"id": "open", "type": "intervals",
         "title": {"en": "how many ( can be open, after each character", "ko": "글자마다 열려 있을 수 있는 ( 개수"}},
    ],
)

ROWS = {"en": "[low, high]", "ko": "[low, high] (최소, 최대)"}
ZERO = {"en": "floor", "ko": "바닥"}


def solve(brackets, run):
    """Solution.canBalance with a frame per character and per clamp. Returns the answer as the Driver prints it."""
    chars = list(brackets)
    n = len(chars)
    rows = []

    def frame(caption, i=None, rows_marks=None, zero_mark=None, chars_marks=None, moves=None, **answer):
        run.frame(caption,
                  brackets={"values": chars, "pointers": {"i": i},
                            "unread": list(range((i if i is not None else n - 1) + 1, n)),
                            "marks": chars_marks or ({"lit": [i]} if i is not None else {})},
                  open={"groups": [{"label": ROWS, "intervals": [list(r) for r in rows], "marks": rows_marks or {}}],
                        "points": [{"at": 0, "label": ZERO, "mark": zero_mark}] if zero_mark else
                                  [{"at": 0, "label": ZERO}]},
                  moves=moves, **answer)

    frame({"en": f"\"{brackets}\" has {n} characters. Before any of them, exactly 0 ( are open.",
           "ko": f"\"{brackets}\"에는 글자가 {n}개 있습니다. 아무것도 읽기 전에는 열린 ( 괄호가 정확히 0개입니다."})
    low = high = 0
    for i, char in enumerate(chars):
        was_low, was_high = low, high
        match char:
            case "(":
                low += 1
                high += 1
                en = f"'(' opens one more: [{was_low}, {was_high}] becomes [{low}, {high}]."
                ko = f"'(' 괄호는 하나를 더 엽니다: [{was_low}, {was_high}] 범위가 [{low}, {high}] 범위가 됩니다."
            case ")":
                low -= 1
                high -= 1
                en = f"')' closes one: [{was_low}, {was_high}] becomes [{low}, {high}]."
                ko = f"')' 괄호는 하나를 닫습니다: [{was_low}, {was_high}] 범위가 [{low}, {high}] 범위가 됩니다."
            case _:
                low -= 1
                high += 1
                en = (f"'*' could close one or open one, so the range widens both ways: [{was_low}, {was_high}] "
                      f"becomes [{low}, {high}].")
                ko = (f"'*' 와일드카드는 하나를 닫을 수도 열 수도 있어 범위가 양쪽으로 넓어집니다: [{was_low}, {was_high}] 범위가 "
                      f"[{low}, {high}] 범위가 됩니다.")
        rows.append([low, high])
        moves = [move(at("brackets", i), at("open", [0, i]), value=char)]
        if high < 0:
            frame({"en": f"{en[:-1]}, so even the most ( possible leaves {-high} ')' with nothing to close. "
                         "Answer: false.",
                   "ko": f"{ko[:-len('됩니다.')]}되므로, ( 개수가 가장 많아도 닫을 것이 없는 ')' 괄호가 {-high}개 "
                         "남습니다. 답은 false입니다."},
                  i=i, rows_marks={"bad": [i]}, zero_mark="bad", chars_marks={"bad": [i]}, moves=moves, answer="false")
            return
        frame({"en": en, "ko": ko}, i=i, rows_marks={"good": [i]}, moves=moves)
        if low < 0:
            neg = low
            low = 0
            rows[i] = [low, high]
            frame({"en": f"A count of open ( can't be {neg}: those choices closed a ( "
                         f"that was never opened. Cut the range at 0: [0, {high}].",
                   "ko": f"열리지 않은 ( 괄호를 닫는 선택이라 열린 ( 개수가 {josa(neg, '이가')} 될 수는 없으므로, "
                         f"범위를 0에서 잘라 [0, {high}] 범위로 둡니다."},
                  i=i, rows_marks={"good": [i]}, zero_mark="lit",
                  moves=[move(None, at("open", [0, i]), value="max(low, 0)")])
    if low == 0:
        frame({"en": f"Every character read and the range is [{low}, {high}]: 0 is in it, so some choice of the "
                     "wildcards closes every (. Answer: true.",
               "ko": f"모든 글자를 읽었고 범위 [{low}, {high}] 안에 0이 들어 있으므로, 와일드카드를 잘 정하면 "
                     "모든 ( 괄호가 닫힙니다. 답은 true입니다."},
              rows_marks={"path": [n - 1]}, zero_mark="path", chars_marks={"path": list(range(n))}, answer="true")
    else:
        frame({"en": f"Every character read and the range is [{low}, {high}]: at least {low} ( stay open whatever the "
                     "wildcards are. Answer: false.",
               "ko": f"모든 글자를 읽었고 범위가 [{low}, {high}] 범위라서, 와일드카드를 어떻게 정해도 ( 괄호가 {low}개 이상 "
                     "열린 채로 남습니다. 답은 false입니다."},
              rows_marks={"bad": [n - 1]}, zero_mark="bad", answer="false")


def domain(brackets):
    low = high = 0
    lo, hi = 0, 1
    for char in brackets:
        d = {"(": (1, 1), ")": (-1, -1)}.get(char, (-1, 1))
        low, high = low + d[0], high + d[1]
        lo, hi = min(lo, low, high), max(hi, high)
        if high < 0:
            break
        low = max(low, 0)
    return [lo, hi]


def start(brackets, number=None, sample=None):
    setup = {"open": {"domain": domain(brackets)}}
    if sample is not None:
        return sample_run(wt, number, sample, input=f"brackets = \"{brackets}\"", setup=setup)
    return wt.run({"en": "Extra: the range is cut at 0", "ko": "추가: 범위를 0에서 자름"},
                  input=f"brackets = \"{brackets}\"", expected="true", extra=True, setup=setup)


for number, sample in enumerate(sample_cases(SLUG), start=1):
    brackets = sample["input"].strip()
    solve(brackets, start(brackets, number, sample))
# No sample's low goes below 0 and survives (example 3 fails first), so this extra run clamps it twice.
EXTRA = "(*))"
solve(EXTRA, start(EXTRA))
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
