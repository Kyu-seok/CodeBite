#!/usr/bin/env python3.12
"""valid-anagram's Walkthrough: the reference solution (scripts/replay-solutions/valid-anagram.py),
Counter(s) == Counter(t), with the two counts built a letter at a time as Counter builds them: each letter
moves into its card in its string's map, one frame per letter, then one frame comparing the two maps, on each
sample Test Case.

    CODEBITE_DB=<database> scripts/walkthroughs/valid-anagram.py

writes common/src/main/resources/walkthroughs/valid-anagram.json.
"""
import os
import sys
from collections import Counter

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, map_entries, move  # noqa: E402

SLUG = "valid-anagram"

wt = Walkthrough(
    {"en": "Valid Anagram", "ko": "애너그램 확인"},
    {"en": "Count each letter in both strings: t is an anagram of s exactly when every letter's two counts match.",
     "ko": "두 문자열의 글자를 각각 셉니다: 모든 글자의 두 개수가 같을 때만 t가 s의 애너그램입니다."},
    views=[
        {"id": "s", "type": "array", "title": "s"},
        {"id": "t", "type": "array", "title": "t"},
        {"id": "count_s", "type": "map", "title": {"en": "letters in s", "ko": "s의 글자별 개수"},
         "empty": {"en": "empty", "ko": "비어 있음"}},
        {"id": "count_t", "type": "map", "title": {"en": "letters in t", "ko": "t의 글자별 개수"},
         "empty": {"en": "empty", "ko": "비어 있음"}},
    ],
)


def solve(s, t, run):
    """Solution.isAnagram, counting letter by letter. Returns the answer as the Driver prints it."""
    count_s, count_t = Counter(), Counter()
    i = j = None

    def frame(caption, s_marks=None, t_marks=None, s_count_marks=None, t_count_marks=None, moves=None, **answer):
        run.frame(caption,
                  s={"values": list(s), "pointers": {"i": i}, "marks": s_marks or {},
                     "unread": list(range(sum(count_s.values()), len(s)))},
                  count_s={"entries": map_entries(count_s), "marks": s_count_marks or {}},
                  t={"values": list(t), "pointers": {"j": j}, "marks": t_marks or {},
                     "unread": list(range(sum(count_t.values()), len(t)))},
                  count_t={"entries": map_entries(count_t), "marks": t_count_marks or {}},
                  moves=moves, **answer)

    frame({"en": "Count how many times each letter appears in s, then in t, each in its own map. Both maps start empty.",
           "ko": "s에서 각 글자가 몇 번 나오는지 세고, 이어서 t에서도 셉니다. 두 맵 모두 비어 있는 채로 시작합니다."})
    for i, c in enumerate(s):
        count_s[c] += 1
        frame({"en": f"s[{i}] is '{c}': it goes into the s map, which now has {count_s[c]} × '{c}'.",
               "ko": f"s[{i}] = '{c}': s의 맵에 넣으면 '{c}' 개수는 이제 {count_s[c]}개입니다."},
              s_marks={"lit": [i]}, s_count_marks={"good": [c]}, moves=[move(at("s", i), at("count_s", c))])
    i = None
    for j, c in enumerate(t):
        count_t[c] += 1
        frame({"en": f"t[{j}] is '{c}': it goes into the t map, which now has {count_t[c]} × '{c}'.",
               "ko": f"t[{j}] = '{c}': t의 맵에 넣으면 '{c}' 개수는 이제 {count_t[c]}개입니다."},
              t_marks={"lit": [j]}, t_count_marks={"good": [c]}, moves=[move(at("t", j), at("count_t", c))])
    j = None
    result = count_s == count_t
    answer = str(result).lower()
    letters = set(count_s) | set(count_t)
    if result:
        frame({"en": f"Both maps hold the same {len(letters)} letters with the same counts, "
                     f"so t is an anagram of s. Answer true.",
               "ko": f"두 맵에 같은 글자 {len(letters)}종류가 같은 개수로 들어 있으므로 t는 s의 애너그램입니다. 답은 true입니다."},
              s_count_marks={"path": list(count_s)}, t_count_marks={"path": list(count_t)}, answer=answer)
    else:
        differ = sorted(c for c in letters if count_s[c] != count_t[c])
        en = ", ".join(f"'{c}' {count_s[c]} vs {count_t[c]}" for c in differ)
        ko = ", ".join(f"'{c}' {count_s[c]}개 대 {count_t[c]}개" for c in differ)
        # no path: a false answer is made of no letters, so only what rules t out is marked
        frame({"en": f"The maps differ ({en}), so t is not an anagram of s: answer false. "
                     f"The letters whose counts differ are marked red.",
               "ko": f"두 맵이 다릅니다({ko}). 그래서 t는 s의 애너그램이 아니고 답은 false이며, 개수가 다른 글자를 빨간색으로 표시했습니다."},
              s_marks={"bad": [k for k, c in enumerate(s) if c in differ]},
              t_marks={"bad": [k for k, c in enumerate(t) if c in differ]},
              s_count_marks={"bad": [c for c in differ if c in count_s], "dim": [c for c in count_s if c not in differ]},
              t_count_marks={"bad": [c for c in differ if c in count_t], "dim": [c for c in count_t if c not in differ]},
              answer=answer)

for number, sample in enumerate(sample_cases(SLUG), start=1):
    s, t = (line.strip() for line in sample["input"].split("\n")[:2])
    run = sample_run(wt, number, sample, input=f's = "{s}", t = "{t}"')
    solve(s, t, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
