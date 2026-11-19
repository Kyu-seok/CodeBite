#!/usr/bin/env python3.12
"""valid-slogan-palindrome's Walkthrough: the reference solution
(scripts/replay-solutions/valid-slogan-palindrome.py), two pointers walking in from both ends of the phrase,
recording one frame per character skipped and one per pair compared on each sample Test Case. What is left
to check is a span between the pointers, fading the characters already settled; a matching pair is tagged
with the letter both read as, and a mismatch ends the run.

    CODEBITE_DB=<database> scripts/walkthroughs/valid-slogan-palindrome.py

writes common/src/main/resources/walkthroughs/valid-slogan-palindrome.json.
"""
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import plural, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, span  # noqa: E402

SLUG = "valid-slogan-palindrome"
SPACE = "␣"

wt = Walkthrough(
    {"en": "Valid Slogan Palindrome", "ko": "슬로건 회문 검사"},
    {"en": "Two pointers walk in from both ends, stepping over anything that isn't a letter or a digit; "
           "the phrase is a palindrome when every pair they stop on is the same character once lowercased.",
     "ko": "두 포인터가 양 끝에서 안쪽으로 오며 알파벳이나 숫자가 아닌 문자는 건너뜁니다. 멈춰 선 쌍마다 "
           "소문자로 바꾼 글자가 모두 같으면 회문입니다."},
    views=[
        {"id": "phrase", "type": "array", "title": {"en": "phrase (␣ is a space)", "ko": "phrase (␣는 공백)"}},
    ],
)


def shown(ch):
    return SPACE if ch == " " else ch


def named(ch):
    """A character as a caption names it."""
    return {"en": "a space", "ko": "공백"} if ch == " " else {"en": f"'{ch}'", "ko": f"'{ch}'"}


def solve(phrase, run):
    """Solution.isPalindrome with a frame per step. Returns the answer as the Driver prints it."""
    n = len(phrase)
    cells = [shown(ch) for ch in phrase]
    left, right = 0, n - 1
    matched, skipped, tags = [], [], []

    def frame(caption, lit=(), bad=(), done=False, result=None, **answer):
        spans = {}
        if not done and left <= right:
            rest = right - left + 1
            spans["check"] = span(left, right, {"en": f"to check {rest}", "ko": f"남은 {rest}칸"}, fade=True)
        marks = {"dim": list(skipped), "lit": list(lit), "bad": list(bad)}
        if done and result:
            marks = {"dim": list(skipped), "path": list(matched)}
        run.frame(caption,
                  phrase={"values": cells, "spans": spans, "tags": list(tags),
                          "pointers": {} if done and result else
                          {"left": left, "right": right if right != left else None},
                          "marks": marks},
                  **answer)

    frame({"en": f"The phrase has {n} {plural(n, 'character', 'characters')}. left starts at 0 and right at {n - 1}; "
                 f"each stops only on a letter or a digit.",
           "ko": f"phrase는 문자 {n}개입니다. left는 0, right는 {n - 1}에서 시작하며, 알파벳이나 숫자에서만 멈춥니다."})
    while left < right:
        a, b = phrase[left], phrase[right]
        if not a.isalnum():
            skipped.append(left)
            left += 1
            what = named(a)
            frame({"en": f"phrase[{left - 1}] is {what['en']}, not a letter or a digit: left skips it and moves to {left}.",
                   "ko": f"phrase[{left - 1}]의 {what['ko']} 문자는 알파벳도 숫자도 아니어서, left가 건너뛰어 "
                         f"{left}번으로 갑니다."},
                  lit=[left - 1])
        elif not b.isalnum():
            skipped.append(right)
            right -= 1
            what = named(b)
            frame({"en": f"phrase[{right + 1}] is {what['en']}, not a letter or a digit: right skips it and moves to {right}.",
                   "ko": f"phrase[{right + 1}]의 {what['ko']} 문자는 알파벳도 숫자도 아니어서, right가 건너뛰어 "
                         f"{right}번으로 갑니다."},
                  lit=[right + 1])
        elif a.lower() != b.lower():
            frame({"en": f"phrase[{left}] = '{a}' and phrase[{right}] = '{b}' differ even lowercased, so the phrase "
                         f"is not a palindrome. Answer false.",
                   "ko": f"phrase[{left}] = '{a}', phrase[{right}] = '{b}': 소문자로 바꿔도 다른 글자라 회문이 아닙니다. "
                         f"답은 false입니다."},
                  bad=[left, right], done=True, result=False, answer="false")
            return
        else:
            low = a.lower()
            same = "the same character" if a == b else "the same letter once lowercased"
            same_ko = "같은 글자" if a == b else "소문자로 바꾸면 같은 글자"
            tags += [[left, low], [right, low]]
            matched += [left, right]
            left += 1
            right -= 1
            frame({"en": f"phrase[{left - 1}] = '{a}' and phrase[{right + 1}] = '{b}' are {same}: the pair matches, "
                         f"and both pointers step inward.",
                   "ko": f"phrase[{left - 1}] = '{a}', phrase[{right + 1}] = '{b}': {same_ko}라 짝이 맞고, "
                         f"두 포인터가 한 칸씩 안으로 옵니다."},
                  lit=[left - 1, right + 1])
    pairs = len(matched) // 2
    if pairs:
        en = (f"left and right met with every pair matching ({pairs} {plural(pairs, 'pair', 'pairs')}), "
              f"so the phrase reads the same both ways. Answer true.")
        ko = f"left와 right가 만날 때까지 {pairs}쌍이 모두 맞아, 앞뒤로 똑같이 읽힙니다. 답은 true입니다."
    else:
        en = "left and right met without stopping on a single letter or digit: the cleaned phrase is empty, and an empty string is a palindrome. Answer true."
        ko = "left와 right가 알파벳이나 숫자에 한 번도 멈추지 않고 만났습니다. 정리하면 빈 문자열이고, 빈 문자열은 회문이라 답은 true입니다."
    frame({"en": en, "ko": ko}, done=True, result=True, answer="true")


for number, sample in enumerate(sample_cases(SLUG), start=1):
    phrase = sample["input"].strip()
    run = sample_run(wt, number, sample, input=f'phrase = "{phrase}"')
    solve(phrase, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
