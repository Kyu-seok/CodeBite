#!/usr/bin/env python3.12
"""unique-genre-window's Walkthrough: the reference solution
(scripts/replay-solutions/unique-genre-window.py), a sliding window with a count per genre. The window is a span
above the queue and the best so far a dashed span below it; the counts are a map with k slots. Each tag added moves
into its genre's card, and each tag dropped from the left is its own frame, moving back out in red, on each sample
Test Case.

    CODEBITE_DB=<database> scripts/walkthroughs/unique-genre-window.py

writes common/src/main/resources/walkthroughs/unique-genre-window.json.
"""
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import josa, plural, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, map_entries, move, span  # noqa: E402

SLUG = "unique-genre-window"
EMPTY = {"en": "empty", "ko": "비어 있음"}

wt = Walkthrough(
    {"en": "Unique Genre Window", "ko": "장르 제한 몰아보기 구간"},
    {"en": "Grow the window one tag at a time on the right; when it holds more than k genres, drop tags from the "
           "left until it holds k again. Every window it passes through is a candidate.",
     "ko": "오른쪽으로 태그를 하나씩 넣어 구간을 늘리고, 장르가 k개를 넘으면 다시 k개가 될 때까지 왼쪽에서 "
           "태그를 뺍니다. 그렇게 지나가는 구간이 모두 후보입니다."},
    views=[
        {"id": "queue", "type": "array", "title": {"en": "queue", "ko": "queue (재생 큐)"}},
        {"id": "window", "type": "map", "title": {"en": "window (genre → count)", "ko": "window (장르 → 개수)"},
         "empty": EMPTY},
        {"id": "state", "type": "vars"},
    ],
)


def solve(queue, k, run):
    """Solution.k_distinct_window with a frame per tag added and per tag dropped."""
    n = len(queue)
    window = {}  # genre -> count, in insertion order as Counter keeps it
    best, best_span, left, right = 0, None, 0, None

    def frame(caption, marks=None, struck=(), moves=None, window_mark="lit", beaten=False, done=False, **answer):
        spans = {}
        if right is not None and not done:
            length = right - left + 1
            spans["window"] = span(left, right, {"en": f"window {length}", "ko": f"구간 {length}"},
                                   mark=window_mark, fade=True)
        if best_span:
            spans["best"] = span(*best_span, {"en": f"best = {best}", "ko": f"best (최장 길이) = {best}"}, below=True,
                                 mark="path" if done else "good" if beaten else None)
        read = n if done else 0 if right is None else right + 1
        run.frame(caption,
                  queue={"values": list(queue), "spans": spans, "unread": list(range(read, n)),
                         "pointers": {"left": None if right is None or done else left,
                                      "right": None if done else right},
                         "marks": ({"path": list(range(best_span[0], best_span[1] + 1))} if done and best_span
                                   else {"lit": [right]} if right is not None and not done else {})},
                  window={"entries": map_entries(window), "slots": k, "struck": list(struck),
                          "marks": marks or ({"dim": list(window)} if done else {})},
                  state={"items": [{"label": "k", "value": k}]},
                  moves=moves, **answer)

    def measure():
        """Hold the window left..right up to best: whether it beats it, and the caption's verdict in each language."""
        nonlocal best, best_span
        beaten = right - left + 1 > best
        if beaten:
            best, best_span = right - left + 1, (left, right)
            return True, f"a new best, {best}", f"best = {josa(best, '(으)로')} 갱신"
        return False, f"best stays {best}", f"best = {best} 그대로"

    if k == 0:
        frame({"en": "k = 0: the window holds no genre, so not even one tag fits. Answer 0.",
               "ko": "k = 0이면 구간에 장르를 하나도 넣을 수 없어 태그 하나도 들어가지 않습니다. 답은 0입니다."},
              done=True, answer="0")
        return
    frame({"en": f"{n} tags, and the window holds at most k = {k} {plural(k, 'genre', 'genres')}. "
                 f"It starts empty; tags join from the left.",
           "ko": f"태그 {n}개, 구간에는 장르가 최대 k = {k}종류까지 들어갑니다. 빈 구간에서 시작해 왼쪽부터 태그를 넣습니다."})
    for right, tag in enumerate(queue):
        window[tag] = window.get(tag, 0) + 1
        joins = [move(at("queue", right), at("window", tag))]
        if len(window) > k:
            frame({"en": f"queue[{right}] = '{tag}' joins: {len(window)} genres, more than k = {k}, "
                         f"so tags leave from the left until it is back to {k}.",
                   "ko": f"queue[{right}] = '{tag}' 추가: 장르가 {len(window)}종류로 k = {k}보다 많아, "
                         f"다시 {k}종류가 될 때까지 왼쪽에서 태그를 뺍니다."},
                  marks={"bad": [tag]}, moves=joins, window_mark="bad")
            while len(window) > k:
                out = queue[left]
                window[out] -= 1
                gone = window[out] == 0
                left += 1
                fits = len(window) - gone <= k
                beaten = False
                tail_en = tail_ko = ""
                if fits:
                    length = right - left + 1
                    beaten, verdict_en, verdict_ko = measure()
                    tail_en = f" Back to {k} {plural(k, 'genre', 'genres')}: window length {length}, {verdict_en}."
                    tail_ko = f" 다시 장르 {k}종류: 구간 길이 {length}, {verdict_ko}."
                count = f"{window[out] + 1} → {window[out]}"
                frame({"en": f"queue[{left - 1}] = '{out}' leaves: its genre's count goes {count}"
                             f"{', so the genre leaves the window' if gone else ''}.{tail_en}",
                       "ko": f"queue[{left - 1}] = '{out}' 제거: 장르 '{out}' 개수 {count}"
                             f"{', 구간에서 이 장르가 빠집니다' if gone else ''}.{tail_ko}"},
                      marks={} if gone else {"bad": [out]}, struck=[out] if gone else [],
                      moves=[move(at("window", out), at("queue", left - 1), mark="bad")],
                      window_mark="lit" if fits else "bad", beaten=beaten)
                if gone:
                    del window[out]
            continue
        length = right - left + 1
        beaten, verdict_en, verdict_ko = measure()
        frame({"en": f"queue[{right}] = '{tag}' joins: {len(window)} {plural(len(window), 'genre', 'genres')}, "
                     f"within k = {k}. Window length {length}: {verdict_en}.",
               "ko": f"queue[{right}] = '{tag}' 추가: 장르 {len(window)}종류로 k = {k} 이내입니다. 구간 길이 {length}, {verdict_ko}."},
              marks={"good": [tag]}, moves=joins, beaten=beaten)
    a, b = best_span
    if (a, b) == (left, right):
        caption = {"en": f"Every tag is in, and the longest window was the last one, \"{queue[a:b + 1]}\" "
                         f"(queue[{a}..{b}]), length {best}. Answer {best}.",
                   "ko": f"모든 태그를 넣었고, 가장 긴 구간은 마지막 구간 \"{queue[a:b + 1]}\"(queue[{a}..{b}]), "
                         f"길이 {best}입니다. 답은 {best}입니다."}
    else:
        caption = {"en": f"Every tag is in: the run ended on queue[{left}..{right}], but the best window was "
                         f"\"{queue[a:b + 1]}\" (queue[{a}..{b}]), length {best}. Answer {best}.",
                   "ko": f"모든 태그를 넣었습니다. 실행은 queue[{left}..{right}]에서 끝났지만 가장 긴 구간은 "
                         f"\"{queue[a:b + 1]}\"(queue[{a}..{b}]), 길이 {best}이고, 답은 {best}입니다."}
    frame(caption, done=True, answer=str(best))


for number, sample in enumerate(sample_cases(SLUG), start=1):
    lines = sample["input"].split("\n")
    queue, k = lines[0].strip(), int(lines[1])
    run = sample_run(wt, number, sample, input=f'queue = "{queue}", k = {k}')
    solve(queue, k, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
