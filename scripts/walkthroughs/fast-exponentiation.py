#!/usr/bin/env python3.12
"""fast-exponentiation's Walkthrough: the reference solution (scripts/replay-solutions/fast-exponentiation.py),
repeated squaring, recording a frame for a negative exponent's flip, then per bit of the exponent one frame reading
it (a 1 multiplies the result) and one squaring the base, on each sample Test Case. The exponent's bits are an array
lowest first, with pointer k on the bit the loop reads (exponent >>= 1 is k moving right); the squares are an array
under them, cell k holding the base squared k times, so a bit and the power it stands for share a column.

    CODEBITE_DB=<database> scripts/walkthroughs/fast-exponentiation.py

writes common/src/main/resources/walkthroughs/fast-exponentiation.json.
"""
import os
import sys
from fractions import Fraction

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import josa, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move  # noqa: E402

SLUG = "fast-exponentiation"
SUPERSCRIPT = str.maketrans("0123456789", "⁰¹²³⁴⁵⁶⁷⁸⁹")

wt = Walkthrough(
    {"en": "Fast Exponentiation", "ko": "빠른 거듭제곱"},
    {"en": "Write the exponent in binary: bit k stands for base^(2^k), which squaring the base k times gives. "
           "Multiply the result by the squares whose bit is 1, so the loop runs once per bit, not once per unit.",
     "ko": "지수를 이진수로 쓰면 k번 비트는 base^(2^k)를 뜻하고, 이 값은 base를 k번 제곱하면 나옵니다. "
           "비트가 1인 자리의 제곱만 result에 곱하므로, 반복은 지수의 크기만큼이 아니라 비트 수만큼 돕니다."},
    views=[
        {"id": "bits", "type": "array",
         "title": {"en": "|exponent|'s bits, lowest first (tag: place value)", "ko": "|exponent|의 비트, 낮은 자리부터 (태그: 자릿값)"}},
        {"id": "squares", "type": "array",
         "title": {"en": "base squared k times (tag: power of b)", "ko": "k번 제곱한 base (태그: b의 거듭제곱)"}},
        {"id": "result", "type": "output", "title": "result"},
    ],
)


def shown(x):
    """A value as short as it reads exactly: 81, 0.5 as 1/2, else 6 significant digits."""
    if x == int(x) and abs(x) < 1e12:
        return str(int(x))
    f = Fraction(x).limit_denominator(10 ** 6)
    if float(f) == x and len(str(f)) <= 7:
        return str(f)
    return f"{x:.6g}"


def solve(base, exponent, run):
    """Solution.power with frames per bit. Returns the answer as the Driver prints it."""
    given_base, given_exp = base, exponent
    e = abs(exponent)
    n = max(1, e.bit_length())
    bits = [(e >> k) & 1 for k in range(n)]
    squares = [""] * (n + 1)
    squares[0] = shown(base)
    result = 1.0
    used = []  # the k whose square went into the result
    k = None
    b_name = "b"

    def frame(caption, lit_bits=(), lit_sq=(), good_sq=(), result_mark=None, path=False, moves=None, **answer):
        run.frame(caption,
                  bits={"values": bits, "tags": [[i, str(1 << i)] for i in range(n)], "pointers": {"k": k},
                        "marks": {"path": used, "lit": list(lit_bits)} if path else {"lit": list(lit_bits)}},
                  squares={"values": list(squares),
                           "tags": [[i, f"{b_name}{str(1 << i).translate(SUPERSCRIPT)}"] for i in range(n + 1)],
                           "unread": [i for i in range(n + 1) if squares[i] == ""],
                           "marks": {"path": used} if path else {"lit": list(lit_sq), "good": list(good_sq)}},
                  result={"values": [shown(result)],
                          "marks": {"path": [0]} if path else {result_mark: [0]} if result_mark else {}},
                  moves=moves, **answer)

    binary = format(e, "b")
    if exponent < 0:
        frame({"en": f"base = {shown(given_base)}, exponent = {given_exp}; the bits drawn are those of |exponent| = {e} "
                     f"({binary} in binary). result starts at 1.",
               "ko": f"base = {shown(given_base)}, exponent = {given_exp}, 그린 비트는 |exponent| = {e}의 "
                     f"비트(이진수 {binary})입니다. result는 1에서 시작합니다."})
        base, exponent = 1 / base, -exponent
        squares[0] = shown(base)
        frame({"en": f"The exponent is negative, so base^{given_exp} = (1/base)^{e}: base = {squares[0]}, exponent = {e}. "
                     f"b below is this new base.",
               "ko": f"지수가 음수이므로 base^{given_exp} = (1/base)^{e}, 곧 base = {squares[0]}, exponent = {josa(e, '(으)로')} 바꿉니다. "
                     "아래 b는 이 새 base입니다."},
              good_sq=[0], moves=[move(None, at("squares", 0), value=f"1/{shown(given_base)}")])
    else:
        frame({"en": f"base = {shown(given_base)}, exponent = {e} = {binary} in binary; b below is base. result starts at 1.",
               "ko": f"base = {shown(given_base)}, exponent = {e}(이진수 {binary}), 아래 b는 base입니다. result는 1에서 시작합니다."})
    k = 0
    while exponent:
        power = f"b{str(1 << k).translate(SUPERSCRIPT)}"
        if exponent & 1:
            before = result
            result *= base
            used.append(k)
            frame({"en": f"Bit {k} is 1, so result *= {power}: {shown(before)} × {squares[k]} = {shown(result)}.",
                   "ko": f"{k}번 비트가 1이므로 result *= {power}: {shown(before)} × {squares[k]} = {shown(result)}."},
                  lit_bits=[k], lit_sq=[k], result_mark="good",
                  moves=[move(at("squares", k), at("result", 0), value=f"×{squares[k]}", mark="good")])
        else:
            frame({"en": f"Bit {k} is 0, so {power} is not part of the answer: result stays {shown(result)}.",
                   "ko": f"{k}번 비트가 0이므로 {power} 항은 답에 들어가지 않습니다. result는 {shown(result)} 그대로입니다."},
                  lit_bits=[k], lit_sq=[k])
        base *= base
        exponent >>= 1
        squares[k + 1] = shown(base)
        nxt = f"b{str(1 << (k + 1)).translate(SUPERSCRIPT)}"
        rest = ({"en": f" exponent >>= 1 = {exponent}: on to bit {k + 1}.", "ko": f" exponent >>= 1 = {exponent}, {k + 1}번 비트로 넘어갑니다."}
                if exponent else
                {"en": " exponent >>= 1 = 0: no bits left, so the loop stops.", "ko": " exponent >>= 1 = 0, 남은 비트가 없어 반복을 멈춥니다."})
        sq = f"({squares[k]})²" if "/" in squares[k] else f"{squares[k]}²"
        frame({"en": f"base *= base: {sq} = {squares[k + 1]}, which is {nxt}.{rest['en']}",
               "ko": f"base *= base: {sq} = {squares[k + 1]}, 곧 {nxt}입니다.{rest['ko']}"},
              good_sq=[k + 1], moves=[move(at("squares", k), at("squares", k + 1), value=sq)])
        if exponent:
            k += 1
    answer = f"{result:.5f}"
    if used:
        product = " × ".join(f"b{str(1 << i).translate(SUPERSCRIPT)}" for i in used)
        en = f"The 1 bits picked {product} = {shown(result)}: answer {answer}."
        ko = f"1인 비트가 고른 {product} = {shown(result)}, 답은 {answer}입니다."
    else:
        en, ko = f"No bit is 1, so result stays 1: answer {answer}.", f"1인 비트가 없어 result는 1 그대로이고, 답은 {answer}입니다."
    k = None
    frame({"en": en, "ko": ko}, path=True, answer=answer)
    return answer


for number, sample in enumerate(sample_cases(SLUG), start=1):
    base_text, exp_text = (line.strip() for line in sample["input"].split("\n"))
    run = sample_run(wt, number, sample, input=f"base = {base_text}, exponent = {exp_text}")
    solve(float(base_text), int(exp_text), run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
