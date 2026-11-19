#!/usr/bin/env python3.12
"""flip-phone-codes's Walkthrough: the reference solution (scripts/replay-solutions/flip-phone-codes.py),
backtracking one digit per call: build(i) appends each letter of digits[i]'s key, calls build(i + 1) and takes the
letter back off; past the last digit the letters are one combination. The calls are drawn as a recursion tree grown
one call per frame (views.md, recursion): one node per call holding the letters so far, the edge into it labelled with
the letter added; the calls still open are shaded and each full combination moves into the answer. The keys of the
digits pressed are a map from digit to its letters, each letter moving from its key into the call that adds it.

    CODEBITE_DB=<database> scripts/walkthroughs/flip-phone-codes.py

writes common/src/main/resources/walkthroughs/flip-phone-codes.json.
"""
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import driver_list, josa, plural, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Tree, Walkthrough, at, move  # noqa: E402

SLUG = "flip-phone-codes"
KEYPAD = {
    "2": "abc", "3": "def", "4": "ghi", "5": "jkl",
    "6": "mno", "7": "pqrs", "8": "tuv", "9": "wxyz",
}

wt = Walkthrough(
    {"en": "Flip Phone Codes", "ko": "플립폰 키패드 코드"},
    {"en": "One call per digit: it adds each letter of that digit's key in turn and calls itself for the next digit, "
           "taking the letter back off afterwards. A call past the last digit holds one full combination.",
     "ko": "숫자 하나에 호출 하나입니다. 그 숫자 키의 글자를 차례로 붙이고 다음 숫자를 위해 자신을 호출한 뒤 글자를 다시 뺍니다. "
           "마지막 숫자를 지난 호출이 완성된 조합 하나를 가집니다."},
    views=[
        {"id": "digits", "type": "array", "title": {"en": "digits", "ko": "digits (누른 키)"}},
        {"id": "keys", "type": "map", "title": {"en": "keys pressed", "ko": "누른 키의 글자"}},
        {"id": "calls", "type": "tree", "title": {"en": "calls (letters so far)", "ko": "호출 (지금까지의 글자)"}},
        {"id": "result", "type": "output", "title": {"en": "combinations", "ko": "조합"},
         "empty": {"en": "none yet", "ko": "아직 없음"}},
    ],
)


def solve(digits, run):
    """Solution.letterCombinations with a frame per call. Returns the answer as the Driver prints it."""
    tree, combos, open_calls, full = Tree(), [], [], []
    letters = []
    keys = list(dict.fromkeys(digits))  # each key once, in the order first pressed

    def frame(caption, lit=None, i=None, letter_at=None, moves=None, done=False, **answer):
        entries = []
        for d in keys:
            entry = {"key": d, "value": list(KEYPAD[d])}
            if letter_at is not None and d == digits[letter_at[0]]:
                entry["marks"] = {"good": [letter_at[1]]}
            entries.append(entry)
        run.frame(caption,
                  digits={"values": list(digits), "pointers": {"i": i} if not done and i is not None and i < len(digits) else {},
                          "marks": {} if done or i is None else {"lit": [i]} if i < len(digits) else {}},
                  keys={"entries": entries,
                        "marks": {"lit": [digits[i]]} if not done and i is not None and i < len(digits) else {}},
                  calls={**tree.state(), "nodeMarks": {"path": list(full)} if done else {"good": list(full), "lit": [lit]},
                         "shade": [] if done else list(open_calls)},
                  result={"values": list(combos),
                          "marks": {"path": list(range(len(combos)))} if done else
                          {"good": [len(combos) - 1]} if any(m.get("to", {}).get("view") == "result" for m in moves or [])
                          else {}},
                  moves=moves, **answer)

    if not digits:
        frame({"en": "No digits were pressed, so there is no combination: the answer is [].",
               "ko": "누른 키가 없으므로 조합도 없고, 답은 빈 목록 []입니다."}, done=True, answer="[]")
        return "[]"

    def build(i, parent, picked):
        node = tree.add("".join(letters) or None, parent=parent, label=None if picked is None else letters[-1])
        open_calls.append(node)
        if picked is None:
            moves = [move(dst=at("calls", node))]
        else:
            moves = [move(at("keys", digits[i - 1]), at("calls", node), value=letters[-1])]
        if i == len(digits):
            text = "".join(letters)
            combos.append(text)
            full.append(node)
            moves.append(move(at("calls", node), at("result", len(combos) - 1)))
            frame({"en": f"Add '{letters[-1]}': build(i={i}) is past the last digit, so \"{text}\" is a full combination "
                         f"and goes into the answer.",
                   "ko": f"'{letters[-1]}' 글자를 붙입니다. build(i={i}) 호출은 마지막 숫자를 지났으므로 \"{text}\" 조합을 "
                         f"답에 넣습니다."},
                  node, i, (i - 1, picked), moves)
            open_calls.pop()
            return
        key = KEYPAD[digits[i]]
        tries = ", ".join(f"'{ch}'" for ch in key)
        if picked is None:
            head = {"en": f"build(i=0) starts with no letters; digit {digits[0]} stands for {tries}",
                    "ko": f"build(i=0) 호출은 글자 없이 시작합니다. 숫자 {josa(int(digits[0]), '은는')} {tries} 글자를 "
                          f"나타냅니다"}
            frame({"en": head["en"] + ", so it will add each in turn.",
                   "ko": head["ko"] + ". 이 글자를 하나씩 붙여 봅니다."}, node, i, None, moves)
        else:
            frame({"en": f"Add '{letters[-1]}': build(i={i}) holds \"{''.join(letters)}\" and will add each of {tries} for "
                         f"digit {digits[i]}.",
                   "ko": f"'{letters[-1]}' 글자를 붙입니다. build(i={i}) 호출은 \"{''.join(letters)}\" 글자를 가지고, 숫자 "
                         f"{digits[i]} 키의 {tries} 글자를 하나씩 붙여 봅니다."},
                  node, i, (i - 1, picked), moves)
        for k, letter in enumerate(key):
            letters.append(letter)
            build(i + 1, node, k)
            letters.pop()
        open_calls.pop()

    build(0, None, None)
    printed = driver_list(sorted(combos))
    n = len(combos)
    sizes = " × ".join(str(len(KEYPAD[d])) for d in digits)
    frame({"en": f"Every call has returned: {n} {plural(n, 'combination', 'combinations')}"
                 + (f", {sizes} = {n}, one per leaf of the tree." if len(digits) > 1 else ", one per letter of the key."),
           "ko": f"모든 호출이 끝났습니다. 조합은 {n}개"
                 + (f"({sizes} = {n})이고, 트리의 잎 하나가 조합 하나입니다." if len(digits) > 1 else
                    "로, 키의 글자마다 하나입니다.")},
          done=True, answer=printed)
    return printed


for number, sample in enumerate(sample_cases(SLUG), start=1):
    digits = sample["input"].strip()
    run = sample_run(wt, number, sample, input=f'digits = "{digits}"')
    solve(digits, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
