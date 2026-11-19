#!/usr/bin/env python3.12
"""merged-price-median's Walkthrough: the reference solution (scripts/replay-solutions/merged-price-median.py),
a binary search over where to cut the shorter list, recording two frames per cut tried on each sample Test
Case: one that draws the cut (i values of a and j = half - i of b on the left, as spans) with the four values
beside it lit, and one that checks them, moving the failing comparison into the range of cuts still possible,
an interval on a number line of i, or, when both checks hold, the median into the answer.

A cut at either end of a list reads -inf or inf past it, which has no cell: the caption names it.

    CODEBITE_DB=<database> scripts/walkthroughs/merged-price-median.py

writes common/src/main/resources/walkthroughs/merged-price-median.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import josa, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move, span  # noqa: E402

SLUG = "merged-price-median"
NEG, POS = "−∞", "∞"

wt = Walkthrough(
    {"en": "Merged Price Median", "ko": "합친 가격 목록의 중앙값"},
    {"en": "Binary search over the cut: take i values from the shorter list a and half − i from b as the left "
           "half of the merged list; the cut is right when each list's left edge is at most the other's right "
           "edge, and which check fails says whether i must grow or shrink.",
     "ko": "자르는 위치 위의 이분 탐색입니다. 짧은 목록 a에서 i개, b에서 half − i개를 합친 목록의 왼쪽 절반으로 삼습니다. "
           "각 목록의 왼쪽 끝 값이 다른 목록의 오른쪽 첫 값 이하이면 맞게 자른 것이고, 어느 비교가 틀리는지가 i를 늘릴지 "
           "줄일지 알려 줍니다."},
    views=[
        {"id": "a", "type": "array", "title": {"en": "a (the shorter list)", "ko": "a (짧은 목록)"}},
        {"id": "b", "type": "array", "title": {"en": "b", "ko": "b (긴 목록)"}},
        {"id": "cuts", "type": "intervals", "title": {"en": "cuts i still possible", "ko": "아직 가능한 자르는 위치 i"}},
        {"id": "state", "type": "vars"},
        {"id": "result", "type": "output", "title": {"en": "median", "ko": "중앙값"}},
    ],
)


def show(x):
    return NEG if x == float("-inf") else POS if x == float("inf") else x


def solve(prices_a, prices_b, run):
    """Solution.mergedPriceMedian with two frames per cut tried. Returns the answer as the Driver prints it."""
    a, b = prices_a, prices_b
    if len(a) > len(b):
        a, b = b, a
    m, n = len(a), len(b)
    half = (m + n + 1) // 2
    low, high = 0, m
    cut = {}
    out = []

    def frame(caption, marks_a=None, marks_b=None, range_mark=None, moves=None, done=False, **answer):
        views = {}
        for name, values, k in (("a", a, cut.get("i")), ("b", b, cut.get("j"))):
            marks = (marks_a if name == "a" else marks_b) or {}
            state = {"values": values,
                     "marks": {mk: [x for x in xs if 0 <= x < len(values)] for mk, xs in marks.items()}}
            if k is not None:
                state["spans"] = {"left": span(0, k - 1, {"en": f"left {k}", "ko": f"왼쪽 {k}"}) if k > 0 else None}
                state["tags"] = [[x, t] for x, t in ((k - 1, {"en": "left", "ko": "왼쪽"}),
                                                     (k, {"en": "right", "ko": "오른쪽"})) if 0 <= x < len(values)]
            views[name] = state
        points = [{"at": cut["i"], "label": "i", "mark": "lit"}] if "i" in cut and not done else []
        run.frame(caption, a=views["a"], b=views["b"],
                  cuts={"groups": [{"label": {"en": "possible", "ko": "가능"}, "intervals": [[low, high]],
                                    "marks": {range_mark: [0]} if range_mark else {}}],
                        "points": points},
                  state={"items": [{"label": {"en": "half (left size)", "ko": "half (왼쪽 크기)"}, "value": half}]},
                  result={"values": list(out)}, moves=moves, **answer)

    names = ("pricesA", "pricesB") if a is prices_a else ("pricesB", "pricesA")
    frame({"en": f"a = {names[0]}, the shorter list, and b = {names[1]}. The left half of all {m + n} values holds "
                 f"half = ({m + n} + 1) // 2 = {half}, and a gives i of them for some i in [0, {m}]"
                 f"{' (a is empty, so only i = 0)' if m == 0 else ''}.",
           "ko": f"a는 짧은 목록 {names[0]}, b는 {names[1]}입니다. 값 {m + n}개의 왼쪽 절반은 half = ({m + n} + 1) // 2 "
                 f"= {half}개이고, 그중 a에서 i개를 가져오며 i는 [0, {m}] 범위입니다"
                 f"{'(a가 비어 있어 i = 0뿐)' if m == 0 else ''}."})
    while low <= high:
        i = (low + high) // 2
        j = half - i
        cut.update(i=i, j=j)
        a_left = a[i - 1] if i > 0 else float("-inf")
        a_right = a[i] if i < m else float("inf")
        b_left = b[j - 1] if j > 0 else float("-inf")
        b_right = b[j] if j < n else float("inf")
        al, ar, bl, br = map(show, (a_left, a_right, b_left, b_right))
        edges = {"lit": [i - 1, i]}
        frame({"en": f"Try i = ({low} + {high}) // 2 = {i}, so j = {half} − {i} = {j}: the left half takes {i} from a "
                     f"and {j} from b. The edges are a: {al} | {ar} and b: {bl} | {br}.",
               "ko": f"i = ({low} + {high}) // 2 = {josa(i, '을를')} 시도하면 j = {half} − {i} = {j}: 왼쪽 절반은 a에서 "
                     f"{i}개, b에서 {j}개입니다. 경계는 a: {al} | {ar}, b: {bl} | {br}입니다."},
              marks_a=edges, marks_b={"lit": [j - 1, j]})
        if a_left <= b_right and b_left <= a_right:
            left_max = max(a_left, b_left)
            from_left = ("a", i - 1) if a_left >= b_left else ("b", j - 1)
            if (m + n) % 2:
                result = float(left_max)
                text = f"{result:.1f}"
                out.append(text)
                cut_ok_en = f"{al} ≤ {br} and {bl} ≤ {ar}, so the cut is right. {m + n} is odd: the median is the " \
                            f"larger left edge, max({al}, {bl}) = {text}."
                cut_ok_ko = f"{al} ≤ {br}, {bl} ≤ {ar}: 맞게 잘랐습니다. 개수 {josa(m + n, '이가')} 홀수라 중앙값은 " \
                            f"왼쪽 끝 중 큰 값, max({al}, {bl}) = {text}입니다."
                moves = [move(at(*from_left), at("result", 0), value=str(left_max))]
                good_a = [from_left[1]] if from_left[0] == "a" else []
                good_b = [from_left[1]] if from_left[0] == "b" else []
            else:
                right_min = min(a_right, b_right)
                from_right = ("a", i) if a_right <= b_right else ("b", j)
                result = (left_max + right_min) / 2
                text = f"{result:.1f}"
                out.append(text)
                cut_ok_en = f"{al} ≤ {br} and {bl} ≤ {ar}, so the cut is right. {m + n} is even: the median is " \
                            f"(max({al}, {bl}) + min({ar}, {br})) / 2 = ({left_max} + {right_min}) / 2 = {text}."
                cut_ok_ko = f"{al} ≤ {br}, {bl} ≤ {ar}: 맞게 잘랐습니다. 개수 {josa(m + n, '이가')} 짝수라 중앙값은 " \
                            f"(max({al}, {bl}) + min({ar}, {br})) / 2 = ({left_max} + {right_min}) / 2 = {text}입니다."
                moves = [move(at(*from_left), at("result", 0), value=str(left_max)),
                         move(at(*from_right), at("result", 0), value=str(right_min))]
                good_a = [k for side, k in (from_left, from_right) if side == "a"]
                good_b = [k for side, k in (from_left, from_right) if side == "b"]
            frame({"en": cut_ok_en, "ko": cut_ok_ko},
                  marks_a={"path": good_a},
                  marks_b={"path": good_b},
                  range_mark="path", moves=moves, done=True, answer=text)
            return
        if a_left > b_right:
            high = i - 1
            frame({"en": f"{al} > {br}: a's left edge is bigger than b's right edge, so a gives too many; every cut "
                         f"from i on fails too: high = {high}.",
                   "ko": f"{al} > {br}: a의 왼쪽 끝이 b의 오른쪽 첫 값보다 커서 a에서 너무 많이 가져왔습니다. "
                         f"i 이상은 모두 안 되므로 high = {high}."},
                  marks_a={"bad": [i - 1]}, marks_b={"bad": [j]}, range_mark="good",
                  moves=[move(at("a", i - 1), at("cuts", [0, 0]), value=f"{al} > {br}")])
        else:
            low = i + 1
            frame({"en": f"{bl} > {ar}: b's left edge is bigger than a's right edge, so a gives too few; every cut "
                         f"up to i fails too: low = {low}.",
                   "ko": f"{bl} > {ar}: b의 왼쪽 끝이 a의 오른쪽 첫 값보다 커서 a에서 너무 적게 가져왔습니다. "
                         f"i 이하는 모두 안 되므로 low = {low}."},
                  marks_a={"bad": [i]}, marks_b={"bad": [j - 1]}, range_mark="good",
                  moves=[move(at("b", j - 1), at("cuts", [0, 0]), value=f"{bl} > {ar}")])
    raise ValueError("inputs are not sorted")


for number, sample in enumerate(sample_cases(SLUG), start=1):
    lines = sample["input"].split("\n")
    prices_a, prices_b = json.loads(lines[0]), json.loads(lines[1])
    m = min(len(prices_a), len(prices_b))
    run = sample_run(wt, number, sample, input=f"pricesA = {lines[0].strip()}, pricesB = {lines[1].strip()}",
                     setup={"cuts": {"domain": [0, max(m, 1)]}})
    solve(prices_a, prices_b, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
