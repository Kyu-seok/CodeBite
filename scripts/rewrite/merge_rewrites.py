#!/usr/bin/env python3
"""
Merge per-tag rewrite JSON files into a single master rewrite set.

Each input file is a JSON list of entries:
    [
      {
        "slug": "new-slug",
        "description": "markdown ...",
        "constraints": "markdown bullet list",
        "sample_test_cases": [
          {"order_index": 1, "input": "stdin lines", "expected_output": "..."},
          {"order_index": 2, "input": "...", "expected_output": "..."}
        ]
      },
      ...
    ]

Validation:
  1. Required keys present; sample_test_cases is a list of >= 2 entries.
  2. `slug` appears as a `new_slug` in master-mapping (or equals the
     pilot slug `shelf-stock-pair`).
  3. Each sample has `order_index`, `input`, `expected_output` as strings
     and preserves the current per-problem line count in `input` (guards
     against accidental driver-format changes).
  4. Description/constraints/samples pass the fingerprint denylist
     (check_denylist.py logic reused inline).
  5. No duplicate slug across batches.

Prints a per-tag report, then writes the merged master rewrite JSON to
--out on success. Exits non-zero on any validation error.
"""
import argparse
import json
import os
import re
import sys
from pathlib import Path

SCRIPT_DIR = Path(__file__).resolve().parent
sys.path.insert(0, str(SCRIPT_DIR))
from check_denylist import (  # noqa: E402
    check_bounds,
    check_examples,
    check_titles,
    load_denylist_file,
    resolve_denylist_dir,
)


def load_master_mapping(path: Path) -> dict:
    by_new = {}
    for e in json.loads(path.read_text()):
        by_new[e["new_slug"]] = e
    return by_new


def load_current_samples(test_cases_json: Path) -> dict:
    """Return dict[old_slug] -> list of sample input line counts by order_index."""
    rows = json.loads(test_cases_json.read_text())
    by_slug = {}
    for r in rows:
        if not r.get("is_sample"):
            continue
        by_slug.setdefault(r["slug"], {})[r["order_index"]] = len(r["input"].splitlines())
    return by_slug


def validate_entry(entry: dict, *, slug_lookup: dict, pilot_slug: str,
                   old_sample_line_counts: dict, denylists: dict) -> list[str]:
    errors = []
    slug = entry.get("slug")
    if not isinstance(slug, str) or not slug:
        return [f"entry missing slug"]
    if slug != pilot_slug and slug not in slug_lookup:
        errors.append(f"{slug}: not present in master-mapping as new_slug")
    for key in ("description", "constraints"):
        if not isinstance(entry.get(key), str) or not entry[key].strip():
            errors.append(f"{slug}: {key} missing or empty")
    tcs = entry.get("sample_test_cases")
    if not isinstance(tcs, list) or len(tcs) < 2:
        errors.append(f"{slug}: sample_test_cases must be a list of >= 2 entries")
    else:
        # Look up old sample line counts (by old_slug).
        old_slug = slug_lookup.get(slug, {}).get("old_slug", slug)
        old_line_counts = old_sample_line_counts.get(old_slug, {})
        seen_idx = set()
        for i, t in enumerate(tcs):
            if not isinstance(t, dict):
                errors.append(f"{slug}: sample_test_cases[{i}] not an object")
                continue
            for k in ("order_index", "input", "expected_output"):
                if k not in t:
                    errors.append(f"{slug}: sample_test_cases[{i}] missing {k!r}")
            oi = t.get("order_index")
            if oi in seen_idx:
                errors.append(f"{slug}: duplicate order_index {oi}")
            seen_idx.add(oi)
            inp = t.get("input", "")
            if not isinstance(inp, str):
                errors.append(f"{slug}: sample_test_cases[{i}].input not a string")
            else:
                expected_lc = old_line_counts.get(oi)
                actual_lc = len(inp.splitlines())
                if expected_lc is not None and expected_lc != actual_lc:
                    errors.append(
                        f"{slug}: sample_test_cases[{i}].input has {actual_lc} "
                        f"line(s); current driver expects {expected_lc}"
                    )

    # Fingerprint denylist (flatten to check_denylist's expected shape).
    flat = {
        "slug": slug,
        "title": slug_lookup.get(slug, {}).get("new_title", ""),
        "description": entry.get("description", ""),
        "constraints": entry.get("constraints", ""),
        "sample_inputs": [t.get("input", "") for t in (tcs if isinstance(tcs, list) else [])],
        "sample_outputs": [t.get("expected_output", "") for t in (tcs if isinstance(tcs, list) else [])],
    }
    hits = []
    hits += check_examples(flat, denylists["examples"])
    hits += check_titles(flat, denylists["titles"])
    hits += check_bounds(flat, denylists["bounds"])
    for h in hits:
        errors.append(f"{slug}: denylist hit — {json.dumps(h)}")

    return errors


def main() -> int:
    p = argparse.ArgumentParser()
    p.add_argument("--dir", default="/tmp/rewrite-workspace/rewrites",
                   help="directory of per-tag rewrite JSON files")
    p.add_argument("--master-mapping", default="/tmp/rewrite-workspace/data/master-mapping.json")
    p.add_argument("--test-cases", default="/tmp/rewrite-workspace/data/test_cases.json")
    p.add_argument("--pilot-slug", default="shelf-stock-pair",
                   help="slug whose rename came via a dedicated pilot commit, "
                        "not present in master-mapping")
    p.add_argument("--denylist-dir", default=None)
    p.add_argument("--out", required=True)
    args = p.parse_args()

    slug_lookup = load_master_mapping(Path(args.master_mapping))
    old_sample_line_counts = load_current_samples(Path(args.test_cases))
    denylist_dir = resolve_denylist_dir(args.denylist_dir)
    denylists = {
        "examples": load_denylist_file(denylist_dir, "examples"),
        "titles": load_denylist_file(denylist_dir, "titles"),
        "bounds": load_denylist_file(denylist_dir, "bounds"),
    }

    master = []
    seen_slugs = {}
    all_errors = []
    per_tag_counts = {}

    for path in sorted(Path(args.dir).glob("*.json")):
        tag_name = path.stem
        try:
            entries = json.loads(path.read_text())
        except json.JSONDecodeError as ex:
            all_errors.append(f"{path.name}: invalid JSON — {ex}")
            continue
        if not isinstance(entries, list):
            all_errors.append(f"{path.name}: top-level is not a list")
            continue
        kept = 0
        for i, e in enumerate(entries):
            if not isinstance(e, dict):
                all_errors.append(f"{path.name}[{i}]: not an object")
                continue
            slug = e.get("slug")
            if slug in seen_slugs:
                all_errors.append(
                    f"{path.name}[{i}]: slug {slug!r} already seen in "
                    f"{seen_slugs[slug]}"
                )
                continue
            errors = validate_entry(
                e,
                slug_lookup=slug_lookup,
                pilot_slug=args.pilot_slug,
                old_sample_line_counts=old_sample_line_counts,
                denylists=denylists,
            )
            if errors:
                for err in errors:
                    all_errors.append(f"{path.name}[{i}]: {err}")
                continue
            seen_slugs[slug] = path.name
            master.append(e)
            kept += 1
        per_tag_counts[tag_name] = (len(entries), kept)

    print("Per-tag summary (total / kept after validation):")
    for tag, (total, kept) in sorted(per_tag_counts.items()):
        print(f"  {tag:40s} {total:3d} / {kept:3d}")
    print(f"\nMerged total: {len(master)}")
    if all_errors:
        print(f"\n{len(all_errors)} error(s):")
        for e in all_errors:
            print(f"  - {e}")
        return 1

    Path(args.out).write_text(json.dumps(master, indent=2))
    print(f"\nOK: wrote {args.out}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
