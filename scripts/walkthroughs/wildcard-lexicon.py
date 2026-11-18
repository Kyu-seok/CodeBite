#!/usr/bin/env python3.12
"""wildcard-lexicon's Walkthrough: the reference solution (scripts/replay-solutions/wildcard-lexicon.py), a trie of
nested dicts whose match walks the word's letters and, on a '.', tries each child in turn, run on the sample's list of
calls. One frame per letter an enroll walks or adds, one per end mark, and one per edge a match follows, on the sample
Test Case. The calls are a table, one row per call, the current call lit and the calls before it faded; each call's
result moves from its row into the answer. The trie grows underneath, each letter on the edge into its node and a
word's end marked ✓; a match lights the node it is on, shades the calls still open (the path from the root) and
fades a branch that failed.

    CODEBITE_DB=<database> scripts/walkthroughs/wildcard-lexicon.py

writes common/src/main/resources/walkthroughs/wildcard-lexicon.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Tree, Walkthrough, at, move  # noqa: E402

SLUG = "wildcard-lexicon"

wt = Walkthrough(
    {"en": "Wildcard Lexicon", "ko": "와일드카드 단어 사전"},
    {"en": "Saved words share the trie paths of their common prefixes. match follows one edge per letter; a '.' has no "
           "one edge to follow, so it tries each child in turn and stops at the first that leads to a ✓ at the word's end.",
     "ko": "저장된 단어는 공통 접두어의 트라이 경로를 함께 씁니다. match는 글자마다 간선 하나를 따라가고, '.'은 따라갈 간선이 "
           "정해져 있지 않으니 자식을 차례로 시도해 단어 끝에서 ✓에 닿는 첫 갈래에서 멈춥니다."},
    views=[
        {"id": "calls", "type": "table", "title": {"en": "calls", "ko": "호출"}},
        {"id": "trie", "type": "tree", "title": {"en": "trie (✓: a saved word ends here)", "ko": "트라이 (✓: 저장된 단어의 끝)"}},
        {"id": "result", "type": "output", "title": {"en": "answer, one value per call", "ko": "답 (호출마다 하나)"},
         "empty": {"en": "none yet", "ko": "아직 없음"}},
    ],
)


def text(value):
    """A result as the Driver prints it."""
    return "null" if value is None else "true" if value is True else "false"


def solve(cmds, args, run):
    """The Driver's loop over WildcardLexicon with a frame per step. Returns the answer as the Driver prints it."""
    tree = Tree()
    ids = {}        # id(dict node) -> the tree view's node id
    root = {}
    result = []
    rows = [{"label": str(i), "cells": [c, a[0] if a else ""]} for i, (c, a) in enumerate(zip(cmds, args))]
    pending = []    # the last frame, held back so a match's answer can join it

    def flush():
        if not pending:
            return
        f = pending.pop()
        r, done = f["row"], f["done"]
        cell_marks = {} if done else {"dim": [[i, j] for i in range(r) for j in (0, 1)], "lit": [[r, 0], [r, 1]]}
        if f["word_mark"]:
            cell_marks[f["word_mark"]] = [[r, 1]]
        answered = any(m.get("to", {}).get("view") == "result" for m in f["moves"])
        node_marks = {"dim": list(f["dim"]), "path": list(f["path"]), "bad": list(f["bad"]), "good": list(f["good"]),
                      "lit": list(f["lit"])}
        run.frame(f["caption"],
                  calls={"columns": [{"en": "call", "ko": "호출"}, {"en": "word", "ko": "단어"}], "rows": rows,
                         "marks": cell_marks},
                  trie={**f["tree"], "nodeMarks": node_marks, "shade": list(f["shade"])},
                  result={"values": [text(v) for v in f["result"]],
                          "marks": {"path": list(range(len(f["result"])))} if done else
                          {"good": [len(f["result"]) - 1]} if answered else {}},
                  moves=f["moves"] or None, **f["answer"])

    def frame(caption, row, lit=(), good=(), bad=(), dim=(), shade=(), moves=(), done=False, **answer):
        flush()
        pending.append({"caption": caption, "row": row, "lit": list(lit), "good": list(good), "bad": list(bad),
                        "dim": list(dim), "path": (),
                        "shade": list(shade), "moves": list(moves), "done": done, "answer": answer, "word_mark": None,
                        "tree": tree.state(), "result": list(result)})

    def answer(row, value, add):
        """The call's result joins the frame held back: its caption gets `add` and its row's value moves out."""
        result.append(value)
        f = pending[-1]
        f["caption"] = {k: f["caption"][k] + add[k] for k in ("en", "ko")}
        f["moves"].append(move(at("calls", [row, 0]), at("result", len(result) - 1), value=text(value)))
        f["result"] = list(result)

    for row, (cmd, arg) in enumerate(zip(cmds, args)):
        if cmd == "WildcardLexicon":
            ids[id(root)] = tree.add(None)
            frame({"en": "WildcardLexicon() makes an empty trie, just the root, and returns null.",
                   "ko": "WildcardLexicon()은 루트만 있는 빈 트라이를 만들고 null을 반환합니다."},
                  row, lit=[ids[id(root)]])
            answer(row, None, {"en": "", "ko": ""})
            continue
        word = arg[0]
        if cmd == "enroll":
            node, path = root, [ids[id(root)]]
            for ch in word:
                if ch in node:
                    node = node[ch]
                    path.append(ids[id(node)])
                    frame({"en": f'enroll("{word}"): the edge \'{ch}\' is already there, so step down it.',
                           "ko": f'enroll("{word}"): \'{ch}\' 간선이 이미 있으니 따라 내려갑니다.'},
                          row, lit=[path[-1]], shade=path)
                else:
                    parent = ids[id(node)]
                    node = node.setdefault(ch, {})
                    ids[id(node)] = tree.add(None, parent=parent, label=ch)
                    path.append(ids[id(node)])
                    frame({"en": f'enroll("{word}"): no edge \'{ch}\' from here, so add a node for it.',
                           "ko": f'enroll("{word}"): 여기서 나가는 \'{ch}\' 간선이 없으니 그 글자의 노드를 새로 만듭니다.'},
                          row, good=[path[-1]], shade=path,
                          moves=[move(at("calls", [row, 1]), at("trie", path[-1]), value=ch)])
            node["$"] = True
            tree.set(path[-1], "✓")
            frame({"en": f'Mark the node after the last letter ✓: "{word}" is saved. enroll returns null.',
                   "ko": f'마지막 글자의 노드에 ✓를 표시해 "{word}"를 저장합니다. enroll은 null을 반환합니다.'},
                  row, good=[path[-1]], shade=path, moves=[move(at("calls", [row, 1]), at("trie", path[-1]), value="✓")])
            answer(row, None, {"en": "", "ko": ""})
            continue

        failed = []     # nodes of branches given up, faded from then on

        def walk(node, i, path):
            """The reference's walk(node, i), drawing each edge it follows; `path` is the open calls' nodes."""
            if i == len(word):
                return "$" in node
            ch = word[i]
            here = ids[id(node)]
            if ch == ".":
                kids = [(k, c) for k, c in node.items() if k != "$"]
                if not kids:
                    frame({"en": f'match("{word}"): \'.\' needs some letter here, but this node has no edges: this branch fails.',
                           "ko": f'match("{word}"): \'.\'에 맞는 글자가 필요하지만 이 노드에서 나가는 간선이 없어 이 갈래는 실패합니다.'},
                          row, bad=[here], dim=failed, shade=path)
                    return False
                for n, (k, child) in enumerate(kids):
                    if arrive(child, i, path, {"en": f"'.' matches any letter: try the {'first' if n == 0 else 'next'} edge, '{k}'",
                                               "ko": f"'.'은 아무 글자와 맞으니 {'첫' if n == 0 else '다음'} 간선 '{k}' 쪽을 시도합니다",
                                               "ko_and": f"'.'은 아무 글자와 맞으니 {'첫' if n == 0 else '다음'} 간선 '{k}' 쪽을 시도하고,"}):
                        return True
                return False
            child = node.get(ch)
            if child is None:
                frame({"en": f'match("{word}"): no edge \'{ch}\' from here, so this path fails.',
                       "ko": f'match("{word}"): 여기서 나가는 \'{ch}\' 간선이 없으므로 이 경로는 실패합니다.'},
                      row, bad=[here], dim=failed, shade=path)
                return False
            return arrive(child, i, path, {"en": f"follow the edge '{ch}'", "ko": f"'{ch}' 간선을 따라갑니다",
                                             "ko_and": f"'{ch}' 간선을 따라가면"})

        def arrive(child, i, path, how):
            """Step into `child` for word[i], then walk on from it."""
            node_id = ids[id(child)]
            path = path + [node_id]
            if i + 1 == len(word):
                if "$" in child:
                    tail = {"en": "; the word ends here at a ✓, so it matches: true.",
                            "ko": " 단어가 끝나는 노드에 ✓가 있어 일치하므로 답은 true입니다."}
                    frame({"en": f'match("{word}"): {how["en"]}{tail["en"]}', "ko": f'match("{word}"): {how["ko_and"]}{tail["ko"]}'},
                          row, lit=[node_id], dim=failed, shade=path)
                    pending[-1]["path"] = path
                    return True
                tail = {"en": "; the word ends here but the node has no ✓, so this branch fails.",
                        "ko": " 단어가 끝나는 노드에 ✓가 없어 이 갈래는 실패합니다."}
                frame({"en": f'match("{word}"): {how["en"]}{tail["en"]}', "ko": f'match("{word}"): {how["ko_and"]}{tail["ko"]}'},
                      row, bad=[node_id], dim=failed, shade=path)
                failed.append(node_id)
                return False
            frame({"en": f'match("{word}"): {how["en"]}.', "ko": f'match("{word}"): {how["ko"]}.'},
                  row, lit=[node_id], dim=failed, shade=path)
            if walk(child, i + 1, path):
                return True
            failed.append(node_id)
            return False

        value = walk(root, 0, [ids[id(root)]])
        if value:
            answer(row, True, {"en": "", "ko": ""})
        else:
            pending[-1]["word_mark"] = "bad"
            answer(row, False, {"en": " No saved word fits: false.", "ko": " 맞는 단어가 없으니 false입니다."})

    printed = "[" + ",".join(text(v) for v in result) + "]"
    frame({"en": f"Every call has run; the answer lists one value per call: {printed}.",
           "ko": f"모든 호출이 끝났습니다. 답은 호출마다 값 하나씩입니다: {printed}."}, len(cmds), done=True, answer=printed)
    flush()
    return printed


for number, sample in enumerate(sample_cases(SLUG), start=1):
    lines = sample["input"].split("\n")
    cmds, args = json.loads(lines[0]), json.loads(lines[1])
    run = sample_run(wt, number, sample, input=f"{json.dumps(cmds, separators=(',', ':'))}\n"
                                               f"{json.dumps(args, separators=(',', ':'))}")
    solve(cmds, args, run)
wt.write(walkthrough_path(SLUG))
