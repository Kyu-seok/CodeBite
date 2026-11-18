#!/usr/bin/env python3.12
"""add-without-plus's Walkthrough: the reference solution (scripts/replay-solutions/add-without-plus.py), the carry
loop, recording three frames per pass on each sample Test Case: the carries ((a & b) << 1), the carry-less sum
(a ^ b), and the carries becoming the next b. a, b and the carries are each an array of bits, the sign bit first.

The solution works in 32 bits; the drawing shows the fewest bits that hold every value of the run in two's
complement, the bits above them copying the sign bit, so the setup caption says how many are left out.

    CODEBITE_DB=<database> scripts/walkthroughs/add-without-plus.py

writes common/src/main/resources/walkthroughs/add-without-plus.json.
"""
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import josa, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move, span  # noqa: E402

SLUG = "add-without-plus"
MASK = 0xFFFFFFFF
SIGN_BIT = 0x80000000

wt = Walkthrough(
    {"en": "Add Without the Plus Sign", "ko": "더하기 없이 더하기"},
    {"en": "a ^ b adds every column without carrying and (a & b) << 1 is the carries, one column left; "
           "add those carries the same way until there are none.",
     "ko": "a ^ b는 올림 없이 자리마다 더한 값이고 (a & b) << 1은 한 칸 왼쪽으로 올라간 올림이므로, "
           "올림이 없어질 때까지 같은 방법으로 더합니다."},
    views=[
        {"id": "a", "type": "array", "title": {"en": "a (tag: place value)", "ko": "a (태그: 자릿값)"}},
        {"id": "b", "type": "array", "title": {"en": "b (what is left to add)", "ko": "b (더할 남은 값)"}},
        {"id": "carry", "type": "array", "title": {"en": "carry = (a & b) << 1", "ko": "carry = (a & b) << 1"}},
    ],
)


def signed(v):
    """A 32-bit pattern read as two's complement."""
    return v if v < SIGN_BIT else ~(v ^ MASK)


def bits_needed(v):
    """The fewest bits that hold the signed `v` in two's complement."""
    return (v if v >= 0 else ~v).bit_length() + 1


def passes(first, second):
    """The loop's passes as (a, b, carry, new a), signed, as the reference solution runs them."""
    a, b = first & MASK, second & MASK
    out = []
    while b:
        carry = ((a & b) << 1) & MASK
        new_a = (a ^ b) & MASK
        out.append((signed(a), signed(b), signed(carry), signed(new_a)))
        a, b = new_a, carry
    return out, signed(a)


def solve(first, second, run):
    """Solution.combineCounters with three frames per pass. Returns the sum."""
    steps, result = passes(first, second)
    seen = [first, second, result] + [v for step in steps for v in step]
    width = max(4, *(bits_needed(v) for v in seen))
    hidden = 32 - width

    def bits(v):
        return [int(c) for c in format(v & ((1 << width) - 1), f"0{width}b")]

    places = [-(1 << (width - 1))] + [1 << (width - 2 - p) for p in range(width - 1)]

    def cols(ps):
        return ", ".join(str(places[p]) for p in ps)

    a, b, carry = first, second, 0

    def frame(caption, marks=None, moves=None, path=False, **answer):
        marks = marks or {}

        def view(name, value):
            return {"values": bits(value),
                    "spans": {"value": span(0, width - 1, f"{name} = {value}", mark="path" if path and name == "a" else None)},
                    "marks": {"path": list(range(width))} if path and name == "a" else marks.get(name, {})}
        a_view = view("a", a)
        a_view["tags"] = [[p, str(places[p])] for p in range(width)]
        run.frame(caption, a=a_view, b=view("b", b), carry=view("carry", carry), moves=moves, **answer)

    frame({"en": f"a = {first} and b = {second} as {width}-bit two's complement: the top bit counts {places[0]}, "
                 f"and the {hidden} bits above it, left out here, copy it.",
           "ko": f"a = {first}, b = {josa(second, "을를")} {width}비트 2의 보수로 그렸습니다. 맨 위 비트는 {josa(places[0], '을를')} 뜻하고, "
                 f"생략한 그 위 {hidden}비트는 맨 위 비트와 같습니다."})
    for old_a, old_b, new_carry, new_a in steps:
        ab, bb, cb_old, cb = bits(old_a), bits(old_b), bits(carry), bits(new_carry)
        both = [p for p in range(width) if ab[p] and bb[p]]
        changed = [p for p in range(width) if cb[p] != cb_old[p]]
        carry = new_carry
        moves = [move(at("a", p + 1), at("carry", p), value=f"{ab[p + 1]}&{bb[p + 1]}") if p + 1 < width
                 else move(dst=at("carry", p), value="0") for p in changed]
        if both:
            en = (f"Column{'s' if len(both) > 1 else ''} {cols(both)} hold{'' if len(both) > 1 else 's'} a 1 in both a and b, "
                  f"so {'each' if len(both) > 1 else 'it'} carries a 1 one column left: carry = {carry}.")
            ko = f"a와 b가 모두 1인 자리({cols(both)})마다 1이 한 칸 왼쪽으로 올라갑니다. carry = {josa(carry, '이가')} 됩니다."
        else:
            en = f"No column holds a 1 in both a and b, so nothing carries: carry = {carry}."
            ko = f"a와 b가 모두 1인 자리가 없어 올림이 없습니다. carry = {josa(carry, '이가')} 됩니다."
        frame({"en": en, "ko": ko}, moves=moves,
              marks={"a": {"lit": both}, "b": {"lit": both}, "carry": {"good": changed}})

        ones = [p for p in range(width) if bb[p]]
        a = new_a
        frame({"en": f"a = a ^ b = {old_a} ^ {old_b} = {a}: each 1 in b flips a's bit in its column ({cols(ones)}).",
               "ko": f"a = a ^ b = {old_a} ^ {old_b} = {josa(a, '이가')} 됩니다. b에 1이 있는 자리({cols(ones)})마다 a의 비트가 뒤집힙니다."},
              moves=[move(at("b", p), at("a", p), value="^1") for p in ones],
              marks={"a": {"good": ones}, "b": {"lit": ones}})

        nb = bits(carry)
        changed = [p for p in range(width) if nb[p] != bb[p]]
        b = carry
        if b:
            en, ko = (f"b = carry = {b}: the carries still have to be added, so the loop goes on.",
                      f"b = carry = {b}이므로 아직 더할 올림이 남아 반복을 계속합니다.")
        else:
            en, ko = (f"b = carry = {b}: nothing is left to add, so the loop stops.",
                      f"b = carry = {b}이므로 더할 것이 없어 반복을 멈춥니다.")
        frame({"en": en, "ko": ko},
              moves=[move(at("carry", p), at("b", p)) for p in changed],
              marks={"b": {"good": changed}, "carry": {"lit": changed}})

    assert a == result
    if not steps:
        why = {"en": "b is 0 from the start, so the loop never runs and a is already the sum",
               "ko": "b가 처음부터 0이라 반복 없이 a가 바로 합입니다"}
    elif result < 0:
        why = {"en": "b is 0, so a holds the whole sum; its top bit is 1, so it is negative",
               "ko": "b가 0이라 a가 합 전체이고, 맨 위 비트가 1이라 음수입니다"}
    else:
        why = {"en": "b is 0, so a holds the whole sum", "ko": "b가 0이라 a가 합 전체입니다"}
    frame({"en": f"{why['en']}: answer {result}.", "ko": f"{why['ko']}. 답은 {result}입니다."},
          path=True, answer=str(result))
    return result


for number, sample in enumerate(sample_cases(SLUG), start=1):
    first, second = (int(line) for line in sample["input"].split("\n"))
    run = sample_run(wt, number, sample, input=f"firstCount = {first}, secondCount = {second}")
    solve(first, second, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
