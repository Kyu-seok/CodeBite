#!/usr/bin/env python3
"""
Turn a merged rewrite JSON into a Flyway migration (UPDATEs only).

For each entry:
  1. UPDATE problems SET description, constraints WHERE slug = ...
  2. For each sample_test_cases[i] (by order_index): UPDATE test_cases
     SET input, expected_output WHERE problem_id = (SELECT id ...)
     AND is_sample = TRUE AND order_index = i. Hidden test cases are
     untouched. Sample rows are updated in place so historical
     submission_results FKs remain valid.

Uses PostgreSQL dollar-quoted string literals to avoid escaping hell in
descriptions and constraints. Sample inputs/outputs go through a
single-quote escape because they may contain arbitrary payload but are
typically short.

Usage:
    emit_rewrite_migration.py --master master-rewrites.json \
        --version V124 --description rewrite_descriptions_batch \
        --out common/src/main/resources/db/migration/V124__rewrite_descriptions_batch.sql
"""
import argparse
import json
import sys
from pathlib import Path


def sql_single(s: str) -> str:
    """Quote a string for SQL using single quotes, doubling embedded ones."""
    escaped = s.replace("'", "''")
    return f"'{escaped}'"


def sql_estring(s: str) -> str:
    """E-string literal for values that may contain \\n (encoded literally)."""
    escaped = s.replace("\\", "\\\\").replace("'", "''").replace("\n", "\\n").replace("\r", "\\r").replace("\t", "\\t")
    return f"E'{escaped}'"


def pick_dollar_tag(text: str) -> str:
    for tag in ("", "DESC", "DESC2", "TXT", "TXT2"):
        delim = f"${tag}$"
        if delim not in text:
            return tag
    # Very unlikely: generate something unique.
    for i in range(1, 1000):
        tag = f"T{i}"
        if f"${tag}$" not in text:
            return tag
    raise RuntimeError("could not find a safe dollar-quote tag")


def dollar(text: str) -> str:
    tag = pick_dollar_tag(text)
    return f"${tag}${text}${tag}$"


def emit_entry(e: dict) -> str:
    slug = e["slug"]
    desc = e["description"].rstrip("\n")
    cons = e["constraints"].rstrip("\n")
    lines = []
    lines.append(f"-- {slug}")
    lines.append("UPDATE problems SET")
    lines.append(f"  description = {dollar(desc)},")
    lines.append(f"  constraints = {dollar(cons)}")
    lines.append(f"WHERE slug = {sql_single(slug)};")
    lines.append("")
    for t in sorted(e["sample_test_cases"], key=lambda x: x["order_index"]):
        oi = t["order_index"]
        inp = t["input"]
        exp = t["expected_output"]
        lines.append(
            f"UPDATE test_cases SET input = {sql_estring(inp)}, "
            f"expected_output = {sql_single(exp)}"
        )
        lines.append(
            f"WHERE problem_id = (SELECT id FROM problems WHERE slug = {sql_single(slug)})"
        )
        lines.append(f"  AND is_sample = TRUE AND order_index = {oi};")
    lines.append("")
    return "\n".join(lines)


def main() -> int:
    p = argparse.ArgumentParser()
    p.add_argument("--master", required=True)
    p.add_argument("--version", required=True, help="e.g. V124")
    p.add_argument("--description", required=True,
                   help="Flyway migration slug after version, e.g. rewrite_descriptions_batch")
    p.add_argument("--out", required=True)
    args = p.parse_args()

    entries = json.loads(Path(args.master).read_text())
    if not isinstance(entries, list) or not entries:
        print("master JSON is empty or not a list", file=sys.stderr)
        return 1

    header = [
        f"-- {args.version}: Phase 2 — rewrite description, constraints, and sample",
        f"-- test cases for {len(entries)} problem(s). Hidden test cases are not touched.",
        "-- Sample test case rows are updated in place (preserving test case IDs) so",
        "-- historical submission_results FKs remain valid.",
        "",
    ]
    body = "\n".join(emit_entry(e) for e in entries)
    out_path = Path(args.out)
    out_path.write_text("\n".join(header) + body)
    print(f"wrote {out_path} covering {len(entries)} problem(s)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
