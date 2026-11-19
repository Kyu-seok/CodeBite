#!/usr/bin/env python3.12
"""split-candy-bar-for-max-product's Walkthrough: the reference solution
(scripts/replay-solutions/split-candy-bar-for-max-product.py), a table of the largest product from every length,
kept whole or split further, filled left to right, recording one frame per length on each sample Test Case.

A length's inner loop reads every shorter length as the rest after a first piece: one frame per read would make
about 50 frames for length 11, so each length's reads are one frame. Each cell read carries under it the product
that choice gives (`first×rest`, the rest kept whole or at its own best, whichever is larger), and the best moves
into the length's cell. The tracer keeps each length's winning first piece and whether its rest stayed whole, so
the last frame marks the cells the answer's pieces come from.

    CODEBITE_DB=<database> scripts/walkthroughs/split-candy-bar-for-max-product.py

writes common/src/main/resources/walkthroughs/split-candy-bar-for-max-product.json.
"""
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import josa, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move  # noqa: E402

SLUG = "split-candy-bar-for-max-product"

wt = Walkthrough(
    {"en": "Split Candy Bar for Max Product", "ko": "곱이 최대가 되게 사탕 막대 쪼개기"},
    {"en": "Fill best[k], the largest product from a bar of k, kept whole or split. A bar of total breaks off a "
           "first piece, and the rest is either kept whole or split at its own best, whichever is larger.",
     "ko": "best[k]는 길이 k 막대를 그대로 두거나 쪼개서 얻는 가장 큰 곱입니다. 길이 total 막대는 첫 조각을 "
           "떼어 내고, 나머지는 그대로 두거나 나머지의 best로 쪼개는 것 중 큰 쪽을 씁니다."},
    views=[
        {"id": "best", "type": "array",
         "title": {"en": "best product per length", "ko": "best (길이별 최대 곱)"}},
    ],
)


def solve(length, run):
    """Solution.maxSplitProduct with a frame per length."""
    best = [0] * (length + 1)
    best[1] = 1
    first_of, whole = {}, {}  # length -> its winning first piece, and whether the rest stayed whole

    def frame(caption, total=None, marks=None, under=(), tags=(), moves=None, **answer):
        run.frame(caption,
                  best={"values": list(best), "pointers": {"total": total}, "marks": marks or {},
                        "under": list(under), "tags": list(tags),
                        "unread": [] if total is None and answer else list(range((total or 1) + 1, length + 1))},
                  moves=moves, **answer)

    frame({"en": f"A bar of {length}. best[0] = 0 is never used, and best[1] = 1: a bar of 1 can't be split, so "
                 "it only counts kept whole.",
           "ko": f"길이 {length} 막대입니다. best[0] = 0은 쓰이지 않고, 길이 1은 쪼갤 수 없으니 best[1] 값은 "
                 "그대로 둔 1입니다."},
          marks={"good": [1], "dim": [0]})
    for total in range(2, length + 1):
        under = []
        win = None
        for first in range(1, total):
            rest = max(total - first, best[total - first])
            under.append([total - first, f"{first}×{rest}"])
            if first * rest > best[total]:
                best[total] = first * rest
                win = first
        rest_len = total - win
        first_of[total], whole[total] = win, rest_len >= best[rest_len]
        rest = max(rest_len, best[rest_len])
        how_en = (f"the rest {rest_len} kept whole" if whole[total] else
                  f"the rest {rest_len} split for best[{rest_len}] = {best[rest_len]}")
        how_ko = (f"나머지 길이 {josa(rest_len, '을를')} 그대로 둔" if whole[total] else
                  f"나머지 길이 {josa(rest_len, '을를')} best[{rest_len}] = {josa(best[rest_len], '(으)로')} 쪼갠")
        frame({"en": f"Bar {total}: each first piece times its rest is under the rest's cell. The largest is "
                     f"{win} × {rest} = {best[total]}, {how_en}.",
               "ko": f"길이 {total}: 첫 조각마다 첫 조각 × 나머지가 나머지 칸 아래에 있습니다. 가장 큰 것은 "
                     f"{how_ko} {win} × {rest} = {best[total]}입니다."},
              total=total, marks={"lit": list(range(1, total)), "good": [total], "dim": [0]}, under=under,
              moves=[move(at("best", rest_len), at("best", total), value=f"{win}×{rest}")])
    pieces, cells, tags, k = [], [], [], length
    while True:
        cells.append(k)
        first = first_of[k]
        pieces.append(first)
        tags.append([k, {"en": f"piece {first}", "ko": f"조각 {first}"}])
        if whole[k]:
            pieces.append(k - first)
            cells.append(k - first)
            tags.append([k - first, {"en": "kept whole", "ko": "그대로"}])
            break
        k -= first
    pieces.sort(reverse=True)
    total_en = " + ".join(map(str, pieces))
    product_en = " × ".join(map(str, pieces))
    frame({"en": f"best[{length}] = {best[length]}. Following each cell to its rest: {length} = {total_en}, and "
                 f"{product_en} = {best[length]}.",
           "ko": f"best[{length}] = {best[length]}입니다. 각 칸을 나머지로 따라가면 {length} = {total_en}이고, "
                 f"{product_en} = {best[length]}입니다."},
          marks={"path": cells, "dim": [0]},
          tags=tags,
          answer=str(best[length]))


for number, sample in enumerate(sample_cases(SLUG), start=1):
    length = int(sample["input"])
    run = sample_run(wt, number, sample, input=f"length = {length}")
    solve(length, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
