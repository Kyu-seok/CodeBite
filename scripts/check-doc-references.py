#!/usr/bin/env python3
"""Fails when an agent-facing document points at something that isn't there.

Two kinds of pointer are checked:

* a repo path in inline backticks (`scripts/judge-local.sh`, `.claude/skills/x/SKILL.md`) in
  CLAUDE.md, GLOSSARY.md, CODING_STANDARDS.md, .claude/skills, .claude/agents and docs/agents
  must exist, at the repo root or, for a package like `common/time/`, under a Java source root.
  Skipped: paths with a placeholder (<slug>, {slug}, *, ..., …), gitignored ones (`infra/.env`),
  fenced code blocks, and ADRs, which record what was true when they were written.
* a term cited as "Term (GLOSSARY.md)" in those documents, ADRs or source comments must be a
  **Term**: entry or a ### section of GLOSSARY.md (a leading article and a plural -s are allowed).

Agents trust pointers, so a dangling one costs a search, or worse, a wrong guess: a branch that
cites a glossary entry or skill another branch adds would merge with a dangling pointer.
A third check keeps the same documents' tables whole: a line that is neither blank nor a row
between two rows of a table (a paragraph pasted into the middle) cuts the rows after it off.
A fourth keeps CLAUDE.md under CLAUDE_MD_CEILING bytes: it loads on every turn of every session,
so layout and reference belong in docs/agents/ behind a pointer (#151).

    scripts/check-doc-references.py [repo-root]

Exits 1 and lists each dangling pointer as file:line.
"""
import re
import subprocess
import sys
from pathlib import Path

DOCS = ["CLAUDE.md", "GLOSSARY.md", "CODING_STANDARDS.md",
        ".claude/skills/**/*.md", ".claude/agents/*.md", "docs/agents/*.md"]
RECORDS = ["docs/adr/*.md"]
PACKAGE_ROOTS = ["common/src/main/java/com/codebite", "backend/src/main/java/com/codebite",
                 "worker/src/main/java/com/codebite/worker"]
SOURCES = ["frontend/src/**/*.ts", "frontend/src/**/*.tsx",
           "backend/src/**/*.java", "common/src/**/*.java", "worker/src/**/*.java"]
TOP_DIRS = (".claude", ".github", ".githooks", "backend", "common", "frontend", "worker", "infra", "scripts", "docs")

INLINE_CODE = re.compile(r"`([^`\n]+)`")
FENCE = re.compile(r"^\s*(```|~~~)")
PLACEHOLDER = re.compile(r"[<>{}*$]|\.\.\.|…")
PATH = re.compile(r"^(?:%s)/[^\s]*$" % "|".join(re.escape(d) for d in TOP_DIRS))
GLOSSARY_CITE = re.compile(r"(?:\*\*)?([A-Z][a-z]+(?: [A-Z][a-z]+)*)(?:\*\*)? \(GLOSSARY\.md\)")
GLOSSARY_ENTRY = re.compile(r"^(?:\*\*(.+?)\*\*:|#{2,} (.+?)\s*)$", re.M)
ARTICLE = re.compile(r"^(?:A|An|The|Each|Every) ")
TABLE_ROW = re.compile(r"^\s*\|")
# CLAUDE.md's size after #151 (22.3KB) plus about ten percent headroom, to a whole KB. Raising it is
# a decision to make on purpose, in its own commit, not a fix for a check that went red.
CLAUDE_MD_CEILING = 25_000


def files(root, patterns):
    seen = set()
    for pattern in patterns:
        for path in sorted(root.glob(pattern)):
            if path.is_file() and "node_modules" not in path.parts and path not in seen:
                seen.add(path)
                yield path


def known_terms(root):
    glossary = root / "GLOSSARY.md"
    if not glossary.exists():
        return set()
    return {entry or heading for entry, heading in GLOSSARY_ENTRY.findall(glossary.read_text())}


def is_term(cited, terms):
    for candidate in (cited, ARTICLE.sub("", cited)):
        if candidate in terms or (candidate.endswith("s") and candidate[:-1] in terms):
            return True
    return False


def path_problems(root, path, text):
    in_fence = False
    for number, line in enumerate(text.splitlines(), 1):
        if FENCE.match(line):
            in_fence = not in_fence
            continue
        if in_fence:
            continue
        for span in INLINE_CODE.findall(line):
            span = span.strip()
            if not PATH.match(span) or PLACEHOLDER.search(span):
                continue
            target = re.sub(r":\d+$", "", span).rstrip("/")
            if not exists(root, target):
                yield f"{path.relative_to(root)}:{number}: `{span}` does not exist"


def exists(root, target):
    if (root / target).exists() or any((root / base / target).exists() for base in PACKAGE_ROOTS):
        return True
    # A folder-only rule (`build/`) matches a path that isn't on disk only when it ends in a slash,
    # so a clean checkout (CI) would miss what this machine's build output lets through.
    return any(subprocess.run(["git", "-C", str(root), "check-ignore", "-q", path], check=False).returncode == 0
               for path in (target, target + "/"))


def glossary_problems(root, path, text, terms):
    for number, line in enumerate(text.splitlines(), 1):
        for cited in GLOSSARY_CITE.findall(line):
            if not is_term(cited, terms):
                yield f"{path.relative_to(root)}:{number}: \"{cited}\" is not a GLOSSARY.md entry"


def table_problems(root, path, text):
    lines = text.splitlines()
    in_fence = False
    for number, line in enumerate(lines, 1):
        if FENCE.match(line):
            in_fence = not in_fence
            continue
        if in_fence or not line.strip() or TABLE_ROW.match(line):
            continue
        before = lines[number - 2] if number >= 2 else ""
        after = lines[number] if number < len(lines) else ""
        if TABLE_ROW.match(before) and TABLE_ROW.match(after):
            yield f"{path.relative_to(root)}:{number}: splits a table (the rows after it are cut off)"


def size_problems(root):
    claude_md = root / "CLAUDE.md"
    if not claude_md.exists():
        return
    size = claude_md.stat().st_size
    if size > CLAUDE_MD_CEILING:
        yield (f"CLAUDE.md: {size} bytes is over the {CLAUDE_MD_CEILING}-byte ceiling; it loads on every "
               "turn, so move layout or reference to docs/agents/ behind a pointer (raising "
               "CLAUDE_MD_CEILING is a decision to make on purpose)")


def problems(root):
    terms = known_terms(root)
    yield from size_problems(root)
    for path in files(root, DOCS):
        text = path.read_text()
        yield from path_problems(root, path, text)
        yield from glossary_problems(root, path, text, terms)
        yield from table_problems(root, path, text)
    for path in files(root, RECORDS + SOURCES):
        yield from glossary_problems(root, path, path.read_text(), terms)


def main(argv):
    root = Path(argv[1] if len(argv) > 1 else Path(__file__).resolve().parent.parent).resolve()
    found = list(problems(root))
    for problem in found:
        print(problem)
    if found:
        print(f"check-doc-references: {len(found)} problem(s)", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
