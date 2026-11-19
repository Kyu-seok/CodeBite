#!/usr/bin/env python3.12
"""count-coupon-ways' Walkthrough: the reference solution (scripts/replay-solutions/count-coupon-ways.py), the count of
combinations per total, updated once per coupon value, recording one frame per total on each sample Test Case.

The solution keeps one array (`ways`), updated in place coupon by coupon; the Walkthrough draws the table it rolls
through, a grid of one row per coupon value under a `∅` row (no coupons yet) and one column per total 0..amount,
headed by the totals. A total below the coupon carries its count down unchanged (one frame per row for all of them);
a total the coupon fits adds the count from the row above (not using it) and the count `coupon` to the left in its
own row (using it once more), each moved in.

    CODEBITE_DB=<database> scripts/walkthroughs/count-coupon-ways.py

writes common/src/main/resources/walkthroughs/count-coupon-ways.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import plural, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move  # noqa: E402

SLUG = "count-coupon-ways"
CORNER, NONE, UNSET = "", "∅", " "
SAMPLES = sample_cases(SLUG)


def parse(sample):
    amount_line, coins_line = sample["input"].split("\n")
    return int(amount_line), json.loads(coins_line)


def head(t):
    return f"a{t}"  # a header cell: drawn as the total, kept apart from the counts


AMOUNTS = range(max(parse(s)[0] for s in SAMPLES) + 1)
COINS = sorted({c for s in SAMPLES for c in parse(s)[1]})
wt = Walkthrough(
    {"en": "Count Coupon Ways", "ko": "쿠폰 조합 세기"},
    {"en": "Add the coupon values one at a time. With a new value, a total is reached by the combinations that don't "
           "use it (the row above) plus those that use it at least once (the same row, that value to the left), so "
           "each combination is counted once, whatever its order.",
     "ko": "쿠폰 금액을 하나씩 추가합니다. 새 금액이 생기면, 어떤 합계를 만드는 조합은 그 금액을 쓰지 않는 조합(위 행)과 "
           "한 번 이상 쓰는 조합(같은 행, 그 금액만큼 왼쪽)의 합이므로, 순서와 상관없이 조합마다 한 번씩만 셉니다."},
    views=[
        {"id": "table", "type": "grid",
         "title": {"en": "combinations for each total (columns) with the coupons so far (rows)",
                   "ko": "지금까지의 쿠폰(행)으로 각 합계(열)를 만드는 조합 수"},
         "values": {**{head(t): {"tone": "b", "glyph": str(t)} for t in AMOUNTS},
                    **{f"+{c}": {"tone": "a"} for c in COINS}, NONE: {"tone": "a"},
                    CORNER: {"glyph": "", "tone": "plain"}, UNSET: {"glyph": "", "tone": "empty"}}},
    ],
)


def solve(amount, coins, run):
    """Solution.countCouponCombos with a frame per total. Returns the answer as the Driver prints it.
    Total t after coupon k is grid cell (k + 2, t + 1); row 1 is no coupons."""
    grid = [[CORNER] + [head(t) for t in range(amount + 1)], [NONE, 1] + [0] * amount]
    grid += [[f"+{c}"] + [UNSET] * (amount + 1) for c in coins]
    ways = [1] + [0] * amount

    def frame(caption, marks=None, moves=None, **answer):
        run.frame(caption, table={"cells": grid, "marks": marks or {}}, moves=moves, **answer)

    frame({"en": f"Spend {amount} with coupons {coins}. With no coupons, only a total of 0 can be made, one way (use "
                 "none); every other total has 0.",
           "ko": f"합계 {amount} 만들기, 쿠폰 금액 {coins}. 쿠폰이 없으면 합계 0만 한 가지(아무것도 안 쓰기)로 만들 수 "
                 "있고, 다른 합계는 0입니다."},
          marks={"good": [[1, t + 1] for t in range(amount + 1)]})
    for k, coin in enumerate(coins):
        row, above = k + 2, k + 1
        low = list(range(min(coin, amount + 1)))
        for t in low:
            grid[row][t + 1] = ways[t]
        if low:
            if len(low) == amount + 1:
                en = f"Coupon {coin} is bigger than every total up to {amount}, so it can't be used: each count carries " \
                     "down unchanged."
                ko = f"{amount}까지의 모든 합계가 쿠폰 금액 {coin}보다 작아 쓸 수 없으므로 모든 값이 " \
                                  "그대로 내려옵니다."
            else:
                en = f"Coupon {coin} doesn't fit totals below {coin}, so their counts carry down unchanged."
                ko = f"쿠폰 금액 {coin}보다 작은 합계에는 쓸 수 없으므로 그 값이 그대로 내려옵니다."
            frame({"en": en, "ko": ko},
                  marks={"lit": [[row, 0]] + [[above, t + 1] for t in low],
                         "good": [[row, t + 1] for t in low]},
                  moves=[move(at("table", [above, t + 1]), at("table", [row, t + 1])) for t in low])
        for t in range(coin, amount + 1):
            skip, use = ways[t], ways[t - coin]
            ways[t] += ways[t - coin]
            grid[row][t + 1] = ways[t]
            frame({"en": f"Total {t}: {skip} {plural(skip, 'way', 'ways')} without coupon {coin} (above) + {use} "
                         f"using it once more on total {t - coin} (left) = {ways[t]}.",
                   "ko": f"합계 {t}: 쿠폰 금액 {coin} 없이(위) {skip}가지 + 합계 {t - coin}에 그 쿠폰을 하나 더 "
                         f"쓰는(왼쪽) {use}가지 = {ways[t]}가지입니다."},
                  marks={"lit": [[row, 0], [0, t + 1], [above, t + 1], [row, t - coin + 1]], "good": [[row, t + 1]]},
                  moves=[move(at("table", [above, t + 1]), at("table", [row, t + 1]), value=str(skip)),
                         move(at("table", [row, t - coin + 1]), at("table", [row, t + 1]), value=f"+{use}")])
    answer = ways[amount]
    last = len(coins) + 1
    frame({"en": f"With every coupon value, total {amount} has {answer} {plural(answer, 'combination', 'combinations')}. "
                 f"Answer: {answer}.",
           "ko": f"모든 쿠폰 금액을 쓸 때 합계 {amount} 칸의 조합 수는 {answer}가지입니다. 답은 {answer}입니다."},
          marks={"path": [[0, amount + 1], [last, amount + 1]]}, answer=str(answer))


for number, sample in enumerate(SAMPLES, start=1):
    amount, coins = parse(sample)
    coins_line = sample["input"].split("\n")[1]
    run = sample_run(wt, number, sample, input=f"amount = {amount}, coupons = {coins_line}")
    solve(amount, coins, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
