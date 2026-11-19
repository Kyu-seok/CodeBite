#!/usr/bin/env python3.12
"""peak-score-streak's Walkthrough: the reference solution (scripts/replay-solutions/peak-score-streak.py), one
pass carrying the best sum of a streak that ends on the current note (Kadane), recording one frame per note on
each sample Test Case.

The streak ending on the note read is a span above the notes, labelled with its sum, and that sum is written under
the note; a streak that goes on moves its sum from the note before, one that starts over doesn't. The best streak so
far is a span below.

    CODEBITE_DB=<database> scripts/walkthroughs/peak-score-streak.py

writes common/src/main/resources/walkthroughs/peak-score-streak.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import josa, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move, span  # noqa: E402

SLUG = "peak-score-streak"

wt = Walkthrough(
    {"en": "Peak Score Streak", "ko": "최고 점수 구간"},
    {"en": "The best streak ending on a note either goes on from the streak before it or starts over at that note: "
           "start over whenever the streak before has a negative sum, and keep the best sum seen.",
     "ko": "어떤 노트에서 끝나는 최고의 구간은 앞 구간에 이어 붙이거나 그 노트에서 새로 시작합니다. 앞 구간의 합이 "
           "음수이면 새로 시작하고, 지금까지 본 가장 큰 합을 기억합니다."},
    views=[
        {"id": "nums", "type": "array", "title": {"en": "nums (points per note)", "ko": "nums (노트별 점수)"}},
    ],
)


def signed(n):
    return f"+{n}" if n >= 0 else f"−{-n}"


def plus(a, b):
    """a + b written out for a caption: "5 + 2", "7 − 8"."""
    return f"{a} + {b}" if b >= 0 else f"{a} − {-b}"


def solve(nums, run):
    """Solution.maxScoreStreak with a frame per note. Returns the answer as the Driver prints it."""
    n = len(nums)
    current = best = nums[0]
    start = 0  # where the streak ending on the note read begins
    best_from = best_to = 0
    under = [[0, str(current)]]

    def frame(caption, i=None, lit=(), good=(), path=(), streak_mark=None, best_mark=None, show_streak=True,
              moves=None, **answer):
        spans = {"best": span(best_from, best_to, {"en": f"best {best}", "ko": f"best (최고 합) {best}"},
                              mark=best_mark, below=True)}
        if show_streak:
            spans["streak"] = span(start, i, {"en": f"sum {current}", "ko": f"합 {current}"}, mark=streak_mark)
        run.frame(caption,
                  nums={"values": nums, "pointers": {"i": i}, "under": list(under), "spans": spans,
                        "unread": list(range(i + 1, n)) if i is not None else [],
                        "marks": {"path": list(path), "good": list(good), "lit": list(lit)}},
                  moves=moves, **answer)

    frame({"en": f"{n} {'note' if n == 1 else 'notes'}. The streak ending on note 0 can only be [{nums[0]}], so it "
                 f"sums to {nums[0]}, and that is the best so far.",
           "ko": f"노트가 {n}개입니다. 노트 0에서 끝나는 구간은 [{nums[0]}] 하나뿐이라 합이 {nums[0]}이고, "
                 f"지금까지의 최고 합도 {nums[0]}입니다."},
          i=0, lit=[0])
    for i in range(1, n):
        score = nums[i]
        before = current
        if current + score >= score:  # max(score, current + score): going on is at least as good
            current = current + score
            how_en = (f"The streak before sums to {before}, not negative, so it goes on: "
                      f"{plus(before, score)} = {current}.")
            how_ko = (f"앞 구간의 합 {josa(before, '이가')} 음수가 아니므로 이어 붙입니다: "
                      f"{plus(before, score)} = {current}.")
            moves = [move(at("nums", i - 1), at("nums", i), value=f"{before}{signed(score)}")]
        else:
            current = score
            start = i
            how_en = f"The streak before sums to {before}, below 0, so it would only drag {score} down: start over at {score}."
            how_ko = (f"앞 구간의 합 {josa(before, '이가')} 0보다 작아 {josa(score, '을를')} 깎을 뿐이므로, "
                      f"{score}에서 새로 시작합니다.")
            moves = None
        under.append([i, str(current)])
        if current > best:
            old = best
            best, best_from, best_to = current, start, i
            frame({"en": f"{how_en} {current} beats the best, {old}.",
                   "ko": f"{how_ko} {josa(current, '이가')} 최고 합 {old}보다 큽니다."},
                  i=i, lit=[i], streak_mark="good", best_mark="good", moves=moves)
        else:
            frame({"en": f"{how_en} The best stays {best}.", "ko": f"{how_ko} 최고 합은 {best} 그대로입니다."},
                  i=i, lit=[i], moves=moves)
    window = nums[best_from:best_to + 1]
    frame({"en": f"Every note read: the best streak is notes {best_from} to {best_to}, "
                 f"{json.dumps(window, separators=(',', ':'))}, with sum {best}. Answer: {best}."
           if best_from != best_to else
           f"Every note read: the best streak is note {best_from} alone, [{nums[best_from]}], with sum {best}. "
           f"Answer: {best}.",
           "ko": f"모든 노트를 읽었고, 가장 좋은 구간은 노트 {best_from}부터 {best_to}까지의 "
                 f"{json.dumps(window, separators=(',', ':'))} 구간으로 합이 {best}입니다. 답은 {best}입니다."
           if best_from != best_to else
           f"모든 노트를 읽었고, 가장 좋은 구간은 노트 {best_from} 하나뿐인 [{nums[best_from]}] 구간으로 "
           f"합이 {best}입니다. 답은 {best}입니다."},
          path=range(best_from, best_to + 1), best_mark="path", show_streak=False, answer=str(best))


for number, sample in enumerate(sample_cases(SLUG), start=1):
    nums = json.loads(sample["input"])
    run = sample_run(wt, number, sample, input=f"nums = {sample['input']}")
    solve(nums, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
