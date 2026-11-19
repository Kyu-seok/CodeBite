#!/usr/bin/env python3.12
"""compare-loadout-bits's Walkthrough: the reference solution (scripts/replay-solutions/compare-loadout-bits.py),
diff = leftFlags ^ rightFlags, then diff &= diff - 1 until it is 0, recording a frame for the XOR and one per 1 bit
cleared on each sample Test Case. The three values are arrays of bits tagged with place values, drawn with the
bits the run needs (at least 4, as the Examples write them); each cleared bit of diff moves into the count.

    CODEBITE_DB=<database> scripts/walkthroughs/compare-loadout-bits.py

writes common/src/main/resources/walkthroughs/compare-loadout-bits.json.
"""
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import josa, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move, span  # noqa: E402

SLUG = "compare-loadout-bits"

wt = Walkthrough(
    {"en": "Compare Loadout Bits", "ko": "로드아웃 비트 비교"},
    {"en": "leftFlags ^ rightFlags has a 1 exactly where the two differ; count its 1 bits by clearing the lowest "
           "one (diff &= diff − 1) until it is 0.",
     "ko": "leftFlags ^ rightFlags는 두 값이 다른 자리만 1입니다. 가장 낮은 1을 끄는 diff &= diff − 1을 "
           "0이 될 때까지 반복하며 1 비트를 셉니다."},
    views=[
        {"id": "left", "type": "array", "title": {"en": "leftFlags (tag: place value)", "ko": "leftFlags (태그: 자릿값)"}},
        {"id": "right", "type": "array", "title": {"en": "rightFlags", "ko": "rightFlags (오른쪽 팀원)"}},
        {"id": "diff", "type": "array", "title": {"en": "diff = leftFlags ^ rightFlags", "ko": "diff (엇갈린 비트) = leftFlags ^ rightFlags"}},
        {"id": "count", "type": "output", "title": {"en": "count", "ko": "count (다른 자리 수)"}},
    ],
)


def solve(left, right, run):
    """Solution.countFlagMismatches with a frame for the XOR and one per bit cleared. Returns the count."""
    width = max(4, left.bit_length(), right.bit_length())
    places = [1 << (width - 1 - p) for p in range(width)]

    def bits(v):
        return [int(c) for c in format(v, f"0{width}b")]

    lb, rb = bits(left), bits(right)
    differ = [p for p in range(width) if lb[p] != rb[p]]
    diff = None
    count = 0

    def frame(caption, lit=(), good=(), path=False, moves=None, counted=False, **answer):
        views = {
            "left": {"values": lb, "tags": [[p, str(places[p])] for p in range(width)],
                     "spans": {"value": span(0, width - 1, f"leftFlags = {left}")},
                     "marks": {"lit": list(lit)}},
            "right": {"values": rb, "spans": {"value": span(0, width - 1, f"rightFlags = {right}")},
                      "marks": {"lit": list(lit)}},
            "count": {"values": [count], "marks": {"path": [0]} if path else {"good": [0]} if counted else {}},
        }
        if diff is not None:
            views["diff"] = {"values": bits(diff), "spans": {"value": span(0, width - 1, f"diff = {diff}")},
                             "marks": {"good": list(good), "path": differ if path else []}}
        run.frame(caption, moves=moves, **views, **answer)

    frame({"en": f"leftFlags = {left} and rightFlags = {right}, drawn in {width} bits. count starts at 0.",
           "ko": f"leftFlags = {left}, rightFlags = {josa(right, '을를')} {width}비트로 그렸습니다. count는 0에서 시작합니다."})
    diff = left ^ right
    if differ:
        where = ", ".join(str(places[p]) for p in differ)
        en = f"diff = {left} ^ {right} = {diff}: a 1 in each place where the two differ ({where})."
        ko = f"diff = {left} ^ {right} = {josa(diff, '이가')} 됩니다. 두 값이 다른 자리({where})마다 1입니다."
    else:
        en = f"diff = {left} ^ {right} = 0: the two agree in every place."
        ko = f"diff = {left} ^ {right} = 0입니다. 두 값이 모든 자리에서 같습니다."
    frame({"en": en, "ko": ko}, lit=differ, good=differ,
          moves=[move(at("right", p), at("diff", p), value=f"{lb[p]}^{rb[p]}") for p in range(width)])
    while diff:
        p = width - 1 - ((diff & -diff).bit_length() - 1)
        diff &= diff - 1
        count += 1
        if p < width - 1:
            how = {"en": f"diff − 1 turns the lowest 1 (place {places[p]}) into 0 and the 0s below it into 1s, so "
                         "diff &= diff − 1 clears only that place",
                   "ko": f"diff − 1은 가장 낮은 1(자릿값 {places[p]})을 0으로, 그 아래 0들을 1로 바꾸므로 diff &= diff − 1은 "
                         "그 자리만 끕니다"}
        else:
            how = {"en": "The lowest 1 is in place 1, which diff − 1 turns into 0, so diff &= diff − 1 clears it",
                   "ko": "가장 낮은 1이 자릿값 1 자리에 있고 diff − 1이 그 비트를 0으로 바꾸므로 diff &= diff − 1이 그 자리를 끕니다"}
        frame({"en": f"{how['en']}: count = {count}, diff = {diff}.",
               "ko": f"{how['ko']}. count = {count}, diff = {josa(diff, '이가')} 됩니다."},
              good=[p], counted=True,
              moves=[move(at("diff", p), at("count", 0), value="+1", mark="good"),
                     move(None, at("diff", p), value="0")])
    if count:
        why = {"en": f"diff is 0: every place the two differ was counted once", "ko": "diff가 0이 되었으니 다른 자리를 한 번씩 모두 셌습니다"}
    else:
        why = {"en": "diff is 0 from the start: no place differs", "ko": "diff가 처음부터 0이라 다른 자리가 없습니다"}
    frame({"en": f"{why['en']}. Answer {count}.", "ko": f"{why['ko']}. 답은 {count}입니다."},
          path=True, answer=str(count))
    return count


for number, sample in enumerate(sample_cases(SLUG), start=1):
    left, right = (int(line) for line in sample["input"].split("\n"))
    run = sample_run(wt, number, sample, input=f"leftFlags = {left}, rightFlags = {right}")
    solve(left, right, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
