#!/usr/bin/env python3.12
"""nth-unlockable-level's Walkthrough: the reference solution (scripts/replay-solutions/nth-unlockable-level.py),
the unlockable levels built in order by three pointers, recording two frames per level on each sample Test Case.

The levels are an array padded with "" to n cells, with the pointers i2, i3 and i5 under the level each multiplies
next. The three products are a three-cell array tagged ×2, ×3 and ×5. One frame works out the products whose
pointer moved (each moving in from its pointer's level); the next moves the smallest into the next level's cell
and steps every pointer whose product equals it, so a level two pointers make (6 = 3×2 = 2×3) is added once.

    CODEBITE_DB=<database> scripts/walkthroughs/nth-unlockable-level.py

writes common/src/main/resources/walkthroughs/nth-unlockable-level.json.
"""
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import josa, ordinal, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move  # noqa: E402

SLUG = "nth-unlockable-level"
FACTORS = (2, 3, 5)
NAMES = ("i2", "i3", "i5")

wt = Walkthrough(
    {"en": "Nth Unlockable Level", "ko": "N번째 해금 가능 레벨"},
    {"en": "Every unlockable level after 1 is an earlier one times 2, 3 or 5. Keep a pointer per factor at the "
           "smallest level not yet multiplied by it; the next level is the smallest of the three products.",
     "ko": "1 다음의 해금 가능 레벨은 모두 앞선 레벨에 2, 3, 5 중 하나를 곱한 수입니다. 곱마다 아직 그 수를 곱하지 "
           "않은 가장 작은 레벨을 가리키는 포인터를 두면, 다음 레벨은 세 곱 중 가장 작은 값입니다."},
    views=[
        {"id": "levels", "type": "array", "title": {"en": "unlockable levels, in order",
                                                    "ko": "levels (해금 가능 레벨, 작은 순)"}},
        {"id": "products", "type": "array", "title": {"en": "next product per factor",
                                                      "ko": "곱마다 다음 후보"}},
    ],
)
PRODUCT_TAGS = [[k, f"×{f}"] for k, f in enumerate(FACTORS)]


def solve(n, run):
    """Solution.nthUnlockableLevel with two frames per level."""
    levels = [1]
    ptr = [0, 0, 0]
    products = ["", "", ""]

    def frame(caption, level_marks=None, product_marks=None, moves=None, **answer):
        run.frame(caption,
                  levels={"values": levels + [""] * (n - len(levels)),
                          "pointers": {NAMES[k]: ptr[k] for k in range(3)} if n > 1 else {},
                          "marks": level_marks or {}, "unread": list(range(len(levels), n))},
                  products={"values": list(products), "tags": PRODUCT_TAGS, "marks": product_marks or {}},
                  moves=moves, **answer)

    if n == 1:
        frame({"en": "The first unlockable level is 1, and n = 1 asks for the first, so nothing needs building.",
               "ko": "첫 번째 해금 가능 레벨은 1이고 n = 1은 첫 번째를 묻으므로 더 만들 것이 없습니다."},
              level_marks={"good": [0]})
        frame({"en": "Answer: 1.", "ko": "답은 1입니다."}, level_marks={"path": [0]}, answer="1")
        return
    frame({"en": f"Level 1 comes first, and all three pointers start on it since nothing has been multiplied yet; "
                 f"{n} levels are needed.",
           "ko": f"레벨 1이 가장 먼저이고, 아직 아무것도 곱하지 않았으니 세 포인터 모두 1을 가리킵니다. 레벨이 "
                 f"{n}개 필요합니다."},
          level_marks={"good": [0]})
    stale = [0, 1, 2]  # products whose pointer moved since they were worked out
    while len(levels) < n:
        for k in stale:
            products[k] = levels[ptr[k]] * FACTORS[k]
        listed = ", ".join(f"{levels[ptr[k]]}×{FACTORS[k]} = {products[k]}" for k in stale)
        following = min(products)
        smallest = [k for k in range(3) if products[k] == following]
        frame({"en": f"New products: {listed}. The smallest of the three is {following}.",
               "ko": f"새 후보: {listed}. 세 후보 중 가장 작은 값은 {following}입니다."},
              level_marks={"lit": sorted({ptr[k] for k in stale})},
              product_marks={"good": stale, "lit": [k for k in smallest if k not in stale]},
              moves=[move(at("levels", ptr[k]), at("products", k), value=f"{levels[ptr[k]]}×{FACTORS[k]}")
                     for k in stale])
        levels.append(following)
        for k in smallest:
            ptr[k] += 1
        stale = smallest
        moved = " and ".join(NAMES[k] for k in smallest)
        moved_ko = ", ".join(NAMES[k] for k in smallest)
        two = len(smallest) > 1
        frame({"en": f"{following} is the {ordinal(len(levels))} level. {moved} made it, so "
                     f"{'they step' if two else 'it steps'} to the next level.",
               "ko": f"{josa(following, '은는')} {len(levels)}번째 레벨입니다. {moved_ko}에서 만들었으므로 "
                     f"{'모두' if two else ''} 다음 레벨로 넘어갑니다.".replace("  ", " ")},
              level_marks={"good": [len(levels) - 1]}, product_marks={"lit": smallest},
              moves=[move(at("products", smallest[0]), at("levels", len(levels) - 1))])
    frame({"en": f"{n} levels are built. The {ordinal(n)} unlockable level is {levels[n - 1]}.",
           "ko": f"레벨 {n}개를 다 만들었습니다. {n}번째 해금 가능 레벨은 {levels[n - 1]}입니다."},
          level_marks={"path": [n - 1]}, answer=str(levels[n - 1]))


for number, sample in enumerate(sample_cases(SLUG), start=1):
    n = int(sample["input"])
    run = sample_run(wt, number, sample, input=f"n = {n}")
    solve(n, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
