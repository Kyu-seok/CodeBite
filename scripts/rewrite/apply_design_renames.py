#!/usr/bin/env python3
"""
Apply design-interface renames across driver files, starter files, and
emit a Flyway migration that updates test_cases command-trace strings
plus problem titles.

Driver files live at common/src/main/resources/drivers/<slug>/<lang>.<ext>.
Starter files live at backend/src/main/resources/starters/<slug>/<lang>.<ext>.

Each rename spec (from design-renames.json) names an old_class → new_class
plus an optional method_renames map. Class and method strings are replaced
with word-boundary care (quoted tokens in command traces, bare identifiers
in code).

For test_cases the migration uses REPLACE() on input; it touches both
sample and hidden rows. This is safe as long as no argument string in
the canonical command traces collides with an old class or method name —
a collision check runs before the SQL is emitted.

Usage:
    apply_design_renames.py --spec /tmp/rewrite-workspace/data/design-renames.json \
        --repo-root /Users/kyu/Work/CodeBite \
        --test-cases /tmp/rewrite-workspace/data/test_cases.json \
        --migration-out /tmp/rewrite-workspace/data/design-renames-partial.sql
"""
import argparse
import json
import re
import sys
from pathlib import Path


LANGS = [("java", "java"), ("cpp", "cpp"), ("python", "py"), ("javascript", "js")]


def rename_in_code(text: str, old_class: str, new_class: str,
                   method_renames: dict) -> str:
    out = text
    # Class name: replace as an identifier (word boundary)
    out = re.sub(rf"\b{re.escape(old_class)}\b", new_class, out)
    # Method names: word-boundary replace in identifier positions, plus
    # inside quoted dispatch strings (e.g. case "push").
    for old_m, new_m in method_renames.items():
        out = re.sub(rf"\b{re.escape(old_m)}\b", new_m, out)
    return out


def rewrite_file(path: Path, old_class: str, new_class: str,
                 method_renames: dict) -> bool:
    if not path.exists():
        return False
    orig = path.read_text()
    new = rename_in_code(orig, old_class, new_class, method_renames)
    if new != orig:
        path.write_text(new)
        return True
    return False


def check_test_case_collisions(test_cases: list, spec: dict) -> list:
    """Return a list of warnings about argument strings that collide with
    an old class/method name and would therefore be corrupted by REPLACE."""
    warnings = []
    by_slug = {}
    for t in test_cases:
        by_slug.setdefault(t["slug"], []).append(t)
    for entry in spec["problems"]:
        slug = entry["slug"]
        rows = by_slug.get(slug, [])
        tokens = {entry["old_class"]}
        tokens.update(entry.get("method_renames", {}).keys())
        for row in rows:
            inp = row.get("input", "")
            # inp is two-line: ops array, args array. Check the args
            # portion only — ops will contain the tokens by design.
            lines = inp.split("\n", 1)
            if len(lines) < 2:
                continue
            args_line = lines[1]
            for tok in tokens:
                quoted = f'"{tok}"'
                if quoted in args_line:
                    warnings.append(
                        f"{slug} order_index={row.get('order_index')} "
                        f"is_sample={row.get('is_sample')}: arg string contains {quoted}"
                    )
    return warnings


def sql_lit(s: str) -> str:
    return "'" + s.replace("'", "''") + "'"


def emit_migration_body(spec: dict) -> str:
    lines = []
    for entry in spec["problems"]:
        slug = entry["slug"]
        old_class = entry["old_class"]
        new_class = entry["new_class"]
        new_title = entry["new_title"]
        method_renames = entry.get("method_renames", {})
        lines.append(f"-- {slug}: {old_class} -> {new_class}")
        lines.append(
            f"UPDATE problems SET title = {sql_lit(new_title)} "
            f"WHERE slug = {sql_lit(slug)};"
        )
        old_q = sql_lit('"' + old_class + '"')
        new_q = sql_lit('"' + new_class + '"')
        slug_q = sql_lit(slug)
        lines.append(
            f"UPDATE test_cases SET input = REPLACE(input, {old_q}, {new_q}) "
            f"WHERE problem_id = (SELECT id FROM problems WHERE slug = {slug_q});"
        )
        for old_m, new_m in method_renames.items():
            om_q = sql_lit('"' + old_m + '"')
            nm_q = sql_lit('"' + new_m + '"')
            lines.append(
                f"UPDATE test_cases SET input = REPLACE(input, {om_q}, {nm_q}) "
                f"WHERE problem_id = (SELECT id FROM problems WHERE slug = {slug_q});"
            )
        # Description rename: backtick-quoted tokens only, so we don't
        # clobber common English words. Class also matches bare tokens.
        bt_old_class = sql_lit("`" + old_class + "`")
        bt_new_class = sql_lit("`" + new_class + "`")
        lines.append(
            f"UPDATE problems SET description = REPLACE(description, {bt_old_class}, {bt_new_class}) "
            f"WHERE slug = {slug_q};"
        )
        plain_old_class = sql_lit(old_class)
        plain_new_class = sql_lit(new_class)
        lines.append(
            f"UPDATE problems SET description = REPLACE(description, {plain_old_class}, {plain_new_class}) "
            f"WHERE slug = {slug_q};"
        )
        for old_m, new_m in method_renames.items():
            bt_old = sql_lit("`" + old_m + "`")
            bt_new = sql_lit("`" + new_m + "`")
            lines.append(
                f"UPDATE problems SET description = REPLACE(description, {bt_old}, {bt_new}) "
                f"WHERE slug = {slug_q};"
            )
            pa_old = sql_lit("`" + old_m + "(")
            pa_new = sql_lit("`" + new_m + "(")
            lines.append(
                f"UPDATE problems SET description = REPLACE(description, {pa_old}, {pa_new}) "
                f"WHERE slug = {slug_q};"
            )
        lines.append("")
    return "\n".join(lines)


def main() -> int:
    p = argparse.ArgumentParser()
    p.add_argument("--spec", required=True)
    p.add_argument("--repo-root", required=True)
    p.add_argument("--test-cases", required=True)
    p.add_argument("--migration-out", required=True)
    p.add_argument("--apply-files", action="store_true",
                   help="actually rewrite driver/starter files")
    args = p.parse_args()

    spec = json.loads(Path(args.spec).read_text())
    test_cases = json.loads(Path(args.test_cases).read_text())
    repo = Path(args.repo_root)
    drivers_root = repo / "common/src/main/resources/drivers"
    starters_root = repo / "backend/src/main/resources/starters"

    warnings = check_test_case_collisions(test_cases, spec)
    if warnings:
        print("WARNING: argument-string collisions detected (REPLACE may corrupt args):",
              file=sys.stderr)
        for w in warnings:
            print(f"  - {w}", file=sys.stderr)

    if args.apply_files:
        for entry in spec["problems"]:
            slug = entry["slug"]
            old_class = entry["old_class"]
            new_class = entry["new_class"]
            method_renames = entry.get("method_renames", {})
            for lang, ext in LANGS:
                d = drivers_root / slug / f"{lang}.{ext}"
                s = starters_root / slug / f"{lang}.{ext}"
                if rewrite_file(d, old_class, new_class, method_renames):
                    print(f"  driver rewrote: {d.relative_to(repo)}")
                if rewrite_file(s, old_class, new_class, method_renames):
                    print(f"  starter rewrote: {s.relative_to(repo)}")

    body = emit_migration_body(spec)
    Path(args.migration_out).write_text(body)
    print(f"wrote migration body to {args.migration_out}", file=sys.stderr)
    return 0


if __name__ == "__main__":
    sys.exit(main())
