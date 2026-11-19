#!/usr/bin/env python3.12
"""longest-genre-window's Walkthrough: the reference solution (scripts/replay-solutions/longest-genre-window.py),
a window whose start jumps past the earlier copy of a repeated tag, found in a map from each tag to where it was
last seen. One frame per tag read, and one more when it repeats inside the window, on each sample Test Case. The
window is a span above feed and the best so far a dashed span below it; the map holds each tag's last index as
text, a card whose index is before start dimmed, and each tag read is looked up as the map's probe.

    CODEBITE_DB=<database> scripts/walkthroughs/longest-genre-window.py

writes common/src/main/resources/walkthroughs/longest-genre-window.json.
"""
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import josa, plural, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, map_entries, move, span  # noqa: E402

SLUG = "longest-genre-window"

wt = Walkthrough(
    {"en": "Longest Genre Window", "ko": "가장 긴 장르 몰아보기"},
    {"en": "Remember where each tag was last seen: when the tag read was last seen inside the window, the window's "
           "start jumps just past that copy, and every window in between is a candidate.",
     "ko": "태그마다 마지막으로 본 위치를 기억합니다. 지금 읽은 태그를 구간 안에서 본 적이 있으면 구간의 start를 그 "
           "태그 바로 다음으로 옮기고, 그사이 지나는 구간이 모두 후보입니다."},
    views=[
        {"id": "feed", "type": "array", "title": {"en": "feed", "ko": "feed (시청 대기열)"}},
        {"id": "last_seen", "type": "map",
         "title": {"en": "last_seen (tag → last index)", "ko": "last_seen (태그 → 마지막 위치)"},
         "empty": {"en": "empty", "ko": "비어 있음"}},
    ],
)


def solve(feed, run):
    """Solution.longestGenreWindow with a frame per tag read and one per jump. Returns the answer as printed."""
    n = len(feed)
    last_seen = {}
    start, best, best_span, i = 0, 0, None, None

    def frame(caption, probe=None, card_mark=None, cell_marks=None, window_mark=None, beaten=False, moves=None,
              done=False, **answer):
        spans = {}
        if i is not None and not done:
            length = i - start + 1
            spans["window"] = span(start, i, {"en": f"window {length}", "ko": f"구간 {length}"},
                                   mark=window_mark, fade=True)
        if best_span:
            spans["best"] = span(*best_span, {"en": f"best = {best}", "ko": f"best (최장 길이) = {best}"}, below=True,
                                 mark="path" if done else "good" if beaten else None)
        marks = {"dim": [t for t, j in last_seen.items() if j < start]}
        if card_mark:
            marks.update(card_mark)
        if done:
            marks = {"dim": list(last_seen)}
        read = n if done else 0 if i is None else i + 1
        state = {"entries": map_entries({t: f"i={j}" for t, j in last_seen.items()}), "marks": marks}
        if probe:
            state["probe"] = probe
        run.frame(caption,
                  feed={"values": list(feed), "spans": spans, "unread": list(range(read, n)),
                        "pointers": {} if done or i is None else {"start": start, "i": i},
                        "marks": ({"path": list(range(best_span[0], best_span[1] + 1))} if done
                                  else cell_marks or ({"lit": [i]} if i is not None else {}))},
                  last_seen=state, moves=moves, **answer)

    def ask(tag, hit):
        return {"key": tag, "hit": hit, "label": {"en": f"'{tag}' in window?", "ko": f"'{tag}' 구간 안에?"}}

    def measure():
        nonlocal best, best_span
        length = i - start + 1
        if length > best:
            best, best_span = length, (start, i)
            return True, f"window length {length}, a new best", f"구간 길이 {length}, best = {josa(best, '(으)로')} 갱신"
        return False, f"window length {length}, best stays {best}", f"구간 길이 {length}, best = {best} 그대로"

    frame({"en": f"{n} {plural(n, 'tag', 'tags')} in feed. Read them left to right; last_seen remembers the index "
                 f"where each tag was last seen, and the window runs from start to the tag read.",
           "ko": f"feed에 태그가 {n}개 있습니다. 왼쪽부터 읽으며 last_seen에 태그마다 마지막으로 본 위치를 기억하고, "
                 f"구간은 start부터 지금 읽는 태그까지입니다."})
    for i, tag in enumerate(feed):
        seen = last_seen.get(tag, -1)
        joins = [move(at("feed", i), at("last_seen", tag), value=f"i={i}")]
        if seen >= start:
            frame({"en": f"feed[{i}] = '{tag}' was last seen at i={seen}, inside the window from start = {start}: "
                         f"the window would hold two '{tag}'s.",
                   "ko": f"feed[{i}] = '{tag}' 태그는 i={seen}에서 마지막으로 봤고, start = {start}부터인 구간 "
                         f"안입니다. 구간에 '{tag}' 태그가 두 번 들어갑니다."},
                  probe=ask(tag, True), card_mark={"lit": [tag]}, cell_marks={"bad": [seen, i]}, window_mark="bad")
            old = start
            start = seen + 1
            last_seen[tag] = i
            beaten, en, ko = measure()
            frame({"en": f"start jumps from {old} to {seen} + 1 = {start}, just past the earlier '{tag}', and "
                         f"last_seen['{tag}'] becomes {i}: {en}.",
                   "ko": f"start가 {old}에서 앞의 '{tag}' 태그 바로 다음인 {seen} + 1 = {josa(start, '(으)로')} 옮겨 가고, "
                         f"last_seen['{tag}']는 {josa(i, '이가')} 됩니다. {ko}."},
                  card_mark={"good": [tag]}, beaten=beaten, window_mark="good" if beaten else None, moves=joins)
            continue
        last_seen[tag] = i
        beaten, en, ko = measure()
        if seen >= 0:
            why_en = f"was last seen at i={seen}, before start = {start}, so it is not in the window"
            why_ko = f"태그는 i={seen}에서 봤지만 start = {start}보다 앞이라 구간 밖입니다"
        else:
            why_en, why_ko = "is new", "태그는 처음 나왔습니다"
        frame({"en": f"feed[{i}] = '{tag}' {why_en}; last_seen['{tag}'] = {i}. {en[0].upper()}{en[1:]}.",
               "ko": f"feed[{i}] = '{tag}' {why_ko}. last_seen['{tag}'] = {i}, {ko}."},
              probe=ask(tag, False), card_mark={"good": [tag]}, beaten=beaten,
              window_mark="good" if beaten else None, moves=joins)
    a, b = best_span
    i_end = i
    if (a, b) == (start, i_end):
        caption = {"en": f"Every tag is read, and the longest window was the last one, \"{feed[a:b + 1]}\" "
                         f"(feed[{a}..{b}]), length {best}. Answer {best}.",
                   "ko": f"모든 태그를 읽었고, 가장 긴 구간은 마지막 구간 \"{feed[a:b + 1]}\"(feed[{a}..{b}]), "
                         f"길이 {best}입니다. 답은 {best}입니다."}
    else:
        caption = {"en": f"Every tag is read: the run ended on feed[{start}..{i_end}], but the first longest window was "
                         f"\"{feed[a:b + 1]}\" (feed[{a}..{b}]), length {best}. Answer {best}.",
                   "ko": f"모든 태그를 읽었습니다. 실행은 feed[{start}..{i_end}]에서 끝났지만 처음 찾은 가장 긴 구간은 "
                         f"\"{feed[a:b + 1]}\"(feed[{a}..{b}]), 길이 {best}이고, 답은 {best}입니다."}
    frame(caption, done=True, answer=str(best))


for number, sample in enumerate(sample_cases(SLUG), start=1):
    feed = sample["input"].split("\n")[0].strip()
    run = sample_run(wt, number, sample, input=f'feed = "{feed}"')
    solve(feed, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
