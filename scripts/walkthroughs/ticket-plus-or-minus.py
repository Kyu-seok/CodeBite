#!/usr/bin/env python3.12
"""ticket-plus-or-minus' Walkthrough: the reference solution (scripts/replay-solutions/ticket-plus-or-minus.py), a
count of sign assignments per net total, rebuilt once per ticket, recording one frame per total spread on each sample
Test Case.

The solution keeps one Counter per ticket (`ways`, then `following`); the Walkthrough draws them as the rows of one
grid, a row per ticket under a `start` row, and a column per total any row reaches, the totals in the header row. A
total's count spreads into two cells of the next row, +value and −value, each a move carrying the count.

    CODEBITE_DB=<database> scripts/walkthroughs/ticket-plus-or-minus.py

writes common/src/main/resources/walkthroughs/ticket-plus-or-minus.json.
"""
import json
import os
import sys
from collections import Counter
from functools import partial

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import plural, sample_cases, sample_run, table_frame, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move  # noqa: E402

SLUG = "ticket-plus-or-minus"
CORNER, START, UNSET = "", "start", " "
HEADER = {"tone": "a"}
SAMPLES = sample_cases(SLUG)


def parse(sample):
    tickets_line, target_line = sample["input"].split("\n")
    return json.loads(tickets_line), int(target_line)


def total_cell(t):
    return f"t{t}"  # a header cell: drawn as the total, kept apart from the counts


def reached(tickets):
    """Every total some row reaches, in order."""
    totals, ways = {0}, {0}
    for v in tickets:
        ways = {t + s for t in ways for s in (v, -v)}
        totals |= ways
    return sorted(totals)


ALL_TOTALS = sorted({t for s in SAMPLES for t in reached(parse(s)[0])})
ALL_VALUES = sorted({v for s in SAMPLES for v in parse(s)[0]})
wt = Walkthrough(
    {"en": "Ticket Plus or Minus", "ko": "티켓에 플러스·마이너스 붙이기"},
    {"en": "Count the sign assignments reaching each net total, one ticket at a time: every total reached so far "
           "passes its count on to total + value and total − value.",
     "ko": "티켓을 하나씩 더하며 각 합계에 도달하는 부호 배정 수를 셉니다. 지금까지 도달한 합계마다 그 개수를 "
           "합계 + 값, 합계 − 값으로 넘깁니다."},
    views=[
        {"id": "table", "type": "grid",
         "title": {"en": "ways to reach each total (columns) after each ticket (rows)",
                   "ko": "티켓(행)마다 각 합계(열)에 도달하는 방법 수"},
         "values": {**{total_cell(t): {"tone": "b", "glyph": str(t)} for t in ALL_TOTALS},
                    **{f"±{v}": HEADER for v in ALL_VALUES}, START: HEADER,
                    CORNER: {"glyph": "", "tone": "plain"}, UNSET: {"glyph": "", "tone": "empty"}}},
    ],
)


def solve(tickets, target, run):
    """Solution.countSignAssignments with a frame per total spread. Returns the answer as the Driver prints it.
    Row 1 is the start; ticket i's row is i + 2."""
    totals = reached(tickets)
    col = {t: c + 1 for c, t in enumerate(totals)}
    grid = [[CORNER] + [total_cell(t) for t in totals], [START] + [UNSET] * len(totals)]
    grid += [[f"±{v}"] + [UNSET] * len(totals) for v in tickets]
    ways = Counter({0: 1})
    grid[1][col[0]] = 1

    frame = partial(table_frame, run, grid)

    frame({"en": f"{len(tickets)} tickets, target {target}. Before any ticket the total is 0, reached one way.",
           "ko": f"티켓 {len(tickets)}장, 목표 {target}. 티켓을 하나도 쓰지 않으면 합계는 0이고, 방법은 1가지입니다."},
          marks={"good": [[1, col[0]]]})
    for i, value in enumerate(tickets):
        row, prev = i + 2, i + 1
        following = Counter()
        for total, count in ways.items():
            following[total + value] += count
            following[total - value] += count
            up, down = total + value, total - value
            grid[row][col[up]] = following[up]
            grid[row][col[down]] = following[down]
            src = at("table", [prev, col[total]])
            lit = [[prev, col[total]], [row, 0]]
            if value == 0:
                frame({"en": f"Total {total} ({count} {plural(count, 'way', 'ways')}): +0 and −0 both stay at {total}, "
                             f"so it passes {count} twice, {following[total]} so far.",
                       "ko": f"합계 {total}({count}가지): +0과 −0 모두 {total} 그대로이므로 {count}가지를 두 번 넘겨 "
                             f"지금까지 {following[total]}가지입니다."},
                      marks={"lit": lit, "good": [[row, col[up]]]},
                      moves=[move(src, at("table", [row, col[up]]), value=f"2×{count}")])
                continue
            frame({"en": f"Total {total} ({count} {plural(count, 'way', 'ways')}): +{value} gives {up}, now "
                         f"{following[up]}, and −{value} gives {down}, now {following[down]}.",
                   "ko": f"합계 {total}({count}가지): +{value}면 {up}, 지금까지 {following[up]}가지, −{value}면 "
                         f"{down}, 지금까지 {following[down]}가지입니다."},
                  marks={"lit": lit, "good": [[row, col[up]], [row, col[down]]]},
                  moves=[move(src, at("table", [row, col[up]]), value=f"+{count}"),
                         move(src, at("table", [row, col[down]]), value=f"+{count}")])
        ways = following
    answer = ways[target]
    last = len(tickets) + 1
    if target in col:
        marks = {"path": [[0, col[target]], [last, col[target]]] if answer else [[0, col[target]]]}
    else:
        marks = {}
    frame({"en": f"After every ticket, total {target} is reached {answer} {plural(answer, 'way', 'ways')}. "
                 f"Answer: {answer}.",
           "ko": f"모든 티켓을 쓴 뒤 합계 {target}에 도달하는 방법은 {answer}가지입니다. 답은 {answer}입니다."},
          marks=marks, answer=str(answer))


for number, sample in enumerate(SAMPLES, start=1):
    tickets, target = parse(sample)
    tickets_line = sample["input"].split("\n")[0]
    run = sample_run(wt, number, sample, input=f"tickets = {tickets_line}, target = {target}")
    solve(tickets, target, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
