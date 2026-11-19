#!/usr/bin/env python3.12
"""word-search-ii's Walkthrough: the reference solution (scripts/replay-solutions/word-search-ii.py), a trie of every
word walked in step with a depth-first search over the board: search(r, c, parent) steps onto a cell whose letter is a
child of the trie node it came from, takes the word that ends there, and goes on to each neighbour whose letter is a
child of the new node. A cell on the current path is marked "#" so it isn't reused, and a trie node left empty when
its call returns is pruned, so a word is found once and a finished branch is never walked again.

The recursion walks the trie and the board, so they are the drawing (views.md, recursion): the current cell and trie
node lit, the open calls shaded on both. One frame per word inserted, one per cell stepped onto, and one per run of
calls returning together (a dead end, or the walk backing out after a word), not per neighbour checked.

    CODEBITE_DB=<database> scripts/walkthroughs/word-search-ii.py

writes common/src/main/resources/walkthroughs/word-search-ii.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import driver_list, plural, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Tree, Walkthrough, at, move  # noqa: E402

SLUG = "word-search-ii"

wt = Walkthrough(
    {"en": "Word Search II", "ko": "단어 찾기 II"},
    {"en": "Put every word in a trie, then walk the board depth-first from each cell, stepping only onto a neighbour "
           "whose letter is a child of the current trie node: one walk checks every word at once. A word found is taken "
           "out of the trie, and a node left empty is pruned.",
     "ko": "모든 단어를 트라이에 넣고, 칸마다 깊이 우선으로 보드를 걸으며 현재 트라이 노드의 자식 글자인 이웃 칸으로만 "
           "이동합니다. 한 번의 탐색으로 모든 단어를 함께 확인합니다. 찾은 단어는 트라이에서 빼고, 비게 된 노드는 잘라 냅니다."},
    views=[
        {"id": "board", "type": "grid"},
        {"id": "trie", "type": "tree",
         "title": {"en": "trie (a word sits on the node where it ends)", "ko": "트라이 (단어는 끝나는 노드에 있음)"}},
        {"id": "words", "type": "table", "title": {"en": "words", "ko": "words (단어 목록)"}},
        {"id": "result", "type": "output", "title": {"en": "found", "ko": "찾은 단어"},
         "empty": {"en": "none yet", "ko": "아직 없음"}},
    ],
)


def cell(r, c):
    return f"({r},{c})"


def listed(items, ko=False):
    """'a', 'b' and 'c' (English) or 'a', 'b', 'c' (Korean)."""
    items = list(items)
    if ko or len(items) < 2:
        return ", ".join(items)
    return ", ".join(items[:-1]) + " and " + items[-1]


def solve(board, words, run):
    """Solution.findWords with a frame per word inserted, per cell stepped onto and per run of returns. Returns the
    answer as the Driver prints it."""
    rows, cols = len(board), len(board[0])
    letters = [row[:] for row in board]  # drawn: a cell on the path keeps its letter, shaded, not its "#"
    tree = Tree()
    ids = {}            # id(dict node) -> the trie view's node id
    gone = set()        # trie node ids pruned
    trie = {}
    ids[id(trie)] = tree.add(None)
    found = []
    path = []           # open calls: (r, c, trie node id)
    table_rows = [{"label": str(i), "cells": [w]} for i, w in enumerate(words)]

    def trie_state():
        state = tree.state()
        state["nodes"] = [n for n in state["nodes"] if n["id"] not in gone]
        state["edges"] = [e for e in state["edges"] if e["to"] not in gone]
        return state

    def frame(caption, lit_cell=None, lit_node=None, cell_marks=None, node_marks=None, word_marks=None,
              leaving=(), moves=None, done=False, **answer):
        marks = {k: list(v) for k, v in (cell_marks or {}).items()}
        if lit_cell is not None:
            marks.setdefault("lit", []).append(list(lit_cell))
        nmarks = {k: list(v) for k, v in (node_marks or {}).items()}
        if lit_node is not None:
            nmarks.setdefault("lit", []).append(lit_node)
        open_cells = [[r, c] for r, c, _ in path] + [[r, c] for r, c, _ in leaving]
        open_nodes = [ids[id(trie)]] + [t for _, _, t in path] + [t for _, _, t in leaving] if path or leaving else []
        run.frame(caption,
                  board={"cells": [row[:] for row in letters], "marks": marks, "shade": [] if done else open_cells},
                  trie={**trie_state(), "nodeMarks": nmarks, "shade": [] if done else open_nodes},
                  words={"rows": table_rows, "marks": word_marks or {}},
                  result={"values": list(found),
                          "marks": {"path": list(range(len(found)))} if done else
                          {"good": [len(found) - 1]} if any(m.get("to", {}).get("view") == "result" for m in moves or [])
                          else {}},
                  moves=moves, **answer)

    frame({"en": f"A {rows}×{cols} board and {len(words)} {plural(len(words), 'word', 'words')}. First, every word goes "
                 f"into a trie, which starts as just its root.",
           "ko": f"{rows}×{cols} 보드와 단어 {len(words)}개가 있습니다. 먼저 루트만 있는 트라이에 모든 단어를 넣습니다."},
          lit_node=ids[id(trie)])

    for w, word in enumerate(words):
        node, made, shared = trie, [], []
        moves = []
        for k, letter in enumerate(word):
            if letter in node:
                node = node[letter]
                shared.append(ids[id(node)])
                continue
            parent = ids[id(node)]
            node = node.setdefault(letter, {})
            ids[id(node)] = tree.add(None, parent=parent, label=letter)
            made.append(ids[id(node)])
            moves.append(move(at("words", [w, 0]), at("trie", ids[id(node)]),
                              value=word if k == len(word) - 1 else letter))
        node["$"] = word
        tree.set(ids[id(node)], word)
        if not made:
            moves.append(move(at("words", [w, 0]), at("trie", ids[id(node)]), value=word))
        prefix = word[:len(shared)]
        frame({"en": f'Insert "{word}": ' + (f'the path for "{prefix}" is already there, so it adds only '
                                              f'"{word[len(shared):]}"' if shared else "every letter gets a new node")
                     + ", and the word sits on its last node.",
               "ko": f'"{word}" 단어를 넣습니다. ' + (f'"{prefix}" 경로는 이미 있으니 "{word[len(shared):]}" 부분만 새로 '
                                                    f"만들고" if shared else "글자마다 노드를 새로 만들고")
                     + ", 단어를 마지막 노드에 둡니다."},
              node_marks={"good": made + ([ids[id(node)]] if not made else []), "lit": shared},
              word_marks={"lit": [[w, 0]]}, moves=moves)

    nodes_by_id = {}    # trie view id -> the dict node, for a dead end's caption
    returns = []        # calls that returned since the last frame: (r, c, node id, pruned, found anything)

    def flush_returns():
        if not returns:
            return
        leaving = [(r, c, t) for r, c, t, _, _ in returns]
        pruned = [t for _, _, t, p, _ in returns if p]
        dead = [[r, c] for r, c, _, _, f in returns if not f]
        names = [f"'{letters[r][c]}' {cell(r, c)}" for r, c, _, _, _ in returns]
        back = path[-1] if path else None
        to = ({"en": f" back at the call on '{letters[back[0]][back[1]]}' {cell(back[0], back[1])}",
               "ko": f" '{letters[back[0]][back[1]]}' {cell(back[0], back[1])} 칸의 호출로 돌아갑니다"} if back else
              {"en": " back at the scan", "ko": " 칸 훑기로 돌아갑니다"})
        if len(returns) == 1:
            who = {"en": f"The call on {names[0]} returns", "ko": f"{names[0]} 칸의 호출이 끝나고"}
        else:
            who = {"en": f"The calls on {listed(names)} return in turn",
                   "ko": f"{listed(names, ko=True)} 칸의 호출이 차례로 끝나고"}
        r0, c0, t0, _, f0 = returns[0]
        need = sorted(k for k in nodes_by_id[t0] if k != "$")
        if not f0 and need:
            needs = " or ".join(f"'{k}'" for k in need)
            why = {"en": f" (no neighbour of {cell(r0, c0)} holds {needs})",
                   "ko": f"{cell(r0, c0)} 칸의 이웃에 {' 또는 '.join(chr(39) + k + chr(39) for k in need)} 글자가 없어 "}
        else:
            why = {"en": "", "ko": ""}
        if pruned:
            cut = {"en": f"; {len(pruned)} trie {plural(len(pruned), 'node is', 'nodes are')} left with no word and no "
                         f"child, so pruned.",
                   "ko": f". 단어도 자식도 없이 남은 트라이 노드 {len(pruned)}개는 잘라 냅니다."}
        else:
            cut = {"en": ".", "ko": "."}
        frame({"en": who["en"] + why["en"] + ", " + plural(len(returns), "clearing", "each clearing") + " its \"#\", and the walk is"
                     + to["en"] + cut["en"],
               "ko": why["ko"] + who["ko"] + " \"#\" 표시를 지운 뒤" + to["ko"] + cut["ko"]},
              cell_marks={"bad": dead, "dim": [[r, c] for r, c, _, _, f in returns if f]},
              node_marks={"bad": pruned}, leaving=leaving,
              moves=[move(at("trie", t)) for t in pruned] or None)
        gone.update(pruned)
        returns.clear()

    def search(r, c, parent, how):
        flush_returns()
        letter = board[r][c]
        node = parent[letter]
        nid = ids[id(node)]
        nodes_by_id[nid] = node
        path.append((r, c, nid))
        before = len(found)
        moves = [move(at("board", [r, c]), at("trie", nid), value=letter)]
        if "$" in node:
            word = node.pop("$")
            found.append(word)
            tree.set(nid, None)
            moves.append(move(at("trie", nid), at("result", len(found) - 1), value=word))
            frame({"en": how["en"].rstrip(".") + f'; its node holds "{word}", found, and taken out of the trie so it '
                                                  f"is found once.",
                   "ko": how["ko"] + f' 노드에 "{word}" 단어가 있으니 찾았고, 한 번만 찾도록 트라이에서 뺍니다.'},
                  lit_cell=(r, c), node_marks={"good": [nid]}, moves=moves)
        else:
            frame(how, lit_cell=(r, c), lit_node=nid, moves=moves)
        board[r][c] = "#"
        for nr, nc in ((r + 1, c), (r - 1, c), (r, c + 1), (r, c - 1)):
            if 0 <= nr < rows and 0 <= nc < cols and board[nr][nc] in node:
                nxt = board[nr][nc]
                search(nr, nc, node, {
                    "en": f"From {cell(r, c)}, the neighbour {cell(nr, nc)} holds '{nxt}', a child of this node: "
                          f"step onto it.",
                    "ko": f"{cell(r, c)} 칸의 이웃 {cell(nr, nc)} 칸에 있는 '{nxt}' 글자가 이 노드의 자식이므로 그 칸으로 "
                          f"갑니다."})
        board[r][c] = letter
        path.pop()
        pruned = not node
        if pruned:
            parent.pop(letter)
        returns.append((r, c, nid, pruned, len(found) > before))

    for r in range(rows):
        for c in range(cols):
            if board[r][c] in trie:
                search(r, c, trie, {
                    "en": f"The scan reaches {cell(r, c)}: '{board[r][c]}' is a child of the root, so a word may start "
                          f"here. Step onto it and mark it \"#\".",
                    "ko": f"보드를 훑다가 {cell(r, c)} 칸에 닿았습니다. '{board[r][c]}' 글자가 루트의 자식이라 여기서 "
                          f"단어가 시작될 수 있으니, 이 칸으로 가서 \"#\" 표시를 합니다."})
    flush_returns()

    left = [w for w in words if w not in found]
    printed = driver_list(sorted(found))
    if found:
        frame({"en": f"The scan has passed every cell: {len(found)} {plural(len(found), 'word', 'words')} found, "
                     f"{printed} sorted" + (f"; {listed(chr(34) + w + chr(34) for w in left)} never had a path." if left
                                             else "."),
               "ko": f"모든 칸을 훑어 단어 {len(found)}개를 찾았고, 정렬하면 {printed}입니다."
                     + (f" {listed((chr(34) + w + chr(34) for w in left), ko=True)} 단어는 경로가 없었습니다." if left
                        else "")},
              word_marks={"dim": [[i, 0] for i, w in enumerate(words) if w in left]}, done=True, answer=printed)
    else:
        frame({"en": "The scan has passed every cell without reaching a word's last node, so the answer is [].",
               "ko": "모든 칸을 훑었지만 단어의 마지막 노드에 닿지 못했으므로 답은 빈 목록 []입니다."},
              word_marks={"dim": [[i, 0] for i in range(len(words))]}, done=True, answer=printed)
    return printed


for number, sample in enumerate(sample_cases(SLUG), start=1):
    lines = sample["input"].split("\n")
    board, words = json.loads(lines[0]), json.loads(lines[1])
    run = sample_run(wt, number, sample, input=f"board = {json.dumps(board, separators=(',', ':'))}, "
                                               f"words = {json.dumps(words, separators=(',', ':'))}")
    solve(board, words, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
