#!/usr/bin/env python3.12
"""biggest-locker-poster's Walkthrough: the reference solution
(scripts/replay-solutions/biggest-locker-poster.py), two pointers walking in from both ends of the lockers,
recording one frame per poster measured on each sample Test Case. The poster between the pointers is a span
labelled with its height × width; the best so far is a dashed span below. The shorter locker then moves in:
every other poster it could frame is narrower and no taller, so it is ruled out (red), and fades next.

    CODEBITE_DB=<database> scripts/walkthroughs/biggest-locker-poster.py

writes common/src/main/resources/walkthroughs/biggest-locker-poster.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import josa, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, span  # noqa: E402

SLUG = "biggest-locker-poster"

wt = Walkthrough(
    {"en": "Biggest Locker Poster", "ko": "가장 큰 사물함 포스터"},
    {"en": "Start with the widest poster, the two end lockers, and always move the shorter one inward: any other "
           "poster on the shorter locker would be narrower and no taller, so it can never win.",
     "ko": "가장 넓은 포스터인 양 끝 사물함에서 시작해, 항상 더 낮은 쪽을 안으로 옮깁니다. 낮은 사물함으로 만들 수 있는 "
           "다른 포스터는 모두 더 좁고 더 높지도 않아 절대 더 커질 수 없습니다."},
    views=[
        {"id": "lockers", "type": "array", "display": "bars",
         "title": {"en": "lockers (heights)", "ko": "lockers (사물함 높이)"}},
    ],
)


def solve(lockers, run):
    """Solution.largestPosterArea with a frame per poster measured. Returns the answer as the Driver prints it."""
    n = len(lockers)
    left, right = 0, n - 1
    best, best_span = 0, None

    def frame(caption, lit=(), bad=(), path=(), poster=None, beaten=False, done=False, **answer):
        spans = {}
        if poster is not None:
            h, w = poster
            spans["poster"] = span(left, right, {"en": f"{h} × {w} = {h * w}", "ko": f"{h} × {w} = {h * w}"},
                                   fade=True)
        if best_span:
            spans["best"] = span(*best_span, {"en": f"best = {best}", "ko": f"최대 {best}"}, below=True,
                                 mark="path" if done else "good" if beaten else None)
        run.frame(caption,
                  lockers={"values": lockers, "spans": spans,
                           "pointers": {} if done else {"left": left, "right": right},
                           "marks": {"path": list(path), "bad": list(bad), "lit": list(lit)}},
                  **answer)

    frame({"en": f"{n} lockers. left starts at locker 0 and right at locker {n - 1}: the widest poster there is.",
           "ko": f"사물함 {n}개입니다. left는 0번, right는 {n - 1}번 사물함에서 시작하며, 가장 넓은 포스터입니다."})
    while left < right:
        a, b = lockers[left], lockers[right]
        h, w = min(a, b), right - left
        area = h * w
        beaten = area > best
        if beaten:
            best, best_span = area, (left, right)
            verdict = {"en": f"a new best, {best}", "ko": f"best = {josa(best, '(으)로')} 갱신"}
        else:
            verdict = {"en": f"best stays {best}", "ko": f"best = {best} 그대로"}
        if a < b:
            shorter, side = left, "left"
        else:
            shorter, side = right, "right"
        tie_en = " (a tie: right moves)" if a == b else ""
        tie_ko = " (높이가 같으면 right 쪽)" if a == b else ""
        frame({"en": f"Lockers {left} and {right}: height min({a}, {b}) = {h}, width {w}, area {area}, {verdict['en']}. "
                     f"Locker {shorter}{tie_en} is the limit, and a nearer partner can't make it taller, so {side} moves in.",
               "ko": f"{left}번과 {right}번 사물함: 높이 min({a}, {b}) = {h}, 너비 {w}, 넓이 {area}, {verdict['ko']}. "
                     f"{shorter}번 사물함이{tie_ko} 높이를 막고, 더 가까운 짝으로는 높아지지 않으니 {side} 포인터를 안으로 옮깁니다."},
              lit=[left + right - shorter], bad=[shorter], poster=(h, w), beaten=beaten)
        if a < b:
            left += 1
        else:
            right -= 1
    a, b = best_span
    frame({"en": f"left and right met. The biggest poster hangs between lockers {a} and {b}: height "
                 f"{min(lockers[a], lockers[b])}, width {b - a}, area {best}.",
           "ko": f"left와 right가 만났습니다. 가장 큰 포스터는 {a}번과 {b}번 사물함 사이로, 높이 "
                 f"{min(lockers[a], lockers[b])}, 너비 {b - a}, 넓이 {best}입니다."},
          path=[a, b], done=True, answer=str(best))


for number, sample in enumerate(sample_cases(SLUG), start=1):
    lockers = json.loads(sample["input"])
    run = sample_run(wt, number, sample, input=f"lockers = {sample['input'].strip()}")
    solve(lockers, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
