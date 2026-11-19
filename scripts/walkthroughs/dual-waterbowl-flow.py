#!/usr/bin/env python3.12
"""dual-waterbowl-flow's Walkthrough: the reference solution (scripts/replay-solutions/dual-waterbowl-flow.py), two
searches that climb from each bowl's border cells to every cell whose water flows down to that bowl, on each sample
Test Case. The field is drawn as the description's grid Diagram draws it, each cell a search reaches tagged with that
bowl's arrow; a frame per cell popped that reaches new cells (and one for pushing them), and one for each run of pops
that reach nothing.

    CODEBITE_DB=<database> scripts/walkthroughs/dual-waterbowl-flow.py

writes common/src/main/resources/walkthroughs/dual-waterbowl-flow.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import driver_list, plural, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move  # noqa: E402

SLUG = "dual-waterbowl-flow"
BOWLS = [{"tag": "↖", "en": "top/left", "ko": "위/왼쪽"}, {"tag": "↘", "en": "bottom/right", "ko": "아래/오른쪽"}]

wt = Walkthrough(
    {"en": "Dual Waterbowl Flow", "ko": "두 물그릇 모두 닿기"},
    {"en": "Search backwards from each bowl: start at its border cells and climb to any neighbor at least as high, "
           "since water from there flows down to it. The cells both climbs reach are the answer.",
     "ko": "물그릇마다 거꾸로 찾습니다. 그 가장자리 칸에서 시작해 높이가 같거나 높은 이웃으로 올라가면, 그 이웃의 물은 "
           "이 칸으로 흘러내립니다. 두 탐색이 모두 닿은 칸이 답입니다."},
    views=[
        {"id": "field", "type": "grid",
         "title": {"en": "field (tag ↖: reaches the top/left bowl, ↘: the bottom/right bowl)",
                   "ko": "field (태그 ↖: 위/왼쪽 물그릇에 닿음, ↘: 아래/오른쪽 물그릇에 닿음)"}},
        {"id": "stack", "type": "stack", "title": {"en": "stack: cells to climb from", "ko": "스택: 올라갈 칸"},
         "empty": {"en": "empty", "ko": "비어 있음"}},
        {"id": "both", "type": "output", "title": {"en": "reach both bowls", "ko": "두 물그릇에 모두 닿는 칸"},
         "empty": {"en": "none yet", "ko": "아직 없음"}},
    ],
)


def name(p):
    return f"{p[0]},{p[1]}"


def listed(cells):
    return ", ".join(f"({name(p)})" for p in cells)


def solve(field, run):
    """Solution.traceDualDrainage with a frame per step. Returns the answer as the Driver prints it."""
    rows, cols = len(field), len(field[0])
    reached = [{}, {}]   # per bowl, the cells its search reached, in order
    todo = []            # the stack, bottom first
    leaving = []         # the cells popped this frame, still drawn on top, first popped on top
    both = []

    def frame(caption, lit=(), good=(), path=(), stack_marks=None, both_marks=None, moves=None, **answer):
        tags = []
        for r in range(rows):
            for c in range(cols):
                t = "".join(BOWLS[b]["tag"] for b in (0, 1) if (r, c) in reached[b])
                if t:
                    tags.append([r, c, t])
        run.frame(caption,
                  field={"cells": field, "tags": tags,
                         "marks": {"path": [list(p) for p in path], "good": [list(p) for p in good],
                                   "lit": [list(p) for p in lit]}},
                  stack={"values": [name(p) for p in todo + leaving[::-1]], "marks": stack_marks or {}},
                  both={"values": list(both), "marks": both_marks or {}},
                  moves=moves, **answer)

    frame({"en": f"A {rows}×{cols} field. Water flows to a neighbor as high or lower, so search backwards from each "
                 f"bowl's border, climbing to neighbors as high or higher.",
           "ko": f"{rows}×{cols} 놀이판입니다. 물은 높이가 같거나 낮은 이웃으로 흐르므로, 물그릇마다 그 가장자리에서 "
                 f"거꾸로 같거나 높은 이웃으로 올라가며 찾습니다."})

    def reachable(b, starts):
        bowl = BOWLS[b]
        seen = reached[b]
        for p in starts:
            seen.setdefault(p, True)
        todo[:] = list(starts)
        s = len(starts)
        twice = [p for i, p in enumerate(starts) if p in starts[:i]]
        frame({"en": f"The {bowl['en']} bowl: its {len(seen)} border cells drain into it, so all {s} starts go on "
                     f"the stack" + (f", corner {listed(twice)} twice, as the code lists it." if twice else "."),
               "ko": f"{bowl['ko']} 물그릇: 가장자리 칸 {len(seen)}개는 바로 흘러 들어가므로 시작 칸 {s}개를 모두 "
                     f"스택에 넣습니다" + (f". 코드대로 모서리 {listed(twice)} 칸은 두 번 들어갑니다." if twice else ".")},
              good=list(seen), stack_marks={"good": list(range(s))},
              moves=[move(at("field", list(p)), at("stack", i), value=name(p)) for i, p in enumerate(starts)])

        def flush():
            """One frame for the pops in a row that reached nothing new."""
            if not leaving:
                return
            k = len(leaving)
            base = len(todo)
            end = "" if todo else {"en": f" The stack is empty: {len(seen)} cells reach the {bowl['en']} bowl.",
                                   "ko": f" 스택이 비었으므로 {len(seen)}칸이 {bowl['ko']} 물그릇에 닿습니다."}
            frame({"en": f"Pop {listed(leaving)}: no neighbor not reached yet is as high or higher, so "
                         f"{plural(k, 'it adds', 'they add')} nothing." + (end["en"] if end else ""),
                   "ko": f"{listed(leaving)} 칸을 꺼내지만 아직 닿지 않은 이웃 중 같거나 높은 칸이 없어 더할 것이 "
                         f"없습니다." + (end["ko"] if end else "")},
                  lit=list(leaving), stack_marks={"lit": list(range(base, base + k))},
                  moves=[move(at("stack", base + i)) for i in range(k)])
            leaving.clear()

        while todo:
            r, c = todo.pop()
            added = []
            for nr, nc in ((r + 1, c), (r - 1, c), (r, c + 1), (r, c - 1)):
                if (0 <= nr < rows and 0 <= nc < cols and (nr, nc) not in seen
                        and field[nr][nc] >= field[r][c]):
                    seen[(nr, nc)] = True
                    added.append((nr, nc))
            if not added:
                leaving.append((r, c))
                if not todo:
                    flush()
                continue
            for p in added:
                del seen[p]  # drawn from the frame that pops (r, c)
            todo.append((r, c))  # still on the stack while the pops before it are drawn
            flush()
            todo.pop()
            for p in added:
                seen[p] = True
            leaving.append((r, c))
            top = len(todo)
            n = len(added)
            heights = ", ".join(str(field[y][x]) for y, x in added)
            frame({"en": f"Pop ({name((r, c))}), height {field[r][c]}: {listed(added)}, height {heights}, "
                         f"{plural(n, 'is', 'are')} at least as high, so water there flows down to the "
                         f"{bowl['en']} bowl.",
                   "ko": f"높이 {field[r][c]}인 ({name((r, c))}) 칸을 꺼냅니다. {listed(added)} 칸의 높이 {heights}: "
                         f"같거나 높아서 그 물이 {bowl['ko']} 물그릇으로 흘러내립니다."},
                  lit=[(r, c)], good=added, stack_marks={"lit": [top]},
                  moves=[move(at("stack", top), at("field", list(p))) for p in added])
            leaving.clear()
            todo.extend(added)
            frame({"en": f"Push {listed(added)}, to climb on from {plural(n, 'it', 'them')}.",
                   "ko": f"{listed(added)} 칸을 스택에 넣어, 거기서 계속 올라갑니다."},
                  good=added, stack_marks={"good": list(range(top, len(todo)))},
                  moves=[move(at("field", list(p)), at("stack", top + i), value=name(p))
                         for i, p in enumerate(added)])
        return set(seen)

    top_left = reachable(0, [(0, c) for c in range(cols)] + [(r, 0) for r in range(rows)])
    bottom_right = reachable(1, [(rows - 1, c) for c in range(cols)] + [(r, cols - 1) for r in range(rows)])
    result = [[r, c] for r, c in sorted(top_left & bottom_right)]
    for r, c in result:
        both.append(name((r, c)))
    k = len(result)
    frame({"en": f"{k} {plural(k, 'cell carries', 'cells carry')} both arrows, so {plural(k, 'its', 'their')} water "
                 f"reaches both bowls.",
           "ko": f"화살표 두 개를 모두 가진 칸 {k}개는 물이 두 물그릇에 모두 닿습니다."},
          lit=[tuple(p) for p in result], both_marks={"good": list(range(k))},
          moves=[move(at("field", p), at("both", i), value=name(p)) for i, p in enumerate(result)])
    frame({"en": f"Answer: {driver_list(result)}.", "ko": f"답은 {driver_list(result)}입니다."},
          path=[tuple(p) for p in result], answer=driver_list(result))


for number, sample in enumerate(sample_cases(SLUG), start=1):
    field = json.loads(sample["input"])
    run = sample_run(wt, number, sample, input=f"field = {sample['input']}")
    solve(field, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
