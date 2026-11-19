#!/usr/bin/env python3.12
"""longest-palindromic-substring's Walkthrough: the reference solution
(scripts/replay-solutions/longest-palindromic-substring.py), growing a palindrome outward from each of the 2n - 1
centres (each letter and each gap between two letters), recording one frame per letter pair compared on each sample
Test Case.

The pair compared is the pointers `left` and `right` on the string. A pair that matches widens the span between them,
the centre's palindrome so far. When the centre stops, on a pair that differs (marked bad) or at an end, its
palindrome's length is held against the longest so far, a span below the string that moves when beaten.

    CODEBITE_DB=<database> scripts/walkthroughs/longest-palindromic-substring.py

writes common/src/main/resources/walkthroughs/longest-palindromic-substring.json.
"""
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import josa, plural, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, span  # noqa: E402

SLUG = "longest-palindromic-substring"

wt = Walkthrough(
    {"en": "Longest Palindromic Substring", "ko": "가장 긴 회문 부분 문자열"},
    {"en": "Every palindrome has a centre, a letter or a gap between two letters. Grow outward from each centre "
           "while the two end letters match; where it stops is that centre's longest palindrome. Keep the longest.",
     "ko": "모든 회문에는 가운데가 있습니다: 글자 하나이거나 두 글자 사이입니다. 가운데마다 양 끝 글자가 같은 "
           "동안 바깥으로 넓히고, 멈춘 곳까지가 그 가운데의 가장 긴 회문입니다. 그중 가장 긴 것을 기억합니다."},
    views=[
        {"id": "s", "type": "array", "title": {"en": "s", "ko": "s (문자열)"}},
    ],
)


def q(text):
    return f"'{text}'"


def letters(k):
    return {"en": f"{k} {plural(k, 'letter', 'letters')}", "ko": f"{k}글자"}


def centre_text(centre):
    i = centre // 2
    if centre % 2 == 0:
        return {"en": f"Centre letter {i}", "ko": f"가운데 글자 {i}"}
    return {"en": f"Centre gap {i}|{i + 1}", "ko": f"가운데 {josa(i, '과와')} {i + 1} 사이"}


def solve(s, run):
    """Solution.longestPalindrome with a frame per pair compared. Returns the answer as the Driver prints it."""
    n = len(s)
    chars = list(s)
    longest = 0
    best = None  # (from, to) of the longest so far

    def frame(caption, left=None, right=None, grown=None, marks=None, best_mark=None, **answer):
        spans = {}
        if grown:
            spans["grown"] = span(grown[0], grown[1], letters(grown[1] - grown[0] + 1), mark="good")
        if best:
            spans["longest"] = span(best[0], best[1],
                                    {"en": f"longest {longest}", "ko": f"longest (최장) {longest}"},
                                    mark=best_mark, below=True)
        run.frame(caption, s={"values": chars, "pointers": {"left": left, "right": right}, "spans": spans,
                              "marks": marks or {}}, **answer)

    frame({"en": f"{n} {plural(n, 'letter', 'letters')}, so {2 * n - 1} {plural(2 * n - 1, 'centre', 'centres')}: "
                 f"{n} {plural(n, 'letter', 'letters')} and {n - 1} {plural(n - 1, 'gap', 'gaps')}. The longest "
                 "palindrome so far has length 0.",
           "ko": f"글자가 {n}개이므로 가운데는 {2 * n - 1}곳입니다: 글자 {n}개와 사이 {n - 1}곳. 지금까지 가장 긴 "
                 "회문의 길이는 0입니다."})
    for centre in range(2 * n - 1):
        where = centre_text(centre)
        left, right = centre // 2, (centre + 1) // 2
        while left >= 0 and right < n and s[left] == s[right]:
            sub = s[left:right + 1]
            off_end = left - 1 < 0 or right + 1 >= n
            if left == right:
                en = f"{where['en']}: {q(sub)} alone is a palindrome."
                ko = f"{where['ko']}: 한 글자 {q(sub)}도 회문입니다."
            else:
                en = f"{where['en']}: letters {left} and {right} are both {q(s[left])}, so {q(sub)} is a palindrome."
                ko = (f"{where['ko']}: 글자 {josa(left, '과와')} {right}의 글자가 같으므로({q(s[left])}) "
                      f"{q(sub)} 부분은 회문입니다.")
            best_mark = None
            if off_end:  # the loop ends here, and the length is compared at once
                length = right - left + 1
                if length > longest:
                    longest, best, best_mark = length, (left, right), "good"
                    en += f" It can't grow past the end, and {length} beats the longest so far."
                    ko += f" 끝을 넘어 넓힐 수 없고, {josa(length, '은는')} 지금까지의 최장보다 깁니다."
                else:
                    en += f" It can't grow past the end, and {length} doesn't beat the longest, {longest}."
                    ko += f" 끝을 넘어 넓힐 수 없고, {josa(length, '은는')} 최장 {longest}보다 길지 않습니다."
            frame({"en": en, "ko": ko}, left=left, right=right, grown=(left, right), marks={"lit": [left, right]},
                  best_mark=best_mark)
            left -= 1
            right += 1
        if left >= 0 and right < n:  # stopped on a pair that differs
            length = right - left - 1
            grown = (left + 1, right - 1) if length else None
            best_mark = None
            if length == 0:
                en_end, ko_end = "so there is no palindrome here.", "여기서는 회문이 없습니다."
            elif length > longest:
                longest, best, best_mark = length, grown, "good"
                en_end = f"so this centre stops at {q(s[left + 1:right])}, and {length} beats the longest so far."
                ko_end = (f"이 가운데는 {q(s[left + 1:right])} 부분에서 멈추고, {josa(length, '은는')} 지금까지의 "
                          "최장보다 깁니다.")
            else:
                en_end = (f"so this centre stops at {q(s[left + 1:right])}, and {length} doesn't beat the longest, "
                          f"{longest}.")
                ko_end = (f"이 가운데는 {q(s[left + 1:right])} 부분에서 멈추고, {josa(length, '은는')} 최장 "
                          f"{longest}보다 길지 않습니다.")
            frame({"en": f"{where['en']}: letter {left} is {q(s[left])} but letter {right} is {q(s[right])}, "
                         f"{en_end}",
                   "ko": f"{where['ko']}: 글자 {left}의 {q(s[left])}, 글자 {right}의 {q(s[right])}. 서로 다르므로 "
                         f"{ko_end}"},
                  left=left, right=right, grown=grown, marks={"bad": [left, right]}, best_mark=best_mark)
    frame({"en": f"Every centre is done: the longest palindrome is {q(s[best[0]:best[1] + 1])}, "
                 f"{longest} {plural(longest, 'letter', 'letters')}. Answer: {longest}.",
           "ko": f"모든 가운데를 마쳤습니다. 가장 긴 회문은 {q(s[best[0]:best[1] + 1])} 부분으로 {longest}글자이고, "
                 f"답은 {longest}입니다."},
          marks={"path": list(range(best[0], best[1] + 1)),
                 "dim": [i for i in range(n) if not best[0] <= i <= best[1]]},
          best_mark="path", answer=str(longest))


for number, sample in enumerate(sample_cases(SLUG), start=1):
    s = sample["input"].strip()
    run = sample_run(wt, number, sample, input=f"s = \"{s}\"")
    solve(s, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
