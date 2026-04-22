#!/usr/bin/env python3
"""
For a given tag, emit a self-contained input bundle for the rename-naming
subagent: the problem rows to rename plus the relevant sub_shape hints and
the full worlds vocabulary. The subagent reads the bundle and returns a
rename mapping JSON (list of old_slug/new_slug/old_title/new_title/
old_method/new_method entries) consumable by `rename_problem.py`.

Usage:
    build_rename_batch.py --tag "Tries" --out /tmp/tries-bundle.json
"""
import argparse
import csv
import json
import sys
from pathlib import Path


SCRIPT_DIR = Path(__file__).resolve().parent
REPO_ROOT = SCRIPT_DIR.parent.parent
SEEDS_DIR = SCRIPT_DIR / "seeds"


def load_tag_problems(rename_input: Path, tag: str, skip: set):
    rows = []
    with rename_input.open() as f:
        reader = csv.DictReader(f, delimiter="\t")
        for r in reader:
            if r["slug"] in skip:
                continue
            if tag in [t.strip() for t in r["tags"].split(",")]:
                rows.append({
                    "old_slug": r["slug"],
                    "old_title": r["title"],
                    "old_method": r["method"],
                    "return_type": r["return_type"],
                })
    return rows


def main() -> int:
    p = argparse.ArgumentParser()
    p.add_argument("--tag", required=True)
    p.add_argument("--rename-input", default="/tmp/rewrite-workspace/data/rename-input.tsv")
    p.add_argument("--skip-file", default="/tmp/rewrite-workspace/data/phase1-skip.txt")
    p.add_argument("--out", required=True)
    args = p.parse_args()

    skip = set()
    skip_path = Path(args.skip_file)
    if skip_path.exists():
        skip = {line.strip() for line in skip_path.read_text().splitlines() if line.strip()}
    problems = load_tag_problems(Path(args.rename_input), args.tag, skip)
    if not problems:
        print(f"no problems for tag {args.tag!r}", file=sys.stderr)
        return 1

    worlds_doc = json.loads((SEEDS_DIR / "worlds.json").read_text())
    shapes_doc = json.loads((SEEDS_DIR / "shapes.json").read_text())
    worlds = worlds_doc.get("worlds", worlds_doc)
    tag_entry = shapes_doc.get("tags", {}).get(args.tag, {})
    tag_shapes = tag_entry.get("sub_shapes", []) if isinstance(tag_entry, dict) else tag_entry

    bundle = {
        "tag": args.tag,
        "problems": problems,
        "sub_shapes": tag_shapes,
        "worlds": worlds,
    }
    Path(args.out).write_text(json.dumps(bundle, indent=2))
    print(f"wrote {args.out} with {len(problems)} problem(s), "
          f"{len(tag_shapes)} sub_shape(s), {len(worlds)} world(s)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
