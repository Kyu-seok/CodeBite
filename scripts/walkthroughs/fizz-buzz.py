#!/usr/bin/env python3.12
"""fizz-buzz's Walkthrough: the reference solution (scripts/replay-solutions/fizz-buzz.py), one frame per i from
1 to n on each sample Test Case: i is tested for 3 and 5, tagged with the divisors it has, and its word (or its
digits) moves into the answer.

    CODEBITE_DB=<database> scripts/walkthroughs/fizz-buzz.py

writes common/src/main/resources/walkthroughs/fizz-buzz.json.
"""
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import driver_list, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, move  # noqa: E402

SLUG = "fizz-buzz"

wt = Walkthrough(
    {"en": "Fizz Buzz", "ko": "피즈 버즈"},
    {"en": "For each i from 1 to n, test i % 3 and i % 5: both 0 is \"FizzBuzz\", only 3 is \"Fizz\", only 5 is "
           "\"Buzz\", and neither is i written out.",
     "ko": "1부터 n까지 i마다 i % 3과 i % 5를 봅니다. 둘 다 0이면 \"FizzBuzz\", 3만이면 \"Fizz\", 5만이면 \"Buzz\", "
           "둘 다 아니면 i를 그대로 씁니다."},
    views=[
        {"id": "nums", "type": "array", "title": {"en": "i (tag: divisible by)", "ko": "i (태그: 나누어떨어지는 수)"}},
        {"id": "result", "type": "output", "title": {"en": "answer", "ko": "answer (답)"},
         "empty": {"en": "empty", "ko": "비어 있음"}},
    ],
)

WORDS = {(True, True): "FizzBuzz", (True, False): "Fizz", (False, True): "Buzz"}


def solve(n, run):
    """Solution.fizzBuzz with a frame per i. Returns the answer."""
    answer = []
    tags = []
    nums = list(range(1, n + 1))

    def frame(caption, i=None, path=False, moves=None, **final):
        run.frame(caption,
                  nums={"values": nums, "tags": list(tags), "pointers": {"i": i - 1 if i else None},
                        "unread": list(range(len(answer), n)),
                        "marks": {"lit": [i - 1]} if i else {}},
                  result={"values": list(answer),
                          "marks": {"path": list(range(len(answer)))} if path else {"good": [len(answer) - 1]} if i else {}},
                  moves=moves, **final)

    frame({"en": f"n = {n}: one entry for each i from 1 to {n}.", "ko": f"n = {n}: 1부터 {n}까지 i마다 하나씩 씁니다."})
    for i in nums:
        key = (i % 3 == 0, i % 5 == 0)
        word = WORDS.get(key, str(i))
        answer.append(word)
        divisors = [d for d, hit in zip((3, 5), key) if hit]
        if divisors:
            tags.append([i - 1, "÷" + ",".join(map(str, divisors))])
        if key == (True, True):
            en, ko = f"{i} is divisible by both 3 and 5: \"FizzBuzz\".", f"{i}: 3과 5 모두로 나누어떨어지므로 \"FizzBuzz\"입니다."
        elif key == (True, False):
            en, ko = f"{i} is divisible by 3 but not 5: \"Fizz\".", f"{i}: 3으로는 나누어떨어지고 5로는 아니므로 \"Fizz\"입니다."
        elif key == (False, True):
            en, ko = f"{i} is divisible by 5 but not 3: \"Buzz\".", f"{i}: 5로는 나누어떨어지고 3으로는 아니므로 \"Buzz\"입니다."
        else:
            en, ko = (f"{i} is divisible by neither 3 nor 5, so it is written as \"{i}\".",
                      f"{i}: 3으로도 5로도 나누어떨어지지 않으므로 \"{i}\" 문자열을 씁니다.")
        frame({"en": en, "ko": ko}, i=i,
              moves=[move(at("nums", i - 1), at("result", i - 1), value=word, mark="good")])
    printed = driver_list(answer)
    if len(printed) <= 40:
        last = {"en": f"Every i from 1 to {n} has its entry: answer {printed}.",
                "ko": f"1부터 {n}까지 모두 썼습니다. 답은 {printed}입니다."}
    else:  # one unbroken JSON line would run out of the caption at 390px
        last = {"en": f"Every i from 1 to {n} has its entry: the answer is the {n} entries in the box, in order.",
                "ko": f"1부터 {n}까지 모두 썼습니다. 답은 상자에 담긴 {n}개 항목을 순서대로 담은 배열입니다."}
    frame(last,
          path=True, answer=driver_list(answer))
    return answer


for number, sample in enumerate(sample_cases(SLUG), start=1):
    n = int(sample["input"])
    solve(n, sample_run(wt, number, sample, input=f"n = {n}"))
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
