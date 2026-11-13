#!/usr/bin/env python3.12
"""valid-anagram's Walkthrough: the reference solution (scripts/replay-solutions/valid-anagram.py),
Counter(s) == Counter(t), with the two counts built a letter at a time as Counter builds them, one frame
per letter, then one frame comparing them, on each sample Test Case.

    CODEBITE_DB=<database> scripts/walkthroughs/valid-anagram.py

writes common/src/main/resources/walkthroughs/valid-anagram.json.
"""
import os
import sys
from collections import Counter

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough  # noqa: E402

SLUG = "valid-anagram"

wt = Walkthrough(
    {"en": "Valid Anagram", "ko": "애너그램 확인"},
    {"en": "Count each letter in both strings: t is an anagram of s exactly when every letter's two counts match.",
     "ko": "두 문자열의 글자를 각각 셉니다: 모든 글자의 두 개수가 같을 때만 t가 s의 애너그램입니다."},
    views=[
        {"id": "s", "type": "array", "title": "s"},
        {"id": "t", "type": "array", "title": "t"},
        {"id": "counts", "type": "table", "title": {"en": "letter counts", "ko": "글자별 개수"}},
    ],
)


def solve(s, t, run):
    """Solution.isAnagram, counting letter by letter. Returns the answer as the Driver prints it."""
    letters = sorted(set(s) | set(t))  # one column per letter either string has
    count_s, count_t = Counter(), Counter()
    i = j = None

    def frame(caption, s_marks=None, t_marks=None, count_marks=None, **answer):
        run.frame(caption,
                  s={"values": list(s), "pointers": {"i": i}, "marks": s_marks or {}},
                  t={"values": list(t), "pointers": {"j": j}, "marks": t_marks or {}},
                  counts={"columns": letters,
                          "rows": [{"label": {"en": "in s", "ko": "s 안"}, "cells": [count_s[c] for c in letters]},
                                   {"label": {"en": "in t", "ko": "t 안"}, "cells": [count_t[c] for c in letters]}],
                          "marks": count_marks or {}},
                  **answer)

    frame({"en": "Count how many times each letter appears in s, then in t. Every count starts at 0.",
           "ko": "s에서 각 글자가 몇 번 나오는지 세고, 이어서 t에서도 셉니다. 모든 개수는 0에서 시작합니다."},
          s_marks={"dim": list(range(len(s)))}, t_marks={"dim": list(range(len(t)))})
    for i, c in enumerate(s):
        count_s[c] += 1
        frame({"en": f"s[{i}] is '{c}': s now has {count_s[c]} × '{c}'.",
               "ko": f"s[{i}] = '{c}': s의 '{c}' 개수는 이제 {count_s[c]}개입니다."},
              s_marks={"lit": [i], "dim": list(range(i + 1, len(s)))}, t_marks={"dim": list(range(len(t)))},
              count_marks={"good": [[0, letters.index(c)]]})
    i = None
    for j, c in enumerate(t):
        count_t[c] += 1
        frame({"en": f"t[{j}] is '{c}': t now has {count_t[c]} × '{c}'.",
               "ko": f"t[{j}] = '{c}': t의 '{c}' 개수는 이제 {count_t[c]}개입니다."},
              t_marks={"lit": [j], "dim": list(range(j + 1, len(t)))},
              count_marks={"good": [[1, letters.index(c)]]})
    j = None
    result = count_s == count_t
    answer = str(result).lower()
    if result:
        frame({"en": f"Every letter's count is the same in s and t ({len(letters)} letters checked), "
                     f"so t is an anagram of s. Answer true.",
               "ko": f"모든 글자({len(letters)}종류)의 개수가 s와 t에서 같으므로 t는 s의 애너그램입니다. 답은 true입니다."},
              count_marks={"path": [[r, k] for r in (0, 1) for k in range(len(letters))]}, answer=answer)
    else:
        differ = [c for c in letters if count_s[c] != count_t[c]]
        en = ", ".join(f"'{c}' {count_s[c]} vs {count_t[c]}" for c in differ)
        ko = ", ".join(f"'{c}' {count_s[c]}개 대 {count_t[c]}개" for c in differ)
        frame({"en": f"The counts differ: {en}. So t is not an anagram of s. Answer false.",
               "ko": f"개수가 다른 글자가 있습니다: {ko}. 그러므로 t는 s의 애너그램이 아닙니다. 답은 false입니다."},
              s_marks={"bad": [k for k, c in enumerate(s) if c in differ]},
              t_marks={"bad": [k for k, c in enumerate(t) if c in differ]},
              count_marks={"bad": [[r, letters.index(c)] for r in (0, 1) for c in differ]}, answer=answer)


for number, sample in enumerate(sample_cases(SLUG), start=1):
    s, t = (line.strip() for line in sample["input"].split("\n")[:2])
    run = sample_run(wt, number, sample, input=f's = "{s}", t = "{t}"')
    solve(s, t, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
