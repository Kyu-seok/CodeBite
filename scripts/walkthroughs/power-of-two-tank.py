#!/usr/bin/env python3.12
"""power-of-two-tank's Walkthrough: the reference solution (scripts/replay-solutions/power-of-two-tank.py),
n > 0 and n & (n - 1) == 0, recording a frame for n - 1, one for the &, and one for the answer on each sample Test
Case. n, n - 1 and n & (n - 1) are each an array of bits tagged with place values, drawn with the bits n needs (n is
positive in every sample; a number that isn't stops at n > 0 with no bits drawn).

    CODEBITE_DB=<database> scripts/walkthroughs/power-of-two-tank.py

writes common/src/main/resources/walkthroughs/power-of-two-tank.json.
"""
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import josa, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move, span  # noqa: E402

SLUG = "power-of-two-tank"

wt = Walkthrough(
    {"en": "Power of Two Tank", "ko": "2의 거듭제곱 수조"},
    {"en": "A power of two has exactly one 1 bit. n − 1 turns that lowest 1 into 0 and the bits below it into 1s, "
           "so n & (n − 1) is 0 exactly when n had no other 1.",
     "ko": "2의 거듭제곱은 1 비트가 딱 하나입니다. n − 1은 가장 낮은 1을 0으로, 그 아래 비트를 1로 바꾸므로, "
           "n & (n − 1)이 0이면 n에 다른 1이 없었다는 뜻입니다."},
    views=[
        {"id": "n", "type": "array", "title": {"en": "n (tag: place value)", "ko": "n (태그: 자릿값)"}},
        {"id": "less", "type": "array", "title": "n − 1"},
        {"id": "both", "type": "array", "title": "n & (n − 1)"},
    ],
)


def solve(n, run):
    """Solution.isPowerOfTwo with a frame per step. Returns the answer as the Driver prints it."""
    if n <= 0:
        run.frame({"en": f"n = {n} is not positive, so it is not a power of two: answer false.",
                   "ko": f"n = {josa(n, '은는')} 양수가 아니라 2의 거듭제곱이 아닙니다. 답은 false입니다."},
                  answer="false")
        return "false"
    width = n.bit_length()
    places = [1 << (width - 1 - p) for p in range(width)]

    def bits(v):
        return [int(c) for c in format(v, f"0{width}b")]

    nb, lb, bb = bits(n), bits(n - 1), bits(n & (n - 1))
    tags = [[p, str(places[p])] for p in range(width)]

    def view(name, value, values, marks):
        return {"values": values, "spans": {"value": span(0, width - 1, f"{name} = {value}")}, "marks": marks}

    low = width - 1 - ((n & -n).bit_length() - 1)  # where n's lowest 1 is drawn
    flipped = list(range(low, width))
    run.frame({"en": f"n = {n} is positive, so look at its bits: {''.join(map(str, nb))}.",
               "ko": f"n = {josa(n, '은는')} 양수이므로 비트를 봅니다. {''.join(map(str, nb))}입니다."},
              n={**view("n", n, nb, {}), "tags": tags})
    if low < width - 1:
        how = {"en": f"the lowest 1 (place {places[low]}) turns into 0 and the 0s below it into 1s",
               "ko": f"가장 낮은 1(자릿값 {places[low]})이 0이 되고 그 아래 0들이 1이 됩니다"}
    else:
        how = {"en": "the lowest 1 is in place 1 and turns into 0", "ko": "가장 낮은 1이 자릿값 1 자리에 있어 0이 됩니다"}
    kept = {"en": " The bits above it stay.", "ko": " 그 위 비트는 그대로입니다."} if low else {"en": "", "ko": ""}
    run.frame({"en": f"n − 1 = {n - 1}: {how['en']}.{kept['en']}",
               "ko": f"n − 1 = {n - 1}: {how['ko']}.{kept['ko']}"},
              n={**view("n", n, nb, {"lit": flipped}), "tags": tags},
              less=view("n − 1", n - 1, lb, {"good": flipped}),
              moves=[move(at("n", p), at("less", p), value=str(lb[p])) for p in range(width)])
    ones = [p for p in range(width) if bb[p]]
    if ones:
        where = ", ".join(str(places[p]) for p in ones)
        en = f"n & (n − 1) = {n & (n - 1)}: place {where} is 1 in both, so it survives the &."
        ko = f"n & (n − 1) = {n & (n - 1)}: 자릿값 {where} 자리는 둘 다 1이라 &를 해도 남습니다."
    else:
        en = f"n & (n − 1) = 0: no place is 1 in both, since n's only 1 became 0 in n − 1."
        ko = f"n & (n − 1) = 0: 둘 다 1인 자리가 없습니다. n의 하나뿐인 1이 n − 1에서 0이 되었기 때문입니다."
    run.frame({"en": en, "ko": ko},
              n={**view("n", n, nb, {"lit": ones}), "tags": tags},
              less=view("n − 1", n - 1, lb, {"lit": ones}),
              both=view("n & (n − 1)", n & (n - 1), bb, {"good": ones}),
              moves=[move(at("less", p), at("both", p), value=f"{nb[p]}&{lb[p]}") for p in range(width)])
    if ones:
        answer = "false"
        en = (f"n & (n − 1) is not 0: n has a 1 besides its lowest one, so {n} is not a power of two. Answer false.")
        ko = f"n & (n − 1)이 0이 아니라 n에 가장 낮은 1 말고도 1이 있으므로 {josa(n, '은는')} 2의 거듭제곱이 아닙니다. 답은 false입니다."
        marks = ({"bad": [p for p in range(width) if nb[p]]}, {"bad": ones})
    else:
        answer = "true"
        k = width - 1
        en = f"n & (n − 1) is 0: n's one 1 bit was its only one, so {n} = 2^{k}. Answer true."
        ko = f"n & (n − 1)이 0이므로 n의 1 비트는 하나뿐이고, {n} = 2^{k}입니다. 답은 true입니다."
        marks = ({"path": [0]}, {"path": list(range(width))})
    run.frame({"en": en, "ko": ko},
              n={**view("n", n, nb, marks[0]), "tags": tags},
              less=view("n − 1", n - 1, lb, {}),
              both=view("n & (n − 1)", n & (n - 1), bb, marks[1]),
              answer=answer)
    return answer


for number, sample in enumerate(sample_cases(SLUG), start=1):
    n = int(sample["input"].strip())
    run = sample_run(wt, number, sample, input=f"n = {n}")
    solve(n, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
