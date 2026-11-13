#!/usr/bin/env python3.12
"""majority-boss-vote's Walkthrough: the reference solution
(scripts/replay-solutions/majority-boss-vote.py), Boyer-Moore voting with one candidate and a count,
recording one frame per vote on each sample Test Case.

    CODEBITE_DB=<database> scripts/walkthroughs/majority-boss-vote.py

writes common/src/main/resources/walkthroughs/majority-boss-vote.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import driver_list, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough  # noqa: E402

SLUG = "majority-boss-vote"

wt = Walkthrough(
    {"en": "Majority Boss Vote", "ko": "대세 픽 고르기"},
    {"en": "Cancel each vote against a different one: a vote for the candidate adds 1, any other vote takes "
           "1 away, and at 0 the next vote becomes the candidate. The majority has more votes than everyone "
           "else together, so it is the candidate left standing.",
     "ko": "서로 다른 표끼리 상쇄합니다. 후보와 같은 표는 카운트를 1 올리고 다른 표는 1 내리며, 카운트가 0이면 "
           "다음 표가 새 후보가 됩니다. 과반은 나머지 표를 모두 합친 것보다 많으니 끝까지 남는 후보가 답입니다."},
    views=[
        {"id": "votes", "type": "array", "title": "votes"},
        {"id": "state", "type": "vars"},
    ],
)


def solve(votes, run):
    """Solution.majorityHeadline with a frame per vote."""
    candidate = votes[0]
    count = 0
    i = None
    picked_at = None  # where the current candidate was picked, for the last frame
    tags = []  # [index, "+1" or "−1"]: what each vote read did to the count

    def frame(caption, lit=(), good=(), path=(), dim=(), cand_mark=None, **answer):
        run.frame(caption,
                  votes={"values": votes, "pointers": {"i": i}, "tags": list(tags),
                         "marks": {"lit": list(lit), "good": list(good), "path": list(path), "dim": list(dim)}},
                  state={"items": [
                      {"label": {"en": "candidate", "ko": "후보"}, "value": candidate if picked_at is not None else "–",
                       **({"mark": cand_mark} if cand_mark else {})},
                      {"label": {"en": "count", "ko": "카운트"}, "value": count},
                  ]},
                  **answer)

    n = len(votes)
    frame({"en": "No candidate yet and the count is 0. Read the votes left to right.",
           "ko": "아직 후보가 없고 카운트는 0입니다. 표를 왼쪽부터 읽습니다."},
          dim=range(n))
    for i, vote in enumerate(votes):
        later = range(i + 1, n)
        if count == 0:
            candidate = vote
            picked_at = i
            count += 1
            tags.append([i, "+1"])
            frame({"en": f"The count is 0, so vote {vote} becomes the candidate with count 1."
                   if i == 0 else
                   f"The count is 0: every earlier vote is cancelled out. Vote {vote} becomes the new candidate "
                   f"with count 1.",
                   "ko": f"카운트가 0이므로 {vote}번 표가 후보가 되고 카운트는 1입니다."
                   if i == 0 else
                   f"카운트가 0입니다. 앞의 표는 모두 서로 상쇄되었습니다. {vote}번 표가 새 후보가 되고 카운트는 1입니다."},
                  good=[i], dim=later, cand_mark="good")
        elif vote == candidate:
            count += 1
            tags.append([i, "+1"])
            frame({"en": f"Vote {vote} matches the candidate: count up to {count}.",
                   "ko": f"{vote}번 표가 후보와 같습니다. 카운트를 올려 {count}입니다."},
                  lit=[i], dim=later)
        else:
            count -= 1
            tags.append([i, "−1"])
            frame({"en": f"Vote {vote} differs from candidate {candidate}: the two cancel, count down to {count}.",
                   "ko": f"{vote}번 표는 후보 {candidate}번과 다릅니다. 둘이 상쇄되어 카운트를 내려 {count}입니다."},
                  lit=[i], dim=later)
    i = None
    answer = str(candidate)
    held = sum(1 for v in votes if v == candidate)
    read = "The only vote" if n == 1 else f"All {n} votes"
    frame({"en": f"{read} read. {candidate} is the candidate left standing with count {count}. It holds {held} "
                 f"of the {n} votes, more than half, and such a value can't be cancelled out entirely: "
                 f"the answer is {candidate}.",
           "ko": f"표 {n}개를 다 읽었습니다. 끝까지 남은 후보는 {candidate}번이고 카운트는 {count}입니다. "
                 f"{candidate}번은 표 {n}개 중 {held}개로 과반이고, 과반인 값은 모두 상쇄될 수 없으므로 "
                 f"답은 {candidate}번입니다."},
          path=[k for k in range(n) if votes[k] == candidate], cand_mark="path", answer=answer)


for number, sample in enumerate(sample_cases(SLUG), start=1):
    votes = json.loads(sample["input"])
    run = sample_run(wt, number, sample, input=f"votes = {driver_list(votes)}")
    solve(votes, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
