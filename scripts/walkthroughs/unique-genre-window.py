#!/usr/bin/env python3.12
"""unique-genre-window's Walkthrough: the reference solution
(scripts/replay-solutions/unique-genre-window.py), a sliding window with a count per genre, recording one
frame per tag added (its shrink, if any, in the same frame) on each sample Test Case.

    CODEBITE_DB=<database> scripts/walkthroughs/unique-genre-window.py

writes common/src/main/resources/walkthroughs/unique-genre-window.json.
"""
import os
import sys
from collections import Counter

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import josa, plural, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough  # noqa: E402

SLUG = "unique-genre-window"

wt = Walkthrough(
    {"en": "Unique Genre Window", "ko": "장르 제한 몰아보기 구간"},
    {"en": "Grow the window one tag at a time on the right; when it holds more than k genres, drop tags from the "
           "left until it holds k again. Every window it passes through is a candidate.",
     "ko": "오른쪽으로 태그를 하나씩 넣어 구간을 늘리고, 장르가 k개를 넘으면 다시 k개가 될 때까지 왼쪽에서 "
           "태그를 뺍니다. 그렇게 지나가는 구간이 모두 후보입니다."},
    views=[
        {"id": "queue", "type": "array", "title": "queue"},
        {"id": "window", "type": "table", "title": {"en": "window (genre → count)", "ko": "window (장르 → 개수)"}},
        {"id": "state", "type": "vars"},
    ],
)


def solve(queue, k, run):
    """Solution.k_distinct_window with a frame per tag added. Returns the answer as the Driver prints it."""
    n = len(queue)
    window = Counter()
    best = 0
    best_span = None  # (left, right) of the first window of length best, for the last frame
    left = 0
    right = None

    def frame(caption, good=(), bad=(), path=(), row_good=None, best_mark=None, **answer):
        keys = list(window)
        # the last frame shows only the best window, so the window the run ended on steps back
        showing = right is not None and not path
        in_window = set(range(left, right + 1)) if showing else set()
        run.frame(caption,
                  queue={"values": list(queue), "pointers": {"left": left if showing else None,
                                                             "right": right if showing else None},
                         "marks": {"dim": [j for j in range(n) if j not in in_window and j not in [*bad, *path]],
                                   "path": list(path), "bad": list(bad), "good": list(good)}},
                  window={"columns": [{"en": "count", "ko": "개수"}],
                          "rows": [{"label": g, "cells": [c]} for g, c in window.items()],
                          "marks": {"good": [[keys.index(row_good), 0]]} if row_good in window else {}},
                  state={"items": [{"label": "k", "value": k},
                                   {"label": {"en": "genres in window", "ko": "구간의 장르 수"}, "value": len(window)},
                                   {"label": {"en": "window length", "ko": "구간 길이"},
                                    "value": 0 if right is None else right - left + 1},
                                   {"label": "best", "value": best, "mark": best_mark}]},
                  **answer)

    if k == 0:
        frame({"en": "k = 0: no window may hold a genre, so not even one tag fits. Answer 0.",
               "ko": "k = 0이면 어떤 장르도 넣을 수 없어 태그 하나도 들어가지 않습니다. 답은 0입니다."},
              answer="0")
        return
    frame({"en": f"{n} tags, at most k = {k} {plural(k, 'genre', 'genres')} per window. "
                 f"The window starts empty; add tags from the left.",
           "ko": f"태그 {n}개, 구간마다 장르는 최대 k = {k}입니다. 빈 구간에서 시작해 왼쪽부터 태그를 넣습니다."})
    for right, tag in enumerate(queue):
        window[tag] += 1
        added = (f"queue[{right}] = '{tag}' joins the window",
                 f"queue[{right}] = '{tag}': 구간에 넣으면")
        dropped = []
        if len(window) > k:
            too_many = len(window)
            while len(window) > k:
                window[queue[left]] -= 1
                if window[queue[left]] == 0:
                    del window[queue[left]]
                dropped.append(left)
                left += 1
        length = right - left + 1
        improved = length > best
        if improved:
            best = length
            best_span = (left, right)
        verdict_en = f"length {length} beats best, so best = {best}." if improved else f"length {length}, best stays {best}."
        verdict_ko = f"길이 {josa(length, '(으)로')} best보다 길어 best = {best}." if improved else f"길이 {length}, best = {best} 그대로."
        if dropped:
            gone = "".join(queue[j] for j in dropped)
            emptied = ", ".join(sorted({queue[j] for j in dropped} - set(window)))  # genres whose count hit 0
            frame({"en": f"{added[0]}: that makes {too_many} genres, more than {k}, so drop from the left until "
                         f"it is back to {k}: \"{gone}\" leaves, genre {emptied} drops to 0 and left = {left}. "
                         f"Window \"{queue[left:right + 1]}\": {verdict_en}",
                   "ko": f"{added[1]} 장르가 {too_many}종류로 k = {k}보다 많아, {k}종류가 될 때까지 왼쪽에서 "
                         f"\"{gone}\" 태그를 빼고 left = {left}입니다(장르 {emptied}의 개수가 0). "
                         f"구간 \"{queue[left:right + 1]}\": {verdict_ko}"},
                  good=[right], bad=dropped, row_good=tag, best_mark="good" if improved else None)
        else:
            frame({"en": f"{added[0]}: {len(window)} {plural(len(window), 'genre', 'genres')}, within k = {k}. "
                         f"Window \"{queue[left:right + 1]}\": {verdict_en}",
                   "ko": f"{added[1]} 장르 {len(window)}종류로 k = {k} 이내입니다. "
                         f"구간 \"{queue[left:right + 1]}\": {verdict_ko}"},
                  good=[right], row_good=tag, best_mark="good" if improved else None)
    a, b = best_span
    frame({"en": f"Every tag added, and the longest window seen was \"{queue[a:b + 1]}\" "
                 f"(queue[{a}..{b}]), length {best}. Answer {best}.",
           "ko": f"모든 태그를 넣었고, 가장 긴 구간은 \"{queue[a:b + 1]}\"(queue[{a}..{b}]), "
                 f"길이 {best}입니다. 답은 {best}입니다."},
          path=range(a, b + 1), best_mark="good", answer=str(best))


for number, sample in enumerate(sample_cases(SLUG), start=1):
    lines = sample["input"].split("\n")
    queue, k = lines[0].strip(), int(lines[1])
    run = sample_run(wt, number, sample, input=f'queue = "{queue}", k = {k}')
    solve(queue, k, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
