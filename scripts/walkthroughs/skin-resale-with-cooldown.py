#!/usr/bin/env python3.12
"""skin-resale-with-cooldown's Walkthrough: the reference solution
(scripts/replay-solutions/skin-resale-with-cooldown.py), three running profits (holding a copy, sold today, resting
and free to buy) rewritten together each day, recording one frame per day on each sample Test Case.

The solution keeps only the three numbers; the Walkthrough draws the table they roll through, as a grid of one row
per state and one column per day after a `start` column, each day's price in the header cell above it. A day is one
frame because the solution assigns the three as one tuple: each new value moves in from the cell of the day before
it was built from, carrying the sum. The tracer keeps each choice, so the last frame walks back to the trades.

    CODEBITE_DB=<database> scripts/walkthroughs/skin-resale-with-cooldown.py

writes common/src/main/resources/walkthroughs/skin-resale-with-cooldown.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move  # noqa: E402

SLUG = "skin-resale-with-cooldown"
HOLD, SOLD, REST = 1, 2, 3   # grid rows
NAMES = {HOLD: "hold", SOLD: "sold", REST: "rest"}  # the solution's holding, sold, resting
INF = "−∞"
CORNER, START = "", "start"
HEADER = {"tone": "a"}


def price_cell(p):
    return f"${p}"


SAMPLES = sample_cases(SLUG)
wt = Walkthrough(
    {"en": "Skin Resale With Cooldown", "ko": "쿨다운이 있는 스킨 되팔기"},
    {"en": "Carry three best profits through the days: hold (a copy in hand), sold (sold today) and rest (free to "
           "buy). Hold keeps its copy or buys from rest; sold sells the copy held; rest comes from yesterday's rest or "
           "sale, so the day after a sale can't buy: the cooldown.",
     "ko": "날마다 세 가지 최대 이익을 이어 갑니다: hold(스킨을 들고 있음), sold(오늘 팖), rest(쉬는 중이라 살 수 있음). "
           "hold는 그대로 들거나 rest에서 사고, sold는 들고 있던 것을 팔며, rest는 어제의 rest나 sold에서 오므로 판 "
           "다음 날은 살 수 없습니다(쿨다운)."},
    views=[
        {"id": "table", "type": "grid",
         "title": {"en": "best profit by state (rows) after each day (columns, price on top)",
                   "ko": "상태별(행) 최대 이익, 날짜별(열, 위는 가격)"},
         "values": {**{name: HEADER for name in NAMES.values()}, **{price_cell(p): {"tone": "b", "glyph": str(p)}
                                                                     for p in sorted({p for s in SAMPLES for p in json.loads(s["input"])})},
                    START: HEADER, CORNER: {"glyph": "", "tone": "plain"}, " ": {"glyph": "", "tone": "empty"}}},
    ],
)


def fmt(v):
    return INF if v == float("-inf") else v


def solve(prices, run):
    """Solution.maxProfit with a frame per day, the three values' whole history drawn. Returns the answer as the Driver
    prints it. Day d's values are grid column d + 2; column 1 is the start."""
    n = len(prices)
    grid = [[CORNER, START] + [price_cell(p) for p in prices]]
    grid += [[NAMES[r]] + [" "] * (n + 1) for r in (HOLD, SOLD, REST)]
    holding, sold, resting = float("-inf"), 0, 0
    grid[HOLD][1], grid[SOLD][1], grid[REST][1] = INF, 0, 0
    came = {}  # (row, col) -> (row, col) the value was taken from

    def frame(caption, marks=None, moves=None, **answer):
        run.frame(caption, table={"cells": grid, "marks": marks or {}}, moves=moves, **answer)

    frame({"en": "Before day 0: no copy can be held yet (hold −∞), and nothing is sold, so sold and rest are 0.",
           "ko": "0일 전: 아직 스킨을 들 수 없으므로 hold는 −∞, 판 것도 없으므로 sold와 rest는 0입니다."},
          marks={"good": [[HOLD, 1], [SOLD, 1], [REST, 1]]})
    for d, price in enumerate(prices):
        col, prev = d + 2, d + 1
        buy = resting - price
        new_hold = max(holding, buy)
        new_sold = holding + price
        new_rest = max(resting, sold)
        hold_src = HOLD if holding >= buy else REST
        rest_src = REST if resting >= sold else SOLD
        came[(HOLD, col)] = (hold_src, prev)
        came[(SOLD, col)] = (HOLD, prev)
        came[(REST, col)] = (rest_src, prev)
        grid[HOLD][col], grid[SOLD][col], grid[REST][col] = fmt(new_hold), fmt(new_sold), fmt(new_rest)
        hold_en = "keep holding" if hold_src == HOLD else f"buy at {price}"
        hold_ko = "계속 들기" if hold_src == HOLD else f"{price}에 사기"
        frame({"en": f"Day {d}, price {price}: hold = max({fmt(holding)}, {resting} − {price}) = {fmt(new_hold)} "
                     f"({hold_en}); sold = {fmt(holding)} + {price} = {fmt(new_sold)}; rest = max({resting}, {fmt(sold)}) "
                     f"= {new_rest}.",
               "ko": f"{d}일, 가격 {price}: hold = max({fmt(holding)}, {resting} − {price}) = {fmt(new_hold)}"
                     f"({hold_ko}), sold = {fmt(holding)} + {price} = {fmt(new_sold)}, rest = max({resting}, {fmt(sold)}) "
                     f"= {new_rest}입니다."},
              marks={"lit": [[0, col], [HOLD, prev], [SOLD, prev], [REST, prev]],
                     "good": [[HOLD, col], [SOLD, col], [REST, col]]},
              moves=[move(at("table", [hold_src, prev]), at("table", [HOLD, col]),
                          value=str(fmt(holding)) if hold_src == HOLD else f"{resting}−{price}"),
                     move(at("table", [HOLD, prev]), at("table", [SOLD, col]), value=f"{fmt(holding)}+{price}"),
                     move(at("table", [rest_src, prev]), at("table", [REST, col]),
                          value=str(resting if rest_src == REST else fmt(sold)))])
        holding, sold, resting = new_hold, new_sold, new_rest
    answer = max(sold, resting)
    end = (SOLD if sold > resting else REST, n + 1)
    # walk back along the choices: a hold taken from rest is a buy, a sale taken from hold is a sell
    path, trades, here = [list(end)], [], end
    while here[1] > 1:
        src = came[here]
        if here[0] == HOLD and src[0] == REST:
            trades.append(("buy", here[1] - 2))
        if here[0] == SOLD:
            trades.append(("sell", here[1] - 2))
        here = src
        path.append(list(here))
    trades.reverse()
    if trades:
        steps_en = ", ".join(f"{kind} on day {d} at {prices[d]}" for kind, d in trades)
        steps_ko = ", ".join(f"{d}일 {prices[d]}{'에 사기' if kind == 'buy' else '에 팔기'}" for kind, d in trades)
        caption = {"en": f"The answer is the best last-day profit, max(sold {sold}, rest {resting}) = {answer}. "
                         f"Walking back: {steps_en}.",
                   "ko": f"마지막 날 최대 이익은 max(sold {sold}, rest {resting}) = {answer}입니다. 거슬러 가면 "
                         f"{steps_ko}이고, 답은 {answer}입니다."}
    else:
        caption = {"en": f"The best last-day profit is max(sold {sold}, rest {resting}) = {answer}: no trade makes "
                         "money, so never buy. Answer: 0.",
                   "ko": f"마지막 날 최대 이익은 max(sold {sold}, rest {resting}) = {answer}이고, 이익이 나는 거래가 "
                         "없으니 사지 않습니다. 답은 0입니다."}
    frame(caption, marks={"path": path}, answer=str(answer))


for number, sample in enumerate(SAMPLES, start=1):
    prices = json.loads(sample["input"])
    run = sample_run(wt, number, sample, input=f"prices = {sample['input']}")
    solve(prices, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
