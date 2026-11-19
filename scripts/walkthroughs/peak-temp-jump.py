#!/usr/bin/env python3.12
"""peak-temp-jump's Walkthrough: the reference solution (scripts/replay-solutions/peak-temp-jump.py), one pass
keeping the lowest reading so far, recording one frame per reading on each sample Test Case. The lowest reading is
the pointer low; the swing from it to the reading read is a window span from low to j, written under j as well, and
the best swing so far is a dashed span under the readings.

    CODEBITE_DB=<database> scripts/walkthroughs/peak-temp-jump.py

writes common/src/main/resources/walkthroughs/peak-temp-jump.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import josa, plural, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, span  # noqa: E402

SLUG = "peak-temp-jump"

wt = Walkthrough(
    {"en": "Peak Temperature Jump", "ko": "최대 온도 변동"},
    {"en": "The best swing ending at a reading starts at the lowest reading before it, so one pass keeps the lowest "
           "so far and measures each reading against it.",
     "ko": "어떤 측정값에서 끝나는 가장 큰 변동은 그 앞의 가장 낮은 값에서 시작합니다. 그래서 한 번 훑으며 지금까지의 "
           "최저값을 기억하고, 측정값마다 그 최저값과의 차이를 잽니다."},
    views=[
        {"id": "readings", "type": "array", "title": {"en": "readings", "ko": "readings (측정값)"}},
    ],
)


def solve(readings, run):
    """Solution.maxTempSwing with a frame per reading. Returns the answer as the Driver prints it."""
    n = len(readings)
    low = None  # index of the lowest reading so far
    best, best_span = 0, None
    swings = []  # the swing ending at each reading read, shown under it
    j = None

    def frame(caption, window_mark=None, best_mark=None, cell_mark="lit", done=False, **answer):
        spans = {}
        if not done and j is not None and j > low:
            d = readings[j] - readings[low]
            spans["window"] = span(low, j, {"en": f"{readings[j]} − {readings[low]} = {d}",
                                            "ko": f"{readings[j]} − {readings[low]} = {d}"}, mark=window_mark)
        if best_span:
            spans["best"] = span(*best_span, {"en": f"best = {best}", "ko": f"best (최대 변동) = {best}"},
                                 below=True, mark="path" if done else best_mark)
        marks = {}
        if done:
            if best_span:
                marks["path"] = list(best_span)
        elif j is not None:
            marks[cell_mark] = [j]
        run.frame(caption,
                  readings={"values": list(readings), "spans": spans,
                            "pointers": {} if done or j is None else {"low": low, "j": j},
                            "under": [[i, f"+{d}" if d > 0 else str(d)] for i, d in enumerate(swings)],
                            "unread": list(range(0 if j is None else j + 1, n)) if not done else [],
                            "marks": marks},
                  **answer)

    frame({"en": f"{n} {plural(n, 'reading', 'readings')}. Read them left to right, keeping low, the lowest "
                 f"reading so far: a swing ending at reading j is largest when it starts at low.",
           "ko": f"측정값 {n}개를 왼쪽부터 읽으며 지금까지의 최저값 위치를 low로 기억합니다. j번 측정값에서 끝나는 변동은 "
                 f"low에서 시작할 때 가장 큽니다."})
    for j, reading in enumerate(readings):
        if low is None or reading < readings[low]:
            before = None if low is None else readings[low]
            low = j
            swings.append(0)
            if before is None:
                caption = {"en": f"readings[0] = {reading} is the first reading, so it is the lowest so far: low = 0.",
                           "ko": f"readings[0] = {josa(reading, '은는')} 첫 측정값이므로 지금까지의 최저값입니다: low = 0."}
            else:
                caption = {"en": f"readings[{j}] = {reading} is below the lowest {before}, so low moves to {j}. "
                                 f"A swing ending here is 0.",
                           "ko": f"readings[{j}] = {josa(reading, '은는')} 최저값 {before}보다 낮으므로 low가 "
                                 f"{josa(j, '(으)로')} 옮겨 갑니다. 여기서 끝나는 변동은 0입니다."}
            frame(caption, cell_mark="good")
            continue
        d = reading - readings[low]
        swings.append(d)
        if d > best:
            old = best
            best, best_span = d, (low, j)
            frame({"en": f"readings[{j}] = {reading}: the swing from low is {reading} − {readings[low]} = {d}, "
                         f"more than the best {old}, so it is the best now.",
                   "ko": f"readings[{j}] = {reading}: low에서의 변동은 {reading} − {readings[low]} = "
                         f"{josa(d, '(으)로')} 지금까지의 best {old}보다 커서 새 best가 됩니다."},
                  window_mark="good", best_mark="good")
        else:
            frame({"en": f"readings[{j}] = {reading}: the swing from low is {reading} − {readings[low]} = {d}, "
                         f"not more than the best {best}.",
                   "ko": f"readings[{j}] = {reading}: low에서의 변동은 {reading} − {readings[low]} = "
                         f"{josa(d, '(으)로')} best {best}보다 크지 않습니다."})
    if best_span:
        a, b = best_span
        caption = {"en": f"Every reading is read. The largest swing went from readings[{a}] = {readings[a]} up to "
                         f"readings[{b}] = {readings[b]}: {readings[b]} − {readings[a]} = {best}.",
                   "ko": f"모든 측정값을 읽었습니다. 가장 큰 변동은 readings[{a}] = {readings[a]}에서 readings[{b}] = "
                         f"{readings[b]}까지 오른 {readings[b]} − {readings[a]} = {best}입니다."}
    else:
        caption = {"en": "Every reading is read, and each one was a new low: the temperature never rose, so the "
                         "answer is 0.",
                   "ko": "모든 측정값을 읽었는데 매번 새 최저값이었습니다. 온도가 한 번도 오르지 않았으므로 답은 0입니다."}
    j = None
    frame(caption, done=True, answer=str(best))


for number, sample in enumerate(sample_cases(SLUG), start=1):
    readings = json.loads(sample["input"])
    run = sample_run(wt, number, sample, input=f"readings = {sample['input'].strip()}")
    solve(readings, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
