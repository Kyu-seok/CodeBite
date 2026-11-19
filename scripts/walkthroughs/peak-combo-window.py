#!/usr/bin/env python3.12
"""peak-combo-window's Walkthrough: the reference solution (scripts/replay-solutions/peak-combo-window.py), a
monotonic deque of indices whose values fall from front to back, recording one frame per index popped from the
back, one per index pushed, one per index leaving the front and one per peak taken, on each sample Test Case and an
extra run where the front slides out of the window. The window is a span above combo; the deque is a queue view open
at both ends, each entry its beat's combo value tagged with the beat's index; each peak moves from the deque's front
into the output.

    CODEBITE_DB=<database> scripts/walkthroughs/peak-combo-window.py

writes common/src/main/resources/walkthroughs/peak-combo-window.json.
"""
import json
import os
import sys
from collections import deque

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import driver_list, josa, plural, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move, span  # noqa: E402

SLUG = "peak-combo-window"

wt = Walkthrough(
    {"en": "Peak Combo Window", "ko": "구간 최고 콤보"},
    {"en": "A deque keeps only the beats that could still be a window's peak, their values falling from front to "
           "back: a new beat pops every smaller one off the back, the front leaves once it slides out of the "
           "window, and the front is always the window's peak.",
     "ko": "덱에는 앞으로 윈도의 최댓값이 될 수 있는 비트만 남기며, 값은 앞에서 뒤로 갈수록 작아집니다. 새 비트는 뒤에서 "
           "자기보다 작거나 같은 값을 모두 꺼내고, 앞쪽 비트는 윈도 밖으로 밀려나면 빠지므로, 덱의 맨 앞이 언제나 "
           "윈도의 최댓값입니다."},
    views=[
        {"id": "combo", "type": "array", "title": {"en": "combo", "ko": "combo (비트별 콤보)"}},
        {"id": "dq", "type": "queue", "deque": True,
         "title": {"en": "deque (beats, values falling front to back)", "ko": "덱 (비트, 앞에서 뒤로 작아지는 값)"},
         "empty": {"en": "empty", "ko": "비어 있음"}},
        {"id": "peaks", "type": "output", "title": {"en": "peaks", "ko": "peaks (윈도별 최댓값)"},
         "empty": {"en": "none yet", "ko": "아직 없음"}},
    ],
)


def beat(i):
    return {"en": f"beat {i}", "ko": f"{i}번"}


def solve(combo, k, run):
    """Solution.peakComboPerWindow with a frame per deque change and per peak. Returns the answer as printed."""
    n = len(combo)
    window = deque()
    peaks = []
    i = None

    def frame(caption, leaving=None, at_front=False, dq_lit=(), dq_good=(), combo_lit=(), peak_good=False,
              moves=None, done=False, **answer):
        shown = list(window)
        if leaving is not None:
            shown = [leaving] + shown if at_front else shown + [leaving]
        spans = {}
        if i is not None and not done:
            lo = max(0, i - k + 1)
            spans["window"] = span(lo, i, {"en": f"window {i - lo + 1}", "ko": f"윈도 {i - lo + 1}"}, fade=True)
        run.frame(caption,
                  combo={"values": list(combo), "spans": spans,
                         "pointers": {} if done or i is None else {"i": i},
                         "unread": [] if done else list(range(0 if i is None else i + 1, n)),
                         "marks": {"lit": list(combo_lit)}},
                  dq={"values": [combo[j] for j in shown], "tags": [[p, beat(j)] for p, j in enumerate(shown)],
                      "marks": {"lit": list(dq_lit), "good": list(dq_good), "dim": list(range(len(shown))) if done else []}},
                  peaks={"values": list(peaks),
                         "marks": {"path": list(range(len(peaks)))} if done else
                         {"good": [len(peaks) - 1]} if peak_good else {}},
                  moves=moves, **answer)

    count = n - k + 1
    frame({"en": f"{n} beats and k = {k}, so there are {n} − {k} + 1 = {count} "
                 f"{plural(count, 'window', 'windows')}. The deque starts empty.",
           "ko": f"비트 {n}개, k = {k}이므로 윈도는 {n} − {k} + 1 = {count}개입니다. 덱은 비어 있습니다."})
    for i, value in enumerate(combo):
        while window and combo[window[-1]] <= value:
            j = window.pop()
            frame({"en": f"combo[{i}] = {value} ≥ {combo[j]} at the back (beat {j}): beat {j} can never be a peak "
                         f"while beat {i} is in the window, so it leaves the back.",
                   "ko": f"combo[{i}] = {value} ≥ 뒤쪽 {j}번 비트의 {combo[j]}: {i}번 비트가 윈도에 있는 동안 {j}번은 "
                         f"최댓값이 될 수 없으므로 뒤에서 꺼냅니다."},
                  leaving=j, dq_lit=[len(window)], combo_lit=[i],
                  moves=[move(at("dq", len(window)), mark="bad")])
        if window:
            why = {"en": f"The back's {combo[window[-1]]} (beat {window[-1]}) is larger than {value}",
                   "ko": f"뒤쪽 {window[-1]}번 비트의 {combo[window[-1]]}보다 {josa(value, '이가')} 작아"}
        else:
            why = {"en": "The deque is empty", "ko": "덱이 비어 있어"}
        window.append(i)
        frame({"en": f"{why['en']}: push beat {i} ({value}) on the back.",
               "ko": f"{why['ko']} {i}번 비트({value})를 뒤에 넣습니다."},
              dq_good=[len(window) - 1], combo_lit=[i],
              moves=[move(at("combo", i), at("dq", len(window) - 1))])
        if window[0] <= i - k:
            j = window.popleft()
            frame({"en": f"The front, beat {j}, is at or before i − k = {i - k}: it slid out of the window, so it "
                         f"leaves the front.",
                   "ko": f"맨 앞 {j}번 비트가 i − k = {i - k} 이하라 윈도 밖으로 밀려났으므로 앞에서 꺼냅니다."},
                  leaving=j, at_front=True, dq_lit=[0], combo_lit=[j],
                  moves=[move(at("dq", 0), mark="bad")])
        if i >= k - 1:
            peaks.append(combo[window[0]])
            lo = i - k + 1
            frame({"en": f"The window combo[{lo}..{i}] is full: its peak is the deque's front, beat {window[0]} "
                         f"with {combo[window[0]]}.",
                   "ko": f"윈도 combo[{lo}..{i}]가 찼습니다. 최댓값은 덱의 맨 앞, {window[0]}번 비트의 "
                         f"{combo[window[0]]}입니다."},
                  dq_lit=[0], combo_lit=[window[0]], peak_good=True,
                  moves=[move(at("dq", 0), at("peaks", len(peaks) - 1))])
    i = None
    answer = driver_list(peaks)
    frame({"en": f"Every beat is read: each of the {count} {plural(count, 'window', 'windows')} took its peak from "
                 f"the deque's front, {answer}.",
           "ko": f"모든 비트를 읽었습니다. 윈도 {count}개가 모두 덱의 맨 앞에서 최댓값을 가져가 {answer}입니다."},
          done=True, answer=answer)


for number, sample in enumerate(sample_cases(SLUG), start=1):
    lines = sample["input"].split("\n")
    combo, k = json.loads(lines[0]), int(lines[1])
    run = sample_run(wt, number, sample, input=f"combo = {lines[0].strip()}, k = {k}")
    solve(combo, k, run)
# Neither sample's deque front ever slides out of the window (the larger beats come late). This extra run has a
# falling start, so the front leaves twice.
EXTRA, EXTRA_K = [5, 3, 1, 2], 2
solve(EXTRA, EXTRA_K, wt.run({"en": "Extra: the front slides out", "ko": "추가: 맨 앞이 윈도 밖으로"},
                             input=f"combo = {driver_list(EXTRA)}, k = {EXTRA_K}", expected="[5,3,2]", extra=True))
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
