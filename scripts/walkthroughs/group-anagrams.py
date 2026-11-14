#!/usr/bin/env python3.12
"""group-anagrams' Walkthrough: the reference solution (scripts/replay-solutions/group-anagrams.py),
a hash map from each word's sorted letters to its group. Each word's sorted letters move into its row's second
cell and the word moves from its row into that key's card, as a chip in the group, one frame per word; then each group, sorted as the Driver prints it, moves into the answer, on
each sample Test Case.

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
from walkthrough_trace import Walkthrough, at, move  # noqa: E402

SLUG = "group-anagrams"

wt = Walkthrough(
    {"en": "Group Anagrams", "ko": "그룹 애너그램"},
    {"en": "Anagrams have the same letters, so sorting a word's letters gives every anagram the same key: "
           "a hash map from key to group collects them in one pass.",
     "ko": "애너그램은 글자 구성이 같아서 글자를 정렬하면 모두 같은 키가 됩니다: 키에서 그룹으로 가는 해시 맵이 "
           "한 번 훑으며 그룹을 모읍니다."},
    views=[
        {"id": "words", "type": "table", "title": "strs"},
        {"id": "groups", "type": "map", "title": {"en": "groups: key → words", "ko": "groups: 키 → 단어"},
         "empty": {"en": "empty", "ko": "비어 있음"}},
        {"id": "result", "type": "output", "title": {"en": "answer", "ko": "답"}, "empty": {"en": "empty", "ko": "비어 있음"}},
    ],
)


def solve(strs, run):
    """Solution.groupAnagrams with a frame per word and per group printed. Returns the answer as the Driver prints it."""
    groups = defaultdict(list)
    keys = {}  # index -> the key computed for that word, shown once the loop reaches it
    result = []

    def frame(caption, word_marks=None, group_marks=None, moves=None, **answer):
        run.frame(caption,
                  words={"columns": [{"en": "word", "ko": "단어"}, {"en": "sorted letters", "ko": "정렬한 글자"}],
                         "rows": [{"label": str(i), "cells": [w, keys.get(i, "")]} for i, w in enumerate(strs)],
                         "marks": word_marks or {}},
                  groups={"entries": [{"key": k, "value": list(g)} for k, g in groups.items()],
                          "marks": group_marks or {}},
                  result={"values": list(result)},
                  moves=moves, **answer)

    span = (f"\"{strs[0]}\"" if len(strs) == 1 else f"from \"{strs[0]}\" to \"{strs[-1]}\"",
            f"\"{strs[0]}\"" if len(strs) == 1 else f"\"{strs[0]}\"부터 \"{strs[-1]}\"까지")
    frame({"en": f"Read the {len(strs)} {plural(len(strs), 'word', 'words')}{'' if len(strs) == 1 else ' in order'}, {span[0]}, starting with an "
                 f"empty map of groups.",
           "ko": f"단어 {len(strs)}개({span[1]})를 {'' if len(strs) == 1 else '차례로 '}읽습니다. 그룹 맵은 처음에 비어 있습니다."},
          word_marks={"dim": [[i, c] for i in range(len(strs)) for c in (0, 1)]})
    for i, word in enumerate(strs):
        key = "".join(sorted(word))
        keys[i] = key
        new = key not in groups
        groups[key].append(word)
        if new:
            caption = {"en": f'"{word}" sorted is "{key}". No group has that key yet, so it starts one.',
                       "ko": f'"{word}"의 글자를 정렬하면 "{key}"입니다. 이 키의 그룹이 아직 없으니 새로 만듭니다.'}
        else:
            others = ", ".join(f'"{w}"' for w in groups[key][:-1])
            caption = {"en": f'"{word}" sorted is "{key}", the same key as {others}, so it joins that group.',
                       "ko": f'"{word}"의 글자를 정렬하면 "{key}"입니다. {others}의 키와 같으므로 그 그룹에 들어갑니다.'}
        frame(caption, word_marks={"lit": [[i, 0]], "good": [[i, 1]],
                                   "dim": [[r, c] for r in range(i + 1, len(strs)) for c in (0, 1)]},
              group_marks={"good": [key]},
              moves=[move(at("words", [i, 0]), at("words", [i, 1]), value=key),
                     move(at("words", [i, 0]), at("groups", key), value=word)])
    printed = sorted((sorted(g), k) for k, g in groups.items())  # each group sorted, then the groups in order
    answer = driver_list([g for g, _ in printed])
    n = len(groups)
    for j, (group, key) in enumerate(printed):
        result.append(driver_list(group))
        last = j == n - 1
        if not last:
            caption = {"en": f"Every word is in its key's group. Printed with each group sorted and the groups in order, "
                             f"group {j + 1} of {n} is {driver_list(group)}." if j == 0 else
                             f"Group {j + 1} of {n} is {driver_list(group)}.",
                       "ko": f"모든 단어가 자기 키의 그룹에 들어갔습니다. 그룹 안과 그룹끼리 정렬해 출력하면 "
                             f"{n}개 중 {j + 1}번째 그룹은 {driver_list(group)}입니다." if j == 0 else
                             f"{n}개 중 {j + 1}번째 그룹은 {driver_list(group)}입니다."}
        elif n == 1:
            caption = {"en": f"Every word is in the group of its key: 1 group, {driver_list(group)}. The answer is {answer}.",
                       "ko": f"모든 단어가 자기 키의 그룹에 들어갔습니다: 그룹 1개, {driver_list(group)}. 답은 {answer}입니다."}
        else:
            caption = {"en": f"Group {n} of {n} is {driver_list(group)}, the last: the answer is {answer}.",
                       "ko": f"마지막 그룹 {driver_list(group)}까지 넣으면 답은 {answer}입니다."}
        frame(caption, group_marks={"path": [k for _, k in printed[:j + 1]], "dim": [k for _, k in printed[j + 1:]]},
              moves=[move(at("groups", key), at("result", j), value=driver_list(group))],
              **({"answer": answer} if last else {}))

for number, sample in enumerate(sample_cases(SLUG), start=1):
    strs = json.loads(sample["input"])
    run = sample_run(wt, number, sample, input=f"strs = {driver_list(strs)}")
    solve(strs, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
