#!/usr/bin/env python3.12
"""list-bracket-pairings's Walkthrough: the reference solution
(scripts/replay-solutions/list-bracket-pairings.py), backtracking one bracket per call: build(opened, closed) adds
"(" while opened < pairCount and ")" while closed < opened, and a full prefix is a well-formed string. pairCount = 4
makes 64 calls, too many to draw as a tree, so the call stack stands beside the prefix (views.md, recursion): one
card per open call, each bracket moving from its call into the prefix.

One frame per call made, one per string found, and one per return to a call that then tries ")": the calls that
returned leave together in that frame, their brackets dropped from the prefix.

    CODEBITE_DB=<database> scripts/walkthroughs/list-bracket-pairings.py

writes common/src/main/resources/walkthroughs/list-bracket-pairings.json.
"""
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import driver_list, plural, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, call, move  # noqa: E402

SLUG = "list-bracket-pairings"

wt = Walkthrough(
    {"en": "List Bracket Pairings", "ko": "괄호 짝 만들기"},
    {"en": "Build each string one bracket per call: add ( while fewer than pairCount are open, add ) while fewer "
           "are closed than opened, and keep the prefix when it is full. Each call tries ( first, then ).",
     "ko": "호출마다 괄호를 하나씩 붙입니다. 연 괄호가 pairCount보다 적으면 ( 괄호를, 닫은 괄호가 연 괄호보다 적으면 ) 괄호를 "
           "붙이고, 접두사가 다 차면 답에 넣습니다. 호출마다 ( 괄호를 먼저, 그다음 ) 괄호를 시도합니다."},
    views=[
        {"id": "prefix", "type": "array", "title": {"en": "prefix", "ko": "prefix (접두사)"}},
        {"id": "calls", "type": "callstack", "title": {"en": "call stack", "ko": "호출 스택"}},
        {"id": "result", "type": "output", "title": {"en": "sequences", "ko": "sequences (만든 문자열)"},
         "empty": {"en": "none yet", "ko": "아직 없음"}},
    ],
)


def solve(pair_count, run):
    """Solution.listBracketPairings with a frame per call, per string found and per return to a call that tries
    ")". Returns the answer as the Driver prints it."""
    size = 2 * pair_count
    prefix = []
    cards = []  # (opened, closed) per open call, bottom first
    sequences = []

    def frame(caption, prefix_marks=None, call_marks=None, leaving=0, result_marks=None, moves=None, **answer):
        run.frame(caption,
                  prefix={"values": prefix + [""] * (size - len(prefix)),
                          "unread": list(range(len(prefix), size)), "marks": prefix_marks or {}},
                  calls={"calls": [call("build", opened=o, closed=c) for o, c in cards],
                         "marks": {**(call_marks or {}),
                                   **({"dim": list(range(len(cards) - leaving, len(cards)))} if leaving else {})}},
                  result={"values": list(sequences), "marks": result_marks or {}},
                  moves=moves, **answer)

    def unwind(depth):
        """Drop the brackets from `depth` on, each leaving its cell with a move out in this frame; the calls above
        `depth` stay drawn this frame (the caller deletes them after it)."""
        gone = len(cards) - depth - 1
        moves = [move(at("prefix", k), value=prefix[k]) for k in range(depth, len(prefix))]
        emptied = list(range(depth, len(prefix)))
        del prefix[depth:]
        return gone, moves, emptied

    def add(bracket, why):
        o, c = cards[-1]
        depth = len(cards) - 1
        prefix.append(bracket)
        child = (o + 1, c) if bracket == "(" else (o, c + 1)
        cards.append(child)
        frame({"en": f"{why['en']}: add {bracket} and call build(opened={child[0]}, closed={child[1]}).",
               "ko": f"{why['ko']} {bracket} 괄호를 붙이고 다음 호출 build(opened={child[0]}, closed={child[1]})에 넘깁니다."},
              prefix_marks={"good": [len(prefix) - 1]}, call_marks={"lit": [depth + 1]},
              moves=[move(at("calls", depth), at("prefix", len(prefix) - 1), value=bracket),
                     move(at("prefix", len(prefix) - 1), at("calls", depth + 1),
                          value=f"{child[0]},{child[1]}")])

    def build(opened, closed):
        depth = len(cards) - 1
        if len(prefix) == size:
            text = "".join(prefix)
            sequences.append(text)
            frame({"en": f"The prefix is full, {size} brackets: {text} is well-formed, so it goes into the list.",
                   "ko": f"접두사가 괄호 {size}개로 다 찼습니다. {text} 문자열은 올바르므로 목록에 넣습니다."},
                  prefix_marks={"good": list(range(size))}, call_marks={"good": [depth]},
                  result_marks={"good": [len(sequences) - 1]},
                  moves=[move(at("calls", depth), at("result", len(sequences) - 1), value=text)])
            return
        before = len(sequences)
        tried_open = False
        if opened < pair_count:
            add("(", {"en": f"opened {opened} < pairCount {pair_count}",
                      "ko": f"opened {opened} < pairCount {pair_count}이므로"})
            build(opened + 1, closed)
            tried_open = True
        if closed < opened:
            if tried_open:
                found = len(sequences) - before
                gone, moves, emptied = unwind(depth)
                frame({"en": f"build(opened={opened}, closed={closed}) is back from its ( branch with {found} "
                             f"{plural(found, 'string', 'strings')} found; now closed {closed} < opened {opened}, so it "
                             f"tries ).",
                       "ko": f"build(opened={opened}, closed={closed}) 호출이 ( 쪽 호출에서 문자열 {found}개를 찾고 "
                             f"돌아왔습니다. 이제 closed {closed} < opened {opened}이므로 ) 괄호를 시도합니다."},
                      prefix_marks={"bad": emptied}, call_marks={"lit": [depth]}, leaving=gone, moves=moves)
                del cards[depth + 1:]
            add(")", {"en": f"closed {closed} < opened {opened}",
                      "ko": f"closed {closed} < opened {opened}이므로"})
            build(opened, closed + 1)

    cards.append((0, 0))
    frame({"en": f"pairCount = {pair_count}: strings of {size} brackets. The first call, build(opened=0, closed=0), "
                 f"starts from an empty prefix.",
           "ko": f"pairCount = {pair_count}: 괄호 {size}개짜리 문자열을 만듭니다. 첫 호출인 "
                 f"build(opened=0, closed=0)에서 빈 접두사로 시작합니다."},
          call_marks={"lit": [0]}, moves=[move(dst=at("calls", 0))])
    build(0, 0)
    k = len(sequences)
    printed = driver_list(sorted(sequences))
    _, moves, emptied = unwind(0)
    gone = len(cards)
    frame({"en": f"Every call has returned: {k} well-formed {plural(k, 'string', 'strings')}, already in sorted order "
                 f"since each call tries ( before ).",
           "ko": f"모든 호출이 끝났습니다. 올바른 문자열은 {k}개이고, 호출마다 ( 괄호를 ) 괄호보다 먼저 시도했으므로 이미 정렬된 "
                 f"순서입니다."},
          leaving=gone, prefix_marks={"bad": emptied},
          result_marks={"path": list(range(k))}, moves=moves, answer=printed)
    return printed


for number, sample in enumerate(sample_cases(SLUG), start=1):
    pair_count = int(sample["input"])
    run = sample_run(wt, number, sample, input=f"pairCount = {pair_count}")
    solve(pair_count, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
