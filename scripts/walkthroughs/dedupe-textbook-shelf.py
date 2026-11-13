#!/usr/bin/env python3.12
"""dedupe-textbook-shelf's Walkthrough: the reference solution
(scripts/replay-solutions/dedupe-textbook-shelf.py), a read pointer i and a write pointer k over the
sorted shelf, recording one frame per book read on each sample Test Case.

    CODEBITE_DB=<database> scripts/walkthroughs/dedupe-textbook-shelf.py

writes common/src/main/resources/walkthroughs/dedupe-textbook-shelf.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough  # noqa: E402

SLUG = "dedupe-textbook-shelf"

wt = Walkthrough(
    {"en": "Dedupe Textbook Shelf", "ko": "책꽂이 중복 정리"},
    {"en": "The shelf is sorted, so a repeat sits right after its copy: compare each book with the last one kept "
           "(books[k-1]) and copy it to slot k only when it differs.",
     "ko": "책꽂이가 정렬되어 있어 같은 책은 바로 붙어 있습니다. 각 책을 마지막으로 남긴 책(books[k-1])과 비교해, "
           "다를 때만 k 자리에 옮겨 씁니다."},
    views=[
        {"id": "books", "type": "array", "title": "books"},
        {"id": "state", "type": "vars"},
    ],
)


def solve(books, run):
    """Solution.compactShelf with a frame per book read. Returns the answer as the Driver prints it."""
    n = len(books)
    k = 1
    i = None

    def stale_and_unread():
        """Slots k..i-1 hold copies the front has moved past (overwritten or never checked), and slots after
        i are not read yet: both are out of play."""
        return [j for j in range(k, n) if j != i]

    def frame(caption, lit=(), good=(), path=(), dim=(), k_mark=None, **answer):
        run.frame(caption,
                  books={"values": books, "pointers": {"k": k if k < n else None, "i": i},
                         "marks": {"dim": list(dim), "path": list(path), "good": list(good), "lit": list(lit)}},
                  state={"items": [{"label": {"en": "k (books kept)", "ko": "k (남긴 책 수)"}, "value": k,
                                    "mark": k_mark}]},
                  **answer)

    frame({"en": f"{n} {'book' if n == 1 else 'books'}. The first book is always kept, so k starts at 1: "
                 f"books[0..k-1] is the compacted front. "
                 + ("Read on from index 1." if n > 1 else "There is no other book to read."),
           "ko": f"책 {n}권입니다. 첫 책은 항상 남으므로 k는 1에서 시작합니다. books[0..k-1]이 정리된 앞쪽입니다. "
                 + ("인덱스 1부터 읽습니다." if n > 1 else "더 읽을 책이 없습니다.")},
          good=[0], dim=range(1, n))
    for i in range(1, n):
        last = books[k - 1]
        if books[i] != last:
            books[k] = books[i]
            k += 1
            frame({"en": f"books[{i}] = {books[i]} differs from the last kept book, {last}: a new value. "
                         f"Write it to slot {k - 1} and k becomes {k}.",
                   "ko": f"books[{i}] = {books[i]} ≠ {last}(마지막으로 남긴 책): 새 값입니다. "
                         f"{k - 1}번 자리에 쓰고 k를 늘려 k = {k}입니다."},
                  lit=[i], good=[k - 1], dim=stale_and_unread(), k_mark="good")
        else:
            frame({"en": f"books[{i}] = {books[i]} equals the last kept book: a repeat. Skip it; k stays {k}.",
                   "ko": f"books[{i}] = {books[i]} = {last}(마지막으로 남긴 책): 중복입니다. 건너뛰고 k = {k} 그대로입니다."},
                  lit=[i, k - 1], dim=stale_and_unread())
    i = None
    front = books[:k]
    shown = ", ".join(map(str, front))
    if n == 1:
        why = {"en": "One book, nothing to compare", "ko": "책이 한 권이라 비교할 것이 없습니다"}
    else:
        why = {"en": f"Every book read. The front holds the {k} distinct values in order ({shown})",
               "ko": f"모든 책을 읽었습니다. 앞쪽에 서로 다른 값 {k}개가 순서대로 있습니다({shown})"}
    tail = {"en": f"; slots from {k} on aren't checked" if k < n else "",
            "ko": f". {k}번 자리부터는 검사하지 않습니다" if k < n else ""}
    frame({"en": f"{why['en']}{tail['en']}. Answer k = {k}.",
           "ko": f"{why['ko']}{tail['ko']}. 답은 k = {k}입니다."},
          path=range(k), dim=range(k, n), k_mark="good",
          answer=f"{k}\n{json.dumps(front, separators=(',', ':'))}")


for number, sample in enumerate(sample_cases(SLUG), start=1):
    books = json.loads(sample["input"])
    run = sample_run(wt, number, sample, input=f"books = {sample['input']}")
    solve(books, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
