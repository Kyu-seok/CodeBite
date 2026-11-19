#!/usr/bin/env python3.12
"""pair-lunchbox-snacks's Walkthrough: the reference solution
(scripts/replay-solutions/pair-lunchbox-snacks.py), weights sorted, a light pointer at the lightest snack left
and a heavy pointer at the heaviest, recording one frame per lunchbox packed on each sample Test Case. The
heaviest snack always takes a new lunchbox; the lightest joins it when the two fit under capacity. The snacks
still unpacked are a span between the pointers, and each lunchbox is a chip of the answer the snacks move into.

    CODEBITE_DB=<database> scripts/walkthroughs/pair-lunchbox-snacks.py

writes common/src/main/resources/walkthroughs/pair-lunchbox-snacks.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import josa, plural, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move, span  # noqa: E402

SLUG = "pair-lunchbox-snacks"

wt = Walkthrough(
    {"en": "Pair Lunchbox Snacks", "ko": "도시락 상자 짝짓기"},
    {"en": "Sort, then pack the heaviest snack left each time: it needs a lunchbox anyway, and the only partner "
           "worth trying is the lightest one. If even that one doesn't fit, nothing does, so the heaviest goes alone.",
     "ko": "정렬한 뒤 매번 남은 가장 무거운 간식을 담습니다. 어차피 도시락 하나가 필요하고, 짝으로 시도할 만한 건 가장 "
           "가벼운 간식뿐입니다. 그것도 안 들어가면 어떤 간식도 안 들어가니 무거운 간식은 혼자 들어갑니다."},
    views=[
        {"id": "weights", "type": "array", "title": {"en": "weights (sorted)", "ko": "weights (정렬한 간식 무게)"}},
        {"id": "boxes", "type": "output", "title": {"en": "lunchboxes", "ko": "도시락"},
         "empty": {"en": "none yet", "ko": "아직 없음"}},
        {"id": "state", "type": "vars"},
    ],
)


def solve(weights, capacity, run):
    """Solution.minLunchboxes with a frame per lunchbox. Returns the answer as the Driver prints it."""
    weights = sorted(weights)
    n = len(weights)
    light, heavy = 0, n - 1
    boxes = []

    def frame(caption, lit=(), good=(), bad=(), moves=None, done=False, **answer):
        left_over = light <= heavy and not done
        run.frame(caption,
                  weights={"values": weights,
                           "spans": {"left": span(light, heavy, {"en": "unpacked", "ko": "남은 간식"}, fade=True)
                                     if left_over else None},
                           "pointers": {"light": light if left_over else None,
                                        "heavy": heavy if left_over and heavy != light else None},
                           "marks": {"dim": [] if left_over or done else list(range(n)),
                                     "bad": list(bad), "good": list(good), "lit": list(lit)}},
                  boxes={"values": boxes,
                         "marks": {"path": list(range(len(boxes)))} if done else
                         {"good": [len(boxes) - 1]} if moves else {}},
                  state={"items": [{"label": {"en": "capacity", "ko": "capacity (도시락 한도)"}, "value": capacity}]},
                  moves=moves, **answer)

    frame({"en": f"{n} {plural(n, 'snack', 'snacks')}, sorted by weight; each lunchbox holds two at most and "
                 f"{capacity} grams. light starts at the lightest, heavy at the heaviest.",
           "ko": f"간식 {n}개를 무게순으로 정렬했고, 도시락에는 최대 두 개, {capacity}그램까지 들어갑니다. "
                 f"light는 가장 가벼운 간식, heavy는 가장 무거운 간식에서 시작합니다."})
    while light <= heavy:
        h = weights[heavy]
        number = len(boxes) + 1
        if light == heavy:
            boxes.append(str(h))
            frame({"en": f"One snack is left, {h} grams: it takes lunchbox {number} alone.",
                   "ko": f"간식이 하나 남았습니다. {h}그램 간식이 {number}번 도시락에 혼자 들어갑니다."},
                  good=[heavy], moves=[move(at("weights", heavy), at("boxes", number - 1), mark="good")])
            heavy -= 1
            continue
        l = weights[light]
        if l + h <= capacity:
            boxes.append(f"{h} + {l}")
            frame({"en": f"Heaviest {h} + lightest {l} = {l + h} ≤ {capacity}: they share lunchbox {number}, "
                         f"and both pointers move in.",
                   "ko": f"가장 무거운 {h} + 가장 가벼운 {l} = {l + h} ≤ {capacity}, {number}번 도시락에 같이 "
                         f"들어가고 두 포인터가 모두 안으로 옵니다."},
                  good=[light, heavy],
                  moves=[move(at("weights", heavy), at("boxes", number - 1), mark="good"),
                         move(at("weights", light), at("boxes", number - 1), mark="good")])
            light += 1
        else:
            boxes.append(str(h))
            frame({"en": f"Heaviest {h} + lightest {l} = {l + h} > {capacity}: no snack fits beside {h}, so it "
                         f"takes lunchbox {number} alone and heavy moves in.",
                   "ko": f"가장 무거운 {h} + 가장 가벼운 {l} = {l + h} > {capacity}, {h}그램 간식 옆에는 어떤 간식도 "
                         f"안 들어가 {number}번 도시락에 혼자 들어가고 heavy가 안으로 옵니다."},
                  good=[heavy], bad=[light],
                  moves=[move(at("weights", heavy), at("boxes", number - 1), mark="good")])
        heavy -= 1
    count = len(boxes)
    pairs = sum(" + " in b for b in boxes)
    shared_en = f"{pairs} of them holding a pair" if pairs else "no two snacks could share one"
    shared_ko = f"도시락 {count}개 중 {pairs}개에 두 개씩 들어갔고" if pairs else f"두 간식이 함께 들어간 도시락 없이 {count}개를 썼고"
    frame({"en": f"Every snack is packed: {count} {plural(count, 'lunchbox', 'lunchboxes')}, {shared_en}. "
                 f"Answer {count}.",
           "ko": f"모든 간식을 담았습니다. {shared_ko}, 답은 {count}입니다."},
          done=True, answer=str(count))


for number, sample in enumerate(sample_cases(SLUG), start=1):
    lines = sample["input"].split("\n")
    weights, capacity = json.loads(lines[0]), int(lines[1])
    run = sample_run(wt, number, sample, input=f"weights = {lines[0].strip()}, capacity = {capacity}")
    solve(weights, capacity, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
