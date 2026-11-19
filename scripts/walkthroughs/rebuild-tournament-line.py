#!/usr/bin/env python3.12
"""rebuild-tournament-line's Walkthrough: the reference solution (scripts/replay-solutions/rebuild-tournament-line.py),
the players sorted tallest first (ties by k), then each inserted into the line at index k, recording one frame for
the sort and one per insert on each sample Test Case.

A player is drawn as their height in an `array` cell with `k=…` as its tag, in three arrays: the players as given,
sorted, and the line being built. The sort moves each player from the input to their sorted place; an insert moves
the player from the sorted array into index k of the line, and each player behind it moves one place back.

    CODEBITE_DB=<database> scripts/walkthroughs/rebuild-tournament-line.py

writes common/src/main/resources/walkthroughs/rebuild-tournament-line.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import driver_list, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move  # noqa: E402

SLUG = "rebuild-tournament-line"

wt = Walkthrough(
    {"en": "Rebuild the Tournament Line", "ko": "참가자 줄 세우기"},
    {"en": "Seat the tallest players first. A shorter player doesn't change anyone's k, and when a player is seated "
           "everyone already in line is at least as tall, so exactly k of them must stand ahead: insert at index k.",
     "ko": "키가 큰 사람부터 세웁니다. 더 작은 사람은 누구의 k도 바꾸지 않고, 한 사람을 세울 때 이미 줄에 선 사람은 "
           "모두 키가 그 이상이므로 그중 정확히 k명이 앞에 있어야 합니다. 그래서 인덱스 k에 끼워 넣습니다."},
    views=[
        {"id": "players", "type": "array", "title": {"en": "players: height, k above", "ko": "players (참가자): 키, 위 태그는 k"}},
        {"id": "order", "type": "array",
         "title": {"en": "sorted: tallest first, then smaller k", "ko": "정렬: 키 큰 순, 같으면 k 작은 순"},
         "empty": {"en": "not sorted yet", "ko": "아직 정렬 전"}},
        {"id": "line", "type": "array", "title": {"en": "line, front first", "ko": "줄 (맨 앞부터)"},
         "empty": {"en": "empty", "ko": "비어 있음"}},
    ],
)


def k_tags(people):
    return [[i, f"k={p[1]}"] for i, p in enumerate(people)]


def text(p):
    return json.dumps(p, separators=(",", ":"))


def solve(players, run):
    """Solution.rebuildLine with a frame for the sort and per insert. Returns the answer as the Driver prints it."""
    n = len(players)
    order = []
    line = []

    def frame(caption, j=None, done=0, line_marks=None, order_marks=None, moves=None, **answer):
        om = {"dim": list(range(done))}
        om.update(order_marks or {})
        run.frame(caption,
                  players={"values": [p[0] for p in players], "tags": k_tags(players)},
                  order={"values": [p[0] for p in order], "tags": k_tags(order), "pointers": {"p": j}, "marks": om},
                  line={"values": [p[0] for p in line], "tags": k_tags(line), "marks": line_marks or {}},
                  moves=moves, **answer)

    frame({"en": f"{n} players, scrambled. Each is a height h with k, the number of players at least h tall who stand "
                 "ahead of them.",
           "ko": f"참가자 {n}명이 뒤섞여 있습니다. 각자 키 h와 k, 곧 자기 앞에 선 키 h 이상인 사람 수를 가집니다."})
    order = sorted(players, key=lambda p: (-p[0], p[1]))
    taken = [False] * n
    moves = []
    for j, p in enumerate(order):
        i = next(x for x in range(n) if not taken[x] and players[x] == p)
        taken[i] = True
        moves.append(move(at("players", i), at("order", j), value=p[0]))
    listed = ", ".join(text(p) for p in order)
    frame({"en": f"Sort tallest first, and among equal heights the smaller k first: {listed}.",
           "ko": f"키가 큰 순으로, 키가 같으면 k가 작은 순으로 정렬합니다: {listed}."},
          order_marks={"good": list(range(n))}, moves=moves)
    for j, p in enumerate(order):
        h, k = p
        line.insert(k, p)
        moves = [move(at("order", j), at("line", k), value=h)]
        moves += [move(at("line", m - 1), at("line", m), value=line[m][0]) for m in range(k + 1, len(line))]
        seated = len(line) - 1
        if seated == 0:
            en = f"{text(p)} goes first into the empty line, at index {k}."
            ko = f"{text(p)} 참가자가 빈 줄의 인덱스 {k}에 섭니다."
        else:
            behind = len(line) - 1 - k
            back_en = ("" if not behind else "; the player behind steps back" if behind == 1 else
                       f"; the {behind} behind step back")
            back_ko = (f" 뒤의 {behind}명은 한 칸씩 물러납니다." if behind else "")
            who = "the one player already in line is" if seated == 1 else f"all {seated} already in line are"
            en = (f"{text(p)}: {who} at least {h} tall, so {k} of them must be ahead. Insert "
                  f"at index {k}{back_en}.")
            ko = (f"{text(p)} 참가자: 줄에 선 {seated}명은 {'' if seated == 1 else '모두 '}키가 {h} 이상이므로 그중 {k}명이 앞에 있어야 합니다. "
                  f"인덱스 {k}에 끼워 넣습니다.{back_ko}")
        frame({"en": en, "ko": ko}, j=j, done=j, order_marks={"lit": [j]}, line_marks={"good": [k]}, moves=moves)
    answer = driver_list(line)
    frame({"en": f"Every player is seated: {answer}. Each later, shorter player went in without changing anyone's "
                 f"count ahead. Answer: {answer}.",
           "ko": f"모든 참가자가 섰습니다: {answer}. 나중에 들어온 작은 사람은 누구의 앞사람 수도 바꾸지 않았습니다. "
                 f"답은 {answer}입니다."},
          done=n, line_marks={"path": list(range(n))}, answer=answer)


for number, sample in enumerate(sample_cases(SLUG), start=1):
    players = json.loads(sample["input"])
    run = sample_run(wt, number, sample, input=f"players = {sample['input']}")
    solve(players, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
