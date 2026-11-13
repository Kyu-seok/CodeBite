#!/usr/bin/env python3.12
"""group-anagrams' Walkthrough: the reference solution (scripts/replay-solutions/group-anagrams.py),
a hash map from each word's sorted letters to its group, recording one frame per word on each sample
Test Case.

    CODEBITE_DB=<database> scripts/walkthroughs/group-anagrams.py

writes common/src/main/resources/walkthroughs/group-anagrams.json.
"""
import json
import os
import sys
from collections import defaultdict

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import driver_list, plural, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough  # noqa: E402

SLUG = "group-anagrams"

wt = Walkthrough(
    {"en": "Group Anagrams", "ko": "그룹 애너그램"},
    {"en": "Anagrams have the same letters, so sorting a word's letters gives every anagram the same key: "
           "a hash map from key to group collects them in one pass.",
     "ko": "애너그램은 글자 구성이 같아서 글자를 정렬하면 모두 같은 키가 됩니다: 키에서 그룹으로 가는 해시 맵이 "
           "한 번 훑으며 그룹을 모읍니다."},
    views=[
        {"id": "words", "type": "table", "title": "strs"},
        {"id": "groups", "type": "table", "title": {"en": "groups: key → words", "ko": "groups: 키 → 단어"}},
    ],
)


def solve(strs, run):
    """Solution.groupAnagrams with a frame per word. Returns the answer as the Driver prints it."""
    groups = defaultdict(list)
    keys = {}  # index -> the key computed for that word, shown once the loop reaches it

    def frame(caption, lit=None, word_marks=None, group_marks=None, **answer):
        run.frame(caption,
                  words={"columns": [{"en": "word", "ko": "단어"}, {"en": "sorted letters", "ko": "정렬한 글자"}],
                         "rows": [{"label": str(i), "cells": [w, keys.get(i, "")]} for i, w in enumerate(strs)],
                         "marks": word_marks or {}},
                  groups={"rows": [{"label": k, "cells": list(g)} for k, g in groups.items()],
                          "marks": group_marks or {}},
                  **answer)

    frame({"en": f"Read the {len(strs)} {plural(len(strs), 'word', 'words')} in order, starting with an "
                 f"empty map of groups.",
           "ko": f"단어 {len(strs)}개를 차례로 읽습니다. 그룹 맵은 비어 있습니다."})
    for i, word in enumerate(strs):
        key = "".join(sorted(word))
        keys[i] = key
        new = key not in groups
        groups[key].append(word)
        row = list(groups).index(key)
        if new:
            caption = {"en": f'"{word}" sorted is "{key}". No group has that key yet, so start one.',
                       "ko": f'"{word}"의 글자를 정렬하면 "{key}"입니다. 이 키의 그룹이 아직 없으니 새로 만듭니다.'}
        else:
            others = ", ".join(f'"{w}"' for w in groups[key][:-1])
            caption = {"en": f'"{word}" sorted is "{key}", the same key as {others}, so it joins that group.',
                       "ko": f'"{word}"의 글자를 정렬하면 "{key}"입니다. {others}의 키와 같으므로 그 그룹에 들어갑니다.'}
        frame(caption, word_marks={"lit": [[i, 0]], "good": [[i, 1]]},
              group_marks={"good": [[row, len(groups[key]) - 1]]})
    result = [sorted(group) for group in groups.values()]
    result.sort()
    answer = driver_list(result)
    n = len(groups)
    frame({"en": f"Every word is in the group of its key: {n} {plural(n, 'group', 'groups')}. "
                 f"Printed with each group sorted and the groups in order: {answer}.",
           "ko": f"모든 단어가 자기 키의 그룹에 들어갔습니다: 그룹 {n}개. 그룹 안과 그룹끼리 정렬해 출력하면 {answer}입니다."},
          group_marks={"path": [[r, c] for r, g in enumerate(groups.values()) for c in range(len(g))]},
          answer=answer)


for number, sample in enumerate(sample_cases(SLUG), start=1):
    strs = json.loads(sample["input"])
    run = sample_run(wt, number, sample, input=f"strs = {driver_list(strs)}")
    solve(strs, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
