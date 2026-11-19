#!/usr/bin/env python3.12
"""snack-combo-picks's Walkthrough: the reference solution (scripts/replay-solutions/snack-combo-picks.py),
backtracking over the sorted flavors: build(start) adds the combo it holds to the answer, then extends it with each
flavor from index `start` on, skipping a flavor equal to the one just tried at the same depth, since taking it would
build the same combos again. The calls are drawn as a recursion tree grown one call per frame (views.md, recursion):
one node per call and combo, the edge into it labelled with the flavor taken; the calls still open are shaded and each
combo moves from its node into the answer. A skip gets a frame of its own, the skipped snack marked on the array, as it
is what keeps the combos distinct.

    CODEBITE_DB=<database> scripts/walkthroughs/snack-combo-picks.py

writes common/src/main/resources/walkthroughs/snack-combo-picks.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import driver_list, josa, listed, plural, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Tree, Walkthrough, at, move  # noqa: E402

SLUG = "snack-combo-picks"

wt = Walkthrough(
    {"en": "Snack Combo Picks", "ko": "간식 조합 뽑기"},
    {"en": "Sort the flavors; each call holds one combo, adds it to the answer and extends it with each flavor after the "
           "last one it took. At one depth, a flavor equal to the one just tried is skipped: it would build the same "
           "combos again.",
     "ko": "맛을 정렬합니다. 호출 하나가 조합 하나를 맡아 답에 넣고, 마지막으로 고른 맛 뒤의 맛으로 조합을 늘립니다. 같은 깊이에서 "
           "방금 시도한 맛과 같은 맛은 같은 조합을 또 만들므로 건너뜁니다."},
    views=[
        {"id": "snacks", "type": "array", "title": {"en": "snacks, sorted", "ko": "snacks (정렬한 맛)"}},
        {"id": "calls", "type": "tree", "title": {"en": "calls (+x: the flavor taken)", "ko": "호출 (+x: 고른 맛)"}},
        {"id": "result", "type": "output", "title": {"en": "combos", "ko": "조합"}},
    ],
)


def solve(snacks, run):
    """Solution.listSnackCombos with a frame per call and per run of skips. Returns the answer as the Driver prints
    it."""
    snacks = sorted(snacks)
    tree, combos, open_calls = Tree(), [], []
    combo = []

    def frame(caption, lit=None, start=None, skipped=(), moves=None, done=False, **answer):
        if done:
            marks = {}
        else:
            marks = {"dim": list(range(start)), "bad": list(skipped)}
        run.frame(caption,
                  snacks={"values": snacks, "marks": marks, "pointers": {} if done or start >= len(snacks) else
                          {"start": start}},
                  calls={**tree.state(), "nodeMarks": {"path": [n["id"] for n in tree.nodes]} if done else {"lit": [lit]},
                         "shade": [] if done else list(open_calls)},
                  result={"values": [driver_list(c) for c in combos],
                          "marks": {"path": list(range(len(combos)))} if done else
                          {"good": [len(combos) - 1]} if any(m.get("to", {}).get("view") == "result" for m in moves or [])
                          else {}},
                  moves=moves, **answer)

    def build(start, parent, taken):
        node = tree.add(driver_list(combo), parent=parent, label=None if taken is None else f"+{snacks[taken]}")
        open_calls.append(node)
        combos.append(combo.copy())
        into = move(at("calls", node), at("result", len(combos) - 1))
        later = [snacks[i] for i in range(start, len(snacks)) if i == start or snacks[i] != snacks[i - 1]]
        if taken is None:
            frame({"en": f"The first call holds the empty combo [] and adds it to the answer; it will extend [] with "
                         f"{listed(later)}, each flavor once.",
                   "ko": f"첫 호출은 빈 조합([])을 맡아 답에 넣고, 맛마다 한 번씩 {listed(later[:-1]) + ', ' if later[:-1] else ''}"
                         f"{josa(later[-1], '을를')} 붙여 봅니다."},
                  node, start, moves=[move(dst=at("calls", node)), into])
        else:
            then = ({"en": f"next it tries {listed(later)}.",
                     "ko": f"다음으로 {listed(later[:-1]) + ', ' if later[:-1] else ''}{josa(later[-1], '을를')} 붙여 봅니다."}
                    if later else {"en": "no snack comes after it, so it returns.",
                                   "ko": "그 뒤에 남은 간식이 없으므로 돌아갑니다."})
            frame({"en": f"Take {snacks[taken]} (index {taken}): the call for {driver_list(combo)} adds it to the "
                         f"answer; " + then["en"],
                   "ko": f"{taken}번 칸의 {josa(snacks[taken], '을를')} 고릅니다. {driver_list(combo)} 호출이 이 조합을 "
                         f"답에 넣고, " + then["ko"]},
                  node, start, moves=[move(at("snacks", taken), at("calls", node)), into])
        skipped = []

        def skip_frame(last):
            n, v = len(skipped), snacks[skipped[0]]
            then = ({"en": " The call returns.", "ko": "건너뛰고 돌아갑니다."} if last else
                    {"en": " Then it goes on.", "ko": "건너뜁니다."})
            frame({"en": f"Back in the call for {driver_list(combo)}: the {plural(n, 'snack', 'snacks')} at "
                         f"{plural(n, 'index', 'indexes')} {listed(skipped)} {plural(n, 'is', 'are')} {v} again, the "
                         f"flavor it just tried, so taking {plural(n, 'it', 'one')} would repeat the combos below "
                         f"+{v}: skipped." + then["en"],
                   "ko": f"{driver_list(combo)} 호출로 돌아왔습니다. {listed(skipped)}번 칸도 방금 시도한 맛 "
                         f"{josa(v, '이가')} 다시 나온 것이라 고르면 +{v} 아래의 조합이 되풀이되므로 " + then["ko"]},
                  node, start, list(skipped))
            skipped.clear()

        for i in range(start, len(snacks)):
            if i > start and snacks[i] == snacks[i - 1]:
                skipped.append(i)
                continue
            if skipped:
                skip_frame(last=False)
            combo.append(snacks[i])
            build(i + 1, node, i)
            combo.pop()
        if skipped:
            skip_frame(last=True)
        open_calls.pop()

    build(0, None, None)
    printed = json.dumps(sorted(sorted(c) for c in combos), separators=(",", ":"))
    n = len(combos)
    frame({"en": f"Every call has returned: {n} calls, one per distinct combo, so the answer holds {n} "
                 f"{plural(n, 'combo', 'combos')}.",
           "ko": f"모든 호출이 끝났습니다. 호출 {n}번이 서로 다른 조합을 하나씩 만들었으니 답에는 조합 {n}개가 있습니다."},
          done=True, answer=printed)
    return printed


for number, sample in enumerate(sample_cases(SLUG), start=1):
    snacks = json.loads(sample["input"])
    run = sample_run(wt, number, sample, input=f"snacks = {driver_list(snacks)}")
    solve(snacks, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
