#!/usr/bin/env python3.12
"""longest-two-flavor-stretch's Walkthrough: the reference solution
(scripts/replay-solutions/longest-two-flavor-stretch.py), a sliding window with a count per flavor that holds at
most two flavors, recording one frame per treat added and one per treat dropped on each sample Test Case. The
window is a span above the treats and the best so far a dashed span below them; the counts are a map with two
slots, so a third flavor shows red. Each treat added moves into its flavor's card, and each treat dropped from the
left moves back out in red.

    CODEBITE_DB=<database> scripts/walkthroughs/longest-two-flavor-stretch.py

writes common/src/main/resources/walkthroughs/longest-two-flavor-stretch.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import hold_to_best, plural, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, map_entries, move, span  # noqa: E402

SLUG = "longest-two-flavor-stretch"
LIMIT = 2

wt = Walkthrough(
    {"en": "Longest Two-Flavor Stretch", "ko": "맛이 두 가지 이하인 가장 긴 구간"},
    {"en": "Grow the stretch one treat at a time on the right; when it holds a third flavor, drop treats from the "
           "left until only two flavors are left. Every stretch it passes through is a candidate.",
     "ko": "오른쪽으로 간식을 하나씩 넣어 구간을 늘리고, 세 번째 맛이 들어오면 맛이 두 가지만 남을 때까지 왼쪽에서 "
           "간식을 뺍니다. 그렇게 지나가는 구간이 모두 후보입니다."},
    views=[
        {"id": "treats", "type": "array", "title": {"en": "treats", "ko": "treats (간식 맛 코드)"}},
        {"id": "window", "type": "map",
         "title": {"en": "window (flavor → count, 2 slots)", "ko": "window (맛 → 개수, 2칸)"},
         "empty": {"en": "empty", "ko": "비어 있음"}},
    ],
)


def solve(treats, run):
    """Solution.longestTwoFlavorStretch with a frame per treat added and per treat dropped."""
    n = len(treats)
    window = {}  # flavor -> count, in insertion order as Counter keeps it
    best, best_span, left, right = 0, None, 0, None

    def frame(caption, marks=None, struck=(), moves=None, window_mark="lit", beaten=False, done=False, **answer):
        spans = {}
        if right is not None and not done:
            length = right - left + 1
            spans["window"] = span(left, right, {"en": f"stretch {length}", "ko": f"구간 {length}"},
                                   mark=window_mark, fade=True)
        if best_span:
            spans["best"] = span(*best_span, {"en": f"best = {best}", "ko": f"best (최장 길이) = {best}"}, below=True,
                                 mark="path" if done else "good" if beaten else None)
        read = n if done else 0 if right is None else right + 1
        run.frame(caption,
                  treats={"values": list(treats), "spans": spans, "unread": list(range(read, n)),
                          "pointers": {"left": None if right is None or done else left,
                                       "right": None if done else right},
                          "marks": ({"path": list(range(best_span[0], best_span[1] + 1))} if done and best_span
                                    else {"lit": [right]} if right is not None and not done else {})},
                  window={"entries": map_entries(window), "slots": LIMIT, "struck": list(struck),
                          "marks": marks or ({"dim": list(window)} if done else {})},
                  moves=moves, **answer)

    frame({"en": f"{n} {plural(n, 'treat', 'treats')}, and the stretch may hold at most {LIMIT} flavors, one per "
                 f"slot. It starts empty; treats join from the left.",
           "ko": f"간식 {n}개, 구간에는 맛이 최대 {LIMIT}가지, 한 칸에 하나씩 들어갑니다. 빈 구간에서 시작해 왼쪽부터 "
                 f"간식을 넣습니다."})
    for right, flavor in enumerate(treats):
        window[flavor] = window.get(flavor, 0) + 1
        joins = [move(at("treats", right), at("window", flavor))]
        if len(window) > LIMIT:
            frame({"en": f"treats[{right}] = {flavor} joins: {len(window)} flavors, more than {LIMIT}, "
                         f"so treats leave from the left until only {LIMIT} are left.",
                   "ko": f"treats[{right}] = {flavor} 추가: 맛이 {len(window)}가지로 {LIMIT}가지보다 많아, "
                         f"{LIMIT}가지만 남을 때까지 왼쪽에서 간식을 뺍니다."},
                  marks={"bad": [flavor]}, moves=joins, window_mark="bad")
            while len(window) > LIMIT:
                out = treats[left]
                window[out] -= 1
                gone = window[out] == 0
                left += 1
                fits = len(window) - gone <= LIMIT
                beaten = False
                tail_en = tail_ko = ""
                if fits:
                    length = right - left + 1
                    beaten, best, best_span, verdict_en, verdict_ko = hold_to_best(left, right, best, best_span)
                    tail_en = f" Back to {LIMIT} flavors: stretch length {length}, {verdict_en}."
                    tail_ko = f" 다시 맛 {LIMIT}가지: 구간 길이 {length}, {verdict_ko}."
                count = f"{window[out] + 1} → {window[out]}"
                frame({"en": f"treats[{left - 1}] = {out} leaves: flavor {out}'s count goes {count}"
                             f"{', so the flavor leaves the stretch' if gone else ''}.{tail_en}",
                       "ko": f"treats[{left - 1}] = {out} 제거: 맛 {out}의 개수 {count}"
                             f"{', 구간에서 이 맛이 빠집니다' if gone else ''}.{tail_ko}"},
                      marks={} if gone else {"bad": [out]}, struck=[out] if gone else [],
                      moves=[move(at("window", out), at("treats", left - 1), mark="bad")],
                      window_mark="lit" if fits else "bad", beaten=beaten)
                if gone:
                    del window[out]
            continue
        length = right - left + 1
        beaten, best, best_span, verdict_en, verdict_ko = hold_to_best(left, right, best, best_span)
        kinds = len(window)
        frame({"en": f"treats[{right}] = {flavor} joins: {kinds} {plural(kinds, 'flavor', 'flavors')}, "
                     f"within {LIMIT}. Stretch length {length}: {verdict_en}.",
               "ko": f"treats[{right}] = {flavor} 추가: 맛 {kinds}가지로 {LIMIT}가지 이내입니다. 구간 길이 {length}, "
                     f"{verdict_ko}."},
              marks={"good": [flavor]}, moves=joins, beaten=beaten)
    a, b = best_span
    if (a, b) == (left, right):
        caption = {"en": f"Every treat is in, and the longest stretch was the last one, treats[{a}..{b}], "
                         f"length {best}. Answer {best}.",
                   "ko": f"모든 간식을 넣었고, 가장 긴 구간은 마지막 구간 treats[{a}..{b}], 길이 {best}입니다. "
                         f"답은 {best}입니다."}
    else:
        caption = {"en": f"Every treat is in: the run ended on treats[{left}..{right}], but the first stretch of "
                         f"the best length was treats[{a}..{b}], length {best}. Answer {best}.",
                   "ko": f"모든 간식을 넣었습니다. 실행은 treats[{left}..{right}]에서 끝났지만 가장 긴 구간은 처음 찾은 "
                         f"treats[{a}..{b}], 길이 {best}이고, 답은 {best}입니다."}
    frame(caption, done=True, answer=str(best))


for number, sample in enumerate(sample_cases(SLUG), start=1):
    treats = json.loads(sample["input"])
    run = sample_run(wt, number, sample, input=f"treats = {sample['input'].strip()}")
    solve(treats, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
