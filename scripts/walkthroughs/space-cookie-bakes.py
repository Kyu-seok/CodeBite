#!/usr/bin/env python3.12
"""space-cookie-bakes' Walkthrough: the reference solution (scripts/replay-solutions/space-cookie-bakes.py), on each
sample Test Case: count each kind, refuse when one kind has more than (n + 1) // 2 batches, else sort the letters
most frequent first and lay them into the even slots and then the odd ones, one frame per letter. The Driver checks
the order returned and prints valid, or an empty line for "", so that is each run's answer.

    CODEBITE_DB=<database> scripts/walkthroughs/space-cookie-bakes.py

writes common/src/main/resources/walkthroughs/space-cookie-bakes.json.
"""
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, map_entries, move  # noqa: E402

SLUG = "space-cookie-bakes"
EMPTY = {"en": "empty", "ko": "비어 있음"}

wt = Walkthrough(
    {"en": "Space the Cookie Bakes", "ko": "쿠키 사이 간격 두기"},
    {"en": "Lay the batches, most frequent kind first, into slots 0, 2, 4, … and then 1, 3, 5, …: each kind fills a "
           "run of every other slot, so no two of a kind touch, as long as no kind has more than (n + 1) // 2 "
           "batches, the number of even slots.",
     "ko": "가장 많은 종류부터 판을 0, 2, 4, … 칸에 놓고 이어서 1, 3, 5, … 칸에 놓습니다. 한 종류가 한 칸씩 건너 이어서 "
           "채워지므로 같은 종류끼리 붙지 않습니다. 단, 어떤 종류도 짝수 칸의 개수인 (n + 1) // 2판보다 많으면 안 됩니다."},
    views=[
        {"id": "cookies", "type": "array", "title": {"en": "cookies", "ko": "cookies (쿠키)"}},
        {"id": "counts", "type": "map", "title": {"en": "batches per kind", "ko": "종류별 판 수"}, "empty": EMPTY},
        {"id": "letters", "type": "array",
         "title": {"en": "letters, most frequent kind first", "ko": "많은 종류부터 정렬한 글자"}},
        {"id": "slots", "type": "array", "title": {"en": "baking order", "ko": "굽는 순서"}},
        {"id": "result", "type": "output", "title": {"en": "returned", "ko": "반환값"}, "empty": {"en": "not yet", "ko": "아직 없음"}},
        {"id": "state", "type": "vars"},
    ],
)


def solve(cookies, run):
    """Solution.spaceBakes with a frame per step. Returns what the Driver prints."""
    n = len(cookies)
    limit = (n + 1) // 2
    counts = {}
    letters = [""] * n
    result = [""] * n
    out = []
    st = {"cookies": {}, "map": {}, "letters": {}, "slots": {}, "ptr": None}

    def frame(caption, moves=None, **answer):
        views = {
            "cookies": {"values": list(cookies), "marks": st["cookies"]},
            "counts": {"entries": map_entries(counts), "marks": st["map"]},
            "result": {"values": list(out), "marks": {"path": [0]} if out else {}},
            "state": {"items": [{"label": {"en": "limit (n + 1) // 2", "ko": "한도 (n + 1) // 2"}, "value": limit}]},
        }
        views["letters"] = {"values": list(letters), "marks": st["letters"]}
        views["slots"] = {"values": list(result), "marks": st["slots"],
                          "pointers": {"slot": st["ptr"]} if st["ptr"] is not None else {}}
        run.frame(caption, moves=moves, **views, **answer)

    frame({"en": f"{n} batches: \"{cookies}\". No kind may have more than (n + 1) // 2 = {limit} batches, or two "
                 f"of it must touch. First count each kind.",
           "ko": f"쿠키 {n}판: \"{cookies}\". 어떤 종류도 (n + 1) // 2 = {limit}판보다 많으면 같은 종류 두 판이 반드시 "
                 f"붙습니다. 먼저 종류마다 판 수를 셉니다."})
    for c in cookies:
        counts[c] = counts.get(c, 0) + 1
    st["cookies"] = {"lit": list(range(n))}
    st["map"] = {"good": list(counts)}
    frame({"en": "Counter(cookies): each batch moves into its kind's card. " +
                 ", ".join(f"'{k}': {v}" for k, v in counts.items()) + ".",
           "ko": "Counter(cookies): 판마다 자기 종류 카드로 들어갑니다. " +
                 ", ".join(f"'{k}' 종류 {v}판" for k, v in counts.items()) + "."},
          moves=[move(at("cookies", i), at("counts", c)) for i, c in enumerate(cookies)])
    st["cookies"] = {"dim": list(range(n))}
    most = max(counts.values())
    top = min(k for k, v in counts.items() if v == most)
    if most > limit:
        st["map"] = {"bad": [top]}
        out.append('""')
        frame({"en": f"Kind '{top}' has {most} batches, more than {limit}: any order puts two of them back to back, "
                     f"so return \"\", and the judge prints an empty line.",
               "ko": f"'{top}' 종류가 {most}판으로 {limit}판보다 많아, 어떻게 놓아도 두 판이 연달아 구워지므로 빈 문자열을 "
                     f"반환하고, 채점기는 빈 줄을 출력합니다."},
              moves=[move(at("counts", top), at("result", 0), value='""')], answer="")
        return ""
    st["map"] = {"lit": [k for k, v in counts.items() if v == most]}
    ordered = sorted(cookies, key=lambda letter: (-counts[letter], letter))
    letters[:] = ordered
    st["letters"] = {"good": list(range(n))}
    frame({"en": f"The most any kind has is {most}, not more than {limit}, so an order exists. Sort the letters by "
                 f"count, most first, then alphabetically: {''.join(ordered)}.",
           "ko": f"가장 많은 종류도 {most}판으로 {limit}판을 넘지 않으므로 순서가 있습니다. 글자를 판 수가 많은 순, 같으면 "
                 f"알파벳 순으로 정렬합니다: {''.join(ordered)}."},
          moves=[move(at("counts", c), at("letters", i), value=c) for i, c in enumerate(ordered)])
    st["map"] = {"dim": list(counts)}
    slots = list(range(0, n, 2)) + list(range(1, n, 2))
    evens = len(range(0, n, 2))
    for j, (slot, letter) in enumerate(zip(slots, letters)):
        result[slot] = letter
        st["ptr"] = slot
        st["letters"] = {"dim": list(range(j)), "lit": [j]}
        st["slots"] = {"good": [slot]}
        side = "even" if slot % 2 == 0 else "odd"
        nxt = {"en": "", "ko": ""}
        if j == evens and n > 1:
            nxt = {"en": " The even slots are full, so the odd ones start.",
                   "ko": " 짝수 칸이 다 차서 홀수 칸을 시작합니다."}
        frame({"en": f"'{letter}' goes into slot {slot}, the next {side} slot.{nxt['en']}",
               "ko": f"'{letter}' 글자를 다음 {'짝수' if side == 'even' else '홀수'} 칸인 {slot}번 칸에 놓습니다."
                     f"{nxt['ko']}"},
              moves=[move(at("letters", j), at("slots", slot))])
    order = "".join(result)
    st["ptr"] = None
    st["letters"] = {"dim": list(range(n))}
    st["slots"] = {"path": list(range(n))}
    out.append(f'"{order}"')
    frame({"en": f"Every batch is placed: \"{order}\" has no two equal letters side by side, so the judge prints "
                 f"valid.",
           "ko": f"모든 판을 놓았습니다. \"{order}\"에는 같은 글자가 붙어 있지 않으므로 채점기 출력은 valid입니다."},
          moves=[move(at("slots", i), at("result", 0), value=order[i]) for i in range(n)], answer="valid")
    return "valid"


for number, sample in enumerate(sample_cases(SLUG), start=1):
    cookies = sample["input"].strip()
    run = sample_run(wt, number, sample, input=f'cookies = "{cookies}"')
    solve(cookies, run)
wt.write(walkthrough_path(SLUG))
