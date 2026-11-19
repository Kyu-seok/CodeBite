#!/usr/bin/env python3.12
"""online-friend-mask's Walkthrough: the reference solution (scripts/replay-solutions/online-friend-mask.py),
mask &= mask - 1 until the mask is 0, recording one frame per 1 bit cleared on each sample Test Case. The mask is a
grid of bits, one row per byte, the highest byte first, drawn with as many bytes as the run needs; each bit is
tagged with its number, which is the friend's. Each cleared bit moves into the count.

    CODEBITE_DB=<database> scripts/walkthroughs/online-friend-mask.py

writes common/src/main/resources/walkthroughs/online-friend-mask.json.
"""
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import josa, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move  # noqa: E402

SLUG = "online-friend-mask"

wt = Walkthrough(
    {"en": "Online Friend Count", "ko": "접속 중인 친구 수"},
    {"en": "mask & (mask − 1) is mask with its lowest 1 bit cleared, so count how many times that runs before "
           "the mask is 0: one per friend online.",
     "ko": "mask & (mask − 1)은 mask에서 가장 낮은 1 비트를 끈 값이므로, mask가 0이 될 때까지 이 연산을 "
           "몇 번 하는지 세면 접속 중인 친구 수입니다."},
    views=[
        {"id": "mask", "type": "grid",
         "title": {"en": "mask, one byte per row (tag: bit = friend)", "ko": "mask, 행마다 1바이트 (태그: 비트 = 친구 번호)"},
         "values": {"1": {"label": {"en": "online", "ko": "접속 중"}, "tone": "a"},
                    "0": {"label": {"en": "offline", "ko": "접속 안 함"}, "tone": "plain"}}},
        {"id": "count", "type": "output", "title": {"en": "count", "ko": "count (접속 중인 친구)"}},
    ],
)


def solve(friend_mask, run):
    """Solution.countOnlineFriends with a frame per bit cleared. Returns the count."""
    mask = friend_mask & 0xFFFFFFFF
    rows = max(1, (mask.bit_length() + 7) // 8)
    width = rows * 8

    def cell(bit):
        p = width - 1 - bit
        return [p // 8, p % 8]

    def grid(v):
        return [[(v >> (width - 1 - (8 * r + c))) & 1 for c in range(8)] for r in range(rows)]

    tags = [[*cell(b), str(b)] for b in range(width)]
    count = 0

    def frame(caption, good=(), path=False, moves=None, **answer):
        run.frame(caption,
                  mask={"cells": grid(mask), "tags": tags,
                        "marks": {"good": [cell(b) for b in good],
                                  "path": [cell(b) for b in range(width) if friend_mask >> b & 1] if path else []}},
                  count={"values": [count], "marks": {"path": [0]} if path else {"good": [0]} if moves else {}},
                  moves=moves, **answer)

    shown = f"{rows} byte{'s' if rows > 1 else ''}"
    frame({"en": f"friendMask = {friend_mask}, drawn as its low {shown} (the bits above are 0). count starts at 0; "
                 "each pass of mask &= mask − 1 clears the lowest 1 bit.",
           "ko": f"friendMask = {friend_mask}의 아래 {rows}바이트를 그렸습니다(그 위 비트는 0). count는 0에서 시작하고, "
                 "mask &= mask − 1을 한 번 할 때마다 가장 낮은 1 비트가 꺼집니다."})
    while mask:
        low = (mask & -mask).bit_length() - 1
        mask &= mask - 1
        count += 1
        if low:
            how = {"en": f"mask − 1 turns the lowest 1 (bit {low}) into 0 and the 0s below it into 1s, so the & clears only bit {low}",
                   "ko": f"mask − 1은 가장 낮은 1({low}번 비트)을 0으로, 그 아래 0들을 1로 바꾸므로 & 하면 {low}번 비트만 꺼집니다"}
        else:
            how = {"en": "The lowest 1 is bit 0, which mask − 1 turns into 0, so the & clears it",
                   "ko": "가장 낮은 1은 0번 비트이고 mask − 1이 그 비트를 0으로 바꾸므로 & 하면 그 비트가 꺼집니다"}
        frame({"en": f"{how['en']}: friend {low} is counted, count = {count}, mask = {mask}.",
               "ko": f"{how['ko']}. 친구 {josa(low, '을를')} 세어 count = {count}, mask = {josa(mask, '이가')} 됩니다."},
              good=[low],
              moves=[move(at("mask", cell(low)), at("count", 0), value="+1", mark="good"),
                     move(None, at("mask", cell(low)), value="0")])
    if count:
        why = {"en": f"mask is 0, so every 1 bit was cleared once: {count} friend{'s' if count > 1 else ''} online",
               "ko": f"mask가 0이 되었으니 1 비트를 모두 한 번씩 껐습니다. 접속 중인 친구는 {count}명"}
    else:
        why = {"en": "mask was 0 from the start: nobody is online", "ko": "mask가 처음부터 0이라 접속 중인 친구가 없습니다"}
    frame({"en": f"{why['en']}. Answer {count}.", "ko": f"{why['ko']}. 답은 {count}입니다."},
          path=True, answer=str(count))
    return count


for number, sample in enumerate(sample_cases(SLUG), start=1):
    friend_mask = int(sample["input"])
    run = sample_run(wt, number, sample, input=f"friendMask = {friend_mask}")
    solve(friend_mask, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
