#!/usr/bin/env python3.12
"""multiply-as-text's Walkthrough: the reference solution (scripts/replay-solutions/multiply-as-text.py), long
multiplication into one array of places, recording one frame per digit pair, one per place of the carry pass and
one for the leading zeros dropped, on each sample Test Case. The places are drawn highest first, as the product is
written, each tagged 10^k; the carry is a one-cell array, so it is an address.

    CODEBITE_DB=<database> scripts/walkthroughs/multiply-as-text.py

writes common/src/main/resources/walkthroughs/multiply-as-text.json.
"""
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import josa, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move  # noqa: E402

SLUG = "multiply-as-text"
SUPERSCRIPT = str.maketrans("0123456789", "⁰¹²³⁴⁵⁶⁷⁸⁹")

wt = Walkthrough(
    {"en": "Multiply As Text", "ko": "문자열로 곱하기"},
    {"en": "The digits at places i and j (counted from the right) multiply into place i + j; "
           "after every pair is added, one carry pass from the lowest place leaves one digit per place.",
     "ko": "오른쪽에서 i번째와 j번째 자리 숫자의 곱은 i + j번 자리에 더해지고, "
           "모든 쌍을 더한 뒤 가장 낮은 자리부터 올림을 한 번 넘기면 자리마다 숫자 하나가 남습니다."},
    views=[
        {"id": "left", "type": "array", "title": {"en": "left (tag: place)", "ko": "left (태그: 자리)"}},
        {"id": "right", "type": "array", "title": {"en": "right (tag: place)", "ko": "right (태그: 자리)"}},
        {"id": "digits", "type": "array", "title": {"en": "digits (tag: place)", "ko": "digits (태그: 자리)"}},
        {"id": "carry", "type": "array", "title": {"en": "carry", "ko": "carry (올림)"}},
    ],
)


def power_tags(n):
    """Tags 10^k over n cells drawn highest place first."""
    return [[n - 1 - k, f"10{str(k).translate(SUPERSCRIPT)}"] for k in range(n)]


def solve(left, right, run):
    """Solution.productAsText with a frame per digit pair and per place. Returns the product text."""
    digits = [0] * (len(left) + len(right))
    carry = 0

    def place(k):
        """Where place k (10^k) is drawn: the highest place first."""
        return len(digits) - 1 - k

    def frame(caption, lit_left=(), lit_right=(), lit=(), good=(), bad=(), path=False, carry_mark=None,
              moves=None, **answer):
        run.frame(caption,
                  left={"values": list(left), "tags": power_tags(len(left)), "marks": {"lit": list(lit_left)}},
                  right={"values": list(right), "tags": power_tags(len(right)), "marks": {"lit": list(lit_right)}},
                  digits={"values": list(reversed(digits)),
                          "tags": power_tags(len(digits)),
                          "marks": {"path": list(range(len(digits)))} if path else
                          {"lit": [place(k) for k in lit], "good": [place(k) for k in good],
                           "bad": [place(k) for k in bad]}},
                  carry={"values": [carry], "marks": {carry_mark: [0]} if carry_mark else {}},
                  moves=moves, **answer)

    frame({"en": f"\"{left}\" × \"{right}\": digits has {len(left)} + {len(right)} = {len(digits)} places, all 0. "
                 "The pair at places i and j adds its product into place i + j.",
           "ko": f"\"{left}\" × \"{right}\": digits는 {len(left)} + {len(right)} = {len(digits)}자리이고 모두 0입니다. "
                 "i번 자리와 j번 자리 숫자의 곱은 i + j번 자리에 더합니다."})
    for i, a in enumerate(reversed(left)):
        for j, b in enumerate(reversed(right)):
            x, y = ord(a) - ord("0"), ord(b) - ord("0")
            digits[i + j] += x * y
            k = i + j
            frame({"en": f"{x} (left, place {i}) × {y} (right, place {j}) = {x * y} goes into place {i} + {j} = {k}, "
                         f"which holds {digits[k]} now.",
                   "ko": f"{x}(left의 {i}번 자리) × {y}(right의 {j}번 자리) = {josa(x * y, '을를')} "
                         f"{i} + {j} = {k}번 자리에 더해 {josa(digits[k], '이가')} 됩니다."},
                  lit_left=[len(left) - 1 - i], lit_right=[len(right) - 1 - j], good=[k],
                  moves=[move(at("right", len(right) - 1 - j), at("digits", place(k)), value=f"+{x}×{y}")])
    for k in range(len(digits)):
        total = digits[k] + carry
        carry_in = carry
        carry, digits[k] = divmod(total, 10)
        changed = digits[k] != total - carry_in or carry != carry_in
        moves = [move(at("carry", 0), at("digits", place(k)), value=f"+{carry_in}"),
                 move(at("digits", place(k)), at("carry", 0), value=str(carry))] if changed else None
        if carry:
            en = f"Place {k}: {total - carry_in} + carry {carry_in} = {total}, so {digits[k]} stays and {carry} carries to place {k + 1}."
            ko = (f"{k}번 자리: {total - carry_in} + carry {carry_in} = {total}이므로 "
                  f"{josa(digits[k], '을를')} 남기고 {josa(carry, '을를')} {k + 1}번 자리로 올립니다.")
        else:
            en = f"Place {k}: {total - carry_in} + carry {carry_in} = {total}, one digit, so nothing carries."
            ko = f"{k}번 자리: {total - carry_in} + carry {carry_in} = {total}, 한 자리 수라 올림이 없습니다."
        frame({"en": en, "ko": ko}, lit=[] if changed else [k], good=[k] if changed else [],
              carry_mark="good" if carry != carry_in else None, moves=moves)
    zeros = []
    while len(digits) - len(zeros) > 1 and digits[len(digits) - 1 - len(zeros)] == 0:
        zeros.append(len(digits) - 1 - len(zeros))
    if zeros:
        which = ", ".join(str(k) for k in reversed(zeros))
        frame({"en": f"Place{'s' if len(zeros) > 1 else ''} {which} {'are' if len(zeros) > 1 else 'is a'} leading "
                     f"zero{'s' if len(zeros) > 1 else ''}, so {'they are' if len(zeros) > 1 else 'it is'} dropped.",
               "ko": f"{which}번 자리는 맨 앞의 0이라 버립니다."},
              bad=zeros, moves=[move(at("digits", place(k)), mark="bad") for k in zeros])
        for _ in zeros:
            digits.pop()
    product = "".join(chr(ord("0") + d) for d in reversed(digits))
    frame({"en": f"Read from the highest place down, the digits spell the product: answer \"{product}\".",
           "ko": f"가장 높은 자리부터 읽은 숫자가 곱입니다. 답은 \"{product}\"입니다."},
          path=True, answer=product)
    return product


for number, sample in enumerate(sample_cases(SLUG), start=1):
    left, right = (line.strip() for line in sample["input"].split("\n"))
    run = sample_run(wt, number, sample, input=f"left = \"{left}\", right = \"{right}\"")
    solve(left, right, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
