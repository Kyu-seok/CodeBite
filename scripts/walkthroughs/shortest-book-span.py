#!/usr/bin/env python3.12
"""shortest-book-span's Walkthrough: the reference solution
(scripts/replay-solutions/shortest-book-span.py), a window that grows on the right until it covers every
needed tag and then shrinks from the left while it still does, recording one frame per volume added, one
per covering window measured and one per volume dropped on each sample Test Case. missing counts, per
tag, how many more the window still needs (negative: spare copies); each volume added moves into its card
as −1 and each one dropped moves back in as +1. The best window so far is a dashed span under the shelf.

    CODEBITE_DB=<database> scripts/walkthroughs/shortest-book-span.py

writes common/src/main/resources/walkthroughs/shortest-book-span.json.
"""
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import josa, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, map_entries, move, span  # noqa: E402

SLUG = "shortest-book-span"

wt = Walkthrough(
    {"en": "Shortest Book Span", "ko": "가장 짧은 책 구간"},
    {"en": "Grow the window on the right until it covers every needed tag, then shrink it from the left for as "
           "long as it still covers them: each covering window is measured, and the shortest one is the answer.",
     "ko": "필요한 태그를 모두 담을 때까지 창을 오른쪽으로 늘리고, 그다음 계속 다 담는 동안 왼쪽에서 줄입니다. "
           "다 담는 창마다 길이를 재고, 가장 짧은 창이 답입니다."},
    views=[
        {"id": "needed", "type": "array", "title": {"en": "needed", "ko": "needed (필요한 태그)"}},
        {"id": "shelf", "type": "array", "title": {"en": "shelf", "ko": "shelf (책꽂이)"}},
        {"id": "missing", "type": "map",
         "title": {"en": "missing (still needed per tag)", "ko": "missing (태그별 아직 필요한 수)"}},
        {"id": "state", "type": "vars"},
    ],
)

TO_COVER_WHY = ("to_cover is how many needed volumes the window still lacks, summed over the cards; "
                "it is no one card's value, only equal to one by chance")


def solve(shelf, needed, run):
    """Solution.shortestShelfSpan with a frame per step. Returns the answer as the Driver prints it."""
    m = len(shelf)
    missing = {}
    for tag in needed:
        missing[tag] = missing.get(tag, 0) + 1
    to_cover = len(needed)
    start, end = 0, -1
    best_start, best_len = 0, m + 1

    def frame(caption, shelf_lit=(), key_mark=None, window_mark=None, best_mark=None, moves=None, done=False,
              **answer):
        spans = {}
        if not done and end >= start:
            length = end - start + 1
            spans["window"] = span(start, end, {"en": f"window {length}", "ko": f"창 {length}"},
                                   mark=window_mark, fade=True)
        if best_len <= m:
            spans["best"] = span(best_start, best_start + best_len - 1,
                                 {"en": f"best {best_len}", "ko": f"best (최단) {best_len}"},
                                 mark="path" if done else best_mark, below=True)
        marks = {"lit": list(shelf_lit)}
        if done and best_len <= m:
            marks["path"] = list(range(best_start, best_start + best_len))
        run.frame(caption,
                  needed={"values": list(needed)},
                  shelf={"values": list(shelf), "spans": spans,
                         "pointers": {} if done else {"start": start if start <= end else None,
                                                      "end": end if end >= 0 else None},
                         "unread": [] if done else list(range(end + 1, m)), "marks": marks},
                  missing={"entries": map_entries(missing), "marks": key_mark or {}},
                  state={"items": [{"label": {"en": "to_cover", "ko": "to_cover (아직 모자란 권수)"},
                                    "value": to_cover, "why": TO_COVER_WHY,
                                    "mark": "good" if to_cover == 0 and not done else None}]},
                  moves=moves, **answer)

    frame({"en": f"needed = \"{needed}\": missing starts with the count of each tag needed, and to_cover = "
                 f"{len(needed)} volumes are still lacking.",
           "ko": f"needed = \"{needed}\": missing에는 태그마다 필요한 수가 들어가고, 아직 모자란 권수는 to_cover = "
                 f"{len(needed)}입니다."},
          moves=[move(at("needed", j), at("missing", tag)) for j, tag in enumerate(needed)])
    for end, tag in enumerate(shelf):
        helped = missing.get(tag, 0) > 0
        if helped:
            to_cover -= 1
        missing[tag] = missing.get(tag, 0) - 1
        if helped:
            text = ({"en": f"shelf[{end}] = '{tag}' was still needed, so to_cover drops to {to_cover}.",
                     "ko": f"shelf[{end}] = '{tag}' 태그는 아직 필요했으므로 to_cover가 {josa(to_cover, '(으)로')} 줄어듭니다."})
        else:
            text = ({"en": f"shelf[{end}] = '{tag}' isn't needed any more, so its count just goes to {missing[tag]} "
                           f"(a spare) and to_cover stays {to_cover}.",
                     "ko": f"shelf[{end}] = '{tag}' 태그는 더 필요하지 않아 개수만 {josa(missing[tag], '이가')} 되고(남는 책) "
                           f"to_cover는 {to_cover} 그대로입니다."})
        frame(text, key_mark={"good": [tag]}, moves=[move(at("shelf", end), at("missing", tag), value="−1")])
        while to_cover == 0:
            length = end - start + 1
            if length < best_len:
                old = best_len
                best_start, best_len = start, length
                beat_en = "the first covering window" if old > m else f"shorter than the best {old}"
                beat_ko = "처음으로 다 담은 창이므로" if old > m else f"지금까지 최단 {old}보다 짧으므로"
                frame({"en": f"to_cover = 0: shelf[{start}..{end}] = \"{shelf[start:end + 1]}\" covers every needed "
                             f"tag. Its length {length} is {beat_en}, so it is the best now.",
                       "ko": f"to_cover = 0: shelf[{start}..{end}] = \"{shelf[start:end + 1]}\" 구간이 필요한 태그를 모두 "
                             f"담습니다. 길이 {length}: {beat_ko} 이제 best입니다."},
                      window_mark="good", best_mark="good")
            else:
                frame({"en": f"to_cover = 0: shelf[{start}..{end}] covers every needed tag, but its length {length} "
                             f"doesn't beat the best {best_len}.",
                       "ko": f"to_cover = 0: shelf[{start}..{end}] 구간이 필요한 태그를 모두 담지만, 길이 "
                             f"{josa(length, '은는')} 최단 {best_len}보다 짧지 않습니다."},
                      window_mark="good")
            out = shelf[start]
            missing[out] += 1
            start += 1
            if missing[out] > 0:
                to_cover += 1
                frame({"en": f"Shrink from the left: shelf[{start - 1}] = '{out}' leaves, and it was needed, so "
                             f"'{out}' is missing again and to_cover rises to {to_cover}. Grow on the right.",
                       "ko": f"왼쪽에서 줄입니다: shelf[{start - 1}] = '{out}' 태그가 빠지는데 필요한 책이었으므로 "
                             f"다시 모자라 to_cover가 {josa(to_cover, '이가')} 됩니다. 오른쪽으로 다시 늘립니다."},
                      shelf_lit=[start - 1], key_mark={"bad": [out]},
                      moves=[move(at("shelf", start - 1), at("missing", out), value="+1", mark="bad")])
            else:
                frame({"en": f"Shrink from the left: shelf[{start - 1}] = '{out}' leaves, but it was a spare "
                             f"(count back to {missing[out]}), so the window still covers everything.",
                       "ko": f"왼쪽에서 줄입니다: shelf[{start - 1}] = '{out}' 태그가 빠지지만 남는 책이었으므로"
                             f"(개수 {missing[out]}) 창은 여전히 모두 담습니다."},
                      shelf_lit=[start - 1], key_mark={"good": [out]},
                      moves=[move(at("shelf", start - 1), at("missing", out), value="+1")])
    if best_len <= m:
        result = shelf[best_start:best_start + best_len]
        frame({"en": f"The window reached the end of the shelf. The shortest covering window was "
                     f"shelf[{best_start}..{best_start + best_len - 1}] = \"{result}\", length {best_len}.",
               "ko": f"창이 책꽂이 끝에 닿았습니다. 필요한 태그를 모두 담은 가장 짧은 창은 "
                     f"shelf[{best_start}..{best_start + best_len - 1}] = \"{result}\", 길이 {best_len}입니다."},
              done=True, answer=result)
    else:
        frame({"en": f"The window reached the end of the shelf with to_cover = {to_cover} still above 0: no window "
                     f"covers \"{needed}\", so the answer is the empty string \"\".",
               "ko": f"창이 책꽂이 끝에 닿았지만 to_cover는 {to_cover}에 머물러 0이 되지 못했습니다. \"{needed}\"의 태그를 모두 담는 "
                     f"창이 없으니 답은 빈 문자열 \"\"입니다."},
              key_mark={"bad": [t for t in missing if missing[t] > 0]}, done=True, answer="")


for number, sample in enumerate(sample_cases(SLUG), start=1):
    shelf, needed = (line.strip() for line in sample["input"].split("\n")[:2])
    run = sample_run(wt, number, sample, input=f'shelf = "{shelf}", needed = "{needed}"')
    solve(shelf, needed, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
