#!/usr/bin/env python3.12
"""power-set's Walkthrough: the reference solution (scripts/replay-solutions/power-set.py), backtracking where each
call adds the subset it holds to the answer and then extends it with each number after the last one it took. The
calls are drawn as a recursion tree grown one call per frame, one node per call and subset, the edge into it
labelled with the number taken; the calls still open are shaded and each subset moves from its node into the answer.

    CODEBITE_DB=<database> scripts/walkthroughs/power-set.py

writes common/src/main/resources/walkthroughs/power-set.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import driver_list, josa, listed, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Tree, Walkthrough, at, move  # noqa: E402

SLUG = "power-set"

wt = Walkthrough(
    {"en": "Power Set", "ko": "멱집합"},
    {"en": "Each call holds one subset and extends it only with numbers after the last one it took, so every subset "
           "is built exactly once: one node of the recursion tree per subset.",
     "ko": "호출 하나가 부분집합 하나를 맡고, 마지막으로 고른 수 뒤의 수로만 늘리므로 모든 부분집합이 정확히 한 번씩 "
           "만들어집니다. 재귀 트리의 노드 하나가 부분집합 하나입니다."},
    views=[
        {"id": "nums", "type": "array"},
        {"id": "calls", "type": "tree", "title": {"en": "calls (+x: the number taken)", "ko": "호출 (+x: 고른 수)"}},
        {"id": "result", "type": "output", "title": {"en": "answer", "ko": "답"}},
    ],
)


def solve(nums, run):
    """Solution.powerSet with a frame per call. Returns the answer as the Driver prints it."""
    nums = sorted(nums)
    tree, subsets, open_calls = Tree(), [], []

    def frame(caption, lit=None, moves=None, done=False, **answer):
        marks = {"path": [n["id"] for n in tree.nodes]} if done else {"lit": [lit]} if lit is not None else {}
        run.frame(caption,
                  nums={"values": nums},
                  calls={**tree.state(), "nodeMarks": marks, "shade": [] if done else list(open_calls)},
                  result={"values": [driver_list(s) for s in subsets],
                          "marks": {"path": list(range(len(subsets)))} if done else {"good": [len(subsets) - 1]}},
                  moves=moves, **answer)

    def build(start, chosen, parent, taken):
        node = tree.add(driver_list(chosen), parent=parent, label=None if taken is None else f"+{nums[taken]}")
        open_calls.append(node)
        subsets.append(chosen[:])
        into = move(at("calls", node), at("result", len(subsets) - 1))
        later = nums[start:]
        if taken is None:
            frame({"en": f"The first call holds the empty subset [] and adds it to the answer; it will extend [] with "
                         f"each of {listed(later)}.",
                   "ko": f"첫 호출은 빈 부분집합([])을 맡아 답에 넣고, 여기에 {listed(later[:-1]) + ', ' if later[:-1] else ''}"
                         f"{josa(later[-1], '을를')} 하나씩 붙여 봅니다."},
                  node, [move(dst=at("calls", node)), into])
        else:
            then = ({"en": f"next it tries {listed(later)}.",
                     "ko": f"다음으로 {listed(later[:-1]) + ', ' if later[:-1] else ''}{josa(later[-1], '을를')} 붙여 봅니다."}
                    if later else {"en": f"no number comes after {nums[taken]}, so it returns.",
                                   "ko": f"{nums[taken]} 뒤에 남은 수가 없으므로 돌아갑니다."})
            frame({"en": f"Take {nums[taken]}: the call for {driver_list(chosen)} adds it to the answer; " + then["en"],
                   "ko": f"{josa(nums[taken], '을를')} 고릅니다. {driver_list(chosen)} 호출이 이 부분집합을 답에 넣고, " + then["ko"]},
                  node, [move(at("nums", taken), at("calls", node)), into])
        for i in range(start, len(nums)):
            if i > start and nums[i] == nums[i - 1]:
                continue
            chosen.append(nums[i])
            build(i + 1, chosen, node, i)
            chosen.pop()
        open_calls.pop()

    build(0, [], None, None)
    printed = driver_list(sorted(sorted(s) for s in subsets))
    n = len(subsets)
    frame({"en": f"Every call has returned: {n} calls, one per subset, so the answer holds all {n} subsets of "
                 f"{len(nums)} numbers (2^{len(nums)} = {n}).",
           "ko": f"모든 호출이 끝났습니다. 호출 {n}번이 부분집합을 하나씩 만들었으니, 답에는 수 {len(nums)}개로 만든 "
                 f"부분집합 {n}개가 모두 있습니다(2^{len(nums)} = {n})."},
          done=True, answer=printed)
    return printed


for number, sample in enumerate(sample_cases(SLUG), start=1):
    nums = json.loads(sample["input"])
    run = sample_run(wt, number, sample, input=f"nums = {driver_list(nums)}")
    solve(nums, run)
wt.write(walkthrough_path(SLUG))
