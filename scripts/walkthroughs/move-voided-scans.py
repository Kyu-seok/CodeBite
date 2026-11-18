#!/usr/bin/env python3.12
"""move-voided-scans's Walkthrough: the reference solution
(scripts/replay-solutions/move-voided-scans.py), a read pointer and a write pointer moving the same way
over scans, recording one frame per scan read and one per slot zeroed on each sample Test Case. The
kept prices are a span over scans[0..write-1]; a real price moves from its slot into slot write, and the
second loop writes a 0 into every slot from write on, a span of voids growing at the back.

    CODEBITE_DB=<database> scripts/walkthroughs/move-voided-scans.py

writes common/src/main/resources/walkthroughs/move-voided-scans.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import driver_list, josa, plural, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move, span  # noqa: E402

SLUG = "move-voided-scans"

wt = Walkthrough(
    {"en": "Move Voided Scans", "ko": "취소 주문 뒤로 밀기"},
    {"en": "Two pointers in the same direction, in place: read walks every scan and write marks the next slot "
           "of the kept front, so each real price moves forward to slot write in order; then every slot from "
           "write on becomes a 0.",
     "ko": "같은 방향으로 가는 두 포인터로 제자리에서 바꿉니다. read는 모든 주문을 읽고 write는 남길 앞쪽의 다음 자리를 "
           "가리켜, 실제 가격은 순서대로 write 자리로 당겨집니다. 그다음 write부터 끝까지를 0으로 채웁니다."},
    views=[
        {"id": "scans", "type": "array", "title": {"en": "scans", "ko": "scans (주문 가격)"}},
    ],
)


def solve(scans, run):
    """Solution.moveVoidsToEnd with a frame per step. Returns the answer as the Driver prints it."""
    n = len(scans)
    write = 0
    read = None
    zero_from = None  # where the second loop started, once it has

    def frame(caption, lit=(), good=(), path=(), dim=(), kept_mark=None, voids_to=None, moves=None,
              done=False, **answer):
        spans = {"kept": span(0, write - 1, {"en": f"kept {write}", "ko": f"남긴 가격 {write}개"},
                              mark="path" if done else kept_mark) if write else None}
        if voids_to is not None:
            count = voids_to - zero_from + 1
            spans["voids"] = span(zero_from, voids_to, {"en": f"voids {count}", "ko": f"취소 {count}개"},
                                  mark="path" if done else "good", below=True)
        pointers = {} if done else {"write": write if write < n else None, "read": read, "i": voids_to}
        run.frame(caption,
                  scans={"values": scans, "pointers": pointers, "spans": spans,
                         "unread": list(range(read + 1, n)) if read is not None
                         else list(range(n)) if zero_from is None else [],
                         "marks": {"dim": list(dim), "path": list(path), "good": list(good), "lit": list(lit)}},
                  moves=moves, **answer)

    zeros = scans.count(0)
    frame({"en": f"{n} {plural(n, 'scan', 'scans')}, {zeros} of them voided (0). write starts at slot 0: "
                 f"the next slot of the kept front.",
           "ko": f"주문 {n}개 중 {zeros}개가 취소(0)입니다. write는 0번 자리에서 시작하며, 남길 앞쪽의 다음 자리를 가리킵니다."})
    for read in range(n):
        scan = scans[read]
        if scan != 0:
            if read == write:
                scans[write] = scan
                write += 1
                frame({"en": f"scans[{read}] = {scan} is a real price and already sits in slot write = {read}. "
                             f"Keep it; write moves on to {write}.",
                       "ko": f"scans[{read}] = {scan}: 실제 가격이고 이미 write = {read} 자리에 있습니다. "
                             f"그대로 두고 write는 {josa(write, '(으)로')} 갑니다."},
                      good=[read], kept_mark="good")
            else:
                scans[write] = scan
                write += 1
                frame({"en": f"scans[{read}] = {scan} is a real price: copy it forward into slot {write - 1}, "
                             f"right after the last kept one, and write moves on to {write}.",
                       "ko": f"scans[{read}] = {scan}: 실제 가격이므로 마지막으로 남긴 가격 바로 뒤인 {write - 1}번 자리로 "
                             f"당겨 쓰고, write는 {josa(write, '(으)로')} 갑니다."},
                      lit=[read], good=[write - 1], kept_mark="good",
                      moves=[move(at("scans", read), at("scans", write - 1))])
        else:
            frame({"en": f"scans[{read}] = 0 is a void: skip it. write stays at {write}, so the next real price "
                         f"lands over it.",
                   "ko": f"scans[{read}] = 0: 취소 주문이므로 건너뜁니다. write는 {write}에 머물러, "
                         f"다음 실제 가격이 그 자리를 덮어씁니다."},
                  lit=[read])
    read = None
    zero_from = write
    if write == n:
        frame({"en": "Every scan was a real price, so no slot is left to zero.",
               "ko": "모든 주문이 실제 가격이라 0으로 채울 자리가 없습니다."})
    for i in range(write, n):
        was = scans[i]
        scans[i] = 0
        if i == write:
            kept_en = "slot 0" if write == 1 else f"slots 0..{write - 1}"
            kept_ko = "0번 자리" if write == 1 else f"0..{write - 1}번 자리"
            intro = {"en": f"Every price is kept in {kept_en}, so i walks the slots from write = {write} on, writing 0s. ",
                     "ko": f"모든 가격이 {kept_ko}에 남았으니 i가 write = {write}부터 끝까지 가며 0을 씁니다. "}
        else:
            intro = {"en": f"i = {i}: ", "ko": f"i = {i}: "}
        if was != 0:
            frame({"en": intro["en"] + f"Slot {i} still holds a stale {was}: write a 0 over it.",
                   "ko": intro["ko"] + f"{i}번 자리에는 옛 값 {josa(was, '이가')} 남아 있어 0으로 덮어씁니다."},
                  good=[i], voids_to=i, moves=[move(dst=at("scans", i), value="0")])
        else:
            frame({"en": intro["en"] + f"Slot {i} gets a 0; it already held one.",
                   "ko": intro["ko"] + f"{i}번 자리에 0을 씁니다(이미 0이었음)."},
                  good=[i], voids_to=i)
    frame({"en": f"The {write} real {plural(write, 'price keeps its', 'prices keep their')} order at the front and "
                 f"the {n - write} {plural(n - write, 'void sits', 'voids sit')} at the end: {driver_list(scans)}.",
           "ko": f"실제 가격 {write}개가 순서대로 앞에, 취소 주문 {n - write}개가 끝에 놓였습니다: {driver_list(scans)}."},
          path=range(n), voids_to=n - 1 if write < n else None, done=True, answer=driver_list(scans))


for number, sample in enumerate(sample_cases(SLUG), start=1):
    scans = json.loads(sample["input"])
    run = sample_run(wt, number, sample, input=f"scans = {sample['input']}")
    solve(scans, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
