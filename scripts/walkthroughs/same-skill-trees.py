#!/usr/bin/env python3.12
"""same-skill-trees' Walkthrough: the reference solution (scripts/replay-solutions/same-skill-trees.py), a recursion
that compares the two roots, then the two left subtrees, then the two right subtrees. The recursion walks both input
trees at once, so it has no drawing of its own (#359): the pair compared is lit in both trees, the pairs still open
are shaded, and each pair is tagged "same" as its call returns true, which moves up into its parents. One frame per
call on a pair with a node, and one per pair returning after its children, on each sample Test Case.

    CODEBITE_DB=<database> scripts/walkthroughs/same-skill-trees.py

writes common/src/main/resources/walkthroughs/same-skill-trees.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import build_tree, driver_list, josa, plural, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, level_order_tree, move  # noqa: E402

SLUG = "same-skill-trees"

wt = Walkthrough(
    {"en": "Same Skill Trees", "ko": "같은 스킬 트리 확인"},
    {"en": "Two trees are the same when both are empty, or their roots hold the same value and their left subtrees "
           "are the same and their right subtrees are the same: compare the roots, then recurse into each side in step.",
     "ko": "두 트리가 같으려면 둘 다 비어 있거나, 루트 값이 같고 왼쪽 서브트리끼리, 오른쪽 서브트리끼리도 같아야 합니다. "
           "루트를 비교한 뒤 양쪽을 나란히 재귀로 내려갑니다."},
    views=[
        {"id": "p", "type": "tree", "arity": 2, "title": "p", "empty": {"en": "empty tree", "ko": "빈 트리"}},
        {"id": "q", "type": "tree", "arity": 2, "title": "q", "empty": {"en": "empty tree", "ko": "빈 트리"}},
    ],
)

SAME = {"en": "same", "ko": "같음"}
SIDE = {"left": "왼쪽", "right": "오른쪽"}


def solve(p_values, q_values, run):
    """Solution.isSameTree with a frame per call on a pair with a node. Returns the answer as the Driver prints it."""
    p_tree, p_root = build_tree(p_values)
    q_tree, q_root = build_tree(q_values)
    tags = {"p": {}, "q": {}}
    stack = {"p": [], "q": []}
    done = {"p": [], "q": []}

    def state(view, lit=(), good=(), bad=(), final=None):
        if final is not None:
            marks = final
            shade = []
        else:
            marks = {"dim": [i for i in done[view] if i not in stack[view]], "lit": list(lit), "good": list(good),
                     "bad": list(bad)}
            shade = list(stack[view])
        return {"nodeMarks": marks, "shade": shade, "tags": [[i, t] for i, t in tags[view].items()]}

    def frame(caption, p=None, q=None, moves=None, **answer):
        run.frame(caption, p=state("p", **(p or {})), q=state("q", **(q or {})), moves=moves, **answer)

    def count(tree):
        n = len(tree["nodes"])
        return {"en": f"{n} {plural(n, 'node', 'nodes')}" if n else "no nodes", "ko": f"노드 {n}개" if n else "빈 트리"}

    cp, cq = count(p_tree), count(q_tree)
    frame({"en": f"p has {cp['en']} and q has {cq['en']}. Compare them root to root, then side by side, left before right.",
           "ko": f"p는 {cp['ko']}, q는 {cq['ko']}입니다. 루트끼리 비교한 뒤 왼쪽, 오른쪽 순으로 나란히 비교합니다."})

    failed = []

    def same(a, b, pa=None, pb=None, side=None):
        if a is None and b is None:
            return True
        if a is None or b is None:
            have, lack, node, parent = ("p", "q", a, pb) if a else ("q", "p", b, pa)
            frame({"en": f"{have}'s {(pa if a else pb).val} has a {side} child {node.val}, but {lack}'s {parent.val} has "
                         f"none: the shapes differ, so this pair is not the same.",
                   "ko": f"{have}의 {(pa if a else pb).val}에는 {SIDE[side]} 자식 {josa(node.val, '이가')} 있지만 "
                         f"{lack}의 {parent.val}에는 없습니다. 모양이 다르므로 같지 않습니다."},
                  **{have: {"bad": [node.id]}, lack: {"bad": [parent.id]}})
            failed.append((have, node.id, lack, parent.id))
            return False
        stack["p"].append(a.id)
        stack["q"].append(b.id)
        if a.val != b.val:
            frame({"en": f"p holds {a.val} here but q holds {b.val}: the values differ, so this pair is not the same.",
                   "ko": f"이 자리에 p는 {josa(a.val, '을를')}, q는 {josa(b.val, '을를')} 가지고 있습니다. 값이 다르므로 "
                         f"같지 않습니다."}, p={"bad": [a.id]}, q={"bad": [b.id]})
            failed.append(("p", a.id, "q", b.id))
            return False
        leaf = not (a.left or a.right or b.left or b.right)
        if leaf:
            tags["p"][a.id] = tags["q"][b.id] = SAME
            stack["p"].pop()
            stack["q"].pop()
            done["p"].append(a.id)
            done["q"].append(b.id)
            frame({"en": f"Both hold {a.val}, and neither has children: this pair is the same.",
                   "ko": f"둘 다 {josa(a.val, '을를')} 가지고 있고 자식이 없습니다. 이 쌍은 같습니다."},
                  p={"good": [a.id]}, q={"good": [b.id]})
            return True
        frame({"en": f"Both hold {a.val}: now compare their left subtrees, then their right ones.",
               "ko": f"둘 다 {josa(a.val, '을를')} 가지고 있습니다. 이제 왼쪽 서브트리끼리, 그다음 오른쪽 서브트리끼리 "
                     f"비교합니다."}, p={"lit": [a.id]}, q={"lit": [b.id]})
        ok = same(a.left, b.left, a, b, "left") and same(a.right, b.right, a, b, "right")
        if not ok:
            return False
        stack["p"].pop()
        stack["q"].pop()
        done["p"].append(a.id)
        done["q"].append(b.id)
        tags["p"][a.id] = tags["q"][b.id] = SAME
        moves = [move(at(v, kid.id), at(v, node.id), value="true")
                 for v, node in (("p", a), ("q", b)) for kid in (node.left, node.right) if kid]
        frame({"en": f"Both sides under {a.val} came back the same, so this pair is the same too.",
               "ko": f"{a.val} 아래 양쪽이 모두 같다고 돌아왔으므로 이 쌍도 같습니다."},
              p={"good": [a.id]}, q={"good": [b.id]}, moves=moves)
        return True

    if same(p_root, q_root):
        frame({"en": "Every pair matched, root to leaves: the trees are the same, true.",
               "ko": "루트부터 리프까지 모든 쌍이 같으므로 두 트리는 같습니다. 답은 true입니다."},
              p={"final": {"path": [n["id"] for n in p_tree["nodes"]]}},
              q={"final": {"path": [n["id"] for n in q_tree["nodes"]]}}, answer="true")
        return "true"
    have, a, lack, b = failed[0]
    frame({"en": "One pair differs, and a single difference makes the whole trees differ: false.",
           "ko": "한 쌍이 다르고, 한 곳만 달라도 두 트리는 다릅니다. 답은 false입니다."},
          **{have: {"final": {"bad": [a]}}, lack: {"final": {"bad": [b]}}}, answer="false")
    return "false"


for number, sample in enumerate(sample_cases(SLUG), start=1):
    p_line, q_line = sample["input"].split("\n")
    p_values, q_values = json.loads(p_line), json.loads(q_line)
    run = sample_run(wt, number, sample, input=f"p = {driver_list(p_values)}, q = {driver_list(q_values)}",
                     setup={"p": level_order_tree(p_values), "q": level_order_tree(q_values)})
    solve(p_values, q_values, run)
wt.write(walkthrough_path(SLUG))
