#!/usr/bin/env python3.12
"""group-study-cards' Walkthrough: the reference solution (scripts/replay-solutions/group-study-cards.py), a count
of each card, then a walk over the cards in increasing order where the smallest card left must start as many groups
as it has copies, each of the next groupSize - 1 cards giving up that many copies, on each sample Test Case.

The counts are a `map`, its cards in increasing order (the order the walk reads them; a Counter's own order is the
order the cards come in). Each card read moves into its card as +1; each card taken into a group leaves its count
(a dropped −1) and moves into the group it joins, an `output` chip that grows to `[1,2]`. A count that reaches 0
stays drawn as 0, dimmed, as the Counter keeps it, and a later start on it is skipped.

    CODEBITE_DB=<database> scripts/walkthroughs/group-study-cards.py

writes common/src/main/resources/walkthroughs/group-study-cards.json.
"""
import json
import os
import sys
from collections import Counter

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import josa, plural, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move, span  # noqa: E402

SLUG = "group-study-cards"

wt = Walkthrough(
    {"en": "Group Study Cards", "ko": "스터디 카드 묶기"},
    {"en": "Count each card. The smallest card left can only be the start of a group, so it starts as many groups as "
           "it has copies, and each of the next groupSize - 1 numbers must have that many copies to give.",
     "ko": "카드마다 장수를 셉니다. 남은 카드 중 가장 작은 카드는 묶음의 첫 카드일 수밖에 없으므로 장수만큼 묶음을 "
           "시작하고, 그다음 groupSize - 1개의 숫자도 그만큼씩 내줄 수 있어야 합니다."},
    views=[
        {"id": "cards", "type": "array", "title": {"en": "cards", "ko": "cards (카드)"}},
        {"id": "left", "type": "map", "title": {"en": "copies left of each card", "ko": "카드별 남은 장수"},
         "empty": {"en": "none counted yet", "ko": "아직 세지 않음"}},
        {"id": "groups", "type": "output", "title": {"en": "groups", "ko": "묶음"},
         "empty": {"en": "none yet", "ko": "아직 없음"}},
        {"id": "state", "type": "vars"},
    ],
)


def group_text(copies, first, last, closed):
    numbers = ",".join(str(c) for c in range(first, last + 1))
    return f"{copies}×[{numbers}{']' if closed else ''}" if copies > 1 else f"[{numbers}{']' if closed else ''}"


def solve(cards, size, run):
    """Solution.canGroupCards with a frame per card counted and per card taken. Returns the answer as the Driver prints it."""
    n = len(cards)
    left = Counter()
    groups = []

    def frame(caption, i=None, card_marks=None, cards_span=None, left_marks=None, probe=None, group_marks=None,
              moves=None, **answer):
        entries = [{"key": k, "value": left[k]} for k in sorted(left)]
        zero = [k for k in sorted(left) if left[k] == 0]
        marks = {"dim": zero}
        for k, v in (left_marks or {}).items():
            marks[k] = v
        state = {"entries": entries, "marks": marks}
        if probe is not None:
            state["probe"] = probe
        run.frame(caption,
                  cards={"values": cards, "pointers": {"i": i},
                         "spans": {"all": cards_span} if cards_span else {}, "marks": card_marks or {}},
                  left=state,
                  groups={"values": list(groups), "marks": group_marks or {}},
                  state={"items": [{"label": {"en": "groupSize", "ko": "groupSize (묶음 크기)"}, "value": size}]},
                  moves=moves, **answer)

    count_text = {"en": f"{n} {plural(n, 'card', 'cards')}", "ko": f"카드 {n}장"}
    if n % size:
        frame({"en": f"{n} {plural(n, 'card', 'cards')}, to be dealt into groups of {size}.",
               "ko": f"카드 {n}장을 {size}장씩 묶어야 합니다."})
        frame({"en": f"{n} isn't a multiple of {size}: {n} cards can't split evenly into groups of {size}. "
                     "Answer: false.",
               "ko": f"{josa(n, '은는')} {size}의 배수가 아니라서 카드 {n}장을 {size}장씩 나눌 수 없습니다. "
                     "답은 false입니다."},
              cards_span=span(0, n - 1, count_text, mark="bad"), card_marks={"bad": list(range(n))}, answer="false")
        return
    frame({"en": f"{n} {plural(n, 'card', 'cards')} into groups of {size}: {n} is a multiple of {size}, so first "
                 "count the copies of each card.",
           "ko": f"카드 {n}장을 {size}장씩 묶습니다. {josa(n, '은는')} {size}의 배수이므로 먼저 카드마다 장수를 "
                 "셉니다."},
          cards_span=span(0, n - 1, count_text, mark="good"))
    for i, card in enumerate(cards):
        left[card] += 1
        frame({"en": f"Card {card}: it now has {left[card]} {plural(left[card], 'copy', 'copies')}.",
               "ko": f"카드 {card}: 지금까지 {left[card]}장입니다."},
              i=i, card_marks={"lit": [i]}, left_marks={"good": [card]},
              moves=[move(at("cards", i), at("left", card), value="+1")])

    for start in sorted(left):
        copies = left[start]
        look = {"key": start, "hit": copies > 0, "label": {"en": f"{start} left?", "ko": f"{start} 남음?"}}
        if copies == 0:
            frame({"en": f"Card {start} has 0 copies left: every copy already went into an earlier group, so no "
                         "group starts here.",
                   "ko": f"카드 {start}에는 남은 장이 없습니다. 모두 앞의 묶음에 들어갔으므로 여기서 시작하는 묶음은 "
                         "없습니다."},
                  probe=look, left_marks={"lit": [start]})
            continue
        g = len(groups)
        for card in range(start, start + size):
            have = left[card] if card in left else 0
            look = {"key": card, "hit": card in left and have >= copies,
                    "label": {"en": f"{card} left?", "ko": f"{card} 남음?"}}
            if have < copies:
                missing_en = "isn't in the pile" if card not in left else f"has only {have} left"
                missing_ko = "더미에 없습니다" if card not in left else f"{have}장만 남았습니다"
                frame({"en": f"The group from {start} needs card {card} next, but {card} {missing_en}: the group "
                             "can't be finished. Answer: false.",
                       "ko": f"{start}부터의 묶음에는 다음으로 카드 {josa(card, '이가')} 필요한데, {card} 카드는 "
                             f"{missing_ko}. 묶음을 채울 수 없으므로 답은 false입니다."},
                      probe=look, left_marks={"bad": [card]} if card in left else {},
                      group_marks={"bad": [g]}, answer="false")
                return
            left[card] -= copies
            closed = card == start + size - 1
            text = group_text(copies, start, card, closed)
            if card == start:
                groups.append(text)
            else:
                groups[g] = text
            moves = [move(at("left", card), value=f"−{copies}"),
                     move(at("left", card), at("groups", g), value=str(card))]
            if card == start:
                en = (f"The smallest card left is {start}, with {copies} {plural(copies, 'copy', 'copies')}: "
                      f"{'it' if copies == 1 else 'each'} can only start a group, so take {start}.")
                ko = (f"남은 카드 중 가장 작은 카드는 {start}이고 {copies}장 있습니다. 묶음의 첫 카드일 수밖에 없으므로 "
                      f"{josa(start, '을를')} 가져갑니다.")
            else:
                en = (f"The group from {start} needs {card} next, and {card} has {have} left: take "
                      f"{copies}{' and the group is full' if closed else ''}.")
                ko = (f"{start}부터의 묶음에는 다음으로 {josa(card, '이가')} 필요하고 {have}장 남았으니 {copies}장을 "
                      f"가져갑니다{'. 묶음이 다 찼습니다' if closed else ''}.")
            frame({"en": en, "ko": ko}, probe=look, left_marks={"lit": [card]}, group_marks={"good": [g]},
                  moves=moves)
    k = len(groups)
    frame({"en": f"Every card went into a group: {k} {plural(k, 'group', 'groups')} of {size}, "
                 f"{', '.join(groups)}. Answer: true.",
           "ko": f"모든 카드가 묶음에 들어갔습니다. {size}장짜리 묶음 {k}개, {', '.join(groups)}입니다. 답은 true입니다."},
          group_marks={"path": list(range(k))}, answer="true")


for number, sample in enumerate(sample_cases(SLUG), start=1):
    cards_line, size_line = sample["input"].split("\n")
    cards, size = json.loads(cards_line), int(size_line)
    run = sample_run(wt, number, sample, input=f"cards = {cards_line}, groupSize = {size}")
    solve(cards, size, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
