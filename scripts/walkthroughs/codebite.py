"""What every CodeBite tracer shares: the problem's sample Test Cases, read from the database, and
sample runs pinned to them (docs/adr/0011).

    samples = sample_cases("rotting-donuts")          # [{"input", "expected", "label"}], by order_index
    run = sample_run(wt, 1, samples[0], input=f"ward = {samples[0]['input']}")
    ...
    run.frame(..., answer="4")                         # the answer as the Driver prints it
    run.frame(..., answer=driver_list(result))         # a list, printed as the Driver prints one

Captions share driver_list, driver_value, plural and ordinal (English), josa (a Korean particle after a number),
quote (a string in single quotes), or_infinity (∞ for an unreached cost), cell_name and cell_at (a grid cell),
listed and listed_cells (values or grid cells joined with commas), centre_text (an expand-around-centre centre)
and bag_text (the fewest-bags tables' cell tag).
The solution's own node classes are shared too: TreeNode with build_tree (a Level-Order Array) and tree_values
(back to one), and ListNode with build_list; node_order places a graph's nodes as its description's Diagram does.
heap_moves gives a heap tree's moves since the last frame, for a tracer that draws a heap as its list leaves it.
Tracers of one shape share more: bit_text and bit_digits (a number in binary), table_cell and table_frame (a DP
table under a header row and column, as the one grid view `table`), node_name and node_object (a ListNode in a
caption), record_return (a design problem's returned values), union_root and halving_find (a union-find's parent
list), hold_to_best (a sliding window against the longest so far) and task_frame (a topological sort's frame).
A helper two tracers need goes here, nested ones too: scripts/check-tracer-helpers.py fails on one defined in two
files. One that closed over the tracer's state takes it as parameters, and the tracer binds it once with
functools.partial: `frame = partial(table_frame, run, grid)`.
    wt.write(walkthrough_path("rotting-donuts"))

The samples come through scripts/db-sql.sh, so the local database (or CODEBITE_DB's) must be at this
checkout's migrations: db-sql.sh refuses one behind instead of letting a tracer copy stale samples.
"""
import json
import os
import re
import subprocess

from walkthrough_trace import at, level_order_tree, move

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))


def sample_cases(slug):
    """The problem's sample Test Cases in order, each {"input": text, "expected": text, "label": Text},
    input and expected verbatim, label as run_label gives it."""
    if "'" in slug:
        raise ValueError(f"not a Slug: {slug!r}")
    sql = ("SELECT json_build_object('description', p.description, 'samples', coalesce(json_agg("
           "json_build_object('input', t.input, 'expected', t.expected_output) ORDER BY t.order_index)"
           " FILTER (WHERE t.id IS NOT NULL), '[]')) FROM problems p"
           " LEFT JOIN test_cases t ON t.problem_id = p.id AND t.is_sample"
           f" WHERE p.slug = '{slug}' GROUP BY p.id")
    out = subprocess.run([os.path.join(ROOT, "scripts", "db-sql.sh"), sql],
                         check=True, capture_output=True, text=True).stdout
    found = json.loads(out) if out.strip() else {"description": "", "samples": []}
    samples = found["samples"]
    if not samples:
        raise SystemExit(f"{slug}: no sample Test Cases in the database (is it the right one? CODEBITE_DB)")
    for number, sample in enumerate(samples, start=1):
        sample["label"] = run_label(number, found["description"])
    return samples


def run_label(number, description):
    """Sample `number`'s run label: "Example N" when the description shows it as **Example N:**, or
    else "Case N", as the test panel numbers the samples, so no run names an Example the learner
    can't find."""
    if re.search(rf"\*\*Example {number}:\*\*", description):
        return {"en": f"Example {number}", "ko": f"예시 {number}"}
    return {"en": f"Case {number}", "ko": f"케이스 {number}"}


def sample_run(wt, number, sample, input, setup=None):
    """Run `number` (1-based) on `sample`, labelled by run_label, carrying the sample's input text as
    `sampleInput` and its expected output text as `expected`."""
    run = wt.run(sample["label"], input=input,
                 expected=sample["expected"], setup=setup)
    run.data["sampleInput"] = sample["input"]
    return run


def walkthrough_path(slug):
    return os.path.join(ROOT, "common", "src", "main", "resources", "walkthroughs", f"{slug}.json")


def driver_list(values):
    """`values` as the Python Drivers print a list: compact JSON, json.dumps(values, separators=(',', ':'))."""
    return json.dumps(values, separators=(",", ":"))


def driver_value(value):
    """`value` as the Python Drivers print one: null, true or false for None and the booleans, compact JSON
    for anything else (driver_list for a list)."""
    return json.dumps(value, separators=(",", ":"))


class TreeNode:
    """A binary tree node as the solution sees it, carrying its level-order index `id` (the tree view's id)."""

    def __init__(self, id, val):
        self.id, self.val, self.left, self.right = id, val, None, None


def build_tree(values):
    """A Level-Order Array as the tree view's state (level_order_tree) and the solution's root TreeNode, None
    for an empty tree: `tree, root = build_tree(values)`."""
    tree = level_order_tree(values)
    nodes = {n["id"]: TreeNode(n["id"], n["value"]) for n in tree["nodes"]}
    for e in tree["edges"]:
        setattr(nodes[e["from"]], "right" if e["slot"] else "left", nodes[e["to"]])
    return tree, nodes.get(0)


def tree_values(root):
    """A tree of TreeNodes as the Drivers print one: its Level-Order Array, None for a missing child and trailing
    Nones left out, so driver_list(tree_values(root)) is the printed answer."""
    out, queue = [], [root] if root else []
    while queue:
        node = queue.pop(0)
        out.append(None if node is None else node.val)
        if node is not None:
            queue += [node.left, node.right]
    while out and out[-1] is None:
        out.pop()
    return out


class ListNode:
    """A singly linked list node as the solution sees it."""

    def __init__(self, val):
        self.val, self.next = val, None


def build_list(values):
    """The solution's linked list of `values` as its ListNodes in order, each linked to the next: nodes[0] is the
    head, and no values give []."""
    nodes = [ListNode(v) for v in values]
    for a, b in zip(nodes, nodes[1:]):
        a.next = b
    return nodes


def heap_moves(view, heap, drawn, text, fresh=()):
    """A move in tree view `view` for each entry of the list `heap` that sits somewhere new since the last frame,
    which drew the list `drawn`: from the node it was at, or, when that node is gone (the last entry lifted to the
    root by a pop), into its node. `text(entry)` is the chip's text. Entries are told apart by identity, so equal
    entries stay distinct. `fresh` entries, pushed since that frame, get no move here: the caller moves each in
    from where it came."""
    out = []
    for j, e in enumerate(heap):
        if (j < len(drawn) and drawn[j] is e) or any(e is f for f in fresh):
            continue
        i = next((k for k, d in enumerate(drawn) if d is e), None)
        out.append(move(at(view, i), at(view, j), value=text(e)) if i is not None and i < len(heap)
                   else move(dst=at(view, j), value=text(e)))
    return out


def plural(n, one, many):
    """`one` when n is 1, else `many`: f"{n} {plural(n, 'window', 'windows')}"."""
    return one if n == 1 else many


_PARTICLES = {"은는", "이가", "을를", "과와", "(으)로"}


def josa(n, particle):
    """The whole number `n` followed by the Korean particle that fits how n is read aloud, as
    "41은" (사십일) but "42는" (사십이). `particle` is "은는", "이가", "을를" or "과와" (the form after a
    final consonant first), or "(으)로".

    A number's last sound is its last digit's: 영 일 이 삼 사 오 육 칠 팔 구, or, for a final 0 after
    other digits, 십 백 천 만, which all end in a consonant. So 2, 4, 5 and 9 take the vowel form.
    (으)로 also drops 으 after ㄹ, so 1, 7 and 8 (일, 칠, 팔) take 로 as well."""
    if particle not in _PARTICLES:
        raise ValueError(f"josa: {particle!r} is not one of {sorted(_PARTICLES)}")
    last = abs(n) % 10
    if particle == "(으)로":
        return f"{n}{'로' if last in (1, 2, 4, 5, 7, 8, 9) else '으로'}"
    return f"{n}{particle[1] if last in (2, 4, 5, 9) else particle[0]}"


def ordinal(n):
    """n as an English ordinal: 1st, 2nd, 3rd, 4th, 11th, 22nd."""
    return f"{n}{'th' if 10 <= n % 100 <= 20 else {1: 'st', 2: 'nd', 3: 'rd'}.get(n % 10, 'th')}"


def listed(values, show=str):
    """The values joined with ", " as a caption lists them, each written by `show`: listed([2, 5]) is "2, 5"."""
    return ", ".join(show(v) for v in values)


def quote(text):
    """`text` in single quotes, as a caption names a string: 'aba'."""
    return f"'{text}'"


def or_infinity(x):
    """A cost as a cell or caption shows it: "∞" for float("inf"), the cost a relaxation hasn't reached, else x."""
    return "∞" if x == float("inf") else x


def bag_text(size):
    """The tag on a cell one candy bag of `size` back, in the fewest-bags tables."""
    return {"en": f"bag {size}", "ko": f"봉지 {size}"}


def cell_name(cell):
    """A grid cell (row, col) as captions and queue values write it: "1,2"."""
    return f"{cell[0]},{cell[1]}"


def cell_at(r, c):
    """Grid cell (r, c) as a caption writes it: "(1,2)"."""
    return f"({r},{c})"


def listed_cells(cells):
    """Grid cells as a caption lists them: "(0,1), (2,3)"."""
    return listed(cells, lambda cell: f"({cell_name(cell)})")


def centre_text(centre):
    """Expand-around-centre's centre number 0..2n-2 as a caption names it: an even one is letter centre // 2, an
    odd one the gap after it."""
    i = centre // 2
    if centre % 2 == 0:
        return {"en": f"Centre letter {i}", "ko": f"가운데 글자 {i}"}
    return {"en": f"Centre gap {i}|{i + 1}", "ko": f"가운데 {josa(i, '과와')} {i + 1} 사이"}


def node_order(edges, nodes=()):
    """A graph's nodes as its description's Diagram places them: in the order the edges name them (each edge's
    first two items, so a weighted edge works too), then the rest of `nodes` in their order."""
    order = list(dict.fromkeys(v for edge in edges for v in edge[:2]))
    return order + [v for v in nodes if v not in order]


def bit_text(v, width):
    """v in binary as a caption or tag writes it, padded with zeros to `width` digits: bit_text(5, 4) is "0101"."""
    return format(v, f"0{width}b")


def bit_digits(v, width):
    """v's `width` binary digits as an array view's values, highest place first: bit_digits(5, 4) is [0, 1, 0, 1]."""
    return [int(c) for c in bit_text(v, width)]


def table_cell(i, j):
    """Entry (i, j) of a table drawn in a grid view under a header row and beside a header column, as the
    grid cell an `at` or a mark names: [i + 1, j + 1]."""
    return [i + 1, j + 1]


def node_name(node, dummy):
    """A ListNode as a caption names it: "dummy" for the solution's dummy head `dummy`, else its value."""
    return "dummy" if node is dummy else str(node.val)


def node_object(node):
    """A ListNode as the object of a Korean verb: its value with 을/를, or null을 for no node."""
    return "null을" if node is None else josa(node.val, "을를")


def record_return(result, value):
    """Append what a call of a design problem returned to `result`, the output view's values, as the JSON the
    Driver prints (null for a call that returns nothing), and give its index there."""
    result.append(json.dumps(value))
    return len(result) - 1


def table_frame(run, grid, caption, marks=None, moves=None, **answer):
    """A frame of `run` for a tracer whose one view is the grid view `table`: `grid` as its cells with `marks`,
    the frame's `moves`, and `answer="…"` on the last. A tracer binds its run and grid once:
    `frame = partial(table_frame, run, grid)`."""
    run.frame(caption, table={"cells": grid, "marks": marks or {}}, moves=moves, **answer)


def task_frame(run, n, prereqs, waiting, finished, ready, caption, leaving=None, node_lit=(), node_good=(),
               node_bad=(), node_path=(), edge_lit=(), edge_bad=(), queue_lit=(), queue_good=(), moves=None, **answer):
    """A frame of `run` for a topological sort over tasks 0..n-1 by counting prerequisites: the graph view `tasks`
    (each task with how many it still waits on, `waiting`, and its place in `finished` as a tag), the queue view
    `ready` and the output view `done`. `leaving` is the task just taken from the front of `ready`, drawn there for
    the frame it leaves. A final `node_path` lights the whole order and dims nothing. A tracer binds the run and
    the solution's state once: `frame = partial(task_frame, run, n, prereqs, waiting, finished, ready)`."""
    shown = ([leaving] if leaving is not None else []) + list(ready)
    run.frame(caption,
              tasks={"nodes": [{"id": v, "tag": {"en": f"#{finished.index(v) + 1}", "ko": f"{finished.index(v) + 1}번째"}}
                               if v in finished else {"id": v} for v in node_order(prereqs, range(n))],
                     "values": {str(v): waiting[v] for v in range(n)},
                     "nodeMarks": {"dim": list(finished) if not node_path else [], "path": list(node_path),
                                   "bad": list(node_bad), "good": list(node_good), "lit": list(node_lit)},
                     "edgeMarks": {"bad": list(edge_bad), "lit": list(edge_lit)}},
              ready={"values": shown, "marks": {"lit": list(queue_lit), "good": list(queue_good)}},
              done={"values": list(finished), "marks": {"path": list(range(len(finished)))} if node_path else {}},
              moves=moves, **answer)


def union_root(parent, x):
    """The root of x's group in a union-find's `parent` list, without the halving halving_find does: for a
    graph's tags, which must not change the list they describe."""
    while parent[x] != x:
        x = parent[x]
    return x


def halving_find(parent, x, writes, visited):
    """A union-find's find with path halving, as the reference solutions write it, recording as it climbs: each
    node it stands on is appended to `visited`, and each parent it rewrites to `writes` as (the cell the new value
    was read from, the cell written, the new value)."""
    visited.append(x)
    while parent[x] != x:
        jumped = parent[parent[x]]
        if jumped != parent[x]:
            writes.append((parent[x], x, jumped))
        parent[x] = jumped
        x = parent[x]
        visited.append(x)
    return x


def hold_to_best(left, right, best, best_span):
    """Hold the window left..right up to the longest so far, `best` long at `best_span` (left, right): whether it
    is longer, the best and its span after it, and the caption's verdict in English and in Korean:
    `beaten, best, best_span, verdict_en, verdict_ko = hold_to_best(left, right, best, best_span)`."""
    length = right - left + 1
    if length > best:
        return True, length, (left, right), f"a new best, {length}", f"best = {josa(length, '(으)로')} 갱신"
    return False, best, best_span, f"best stays {best}", f"best = {best} 그대로"
