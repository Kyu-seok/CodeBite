#!/usr/bin/env python3.12
"""kth-highest-raid-score's Walkthrough: the reference solution (scripts/replay-solutions/kth-highest-raid-score.py),
a min-heap that keeps the k highest scores read so far, with heapq's push and replace written out as the textbook
sift-up and sift-down, one swap per frame. The heap is drawn as a tree, each node tagged with its array index; each
score read moves from its cell into the heap, a score that doesn't beat the root is skipped, and the root at the end,
the lowest of the k highest, moves into the answer.

    CODEBITE_DB=<database> scripts/walkthroughs/kth-highest-raid-score.py

writes common/src/main/resources/walkthroughs/kth-highest-raid-score.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import josa, plural, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, level_order_tree, move, swap  # noqa: E402

SLUG = "kth-highest-raid-score"

wt = Walkthrough(
    {"en": "K-th Highest Raid Score", "ko": "K번째로 높은 레이드 점수"},
    {"en": "Keep the k highest scores so far in a min-heap: its root is the lowest of them, so a new score either "
           "beats the root and replaces it, or can't be among the k highest. After the last score the root is the "
           "k-th highest.",
     "ko": "지금까지 가장 높은 점수 k개를 최소 힙에 둡니다. 루트가 그중 가장 낮은 점수이므로, 새 점수는 루트보다 높으면 루트를 "
           "밀어내고, 아니면 높은 k개에 들 수 없습니다. 마지막 점수까지 읽고 나면 루트가 k번째로 높은 점수입니다."},
    views=[
        {"id": "scores", "type": "array", "title": {"en": "scores", "ko": "scores (점수)"}},
        {"id": "heap", "type": "tree", "arity": 2,
         "title": {"en": "min-heap of the k highest ([i]: array index)", "ko": "높은 점수 k개의 최소 힙 ([i]: 배열 인덱스)"},
         "empty": {"en": "empty", "ko": "비어 있음"}},
        {"id": "result", "type": "output", "title": {"en": "answer", "ko": "답"}, "empty": {"en": "not yet", "ko": "아직 없음"}},
        {"id": "state", "type": "vars"},
    ],
)


def ordinal(k):
    return f"{k}{'th' if 10 <= k % 100 <= 20 else {1: 'st', 2: 'nd', 3: 'rd'}.get(k % 10, 'th')}"


def top(k):
    """'the 3 highest' in English, or 'the highest' when k is 1."""
    return "the highest" if k == 1 else f"the {k} highest"


def solve(scores, k, run):
    """Solution.kthHighestScore with heapq's sifts written out, a frame per score read and per swap.
    Returns the answer as the Driver prints it."""
    n = len(scores)
    heap = []
    out = []
    dropped = []   # cells whose score left the heap or never got in
    i = None

    def frame(caption, cell=None, cell_mark="lit", nodes=None, moves=None, done=False, **answer):
        marks = {}
        if done:
            marks = {"path": [0]}
        elif nodes:
            marks = nodes
        cells = {"dim": list(dropped)}
        if cell is not None:
            cells[cell_mark] = [cell]
        run.frame(caption,
                  scores={"values": scores, "pointers": {"i": i} if i is not None and not done else {},
                          "unread": list(range(0 if i is None else i + 1, n)), "marks": cells},
                  heap={**level_order_tree(heap), "tags": [[j, f"[{j}]"] for j in range(len(heap))], "nodeMarks": marks},
                  result={"values": out, "marks": {"path": [0]} if out else {}},
                  state={"items": [{"label": "k", "value": k}]},
                  moves=moves, **answer)

    def sift_up(j, x):
        """Swap the new score at index j up while it is lower than its parent."""
        while j > 0:
            p = (j - 1) // 2
            if heap[j] >= heap[p]:
                return
            a, b = heap[j], heap[p]
            heap[j], heap[p] = b, a
            src[j], src[p] = src[p], src[j]
            stop = p == 0 or heap[p] >= heap[(p - 1) // 2]
            then = ({"en": " It is at the root now." if p == 0 else
                           f" Its new parent [{(p - 1) // 2}] holds {heap[(p - 1) // 2]}, not higher, so it stops.",
                     "ko": " 이제 루트입니다." if p == 0 else
                           f" 새 부모 [{(p - 1) // 2}]의 {josa(heap[(p - 1) // 2], '은는')} 더 높지 않으므로 멈춥니다."}
                    if stop else {"en": "", "ko": ""})
            frame({"en": f"Sift up: {a} at [{j}] is lower than its parent {b} at [{p}], so they swap.{then['en']}",
                   "ko": f"위로 올리기: [{j}]의 {josa(a, '은는')} 부모 [{p}]의 {b}보다 낮으므로 자리를 바꿉니다.{then['ko']}"},
                  nodes={"good": [p], "lit": [j]}, moves=swap("heap", j, p, a, b))
            j = p

    def sift_down(j):
        """Swap the score at index j down to its lower child while that child is lower."""
        size = len(heap)
        while True:
            left, right = 2 * j + 1, 2 * j + 2
            low = j
            if left < size and heap[left] < heap[low]:
                low = left
            if right < size and heap[right] < heap[low]:
                low = right
            if low == j:
                return
            a, b = heap[j], heap[low]
            heap[j], heap[low] = b, a
            src[j], src[low] = src[low], src[j]
            kids = [c for c in (2 * low + 1, 2 * low + 2) if c < size]
            stop = not kids or all(heap[c] >= heap[low] for c in kids)
            then = ({"en": " No child below is lower, so it stops." if kids else " It is a leaf now, so it stops.",
                     "ko": " 아래 자식이 더 낮지 않으므로 멈춥니다." if kids else " 이제 잎 노드이므로 멈춥니다."}
                    if stop else {"en": "", "ko": ""})
            frame({"en": f"Sift down: {a} at [{j}] is higher than its lower child {b} at [{low}], so they swap.{then['en']}",
                   "ko": f"아래로 내리기: [{j}]의 {josa(a, '은는')} 더 낮은 자식 [{low}]의 {b}보다 높으므로 자리를 "
                         f"바꿉니다.{then['ko']}"},
                  nodes={"good": [j], "lit": [low]}, moves=swap("heap", j, low, a, b))
            j = low

    src = []   # src[j]: the cell heap[j] came from
    frame({"en": f"{n} {plural(n, 'score', 'scores')}, k = {k}. The min-heap will hold {top(k)} "
                 f"{plural(k, 'score', 'scores')} read so far, so its root is always the lowest of them.",
           "ko": f"점수 {n}개, k = {k}입니다. 최소 힙에 지금까지 읽은 점수 중 가장 높은 {k}개를 두므로, 루트는 언제나 "
                 f"그중 가장 낮은 점수입니다."})
    for i, x in enumerate(scores):
        if len(heap) < k:
            heap.append(x)
            src.append(i)
            j = len(heap) - 1
            p = (j - 1) // 2
            if j == 0:
                rest = {"en": "it is the root.", "ko": "루트가 됩니다."}
            elif x >= heap[p]:
                rest = {"en": f"its parent {heap[p]} at [{p}] is not higher, so it stays.",
                        "ko": f"부모 [{p}]의 {josa(heap[p], '은는')} 더 높지 않으므로 그대로 둡니다."}
            else:
                rest = {"en": f"it is lower than its parent {heap[p]} at [{p}], so it sifts up.",
                        "ko": f"부모 [{p}]의 {heap[p]}보다 낮으므로 위로 올립니다."}
            frame({"en": f"The heap holds {j} of {k}, so push {x}: it goes in at the end, [{j}]; " + rest["en"],
                   "ko": f"힙에 {j}개뿐이고 {k}개까지 둘 수 있으므로 {josa(x, '을를')} 넣습니다. 맨 끝 [{j}]에 "
                         f"들어가고, " + rest["ko"]},
                  cell=i, nodes={"good": [j]},
                  moves=[move(at("scores", i), at("heap", j))])
            sift_up(j, x)
        elif x > heap[0]:
            old = heap[0]
            dropped.append(src[0])
            heap[0] = x
            src[0] = i
            kids = [c for c in (1, 2) if c < len(heap)]
            low = min(kids, key=lambda c: heap[c]) if kids else None
            rest = ({"en": f"{x} is higher than its lower child {heap[low]}, so it sifts down.",
                     "ko": f"{josa(x, '은는')} 더 낮은 자식 {heap[low]}보다 높으므로 아래로 내립니다."}
                    if low is not None and heap[low] < x else
                    {"en": "no child is lower, so it stays.", "ko": "더 낮은 자식이 없으므로 그대로 둡니다."})
            frame({"en": f"{x} beats the root {old}, the lowest of {top(k)}: {old} leaves and {x} takes the "
                         f"root; " + rest["en"],
                   "ko": f"{josa(x, '은는')} 높은 {k}개 중 가장 낮은 루트 {old}보다 높습니다. {josa(old, '은는')} 빠지고 "
                         f"{josa(x, '이가')} 루트에 들어가며, " + rest["ko"]},
                  cell=i, nodes={"good": [0]},
                  moves=[move(at("heap", 0), at("scores", dropped[-1]), value=old, mark="bad"), move(at("scores", i), at("heap", 0))])
            sift_down(0)
        else:
            dropped.append(i)
            frame({"en": f"{x} is not higher than the root {heap[0]}, and the heap already holds {k} "
                         f"{plural(k, 'score', 'scores')} at least {heap[0]}, so {x} can't be among {top(k)}: skip it.",
                   "ko": f"{josa(x, '은는')} 루트 {heap[0]}보다 높지 않고, 힙에는 이미 {heap[0]} 이상인 점수가 {k}개 "
                         f"있으므로 {josa(x, '은는')} 높은 {k}개에 들 수 없어 건너뜁니다."},
                  cell=i, cell_mark="bad", nodes={"lit": [0]},
                  moves=[move(at("scores", i), mark="bad")])
    answer = heap[0]
    out.append(str(answer))
    frame({"en": f"Every score is read. The heap holds {top(k)}, and its root {answer} is the lowest of them: "
                 f"the {ordinal(k)} highest score is {answer}.",
           "ko": f"모든 점수를 읽었습니다. 힙에는 가장 높은 {k}개가 있고, 그중 가장 낮은 루트 {josa(answer, '이가')} "
                 f"{k}번째로 높은 점수입니다."},
          moves=[move(at("heap", 0), at("result", 0))], done=True, answer=str(answer))
    return answer


for number, sample in enumerate(sample_cases(SLUG), start=1):
    lines = sample["input"].split("\n")
    scores, k = json.loads(lines[0]), int(lines[1])
    run = sample_run(wt, number, sample, input=f"scores = {json.dumps(scores, separators=(',', ':'))}, k = {k}")
    solve(scores, k, run)
wt.write(walkthrough_path(SLUG))
