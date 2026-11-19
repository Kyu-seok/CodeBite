#!/usr/bin/env python3.12
"""list-skill-build-paths' Walkthrough: the reference solution (scripts/replay-solutions/list-skill-build-paths.py), a
depth-first recursion, left before right, that keeps the path of open calls and the sum down to the current node; a
leaf whose sum equals target copies the path out. The recursion walks the input tree, so it has no drawing of its own
(#359): the current call's node is lit, the open calls (the path) are shaded, and each node is tagged with the sum
from the root down to it, which moves down from its parent. A path that hits target moves from its leaf into the
answer. One frame per call, on each sample Test Case.

    CODEBITE_DB=<database> scripts/walkthroughs/list-skill-build-paths.py

writes common/src/main/resources/walkthroughs/list-skill-build-paths.json.
"""
import os
import sys
import json

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import build_tree, driver_list, plural, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, level_order_tree, move  # noqa: E402

SLUG = "list-skill-build-paths"

wt = Walkthrough(
    {"en": "List Skill Build Paths", "ko": "스킬 빌드 경로 나열"},
    {"en": "Walk down depth first, carrying the sum from the root and keeping the path of open calls: at a leaf, a sum "
           "equal to target means the path is a build path, so copy it out; each call takes its node off the path as it "
           "returns.",
     "ko": "root에서부터의 합을 넘기고 열린 호출의 경로를 유지하며 깊이 우선으로 내려갑니다. 리프에서 합이 target과 같으면 그 "
           "경로가 빌드 경로이므로 복사해 둡니다. 각 호출은 돌아갈 때 자기 노드를 경로에서 뺍니다."},
    views=[
        {"id": "tree", "type": "tree", "arity": 2,
         "title": {"en": "root (under each node: the sum down to it)", "ko": "root (노드 아래: 내려온 합)"}},
        {"id": "result", "type": "output", "title": {"en": "build paths", "ko": "빌드 경로"},
         "empty": {"en": "none yet", "ko": "아직 없음"}},
        {"id": "state", "type": "vars"},
    ],
)


def solve(values, target, run):
    """Solution.listBuildPaths with a frame per call. Returns the answer as the Driver prints it."""
    tree, root = build_tree(values)
    tags, path_ids, path, paths, done, hits = {}, [], [], [], [], []

    def frame(caption, lit=None, good=None, bad=None, moves=None, final=False, r_good=(), **answer):
        if final:
            marks, shade = {"path": list(hits), "dim": [n["id"] for n in tree["nodes"] if n["id"] not in hits]}, []
        else:
            marks = {"dim": [i for i in done if i not in path_ids]}
            for name, x in (("lit", lit), ("good", good), ("bad", bad)):
                if x is not None:
                    marks[name] = x if isinstance(x, list) else [x]
            shade = list(path_ids)
        run.frame(caption, tree={"nodeMarks": marks, "shade": shade, "tags": [[i, t] for i, t in tags.items()]},
                  result={"values": [driver_list(p) for p in paths], "marks": {"good": list(r_good)}},
                  state={"items": [{"label": {"en": "target", "ko": "target (목표 합)"}, "value": target}]}, moves=moves, **answer)

    if root is None:
        frame({"en": "The tree is empty, so there is no path: the answer is [].",
               "ko": "트리가 비어 있어 경로가 없으므로 답은 []입니다."}, answer="[]")
        return "[]"
    n = len(tree["nodes"])
    frame({"en": f"A skill tree of {n} {plural(n, 'node', 'nodes')}. Walk down from the root {root.val}, left before "
                 f"right, adding up XP, and look for leaves where the sum is {target}.",
           "ko": f"노드 {n}개짜리 스킬 트리입니다. root {root.val}부터 왼쪽 먼저 내려가며 XP를 더하고, 합이 target "
                 f"{target}인 리프를 찾습니다."})

    def walk(node, total, parent=None):
        path.append(node.val)
        path_ids.append(node.id)
        total += node.val
        tags[node.id] = {"en": f"sum {total}", "ko": f"합 {total}"}
        came = [move(at("tree", parent.id), at("tree", node.id), value=f"+{node.val}")] if parent else None
        added = (f"{total - node.val} + {node.val} = {total}" if parent else f"{total}")
        if not node.left and not node.right:
            route = " -> ".join(str(v) for v in path)
            if total == target:
                paths.append(list(path))
                hits.extend(i for i in path_ids if i not in hits)
                frame({"en": f"{node.val} is a leaf and its sum {added} equals target: {route} is a build path, so "
                             f"copy it out.",
                       "ko": f"{node.val} 노드는 리프이고 합 {added} 값이 target과 같습니다. {route} 경로는 빌드 "
                             f"경로이므로 복사해 둡니다."},
                      good=list(path_ids), moves=(came or []) + [move(at("tree", node.id), at("result", len(paths) - 1),
                                                                      value=driver_list(path))],
                      r_good=[len(paths) - 1])
            else:
                frame({"en": f"{node.val} is a leaf and its sum {added} is not {target}: {route} is no build path.",
                       "ko": f"{node.val} 노드는 리프이고 합 {added} 값이 target과 다릅니다. {route} 경로는 빌드 "
                             f"경로가 아닙니다."},
                      bad=node.id, moves=came)
        else:
            first = node.left or node.right
            frame({"en": f"{node.val} brings the sum to {added}. It has children, so go on to {first.val}.",
                   "ko": f"{node.val} 노드까지의 합은 {added}입니다. 자식이 있으므로 {first.val} 노드로 내려갑니다."},
                  lit=node.id, moves=came)
            for child in (node.left, node.right):
                if child:
                    walk(child, total, node)
        path.pop()
        path_ids.pop()
        done.append(node.id)

    walk(root, 0)
    printed = driver_list(sorted(paths))
    if paths:
        found = {"en": f"Every leaf is checked: {len(paths)} build {plural(len(paths), 'path sums', 'paths sum')} to "
                       f"{target}, so the answer is {printed}.",
                 "ko": f"모든 리프를 확인했습니다. 합이 target인 빌드 경로가 {len(paths)}개이므로 답은 {printed}입니다."}
    else:
        found = {"en": f"Every leaf is checked and no path sums to {target}: the answer is [].",
                 "ko": "모든 리프를 확인했지만 합이 target인 경로가 없으므로 답은 []입니다."}
    frame(found, final=True, answer=printed)
    return printed


for number, sample in enumerate(sample_cases(SLUG), start=1):
    tree_line, target_line = sample["input"].split("\n")
    values, target = json.loads(tree_line), int(target_line)
    run = sample_run(wt, number, sample, input=f"root = {driver_list(values)}, target = {target}",
                     setup={"tree": level_order_tree(values)})
    solve(values, target, run)
wt.write(walkthrough_path(SLUG))
