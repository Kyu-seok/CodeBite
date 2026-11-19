#!/usr/bin/env python3.12
"""voucher-price-combos's Walkthrough: the reference solution (scripts/replay-solutions/voucher-price-combos.py),
backtracking over the sorted prices: build(start, remaining, basket) keeps a basket whose remaining is 0, and
otherwise adds each price from index `start` on that still fits, calling build(i, remaining - price) with the same
`start` so a price can repeat but never comes before a cheaper one already passed. The calls are drawn as a recursion
tree grown one call per frame (views.md, recursion): one node per call holding its basket, tagged with what is left,
the edge into it labelled with the price added; the calls still open are shaded and each full basket moves into the
answer. On the prices, a call lights the ones it may add, fades the ones before `start` and marks the ones too dear.

    CODEBITE_DB=<database> scripts/walkthroughs/voucher-price-combos.py

writes common/src/main/resources/walkthroughs/voucher-price-combos.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import driver_list, josa, plural, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Tree, Walkthrough, at, move  # noqa: E402

SLUG = "voucher-price-combos"

wt = Walkthrough(
    {"en": "Voucher Price Combos", "ko": "쿠폰 가격 조합"},
    {"en": "Sort the prices and grow a basket one price at a time, each call adding only prices from the last one it "
           "added on, so a basket is built in one order only; a call stops at the first price dearer than what is left, "
           "and a basket with nothing left is an answer.",
     "ko": "가격을 정렬하고 장바구니에 가격을 하나씩 담습니다. 호출마다 마지막으로 담은 가격부터만 담으므로 장바구니는 한 가지 "
           "순서로만 만들어집니다. 남은 금액보다 비싼 가격에서 멈추고, 남은 금액이 0인 장바구니가 답입니다."},
    views=[
        {"id": "prices", "type": "array", "title": {"en": "prices, sorted", "ko": "prices (정렬한 가격)"}},
        {"id": "calls", "type": "tree",
         "title": {"en": "calls (basket; tag: left to spend)", "ko": "호출 (장바구니, 태그: 남은 금액)"}},
        {"id": "result", "type": "output", "title": {"en": "baskets", "ko": "장바구니"},
         "empty": {"en": "none yet", "ko": "아직 없음"}},
    ],
)


def listed(values):
    return ", ".join(map(str, values))


def solve(prices, voucher, run):
    """Solution.listVoucherSums with a frame per call. Returns the answer as the Driver prints it."""
    prices = sorted(prices)
    tree, baskets, open_calls, tags = Tree(), [], [], []
    marks_by_node = {"bad": [], "good": []}

    def frame(caption, lit=None, start=None, remaining=None, moves=None, done=False, **answer):
        if done:
            node_marks = {"path": list(marks_by_node["good"]), "dim": list(marks_by_node["bad"])}
        else:
            node_marks = {"bad": list(marks_by_node["bad"]), "good": list(marks_by_node["good"]), "lit": [lit]}
        price_marks = {}
        if not done and remaining:  # a full basket tries no price
            price_marks = {"dim": list(range(start)),
                           "lit": [i for i in range(start, len(prices)) if prices[i] <= remaining],
                           "bad": [i for i in range(start, len(prices)) if prices[i] > remaining]}
        run.frame(caption,
                  prices={"values": prices, "marks": price_marks,
                          "pointers": {} if done else {"start": start}},
                  calls={**tree.state(), "nodeMarks": node_marks, "tags": [list(t) for t in tags],
                         "shade": [] if done else list(open_calls)},
                  result={"values": [driver_list(b) for b in baskets],
                          "marks": {"path": list(range(len(baskets)))} if done else
                          {"good": [len(baskets) - 1]} if any(m.get("to", {}).get("view") == "result" for m in moves or [])
                          else {}},
                  moves=moves, **answer)

    def build(start, remaining, basket, parent, taken):
        node = tree.add(driver_list(basket), parent=parent, label=None if taken is None else f"+{prices[taken]}")
        tags.append([node, {"en": f"{remaining} left", "ko": f"{remaining} 남음"}])
        open_calls.append(node)
        fits = [prices[i] for i in range(start, len(prices)) if prices[i] <= remaining]
        moves = [move(dst=at("calls", node))] if taken is None else [move(at("prices", taken), at("calls", node))]
        if taken is None:
            head = {"en": f"The first call starts with an empty basket and {voucher} to spend",
                    "ko": f"첫 호출은 빈 장바구니와 쓸 금액 {voucher}에서 시작하고"}
        else:
            head = {"en": f"Add {prices[taken]}: the call for {driver_list(basket)} has {remaining} left",
                    "ko": f"{josa(prices[taken], '을를')} 담습니다. {driver_list(basket)} 호출에는 {josa(remaining, '이가')} "
                          f"남았고"}
        if remaining == 0:
            baskets.append(basket[:])
            marks_by_node["good"].append(node)
            moves.append(move(at("calls", node), at("result", len(baskets) - 1)))
            frame({"en": head["en"] + f", so {driver_list(basket)} adds up to exactly {voucher}: it goes into the answer.",
                   "ko": head["ko"] + f", 합이 정확히 {voucher}이므로 이 장바구니를 답에 넣습니다."},
                  node, start, remaining, moves)
        elif not fits:
            marks_by_node["bad"].append(node)
            frame({"en": head["en"] + f", and every price it may add is dearer than {remaining}: a dead end, it returns.",
                   "ko": head["ko"] + f", 담을 수 있는 가격이 모두 {remaining}보다 비싸 막다른 길이므로 돌아갑니다."},
                  node, start, remaining, moves)
        else:
            frame({"en": head["en"] + (f"; it will try {listed(fits)} in turn." if len(fits) > 1 else
                                       f"; only {fits[0]} still fits, so it tries that."),
                   "ko": head["ko"] + (f", {listed(fits[:-1])}, {josa(fits[-1], '을를')} 차례로 담아 봅니다." if len(fits) > 1
                                       else f", 아직 담을 수 있는 가격은 {fits[0]}뿐이니 그것을 담아 봅니다.")},
                  node, start, remaining, moves)
        if remaining == 0:
            open_calls.pop()
            return
        for i in range(start, len(prices)):
            if prices[i] > remaining:
                break
            basket.append(prices[i])
            build(i, remaining - prices[i], basket, node, i)
            basket.pop()
        open_calls.pop()

    build(0, voucher, [], None, None)
    printed = json.dumps(sorted(sorted(b) for b in baskets), separators=(",", ":"))
    n, calls = len(baskets), len(tree.nodes)
    if n:
        frame({"en": f"Every call has returned: {calls} calls, and {n} {plural(n, 'basket adds', 'baskets add')} up to "
                     f"exactly {voucher}.",
               "ko": f"모든 호출이 끝났습니다. 호출 {calls}번 가운데 합이 정확히 {voucher}인 장바구니는 {n}개입니다."},
              done=True, answer=printed)
    else:
        frame({"en": f"Every call has returned: {calls} calls, and no basket adds up to exactly {voucher}, so the answer "
                     f"is [].",
               "ko": f"모든 호출이 끝났습니다. 호출 {calls}번 가운데 합이 정확히 {voucher}인 장바구니가 없으므로 답은 빈 목록 "
                     f"[]입니다."},
              done=True, answer=printed)
    return printed


for number, sample in enumerate(sample_cases(SLUG), start=1):
    lines = sample["input"].split("\n")
    prices, voucher = json.loads(lines[0]), int(lines[1])
    run = sample_run(wt, number, sample, input=f"prices = {driver_list(prices)}, voucher = {voucher}")
    solve(prices, voucher, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
