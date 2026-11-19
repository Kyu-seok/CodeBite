#!/usr/bin/env python3.12
"""find-menu-price's Walkthrough: the reference solution (scripts/replay-solutions/find-menu-price.py), one
binary search over the menu read row by row as a single sorted list, recording one frame per probe of mid
on each sample Test Case. The list is an array of indices 0..m*n-1 with the search range a faded span and
low/mid/high pointers; the grid beside it, drawn as the description's Diagram, lights the cell index mid
lands on, row mid // n and column mid % n, and fades the cells out of the range.

    CODEBITE_DB=<database> scripts/walkthroughs/find-menu-price.py

writes common/src/main/resources/walkthroughs/find-menu-price.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import josa, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move, span  # noqa: E402

SLUG = "find-menu-price"

wt = Walkthrough(
    {"en": "Find the Menu Price", "ko": "메뉴판에서 가격 찾기"},
    {"en": "Binary search over one sorted list: read row by row, the menu is ascending, so index i stands for "
           "row i // n and column i % n, and a binary search over i = 0..m·n − 1 throws away half the cells "
           "with each probe.",
     "ko": "하나로 이어진 정렬 목록 위의 이분 탐색입니다. 행을 차례로 이어 읽으면 메뉴판은 오름차순이므로, 인덱스 i는 "
           "i // n행, i % n열을 가리키고, i = 0..m·n − 1 위에서 이분 탐색하면 한 번 볼 때마다 칸이 절반으로 줄어듭니다."},
    views=[
        {"id": "flat", "type": "array",
         "title": {"en": "menu read row by row (index i)", "ko": "행을 이어 읽은 menu (인덱스 i)"}},
        {"id": "menu", "type": "grid",
         "title": {"en": "menu (faded: out of range)", "ko": "menu (메뉴판, 흐림: 범위 밖)"}},
        {"id": "state", "type": "vars"},
    ],
)


def solve(menu, target, run):
    """Solution.hasPrice with a frame per probe. Returns the answer as the Driver prints it."""
    rows, cols = len(menu), len(menu[0])
    flat = [v for row in menu for v in row]
    n = len(flat)
    low, high = 0, n - 1
    mid = None

    def frame(caption, kept=None, path=(), done=False, moves=None, **answer):
        spans = {}
        if low <= high and not done:
            spans["range"] = span(low, high, {"en": f"range {high - low + 1}", "ko": f"범위 {high - low + 1}"},
                                  fade=True)
        if kept:
            spans["kept"] = span(kept[0], kept[1], {"en": "kept", "ko": "남김"}, below=True, mark="good")
        if done and path:
            pointers = {}
        elif done:
            pointers = {"high": high if high >= 0 else None, "low": low if low < n else None}
        else:
            pointers = {"low": low, "mid": mid, "high": high}
        lit = [] if done or mid is None else [mid]
        if done and not path:
            lit = [i for i in (high, low) if 0 <= i < n]
        in_range = [] if done else list(range(low, high + 1))
        cell = lambda i: [i // cols, i % cols]  # noqa: E731
        run.frame(caption,
                  flat={"values": flat, "pointers": pointers, "spans": spans,
                        "marks": {"lit": lit, "path": list(path),
                                  "dim": [i for i in range(n) if i not in lit] if done and not path else []}},
                  menu={"cells": menu,
                        "tags": [cell(i) + ["mid"] for i in lit] if not done else [],
                        "marks": {"lit": [cell(i) for i in lit], "path": [cell(i) for i in path],
                                  "dim": [cell(i) for i in range(n) if i not in in_range and i not in lit
                                          and i not in path]}},
                  state={"items": [{"label": {"en": "target", "ko": "target (목표)"}, "value": target}]},
                  moves=moves, **answer)

    frame({"en": f"Look for {target} in a {rows} × {cols} menu: read row by row it is one sorted list of {n} "
                 f"prices, so the range starts as indices low = 0 to high = {n - 1}.",
           "ko": f"{rows} × {cols} 메뉴판에서 가격 {josa(target, '을를')} 찾습니다. 행을 이어 읽으면 가격 {n}개의 정렬 목록 하나이므로, "
                 f"범위는 처음에 인덱스 전체입니다: low = 0, high = {n - 1}."})
    while low <= high:
        mid = (low + high) // 2
        r, c = mid // cols, mid % cols
        value = menu[r][c]
        read = [move(at("flat", mid), at("menu", [r, c]), value=f"[{r}][{c}]")]
        where_en = f"mid = ({low} + {high}) // 2 = {mid} is row {mid} // {cols} = {r}, column {mid} % {cols} = {c}"
        where_ko = f"mid = ({low} + {high}) // 2 = {mid}: {mid} // {cols} = {r}행, {mid} % {cols} = {c}열"
        if value == target:
            frame({"en": f"{where_en}, and menu[{r}][{c}] = {value} is target: the menu has it, true.",
                   "ko": f"{where_ko}, menu[{r}][{c}] = {value}: target과 같습니다. 메뉴판에 있으니 답은 true입니다."},
                  path=[mid], done=True, moves=read, answer="true")
            return
        old_low, old_high = low, high
        if value < target:
            low = mid + 1
            kept = (low, old_high) if low <= old_high else None
            en = f"{where_en}: {value} < {target}, so target can only be after it: low = {low}."
            ko = f"{where_ko}: {value} < {target}, 그러니 target은 그 뒤에만 있을 수 있습니다. low = {low}."
        else:
            high = mid - 1
            kept = (old_low, high) if old_low <= high else None
            en = f"{where_en}: {value} > {target}, so target can only be before it: high = {high}."
            ko = f"{where_ko}: {value} > {target}, 그러니 target은 그 앞에만 있을 수 있습니다. high = {high}."
        # the frame shows the range this probe split, before it shrinks
        new_low, new_high = low, high
        low, high = old_low, old_high
        frame({"en": en, "ko": ko}, kept=kept, moves=read)
        low, high = new_low, new_high
    mid = None
    between_en = (f" ({target} would sit between {flat[high]} and {flat[low]})" if 0 <= high and low < n else "")
    between_ko = (f"(있다면 {flat[high]}, {flat[low]} 사이에 옵니다) " if 0 <= high and low < n else "")
    frame({"en": f"low = {low} passed high = {high}, so the range is empty: no cell holds {target}{between_en}. "
                 f"The answer is false.",
           "ko": f"low = {low}, high = {high}: low가 high를 지나쳐 범위가 비었습니다. {josa(target, '이가')} 적힌 칸이 없으니"
                 f"{' ' if between_ko else ' '}{between_ko}답은 false입니다."},
          done=True, answer="false")


for number, sample in enumerate(sample_cases(SLUG), start=1):
    lines = sample["input"].split("\n")
    menu, target = json.loads(lines[0]), int(lines[1])
    run = sample_run(wt, number, sample, input=f"menu = {lines[0].strip()}, target = {target}")
    solve(menu, target, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
