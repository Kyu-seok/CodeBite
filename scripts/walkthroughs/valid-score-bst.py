#!/usr/bin/env python3.12
"""valid-score-bst's Walkthrough: the reference solution (scripts/replay-solutions/valid-score-bst.py) checks every
node against the open range (low, high) its ancestors leave it, the left child getting (low, value) and the right one
(value, high). The reference keeps the pending nodes on an explicit stack (a tree may be 2 * 10^5 deep); the
Walkthrough draws the same check as the depth-first recursion it stands for, left before right, with no drawing of
its own (#359): the current call's node is lit on the input tree, the calls still open are shaded, and each visited
node is tagged with its range. One frame per node checked, on each sample Test Case.

    CODEBITE_DB=<database> scripts/walkthroughs/valid-score-bst.py

writes common/src/main/resources/walkthroughs/valid-score-bst.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import build_tree, driver_list, josa, plural, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, level_order_tree, move  # noqa: E402

SLUG = "valid-score-bst"

wt = Walkthrough(
    {"en": "Valid Score BST", "ko": "점수 트리 검사"},
    {"en": "A score must fall inside the range all its ancestors leave it, not just beside its parent: pass the open "
           "range down, narrowing it to (low, score) going left and (score, high) going right.",
     "ko": "점수는 부모와만 비교해서는 안 되고, 모든 조상이 남긴 범위 안에 있어야 합니다. 열린 범위를 내려보내며 왼쪽으로 "
           "갈 때는 (low, 점수), 오른쪽으로 갈 때는 (점수, high)로 좁힙니다."},
    views=[{"id": "tree", "type": "tree", "arity": 2,
            "title": {"en": "root (under each node: its range)", "ko": "root (노드 아래: 허용 범위)"}}],
)


def rng(low, high):
    return f"({'-∞' if low is None else low}, {'∞' if high is None else high})"


def solve(values, run):
    """Solution.isValidBST with a frame per node checked. Returns the answer as the Driver prints it."""
    tree, root = build_tree(values)
    tags, stack, done, failed = {}, [], [], []

    def frame(caption, lit=None, bad=None, moves=None, edge=None, **answer):
        marks = {"dim": [i for i in done if i not in stack]}
        if lit is not None:
            marks["lit"] = [lit]
        if bad is not None:
            marks["bad"] = [bad]
        run.frame(caption, tree={"nodeMarks": marks, "shade": list(stack),
                                 "edgeMarks": {"lit": [edge]} if edge else {},
                                 "tags": [[i, t] for i, t in tags.items()]},
                  moves=moves, **answer)

    n = len(tree["nodes"])
    frame({"en": f"{n} {plural(n, 'score', 'scores')}. Start at the root {root.val} with the range (-∞, ∞): any score fits.",
           "ko": f"점수 {n}개이며 root {root.val}부터 확인합니다. 범위는 (-∞, ∞)이니 어떤 점수든 들어갑니다."})

    def valid(node, low, high, parent=None, side=None):
        if node is None:
            return True
        stack.append(node.id)
        tags[node.id] = rng(low, high)
        fits = (low is None or low < node.val) and (high is None or node.val < high)
        moves = [move(at("tree", parent.id), at("tree", node.id),
                      value=f"{'<' if side == 'left' else '>'} {parent.val}")] if parent else None
        edge = [parent.id, node.id] if parent else None
        if parent is None:
            came = {"en": "", "ko": ""}
        else:
            came = {"en": f"Going {side} from {parent.val} makes {parent.val} the "
                          f"{'upper' if side == 'left' else 'lower'} bound. ",
                    "ko": f"{parent.val}에서 {'왼쪽' if side == 'left' else '오른쪽'}으로 가므로 {josa(parent.val, '이가')} "
                          f"{'위' if side == 'left' else '아래'} 경계가 됩니다. "}
        if not fits:
            frame({"en": came["en"] + f"{node.val} is not inside {rng(low, high)}, so the rule breaks.",
                   "ko": came["ko"] + f"{josa(node.val, '은는')} 범위 {rng(low, high)} 밖이므로 규칙이 깨집니다."},
                  bad=node.id, moves=moves, edge=edge)
            failed.extend([node, low, high])
            return False
        frame({"en": came["en"] + f"{node.val} is inside {rng(low, high)}: check its children.",
               "ko": came["ko"] + f"{josa(node.val, '은는')} 범위 {rng(low, high)} 안에 있으니 자식을 확인합니다."},
              lit=node.id, moves=moves, edge=edge)
        ok = valid(node.left, low, node.val, node, "left") and valid(node.right, node.val, high, node, "right")
        if not ok:
            return False
        stack.pop()
        done.append(node.id)
        return True

    if valid(root, None, None):
        run.frame({"en": f"All {n} scores fall inside their ranges, so the tree is a valid BST: true.",
                   "ko": f"점수 {n}개가 모두 범위 안에 있으므로 올바른 BST입니다. 답은 true입니다."},
                  tree={"nodeMarks": {"path": [x["id"] for x in tree["nodes"]]}, "tags": [[i, t] for i, t in tags.items()]},
                  answer="true")
        return "true"
    node, low, high = failed
    run.frame({"en": f"{node.val} breaks the range {rng(low, high)} its ancestors left it, so the tree is not a valid "
                     f"BST: false.",
               "ko": f"{josa(node.val, '이가')} 조상들이 남긴 범위 {rng(low, high)}에서 벗어나므로 올바른 BST가 아닙니다. "
                     f"답은 false입니다."},
              tree={"nodeMarks": {"bad": [node.id]}, "shade": list(stack), "tags": [[i, t] for i, t in tags.items()]},
              answer="false")
    return "false"


for number, sample in enumerate(sample_cases(SLUG), start=1):
    values = json.loads(sample["input"])
    run = sample_run(wt, number, sample, input=f"root = {driver_list(values)}", setup={"tree": level_order_tree(values)})
    solve(values, run)
wt.write(walkthrough_path(SLUG))
