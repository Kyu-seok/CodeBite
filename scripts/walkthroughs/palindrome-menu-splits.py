#!/usr/bin/env python3.12
"""palindrome-menu-splits's Walkthrough: the reference solution (scripts/replay-solutions/palindrome-menu-splits.py),
backtracking one piece per call: split_from(start) tries each piece menu[start:end], shortest first, and for each
palindrome appends it and calls split_from(end); a call at the end of the string holds one full split. The calls are
drawn as a recursion tree grown one call per frame (views.md, recursion): one node per call holding the text it still
has to split, the edge into it labelled with the piece taken, a ✓ where nothing is left; the calls still open are
shaded and each full split moves into the answer. On the menu, the letters already split are faded and the piece
checked is a span.

One frame per call. A piece that is not a palindrome is named in the caption of the next call made from the same
call, or, when no call follows, in a frame of its own where the call gives up on it and returns.

    CODEBITE_DB=<database> scripts/walkthroughs/palindrome-menu-splits.py

writes common/src/main/resources/walkthroughs/palindrome-menu-splits.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import driver_list, plural, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Tree, Walkthrough, at, move, span  # noqa: E402

SLUG = "palindrome-menu-splits"

wt = Walkthrough(
    {"en": "Palindrome Menu Splits", "ko": "팰린드롬 조각으로 쪼개기"},
    {"en": "Cut one piece per call: from where the last piece ended, try each length; a piece that reads the same "
           "backwards is kept and the rest of the string is split by the next call. Reaching the end is one full split.",
     "ko": "호출마다 조각을 하나 자릅니다. 앞 조각이 끝난 곳부터 길이를 하나씩 늘려 보고, 거꾸로 읽어도 같은 조각이면 남기고 나머지 "
           "문자열은 다음 호출이 나눕니다. 끝까지 닿으면 분할 하나가 완성됩니다."},
    views=[
        {"id": "menu", "type": "array", "title": {"en": "menu", "ko": "menu (문자열)"}},
        {"id": "calls", "type": "tree",
         "title": {"en": "calls (text left to split; ✓: none)", "ko": "호출 (나눌 남은 문자열, ✓: 없음)"}},
        {"id": "result", "type": "output", "title": {"en": "splits", "ko": "분할"},
         "empty": {"en": "none yet", "ko": "아직 없음"}},
    ],
)


def quoted(pieces):
    return ", ".join(f'"{p}"' for p in pieces)


def solve(menu, run):
    """Solution.splitMirrorPhrases with a frame per call and per call giving up. Returns the answer as the Driver
    prints it."""
    tree, splits, open_calls, full = Tree(), [], [], []
    pieces = []

    def frame(caption, lit=None, start=None, piece=None, piece_mark=None, moves=None, done=False, **answer):
        spans = {}
        if piece is not None:
            spans["piece"] = span(piece[0], piece[1] - 1, {"en": "piece", "ko": "조각"}, mark=piece_mark)
        run.frame(caption,
                  menu={"values": list(menu), "marks": {} if done else
                        {"dim": list(range(start)), **({piece_mark: list(range(*piece))} if piece and piece_mark else {})},
                        "pointers": {"start": start} if not done and start < len(menu) else {},
                        "spans": spans},
                  calls={**tree.state(), "nodeMarks": {"path": list(full)} if done else {"good": list(full), "lit": [lit]},
                         "shade": [] if done else list(open_calls)},
                  result={"values": [driver_list(s) for s in splits],
                          "marks": {"path": list(range(len(splits)))} if done else
                          {"good": [len(splits) - 1]} if any(m.get("to", {}).get("view") == "result" for m in moves or [])
                          else {}},
                  moves=moves, **answer)

    def split_from(start, parent, prev_start, rejected):
        """`prev_start` is where the piece taken into this call began; `rejected` the pieces the caller checked and
        dropped since its last call."""
        node = tree.add(menu[start:] or "✓", parent=parent, label=None if parent is None else pieces[-1])
        open_calls.append(node)
        if parent is None:
            moves = [move(dst=at("calls", node))]
            head = {"en": f"split_from(0) has all of \"{menu}\" to split; it tries pieces from index 0, shortest first.",
                    "ko": f"split_from(0) 호출은 \"{menu}\" 전체를 나눠야 하므로 0번 칸부터 짧은 조각 순으로 시도합니다."}
            piece = None
        else:
            moves = [move(at("menu", prev_start), at("calls", node), value=pieces[-1])]
            piece = (prev_start, start)
            no = ({"en": f"{quoted(rejected)} {plural(len(rejected), 'is not a palindrome', 'are not palindromes')}; "
                         f"\"{pieces[-1]}\" is",
                   "ko": f"{quoted(rejected)} 조각은 팰린드롬이 아니고, "} if rejected else
                  {"en": f"\"{pieces[-1]}\" is a palindrome", "ko": ""})
            head = {"en": no["en"] + f", so take it: split_from({start}) "
                    + (f"has \"{menu[start:]}\" left." if start < len(menu) else "is at the end."),
                    "ko": no["ko"] + f"\"{pieces[-1]}\" 조각은 팰린드롬이니 자릅니다. split_from({start}) 호출에는 "
                    + (f"\"{menu[start:]}\" 문자열이 남았습니다." if start < len(menu) else
                       f"남은 글자가 없으므로 분할 {driver_list(pieces)} 완성, 답에 넣습니다.")}
        if start == len(menu):
            splits.append(pieces.copy())
            full.append(node)
            moves.append(move(at("calls", node), at("result", len(splits) - 1)))
            frame({"en": head["en"][:-1] + f", so {driver_list(pieces)} is a full split: it goes into the answer.",
                   "ko": head["ko"]},
                  node, start, piece, "good", moves)
            open_calls.pop()
            return
        frame(head, node, start, piece, "good" if piece else None, moves)
        dropped = []
        for end in range(start + 1, len(menu) + 1):
            piece_text = menu[start:end]
            if piece_text == piece_text[::-1]:
                pieces.append(piece_text)
                split_from(end, node, start, dropped)
                pieces.pop()
                dropped = []
            else:
                dropped.append(piece_text)
        if dropped:
            frame({"en": f"Back in split_from({start}): {quoted(dropped)} "
                         f"{plural(len(dropped), 'is not a palindrome', 'are not palindromes')}, and no longer piece is left, so the call returns.",
                   "ko": f"split_from({start}) 호출로 돌아왔습니다. {quoted(dropped)} 조각은 팰린드롬이 아니고 더 긴 "
                         f"조각이 없으므로 돌아갑니다."},
                  node, start, (start, len(menu)), "bad")
        open_calls.pop()

    split_from(0, None, None, [])
    printed = json.dumps(sorted(splits), separators=(",", ":"))
    n = len(splits)
    frame({"en": f"Every call has returned: {n} {plural(n, 'split', 'splits')} of \"{menu}\" into palindromes, one per ✓ "
                 f"in the tree.",
           "ko": f"모든 호출이 끝났습니다. \"{menu}\" 문자열을 팰린드롬으로 나누는 분할은 {n}가지이고, 트리의 ✓ 하나가 분할 "
                 f"하나입니다."},
          done=True, answer=printed)
    return printed


for number, sample in enumerate(sample_cases(SLUG), start=1):
    menu = sample["input"].strip()
    run = sample_run(wt, number, sample, input=f'menu = "{menu}"')
    solve(menu, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
