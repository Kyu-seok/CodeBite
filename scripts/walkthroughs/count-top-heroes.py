#!/usr/bin/env python3.12
"""count-top-heroes' Walkthrough: the reference solution (scripts/replay-solutions/count-top-heroes.py), a recursion
whose call carries the highest number above its node: the node is dominant when it reaches that number, and the call
returns how many dominant heroes its subtree holds (its own 1 or 0 plus its two children's counts). The recursion walks
the input tree, so it has no drawing of its own (#359): the current call's node is lit, the calls still open are
shaded, and each node is tagged with the max its call carries and, once it returns, the count it returns, which moves
up into its parent. One frame per call on a node and one more per call with children returning, on each sample Test
Case.

    CODEBITE_DB=<database> scripts/walkthroughs/count-top-heroes.py

writes common/src/main/resources/walkthroughs/count-top-heroes.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import build_tree, driver_list, josa, plural, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, level_order_tree, move  # noqa: E402

SLUG = "count-top-heroes"

wt = Walkthrough(
    {"en": "Count Top Heroes", "ko": "최고점 영웅 세기"},
    {"en": "Carry the highest number seen on the way down into each call: a hero is dominant when it reaches that max, "
           "and its call returns its own 1 or 0 plus the counts its two children return.",
     "ko": "내려가면서 본 가장 큰 값을 각 호출에 넘겨줍니다. 영웅의 값이 그 최댓값 이상이면 우세하고, 호출은 자기 몫 1 또는 0에 "
           "두 자식이 돌려준 수를 더해 돌려줍니다."},
    views=[{"id": "tree", "type": "tree", "arity": 2,
            "title": {"en": "root (under each node: max above → count returned)",
                      "ko": "root (노드 아래: 위쪽 최댓값 → 돌려준 수)"}}],
)


def show(best):
    return "−∞" if best is None else str(best)


def tag(best, count=None):
    """A node's tag: the max its call carries and, once the call returns, the count it returns."""
    end = "" if count is None else f" → {count}"
    return {"en": f"max {show(best)}{end}", "ko": f"최대 {show(best)}{end}"}


def solve(values, run):
    """Solution.countDominantHeroes with a frame per call on a node and per call with children returning.
    Returns the answer as the Driver prints it."""
    tree, root = build_tree(values)
    tags, stack, done, dominant, count_of = {}, [], [], [], {}

    def frame(caption, lit=None, good=None, bad=None, moves=None, final=False, **answer):
        if final:
            marks, shade = {"path": list(dominant), "dim": [i for i in done if i not in dominant]}, []
        else:
            marks = {"dim": [i for i in done if i not in stack and i not in dominant]}
            for name, ids in (("lit", lit), ("good", good), ("bad", bad)):
                if ids is not None:
                    marks[name] = [ids]
            shade = list(stack)
        run.frame(caption, tree={"nodeMarks": marks, "shade": shade, "tags": [[i, t] for i, t in tags.items()]},
                  moves=moves, **answer)

    n = len(tree["nodes"])
    frame({"en": f"A tree of {n} {plural(n, 'hero', 'heroes')} with root {root.val}. Count from the root down, carrying "
                 f"the highest number above each node; above the root there is none (−∞).",
           "ko": f"root가 {root.val}인 영웅 {n}명의 트리입니다. root부터 내려가며 각 노드 위쪽의 가장 큰 값을 넘겨주며 "
                 f"셉니다. root 위에는 아무도 없습니다(−∞)."})

    def count(node, best, parent=None):
        if node is None:
            return 0
        stack.append(node.id)
        is_dom = best is None or node.val >= best
        new_best = node.val if best is None else max(best, node.val)
        leaf = node.left is None and node.right is None
        came = [move(at("tree", parent.id), at("tree", node.id), value=show(best))] if parent else None
        if is_dom:
            dominant.append(node.id)
            why = ({"en": f"{node.val} is the root: nothing is above it, so it is dominant.",
                    "ko": f"{josa(node.val, '은는')} root라 위에 아무도 없으므로 우세합니다."} if best is None else
                   {"en": f"{node.val} ≥ {best}, the max above it, so it is dominant.",
                    "ko": f"{josa(node.val, '은는')} 위쪽 최댓값 {best} 이상이므로 우세합니다."})
        else:
            why = {"en": f"{node.val} < {best}, the max above it, so it is not dominant.",
                   "ko": f"{josa(node.val, '은는')} 위쪽 최댓값 {best}보다 작으므로 우세하지 않습니다."}
        if leaf:
            mine = int(is_dom)
            count_of[node.id] = mine
            tags[node.id] = tag(best, mine)
            frame({"en": why["en"] + f" It is a leaf, so it returns {mine}.",
                   "ko": why["ko"] + f" 리프이므로 {josa(mine, '을를')} 돌려줍니다."},
                  lit=node.id if not is_dom else None, good=node.id if is_dom else None,
                  bad=None if is_dom else node.id, moves=came)
            stack.pop()
            done.append(node.id)
            return mine
        tags[node.id] = tag(best)
        first = node.left or node.right
        passes = {"en": f" Its children get max {new_best}; ask {first.val} first.",
                  "ko": f" 자식에게는 최댓값 {josa(new_best, '을를')} 넘기고, 먼저 {first.val}에게 묻습니다."}
        frame({"en": why["en"] + passes["en"], "ko": why["ko"] + passes["ko"]},
              good=node.id if is_dom else None, bad=None if is_dom else node.id, moves=came)
        total = int(is_dom) + count(node.left, new_best, node) + count(node.right, new_best, node)
        count_of[node.id] = total
        tags[node.id] = tag(best, total)
        parts = [str(int(is_dom))] + [str(count_of[k.id]) for k in (node.left, node.right) if k]
        frame({"en": f"{node.val} returns its own {int(is_dom)} plus its children's counts: {' + '.join(parts)} = "
                     f"{total}.",
               "ko": f"{node.val}의 자기 몫 {int(is_dom)}에 자식들이 돌려준 수를 더해 {' + '.join(parts)} = "
                     f"{josa(total, '을를')} 돌려줍니다."},
              lit=node.id,
              moves=[move(at("tree", k.id), at("tree", node.id), value=str(count_of[k.id]))
                     for k in (node.left, node.right) if k])
        stack.pop()
        done.append(node.id)
        return total

    answer = count(root, None)
    names = ", ".join(str(x["value"]) for x in tree["nodes"] if x["id"] in dominant)
    frame({"en": f"The root returns {answer}: the dominant {plural(answer, 'hero is', 'heroes are')} {names}.",
           "ko": f"root가 {josa(answer, '을를')} 돌려줍니다. 우세한 영웅은 {names}입니다."},
          final=True, answer=str(answer))
    return str(answer)


for number, sample in enumerate(sample_cases(SLUG), start=1):
    values = json.loads(sample["input"])
    run = sample_run(wt, number, sample, input=f"root = {driver_list(values)}", setup={"tree": level_order_tree(values)})
    solve(values, run)
wt.write(walkthrough_path(SLUG))
