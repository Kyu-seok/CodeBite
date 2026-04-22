#!/usr/bin/env python3
"""
Rename one or more problems structurally: slug, title, and the method name
used in driver harnesses and starter stubs. Driver and starter folders are
moved via `git mv` so history is preserved; method-name tokens inside the
eight affected files (driver + starter × 4 languages) are rewritten in place.

A Flyway migration stub is emitted so the database can be updated to match.
Migration is NOT applied automatically — the operator runs `flyway migrate`
or restarts the backend.

Mapping JSON shape:
    [
      {
        "old_slug": "old-slug",
        "new_slug": "new-slug",
        "old_title": "Old Title",
        "new_title": "New Title",
        "old_method": "oldMethodName",
        "new_method": "newMethodName"
      },
      ...
    ]

Usage:
    rename_problem.py --mapping map.json --migration-version V121 [--dry-run]
"""
import argparse
import json
import re
import subprocess
import sys
from pathlib import Path
from typing import List, Dict


REPO_ROOT = Path(__file__).resolve().parents[2]
DRIVERS_DIR = REPO_ROOT / "common" / "src" / "main" / "resources" / "drivers"
STARTERS_DIR = REPO_ROOT / "backend" / "src" / "main" / "resources" / "starters"
MIGRATIONS_DIR = REPO_ROOT / "common" / "src" / "main" / "resources" / "db" / "migration"

FILE_NAMES = ["java.java", "python.py", "javascript.js", "cpp.cpp"]


def die(msg: str) -> None:
    print(f"error: {msg}", file=sys.stderr)
    sys.exit(1)


def validate_entry(entry: Dict) -> None:
    required = ["old_slug", "new_slug", "old_title", "new_title", "old_method", "new_method"]
    missing = [k for k in required if k not in entry]
    if missing:
        die(f"mapping entry missing keys {missing}: {entry}")
    for k in ["new_slug", "new_method"]:
        if not entry[k] or not isinstance(entry[k], str):
            die(f"mapping entry has empty/invalid {k}: {entry}")


def git_mv(src: Path, dst: Path, dry_run: bool) -> None:
    if not src.exists():
        die(f"source path does not exist: {src}")
    if dst.exists():
        die(f"destination already exists: {dst}")
    cmd = ["git", "mv", str(src), str(dst)]
    print("  $", " ".join(cmd))
    if not dry_run:
        subprocess.run(cmd, cwd=REPO_ROOT, check=True)


def rewrite_methods_in_file(path: Path, old_method: str, new_method: str, dry_run: bool) -> int:
    """Replace whole-word occurrences of old_method with new_method. Returns replacement count."""
    text = path.read_text()
    pattern = re.compile(r"\b" + re.escape(old_method) + r"\b")
    new_text, n = pattern.subn(new_method, text)
    if n > 0:
        print(f"  ~ {path.relative_to(REPO_ROOT)}: {n} replacement(s)")
        if not dry_run:
            path.write_text(new_text)
    return n


def rename_one(entry: Dict, dry_run: bool) -> Dict:
    validate_entry(entry)
    old_slug = entry["old_slug"]
    new_slug = entry["new_slug"]
    old_method = entry["old_method"]
    new_method = entry["new_method"]

    print(f"\n== {old_slug} -> {new_slug} (method {old_method} -> {new_method}) ==")

    driver_old = DRIVERS_DIR / old_slug
    driver_new = DRIVERS_DIR / new_slug
    starter_old = STARTERS_DIR / old_slug
    starter_new = STARTERS_DIR / new_slug

    if not driver_old.exists():
        die(f"driver folder missing: {driver_old}")
    if not starter_old.exists():
        die(f"starter folder missing: {starter_old}")

    # 1. Move folders (git mv preserves history).
    if old_slug != new_slug:
        git_mv(driver_old, driver_new, dry_run)
        git_mv(starter_old, starter_new, dry_run)

    # Resolve file targets after move. In dry-run, git mv is skipped, so the
    # files are still at the old paths.
    if old_slug != new_slug and not dry_run:
        driver_target = driver_new
        starter_target = starter_new
    else:
        driver_target = driver_old
        starter_target = starter_old

    # 2. Rewrite method name in 8 files.
    total_replacements = 0
    for fname in FILE_NAMES:
        for base in (driver_target, starter_target):
            path = base / fname
            if path.exists() and old_method != new_method:
                total_replacements += rewrite_methods_in_file(path, old_method, new_method, dry_run)

    return {
        "old_slug": old_slug,
        "new_slug": new_slug,
        "old_title": entry["old_title"],
        "new_title": entry["new_title"],
        "old_method": old_method,
        "new_method": new_method,
        "method_replacements": total_replacements,
    }


def emit_migration(results: List[Dict], version: str, dry_run: bool) -> Path:
    if not version.startswith("V") or not version[1:].isdigit():
        die(f"migration version must look like V121, got {version!r}")
    path = MIGRATIONS_DIR / f"{version}__rename_problems_batch.sql"
    lines = [
        f"-- {version}: structural rename (slug + title) for one rewrite batch",
        "-- Driver folders, starter folders, and embedded method names are moved",
        "-- separately; this migration only updates the problems table.",
        "",
    ]
    for r in results:
        old_slug = r["old_slug"].replace("'", "''")
        new_slug = r["new_slug"].replace("'", "''")
        new_title = r["new_title"].replace("'", "''")
        lines.append(
            f"UPDATE problems SET slug = '{new_slug}', title = '{new_title}' "
            f"WHERE slug = '{old_slug}';"
        )
    lines.append("")
    content = "\n".join(lines)
    print(f"\n== migration {path.relative_to(REPO_ROOT)} ==")
    print(content)
    if not dry_run:
        path.write_text(content)
    return path


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--mapping", required=True, help="Path to mapping JSON")
    parser.add_argument("--migration-version", required=True, help="e.g. V121")
    parser.add_argument("--dry-run", action="store_true",
                        help="Print planned operations; do not run git mv, edit files, or emit migration")
    args = parser.parse_args()

    mapping = json.loads(Path(args.mapping).read_text())
    if not isinstance(mapping, list) or not mapping:
        die("mapping must be a non-empty list of entries")

    results = []
    for entry in mapping:
        results.append(rename_one(entry, args.dry_run))

    emit_migration(results, args.migration_version, args.dry_run)

    print(f"\nOK: {len(results)} problem(s) renamed{' (dry run)' if args.dry_run else ''}.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
