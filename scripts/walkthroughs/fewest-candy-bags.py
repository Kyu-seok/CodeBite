#!/usr/bin/env python3.12
"""fewest-candy-bags' Walkthrough: the reference solution (scripts/replay-solutions/fewest-candy-bags.py), a
table of the fewest bags for every amount from 0 to quota, filled left to right, recording one frame per amount
on each sample Test Case.

Each amount reads the cells one bag size back (tagged with that size), and the best of them plus one bag moves
into its cell. The tracer keeps which size won at each amount, so the last frame marks the chain of amounts the
answer's bags step through.

    CODEBITE_DB=<database> scripts/walkthroughs/fewest-candy-bags.py

writes common/src/main/resources/walkthroughs/fewest-candy-bags.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import bag_text, josa, plural, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move  # noqa: E402

SLUG = "fewest-candy-bags"
INF = "∞"

wt = Walkthrough(
    {"en": "Fewest Candy Bags", "ko": "최소 사탕 봉지 수"},
    {"en": "Fill a table of the fewest bags for every amount from 0 up to the quota: an amount's last bag is "
           "one of the sizes, so it is one more than the best of the amounts one bag size back.",
     "ko": "0부터 quota까지 모든 개수에 대해 최소 봉지 수 표를 채웁니다. 마지막 봉지는 크기 중 하나이므로, "
           "봉지 크기만큼 앞선 개수들 중 최솟값에 1을 더한 값이 됩니다."},
    views=[
        {"id": "sizes", "type": "array", "title": {"en": "bag sizes", "ko": "bagSizes (봉지 크기)"}},
        {"id": "fewest", "type": "array", "title": {"en": "fewest bags for each amount",
                                                    "ko": "사탕 개수별 최소 봉지 수"}},
    ],
)


def solve(bag_sizes, quota, run):
    """Solution.fewestBags with a frame per amount. Returns the answer as the Driver prints it."""
    unreachable = quota + 1
    fewest = [0] + [unreachable] * quota
    won = {}  # amount -> the bag size whose cell it was filled from

    def shown():
        return [INF if v == unreachable else v for v in fewest]

    def frame(caption, total=None, cells=None, size_marks=None, tags=(), moves=None, unread=None, **answer):
        run.frame(caption,
                  sizes={"values": bag_sizes, "marks": size_marks or {}},
                  fewest={"values": shown(), "pointers": {"total": total}, "marks": cells or {},
                          "tags": list(tags), "unread": [] if unread is None else unread},
                  moves=moves, **answer)

    if quota == 0:
        frame({"en": f"The quota is 0: the table is just amount 0, which needs 0 bags.",
               "ko": "quota가 0이므로 표에는 개수 0 하나뿐이고, 봉지가 0개 필요합니다."},
              cells={"lit": [0]})
    else:
        frame({"en": f"Amount 0 needs 0 bags. Every other amount up to {quota} starts as ∞, not packed yet.",
               "ko": f"사탕 0개에는 봉지가 0개 필요합니다. {quota}까지의 나머지 개수는 아직 담을 수 없는 ∞로 시작합니다."},
              cells={"good": [0]}, unread=list(range(1, quota + 1)))
    for total in range(1, quota + 1):
        tried = [s for s in bag_sizes if s <= total]
        read, read_ko = [], []
        for size in bag_sizes:
            if size <= total and fewest[total - size] + 1 < fewest[total]:
                fewest[total] = fewest[total - size] + 1
                won[total] = size
        for s in tried:
            v = fewest[total - s]
            read.append(f"{total - s} ({INF})" if v == unreachable else f"{total - s} ({v} + 1)")
            read_ko.append(f"{total - s}개({INF})" if v == unreachable else f"{total - s}개({v} + 1)")
        tags = [[total - s, bag_text(s)] for s in tried]
        sizes_marks = {"lit": [i for i, s in enumerate(bag_sizes) if s <= total],
                       "dim": [i for i, s in enumerate(bag_sizes) if s > total]}
        unread = list(range(total + 1, quota + 1))
        if not tried:
            frame({"en": f"Amount {total}: every bag is bigger than {total}, so it can't be packed. It stays ∞.",
                   "ko": f"사탕 {total}개: 모든 봉지가 {total}보다 커서 담을 수 없습니다. ∞ 그대로입니다."},
                  total=total, size_marks=sizes_marks, unread=unread)
            continue
        froms_en = read[0] if len(read) == 1 else ", ".join(read[:-1]) + " or " + read[-1]
        froms_ko = read_ko[0] if len(read_ko) == 1 else ", ".join(read_ko[:-1]) + " 또는 " + read_ko[-1]
        if total in won:
            size = won[total]
            src = total - size
            best = fewest[total]
            frame({"en": f"Amount {total} is one bag added to amount {froms_en}. The fewest is amount {src}'s "
                         f"{best - 1} {plural(best - 1, 'bag', 'bags')} plus a bag of {size}: {best}.",
                   "ko": f"사탕 {total}개는 사탕 {froms_ko}에 봉지 하나를 더한 것입니다. 가장 적은 것은 사탕 "
                         f"{src}개의 {best - 1}개에 크기 {size} 봉지를 더한 {best}개입니다."},
                  total=total, cells={"lit": [total - s for s in tried], "good": [total]}, size_marks=sizes_marks,
                  tags=tags, unread=unread,
                  moves=[move(at("fewest", src), at("fewest", total), value=f"{best - 1}+1")])
        else:
            every_en, every_ko = ("all ∞", "모두 ∞입니다") if len(read) > 1 else ("which is ∞", "∞입니다")
            frame({"en": f"Amount {total} is one bag added to amount {froms_en}, {every_en}. It can't be packed "
                         "either, so it stays ∞.",
                   "ko": f"사탕 {total}개는 사탕 {froms_ko}에 봉지 하나를 더한 것인데, {every_ko}. 이 개수도 "
                         "담을 수 없어 ∞ 그대로입니다."},
                  total=total, cells={"lit": [total - s for s in tried]}, size_marks=sizes_marks, tags=tags,
                  unread=unread)
    if fewest[quota] == unreachable:
        frame({"en": f"Amount {quota} is still ∞: no mix of bag sizes sums to exactly {quota}. Answer: -1.",
               "ko": f"사탕 {quota}개는 여전히 ∞입니다. 어떤 봉지 조합으로도 합이 정확히 {josa(quota, '이가')} "
                     "되지 않으므로 답은 -1입니다."},
              cells={"bad": [quota]}, answer="-1")
        return
    chain, amount = [], quota
    while amount > 0:
        chain.append(amount)
        amount -= won[amount]
    chain.append(0)
    used = [won[a] for a in chain[:-1]]
    k = fewest[quota]
    if quota == 0:
        en = "Answer: 0 bags."
        ko = "답은 봉지 0개입니다."
    else:
        en = (f"Amount {quota} needs {k} {plural(k, 'bag', 'bags')}. Following each cell back to the one it came "
              f"from: {' + '.join(map(str, used))} = {quota}.")
        ko = (f"사탕 {quota}개에는 봉지가 {k}개 필요합니다. 각 칸이 온 칸을 거슬러 가면 "
              f"{' + '.join(map(str, used))} = {quota}입니다.")
    frame({"en": en, "ko": ko}, cells={"path": chain},
          tags=[[a - won[a], bag_text(won[a])] for a in chain[:-1]], answer=str(k))


for number, sample in enumerate(sample_cases(SLUG), start=1):
    sizes_line, quota_line = sample["input"].split("\n")
    bag_sizes, quota = json.loads(sizes_line), int(quota_line)
    run = sample_run(wt, number, sample, input=f"bagSizes = {sizes_line}, quota = {quota}")
    solve(bag_sizes, quota, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
