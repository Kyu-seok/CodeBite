#!/usr/bin/env python3.12
"""slot-a-meeting's Walkthrough: the reference solution (scripts/replay-solutions/slot-a-meeting.py), one sweep over
the sorted calendar in three stretches (meetings that end before the new one starts are copied, meetings that start
by its end are merged into it, the rest are copied after it), recording one frame per meeting read on each sample
Test Case.

The calendar, the new meeting and the updated calendar are three groups on one number line, as the description's
Diagram stacks them; the boundary each meeting is compared with, the new meeting's start or end, is a point on the
axis, and every meeting moves into the group it lands in.

    CODEBITE_DB=<database> scripts/walkthroughs/slot-a-meeting.py

writes common/src/main/resources/walkthroughs/slot-a-meeting.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import driver_list, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move  # noqa: E402

SLUG = "slot-a-meeting"
CAL, NEW, OUT = 0, 1, 2
CALENDAR = {"en": "meetings", "ko": "meetings (기존 회의)"}
ADDED = {"en": "newMeeting", "ko": "newMeeting (새 회의)"}
UPDATED = {"en": "updated calendar", "ko": "새 캘린더"}
START = {"en": "start", "ko": "시작"}
END = {"en": "end", "ko": "끝"}

wt = Walkthrough(
    {"en": "Slot a Meeting In", "ko": "회의 일정 끼워 넣기"},
    {"en": "The calendar is sorted, so it splits into three stretches: meetings ending before the new one starts "
           "stay as they are, meetings starting by its end merge into it, and the rest follow it unchanged.",
     "ko": "캘린더가 정렬되어 있으므로 세 구간으로 나뉩니다: 새 회의가 시작하기 전에 끝나는 회의는 그대로, 새 회의가 "
           "끝나기 전에 시작하는 회의는 새 회의에 합쳐지고, 나머지는 그 뒤에 그대로 붙습니다."},
    views=[
        {"id": "line", "type": "intervals", "empty": {"en": "none yet", "ko": "아직 없음"}},
    ],
)


def iv(w):
    return f"[{w[0]},{w[1]}]"


def solve(meetings, new_meeting, run):
    """Solution.insertMeeting with a frame per meeting read. Returns the answer as the Driver prints it."""
    start, end = new_meeting
    result = []
    n = len(meetings)

    def frame(caption, cal=None, new=None, out=None, points=(), moves=None, **answer):
        line = {"groups": [{"label": CALENDAR, "intervals": meetings, "marks": cal or {}},
                           {"label": ADDED, "intervals": [[start, end]], "marks": new or {}},
                           {"label": UPDATED, "intervals": result, "marks": out or {}}],
                "points": [{"at": at_, "label": label, "mark": "lit"} for at_, label in points]}
        run.frame(caption, line=line, moves=moves, **answer)

    frame({"en": f"Insert {iv(new_meeting)} into {n} sorted meetings. Walk the calendar from the left, comparing "
                 "each meeting with the new one's start, then its end.",
           "ko": f"정렬된 회의 {n}개에 {iv(new_meeting)} 회의를 끼워 넣습니다. 캘린더를 왼쪽부터 보며 각 회의를 "
                 "새 회의의 시작, 그다음 끝과 비교합니다."},
          new={"lit": [0]})
    i = 0
    while i < n and meetings[i][1] < start:
        result.append(meetings[i])
        frame({"en": f"{iv(meetings[i])} ends at {meetings[i][1]}, before the new meeting starts at {start}: "
                     "it can't overlap, so it goes into the calendar as it is.",
               "ko": f"{iv(meetings[i])} 회의는 {meetings[i][1]}에 끝나 새 회의가 시작하는 {start}보다 앞이므로 "
                     "겹칠 수 없습니다. 그대로 새 캘린더에 넣습니다."},
              cal={"lit": [i], "dim": list(range(i))}, out={"good": [len(result) - 1]}, points=[(start, START)],
              moves=[move(at("line", [CAL, i]), at("line", [OUT, len(result) - 1]))])
        i += 1
    first_compared = i  # the meeting that ended the first stretch: its end was compared with the start too
    while i < n and meetings[i][0] <= end:
        a, b = meetings[i]
        before = (start, end)
        start = min(start, a)
        end = max(end, b)
        not_before = f"ends at {b}, not before {before[0]}, and " if i == first_compared else ""
        not_before_ko = (f"{b}에 끝나 {before[0]}보다 앞이 아니고, " if not_before else "")
        changed = (start, end) != before
        grow_en = f"merge them into {iv((start, end))}" if changed else f"{iv(before)} already covers it"
        grow_ko = f"둘을 합쳐 {iv((start, end))} 회의가 됩니다" if changed else f"{iv(before)} 회의가 이미 덮고 있습니다"
        frame({"en": f"{iv((a, b))} {not_before}starts at {a}, by the new meeting's end {before[1]}: they overlap, "
                     f"so {grow_en}.",
               "ko": f"{iv((a, b))} 회의는 {not_before_ko}{a}에 시작해 새 회의의 끝 {before[1]} 이하이므로 겹칩니다. "
                     f"{grow_ko}."},
              cal={"lit": [i], "dim": list(range(i))}, new={"good": [0]} if changed else {"lit": [0]},
              points=[(before[0], START), (before[1], END)] if not_before else [(before[1], END)],
              moves=[move(at("line", [CAL, i]), at("line", [NEW, 0]))])
        i += 1
    result.append([start, end])
    placed = len(result) - 1
    if i < n:
        why_en = f"{iv(meetings[i])} starts at {meetings[i][0]}, after the new meeting's end {end}, so nothing else " \
                 f"overlaps: {iv((start, end))} goes into the calendar."
        why_ko = f"{iv(meetings[i])} 회의는 {meetings[i][0]}에 시작해 새 회의의 끝 {end}보다 뒤이므로 더 겹치는 회의가 " \
                 f"없습니다. {iv((start, end))} 회의를 새 캘린더에 넣습니다."
        cal = {"lit": [i], "dim": list(range(i))}
        points = [(end, END)]
    else:
        why_en = f"No meetings are left to compare, so {iv((start, end))} goes into the calendar."
        why_ko = f"더 비교할 회의가 없으므로 {iv((start, end))} 회의를 새 캘린더에 넣습니다."
        cal = {"dim": list(range(n))}
        points = []
    frame({"en": why_en, "ko": why_ko}, cal=cal, new={"lit": [0]}, out={"good": [placed]}, points=points,
          moves=[move(at("line", [NEW, 0]), at("line", [OUT, placed]))])
    if i < n:
        rest = meetings[i:]
        first = len(result)
        result.extend(rest)
        names = ", ".join(iv(m) for m in rest)
        frame({"en": f"The calendar is sorted, so every meeting from here on starts later still: {names} "
                     "follow unchanged.",
               "ko": f"캘린더가 정렬되어 있으므로 남은 회의는 모두 더 늦게 시작합니다. {names} 회의는 그대로 뒤에 "
                     "붙습니다."},
              cal={"lit": list(range(i, n)), "dim": list(range(i))}, new={"dim": [0]},
              out={"good": list(range(first, len(result)))},
              moves=[move(at("line", [CAL, j]), at("line", [OUT, first + k])) for k, j in enumerate(range(i, n))])
    answer = driver_list(result)
    frame({"en": f"The updated calendar is {answer}: still sorted, with no overlaps.",
           "ko": f"새 캘린더는 {answer}입니다. 여전히 정렬되어 있고 겹치는 회의가 없습니다."},
          cal={"dim": list(range(n))}, new={"dim": [0]}, out={"path": list(range(len(result)))}, answer=answer)


for number, sample in enumerate(sample_cases(SLUG), start=1):
    meetings_line, new_line = sample["input"].split("\n")
    meetings, new_meeting = json.loads(meetings_line), json.loads(new_line)
    values = [v for w in meetings + [new_meeting] for v in w]
    run = sample_run(wt, number, sample, input=f"meetings = {meetings_line}, newMeeting = {new_line}",
                     setup={"line": {"domain": [min(values), max(values)]}})
    solve(meetings, new_meeting, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
