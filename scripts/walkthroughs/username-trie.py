#!/usr/bin/env python3.12
"""username-trie's Walkthrough: the reference solution (scripts/replay-solutions/username-trie.py), a trie of nested
dicts, run on the sample's list of calls. One frame per letter an insert walks or adds, one per end mark, and one per
letter a search or startsWith walks, on the sample Test Case. The calls are a table, one row per call, the current
call lit and the calls before it faded; each call's result moves from its row into the answer, and the trie grows
underneath, each letter on the edge into its node and a username's end marked ✓.

    CODEBITE_DB=<database> scripts/walkthroughs/username-trie.py

writes common/src/main/resources/walkthroughs/username-trie.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Tree, Walkthrough, at, move  # noqa: E402

SLUG = "username-trie"

wt = Walkthrough(
    {"en": "Username Trie", "ko": "유저네임 트라이"},
    {"en": "Usernames that share a prefix share the path that spells it: insert walks the letters, adding the nodes "
           "that are missing, and marks the last one ✓. search and startsWith walk the same way; only search also "
           "needs the ✓.",
     "ko": "접두어가 같은 유저명은 그 접두어를 이루는 경로를 함께 씁니다. insert는 글자를 따라 내려가며 없는 노드를 만들고 마지막 "
           "노드에 ✓를 표시합니다. search와 startsWith도 똑같이 내려가며, search만 ✓까지 확인합니다."},
    views=[
        {"id": "calls", "type": "table", "title": {"en": "calls", "ko": "호출"}},
        {"id": "trie", "type": "tree", "title": {"en": "trie (✓: a username ends here)", "ko": "트라이 (✓: 유저명의 끝)"}},
        {"id": "result", "type": "output", "title": {"en": "answer, one value per call", "ko": "답 (호출마다 하나)"},
         "empty": {"en": "none yet", "ko": "아직 없음"}},
    ],
)


def text(value):
    """A result as the Driver prints it."""
    return "null" if value is None else "true" if value is True else "false"


def solve(cmds, args, run):
    """The Driver's loop over PrefixIndex with a frame per step. Returns the answer as the Driver prints it."""
    tree = Tree()
    ids = {}        # id(dict node) -> the tree view's node id
    root = {}
    result = []
    rows = [{"label": str(i), "cells": [c, a[0] if a else ""]} for i, (c, a) in enumerate(zip(cmds, args))]
    state = {"row": 0}

    def frame(caption, lit=(), good=(), bad=(), shade=(), word_mark=None, moves=None, done=False, **answer):
        answered = any(m.get("to", {}).get("view") == "result" for m in moves or [])
        r = state["row"]
        cell_marks = {"dim": [[i, j] for i in range(r) for j in (0, 1)], "lit": [[r, 0], [r, 1]]} if not done else {}
        if word_mark:
            cell_marks[word_mark] = [[r, 1]]
        run.frame(caption,
                  calls={"columns": [{"en": "call", "ko": "호출"}, {"en": "word", "ko": "단어"}], "rows": rows,
                         "marks": cell_marks},
                  trie={**tree.state(), "nodeMarks": {"lit": list(lit), "good": list(good), "bad": list(bad)},
                        "shade": list(shade)},
                  result={"values": [text(v) for v in result],
                          "marks": {"path": list(range(len(result)))} if done else {"good": [len(result) - 1]} if answered else {}},
                  moves=moves, **answer)

    def answer(value):
        result.append(value)
        return move(at("calls", [state["row"], 0]), at("result", len(result) - 1), value=text(value))

    for row, (cmd, arg) in enumerate(zip(cmds, args)):
        state["row"] = row
        if cmd == "PrefixIndex":
            ids[id(root)] = tree.add(None)
            frame({"en": "PrefixIndex() makes an empty trie, just the root, and returns null.",
                   "ko": "PrefixIndex()는 루트만 있는 빈 트라이를 만들고 null을 반환합니다."},
                  lit=[ids[id(root)]], moves=[answer(None)])
            continue
        word = arg[0]
        node, path = root, [ids[id(root)]]
        if cmd == "insert":
            for k, ch in enumerate(word):
                if ch in node:
                    node = node[ch]
                    path.append(ids[id(node)])
                    frame({"en": f'insert("{word}"): the edge \'{ch}\' is already there, shared with an earlier username, '
                                 f"so step down it.",
                           "ko": f'insert("{word}"): \'{ch}\' 간선은 앞서 넣은 유저명과 함께 쓰는 것이라 이미 있으니 따라 내려갑니다.'},
                          lit=[path[-1]], shade=path)
                else:
                    parent = ids[id(node)]
                    node = node.setdefault(ch, {})
                    ids[id(node)] = tree.add(None, parent=parent, label=ch)
                    path.append(ids[id(node)])
                    frame({"en": f'insert("{word}"): no edge \'{ch}\' from here, so add a node for it.',
                           "ko": f'insert("{word}"): 여기서 나가는 \'{ch}\' 간선이 없으니 그 글자의 노드를 새로 만듭니다.'},
                          good=[path[-1]], shade=path,
                          moves=[move(at("calls", [row, 1]), at("trie", path[-1]), value=ch)])
            node["$"] = True
            tree.set(path[-1], "✓")
            frame({"en": f'Mark the node after the last letter ✓: "{word}" is a full username. insert returns null.',
                   "ko": f'마지막 글자의 노드에 ✓를 표시해 "{word}" 이름이 완전한 유저명임을 남깁니다. insert는 null을 반환합니다.'},
                  good=[path[-1]], shade=path,
                  moves=[move(at("calls", [row, 1]), at("trie", path[-1]), value="✓"), answer(None)])
            continue
        # search and startsWith share _walk
        for k, ch in enumerate(word):
            child = node.get(ch)
            if child is None:
                value = False
                frame({"en": f'{cmd}("{word}"): no edge \'{ch}\' from here, so no username starts with "{word[:k + 1]}". '
                             f"It returns false.",
                       "ko": f'{cmd}("{word}"): 여기서 나가는 \'{ch}\' 간선이 없으므로 "{word[:k + 1]}" 접두어로 시작하는 유저명이 '
                             f"없습니다. false를 반환합니다."},
                      bad=[path[-1]], shade=path, word_mark="bad", moves=[answer(value)])
                break
            node = child
            path.append(ids[id(node)])
            if k < len(word) - 1:
                frame({"en": f'{cmd}("{word}"): follow the edge \'{ch}\'.',
                       "ko": f'{cmd}("{word}"): \'{ch}\' 간선을 따라 내려갑니다.'},
                      lit=[path[-1]], shade=path)
                continue
            if cmd == "startsWith":
                value = True
                frame({"en": f'startsWith("{word}"): follow the edge \'{ch}\'. Every letter has an edge, so some username '
                             f"starts with it: true.",
                       "ko": f'startsWith("{word}"): \'{ch}\' 간선을 따라갑니다. 모든 글자에 간선이 있으니 이 접두어로 시작하는 '
                             f"유저명이 있어 true입니다."},
                      lit=[path[-1]], shade=path, moves=[answer(value)])
            elif "$" in node:
                value = True
                frame({"en": f'search("{word}"): follow the edge \'{ch}\'. The node is marked ✓, so "{word}" was inserted '
                             f"whole: true.",
                       "ko": f'search("{word}"): \'{ch}\' 간선을 따라갑니다. 노드에 ✓가 있으니 "{word}" 이름은 완전한 유저명으로 '
                             f"등록된 것이고, 답은 true입니다."},
                      lit=[path[-1]], shade=path, moves=[answer(value)])
            else:
                value = False
                frame({"en": f'search("{word}"): follow the edge \'{ch}\'. The node has no ✓: "{word}" is only a prefix, '
                             f"never inserted whole, so false.",
                       "ko": f'search("{word}"): \'{ch}\' 간선을 따라갑니다. 노드에 ✓가 없어 "{word}" 이름은 접두어일 뿐 '
                             f"등록된 유저명이 아니므로 false입니다."},
                      bad=[path[-1]], shade=path, moves=[answer(value)])

    printed = "[" + ",".join(text(v) for v in result) + "]"
    state["row"] = len(cmds)
    frame({"en": f"Every call has run; the answer lists one value per call: {printed}.",
           "ko": f"모든 호출이 끝났습니다. 답은 호출마다 값 하나씩입니다: {printed}."}, done=True, answer=printed)
    return printed


for number, sample in enumerate(sample_cases(SLUG), start=1):
    lines = sample["input"].split("\n")
    cmds, args = json.loads(lines[0]), json.loads(lines[1])
    run = sample_run(wt, number, sample, input=f"{json.dumps(cmds, separators=(',', ':'))}\n"
                                               f"{json.dumps(args, separators=(',', ':'))}")
    solve(cmds, args, run)
wt.write(walkthrough_path(SLUG))
