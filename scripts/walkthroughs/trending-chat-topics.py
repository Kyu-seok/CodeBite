#!/usr/bin/env python3.12
"""trending-chat-topics' Walkthrough: the reference solution (scripts/replay-solutions/trending-chat-topics.py), a
count per topic in a hash map and then every topic ranked by count, ties by label. Each mention moves into its
topic's card, a ranking step badges the cards, and the first k move into the answer, on each sample Test Case.

    CODEBITE_DB=<database> scripts/walkthroughs/trending-chat-topics.py

writes common/src/main/resources/walkthroughs/trending-chat-topics.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import driver_list, josa, plural, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, map_entries, move  # noqa: E402

SLUG = "trending-chat-topics"
EMPTY = {"en": "empty", "ko": "비어 있음"}

wt = Walkthrough(
    {"en": "Trending Chat Topics", "ko": "단톡방 유행 주제"},
    {"en": "Count every topic's mentions in a hash map in one pass, then rank the topics by count, most first, and "
           "alphabetically on a tie; the first k are the answer.",
     "ko": "한 번 훑으며 주제마다 언급 횟수를 해시 맵에 세고, 횟수가 많은 순, 같으면 알파벳 순으로 순위를 매깁니다. 앞의 "
           "k개가 답입니다."},
    views=[
        {"id": "topics", "type": "table", "title": {"en": "topics", "ko": "topics (주제)"}},
        {"id": "counts", "type": "map", "title": {"en": "mentions per topic (hash map)", "ko": "주제별 언급 횟수 (해시 맵)"},
         "empty": EMPTY},
        {"id": "result", "type": "output", "title": {"en": "answer", "ko": "답"}, "empty": EMPTY},
        {"id": "state", "type": "vars"},
    ],
)


def solve(topics, k, run):
    """Solution.rankTrendingTopics with a frame per mention and per topic taken. Returns the answer as printed."""
    rows = [{"label": str(i), "cells": [t]} for i, t in enumerate(topics)]
    counts = {}
    ranked, out = [], []

    def frame(caption, row=None, marks=None, moves=None, **answer):
        cell = {"lit": [[row, 0]], "dim": [[r, 0] for r in range(row)]} if row is not None else (
            {"dim": [[r, 0] for r in range(len(topics))]} if ranked else {})
        run.frame(caption,
                  topics={"rows": rows, "marks": cell},
                  counts={"entries": map_entries(counts), "marks": marks or {}, **({"ranks": ranked} if ranked else {})},
                  result={"values": list(out), "marks": {"path": list(range(len(out)))}},
                  state={"items": [{"label": "k", "value": k}]},
                  moves=moves, **answer)

    frame({"en": f"Walk the {len(topics)} mentions once and count each topic in a hash map; then rank the topics and "
                 f"take the first {k}.",
           "ko": f"언급 {len(topics)}개를 한 번 훑으며 주제마다 횟수를 해시 맵에 셉니다. 그다음 순위를 매겨 앞의 "
                 f"{k}개를 고릅니다."})
    for i, topic in enumerate(topics):
        before = counts.get(topic, 0)
        counts[topic] = before + 1
        if before:
            caption = {"en": f"topics[{i}] is \"{topic}\", already in the map: its count goes {before} → {before + 1}.",
                       "ko": f"topics[{i}] = \"{topic}\": 이미 맵에 있는 주제이므로 횟수를 1 늘립니다 "
                             f"({before} → {before + 1})."}
        else:
            caption = {"en": f"topics[{i}] is \"{topic}\", not in the map yet: it goes in with count 1.",
                       "ko": f"topics[{i}] = \"{topic}\": 아직 맵에 없는 주제이므로 횟수 1로 들어갑니다."}
        frame(caption, row=i, marks={"good": [topic]}, moves=[move(at("topics", [i, 0]), at("counts", topic))])

    ranked = sorted(counts, key=lambda t: (-counts[t], t))
    top, rest = ranked[:k], ranked[k:]
    order = ", ".join(f"{t} ({counts[t]})" for t in ranked)
    frame({"en": f"Every mention is counted. Ranked by count, most first, and alphabetically on a tie: {order}; "
                 f"the first {k} {plural(k, 'is', 'are')} the answer.",
           "ko": f"언급을 모두 세었습니다. 횟수가 많은 순, 같으면 알파벳 순으로 놓으면 {order}이고, 앞의 "
                 f"{k}개가 답입니다."},
          marks={"path": top, "dim": rest})
    answer = driver_list(top)
    for j, topic in enumerate(top):
        out.append(topic)
        c = counts[topic]
        tie = [t for t in ranked if counts[t] == c and t != topic]
        why = ({"en": f", tied with {', '.join(tie)}: on a tie the earlier label ranks first",
                "ko": f"이고, {', '.join(tie)} 주제와 횟수가 같아 알파벳 순으로 순위를 정합니다"} if tie else
               {"en": "", "ko": ""})
        last = j == len(top) - 1
        frame({"en": f"#{j + 1} is \"{topic}\" with {c} {plural(c, 'mention', 'mentions')}{why['en']}." +
                     (f" The answer is {answer}." if last else ""),
               "ko": f"{j + 1}위는 \"{topic}\"(언급 {c}회){why['ko'] or '입니다'}." +
                     (f" 답은 {answer}입니다." if last else "")},
              marks={"path": top, "dim": rest}, moves=[move(at("counts", topic), at("result", j))],
              **({"answer": answer} if last else {}))
    return answer


for number, sample in enumerate(sample_cases(SLUG), start=1):
    lines = sample["input"].split("\n")
    topics, k = json.loads(lines[0]), int(lines[1])
    run = sample_run(wt, number, sample, input=f"topics = {driver_list(topics)}, k = {k}")
    solve(topics, k, run)
wt.write(walkthrough_path(SLUG))
