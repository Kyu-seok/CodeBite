#!/usr/bin/env python3.12
"""word-ladder's Walkthrough: the reference solution (scripts/replay-solutions/word-ladder.py), a BFS from beginWord
that tries every one-letter change of the word at the front and takes the ones still unvisited, on each sample Test
Case. The words are drawn as the description's graph Diagram draws them (an edge between words one letter apart),
each word's ladder length under it, with the unvisited set and the queue beside them.

    CODEBITE_DB=<database> scripts/walkthroughs/word-ladder.py

writes common/src/main/resources/walkthroughs/word-ladder.json.
"""
import os
import json
import sys
from string import ascii_lowercase

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import josa, plural, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move  # noqa: E402

SLUG = "word-ladder"

wt = Walkthrough(
    {"en": "Word Ladder", "ko": "단어 사다리"},
    {"en": "BFS from beginWord: the word at the front tries every one-letter change, and each change still in the "
           "unvisited set is one step longer. The first time a change is endWord, its length is the shortest.",
     "ko": "beginWord에서 BFS: 큐 앞의 단어가 글자 하나를 바꾼 모든 단어를 시도하고, 아직 방문하지 않은 집합에 있는 단어는 "
           "한 단계 더 긴 길이를 받습니다. 처음 endWord가 나오는 순간의 길이가 가장 짧습니다."},
    views=[
        {"id": "words", "type": "graph", "directed": False,
         "title": {"en": "words one letter apart (under: ladder length)",
                   "ko": "한 글자 차이인 단어 (아래: 사다리 길이)"}},
        {"id": "unvisited", "type": "set", "title": {"en": "unvisited", "ko": "unvisited (방문 전 단어)"},
         "empty": {"en": "empty", "ko": "비어 있음"},
         "hit": {"en": "unvisited", "ko": "방문 전"}, "miss": {"en": "not in it", "ko": "없음"}},
        {"id": "queue", "type": "queue", "title": {"en": "queue (tag: length)", "ko": "큐 (태그: 길이)"},
         "empty": {"en": "empty", "ko": "비어 있음"}},
    ],
)


def one_apart(a, b):
    return len(a) == len(b) and sum(x != y for x, y in zip(a, b)) == 1


def graph(begin, end, word_list):
    """The words as the description's graph Diagram draws them: beginWord first, then the dictionary in order, an
    edge between each pair one letter apart."""
    nodes = [begin] + [w for w in dict.fromkeys(word_list) if w != begin]
    edges = [(a, b) for i, a in enumerate(nodes) for b in nodes[i + 1:] if one_apart(a, b)]
    tags = {begin: {"en": "begin", "ko": "시작"}, end: {"en": "end", "ko": "끝"}}
    return nodes, edges, {"words": {"nodes": [{"id": w, "tag": tags[w]} if w in tags else {"id": w} for w in nodes],
                                    "edges": [{"from": a, "to": b} for a, b in edges]}}


def solve(begin, end, word_list, run):
    """Solution.ladderLength with a frame per step. Returns nothing; the last frame carries the answer."""
    nodes, edges, _ = graph(begin, end, word_list)
    edge_index = {frozenset(e): i for i, e in enumerate(edges)}
    lengths = {}         # word -> ladder length when reached
    parent = {}
    unvisited = list(dict.fromkeys(word_list))   # the set, in the order its words went in
    queue = []           # (word, length), front first


    def frame(caption, lit=(), good=(), path=(), bad=(), edge_lit=(), edge_path=(), probes=(), set_marks=None,
              queue_marks=None, moves=None, **answer):
        run.frame(caption,
                  words={"values": {w: n for w, n in lengths.items()},
                         "nodeMarks": {"path": list(path), "bad": list(bad), "good": list(good), "lit": list(lit)},
                         "edgeMarks": {"path": [edge_index[frozenset(e)] for e in edge_path],
                                       "lit": [edge_index[frozenset(e)] for e in edge_lit]}},
                  unvisited={"members": list(unvisited), "probes": list(probes), "marks": set_marks or {}},
                  queue={"values": [w for w, _ in queue], "tags": [[i, str(n)] for i, (_, n) in enumerate(queue)],
                         "marks": queue_marks or {}},
                  moves=moves, **answer)

    k = len(edges)
    frame({"en": f"From '{begin}' to '{end}' through {len(word_list)} dictionary "
                 f"{plural(len(word_list), 'word', 'words')}; {k} {plural(k, 'pair is', 'pairs are')} one letter "
                 f"apart. Every dictionary word starts unvisited.",
           "ko": f"사전 단어 {len(word_list)}개를 거쳐 '{begin}' 단어에서 '{end}' 단어까지 갑니다. 한 글자 차이인 쌍은 {k}개이고, "
                 f"사전 단어는 모두 방문 전 집합에서 시작합니다."})

    if end not in unvisited:
        frame({"en": f"'{end}' is not in the dictionary, so no ladder can end on it: answer 0.",
               "ko": f"'{end}' 단어가 사전에 없으므로 어떤 사다리도 거기서 끝날 수 없습니다: 답은 0입니다."},
              probes=[{"value": end, "hit": False}], answer="0")
        return
    if begin in unvisited:
        frame({"en": f"'{end}' is in the dictionary. '{begin}' is too, so take it out of unvisited: the ladder "
                     f"starts there.",
               "ko": f"'{end}' 단어는 사전에 있습니다. '{begin}' 단어도 있으므로 방문 전 집합에서 빼서 사다리의 시작으로 "
                     f"삼습니다."},
              lit=[begin], probes=[{"value": end, "hit": True}],
              set_marks={"bad": [begin]}, moves=[move(at("unvisited", begin), mark="bad")])
        unvisited.remove(begin)
    lengths[begin] = 1
    queue.append((begin, 1))
    frame({"en": f"'{begin}' joins the queue with length 1: a ladder of one word."
                 + ("" if begin in word_list else f" '{end}' is in the dictionary, so a ladder can end there."),
           "ko": f"'{begin}' 단어가 길이 1로 큐에 들어갑니다: 단어 하나짜리 사다리입니다."
                 + ("" if begin in word_list else f" '{end}' 단어는 사전에 있으니 사다리가 거기서 끝날 수 있습니다.")},
          good=[begin], queue_marks={"good": [0]},
          probes=[] if begin in word_list else [{"value": end, "hit": True}],
          moves=[move(None, at("words", begin), value="1"), move(at("words", begin), at("queue", 0), value=begin)])

    def chain(w):
        out = [w]
        while out[-1] in parent:
            out.append(parent[out[-1]])
        return out[::-1]

    while queue:
        word, length = queue[0]
        tries = 26 * len(word)
        hits, found_end = [], None
        for i in range(len(word)):
            for letter in ascii_lowercase:
                cand = word[:i] + letter + word[i + 1:]
                if cand in unvisited:
                    if cand == end:
                        found_end = (i, letter)
                        break
                    hits.append(cand)
            if found_end:
                break
        n = len(hits)
        if hits:
            for h in hits:
                lengths[h] = length + 1
                parent[h] = word
            listed = ", ".join(f"'{h}'" for h in hits)
            frame({"en": f"'{word}' leaves the front at length {length} and tries each one-letter change: "
                         f"{listed} {plural(n, 'is', 'are')} unvisited, so {plural(n, 'it gets', 'they get')} "
                         f"length {length} + 1 = {length + 1}.",
                   "ko": f"길이 {length}인 '{word}' 단어가 큐 앞에서 나와 글자 하나씩 바꿔 봅니다. 방문 전인 {listed} "
                         f"단어는 길이 {length} + 1 = {josa(length + 1, '을를')} 받습니다."},
                  lit=[word], good=hits, edge_lit=[(word, h) for h in hits],
                  probes=[{"value": h, "hit": True} for h in hits], queue_marks={"lit": [0]},
                  moves=[move(at("queue", 0), at("words", h), value=str(length + 1)) for h in hits])
            queue.pop(0)
            back = len(queue)
            for h in hits:
                unvisited.remove(h)
                queue.append((h, length + 1))
            frame({"en": f"{plural(n, 'It leaves', 'They leave')} unvisited and {plural(n, 'joins', 'join')} the "
                         f"back of the queue with length {length + 1}.",
                   "ko": f"새로 닿은 단어 {n}개가 방문 전 집합에서 빠져 길이 {josa(length + 1, '(으)로')} 큐 뒤에 들어갑니다."},
                  good=hits, queue_marks={"good": list(range(back, len(queue)))},
                  moves=[move(at("words", h), at("queue", back + j), value=h) for j, h in enumerate(hits)])
        if found_end:
            i, letter = found_end
            parent[end] = word
            lengths[end] = length + 1
            route = chain(end)
            ans = length + 1
            still = "Still on" if hits else "Taking"
            still_ko = "아직" if hits else ""
            frame({"en": f"{still} '{word}': changing '{word[i]}' to '{letter}' gives '{end}', the end word, so the "
                         f"shortest ladder is {' → '.join(route)}: answer {length} + 1 = {ans}.",
                   "ko": f"{still_ko + ' ' if still_ko else ''}'{word}' 단어의 '{word[i]}' 글자를 '{letter}' 글자로 바꾸면 "
                         f"endWord '{end}' 단어가 나오므로 가장 짧은 사다리는 {' → '.join(route)} 순서이고, 답은 "
                         f"{length} + 1 = {ans}입니다."},
                  path=route, edge_path=list(zip(route, route[1:])),
                  probes=[{"value": end, "hit": True}],
                  moves=[move(at("words", word), at("words", end), value=str(ans))], answer=str(ans))
            return
        if not hits:
            frame({"en": f"'{word}' leaves the front at length {length}: none of its {tries} one-letter changes "
                         f"is unvisited.",
                   "ko": f"길이 {length}인 '{word}' 단어가 큐 앞에서 나오지만, 글자 하나를 바꾼 {tries}개 중 방문 전인 "
                         f"단어가 없습니다."},
                  lit=[word], queue_marks={"lit": [0]}, moves=[move(at("queue", 0))])
            queue.pop(0)
    frame({"en": f"The queue is empty and '{end}' was never reached: answer 0.",
           "ko": f"큐가 비었는데 '{end}'에 끝내 닿지 못했으므로 답은 0입니다."},
          bad=[end], answer="0")


for number, sample in enumerate(sample_cases(SLUG), start=1):
    begin, end, raw = sample["input"].split("\n")
    word_list = json.loads(raw)
    b, e = begin.strip(), end.strip()
    run = sample_run(wt, number, sample, setup=graph(b, e, word_list)[2],
                     input=f'beginWord = "{begin.strip()}", endWord = "{end.strip()}", wordList = {raw.strip()}')
    solve(begin.strip(), end.strip(), word_list, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
