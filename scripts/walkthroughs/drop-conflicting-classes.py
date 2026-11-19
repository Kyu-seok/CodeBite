#!/usr/bin/env python3.12
"""drop-conflicting-classes' Walkthrough: the reference solution (scripts/replay-solutions/drop-conflicting-classes.py),
a greedy sweep over the classes by end time that keeps a class when it starts at or after the last kept class's end
and drops it otherwise, recording one frame per class on each sample Test Case.

The sorted classes, the kept ones and the dropped ones are three groups on one number line, so the count dropped is
the size of the bottom group; the last kept end each class is compared with is the one point on the axis.

    CODEBITE_DB=<database> scripts/walkthroughs/drop-conflicting-classes.py

writes common/src/main/resources/walkthroughs/drop-conflicting-classes.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import driver_list, josa, plural, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move  # noqa: E402

SLUG = "drop-conflicting-classes"
SORTED, KEPT, DROPPED = 0, 1, 2
LABELS = [{"en": "classes, by end", "ko": "끝 시각 순으로 정렬한 수업"},
          {"en": "kept", "ko": "남긴 수업"},
          {"en": "dropped", "ko": "뺀 수업"}]
LAST_END = {"en": "last end", "ko": "마지막 끝"}

wt = Walkthrough(
    {"en": "Drop Conflicting Classes", "ko": "충돌 수업 빼기"},
    {"en": "Sort the classes by end time and keep each one that starts at or after the last kept class ends: "
           "ending earliest leaves the most room for the rest, so every class that would overlap is dropped.",
     "ko": "수업을 끝 시각 순으로 정렬하고, 마지막으로 남긴 수업이 끝난 뒤(같은 시각 포함)에 시작하는 수업만 "
           "남깁니다. 가장 일찍 끝나는 수업을 남겨야 나머지에 자리가 가장 많이 남으므로, 겹치는 수업은 모두 뺍니다."},
    views=[
        {"id": "line", "type": "intervals", "empty": {"en": "none yet", "ko": "아직 없음"}},
    ],
)


def solve(classes, run):
    """Solution.dropClassConflicts with a frame per class. Returns the answer as the Driver prints it."""
    ordered = sorted(classes, key=lambda c: c[1])
    kept, dropped = [], []
    last_end = None  # the solution's float("-inf") until a class is kept

    def frame(caption, marks=(None, None, None), point=None, moves=None, **answer):
        groups = [{"label": LABELS[g], "intervals": ivs, "marks": marks[g] or {}}
                  for g, ivs in enumerate((ordered, kept, dropped))]
        line = {"groups": groups}
        if point is not None:
            line["points"] = [{"at": point, "label": LAST_END, "mark": "lit"}]
        run.frame(caption, line=line, moves=moves, **answer)

    listed = ", ".join(driver_list(c) for c in ordered)
    frame({"en": f"Sort the {len(ordered)} classes by end time: {listed}. Nothing is kept yet, so the first one "
                 "can't conflict.",
           "ko": f"수업 {len(ordered)}개를 끝 시각 순으로 정렬합니다: {listed}. 아직 남긴 수업이 없으므로 첫 수업은 "
                 "충돌할 수 없습니다."},
          marks=({"lit": list(range(len(ordered)))}, None, None))
    for i, (start, end) in enumerate(ordered):
        cls = driver_list([start, end])
        read = {"lit": [i], "dim": list(range(i))}
        if last_end is None or start >= last_end:
            if last_end is None:
                en = f"{cls}: nothing is kept yet, so keep it. Its end, {end}, is now the last end."
                ko = f"{cls} 수업: 아직 남긴 수업이 없으므로 남깁니다. 이제 마지막 끝은 {josa(end, '이가')} 됩니다."
                kept_marks = {"good": [0]}
            else:
                en = f"{cls} starts at {start} ≥ last end {last_end}, so it fits after the kept classes: keep it, " \
                     f"and the last end becomes {end}."
                ko = f"{cls} 수업은 {start}분에 시작해 마지막 끝 {last_end} 이후이므로 남긴 수업 뒤에 들어갑니다. " \
                     f"남기고, 마지막 끝은 {josa(end, '이가')} 됩니다."
                kept_marks = {"lit": [len(kept) - 1], "good": [len(kept)]}
            point = last_end
            kept.append([start, end])
            last_end = end
            frame({"en": en, "ko": ko}, marks=(read, kept_marks, None), point=point,
                  moves=[move(at("line", [SORTED, i]), at("line", [KEPT, len(kept) - 1]))])
        else:
            dropped.append([start, end])
            frame({"en": f"{cls} starts at {start} < last end {last_end}: it overlaps the kept class "
                         f"{driver_list(kept[-1])}, so drop it ({len(dropped)} dropped so far).",
                   "ko": f"{cls} 수업은 {start}분에 시작해 마지막 끝 {last_end}보다 앞이므로 남긴 "
                         f"{driver_list(kept[-1])} 수업과 겹칩니다. 이 수업을 뺍니다(지금까지 {len(dropped)}개)."},
                  marks=(read, {"lit": [len(kept) - 1]}, {"bad": [len(dropped) - 1]}), point=last_end,
                  moves=[move(at("line", [SORTED, i]), at("line", [DROPPED, len(dropped) - 1]), mark="bad")])
    d, k = len(dropped), len(kept)
    if d == 0:
        caption = {"en": f"No class overlapped the one kept before it, so all {k} stay. Answer: 0.",
                   "ko": f"어떤 수업도 앞서 남긴 수업과 겹치지 않아 {k}개 모두 남습니다. 답은 0입니다."}
        marks = ({"dim": list(range(len(ordered)))}, {"path": list(range(k))}, None)
    else:
        caption = {"en": f"{k} {plural(k, 'class', 'classes')} kept without overlap, {d} dropped: the fewest that can "
                         f"go. Answer: {d}.",
                   "ko": f"겹치지 않게 수업 {k}개를 남기고 {d}개를 뺐습니다. 이보다 적게 뺄 수는 "
                         f"없습니다. 답은 {d}입니다."}
        marks = ({"dim": list(range(len(ordered)))}, {"dim": list(range(k))}, {"path": list(range(d))})
    frame(caption, marks=marks, answer=str(d))


for number, sample in enumerate(sample_cases(SLUG), start=1):
    classes = json.loads(sample["input"])
    values = [v for c in classes for v in c]
    run = sample_run(wt, number, sample, input=f"classes = {sample['input']}",
                     setup={"line": {"domain": [min(values), max(values)]}})
    solve(classes, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
