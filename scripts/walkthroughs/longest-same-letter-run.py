#!/usr/bin/env python3.12
"""longest-same-letter-run's Walkthrough: the reference solution
(scripts/replay-solutions/longest-same-letter-run.py), a window over s with a count per letter, recording one
frame per letter joining and one per letter leaving on each sample Test Case. The window is a span above s
labelled with its length and the letters it would have to change (length − top, top being the highest count
any letter has reached); the best is a dashed span below. Each letter joining moves into its card, and while
the window needs more than k changes, letters leave from the left, moving back out in red.

    CODEBITE_DB=<database> scripts/walkthroughs/longest-same-letter-run.py

writes common/src/main/resources/walkthroughs/longest-same-letter-run.json.
"""
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import josa, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, map_entries, move, span  # noqa: E402

SLUG = "longest-same-letter-run"
TOP_WHY = ("top is the highest count any letter has reached so far, and it never goes down: after letters leave, "
           "no card may hold it any more, so it can't be drawn on a card")

wt = Walkthrough(
    {"en": "Longest Same-Letter Run", "ko": "같은 글자 최장 구간"},
    {"en": "Grow a window to the right; it is one letter repeated once the letters other than its most common one, "
           "length − top, are changed. While that needs more than k changes, letters leave from the left.",
     "ko": "구간을 오른쪽으로 늘립니다. 가장 많은 글자 말고 나머지(길이 − top)를 바꾸면 한 글자만 남습니다. "
           "바꿀 글자가 k개보다 많으면 왼쪽에서 글자를 뺍니다."},
    views=[
        {"id": "s", "type": "array", "title": "s"},
        {"id": "counts", "type": "map", "title": {"en": "counts (letter → count)", "ko": "counts (글자 → 개수)"},
         "empty": {"en": "empty", "ko": "비어 있음"}},
        {"id": "state", "type": "vars"},
    ],
)


def solve(s, k, run):
    """Solution.longestSameLetterRun with a frame per letter added and per letter dropped."""
    n = len(s)
    counts = {}
    start, end = 0, None
    top = best = 0
    best_span = None

    def frame(caption, marks=None, moves=None, window_mark="lit", beaten=False, top_mark=None, done=False,
              **answer):
        spans = {}
        if end is not None and not done:
            length = end - start + 1
            spans["window"] = span(start, end, {"en": f"window {length} − top {top} = {length - top}",
                                                "ko": f"구간 {length} − top {top} = {length - top}"},
                                   mark=window_mark, fade=True)
        if best_span:
            spans["best"] = span(*best_span, {"en": f"best = {best}", "ko": f"최장 {best}"}, below=True,
                                 mark="path" if done else "good" if beaten else None)
        read = n if done else 0 if end is None else end + 1
        run.frame(caption,
                  s={"values": list(s), "spans": spans, "unread": list(range(read, n)),
                     "pointers": {} if done or end is None else {"start": start, "end": end},
                     "marks": ({"path": list(range(best_span[0], best_span[1] + 1))} if done
                               else {"lit": [end]} if end is not None else {})},
                  counts={"entries": map_entries(counts), "marks": marks or {}},
                  state={"items": [{"label": "k", "value": k},
                                   {"label": {"en": "top", "ko": "top (최다 개수)"}, "value": top, "mark": top_mark,
                                    "why": TOP_WHY}]},
                  moves=moves, **answer)

    def fits():
        return end - start + 1 - top <= k

    frame({"en": f"s has {n} letters and k = {k} of them may change. The window starts empty and grows from "
                 f"the left; top is the highest count any letter has reached.",
           "ko": f"s는 글자 {n}개이고 그중 k = {k}개까지 바꿀 수 있습니다. 빈 구간에서 시작해 왼쪽부터 늘려 가며, "
                 f"top은 지금까지 한 글자가 도달한 가장 큰 개수입니다."})
    for end, letter in enumerate(s):
        counts[letter] = counts.get(letter, 0) + 1
        raised = counts[letter] > top
        top = max(top, counts[letter])
        length = end - start + 1
        joins = [move(at("s", end), at("counts", letter))]
        top_en = f", the new top" if raised else ""
        top_ko = f", 새 top" if raised else ""
        head_en = f"s[{end}] = '{letter}' joins: its count is {counts[letter]}{top_en}."
        head_ko = f"s[{end}] = '{letter}' 추가: 개수 {counts[letter]}{top_ko}."
        if fits():
            beaten = length > best
            if beaten:
                best, best_span = length, (start, end)
            verdict_en = f"a new best, {best}" if beaten else f"best stays {best}"
            verdict_ko = f"best = {josa(best, '(으)로')} 갱신" if beaten else f"best = {best} 그대로"
            frame({"en": f"{head_en} Window {length} needs {length} − {top} = {length - top} "
                         f"{'change' if length - top == 1 else 'changes'}, within k = {k}: {verdict_en}.",
                   "ko": f"{head_ko} 구간 {length}에서 바꿀 글자는 {length} − {top} = {length - top}개로 "
                         f"k = {k} 이내이고, {verdict_ko}."},
                  marks={"good": [letter]}, moves=joins, beaten=beaten, top_mark="good" if raised else None)
            continue
        frame({"en": f"{head_en} Window {length} needs {length} − {top} = {length - top} changes, more than "
                     f"k = {k}, so a letter leaves from the left.",
               "ko": f"{head_ko} 구간 {length}에서 바꿀 글자가 {length} − {top} = {length - top}개로 k = {k}보다 "
                     f"많아, 왼쪽에서 글자를 뺍니다."},
              marks={"bad": [letter]}, moves=joins, window_mark="bad", top_mark="good" if raised else None)
        while not fits():
            out = s[start]
            counts[out] -= 1
            start += 1
            length = end - start + 1
            ok = fits()
            stale = top not in counts.values()
            tail_en = (f" Window {length} needs {length} − {top} = {length - top}, within k = {k}; best stays {best}."
                       if ok else "")
            tail_ko = (f" 구간 {length}에서 바꿀 글자는 {length - top}개로 k = {k} 이내, best = {best} 그대로."
                       if ok else "")
            if ok and stale:
                tail_en = (f" No letter has {top} now, but top stays {top}: a window only beats best = {best} with "
                           f"a letter more than {top} times, so the old top is still the right bar.")
                tail_ko = (f", 이제 개수가 {top}인 글자는 없지만 top은 그대로 {top}입니다. 어느 글자가 "
                           f"{top}개를 넘어야만 best = {josa(best, '을를')} 넘을 수 있어 옛 top으로 충분합니다.")
            frame({"en": f"s[{start - 1}] = '{out}' leaves: its count goes {counts[out] + 1} → {counts[out]}.{tail_en}",
                   "ko": f"s[{start - 1}] = '{out}' 제거: 개수 {counts[out] + 1} → {counts[out]}"
                         f"{tail_ko if tail_ko.startswith(',') else '.' + tail_ko}"},
                  marks={"bad": [out]}, window_mark="lit" if ok else "bad",
                  moves=[move(at("counts", out), at("s", start - 1), mark="bad")])
    end_was = (start, end)
    a, b = best_span
    if (a, b) == end_was:
        caption = {"en": f"Every letter is in, and the longest window was the last one, s[{a}..{b}], length {best}. "
                         f"Answer {best}.",
                   "ko": f"모든 글자를 넣었고, 가장 긴 구간은 마지막 구간 s[{a}..{b}], 길이 {best}입니다. 답은 {best}입니다."}
    else:
        caption = {"en": f"Every letter is in: the run ended on s[{end_was[0]}..{end_was[1]}], but the best window was "
                         f"s[{a}..{b}], length {best}. Answer {best}.",
                   "ko": f"모든 글자를 넣었습니다. 실행은 s[{end_was[0]}..{end_was[1]}]에서 끝났지만 가장 긴 구간은 "
                         f"s[{a}..{b}], 길이 {best}이고, 답은 {best}입니다."}
    frame(caption, done=True, answer=str(best))


for number, sample in enumerate(sample_cases(SLUG), start=1):
    lines = sample["input"].split("\n")
    s, k = lines[0].strip(), int(lines[1])
    run = sample_run(wt, number, sample, input=f's = "{s}", k = {k}')
    solve(s, k, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
