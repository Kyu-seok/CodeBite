#!/usr/bin/env python3.12
"""longest-rising-quiz-scores' Walkthrough: the reference solution
(scripts/replay-solutions/longest-rising-quiz-scores.py), a list `tails` where tails[k] is the smallest score that
ends a strictly rising run of length k + 1, kept sorted and searched with bisect_left, recording one frame per score
on each sample Test Case.

Each score moves into the tail bisect_left finds for it: past the end, it makes the list one longer; otherwise it
replaces the first tail not below it. The tail before that place, the run it extends, is lit. The tracer keeps
which score each placed score extended, so the last frame marks a rising run of the answer's length on the scores.

    CODEBITE_DB=<database> scripts/walkthroughs/longest-rising-quiz-scores.py

writes common/src/main/resources/walkthroughs/longest-rising-quiz-scores.json.
"""
import json
import os
import sys
from bisect import bisect_left

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import josa, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move  # noqa: E402

SLUG = "longest-rising-quiz-scores"

wt = Walkthrough(
    {"en": "Longest Rising Quiz Scores", "ko": "가장 긴 상승 퀴즈 점수"},
    {"en": "Keep, for every run length, the smallest score a rising run of that length can end on. Each score "
           "either extends the longest run or lowers the end of a shorter one, so the list's length is the answer.",
     "ko": "길이마다 그 길이의 증가 부분수열이 끝날 수 있는 가장 작은 점수를 기억합니다. 각 점수는 가장 긴 "
           "수열을 늘리거나 더 짧은 수열의 끝을 낮추므로, 이 목록의 길이가 답입니다."},
    views=[
        {"id": "scores", "type": "array", "title": {"en": "scores", "ko": "scores (퀴즈 점수)"}},
        {"id": "tails", "type": "array",
         "title": {"en": "tails: smallest end of a rise of each length", "ko": "tails: 길이별 증가 수열의 가장 작은 끝"},
         "empty": {"en": "empty", "ko": "비어 있음"}},
    ],
)


def length(k):
    return {"en": f"len {k}", "ko": f"길이 {k}"}


def solve(scores, run):
    """Solution.longestRisingScores with a frame per score. Returns the answer as the Driver prints it."""
    n = len(scores)
    tails = []
    tail_at = []  # tail_at[k] is the index in scores of tails[k]
    extends = {}  # score index -> the index of the score it extended, for the last frame's run

    def frame(caption, i=None, done=False, score_marks=None, tail_marks=None, moves=None, **answer):
        run.frame(caption,
                  scores={"values": scores, "pointers": {"i": i}, "marks": score_marks or {},
                          "unread": [] if done else list(range(n)) if i is None else list(range(i + 1, n))},
                  tails={"values": list(tails), "tags": [[k, length(k + 1)] for k in range(len(tails))],
                         "marks": tail_marks or {}},
                  moves=moves, **answer)

    frame({"en": f"{n} scores. tails starts empty: no run is known yet.",
           "ko": f"점수가 {n}개입니다. 아직 아는 수열이 없으므로 tails는 비어 있습니다."})
    for i, score in enumerate(scores):
        pos = bisect_left(tails, score)
        lit = [pos - 1] if pos > 0 else []
        if pos > 0:
            extends[i] = tail_at[pos - 1]
        if pos == len(tails):
            tails.append(score)
            tail_at.append(i)
            if pos == 0:
                en = f"Score {score}: tails is empty, so {score} starts a run of length 1."
                ko = f"점수 {score}: tails가 비어 있으므로 {score}에서 길이 1인 수열이 시작됩니다."
            else:
                en = (f"Score {score} is above every tail, the last being {tails[pos - 1]}: it extends that run of "
                      f"length {pos} to length {pos + 1}, and tails grows.")
                ko = (f"점수 {josa(score, '은는')} 마지막 끝 {josa(tails[pos - 1], '을를')} 포함해 모든 끝보다 큽니다. 길이 "
                      f"{pos}인 수열을 길이 {josa(pos + 1, '(으)로')} 늘리므로 tails가 길어집니다.")
        else:
            old = tails[pos]
            tails[pos] = score
            tail_at[pos] = i
            if old == score:
                en = (f"Score {score} equals the end of the length-{pos + 1} run, and equal scores don't rise, so "
                      f"it can't extend it. It takes that place, and the end stays {score}.")
                ko = (f"점수 {josa(score, '은는')} 길이 {pos + 1}인 수열의 끝과 같고, 같은 점수는 증가가 아니라 "
                      f"늘릴 수 없습니다. 그 자리에 들어가며 끝은 {score} 그대로입니다.")
            elif pos == 0:
                en = (f"Score {score} is below every tail. A run of length 1 can now end on {score} instead of "
                      f"{old}, so it replaces {old}.")
                ko = (f"점수 {josa(score, '은는')} 모든 끝보다 작습니다. 길이 1인 수열이 {old} 대신 {score}에서 "
                      f"끝날 수 있으므로 {josa(old, '을를')} 바꿉니다.")
            else:
                en = (f"Score {score}: the first tail not below it is {old}, at length {pos + 1}. {score} extends "
                      f"the length-{pos} run ending on {tails[pos - 1]}, so a length-{pos + 1} run can end lower: "
                      f"{score} replaces {old}.")
                ko = (f"점수 {score}: 이보다 작지 않은 첫 끝은 길이 {pos + 1}의 {old}입니다. {tails[pos - 1]}에서 "
                      f"끝나는 길이 {pos} 수열을 {josa(score, '이가')} 늘리므로, 길이 {pos + 1} 수열이 더 낮은 "
                      f"{score}에서 끝날 수 있어 {josa(old, '을를')} 바꿉니다.")
        frame({"en": en, "ko": ko}, i=i, score_marks={"lit": [i]}, tail_marks={"lit": lit, "good": [pos]},
              moves=[move(at("scores", i), at("tails", pos))])
    best = len(tails)
    chain = [tail_at[-1]]
    while chain[-1] in extends:
        chain.append(extends[chain[-1]])
    chain.reverse()
    picked = json.dumps([scores[j] for j in chain], separators=(",", ":"))
    frame({"en": f"Every score read: tails holds {best} {'end' if best == 1 else 'ends'}, so the longest rising "
                 f"run has length {best}; following each score back to the one it extended gives {picked}. "
                 f"Answer: {best}.",
           "ko": f"모든 점수를 읽었고 tails에 끝이 {best}개 있으므로 가장 긴 증가 부분수열의 길이는 "
                 f"{best}이고, 각 점수가 늘린 점수를 거슬러 가면 {picked}입니다. 답은 {best}입니다."},
          done=True, score_marks={"path": chain, "dim": [j for j in range(n) if j not in chain]},
          tail_marks={"path": list(range(best))}, answer=str(best))


for number, sample in enumerate(sample_cases(SLUG), start=1):
    scores = json.loads(sample["input"])
    run = sample_run(wt, number, sample, input=f"scores = {sample['input']}")
    solve(scores, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
