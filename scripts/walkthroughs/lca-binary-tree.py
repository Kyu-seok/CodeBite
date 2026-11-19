#!/usr/bin/env python3.12
"""lca-binary-tree's Walkthrough: the reference solution (scripts/replay-solutions/lca-binary-tree.py), a recursion
that returns p or q when its node is one (without looking below it), nothing for an empty subtree, its own node when
both sides return something (the LCA), and otherwise whatever one side returned. The recursion walks the input tree,
so it has no drawing of its own (#359): the current call's node is lit, the calls still open are shaded, p and q are
tagged, and each node's tag shows what its call returns, which moves up into its parent. One frame per call entering
a node with children that is neither p nor q, and one per call returning, on each sample Test Case.

    CODEBITE_DB=<database> scripts/walkthroughs/lca-binary-tree.py

writes common/src/main/resources/walkthroughs/lca-binary-tree.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import build_tree, driver_list, plural, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, level_order_tree, move  # noqa: E402

SLUG = "lca-binary-tree"

wt = Walkthrough(
    {"en": "Lowest Common Ancestor of a Binary Tree", "ko": "이진 트리의 최소 공통 조상"},
    {"en": "Each call reports up what its subtree holds: p or q itself, or nothing. The first node whose two sides both "
           "report something is the lowest node with p and q below it, and it reports itself from then on; a node that "
           "is p or q reports itself at once, since the other may be below it.",
     "ko": "각 호출은 자기 서브트리에 있는 것, 즉 p나 q 자신 또는 없음을 위로 알립니다. 두 쪽 모두에서 무언가를 받은 첫 노드가 "
           "p와 q를 아래에 둔 가장 낮은 노드이고, 그 뒤로는 자기 자신을 알립니다. p나 q인 노드는 다른 하나가 그 아래에 "
           "있을 수 있으므로 바로 자기 자신을 알립니다."},
    views=[{"id": "tree", "type": "tree", "arity": 2,
            "title": {"en": "root (under each node: what its call returns)",
                      "ko": "root (노드 아래: 호출이 돌려주는 값)"}}],
)


def solve(values, p_val, q_val, run):
    """Solution.lowestCommonAncestor with a frame per call entering a node and per call returning.
    Returns the answer as the Driver prints it."""
    tree, root = build_tree(values)
    nodes = {}

    def collect(x):
        if x:
            nodes[x.val] = x
            collect(x.left)
            collect(x.right)
    collect(root)
    p, q = nodes[p_val], nodes[q_val]
    names = {p.id: "p", q.id: "q"}
    returned, stack, done = {}, [], []

    def show(x, ko=False):
        if x is None:
            return "없음" if ko else "none"
        return str(x.val)

    def tag(i):
        name = names.get(i, "")
        if i not in returned:
            return name
        ret = returned[i]
        return {"en": f"{name} → {show(ret)}".strip(), "ko": f"{name} → {show(ret, True)}".strip()}

    def frame(caption, lit=None, good=None, moves=None, final=None, **answer):
        if final is not None:
            marks, shade = {"path": final, "dim": [n["id"] for n in tree["nodes"] if n["id"] not in final]}, []
            edges = {"path": [[a, b] for a, b in edge_list if a in final and b in final]}
        else:
            marks = {"dim": [i for i in done if i not in stack and i != good]}
            if lit is not None:
                marks["lit"] = [lit]
            if good is not None:
                marks["good"] = [good]
            shade, edges = list(stack), {}
        tags = [[i, tag(i)] for i in sorted(set(names) | set(returned))]
        run.frame(caption, tree={"nodeMarks": marks, "shade": shade, "edgeMarks": edges, "tags": tags},
                  moves=moves, **answer)

    edge_list = [(e["from"], e["to"]) for e in tree["edges"]]
    n = len(tree["nodes"])
    frame({"en": f"A tree of {n} {plural(n, 'node', 'nodes')}; p = {p.val} and q = {q.val}. Ask the root {root.val} "
                 f"what its subtree holds.",
           "ko": f"노드 {n}개짜리 트리이고 p = {p.val}, q = {q.val}입니다. root {root.val} 노드에게 서브트리에 무엇이 "
                 f"있는지 묻습니다."})

    def lca(node):
        if node is None:
            return None
        stack.append(node.id)
        if node is p or node is q:
            returned[node.id] = node
            who = names[node.id]
            frame({"en": f"{node.val} is {who}, so it returns itself without looking below: the other target may be "
                         f"under it, and then {node.val} would be the answer anyway.",
                   "ko": f"{node.val} 노드는 {who}이므로 아래를 보지 않고 자기 자신을 돌려줍니다. 다른 하나가 그 아래에 "
                         f"있다면 어차피 {node.val} 노드가 답이기 때문입니다."},
                  good=node.id)
            stack.pop()
            done.append(node.id)
            return node
        kids = [k for k in (node.left, node.right) if k]
        if kids:
            first = kids[0]
            frame({"en": f"{node.val} is neither p nor q, so it asks its children, {first.val} first.",
                   "ko": f"{node.val} 노드는 p도 q도 아니므로 자식들에게 묻습니다. 먼저 {first.val} 노드입니다."},
                  lit=node.id)
        left = lca(node.left)
        right = lca(node.right)
        result = node if left and right else left or right
        returned[node.id] = result
        moves = [move(at("tree", k.id), at("tree", node.id), value=show(returned[k.id])) for k in kids] or None
        if not kids:
            cap = {"en": f"{node.val} is a leaf and neither p nor q: it returns none.",
                   "ko": f"{node.val} 노드는 p도 q도 아닌 리프이므로 없음을 돌려줍니다."}
        elif left and right:
            cap = {"en": f"{node.val} gets {left.val} from the left and {right.val} from the right: p and q are on "
                         f"different sides, so {node.val} is their lowest common ancestor and returns itself.",
                   "ko": f"{node.val} 노드는 왼쪽에서 {left.val}, 오른쪽에서 {right.val} 값을 받았습니다. p와 q가 서로 "
                         f"다른 쪽에 있으므로 {node.val} 노드가 최소 공통 조상이며 자기 자신을 돌려줍니다."}
        elif result:
            cap = {"en": f"{node.val} gets {show(left)} from the left and {show(right)} from the right, so it passes "
                         f"{result.val} up.",
                   "ko": f"{node.val} 노드는 왼쪽에서 {show(left, True)}, 오른쪽에서 {show(right, True)} 값을 받았으므로 "
                         f"{result.val} 값을 위로 넘깁니다."}
        else:
            cap = {"en": f"Neither side of {node.val} holds p or q, so it returns none.",
                   "ko": f"{node.val} 노드의 양쪽 어디에도 p나 q가 없으므로 없음을 돌려줍니다."}
        frame(cap, good=node.id if (left and right) else None, lit=None if (left and right) else node.id, moves=moves)
        stack.pop()
        done.append(node.id)
        return result

    answer = lca(root)
    # the answer and the ways down from it to p and q
    keep = set()
    for target in (p, q):
        def down(x, route):
            if x is None:
                return None
            if x is target:
                return route + [x.id]
            return down(x.left, route + [x.id]) or down(x.right, route + [x.id])
        keep.update(down(answer, []))
    frame({"en": f"The root returns {answer.val}: the lowest node with both p = {p.val} and q = {q.val} in its subtree "
                 f"is {answer.val}.",
           "ko": f"root가 {answer.val} 노드를 돌려줍니다. p = {p.val}, q = {q.val} 두 노드를 모두 서브트리에 둔 가장 낮은 "
                 f"노드는 {answer.val} 노드입니다."},
          final=sorted(keep), answer=str(answer.val))
    return str(answer.val)


for number, sample in enumerate(sample_cases(SLUG), start=1):
    tree_line, p_line, q_line = sample["input"].split("\n")
    values, p_val, q_val = json.loads(tree_line), int(p_line), int(q_line)
    run = sample_run(wt, number, sample, input=f"root = {driver_list(values)}, p = {p_val}, q = {q_val}",
                     setup={"tree": level_order_tree(values)})
    solve(values, p_val, q_val, run)
wt.write(walkthrough_path(SLUG))
