#!/usr/bin/env python3.12
"""find-empty-locker's Walkthrough: the reference solution (scripts/replay-solutions/find-empty-locker.py), one
running XOR over the full range 0..n and the claimed lockers, recording one frame for n and one per index on each
sample Test Case. The range is an array of its own, so each number XORed in moves from a cell; a number met in both
arrays has cancelled, and both its cells fade.

    CODEBITE_DB=<database> scripts/walkthroughs/find-empty-locker.py

writes common/src/main/resources/walkthroughs/find-empty-locker.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import bit_text, driver_list, josa, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move  # noqa: E402

SLUG = "find-empty-locker"

wt = Walkthrough(
    {"en": "Find the Empty Locker", "ko": "비어 있는 사물함 찾기"},
    {"en": "XOR every number 0..n and every claimed locker into one value: each claimed number meets itself and "
           "cancels (x ^ x = 0), so only the missing one is left.",
     "ko": "0부터 n까지의 모든 수와 배정된 사물함 번호를 모두 XOR로 한 값에 모읍니다. 배정된 번호는 자기 자신과 "
           "만나 지워지므로(x ^ x = 0) 빠진 번호만 남습니다."},
    views=[
        {"id": "range", "type": "array", "title": {"en": "0..n (tag: bits)", "ko": "0..n 전체 범위 (태그: 비트)"}},
        {"id": "lockers", "type": "array", "title": {"en": "lockers (tag: bits)", "ko": "lockers (배정된 번호, 태그: 비트)"}},
        {"id": "missing", "type": "output", "title": {"en": "missing (running XOR)", "ko": "missing (누적 XOR)"}},
    ],
)


def solve(lockers, run):
    """Solution.findVacantSlot with a frame for n and one per index. Returns the missing number."""
    n = len(lockers)
    width = max(1, n.bit_length())

    numbers = list(range(n + 1))
    xored_range, xored_lockers = set(), set()  # values XORed in from each array so far
    missing = 0

    def frame(caption, i=None, from_range=(), from_locker=None, path=False, **answer):
        cancelled = xored_range & xored_lockers
        run.frame(caption,
                  range={"values": numbers, "tags": [[k, bit_text(k, width)] for k in numbers],
                         "marks": {"dim": [k for k in numbers if k in cancelled],
                                   "lit": list(from_range), "path": [missing] if path else []}},
                  lockers={"values": lockers, "tags": [[k, bit_text(v, width)] for k, v in enumerate(lockers)],
                           "pointers": {"i": i},
                           "marks": {"dim": [k for k, v in enumerate(lockers) if v in cancelled],
                                     "lit": [from_locker] if from_locker is not None else []}},
                  missing={"values": [f"{missing} ({bit_text(missing, width)})"],
                           "marks": {"path": [0]} if path else {"good": [0]} if from_range else {}},
                  moves=[move(at("range", k), at("missing", 0), value=f"^ {k}", mark="good") for k in from_range]
                  + ([move(at("lockers", from_locker), at("missing", 0), value=f"^ {lockers[from_locker]}", mark="good")]
                     if from_locker is not None else []) or None,
                  **answer)

    frame({"en": f"{n} lockers claimed, so the full range is 0..{n}. Start missing at 0 and XOR in every number of the "
                 "range and every claimed locker.",
           "ko": f"배정된 사물함이 {n}개이니 전체 범위는 0..{n}입니다. missing = 0에서 시작해 범위의 모든 수와 배정된 "
                 "번호를 하나씩 XOR합니다."})
    before = missing
    missing ^= n
    xored_range.add(n)
    frame({"en": f"First n itself: missing = {before} ^ {n} = {missing}.",
           "ko": f"먼저 n부터: missing = {before} ^ {n} = {josa(missing, '이가')} 됩니다."},
          from_range=[n])
    for i, locker in enumerate(lockers):
        before = missing
        missing ^= i ^ locker
        xored_range.add(i)
        xored_lockers.add(locker)
        gone = sorted({i, locker} & xored_range & xored_lockers)
        if gone:
            names = " and ".join(str(k) for k in gone)
            en = f" {names} {'have' if len(gone) > 1 else 'has'} now come in from both arrays and cancelled."
            ko = f" {', '.join(str(k) for k in gone)}번은 이제 두 배열에서 모두 들어와 지워졌습니다."
        else:
            en = ko = ""
        frame({"en": f"i = {i}: missing ^= {i} ^ {locker}, so {before} ^ {i} ^ {locker} = {missing}.{en}",
               "ko": f"i = {i}: missing ^= {i} ^ {locker}, 즉 {before} ^ {i} ^ {locker} = {josa(missing, '이가')} 됩니다.{ko}"},
              i=i, from_range=[i], from_locker=i)
    frame({"en": f"Every claimed number cancelled with its copy in the range; only {missing} came in once, so it is "
                 f"the empty locker: answer {missing}.",
           "ko": f"배정된 번호는 모두 범위의 같은 수와 지워졌고 {missing}만 한 번 들어왔으므로, 그 번호가 빈 사물함입니다. "
                 f"답은 {missing}입니다."},
          path=True, answer=str(missing))
    return missing


for number, sample in enumerate(sample_cases(SLUG), start=1):
    lockers = json.loads(sample["input"])
    run = sample_run(wt, number, sample, input=f"lockers = {driver_list(lockers)}")
    solve(lockers, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
