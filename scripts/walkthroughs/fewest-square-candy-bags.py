#!/usr/bin/env python3.12
"""fewest-square-candy-bags' Walkthrough: the reference solution (scripts/replay-solutions/fewest-square-candy-bags.py),
a table of the fewest square bags for every amount from 0 to candies, filled left to right, recording one frame per
amount on each sample Test Case.

The squares up to candies are their own array. Each amount reads the cells one square back (tagged with that
square, the loop stopping at the first square bigger than the amount), and the best of them plus one bag moves
into its cell. Every other cell starts at candies, as the solution's does: no amount up to candies needs more bags
than that (all 1s). The tracer keeps which square won at each amount, so the last frame marks the chain of amounts
the answer's bags step through.

    CODEBITE_DB=<database> scripts/walkthroughs/fewest-square-candy-bags.py

writes common/src/main/resources/walkthroughs/fewest-square-candy-bags.json.
"""
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import josa, plural, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move  # noqa: E402

SLUG = "fewest-square-candy-bags"

wt = Walkthrough(
    {"en": "Fewest Square Candy Bags", "ko": "최소 제곱수 사탕 봉지"},
    {"en": "Fill a table of the fewest bags for every amount from 0 up to candies: an amount's last bag is some "
           "square, so it is one more than the best of the amounts one square back.",
     "ko": "0부터 candies까지 모든 개수에 대해 최소 봉지 수 표를 채웁니다. 마지막 봉지는 어떤 제곱수이므로, "
           "제곱수만큼 앞선 개수들 중 최솟값에 1을 더한 값이 됩니다."},
    views=[
        {"id": "squares", "type": "array", "title": {"en": "square bag sizes", "ko": "squares (제곱수 봉지 크기)"}},
        {"id": "fewest", "type": "array", "title": {"en": "fewest bags for each amount",
                                                    "ko": "사탕 개수별 최소 봉지 수"}},
    ],
)


def bag(size):
    return {"en": f"bag {size}", "ko": f"봉지 {size}"}


def solve(candies, run):
    """Solution.fewestBags with a frame per amount."""
    squares = [i * i for i in range(1, int(candies ** 0.5) + 1)]
    fewest = [0] + [candies] * candies
    won = {}  # amount -> the square whose cell it was filled from

    def frame(caption, amount=None, cells=None, square_marks=None, tags=(), moves=None, unread=None, **answer):
        run.frame(caption,
                  squares={"values": squares, "marks": square_marks or {}},
                  fewest={"values": list(fewest), "pointers": {"amount": amount}, "marks": cells or {},
                          "tags": list(tags), "unread": [] if unread is None else unread},
                  moves=moves, **answer)

    frame({"en": f"The squares up to {candies} are {', '.join(map(str, squares))}. Amount 0 needs 0 bags; every "
                 f"other amount starts at {candies}, more than it can need (all 1s).",
           "ko": f"{candies} 이하의 제곱수는 {', '.join(map(str, squares))}입니다. 사탕 0개에는 봉지 0개, 나머지 "
                 f"개수는 {candies}에서 시작합니다. 1짜리로만 담아도 이보다 많이 들지 않습니다."},
          cells={"good": [0]}, unread=list(range(1, candies + 1)))
    for amount in range(1, candies + 1):
        tried = []
        for square in squares:
            if square > amount:
                break
            tried.append(square)
            fewest[amount] = min(fewest[amount], fewest[amount - square] + 1)
        size = won[amount] = min(tried, key=lambda s: fewest[amount - s])  # the first square with the fewest
        src, best = amount - size, fewest[amount]
        reads = [f"{amount - s} ({fewest[amount - s]} + 1)" for s in tried]
        reads_ko = [f"{amount - s}개({fewest[amount - s]} + 1)" for s in tried]
        froms_en = reads[0] if len(reads) == 1 else ", ".join(reads[:-1]) + " or " + reads[-1]
        froms_ko = reads_ko[0] if len(reads_ko) == 1 else ", ".join(reads_ko[:-1]) + " 또는 " + reads_ko[-1]
        frame({"en": f"Amount {amount} is one bag added to amount {froms_en}. The fewest is amount {src}'s "
                     f"{best - 1} {plural(best - 1, 'bag', 'bags')} plus a bag of {size}: {best}.",
               "ko": f"사탕 {amount}개는 사탕 {froms_ko}에 봉지 하나를 더한 것입니다. 가장 적은 것은 사탕 "
                     f"{src}개의 {best - 1}개에 크기 {size} 봉지를 더한 {best}개입니다."},
              amount=amount, cells={"lit": [amount - s for s in tried], "good": [amount]},
              square_marks={"lit": list(range(len(tried))), "dim": list(range(len(tried), len(squares)))},
              tags=[[amount - s, bag(s)] for s in tried], unread=list(range(amount + 1, candies + 1)),
              moves=[move(at("fewest", src), at("fewest", amount), value=f"{best - 1}+1")])
    chain, amount = [], candies
    while amount > 0:
        chain.append(amount)
        amount -= won[amount]
    chain.append(0)
    used = [won[a] for a in chain[:-1]]
    k = fewest[candies]
    frame({"en": f"Amount {candies} needs {k} {plural(k, 'bag', 'bags')}. Following each cell back to the one it "
                 f"came from: {' + '.join(map(str, used))} = {candies}.",
           "ko": f"사탕 {candies}개에는 봉지가 {k}개 필요합니다. 각 칸이 온 칸을 거슬러 가면 "
                 f"{' + '.join(map(str, used))} = {josa(candies, '이가')} 됩니다."},
          cells={"path": chain}, square_marks={"path": sorted({squares.index(s) for s in used})},
          tags=[[a - won[a], bag(won[a])] for a in chain[:-1]], answer=str(k))


for number, sample in enumerate(sample_cases(SLUG), start=1):
    candies = int(sample["input"])
    run = sample_run(wt, number, sample, input=f"candies = {candies}")
    solve(candies, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
