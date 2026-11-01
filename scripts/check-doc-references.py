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
    ignored = subprocess.run(["git", "-C", str(root), "check-ignore", "-q", target], check=False)
    return ignored.returncode == 0


def glossary_problems(root, path, text, terms):
    for number, line in enumerate(text.splitlines(), 1):
        for cited in GLOSSARY_CITE.findall(line):
            if not is_term(cited, terms):
                yield f"{path.relative_to(root)}:{number}: \"{cited}\" is not a GLOSSARY.md entry"


def problems(root):
    terms = known_terms(root)
    for path in files(root, DOCS):
        text = path.read_text()
        yield from path_problems(root, path, text)
        yield from glossary_problems(root, path, text, terms)
    for path in files(root, RECORDS + SOURCES):
        yield from glossary_problems(root, path, path.read_text(), terms)


def main(argv):
    root = Path(argv[1] if len(argv) > 1 else Path(__file__).resolve().parent.parent).resolve()
    found = list(problems(root))
    for problem in found:
        print(problem)
    if found:
        print(f"check-doc-references: {len(found)} dangling pointer(s)", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
