#!/usr/bin/env python3.12
"""restore-wifi-ip's Walkthrough: the reference solution (scripts/replay-solutions/restore-wifi-ip.py), backtracking
one segment per call: place(start) tries the next 1, 2 and 3 digits as a segment, stops at one with a leading zero or
over 255, skips one that leaves too few or too many digits for the segments still to come, and calls place(end) with
it; four segments are an address. "19216811" makes 35 calls, too many to draw as a tree, so the call stack stands
beside the digits (views.md, recursion): one card per open call noting the address so far, each segment a span over
its digits, moving from them into the call that takes it.

One frame per call made (a full address goes into the answer in its frame) and one per run of calls returning
together, not per length tried: the lengths a call passes over are named in the caption of the next call it makes.
A pruned branch, a segment with no address anywhere below it, is one frame (#388): the segment is drawn taken and
marked bad, its caption says how many calls below it ran undrawn and what they tried, and the next frame has it off
again. Whether a branch is pruned, and those counts, come from place itself: it first runs the branch with its frames
held back, counting, and draws it call by call only when that run reached an address.

    CODEBITE_DB=<database> scripts/walkthroughs/restore-wifi-ip.py

writes common/src/main/resources/walkthroughs/restore-wifi-ip.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import driver_list, plural, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, call, move, span  # noqa: E402

SLUG = "restore-wifi-ip"

wt = Walkthrough(
    {"en": "Restore Wi-Fi IP", "ko": "Wi-Fi IP 복원하기"},
    {"en": "Place one segment per call: try the next 1, 2 or 3 digits, stop at a leading zero or a number over 255, and "
           "skip a length that leaves the digits unable to fill the segments still to come. Four segments that use "
           "every digit are an address.",
     "ko": "호출마다 조각 하나를 놓습니다. 다음 숫자 1, 2, 3개를 차례로 시도하고, 앞자리가 0이거나 255를 넘으면 멈추며, 남은 "
           "숫자로 남은 조각을 채울 수 없는 길이는 건너뜁니다. 모든 숫자를 쓴 네 조각이 주소 하나입니다."},
    views=[
        {"id": "digits", "type": "array", "title": {"en": "digits (a span per segment)", "ko": "digits (조각마다 구간)"}},
        {"id": "calls", "type": "callstack", "title": {"en": "call stack", "ko": "호출 스택"}},
        {"id": "result", "type": "output", "title": {"en": "addresses", "ko": "주소"},
         "empty": {"en": "none yet", "ko": "아직 없음"}},
    ],
)


def why_not(digits, start, end, placed):
    """Why place(start) passes over digits[start:end] with `placed` segments down, or None when it takes it."""
    segment = digits[start:end]
    if segment[0] == "0" and len(segment) > 1:
        return {"en": f"\"{segment}\" has a leading zero", "ko": f"\"{segment}\" 조각은 앞자리가 0"}
    if int(segment) > 255:
        return {"en": f"\"{segment}\" is over 255", "ko": f"\"{segment}\" 조각은 255 초과"}
    left, slots = len(digits) - end, 3 - placed
    if left < slots:
        return {"en": f"\"{segment}\" leaves {left} {plural(left, 'digit', 'digits')} for {slots} {plural(slots, 'segment', 'segments')}",
                "ko": f"\"{segment}\" 조각 뒤로 숫자 {left}개가 남아 조각 {slots}개를 못 채움"}
    if left > 3 * slots and slots == 0:
        return {"en": f"\"{segment}\" would leave {left} {plural(left, 'digit', 'digits')} after segment 4",
                "ko": f"\"{segment}\" 조각은 4번째 조각 뒤로 숫자 {left}개를 남김"}
    if left > 3 * slots:
        return {"en": f"\"{segment}\" leaves {left} digits, too many for {slots} {plural(slots, 'segment', 'segments')}",
                "ko": f"\"{segment}\" 조각 뒤로 숫자 {left}개가 남아 조각 {slots}개에 너무 많음"}
    return None


def lengths(digits, start, placed):
    """Each length place(start) tries with `placed` segments down, as (end, why it passes over it or None when it
    takes it), stopping after a leading zero or a number over 255 as the solution breaks there."""
    for end in range(start + 1, min(start + 3, len(digits)) + 1):
        segment = digits[start:end]
        yield end, why_not(digits, start, end, placed)
        if (segment[0] == "0" and len(segment) > 1) or int(segment) > 255:
            return


def solve(digits, run):
    """Solution.restoreIpAddresses with a frame per call made, per run of returns and per pruned branch. Returns the
    answer as the Driver prints it."""
    segments, starts, addresses = [], [], []
    stack = []          # start of each open call, bottom first

    def card(start, depth):
        so_far = ".".join(segments[:depth])
        return call("place", note=so_far or {"en": "no segment yet", "ko": "아직 조각 없음"}, start=start)

    def frame(caption, call_marks=None, digit_marks=None, leaving=0, result_marks=None, moves=None, **answer):
        spans = {f"s{k + 1}": span(starts[k], starts[k] + len(segments[k]) - 1, segments[k])
                 for k in range(len(segments))}
        cards = [card(s, d) for d, s in enumerate(stack)]
        run.frame(caption,
                  digits={"values": list(digits), "spans": spans, "marks": digit_marks or {}},
                  calls={"calls": cards,
                         "marks": {**(call_marks or {}),
                                   **({"dim": list(range(len(cards) - leaving, len(cards)))} if leaving else {})}},
                  result={"values": list(addresses), "marks": result_marks or {}},
                  moves=moves, **answer)

    ended = {}          # depth -> the lengths a call passed over after its last call, for its return's caption
    returned = []       # depths of the calls returned since the last frame, deepest first

    def flush():
        if not returned:
            return
        back = len(stack) - len(returned) - 1
        names = ", ".join(f"place(start={stack[d]})" for d in returned)
        if back >= 0:
            to = {"en": f"back in place(start={stack[back]}), which tries a longer segment",
                  "ko": f"place(start={stack[back]}) 호출로 돌아와 더 긴 조각을 시도합니다"}
        else:
            to = {"en": "the search is over", "ko": "탐색이 끝납니다"}
        moves = [move(at("calls", d)) for d in returned]
        keep = max(back, 0)
        dropped = list(range(starts[keep], len(digits))) if keep < len(starts) else []
        notes = [(stack[d], ended.pop(d)) for d in returned if d in ended]
        why = ({"en": " " + "; ".join(f"place(start={st}) ran out of lengths: " + ", ".join(r["en"] for r in rs)
                                      for st, rs in notes) + ".",
                "ko": " 더 시도할 길이가 없는 호출: " + ", ".join(f"place(start={st})(" + ", ".join(r["ko"] for r in rs) + ")"
                                                         for st, rs in notes) + "."} if notes else {"en": "", "ko": ""})
        frame({"en": f"{names} {plural(len(returned), 'returns, taking', 'return, each taking')} its segment back off; "
                     + to["en"] + "." + why["en"],
               "ko": f"{names} 호출이 조각을 다시 떼고 끝나며, " + to["ko"] + "." + why["ko"]},
              leaving=len(returned), digit_marks={"bad": dropped}, moves=moves)
        del stack[back + 1:]
        del segments[keep:]
        del starts[keep:]
        returned.clear()

    def dead_end(start, end, skipped, held):
        """The pruned branch under digits[start:end] as one frame: the segment taken and the call for the next one
        drawn bad, both gone again after it. `held` is what place counted running the branch undrawn."""
        calls, taken, reasons = held["calls"], held["taken"], held["passed"]
        seg, depth, nth = digits[start:end], len(stack), len(segments) + 1
        segments.append(seg)
        starts.append(start)
        stack.append(end)
        pass_over = {"en": "".join(r["en"] + "; " for r in skipped), "ko": "".join(r["ko"] + ", " for r in skipped)}
        pass_over["en"] = pass_over["en"][:1].upper() + pass_over["en"][1:]
        if calls == 1:
            tries = len(reasons)
            why = {"en": f"the 1 call below it, place(start={end}), not drawn, tries {tries} "
                         f"{plural(tries, 'length', 'lengths')} and finds no segment {nth + 1} ("
                         + ", ".join(r["en"] for r in reasons) + f"), so \"{seg}\" comes straight back off",
                   "ko": f"그 아래 place(start={end}) 호출 1개(그리지 않음)에서 길이 {tries}가지를 시도해도 {nth + 1}번째 "
                         f"조각을 찾지 못하는(" + ", ".join(r["ko"] for r in reasons) + ") 막다른 길이므로, 바로 다시 뗍니다"}
        else:
            tried = ", ".join(f"\"{t}\"" for t in taken)
            why = {"en": f"the {calls} calls below it, not drawn, try {tried} and reach no address, so \"{seg}\" "
                         f"comes back off",
                   "ko": f"그 아래 호출 {calls}개(그리지 않음)에서 {tried} 조각을 시도해도 주소가 나오지 않는 막다른 "
                         f"길이므로, 다시 뗍니다"}
        frame({"en": pass_over["en"] + f"\"{seg}\" as segment {nth} is a dead end: " + why["en"] + ".",
               "ko": pass_over["ko"] + f"\"{seg}\" 조각을 {nth}번째 조각으로 놓으면 " + why["ko"] + "."},
              call_marks={"bad": [depth]}, digit_marks={"bad": list(range(start, end))},
              moves=[move(at("digits", start), at("calls", depth), value=seg)])
        segments.pop()
        starts.pop()
        stack.pop()

    def place(start, skipped, held=None):
        """The solution's recursion. With `held` (a dead end's counts so far), it runs with its frames held back:
        it counts itself in `calls`, each segment it takes in `taken`, each length it passes over in `passed` and
        each address it reaches in `found`, adds nothing to the answer, and leaves the stack as it found it."""
        depth = len(stack)
        stack.append(start)
        if held is not None:
            held["calls"] += 1
            if len(segments) == 4:
                held["found"] += 1
            else:
                for end, reason in lengths(digits, start, depth):
                    if reason:
                        held["passed"].append(reason)
                        continue
                    held["taken"].append(digits[start:end])
                    segments.append(digits[start:end])
                    starts.append(start)
                    place(end, [], held)
                    segments.pop()
                    starts.pop()
            stack.pop()
            return
        if depth == 0:
            frame({"en": f"\"{digits}\" has {len(digits)} digits. The first call, place(start=0), will try the first 1, 2 "
                         f"and 3 digits as segment 1.",
                   "ko": f"\"{digits}\" 문자열은 숫자 {len(digits)}개입니다. 첫 호출 place(start=0)에서 앞의 숫자 1, 2, "
                         f"3개를 1번째 조각으로 시도합니다."},
                  call_marks={"lit": [0]}, moves=[move(dst=at("calls", 0))])
        else:
            seg = segments[-1]
            pass_over = ({"en": "; ".join(r["en"] for r in skipped) + "; ", "ko": ", ".join(r["ko"] for r in skipped)
                          + ". "} if skipped else {"en": "", "ko": ""})
            pass_over["en"] = pass_over["en"][:1].upper() + pass_over["en"][1:]
            cells = list(range(starts[-1], start))
            moves = [move(at("digits", starts[-1]), at("calls", depth), value=seg)]
            if len(segments) == 4:
                address = ".".join(segments)
                addresses.append(address)
                moves.append(move(at("calls", depth), at("result", len(addresses) - 1), value=address))
                frame({"en": pass_over["en"] + f"\"{seg}\" is segment 4 and uses the last digit, so {address} is an "
                                               f"address: it goes into the answer.",
                       "ko": pass_over["ko"] + f"\"{seg}\" 조각이 4번째 조각으로 마지막 숫자까지 쓰므로 주소 {address} "
                                               f"완성, 답에 넣습니다."},
                      call_marks={"good": [depth]}, digit_marks={"good": cells},
                      result_marks={"good": [len(addresses) - 1]}, moves=moves)
            else:
                frame({"en": (pass_over["en"] or "T") + ("t" if pass_over["en"] else "") + f"ake \"{seg}\" as segment {len(segments)} and call "
                                               f"place(start={start}) for segment {len(segments) + 1}.",
                       "ko": pass_over["ko"] + f"\"{seg}\" 조각을 {len(segments)}번째 조각으로 놓고, "
                                               f"{len(segments) + 1}번째 조각을 위해 place(start={start}) 호출에 넘깁니다."},
                      call_marks={"lit": [depth]}, digit_marks={"good": cells}, moves=moves)
        if len(segments) == 4:
            returned.append(depth)
            return
        passed = []
        for end, reason in lengths(digits, start, depth):
            segment = digits[start:end]
            if reason:
                passed.append(reason)
                continue
            flush()
            segments.append(segment)
            starts.append(start)
            below = {"calls": 0, "taken": [], "passed": [], "found": 0}
            place(end, [], below)
            if not below["found"]:
                segments.pop()
                starts.pop()
                dead_end(start, end, passed, below)
                passed = []
                continue
            place(end, passed)
            passed = []
        if passed:
            ended[depth] = passed
        returned.append(depth)

    place(0, [])
    flush()
    k = len(addresses)
    printed = driver_list(sorted(addresses))
    frame({"en": f"Every call has returned: {k} valid {plural(k, 'address', 'addresses')}" + (", listed sorted." if k else
                                                                                             ", so the answer is []."),
           "ko": f"모든 호출이 끝났습니다. 유효한 주소는 {k}개" + ("이고, 정렬해서 답으로 냅니다." if k else
                                                         "이므로 답은 빈 목록 []입니다.")},
          result_marks={"path": list(range(k))}, answer=printed)
    return printed


for number, sample in enumerate(sample_cases(SLUG), start=1):
    digits = sample["input"].strip()
    run = sample_run(wt, number, sample, input=f'digits = "{digits}"')
    solve(digits, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
