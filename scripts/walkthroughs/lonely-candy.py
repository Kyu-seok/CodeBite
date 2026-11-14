#!/usr/bin/env python3.12
"""lonely-candy's Walkthrough: the reference solution (scripts/replay-solutions/lonely-candy.py), one
running XOR over the candies, recording one frame per candy on each sample Test Case. The running XOR is a box
each candy moves into; a cancelled pair fades.

    CODEBITE_DB=<database> scripts/walkthroughs/lonely-candy.py

writes common/src/main/resources/walkthroughs/lonely-candy.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import plural, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move  # noqa: E402

SLUG = "lonely-candy"

wt = Walkthrough(
    {"en": "Lonely Candy", "ko": "외톨이 사탕 찾기"},
    {"en": "XOR every flavor into one number: x ^ x = 0, so each pair cancels and only the loner's bits stay.",
     "ko": "모든 맛을 XOR로 한 수에 모읍니다: x ^ x = 0이라 짝은 서로 지워지고 외톨이의 비트만 남습니다."},
    views=[
        {"id": "candies", "type": "array", "title": {"en": "candies (tag: bits)", "ko": "candies (태그: 비트)"}},
        {"id": "loner", "type": "output", "title": {"en": "loner (running XOR)", "ko": "loner (누적 XOR)"}},
    ],
)


def solve(candies, run):
    """Solution.findLonelyCandy with a frame per candy. Returns the loner."""
    width = max(1, *(abs(v).bit_length() for v in candies))
    show_bits = all(v >= 0 for v in candies)  # two's-complement bits of a negative would only confuse

    def bits(v):
        return format(v, f"0{width}b") if show_bits else str(v)

    cancelled = []  # indexes whose pair has been XORed in, so the reader sees them drop out

    def frame(caption, i=None, lit=(), good=(), path=(), **answer):
        shown = f"{loner} ({bits(loner)})" if show_bits else loner
        run.frame(caption,
                  candies={"values": candies, "pointers": {"i": i},
                           "tags": [[k, bits(v)] for k, v in enumerate(candies)] if show_bits else [],
                           "marks": {"dim": cancelled, "lit": list(lit), "good": list(good), "path": list(path)}},
                  loner={"values": [shown],
                         "marks": {"path": [0]} if path else {"good": [0]} if i is not None else {}},
                  moves=[move(at("candies", i), at("loner", 0), value=f"^ {candies[i]}", mark="good")]
                  if i is not None else None,
                  **answer)

    loner = 0
    frame({"en": f"{len(candies)} {plural(len(candies), 'candy', 'candies')}. Start loner at 0 and XOR each candy into it; "
                 "XOR flips the bits where the candy has a 1.",
           "ko": f"사탕 {len(candies)}개를 loner = 0에서 시작해 하나씩 XOR합니다. "
                 "XOR은 사탕의 비트가 1인 자리를 뒤집습니다."})
    first_at = {}
    for i, candy in enumerate(candies):
        before = loner
        loner ^= candy
        expr = f"{before} ^ {candy} = {loner}"
        if show_bits:
            expr += f" ({bits(before)} ^ {bits(candy)} = {bits(loner)})"
        if candy in first_at:
            j = first_at.pop(candy)
            cancelled.extend([j, i])
            frame({"en": f"{expr}. This is the second {candy}: it flips back exactly the bits "
                         f"the first one flipped, so the pair cancels.",
                   "ko": f"{expr}. 같은 맛의 두 번째 사탕이라 첫 번째가 뒤집은 비트를 그대로 되돌리므로, "
                         "짝이 지워집니다."},
                  i=i, lit=[j, i])
        else:
            first_at[candy] = i
            frame({"en": f"{expr}. The first {candy} so far: its bits are now in loner.",
                   "ko": f"{expr}. 이 맛은 처음 나왔으므로 그 비트가 loner에 들어갑니다."},
                  i=i, lit=[i], good=[i])
    (lone_index,) = first_at.values()
    if len(candies) == 1:
        why = {"en": "There is no pair to cancel, so loner is the one candy",
               "ko": "지울 짝이 없으므로 loner는 사탕 하나 그대로입니다"}
    else:
        why = {"en": "Every pair cancelled to 0, so loner holds only the unpaired candy",
               "ko": "모든 짝이 0으로 지워졌으므로 loner에는 짝 없는 사탕만 남습니다"}
    frame({"en": f"{why['en']}: answer {loner}.", "ko": f"{why['ko']}. 답은 {loner}입니다."},
          path=[lone_index], answer=str(loner))


for number, sample in enumerate(sample_cases(SLUG), start=1):
    candies = json.loads(sample["input"])
    run = sample_run(wt, number, sample, input=f"candies = {sample['input']}")
    solve(candies, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
