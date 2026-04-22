#!/usr/bin/env python3
"""
For a given tag, emit a self-contained input bundle for the rewrite
subagent: per problem, the post-rename identifiers (slug, title, method,
return_type) plus the current description, constraints, and sample test
cases, alongside the tag's sub_shape catalog and the full worlds
vocabulary. The subagent reads the bundle and returns a rewrite JSON
(list of slug/description/constraints/sample_test_cases entries)
consumable by `merge_rewrites.py` and `emit_rewrite_migration.py`.

Usage:
    build_rewrite_batch.py --tag "Arrays & Hashing" --out /tmp/ah-bundle.json
"""
import argparse
import json
import sys
from pathlib import Path


SCRIPT_DIR = Path(__file__).resolve().parent
SEEDS_DIR = SCRIPT_DIR / "seeds"


TAG_OF_MAPPING_STEM = {
    "advanced-graphs": "Advanced Graphs",
    "arrays-hashing": "Arrays & Hashing",
    "backtracking": "Backtracking",
    "binary-search": "Binary Search",
    "bit": "Bit Manipulation",
    "dp-2d": "2D Dynamic Programming",
    "dp": "1D Dynamic Programming",
    "graphs": "Graphs",
    "greedy": "Greedy",
    "heap": "Heap / Priority Queue",
    "intervals": "Intervals",
    "linked-lists": "Linked Lists",
    "math": "Math & Geometry",
    "sliding-window": "Sliding Window",
    "stack": "Stack",
    "trees": "Trees",
    "tries": "Tries",
    "two-pointers": "Two Pointers",
}


def load_rename_mapping(mappings_dir: Path):
    """Return (by_new_slug, by_tag) from per-tag mapping files."""
    by_new_slug = {}
    by_tag = {}
    for path in sorted(mappings_dir.glob("*-mapping.json")):
        stem = path.stem.replace("-mapping", "")
        tag = TAG_OF_MAPPING_STEM.get(stem, stem)
        entries = json.loads(path.read_text())
        for e in entries:
            e["_tag"] = tag
            by_new_slug[e["new_slug"]] = e
            by_tag.setdefault(tag, []).append(e)
    return by_new_slug, by_tag


def load_problems_snapshot(problems_json: Path):
    """Return dict[old_slug] -> {description, constraints}."""
    rows = json.loads(problems_json.read_text())
    return {r["slug"]: r for r in rows}


def load_test_cases_snapshot(test_cases_json: Path):
    """Return dict[old_slug] -> list of {input, expected_output, order_index, is_sample}."""
    rows = json.loads(test_cases_json.read_text())
    by_slug = {}
    for r in rows:
        by_slug.setdefault(r["slug"], []).append(r)
    for slug in by_slug:
        by_slug[slug].sort(key=lambda r: r["order_index"])
    return by_slug


def load_rename_input(tsv_path: Path):
    """Return dict[old_slug] -> {title, method, tags, return_type}."""
    import csv
    out = {}
    with tsv_path.open() as f:
        for r in csv.DictReader(f, delimiter="\t"):
            out[r["slug"]] = r
    return out


def main() -> int:
    p = argparse.ArgumentParser()
    p.add_argument("--tag", required=True)
    p.add_argument("--mappings-dir", default="/tmp/rewrite-workspace/mappings")
    p.add_argument("--problems", default="/tmp/rewrite-workspace/data/problems.json")
    p.add_argument("--test-cases", default="/tmp/rewrite-workspace/data/test_cases.json")
    p.add_argument("--rename-input", default="/tmp/rewrite-workspace/data/rename-input.tsv")
    p.add_argument("--done-file", default="/tmp/rewrite-workspace/data/phase2-done.txt",
                   help="newline-separated list of new_slugs already rewritten (skip)")
    p.add_argument("--out", required=True)
    args = p.parse_args()

    _, by_tag = load_rename_mapping(Path(args.mappings_dir))
    problems_by_old = load_problems_snapshot(Path(args.problems))
    tcs_by_old = load_test_cases_snapshot(Path(args.test_cases))
    ri_by_old = load_rename_input(Path(args.rename_input))

    done = set()
    done_path = Path(args.done_file)
    if done_path.exists():
        done = {line.strip() for line in done_path.read_text().splitlines() if line.strip()}

    entries = by_tag.get(args.tag, [])
    if not entries:
        print(f"no entries for tag {args.tag!r}", file=sys.stderr)
        return 1

    bundle_problems = []
    for e in entries:
        old_slug = e["old_slug"]
        new_slug = e["new_slug"]
        if new_slug in done:
            continue
        p_row = problems_by_old.get(old_slug)
        if p_row is None:
            print(f"warn: {old_slug!r} missing from problems snapshot", file=sys.stderr)
            continue
        sample_tcs = [t for t in tcs_by_old.get(old_slug, []) if t.get("is_sample")]
        ri = ri_by_old.get(old_slug, {})
        bundle_problems.append({
            "new_slug": new_slug,
            "new_title": e["new_title"],
            "new_method": e["new_method"],
            "return_type": ri.get("return_type", ""),
            "suggested_world": e.get("world", ""),
            "current_description": p_row.get("description", ""),
            "current_constraints": p_row.get("constraints", ""),
            "sample_test_cases": [
                {
                    "order_index": t["order_index"],
                    "input": t["input"],
                    "expected_output": t["expected_output"],
                }
                for t in sample_tcs
            ],
        })

    if not bundle_problems:
        print(f"all entries for tag {args.tag!r} are marked done", file=sys.stderr)
        return 1

    worlds_doc = json.loads((SEEDS_DIR / "worlds.json").read_text())
    shapes_doc = json.loads((SEEDS_DIR / "shapes.json").read_text())
    worlds = worlds_doc.get("worlds", worlds_doc)
    shapes_tags = shapes_doc.get("tags", {})
    tag_aliases = {
        "1D Dynamic Programming": "Dynamic Programming",
    }
    shapes_key = args.tag if args.tag in shapes_tags else tag_aliases.get(args.tag, args.tag)
    tag_entry = shapes_tags.get(shapes_key, {})
    tag_shapes = tag_entry.get("sub_shapes", []) if isinstance(tag_entry, dict) else tag_entry

    bundle = {
        "tag": args.tag,
        "problems": bundle_problems,
        "sub_shapes": tag_shapes,
        "worlds": worlds,
    }
    Path(args.out).write_text(json.dumps(bundle, indent=2))
    print(f"wrote {args.out} with {len(bundle_problems)} problem(s), "
          f"{len(tag_shapes)} sub_shape(s), {len(worlds)} world(s)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
