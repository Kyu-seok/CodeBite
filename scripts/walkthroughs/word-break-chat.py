#!/usr/bin/env python3.12
"""word-break-chat's Walkthrough: the reference solution (scripts/replay-solutions/word-break-chat.py), a table
`splittable` where splittable[end] says whether the first `end` letters split into known words, filled left to
right, recording one frame per end on each sample Test Case and on an extra run.

Each end looks, in the order of `words`, for a word the prefix ends with, drawn as a span over its letters, and
reads the cell where that word starts, tagged with the word. The first word whose start cell is T makes the end T,
and its start's T and the word move into the cell. The tracer keeps that word per end, so the last frame marks the
split the answer found. No sample has a word that ends in place but starts after a prefix that doesn't split, so an
extra run does.

    CODEBITE_DB=<database> scripts/walkthroughs/word-break-chat.py

writes common/src/main/resources/walkthroughs/word-break-chat.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import driver_list, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move, span  # noqa: E402

SLUG = "word-break-chat"

wt = Walkthrough(
    {"en": "Word Break Chat", "ko": "채팅 메시지 단어 나누기"},
    {"en": "The first end letters split when some word ends them and the letters before that word split too. "
           "Fill that answer for every end, left to right, so each one reads only ends already filled.",
     "ko": "앞 end글자는 그 끝에 오는 단어가 있고 그 단어 앞부분도 나뉠 때 나뉩니다. 모든 end에 대해 왼쪽부터 "
           "채우므로, 각 칸은 이미 채운 칸만 읽습니다."},
    views=[
        {"id": "message", "type": "array", "title": {"en": "message", "ko": "message (채팅 메시지)"}},
        {"id": "split", "type": "array",
         "title": {"en": "splittable: do the first end letters split?", "ko": "splittable: 앞 end글자가 나뉘는가?"}},
    ],
)


def q(text):
    return f"'{text}'"


def solve(message, words, run):
    """Solution.canSplitMessage with a frame per end. Returns the answer as the Driver prints it."""
    n = len(message)
    letters = list(message)
    splittable = [True] + [False] * n
    won = {}  # end -> the word that made it T

    def cells():
        return ["T" if v else "F" for v in splittable]

    def frame(caption, end=None, done=False, spans=None, tags=(), split_marks=None, letter_marks=None, moves=None,
              **answer):
        run.frame(caption,
                  message={"values": letters, "spans": spans or {}, "marks": letter_marks or {}},
                  split={"values": cells(), "pointers": {"end": end}, "tags": list(tags),
                         "marks": split_marks or {},
                         "unread": [] if done else list(range(1 if end is None else end + 1, n + 1))},
                  moves=moves, **answer)

    frame({"en": f"{n} letters. Cell 0, no letters at all, splits (T); every other cell starts F, not filled yet.",
           "ko": f"글자가 {n}개입니다. 글자가 하나도 없는 0번 칸은 나뉘는 것으로(T) 시작하고, 나머지 칸은 아직 "
                 "채우지 않은 F입니다."},
          split_marks={"good": [0]})
    for end in range(1, n + 1):
        prefix = message[:end]
        tried = []  # (word, start, splits) in the order any() reads them
        for word in words:
            start = end - len(word)
            if len(word) <= end and message.startswith(word, start):
                tried.append((word, start, splittable[start]))
                if splittable[start]:
                    break
        splittable[end] = any(ok for _, _, ok in tried)
        spans = {f"w{k}": span(start, end - 1, word, mark="good" if ok else "bad", below=not ok)
                 for k, (word, start, ok) in enumerate(tried)}
        tags = [[start, word] for word, start, _ in tried]
        if not tried:
            frame({"en": f"End {end}, {q(prefix)}: no known word ends it, so it can't split. It stays F.",
                   "ko": f"end {end}, {q(prefix)}: 끝에 오는 아는 단어가 없어 나눌 수 없습니다. F 그대로입니다."},
                  end=end, letter_marks={"lit": [end - 1]}, split_marks={"bad": [end]})
            continue
        en, ko = [], []
        for word, start, ok in tried:
            before = q(message[:start]) if start else "nothing"
            before_ko = f"{q(message[:start])} 부분" if start else "빈 앞부분"
            if ok:
                en.append(f"{q(word)} ends it, and {before} before it splits (cell {start} is T), so "
                          f"{q(prefix)} splits: T.")
                ko.append(f"단어 {q(word)}에서 끝나고 그 앞 {before_ko}이 나뉘므로(칸 {start} T), "
                          f"{q(prefix)} 부분도 나뉩니다: T.")
            else:
                en.append(f"{q(word)} ends it, but {before} before it doesn't split (cell {start} is F).")
                ko.append(f"단어 {q(word)}에서 끝나지만 그 앞 {before_ko}은 나뉘지 않습니다(칸 {start} F).")
        if not splittable[end]:
            en.append("No other word ends it, so it stays F.")
            ko.append("끝나는 다른 단어가 없어 F 그대로입니다.")
        moves = None
        if splittable[end]:
            word, start, _ = tried[-1]
            won[end] = word
            moves = [move(at("split", start), at("split", end), value="T"),
                     move(at("message", start), at("split", end), value=word)]
        frame({"en": f"End {end}: " + " ".join(en), "ko": f"end {end}: " + " ".join(ko)},
              end=end, spans=spans, tags=tags,
              split_marks={"lit": [s for _, s, _ in tried],
                           ("good" if splittable[end] else "bad"): [end]},
              moves=moves)
    if not splittable[n]:
        frame({"en": f"Cell {n} is F: no split of {q(message)} uses only known words. Answer: false.",
               "ko": f"{n}번 칸이 F입니다. {q(message)} 메시지는 아는 단어로만 나눌 수 없습니다. 답은 false입니다."},
              done=True, split_marks={"bad": [n]}, answer="false")
        return
    chain, parts, end = [n], [], n
    while end > 0:
        parts.append((end - len(won[end]), end))
        end -= len(won[end])
        chain.append(end)
    parts.reverse()
    split_words = [message[a:b] for a, b in parts]
    joined = " + ".join(q(w) for w in split_words)
    frame({"en": f"Cell {n} is T. Following each T back to the cell its word started from splits the message "
                 f"into {joined}. Answer: true.",
           "ko": f"{n}번 칸이 T입니다. 각 T 칸을 그 단어가 시작한 칸으로 거슬러 가면 메시지가 이렇게 나뉩니다: {joined}. "
                 "답은 true입니다."},
          done=True, spans={f"p{k}": span(a, b - 1, w, mark="path", below=True)
                            for k, ((a, b), w) in enumerate(zip(parts, split_words))},
          split_marks={"path": chain}, letter_marks={"path": list(range(n))}, answer="true")


for number, sample in enumerate(sample_cases(SLUG), start=1):
    message_line, words_line = sample["input"].split("\n")
    message, words = message_line.strip(), json.loads(words_line)
    run = sample_run(wt, number, sample, input=f"message = \"{message}\", words = {words_line}")
    solve(message, words, run)
# No sample reads a start cell that is F: here 'lo' and 'omg' both end in place after a prefix that doesn't split.
EXTRA_MESSAGE, EXTRA_WORDS = "yolomg", ["lo", "yolo", "omg"]
solve(EXTRA_MESSAGE, EXTRA_WORDS,
      wt.run({"en": "Extra: a word after a prefix that doesn't split", "ko": "추가: 앞부분이 나뉘지 않는 단어"},
             input=f"message = \"{EXTRA_MESSAGE}\", words = {driver_list(EXTRA_WORDS)}", expected="false",
             extra=True))
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
