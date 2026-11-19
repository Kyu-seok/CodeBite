#!/usr/bin/env python3.12
"""count-doodle-palindromes' Walkthrough: the reference solution
(scripts/replay-solutions/count-doodle-palindromes.py), growing a palindrome outward from each of the 2n - 1
centres (each letter and each gap between two letters), recording one frame per letter pair compared on each sample
Test Case.

The pair compared is the pointers `left` and `right` on the doodle. A pair that matches makes the span between them
a palindrome, which moves into the box of counted palindromes, so the answer is how many the box holds. A pair that
differs is marked bad and ends its centre; a centre that runs off an end says so in its last match's caption.

    CODEBITE_DB=<database> scripts/walkthroughs/count-doodle-palindromes.py

writes common/src/main/resources/walkthroughs/count-doodle-palindromes.json.
"""
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import josa, plural, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move, span  # noqa: E402

SLUG = "count-doodle-palindromes"

wt = Walkthrough(
    {"en": "Count Doodle Palindromes", "ko": "낙서 회문 세기"},
    {"en": "Every palindrome has a centre, a letter or a gap between two letters. Grow outward from each centre "
           "while the two end letters match, counting one palindrome per step.",
     "ko": "모든 회문에는 가운데가 있습니다: 글자 하나이거나 두 글자 사이입니다. 가운데마다 양 끝 글자가 같은 "
           "동안 바깥으로 넓히며, 한 번 넓힐 때마다 회문 하나를 셉니다."},
    views=[
        {"id": "doodle", "type": "array", "title": {"en": "doodle", "ko": "doodle (낙서 문자열)"}},
        {"id": "found", "type": "output", "title": {"en": "palindromes counted", "ko": "센 회문"},
         "empty": {"en": "none yet", "ko": "아직 없음"}},
    ],
)


def q(text):
    return f"'{text}'"


def centre_text(centre):
    i = centre // 2
    if centre % 2 == 0:
        return {"en": f"Centre letter {i}", "ko": f"가운데 글자 {i}"}
    return {"en": f"Centre gap {i}|{i + 1}", "ko": f"가운데 {josa(i, '과와')} {i + 1} 사이"}


def solve(doodle, run):
    """Solution.countPalindromicSubstrings with a frame per pair compared. Returns the answer as the Driver
    prints it."""
    n = len(doodle)
    letters = list(doodle)
    found = []

    def frame(caption, left=None, right=None, pal=None, marks=None, out_marks=None, moves=None, **answer):
        run.frame(caption,
                  doodle={"values": letters, "pointers": {"left": left, "right": right},
                          "spans": {"pal": pal} if pal else {}, "marks": marks or {}},
                  found={"values": list(found), "marks": out_marks or {}},
                  moves=moves, **answer)

    frame({"en": f"{n} letters, so {2 * n - 1} centres: {n} letters and {n - 1} gaps. Each grows outward one pair "
                 "of letters at a time.",
           "ko": f"글자가 {n}개이므로 가운데는 {2 * n - 1}곳입니다: 글자 {n}개와 사이 {n - 1}곳. 각 가운데에서 "
                 "글자 한 쌍씩 바깥으로 넓힙니다."})
    count = 0
    for centre in range(2 * n - 1):
        where = centre_text(centre)
        left, right = centre // 2, (centre + 1) // 2
        while left >= 0 and right < n and doodle[left] == doodle[right]:
            count += 1
            sub = doodle[left:right + 1]
            found.append(sub)
            off_end = left - 1 < 0 or right + 1 >= n
            if left == right:
                en = f"{where['en']}: {q(sub)} alone is a palindrome, number {count}."
                ko = f"{where['ko']}: 한 글자 {q(sub)}도 회문이고, {count}번째입니다."
            else:
                en = (f"{where['en']}: letters {left} and {right} are both {q(doodle[left])}, so {q(sub)} is a "
                      f"palindrome, number {count}.")
                ko = (f"{where['ko']}: 글자 {josa(left, '과와')} {right}의 글자가 같으므로({q(doodle[left])}) "
                      f"{q(sub)} 부분은 회문이고, {count}번째입니다.")
            if off_end:
                en += " The next pair would run off the end, so this centre is done."
                ko += " 다음 쌍은 문자열 밖이라 이 가운데는 끝납니다."
            frame({"en": en, "ko": ko}, left=left, right=right,
                  pal=span(left, right, {"en": f"{len(sub)} {plural(len(sub), 'letter', 'letters')}", "ko": f"{len(sub)}글자"}, mark="good"),
                  marks={"lit": [left, right]}, out_marks={"good": [count - 1]},
                  moves=[move(at("doodle", left), at("found", count - 1), value=sub)])
            left -= 1
            right += 1
        if left >= 0 and right < n:  # stopped on a pair that differs
            grew = right - left - 1
            done_en = "no palindrome here" if grew == 0 else "this centre is done"
            done_ko = "여기서는 회문이 없습니다" if grew == 0 else "이 가운데는 끝납니다"
            frame({"en": f"{where['en']}: letter {left} is {q(doodle[left])} but letter {right} is "
                         f"{q(doodle[right])}, so {done_en}.",
                   "ko": f"{where['ko']}: 글자 {left}의 {q(doodle[left])}, 글자 {right}의 {q(doodle[right])}. "
                         f"서로 다르므로 {done_ko}."},
                  left=left, right=right, marks={"bad": [left, right]})
    frame({"en": f"Every centre is done: the box holds {count} palindromes. Answer: {count}.",
           "ko": f"모든 가운데를 마쳤습니다. 상자에 회문이 {count}개 있습니다. 답은 {count}입니다."},
          out_marks={"path": list(range(count))}, answer=str(count))


for number, sample in enumerate(sample_cases(SLUG), start=1):
    doodle = sample["input"].strip()
    run = sample_run(wt, number, sample, input=f"doodle = \"{doodle}\"")
    solve(doodle, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
