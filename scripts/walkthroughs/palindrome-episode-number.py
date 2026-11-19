#!/usr/bin/env python3.12
"""palindrome-episode-number's Walkthrough: the reference solution
(scripts/replay-solutions/palindrome-episode-number.py), text == text[::-1], recording a frame for the reversed copy
(every character moving to its mirror place, as the one slice does) and one per position == compares until the first
difference, on each sample Test Case.

    CODEBITE_DB=<database> scripts/walkthroughs/palindrome-episode-number.py

writes common/src/main/resources/walkthroughs/palindrome-episode-number.json.
"""
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move  # noqa: E402

SLUG = "palindrome-episode-number"

wt = Walkthrough(
    {"en": "Palindrome Episode Number", "ko": "회문 에피소드 번호"},
    {"en": "Write the number as text, reverse it, and compare the two position by position: a palindrome reads the "
           "same both ways.",
     "ko": "수를 문자열로 쓰고 뒤집은 다음, 두 문자열을 자리마다 비교합니다. 회문은 어느 쪽에서 읽어도 같습니다."},
    views=[
        {"id": "text", "type": "array", "title": {"en": "text = str(episode)", "ko": "text = str(episode)"}},
        {"id": "rev", "type": "array", "title": "text[::-1]"},
    ],
)


def solve(episode, run):
    """Solution.isPalindrome with a frame for the reverse and per position compared. Returns the answer."""
    text = str(episode)
    n = len(text)
    rev = None
    k = None

    def frame(caption, lit=(), good=(), bad=(), path=False, moves=None, **answer):
        views = {"text": {"values": list(text), "pointers": {"k": k},
                          "marks": {"path": list(range(n))} if path else {"lit": list(lit), "bad": list(bad)}}}
        if rev is not None:
            views["rev"] = {"values": list(rev), "pointers": {"k": k},
                            "marks": {"path": list(range(n))} if path else
                            {"good": list(good), "lit": list(lit), "bad": list(bad)}}
        run.frame(caption, moves=moves, **views, **answer)

    frame({"en": f"episode = {episode} as text: {n} character{'s' if n > 1 else ''}, \"{text}\".",
           "ko": f"episode = {episode}: 문자열로 쓰면 {n}글자짜리 \"{text}\"입니다."})
    rev = text[::-1]
    frame({"en": f"text[::-1] copies each character to its mirror place: \"{rev}\".",
           "ko": f"text[::-1] 슬라이스는 각 글자를 거울 위치로 옮겨 적습니다: \"{rev}\"."},
          good=range(n), moves=[move(at("text", j), at("rev", n - 1 - j)) for j in range(n)])
    for k in range(n):
        a, b = text[k], rev[k]
        if a != b:
            frame({"en": f"Position {k}: '{a}' and '{b}' differ, so the text does not read the same backwards.",
                   "ko": f"{k}번 자리: text는 '{a}', 뒤집은 쪽은 '{b}'. 서로 다르니 거꾸로 읽으면 같지 않습니다."},
                  bad=[k])
            first, k = k, None
            frame({"en": f"\"{text}\" != \"{rev}\", so {episode} is not a palindrome: answer false.",
                   "ko": f"\"{text}\" != \"{rev}\", 곧 {episode}번은 회문이 아닙니다. 답은 false입니다."},
                  bad=[first], answer="false")
            return "false"
        frame({"en": f"Position {k}: '{a}' and '{b}' match.",
               "ko": f"{k}번 자리: 양쪽 모두 '{a}', 같습니다."},
              lit=[k])
    k = None
    frame({"en": f"Every position matches, so \"{text}\" reads the same backwards: answer true.",
           "ko": f"모든 자리가 같으므로 \"{text}\" 문자열은 거꾸로 읽어도 같습니다. 답은 true입니다."},
          path=True, answer="true")
    return "true"


for number, sample in enumerate(sample_cases(SLUG), start=1):
    episode = int(sample["input"].strip())
    solve(episode, sample_run(wt, number, sample, input=f"episode = {episode}"))
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
