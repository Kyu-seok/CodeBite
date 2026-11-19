#!/usr/bin/env python3.12
"""crush-heaviest-blocks' Walkthrough: the reference solution (scripts/replay-solutions/crush-heaviest-blocks.py), a
max-heap of the weights (heapq on negated weights, drawn with the weights themselves), run on each sample Test Case
with heapq's heapify, pop and push written out as the textbook sift-down and sift-up, one swap per frame. A pop is one
frame: the root leaves for the crusher and the last node fills the root at once, as heappop does; the swaps that
follow are a frame each. The two blocks popped sit in a two-cell crusher, and what is left of the heavier goes back
in at the heap's end.

    CODEBITE_DB=<database> scripts/walkthroughs/crush-heaviest-blocks.py

writes common/src/main/resources/walkthroughs/crush-heaviest-blocks.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import driver_list, josa, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, level_order_tree, move, swap  # noqa: E402

SLUG = "crush-heaviest-blocks"

wt = Walkthrough(
    {"en": "Crush Heaviest Blocks", "ko": "가장 무거운 블록 부수기"},
    {"en": "A max-heap keeps the heaviest block on top, so each round pops the two heaviest in two pops, and pushes "
           "back what is left of the heavier one. The last block left in the heap is the answer, or 0 when none is left.",
     "ko": "최대 힙은 가장 무거운 블록을 맨 위에 두므로, 매 라운드 두 번 꺼내 가장 무거운 두 블록을 얻고, 무거운 쪽에서 남은 "
           "무게를 다시 넣습니다. 힙에 마지막으로 남은 블록이 답이고, 없으면 0입니다."},
    views=[
        {"id": "blocks", "type": "array", "title": {"en": "blocks", "ko": "blocks (블록)"}},
        {"id": "heap", "type": "tree", "arity": 2,
         "title": {"en": "max-heap: heaviest on top ([i]: array index)", "ko": "최대 힙: 맨 위가 가장 무거움 ([i]: 배열 인덱스)"},
         "empty": {"en": "empty", "ko": "비어 있음"}},
        {"id": "crusher", "type": "array",
         "title": {"en": "crusher: y (heaviest), x", "ko": "부수는 자리: y (가장 무거움), x"}},
        {"id": "result", "type": "output", "title": {"en": "answer", "ko": "답"},
         "empty": {"en": "not yet", "ko": "아직 없음"}},
    ],
)


def solve(blocks, run):
    """Solution.crushHeaviestBlocks with heapq written out, a frame per step. Returns the answer as printed."""
    n = len(blocks)
    heap = []
    crusher = ["", ""]
    out = []
    st = {"draw": None, "copied": False, "crush": {}}

    def frame(caption, marks=None, block_marks=None, moves=None, done=False, **answer):
        shown = st["draw"] if st["draw"] is not None else heap
        node_marks = {"path": [0]} if done and shown and out else (marks or {})
        cm = st["crush"]
        if not cm and any(crusher):
            cm = {"dim": [0, 1]}
        bm = block_marks if block_marks is not None else ({"dim": list(range(n))} if st["copied"] else {})
        run.frame(caption,
                  blocks={"values": blocks, "marks": bm},
                  heap={**level_order_tree(list(shown)), "tags": [[j, f"[{j}]"] for j in range(len(shown))],
                        "nodeMarks": node_marks},
                  crusher={"values": list(crusher), "tags": [[0, "y"], [1, "x"]], "marks": cm},
                  result={"values": list(out), "marks": {"path": [0]} if out else {}},
                  moves=moves, **answer)

    def sift_down(j):
        """Swap the weight at j down to its heavier child while that child is heavier."""
        while True:
            big = j
            for c in (2 * j + 1, 2 * j + 2):
                if c < len(heap) and heap[c] > heap[big]:
                    big = c
            if big == j:
                return
            a, b = heap[j], heap[big]
            heap[j], heap[big] = b, a
            frame({"en": f"Sift down: {a} at [{j}] is lighter than its heavier child {b} at [{big}], so they swap.",
                   "ko": f"아래로 내리기: [{j}]의 {josa(a, '은는')} 더 무거운 자식 [{big}]의 {b}보다 가벼우므로 자리를 "
                         f"바꿉니다."},
                  marks={"good": [j], "lit": [big]}, moves=swap("heap", j, big, a, b))
            j = big

    def sift_up(j):
        """Swap the weight at j up while it is heavier than its parent."""
        while j > 0:
            p = (j - 1) // 2
            if heap[j] <= heap[p]:
                return
            a, b = heap[j], heap[p]
            heap[j], heap[p] = b, a
            frame({"en": f"Sift up: {a} at [{j}] is heavier than its parent {b} at [{p}], so they swap.",
                   "ko": f"위로 올리기: [{j}]의 {josa(a, '은는')} 부모 [{p}]의 {b}보다 무거우므로 자리를 바꿉니다."},
                  marks={"good": [p], "lit": [j]}, moves=swap("heap", j, p, a, b))
            j = p

    def pop(slot, name):
        """heappop into crusher[slot], as one frame: the root leaves and the last node fills it; then the sift."""
        top = heap[0]
        crusher[slot] = top
        st["crush"] = {"good": [slot], **({"dim": [1]} if slot == 0 and crusher[1] != "" else {})}
        last = heap.pop()
        if heap:
            k = len(heap)
            heap[0] = last
            st["draw"] = heap + [last]
            frame({"en": f"heappop: the root {top} is the {name} block left; it goes to the crusher as "
                         f"{'y' if slot == 0 else 'x'}, and the last node {last} at [{k}] fills the root.",
                   "ko": f"heappop: 루트 {josa(top, '이가')} 남은 블록 중 {'가장' if slot == 0 else '두 번째로'} "
                         f"무겁습니다. {'y' if slot == 0 else 'x'} 자리로 옮기고, 마지막 노드 [{k}]의 "
                         f"{josa(last, '이가')} 루트를 채웁니다."},
                  marks={"good": [0]},
                  moves=[move(at("heap", 0), at("crusher", slot), value=str(top)), move(at("heap", k), at("heap", 0))])
            st["draw"] = None
            st["crush"] = {}
            sift_down(0)
        else:
            st["draw"] = [top]
            frame({"en": f"heappop: the root {top}, the only block left in the heap, goes to the crusher as "
                         f"{'y' if slot == 0 else 'x'}.",
                   "ko": f"heappop: 힙에 하나 남은 루트 {josa(top, '이가')} {'y' if slot == 0 else 'x'} 자리로 "
                         f"갑니다."},
                  marks={"lit": [0]}, moves=[move(at("heap", 0), at("crusher", slot))])
            st["draw"] = None
            st["crush"] = {}
        return top

    frame({"en": f"{n} {'block' if n == 1 else 'blocks'}: {driver_list(blocks)}. A max-heap will keep the heaviest "
                 f"on top, so the two heaviest are always two pops away.",
           "ko": f"블록 {n}개: {driver_list(blocks)}. 최대 힙이 가장 무거운 블록을 맨 위에 두므로, 가장 무거운 두 블록은 "
                 f"언제나 두 번 꺼내면 나옵니다."})
    heap.extend(blocks)
    st["copied"] = True
    frame({"en": f"The {n} weights go into the heap list in their order; heapify then sifts each parent down, from "
                 f"the last one to the root.",
           "ko": f"무게 {n}개를 순서대로 힙 리스트에 넣습니다. 이어서 heapify가 마지막 부모부터 루트까지 차례로 아래로 "
                 f"내립니다."},
          marks={"good": list(range(n))}, block_marks={"lit": list(range(n))},
          moves=[move(at("blocks", i), at("heap", i)) for i in range(n)])
    for j in reversed(range(len(heap) // 2)):
        sift_down(j)
    while len(heap) > 1:
        y = pop(0, "heaviest")
        x = pop(1, "second heaviest")
        if y != x:
            heap.append(y - x)
            j = len(heap) - 1
            st["crush"] = {"lit": [0], "bad": [1]}
            frame({"en": f"Crush {y} and {x}: {x} is destroyed and {y} becomes {y} − {x} = {y - x}, which goes back "
                         f"in at the heap's end, [{j}].",
                   "ko": f"{josa(y, '과와')} {josa(x, '을를')} 부딪칩니다. {josa(x, '은는')} 사라지고 {josa(y, '은는')} "
                         f"{y} − {x} = {josa(y - x, '이가')} 되어 힙의 맨 끝 [{j}]에 다시 들어갑니다."},
                  marks={"good": [j]},
                  moves=[move(at("crusher", 1), mark="bad"),
                         move(at("crusher", 0), at("heap", j), value=str(y - x))])
            st["crush"] = {}
            sift_up(j)
        else:
            st["crush"] = {"bad": [0, 1]}
            frame({"en": f"Crush {y} and {x}: they weigh the same, so both are pulverized and nothing goes back.",
                   "ko": f"{josa(y, '과와')} {josa(x, '을를')} 부딪칩니다. 무게가 같으므로 둘 다 산산조각 나고 다시 넣을 것이 "
                         f"없습니다."},
                  moves=[move(at("crusher", 0), mark="bad"), move(at("crusher", 1), mark="bad")])
            st["crush"] = {}
    if heap:
        answer = heap[0]
        out.append(str(answer))
        frame({"en": f"Only one block is left in the heap, so the crushing stops: the last block weighs {answer}.",
               "ko": f"힙에 블록이 하나만 남아 부수기가 끝납니다. 마지막 블록의 무게는 {answer}입니다."},
              moves=[move(at("heap", 0), at("result", 0))], done=True, answer=str(answer))
    else:
        answer = 0
        out.append("0")
        frame({"en": "The heap is empty: every block was pulverized, so the answer is 0.",
               "ko": "힙이 비었습니다. 모든 블록이 산산조각 났으므로 답은 0입니다."},
              moves=[move(None, at("result", 0), value="0")], done=True, answer="0")
    return answer


for number, sample in enumerate(sample_cases(SLUG), start=1):
    blocks = json.loads(sample["input"])
    run = sample_run(wt, number, sample, input=f"blocks = {driver_list(blocks)}")
    solve(blocks, run)
wt.write(walkthrough_path(SLUG))
