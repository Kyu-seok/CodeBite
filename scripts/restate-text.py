#!/usr/bin/env python3
"""Writes a text-only Restatement's migration from exact replacements on the statement as it stands.

    scripts/restate-text.py <spec.json>          # reads the statement through scripts/db-sql.sh
    scripts/restate-text.py <spec.json> --current current.json --out-dir <dir>   # (tests)

spec.json:
    {"slug": "merge-cafe-queues", "version": 586,
     "why": ["The last constraint counted \"order nodes\", left over from an older story."],
     "edits": [{"lang": "en", "column": "constraints", "old": "order nodes", "new": "nodes"},
               {"lang": "ko", "column": "constraints", "old": "주문 노드", "new": "노드"}]}

Each edit replaces text that occurs exactly once in that language's title, description or
constraints, in order, so several edits can rework one column. Only changed columns are written,
English to `problems` and Korean to `problem_translations`, in $$ quotes, as
.claude/skills/restate-problem/SKILL.md step 3 lays out; the file is V<version>__restate_<slug>.sql,
or ..._ko.sql when only Korean changes. Nothing is written when an edit misses, matches twice or
brings in a $$. The database read is refused like any scripts/db-sql.sh read when it is missing this
checkout's migrations: with several Restatements in a row, CODEBITE_ALLOW_STALE=1 reads past the
ones just written, which touch other problems.
"""
import argparse
import json
import pathlib
import subprocess
import sys

ROOT = pathlib.Path(__file__).resolve().parent.parent
COLUMNS = ("title", "description", "constraints")


def current_statement(slug):
    query = f"""SELECT json_build_object(
        'en', json_build_object('title', p.title, 'description', p.description, 'constraints', p.constraints),
        'ko', json_build_object('title', k.title, 'description', k.description, 'constraints', k.constraints))
        FROM problems p JOIN problem_translations k ON k.problem_id = p.id AND k.locale = 'ko'
        WHERE p.slug = '{slug}'"""
    result = subprocess.run([str(ROOT / "scripts/db-sql.sh"), query], cwd=ROOT, capture_output=True, text=True)
    if result.returncode != 0:
        sys.exit(result.stderr.strip() or "restate-text: the database read failed")
    if not result.stdout.strip():
        sys.exit(f"restate-text: no problem {slug}")
    return json.loads(result.stdout)


def main():
    parser = argparse.ArgumentParser(description="Write a text-only Restatement migration.")
    parser.add_argument("spec")
    parser.add_argument("--current", help="the statement as JSON, instead of reading the database")
    parser.add_argument("--out-dir", default=str(ROOT / "common/src/main/resources/db/migration"))
    args = parser.parse_args()

    spec = json.loads(pathlib.Path(args.spec).read_text(encoding="utf-8"))
    slug, version = spec["slug"], int(spec["version"])
    current = (json.loads(pathlib.Path(args.current).read_text(encoding="utf-8")) if args.current
               else current_statement(slug))

    changed = {}
    for edit in spec["edits"]:
        lang, column = edit["lang"], edit["column"]
        if lang not in ("en", "ko") or column not in COLUMNS:
            sys.exit(f"restate-text: {lang} column {column} is not part of a statement ({', '.join(COLUMNS)})")
        text = changed.get((lang, column), current[lang][column])
        count = text.count(edit["old"])
        if count != 1:
            sys.exit(f"restate-text: {lang} {column}: {edit['old']!r} occurs {count} times, not once")
        changed[(lang, column)] = text.replace(edit["old"], edit["new"])
    for (lang, column), text in changed.items():
        if "$$" in text:
            sys.exit(f"restate-text: {lang} {column} would contain $$, which ends the SQL quote")

    def assignments(lang):
        return ",\n".join(f"    {column} = $${text}$$" for (l, column), text in changed.items() if l == lang)

    why = spec.get("why") or []
    header = f"-- V{version}: {slug}, text only." + (f" {why[0]}" if why else "") + "\n"
    header += "".join(f"-- {line}\n" for line in why[1:])
    sql = header
    if assignments("en"):
        sql += f"\nUPDATE problems SET\n{assignments('en')}\nWHERE slug = $${slug}$$;\n"
    if assignments("ko"):
        sql += (f"\nUPDATE problem_translations SET\n{assignments('ko')}\nWHERE locale = 'ko'\n"
                f"  AND problem_id = (SELECT id FROM problems WHERE slug = $${slug}$$);\n")

    only_korean = all(lang == "ko" for lang, _ in changed)
    name = f"V{version}__restate_{slug.replace('-', '_')}{'_ko' if only_korean else ''}.sql"
    out = pathlib.Path(args.out_dir)
    taken = [p.name for p in out.glob(f"V{version}__*")]
    if taken:
        sys.exit(f"restate-text: V{version} is taken by {taken[0]}")
    (out / name).write_text(sql, encoding="utf-8")
    print(f"wrote {out / name}")


if __name__ == "__main__":
    main()
