#!/usr/bin/env python3.12
"""micro-feed's Walkthrough: the reference solution (scripts/replay-solutions/micro-feed.py) run on each sample's list
of calls. Each user's posts are a map card of message@time chips, oldest first, and who follows whom a second map.
latestFeed merges its authors' post lists from the newest end through a max-heap of time (heapq on negated times,
drawn with each message tagged by its time), with heapq's push and pop written out as the textbook sift-up and
sift-down, one swap per frame; a pop is one frame, the root leaving and the last node filling it at once, as heappop
does. The calls are a table, the current call lit, and each call's return value moves into the returned list.

    CODEBITE_DB=<database> scripts/walkthroughs/micro-feed.py

writes common/src/main/resources/walkthroughs/micro-feed.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import driver_list, josa, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, level_order_tree, map_entries, move, swap  # noqa: E402

SLUG = "micro-feed"
EMPTY = {"en": "empty", "ko": "비어 있음"}

wt = Walkthrough(
    {"en": "Micro Feed", "ko": "짧은 글 피드"},
    {"en": "Each user's posts are kept oldest first, stamped with a clock. latestFeed puts each author's newest post in "
           "a max-heap by time; popping the top gives the newest post left, and that author's next older post takes "
           "its place, until 10 are taken or the heap is empty.",
     "ko": "사용자마다 글을 시각과 함께 오래된 순으로 둡니다. latestFeed는 작성자마다 가장 최근 글을 시각 기준 최대 힙에 "
           "넣습니다. 맨 위를 꺼내면 남은 글 중 가장 최근 글이고, 그 작성자의 바로 이전 글이 대신 들어갑니다. 10개를 "
           "꺼내거나 힙이 빌 때까지 반복합니다."},
    views=[
        {"id": "calls", "type": "table", "title": {"en": "calls", "ko": "호출"}},
        {"id": "posts", "type": "map", "title": {"en": "posts per user (message@time)", "ko": "사용자별 글 (메시지@시각)"},
         "empty": EMPTY},
        {"id": "following", "type": "map", "title": {"en": "follows", "ko": "팔로우"}, "empty": EMPTY},
        {"id": "heap", "type": "tree", "arity": 2,
         "title": {"en": "max-heap: newest on top", "ko": "최대 힙: 맨 위가 가장 최근"}, "empty": EMPTY},
        {"id": "feed", "type": "output", "title": {"en": "feed", "ko": "피드"}, "empty": EMPTY},
        {"id": "result", "type": "output", "title": {"en": "returned", "ko": "반환값"}},
    ],
)


def solve(ops, args, run):
    """The Driver's loop over MicroFeed's calls with latestFeed's heapq written out. Returns the printed list."""
    rows = [{"label": str(i), "cells": [op, ", ".join(str(a) for a in arg)]} for i, (op, arg) in enumerate(zip(ops, args))]
    posts = {}      # user -> [(time, messageId)]
    following = {}  # user -> followees in the order followed (the reference's set, drawn in insertion order)
    heap = []       # (-time, messageId, author, index)
    feed = []
    result = []
    clock = [0]
    st = {"row": 0, "draw": None, "pmarks": {}, "fmarks": {}, "feed_mark": False, "drawn": 0, "stale": False}

    def chip(post):
        return f"{post[1]}@t{post[0]}"

    def frame(caption, marks=None, moves=None, done=False, **answer):
        r = st["row"]
        fresh = list(range(st["drawn"], len(result)))
        st["drawn"] = len(result)
        shown = st["draw"] if st["draw"] is not None else heap
        run.frame(caption,
                  calls={"columns": [{"en": "call", "ko": "호출"}, {"en": "arguments", "ko": "인자"}], "rows": rows,
                         "marks": {} if done else {"dim": [[i, c] for i in range(r) for c in (0, 1)],
                                                   "lit": [[r, 0], [r, 1]]}},
                  posts={"entries": [{"key": u, "value": [chip(p) for p in ps]} for u, ps in posts.items()],
                         "marks": st["pmarks"]},
                  following={"entries": [{"key": u, "value": list(fs)} for u, fs in following.items()],
                             "marks": st["fmarks"]},
                  heap={**level_order_tree([str(e[1]) for e in shown]),
                        "tags": [[j, f"[{j}] t{-e[0]}"] for j, e in enumerate(shown)], "nodeMarks": marks or {}},
                  feed={"values": [str(m) for m in feed],
                        "marks": {"good": [len(feed) - 1]} if st["feed_mark"] and feed else
                        {"dim": list(range(len(feed)))} if st["stale"] else {}},
                  result={"values": list(result),
                          "marks": {"path": list(range(len(result)))} if done else {"good": fresh}},
                  moves=moves, **answer)
        st["feed_mark"] = False

    def null(row):
        result.append("null")
        return move(at("calls", [row, 0]), at("result", len(result) - 1), value="null")

    def above(a, b):
        return a < b  # heapq's order on (-time, ...): the later time on top

    def sift_up(j):
        while j > 0:
            p = (j - 1) // 2
            if not above(heap[j], heap[p]):
                return
            a, b = heap[j], heap[p]
            heap[j], heap[p] = b, a
            frame({"en": f"Sift up: {a[1]} (t{-a[0]}) is newer than its parent {b[1]} (t{-b[0]}), so they swap.",
                   "ko": f"위로 올리기: {a[1]} (t{-a[0]}) 글이 부모 {b[1]} (t{-b[0]}) 글보다 최근이므로 자리를 "
                         f"바꿉니다."},
                  marks={"good": [p], "lit": [j]}, moves=swap("heap", j, p, str(a[1]), str(b[1])))
            j = p

    def sift_down(j):
        while True:
            best = j
            for c in (2 * j + 1, 2 * j + 2):
                if c < len(heap) and above(heap[c], heap[best]):
                    best = c
            if best == j:
                return
            a, b = heap[j], heap[best]
            heap[j], heap[best] = b, a
            frame({"en": f"Sift down: its child {b[1]} (t{-b[0]}) is newer than {a[1]} (t{-a[0]}), so they swap.",
                   "ko": f"아래로 내리기: 자식 {b[1]} (t{-b[0]}) 글이 {a[1]} (t{-a[0]}) 글보다 최근이므로 자리를 "
                         f"바꿉니다."},
                  marks={"good": [j], "lit": [best]}, moves=swap("heap", j, best, str(a[1]), str(b[1])))
            j = best

    def push(entry, caption):
        heap.append(entry)
        j = len(heap) - 1
        st["pmarks"] = {"lit": [entry[2]]}
        frame(caption, marks={"good": [j]}, moves=[move(at("posts", entry[2]), at("heap", j), value=str(entry[1]))])
        st["pmarks"] = {}
        sift_up(j)

    for row, (op, arg) in enumerate(zip(ops, args)):
        st["row"] = row
        if op == "MicroFeed":
            result.append("null")
            frame({"en": "MicroFeed() starts an empty board, with the clock at 0; the constructor returns null.",
                   "ko": "MicroFeed()는 시계를 0에 두고 빈 보드로 시작하며, 생성자는 null을 반환합니다."})
        elif op == "publishPost":
            user, msg = arg
            post = (clock[0], msg)
            clock[0] += 1
            posts.setdefault(user, []).append(post)
            st["pmarks"] = {"good": [user]}
            frame({"en": f"publishPost({user}, {msg}): message {msg} gets time {post[0]} and goes at the end of user "
                         f"{user}'s posts, the newest end. Returns null.",
                   "ko": f"publishPost({user}, {msg}): 메시지 {msg}에 시각 {josa(post[0], '을를')} 붙여 사용자 {user}의 글 맨 끝, "
                         f"가장 최근 쪽에 넣습니다. null을 반환합니다."},
                  moves=[move(at("calls", [row, 1]), at("posts", user), value=chip(post)), null(row)])
            st["pmarks"] = {}
        elif op == "subscribe":
            a, b = arg
            if a != b and b not in following.get(a, []):
                following.setdefault(a, []).append(b)
                st["fmarks"] = {"good": [a]}
                frame({"en": f"subscribe({a}, {b}): user {a} now follows user {b}. Returns null.",
                       "ko": f"subscribe({a}, {b}): 이제 사용자 {josa(a, '이가')} 사용자 {josa(b, '을를')} 팔로우합니다. null을 반환합니다."},
                      moves=[move(at("calls", [row, 1]), at("following", a), value=str(b)), null(row)])
            else:
                frame({"en": f"subscribe({a}, {b}): nothing changes. Returns null.",
                       "ko": f"subscribe({a}, {b}): 바뀌는 것이 없습니다. null을 반환합니다."}, moves=[null(row)])
            st["fmarks"] = {}
        elif op == "unsubscribe":
            a, b = arg
            if b in following.get(a, []):
                following[a].remove(b)
                st["fmarks"] = {"bad": [a]}
                frame({"en": f"unsubscribe({a}, {b}): user {b} leaves user {a}'s follows. Returns null.",
                       "ko": f"unsubscribe({a}, {b}): 사용자 {a}의 팔로우에서 사용자 {josa(b, '이가')} 빠집니다. null을 "
                             f"반환합니다."},
                      moves=[move(at("following", a), value=str(b), mark="bad"), null(row)])
            else:
                frame({"en": f"unsubscribe({a}, {b}): user {a} doesn't follow user {b}, so nothing changes. "
                             f"Returns null.",
                       "ko": f"unsubscribe({a}, {b}): 사용자 {josa(a, '은는')} 사용자 {josa(b, '을를')} 팔로우하지 않으므로 바뀌는 것이 "
                             f"없습니다. null을 반환합니다."}, moves=[null(row)])
            st["fmarks"] = {}
        else:
            user = arg[0]
            feed.clear()
            st["stale"] = False
            authors = sorted(set(following.get(user, [])) | {user})
            names = ", ".join(str(a) for a in authors)
            st["fmarks"] = {"lit": [user]} if user in following else {}
            st["pmarks"] = {"lit": [a for a in authors if a in posts]}
            frame({"en": f"latestFeed({user}): the authors are user {user} and everyone {user} follows: {names}. "
                         f"Each one's newest post goes into the heap.",
                   "ko": f"latestFeed({user}): 작성자는 사용자 {user} 자신과 {josa(user, '이가')} 팔로우하는 사용자로, {names}입니다. "
                         f"작성자마다 가장 최근 글을 힙에 넣습니다."})
            st["fmarks"] = {}
            st["pmarks"] = {}
            for author in authors:
                mine = posts.get(author, [])
                if mine:
                    t, m = mine[-1]
                    push((-t, m, author, len(mine) - 1),
                         {"en": f"User {author}'s newest post, {m} at time {t}, goes in at the heap's end.",
                          "ko": f"사용자 {author}의 가장 최근 글, 시각 {t}의 {m} 글이 힙의 맨 끝에 들어갑니다."})
            while heap and len(feed) < 10:
                top = heap[0]
                _, m, author, i = top
                feed.append(m)
                st["feed_mark"] = True
                moves = [move(at("heap", 0), at("feed", len(feed) - 1), value=str(m))]
                last = heap.pop()
                if heap:
                    k = len(heap)
                    heap[0] = last
                    st["draw"] = heap + [last]
                    moves.append(move(at("heap", k), at("heap", 0)))
                    fill = {"en": f" The last node {last[1]} fills the root.",
                            "ko": f" 마지막 노드 {last[1]} 글이 루트를 채웁니다."}
                    marks = {"good": [0]}
                else:
                    st["draw"] = [top]
                    fill = {"en": "", "ko": ""}
                    marks = {"lit": [0]}
                frame({"en": f"heappop: {m} (t{-top[0]}) on top is the newest post left, so it is next in the "
                             f"feed.{fill['en']}",
                       "ko": f"heappop: 맨 위의 {m} (t{-top[0]}) 글이 남은 글 중 가장 최근이므로 피드의 다음 "
                             f"글입니다.{fill['ko']}"},
                      marks=marks, moves=moves)
                st["draw"] = None
                sift_down(0)
                if i > 0:
                    t, older = posts[author][i - 1]
                    push((-t, older, author, i - 1),
                         {"en": f"User {author}'s next older post, {older} at time {t}, takes its place in the heap.",
                          "ko": f"사용자 {author}의 바로 이전 글, 시각 {t}의 {older} 글이 힙에 대신 들어갑니다."})
            printed = driver_list(feed)
            why = ({"en": "the heap is empty", "ko": "힙이 비었으므로"} if len(feed) < 10 else
                   {"en": "it holds 10", "ko": "10개를 채웠으므로"})
            result.append(printed)
            st["feed_mark"] = False
            frame({"en": f"The feed is done ({why['en']}): latestFeed({user}) returns {printed}, newest first.",
                   "ko": f"{why['ko']} 피드가 끝났습니다. latestFeed({user})의 반환값은 최신순으로 {printed}입니다."},
                  moves=[move(at("feed", 0), at("result", len(result) - 1), value=printed)] if feed else
                  [move(at("calls", [row, 0]), at("result", len(result) - 1), value=printed)])
            st["stale"] = True

    printed = "[" + ",".join(result) + "]"
    st["row"] = len(ops)
    frame({"en": f"Every call has run; the returned values, one per call, are {printed}.",
           "ko": f"모든 호출이 끝났습니다. 호출마다 하나씩 반환한 값은 {printed}입니다."}, done=True, answer=printed)
    return printed


for number, sample in enumerate(sample_cases(SLUG), start=1):
    lines = sample["input"].split("\n")
    ops, args = json.loads(lines[0]), json.loads(lines[1])
    run = sample_run(wt, number, sample, input=f"{driver_list(ops)}\n{driver_list(args)}")
    solve(ops, args, run)
wt.write(walkthrough_path(SLUG))
