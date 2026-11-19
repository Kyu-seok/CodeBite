#!/usr/bin/env python3.12
"""shortest-cookie-span's Walkthrough: the reference solution (scripts/replay-solutions/shortest-cookie-span.py),
a window that grows on the right until its trays hold at least target cookies and then shrinks from the left while
they still do, recording one frame per tray added, one per window measured and one per tray dropped on each sample
Test Case. The window is a span above the trays and the shortest one so far a dashed span below them; the window's
total is an output of one chip that each tray added moves into as +c and each tray dropped as −c.

    CODEBITE_DB=<database> scripts/walkthroughs/shortest-cookie-span.py

writes common/src/main/resources/walkthroughs/shortest-cookie-span.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import josa, plural, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move, span  # noqa: E402

SLUG = "shortest-cookie-span"

wt = Walkthrough(
    {"en": "Shortest Cookie Span", "ko": "가장 짧은 쿠키 구간"},
    {"en": "Grow the window on the right until its trays hold at least target cookies, then shrink it from the left "
           "for as long as they still do: each window that reaches target is measured, and the shortest is the answer.",
     "ko": "트레이의 쿠키 합이 target 이상이 될 때까지 구간을 오른쪽으로 늘리고, 그 뒤 합이 target 이상인 동안 왼쪽에서 "
           "줄입니다. target에 닿는 구간마다 길이를 재고, 가장 짧은 구간이 답입니다."},
    views=[
        {"id": "trays", "type": "array", "title": {"en": "trays", "ko": "trays (트레이별 쿠키)"}},
        {"id": "total", "type": "output", "title": {"en": "total in the window", "ko": "구간의 쿠키 합 (total)"}},
        {"id": "state", "type": "vars"},
    ],
)


def solve(trays, target, run):
    """Solution.shortestCookieSpan with a frame per step. Returns the answer as the Driver prints it."""
    n = len(trays)
    best, best_start = n + 1, None
    total, left, right = 0, 0, None

    def frame(caption, trays_lit=(), total_mark=None, window_mark=None, best_mark=None, moves=None, done=False,
              **answer):
        spans = {}
        if not done and right is not None and right >= left:
            length = right - left + 1
            spans["window"] = span(left, right, {"en": f"window {length}", "ko": f"구간 {length}"},
                                   mark=window_mark, fade=True)
        if best <= n:
            spans["best"] = span(best_start, best_start + best - 1,
                                 {"en": f"best {best}", "ko": f"best (최단) {best}"},
                                 mark="path" if done else best_mark, below=True)
        marks = {"lit": list(trays_lit)}
        if done and best <= n:
            marks = {"path": list(range(best_start, best_start + best))}
        read = n if done else 0 if right is None else right + 1
        run.frame(caption,
                  trays={"values": list(trays), "spans": spans,
                         "pointers": {} if done or right is None else
                         {"left": left if left <= right else None, "right": right},
                         "unread": list(range(read, n)), "marks": marks},
                  total={"values": [total], "marks": {total_mark: [0]} if total_mark else {}},
                  state={"items": [{"label": {"en": "target", "ko": "target (목표)"}, "value": target}]},
                  moves=moves, **answer)

    frame({"en": f"{n} {plural(n, 'tray', 'trays')} and target = {target}. The window starts empty with a total "
                 f"of 0 cookies.",
           "ko": f"트레이 {n}개, target = {target}입니다. 구간은 비어 있고 쿠키 합은 0에서 시작합니다."})
    for right, cookies in enumerate(trays):
        total += cookies
        reached = total >= target
        if reached:
            text = {"en": f"trays[{right}] = {cookies} joins: total = {total}, at least target {target}. "
                          f"The window holds enough.",
                    "ko": f"trays[{right}] = {cookies} 추가: 합이 {josa(total, '(으)로')} target {target} 이상입니다. "
                          f"구간이 충분히 담았습니다."}
        else:
            text = {"en": f"trays[{right}] = {cookies} joins: total = {total}, still short of target {target}, "
                          f"so the window grows.",
                    "ko": f"trays[{right}] = {cookies} 추가: 합이 {josa(total, '(으)로')} 아직 target {target}보다 "
                          f"적어 구간을 늘립니다."}
        frame(text, trays_lit=[right], total_mark="good",
              moves=[move(at("trays", right), at("total", 0), value=f"+{cookies}", mark="good")])
        while total >= target and left <= right:
            length = right - left + 1
            if length < best:
                old = best
                best, best_start = length, left
                beat_en = "the first window to reach target" if old > n else f"shorter than the best {old}"
                beat_ko = "처음으로 target에 닿은 구간이므로" if old > n else f"지금까지 최단 {old}보다 짧으므로"
                frame({"en": f"trays[{left}..{right}] hold {total} ≥ {target}. Length {length} is {beat_en}, "
                             f"so it is the best now.",
                       "ko": f"trays[{left}..{right}]의 합 {total} ≥ {target}. 길이 {length}: {beat_ko} 이제 "
                             f"best입니다."},
                      window_mark="good", best_mark="good")
            else:
                frame({"en": f"trays[{left}..{right}] hold {total} ≥ {target}, but length {length} doesn't beat "
                             f"the best {best}.",
                       "ko": f"trays[{left}..{right}]의 합 {total} ≥ {target}이지만, 길이 {josa(length, '은는')} "
                             f"최단 {best}보다 짧지 않습니다."},
                      window_mark="good")
            out = trays[left]
            total -= out
            left += 1
            if total >= target:
                tail_en, tail_ko = "still enough, so shrink again", "여전히 충분하니 다시 줄입니다"
            else:
                tail_en, tail_ko = "short of target again, so grow on the right", "다시 모자라니 오른쪽으로 늘립니다"
            frame({"en": f"Shrink from the left: trays[{left - 1}] = {out} leaves, total = {total}: {tail_en}.",
                   "ko": f"왼쪽에서 줄입니다: trays[{left - 1}] = {out} 제거, 합 {total}: {tail_ko}."},
                  trays_lit=[left - 1], total_mark="bad",
                  moves=[move(at("trays", left - 1), at("total", 0), value=f"−{out}", mark="bad")])
    if best <= n:
        end = best_start + best - 1
        frame({"en": f"The window reached the last tray. The shortest window holding at least {target} cookies was "
                     f"trays[{best_start}..{end}], length {best}.",
               "ko": f"구간이 마지막 트레이에 닿았습니다. 쿠키를 {target}개 이상 담은 가장 짧은 구간은 "
                     f"trays[{best_start}..{end}], 길이 {best}입니다."},
              total_mark="dim", done=True, answer=str(best))
    else:
        frame({"en": f"The window reached the last tray with total {total}, short of target {target}: even all the "
                     f"trays together never reach it, so the answer is 0.",
               "ko": f"구간이 마지막 트레이에 닿았지만 합 {josa(total, '은는')} target {target}보다 적습니다. 트레이를 "
                     f"모두 합쳐도 닿지 않으므로 답은 0입니다."},
              total_mark="bad", done=True, answer="0")


for number, sample in enumerate(sample_cases(SLUG), start=1):
    lines = sample["input"].split("\n")
    trays, target = json.loads(lines[0]), int(lines[1])
    run = sample_run(wt, number, sample, input=f"trays = {lines[0].strip()}, target = {target}")
    solve(trays, target, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
