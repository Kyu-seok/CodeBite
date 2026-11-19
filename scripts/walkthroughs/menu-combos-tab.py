#!/usr/bin/env python3.12
"""menu-combos-tab's Walkthrough: the reference solution (scripts/replay-solutions/menu-combos-tab.py), backtracking
over the sorted prices: pick(start, remaining) keeps the combo chosen when remaining is 0, and otherwise adds each
pastry from index `start` on, stopping at the first one dearer than remaining and skipping a price equal to the one just
tried at the same depth, then calls pick(i + 1, remaining - price) so each pastry is used at most once. The calls are
drawn as a recursion tree grown one call per frame (views.md, recursion): one node per call holding its combo, tagged
with what is left of the tab, the edge into it labelled with the price added; the calls still open are shaded and each
full combo moves into the answer. On the prices, a call lights the ones it may add, fades the ones before `start` and
marks the ones too dear; a skip gets a frame of its own, the skipped pastry marked, as it keeps the combos distinct.

Example 1 makes 17 calls, a little past the recursion tree's 15, drawn as a tree all the same so it reads like
voucher-price-combos and snack-combo-picks, its neighbours.

    CODEBITE_DB=<database> scripts/walkthroughs/menu-combos-tab.py

writes common/src/main/resources/walkthroughs/menu-combos-tab.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import driver_list, josa, plural, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Tree, Walkthrough, at, move  # noqa: E402

SLUG = "menu-combos-tab"

wt = Walkthrough(
    {"en": "Menu Combos For The Tab", "ko": "계산서에 딱 맞는 메뉴 조합"},
    {"en": "Sort the prices and grow a combo one pastry at a time, each call adding only pastries after the last one "
           "taken. It stops at the first price dearer than what is left of the tab, and skips a price equal to the one "
           "it just tried, which would repeat a combo.",
     "ko": "가격을 정렬하고 조합에 페이스트리를 하나씩 담습니다. 호출마다 마지막으로 담은 것 뒤의 페이스트리만 담습니다. 남은 "
           "금액보다 비싼 가격에서 멈추고, 방금 시도한 가격과 같은 가격은 같은 조합을 되풀이하므로 건너뜁니다."},
    views=[
        {"id": "prices", "type": "array", "title": {"en": "pastries, sorted", "ko": "pastries (정렬한 가격)"}},
        {"id": "calls", "type": "tree",
         "title": {"en": "calls (combo; tag: left of the tab)", "ko": "호출 (조합, 태그: 남은 금액)"}},
        {"id": "result", "type": "output", "title": {"en": "combos", "ko": "조합"},
         "empty": {"en": "none yet", "ko": "아직 없음"}},
    ],
)


def listed(values):
    return ", ".join(map(str, values))


def solve(pastries, tab, run):
    """Solution.listTabCombos with a frame per call and per run of skips. Returns the answer as the Driver prints it."""
    prices = sorted(pastries)
    tree, combos, open_calls, tags = Tree(), [], [], []
    chosen = []
    found, dead = [], []

    def candidates(start, remaining):
        """The indexes pick(start, remaining) will take: fitting, and not a repeat of the price before it."""
        out = []
        for i in range(start, len(prices)):
            if prices[i] > remaining:
                break
            if i > start and prices[i] == prices[i - 1]:
                continue
            out.append(i)
        return out

    def frame(caption, lit=None, start=None, remaining=None, skipped=(), moves=None, done=False, **answer):
        if done:
            node_marks = {"path": list(found), "dim": list(dead)}
        else:
            node_marks = {"bad": list(dead), "good": list(found), "lit": [lit]}
        price_marks = {}
        if not done and remaining:  # a full combo tries no price
            price_marks = {"dim": list(range(start)), "lit": candidates(start, remaining),
                           "bad": [i for i in range(start, len(prices)) if prices[i] > remaining] + list(skipped)}
        run.frame(caption,
                  prices={"values": prices, "marks": price_marks,
                          "pointers": {"start": start} if not done and start < len(prices) else {}},
                  calls={**tree.state(), "nodeMarks": node_marks, "tags": [list(t) for t in tags],
                         "shade": [] if done else list(open_calls)},
                  result={"values": [driver_list(c) for c in combos],
                          "marks": {"path": list(range(len(combos)))} if done else
                          {"good": [len(combos) - 1]} if any(m.get("to", {}).get("view") == "result" for m in moves or [])
                          else {}},
                  moves=moves, **answer)

    def pick(start, remaining, parent, taken):
        node = tree.add(driver_list(chosen), parent=parent, label=None if taken is None else f"+{prices[taken]}")
        tags.append([node, {"en": f"{remaining} left", "ko": f"{remaining} 남음"}])
        open_calls.append(node)
        tries = [prices[i] for i in candidates(start, remaining)]
        moves = [move(dst=at("calls", node))] if taken is None else [move(at("prices", taken), at("calls", node))]
        if taken is None:
            head = {"en": f"The first call starts with an empty combo and a tab of {tab}",
                    "ko": f"첫 호출은 빈 조합과 계산서 금액 {tab}에서 시작합니다"}
        else:
            head = {"en": f"Add {prices[taken]} (index {taken}): the call for {driver_list(chosen)} has {remaining} left",
                    "ko": f"{taken}번 칸의 {josa(prices[taken], '을를')} 담습니다. {driver_list(chosen)} 호출에는 "
                          f"{josa(remaining, '이가')} 남았습니다"}
        if remaining == 0:
            combos.append(chosen.copy())
            found.append(node)
            moves.append(move(at("calls", node), at("result", len(combos) - 1)))
            frame({"en": head["en"] + f", so {driver_list(chosen)} adds up to exactly {tab}: it goes into the answer.",
                   "ko": head["ko"] + f". 합이 정확히 {tab}이므로 이 조합을 답에 넣습니다."},
                  node, start, remaining, moves=moves)
            open_calls.pop()
            return
        if not tries:
            dead.append(node)
            frame({"en": head["en"] + (f", and every pastry after it is dearer than {remaining}" if start < len(prices)
                                       else ", and no pastry comes after it") + ": a dead end, it returns.",
                   "ko": head["ko"] + (f". 뒤의 페이스트리가 모두 {remaining}보다 비싸" if start < len(prices)
                                       else ". 뒤에 남은 페이스트리가 없어") + " 막다른 길이므로 돌아갑니다."},
                  node, start, remaining, moves=moves)
        else:
            frame({"en": head["en"] + (f"; it will try {listed(tries)} in turn." if len(tries) > 1 else
                                       f"; only {tries[0]} fits, so it tries that."),
                   "ko": head["ko"] + (f". {listed(tries[:-1])}, {josa(tries[-1], '을를')} 차례로 담아 봅니다."
                                       if len(tries) > 1 else f". 담을 수 있는 가격은 {tries[0]}뿐이니 그것을 담아 봅니다.")},
                  node, start, remaining, moves=moves)
        skipped = []

        def skip_frame():
            v = prices[skipped[0]]
            one = len(skipped) == 1
            frame({"en": f"Back in the call for {driver_list(chosen)}: the {'pastry at index' if one else 'pastries at indexes'} "
                         f"{listed(skipped)} {'costs' if one else 'cost'} {v} again, the price it just tried, so taking "
                         f"{'it' if one else 'one'} would repeat the combos below +{v}: skipped.",
                   "ko": f"{driver_list(chosen)} 호출로 돌아왔습니다. {listed(skipped)}번 칸도 방금 시도한 가격 "
                         f"{josa(v, '이가')} 다시 나온 것이라 고르면 +{v} 아래의 조합이 되풀이되므로 건너뜁니다."},
                  node, start, remaining, skipped=list(skipped))
            skipped.clear()

        for i in range(start, len(prices)):
            if prices[i] > remaining:
                break
            if i > start and prices[i] == prices[i - 1]:
                skipped.append(i)
                continue
            if skipped:
                skip_frame()
            chosen.append(prices[i])
            pick(i + 1, remaining - prices[i], node, i)
            chosen.pop()
        if skipped:
            skip_frame()
        open_calls.pop()

    pick(0, tab, None, None)
    printed = json.dumps(sorted(sorted(c) for c in combos), separators=(",", ":"))
    n, calls = len(combos), len(tree.nodes)
    if n:
        frame({"en": f"Every call has returned: {calls} calls, and {n} {plural(n, 'combo adds', 'combos add')} up to "
                     f"exactly {tab}, none repeated.",
               "ko": f"모든 호출이 끝났습니다. 호출 {calls}번 가운데 합이 정확히 {tab}인 조합은 겹치지 않고 {n}개입니다."},
              done=True, answer=printed)
    else:
        frame({"en": f"Every call has returned: {calls} calls, and no combo adds up to exactly {tab}, so the answer "
                     f"is [].",
               "ko": f"모든 호출이 끝났습니다. 호출 {calls}번 가운데 합이 정확히 {tab}인 조합이 없으므로 답은 빈 목록 "
                     f"[]입니다."},
              done=True, answer=printed)
    return printed


for number, sample in enumerate(sample_cases(SLUG), start=1):
    lines = sample["input"].split("\n")
    pastries, tab = json.loads(lines[0]), int(lines[1])
    run = sample_run(wt, number, sample, input=f"pastries = {driver_list(pastries)}, tab = {tab}")
    solve(pastries, tab, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
