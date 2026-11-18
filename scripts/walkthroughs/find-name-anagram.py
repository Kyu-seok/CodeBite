#!/usr/bin/env python3.12
"""find-name-anagram's Walkthrough: the reference solution
(scripts/replay-solutions/find-name-anagram.py), a window of pattern's length sliding over log with a
count of its letters, recording one frame per letter added and one per letter dropped on each sample
Test Case. The window is a span on log; each letter added moves into its card in the window's count map,
each letter dropped moves back out, and after each slide the two maps are compared, a key that differs
marked on both.

    CODEBITE_DB=<database> scripts/walkthroughs/find-name-anagram.py

writes common/src/main/resources/walkthroughs/find-name-anagram.json.
"""
import os
import sys
from collections import Counter

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import josa, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, map_entries, move, span  # noqa: E402

SLUG = "find-name-anagram"

wt = Walkthrough(
    {"en": "Find Name Anagram", "ko": "애너그램 부분 문자열"},
    {"en": "A window exactly as long as pattern slides over log, one letter in on the right and one out on the left; "
           "it is a reordering of pattern exactly when its letter counts equal pattern's.",
     "ko": "pattern과 길이가 같은 창을 log 위로 밀며, 오른쪽에서 한 글자를 넣고 왼쪽에서 한 글자를 뺍니다. "
           "창의 글자 수가 pattern의 글자 수와 같을 때가 바로 pattern을 재배열한 부분 문자열입니다."},
    views=[
        {"id": "pattern", "type": "array", "title": {"en": "pattern", "ko": "pattern (이름)"}},
        {"id": "log", "type": "array", "title": {"en": "log", "ko": "log (메모)"}},
        {"id": "need", "type": "map", "title": {"en": "need (pattern's counts)", "ko": "need (pattern의 글자 수)"}},
        {"id": "window", "type": "map", "title": {"en": "window's counts", "ko": "창의 글자 수"},
         "empty": {"en": "empty", "ko": "비어 있음"}},
    ],
)


def quoted(s):
    return f'"{s}"'


def solve(pattern, log, run):
    """Solution.containsNameAnagram with a frame per letter in or out. Returns the answer as the Driver prints it."""
    size, n = len(pattern), len(log)
    need = Counter(pattern)
    window = {}  # the window's counts in insertion order; a key reaching 0 is dropped after its frame
    lo, hi = 0, -1  # the window is log[lo..hi]

    def differing():
        return sorted({k for k in set(need) | set(window) if need.get(k, 0) != window.get(k, 0)})

    def frame(caption, log_lit=(), window_mark=None, struck=(), good_key=None, compare=False, found=False,
              moves=None, done=False, **answer):
        bad = differing() if compare else []
        length = hi - lo + 1
        win = span(lo, hi, {"en": f"window {length}", "ko": f"창 {length}"},
                   mark="path" if found else window_mark, fade=True) if length > 0 else None
        run.frame(caption,
                  pattern={"values": list(pattern)},
                  log={"values": list(log), "spans": {"window": win},
                       "pointers": {} if done else {"left": lo if length > 0 else None, "right": hi if hi >= 0 else None},
                       "unread": list(range(hi + 1, n)),
                       "marks": {"lit": list(log_lit), "path": list(range(lo, hi + 1)) if found else []}},
                  need={"entries": map_entries(need),
                        "marks": {"path": list(need)} if found else {"bad": [k for k in bad if k in need]}},
                  window={"entries": map_entries(window), "struck": list(struck),
                          "marks": {"path": list(window)} if found else
                          {"bad": [k for k in bad if k in window], "good": [good_key] if good_key and good_key not in bad else []}},
                  moves=moves, **answer)

    def verdict(en_prefix, ko_prefix):
        """The comparison after a step, as the end of its caption."""
        text = quoted(log[lo:hi + 1])
        if window_equal():
            return (f"{en_prefix}the window {text} has the same counts as need: a match.",
                    f"{ko_prefix}창 {text}의 글자 수가 pattern과 같습니다: 찾았습니다.")
        keys = ", ".join(f"'{k}'" for k in differing())
        return (f"{en_prefix}the window {text} differs from need at {keys}.",
                f"{ko_prefix}창 {text}의 글자 수가 need와 다른 글자: {keys}.")

    def window_equal():
        return Counter({k: v for k, v in window.items() if v}) == need

    frame({"en": f"pattern {quoted(pattern)} has {size} letters, so every window over log {quoted(log)} is {size} long; "
                 f"need holds pattern's letter counts.",
           "ko": f"pattern {quoted(pattern)}의 길이가 {size}글자이므로 log {quoted(log)} 위의 창은 모두 {size}글자입니다. "
                 f"need에는 pattern의 글자 수를 셉니다."},
          moves=[move(at("pattern", j), at("need", ch)) for j, ch in enumerate(pattern)])
    if size > n:
        frame({"en": f"log is shorter than pattern ({n} < {size}), so no window fits: false.",
               "ko": f"log가 pattern보다 짧아({n} < {size}) 창이 들어갈 수 없습니다: false."},
              done=True, answer="false")
        return
    for j in range(size):
        ch = log[j]
        window[ch] = window.get(ch, 0) + 1
        hi = j
        if j < size - 1:
            frame({"en": f"Fill the first window: log[{j}] = '{ch}' goes into its card.",
                   "ko": f"첫 창을 채웁니다: log[{j}] = '{ch}' 글자를 그 카드에 넣습니다."},
                  good_key=ch, moves=[move(at("log", j), at("window", ch))])
        else:
            en, ko = verdict("", "")
            frame({"en": f"log[{j}] = '{ch}' goes in, completing the first window. Compare: {en}",
                   "ko": f"log[{j}] = '{ch}' 글자를 넣어 첫 창이 찼습니다. 비교: {ko}"},
                  good_key=ch, compare=True, moves=[move(at("log", j), at("window", ch))])
    if window_equal():
        frame({"en": f"The first window {quoted(log[lo:hi + 1])} is already a reordering of {quoted(pattern)}: true.",
               "ko": f"첫 창 {quoted(log[lo:hi + 1])}부터 pattern {quoted(pattern)}의 재배열입니다: true."},
              found=True, done=True, answer="true")
        return
    for i in range(size, n):
        ch = log[i]
        window[ch] = window.get(ch, 0) + 1
        hi = i
        frame({"en": f"Slide right: log[{i}] = '{ch}' comes in, so the window is {size + 1} long, one too many.",
               "ko": f"오른쪽으로 밉니다: log[{i}] = '{ch}' 글자가 들어와 창이 {size + 1}글자로 하나 넘칩니다."},
              window_mark="bad", good_key=ch, moves=[move(at("log", i), at("window", ch))])
        out = log[i - size]
        window[out] -= 1
        lo = i - size + 1
        gone = window[out] == 0
        en, ko = verdict("", "")
        frame({"en": f"log[{i - size}] = '{out}' leaves on the left. {en}",
               "ko": f"왼쪽의 log[{i - size}] = '{out}' 글자가 빠집니다. {ko}"},
              log_lit=[i - size], struck=[out] if gone else [], compare=True,
              moves=[move(at("window", out), at("log", i - size), mark="bad")])
        if gone:
            del window[out]
        if window_equal():
            frame({"en": f"Window {quoted(log[lo:hi + 1])} at log[{lo}..{hi}] is a reordering of {quoted(pattern)}: "
                         f"true, and the slide stops here.",
                   "ko": f"log[{lo}..{hi}]의 창 {quoted(log[lo:hi + 1])}: pattern {quoted(pattern)}의 재배열이므로 답은 "
                         f"true이고, 여기서 멈춥니다."},
                  found=True, done=True, answer="true")
            return
    frame({"en": f"The window reached the end of log after {n - size + 1} positions, and none matched pattern's "
                 f"counts: false.",
           "ko": f"창이 {n - size + 1}곳을 지나 log 끝에 닿았지만, pattern과 글자 수가 같은 창은 없었습니다: false."},
          done=True, answer="false")


for number, sample in enumerate(sample_cases(SLUG), start=1):
    pattern, log = (line.strip() for line in sample["input"].split("\n")[:2])
    run = sample_run(wt, number, sample, input=f'pattern = "{pattern}", log = "{log}"')
    solve(pattern, log, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
