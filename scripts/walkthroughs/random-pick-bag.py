#!/usr/bin/env python3.12
"""random-pick-bag's Walkthrough: the reference solution (scripts/replay-solutions/random-pick-bag.py), a list of the
cards plus a map from each card to its index in the list, driven by the sample's list of calls, recording one frame
per call on each sample Test Case.

drawRandom is random.choice(cards), which has one right answer only when the bag holds one card. Every sample draws
from a bag of one (the description says so), and this tracer refuses a draw from a bigger bag rather than draw an
answer the code can't promise.

The call-list pattern (add-walkthrough views.md): the calls are a table, one row per call, the current one lit and
those before it faded, each call's return value moves into an `output` (the Driver's printed list), and the list and
the map change underneath.

    CODEBITE_DB=<database> scripts/walkthroughs/random-pick-bag.py

writes common/src/main/resources/walkthroughs/random-pick-bag.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import driver_list, josa, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move  # noqa: E402

SLUG = "random-pick-bag"

wt = Walkthrough(
    {"en": "Random Pick Bag", "ko": "무작위로 뽑는 가방"},
    {"en": "Keep the cards in a list, for a uniform draw by index, and a map from each card to its index, for "
           "constant-time lookup. A remove fills the removed card's slot with the last card, so the list never has a gap.",
     "ko": "카드를 리스트에 두어 인덱스로 고르게 뽑고, 카드마다 리스트 인덱스를 맵에 두어 상수 시간에 찾습니다. "
           "제거할 때는 마지막 카드로 빈 자리를 채워, 리스트에 구멍이 생기지 않게 합니다."},
    views=[
        {"id": "calls", "type": "table", "title": {"en": "calls", "ko": "호출"}},
        {"id": "cards", "type": "array", "title": {"en": "cards (list)", "ko": "cards (리스트)"},
         "empty": {"en": "empty", "ko": "비어 있음"}},
        {"id": "where", "type": "map", "title": {"en": "where (card → index)", "ko": "where (카드 → 인덱스)"},
         "empty": {"en": "empty", "ko": "비어 있음"}},
        {"id": "result", "type": "output", "title": {"en": "returned", "ko": "반환값"}},
    ],
)


def solve(ops, args, run):
    """The Driver's loop over the calls with the reference RandomBag inside, a frame per call. Returns the printed
    list."""
    n = len(ops)
    rows = [{"label": str(i), "cells": [op, ", ".join(str(x) for x in a)]} for i, (op, a) in enumerate(zip(ops, args))]
    cards, where, result = [], {}, []
    drawn = [0]
    i = 0

    def frame(caption, shown=None, held=None, leaving=None, card_marks=None, map_marks=None, probe=None, path=False,
              moves=None, **answer):
        """`shown` and `held` draw the list and the map mid-step, when a card leaving stays drawn for the step it
        leaves; `leaving` is the key struck in the map."""
        fresh = list(range(drawn[0], len(result)))
        drawn[0] = len(result)
        bag = {"entries": [{"key": c, "value": f"i={j}"} for c, j in (where if held is None else held).items()],
               "marks": map_marks or {}}
        if leaving is not None:
            bag["struck"] = [leaving]
        if probe is not None:
            bag["probe"] = probe
        run.frame(caption,
                  calls={"columns": [{"en": "call", "ko": "호출"}, {"en": "argument", "ko": "인자"}], "rows": rows,
                         "marks": {} if path else {"dim": [[r, c] for r in range(i) for c in (0, 1)],
                                                    "lit": [[i, 0], [i, 1]]}},
                  cards={"values": cards if shown is None else shown, "marks": card_marks or {}},
                  where=bag,
                  result={"values": result, "marks": {"path": list(range(len(result)))} if path else {"good": fresh}},
                  moves=moves, **answer)

    def back(value):
        """A boolean the call returns, moving from its call cell into the output."""
        result.append(json.dumps(value))
        return move(at("calls", [i, 0]), at("result", len(result) - 1), value=json.dumps(value))

    result.append("null")
    frame({"en": "RandomBag() starts with an empty list of cards and an empty map from card to index. It returns null.",
           "ko": "RandomBag(): 빈 카드 리스트와 카드 → 인덱스의 빈 맵으로 시작합니다. null을 반환합니다."})
    for i in range(1, n):
        op = ops[i]
        if op == "insert":
            val = args[i][0]
            if val in where:
                frame({"en": f"insert({val}): {val} is already in where, so nothing changes and it returns false.",
                       "ko": f"insert({val}): where에 카드 {val}번이 이미 있으므로 아무것도 바꾸지 않고 false를 "
                             "반환합니다."},
                      card_marks={"lit": [where[val]]}, probe={"key": val}, moves=[back(False)])
                continue
            where[val] = len(cards)
            cards.append(val)
            j = len(cards) - 1
            frame({"en": f"insert({val}): {val} isn't in where, so it goes on the end of the list at index {j}, and "
                         f"where records {val} → {j}. It returns true.",
                   "ko": f"insert({val}): where에 카드 {val}번이 없으므로 리스트 끝 인덱스 {j} 자리에 넣고, where에 "
                         f"{val} → {j} 항목을 적습니다. true를 반환합니다."},
                  card_marks={"good": [j]}, map_marks={"good": [val]}, probe={"key": val, "hit": False},
                  moves=[move(at("calls", [i, 1]), at("cards", j), value=str(val)),
                         move(at("cards", j), at("where", val), value=f"i={j}"), back(True)])
        elif op == "remove":
            val = args[i][0]
            if val not in where:
                frame({"en": f"remove({val}): {val} isn't in where, so nothing changes and it returns false.",
                       "ko": f"remove({val}): where에 카드 {val}번이 없으므로 아무것도 바꾸지 않고 false를 반환합니다."},
                      probe={"key": val}, moves=[back(False)])
                continue
            before, held = cards[:], dict(where)
            j = where.pop(val)
            last = cards.pop()
            last_at = len(before) - 1
            if last != val:
                cards[j] = last
                where[last] = j
                held[last] = j
                # mid-step: the last slot still holds `last` as it leaves, and slot j already holds it
                frame({"en": f"remove({val}): where gives index {j}; the last card, {last}, moves into slot {j} over "
                             f"{val}, its index becomes {j}, and the last slot is popped off. It returns true.",
                       "ko": f"remove({val}): where에서 인덱스 {josa(j, '을를')} 얻고, 마지막 카드 {last}번이 {j}번 자리의 "
                             f"{val}번 위로 옮겨 오고 인덱스가 {josa(j, '(으)로')} 바뀌며, 마지막 자리는 리스트에서 뺍니다. "
                             "true를 반환합니다."},
                      shown=cards + [last], held=held, leaving=val, card_marks={"good": [j], "lit": [last_at]},
                      map_marks={"bad": [val], "good": [last]}, probe={"key": val},
                      moves=[move(at("cards", last_at), at("cards", j), value=str(last)),
                             move(at("cards", j), at("where", last), value=f"i={j}"),
                             move(at("where", val), mark="bad"), back(True)])
            else:
                frame({"en": f"remove({val}): where gives index {j}, the last slot, so the card is simply popped off "
                             "the end. It returns true.",
                       "ko": f"remove({val}): where에서 얻은 인덱스 {josa(j, '이가')} 마지막 자리이므로 카드를 리스트 끝에서 "
                             "그냥 뺍니다. true를 반환합니다."},
                      shown=before, held=held, leaving=val, card_marks={"bad": [j]}, map_marks={"bad": [val]},
                      probe={"key": val},
                      moves=[move(at("cards", j), mark="bad"), move(at("where", val), mark="bad"), back(True)])
        elif op == "drawRandom":
            if len(cards) != 1:
                raise SystemExit(f"{SLUG}: drawRandom from {len(cards)} cards has no one right answer to draw")
            result.append(json.dumps(cards[0]))
            frame({"en": f"drawRandom(): random.choice picks an index from 0 to {len(cards) - 1}; the bag holds one "
                         f"card, so it can only return {cards[0]}.",
                   "ko": f"drawRandom(): random.choice가 0부터 {len(cards) - 1}까지의 인덱스 하나를 고릅니다. 가방에 "
                         f"카드가 한 장뿐이므로 {cards[0]}번만 나올 수 있습니다."},
                  card_marks={"lit": [0]}, moves=[move(at("cards", 0), at("result", len(result) - 1))])
        else:
            raise ValueError(op)
    printed = driver_list([json.loads(v) for v in result])
    frame({"en": f"Every call is answered, in order: answer {printed}.",
           "ko": f"모든 호출의 반환값을 차례로 모았습니다. 답은 {printed}입니다."},
          path=True, answer=printed)
    return printed


for number, sample in enumerate(sample_cases(SLUG), start=1):
    ops_line, args_line = sample["input"].split("\n")
    run = sample_run(wt, number, sample, input=sample["input"])
    solve(json.loads(ops_line), json.loads(args_line), run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
