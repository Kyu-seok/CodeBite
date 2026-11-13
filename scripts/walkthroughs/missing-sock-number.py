#!/usr/bin/env python3.12
"""missing-sock-number's Walkthrough: the reference solution
(scripts/replay-solutions/missing-sock-number.py), cyclic placement: every number k in 1..n is swapped
to index k - 1, then the first index not holding its own number is the answer. One frame per swap, per
number left where it is, and per index checked, on each sample Test Case.

    CODEBITE_DB=<database> scripts/walkthroughs/missing-sock-number.py

writes common/src/main/resources/walkthroughs/missing-sock-number.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import driver_list, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move, span  # noqa: E402

SLUG = "missing-sock-number"

wt = Walkthrough(
    {"en": "Missing Sock Number", "ko": "사라진 빨래 번호"},
    {"en": "Only 1 to n can be the answer, and the array has n slots: swap each such number k into slot "
           "k − 1, and the first slot not holding its own number names the missing one.",
     "ko": "답이 될 수 있는 수는 1부터 n까지뿐이고, 배열에는 칸이 n개 있습니다. 그런 수 k를 모두 k − 1번 "
           "인덱스로 옮기면, 제 번호를 갖지 못한 첫 칸이 빠진 번호를 알려 줍니다."},
    views=[
        {"id": "socks", "type": "array", "title": {"en": "socks", "ko": "socks (양말 번호)"}},
        {"id": "result", "type": "output", "title": {"en": "answer", "ko": "답"},
         "empty": {"en": "not found yet", "ko": "아직 없음"}},
    ],
)


def solve(socks, run):
    """Solution.lowestMissingTarget with a frame per swap, per number left in place and per index
    checked."""
    n = len(socks)
    i = None
    homes = [[k, {"en": f"for {k + 1}", "ko": f"{k + 1}번 칸"}] for k in range(n)]

    def frame(caption, lit=(), good=(), bad=(), path=(), present=0, moves=None, result=(), **answer):
        """`present`: how many slots from the left were found holding their number (a span below them)."""
        spans = {}
        if present:
            label = ({"en": "1 present", "ko": "1번 있음"} if present == 1
                     else {"en": f"1..{present} present", "ko": f"1..{present}번 있음"})
            spans["present"] = span(0, present - 1, label, below=True, mark="path" if result else None)
        run.frame(caption,
                  socks={"values": list(socks), "pointers": {"i": i}, "tags": homes, "spans": spans,
                         "marks": {"lit": list(lit), "good": list(good), "bad": list(bad), "path": list(path)}},
                  result={"values": list(result), "marks": {"path": list(range(len(result)))}},
                  moves=moves, **answer)

    frame({"en": f"{n} socks, so the answer is between 1 and {n + 1}. The slot at index k is for number k + 1, "
                 f"as the label above each cell says.",
           "ko": f"양말이 {n}개이니 답은 1부터 {n + 1}까지 중 하나입니다. 인덱스 k의 칸은 번호 k + 1의 "
                 f"자리이고, 각 칸 위에 적혀 있습니다."})
    for i in range(n):
        while 1 <= socks[i] <= n and socks[socks[i] - 1] != socks[i]:
            target = socks[i] - 1
            v, w = socks[i], socks[target]
            socks[i], socks[target] = socks[target], socks[i]
            frame({"en": f"socks[{i}] = {v} belongs at index {target}, which held {w}. Swap them: {v} is home, "
                         f"and {w} lands at index {i} to be placed next.",
                   "ko": f"socks[{i}] = {v}: 이 번호의 자리는 인덱스 {target}이고, 거기에는 {w}번이 있었습니다. "
                         f"맞바꾸면 {v}번은 제자리에 가고, {w}번이 인덱스 {i}에 와서 다음으로 자리를 찾습니다."},
                  good=[i, target],
                  moves=[move(at("socks", i), at("socks", target), value=v),
                         move(at("socks", target), at("socks", i), value=w)])
        v = socks[i]
        if not 1 <= v <= n:
            frame({"en": f"socks[{i}] = {v} is outside 1 to {n}: no slot is for it, and it can't be the answer. "
                         f"Leave it.",
                   "ko": f"socks[{i}] = {v}: 1부터 {n}까지의 범위 밖이라 맞는 칸이 없고 답도 될 수 없습니다. "
                         f"그대로 둡니다."},
                  lit=[i])
        elif v - 1 == i:
            frame({"en": f"socks[{i}] = {v} is already in its own slot.",
                   "ko": f"socks[{i}] = {v}: 이미 제 칸에 있습니다."},
                  lit=[i])
        else:
            frame({"en": f"socks[{i}] = {v} is a repeat: index {v - 1} already holds {v}. Leave this copy.",
                   "ko": f"socks[{i}] = {v}: 중복입니다. 인덱스 {v - 1}에 이미 {v}번이 있으니 이 짝은 그대로 둡니다."},
                  lit=[i, v - 1])
    i = None
    frame({"en": "Every number from 1 to n that is in the pile now sits in its slot. Now read the slots from the left for the first one "
                 "missing its number.",
           "ko": "1부터 n까지 중 더미에 있는 번호는 모두 제 칸에 들어갔습니다. 이제 왼쪽부터 제 번호가 없는 첫 칸을 찾습니다."})
    for i in range(n):
        if socks[i] != i + 1:
            answer = str(i + 1)
            before = ({"en": f"1 to {i} are all there, so ", "ko": f"1부터 {i}까지는 모두 있으므로 "} if i
                      else {"en": "No smaller positive number exists, so ", "ko": "이보다 작은 양수는 없으므로 "})
            frame({"en": f"Index {i} is the slot for {i + 1} but holds {socks[i]}, so no sock is numbered {i + 1}. "
                         f"{before['en']}the smallest missing number is {i + 1}.",
                   "ko": f"인덱스 {i}의 칸은 {i + 1}번 칸인데 {socks[i]}번이 들어 있으니 {i + 1}번 양말은 없습니다. "
                         f"{before['ko']}빠진 가장 작은 번호는 {i + 1}번입니다."},
                  bad=[i], present=i, result=[i + 1],
                  moves=[move(at("socks", i), at("result", 0), value=i + 1)], answer=answer)
            return
        frame({"en": f"Index {i} holds {i + 1}: number {i + 1} is in the pile.",
               "ko": f"인덱스 {i}에 {i + 1}번이 있습니다. {i + 1}번 양말은 있습니다."},
              lit=[i], present=i + 1)
    i = None
    frame({"en": f"Every slot holds its own number, so 1 to {n} are all there: the answer is {n + 1}.",
           "ko": f"모든 칸에 제 번호가 있으니 1부터 {n}까지 다 있습니다. 답은 {n + 1}번입니다."},
          present=n, result=[n + 1], moves=[move(None, at("result", 0), value=n + 1)], answer=str(n + 1))


for number, sample in enumerate(sample_cases(SLUG), start=1):
    socks = json.loads(sample["input"])
    run = sample_run(wt, number, sample, input=f"socks = {driver_list(socks)}")
    solve(socks, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
