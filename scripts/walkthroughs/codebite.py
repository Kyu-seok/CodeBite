"""What every CodeBite tracer shares: the problem's sample Test Cases, read from the database, and
sample runs pinned to them (docs/adr/0011).

    samples = sample_cases("rotting-donuts")          # [{"input", "expected", "label"}], by order_index
    run = sample_run(wt, 1, samples[0], input=f"ward = {samples[0]['input']}")
    ...
    run.frame(..., answer="4")                         # the answer as the Driver prints it
    run.frame(..., answer=driver_list(result))         # a list, printed as the Driver prints one

Captions share driver_list, driver_value, plural and ordinal (English), josa (a Korean particle after a number),
listed and listed_cells (values or grid cells joined with commas) and centre_text (an expand-around-centre centre).
The solution's own node classes are shared too: TreeNode with build_tree (a Level-Order Array) and tree_values
(back to one), and ListNode; node_order places a graph's nodes as its description's Diagram does.
    wt.write(walkthrough_path("rotting-donuts"))

The samples come through scripts/db-sql.sh, so the local database (or CODEBITE_DB's) must be at this
checkout's migrations: db-sql.sh refuses one behind instead of letting a tracer copy stale samples.
"""
import json
import os
import re
import subprocess

from walkthrough_trace import level_order_tree

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


def cell_name(cell):
    """A grid cell (row, col) as captions and queue values write it: "1,2"."""
    return f"{cell[0]},{cell[1]}"


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
