#!/usr/bin/env python3.12
"""match-dot-star-pattern's Walkthrough: the reference solution (scripts/replay-solutions/match-dot-star-pattern.py),
the memoised recursion matches(i, j), whether p[j:] matches all of s[i:], recording a frame when a call starts and
when it returns, on each sample Test Case.

Every sample makes 10 calls or fewer, so the recursion is a tree (views.md, Recursion), one node per call holding the
rest of s and the rest of p, the edge into it naming the choice (`b* → ∅` skips a starred piece, `b* → b` lets it take
one more letter, `x → x` matches one letter). Beside it is the memo, the 2D table @cache keeps: a grid of s positions
(rows) by p positions (columns), headed by the letter there (∅ past the end), each call's result moving into its cell
as it returns.

    CODEBITE_DB=<database> scripts/walkthroughs/match-dot-star-pattern.py

writes common/src/main/resources/walkthroughs/match-dot-star-pattern.json.
"""
import os
import string
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Tree, Walkthrough, at, move  # noqa: E402

SLUG = "match-dot-star-pattern"
EMPTY, CORNER, UNSET, YES, NO = "∅", "", " ", "T", "F"
LETTER = {"tone": "a"}

wt = Walkthrough(
    {"en": "Match Dot-Star Pattern", "ko": "점·별 패턴 매칭"},
    {"en": "matches(i, j) asks whether the rest of the pattern matches the rest of s. A piece followed by * either "
           "matches nothing (skip it) or takes one letter and stays; any other piece must take exactly one letter. "
           "Each answer is kept in a table, so no call is worked out twice.",
     "ko": "matches(i, j)는 패턴의 나머지가 s의 나머지 전체와 맞는지 묻습니다. *가 붙은 조각은 아무것도 맞추지 않고 "
           "건너뛰거나, 한 글자를 먹고 그대로 남습니다. 다른 조각은 정확히 한 글자를 맞춰야 합니다. 답은 표에 저장해 "
           "같은 호출을 두 번 계산하지 않습니다."},
    views=[
        {"id": "calls", "type": "tree", "title": {"en": "calls: rest of s ~ rest of p", "ko": "호출: s의 나머지 ~ p의 나머지"}},
        {"id": "memo", "type": "grid",
         "title": {"en": "memo: matches(i, j), s position (rows) × p position (columns)",
                   "ko": "메모: matches(i, j), s 위치(행) × p 위치(열)"},
         "values": {**{ch: LETTER for ch in string.ascii_lowercase + ".*"}, EMPTY: LETTER,
                    YES: {"glyph": "✓", "tone": "c"}, NO: {"glyph": "✗", "tone": "plain"},
                    CORNER: {"glyph": "", "tone": "plain"}, UNSET: {"glyph": "", "tone": "empty"}}},
    ],
)


def solve(s, p, run):
    """Solution.isMatch with a frame per call started and returned. Returns the answer as the Driver prints it.
    matches(i, j) is grid cell (i + 1, j + 1)."""
    grid = [[CORNER] + list(p) + [EMPTY]] + [[ch] + [UNSET] * (len(p) + 1) for ch in s]
    grid.append([EMPTY] + [UNSET] * (len(p) + 1))
    tree = Tree()
    memo, tags, results = {}, [], {}  # results: node -> (i, j, bool)
    open_calls = []

    def rest(text, k):
        return text[k:] or EMPTY

    def frame(caption, lit=None, marks=None, memo_marks=None, moves=None, **answer):
        node_marks = dict(marks or {})
        if lit is not None:
            node_marks["lit"] = [lit]
        run.frame(caption, calls={**tree.state(), "nodeMarks": node_marks, "shade": list(open_calls), "tags": tags},
                  memo={"cells": grid, "marks": memo_marks or {}}, moves=moves, **answer)

    def finish(node, i, j, result, caption, moves):
        memo[(i, j)] = result
        results[node] = (i, j, result)
        grid[i + 1][j + 1] = YES if result else NO
        tags.append([node, "✓" if result else "✗"])
        frame(caption, lit=node, marks={"good" if result else "bad": [node]},
              memo_marks={"good" if result else "bad": [[i + 1, j + 1]]},
              moves=moves + [move(at("calls", node), at("memo", [i + 1, j + 1]), value="✓" if result else "✗")])
        open_calls.remove(node)
        return result

    def matches(i, j, parent=None, label=None):
        node = tree.add(f"{rest(s, i)} ~ {rest(p, j)}", parent=parent, label=label)
        open_calls.append(node)
        came = [move(at("calls", parent), at("calls", node)) if parent is not None else move(None, at("calls", node))]
        if (i, j) in memo:
            r = memo[(i, j)]
            return finish(node, i, j, r, {"en": f"matches({i}, {j}) is already in the memo: {'✓' if r else '✗'}.",
                                          "ko": f"matches({i}, {j}): 이미 메모에 있습니다: {'✓' if r else '✗'}."},
                          came)
        if j == len(p):
            r = i == len(s)
            if r:
                cap = {"en": f"matches({i}, {j}): the pattern and s are both used up, so they match: ✓.",
                       "ko": f"matches({i}, {j}): 패턴과 s를 모두 다 썼으므로 맞습니다: ✓."}
            else:
                cap = {"en": f"matches({i}, {j}): the pattern is used up but \"{s[i:]}\" is left over: ✗.",
                       "ko": f"matches({i}, {j}): 패턴은 다 썼는데 s에 \"{s[i:]}\" 부분이 남았습니다: ✗."}
            return finish(node, i, j, r, cap, came)
        piece = p[j]
        here_en = "the end of s" if i == len(s) else f"'{s[i]}'"
        here_ko = "s의 끝" if i == len(s) else f"글자 '{s[i]}'"
        first = i < len(s) and piece in (s[i], ".")
        if j + 1 < len(p) and p[j + 1] == "*":
            frame({"en": f"matches({i}, {j}): \"{s[i:]}\" against \"{p[j:]}\". '{piece}*' may match nothing, so first "
                         "try skipping it.",
                   "ko": f"matches({i}, {j}): \"{s[i:]}\" 대 \"{p[j:]}\". '{piece}*' 조각은 아무것도 맞추지 않을 수 "
                         "있으므로 먼저 건너뛰어 봅니다."},
                  lit=node, memo_marks={"lit": [[i + 1, 0], [0, j + 1], [0, j + 2]]}, moves=came)
            child = len(tree.nodes)
            if matches(i, j + 2, node, f"{piece}* → ∅"):
                return finish(node, i, j, True, {"en": f"matches({i}, {j}): skipping '{piece}*' worked: ✓.",
                                                 "ko": f"matches({i}, {j}): '{piece}*' 조각을 건너뛰니 맞았습니다: ✓."},
                              [move(at("calls", child), at("calls", node), value="✓")])
            if not first:
                return finish(node, i, j, False,
                              {"en": f"matches({i}, {j}): skipping failed, and '{piece}*' can't take {here_en}: ✗.",
                               "ko": f"matches({i}, {j}): 건너뛰기는 실패했고, '{piece}*' 조각은 {here_ko}에 맞지 "
                                     "않습니다: ✗."},
                              [move(at("calls", child), at("calls", node), value="✗")])
            frame({"en": f"matches({i}, {j}): skipping failed, but '{piece}*' can take '{s[i]}' and stay for the next "
                         "letter.",
                   "ko": f"matches({i}, {j}): 건너뛰기는 실패했지만 '{piece}*' 조각은 글자 '{s[i]}' 하나를 먹고 그대로 "
                         "남을 수 있습니다."},
                  lit=node, memo_marks={"lit": [[i + 1, 0], [0, j + 1]]})
            child = len(tree.nodes)
            r = matches(i + 1, j, node, f"{piece}* → {s[i]}")
            return finish(node, i, j, r, {"en": f"matches({i}, {j}) takes its answer from '{piece}*' taking '{s[i]}': "
                                                f"{'✓' if r else '✗'}.",
                                          "ko": f"matches({i}, {j})의 답은 '{piece}*' 조각이 글자 '{s[i]}' 하나를 "
                                                f"먹은 결과입니다: {'✓' if r else '✗'}."},
                          [move(at("calls", child), at("calls", node), value="✓" if r else "✗")])
        if not first:
            return finish(node, i, j, False,
                          {"en": f"matches({i}, {j}): '{piece}' must take exactly one letter, but it can't match "
                                 f"{here_en}: ✗.",
                           "ko": f"matches({i}, {j}): '{piece}' 조각은 정확히 한 글자를 맞춰야 하는데 {here_ko}에 맞지 "
                                 "않습니다: ✗."},
                          came)
        frame({"en": f"matches({i}, {j}): '{piece}' matches '{s[i]}', so move on in both.",
               "ko": f"matches({i}, {j}): '{piece}' 조각이 글자 '{s[i]}'에 맞으므로 둘 다 한 칸씩 나아갑니다."},
              lit=node, memo_marks={"lit": [[i + 1, 0], [0, j + 1]]}, moves=came)
        child = len(tree.nodes)
        r = matches(i + 1, j + 1, node, f"{piece} → {s[i]}")
        return finish(node, i, j, r, {"en": f"matches({i}, {j}) passes on what the rest returned: {'✓' if r else '✗'}.",
                                      "ko": f"matches({i}, {j}): 나머지의 결과를 그대로 돌려줍니다: "
                                            f"{'✓' if r else '✗'}."},
                      [move(at("calls", child), at("calls", node), value="✓" if r else "✗")])

    frame({"en": f"Match s = \"{s}\" against p = \"{p}\", starting from matches(0, 0), the whole of both. The memo is "
                 "empty.",
           "ko": f"s = \"{s}\", p = \"{p}\": 둘 전체를 보는 matches(0, 0)부터 시작합니다. 메모는 비어 있습니다."})
    answer = matches(0, 0)
    # the answer's path: from the root down through the calls whose result decided it
    path, cells, node = [], [], 0
    while True:
        i, j, r = results[node]
        path.append(node)
        cells.append([i + 1, j + 1])
        kids = [e["to"] for e in tree.edges if e["from"] == node]
        deciding = [k for k in kids if results[k][2] == r]
        if not deciding:
            break
        node = deciding[-1] if not r else deciding[0]
    text = "true" if answer else "false"
    frame({"en": f"matches(0, 0) is {'✓' if answer else '✗'}: the pattern {'matches' if answer else 'does not match'} "
                 f"all of s. Answer: {text}.",
           "ko": f"matches(0, 0)의 결과가 {'✓' if answer else '✗'}이므로 패턴이 s 전체와 {'맞습니다' if answer else '맞지 않습니다'}. "
                 f"답은 {text}입니다."},
          marks={"path": path}, memo_marks={"path": cells}, answer=text)


for number, sample in enumerate(sample_cases(SLUG), start=1):
    s, p = sample["input"].split("\n")
    run = sample_run(wt, number, sample, input=f"s = \"{s}\", p = \"{p}\"")
    solve(s, p, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
