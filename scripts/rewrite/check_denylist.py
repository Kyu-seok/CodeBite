#!/usr/bin/env python3
"""
Check a proposed problem rewrite against the fingerprint denylist.

Flags a rewrite whose title, slug, description, constraints, or sample I/O
contains a pattern, substring, or regex that is known to uniquely identify a
canonical problem from well-known problem sets. Keeps generated content
distinctive instead of accidentally echoing a famous example.

Usage:
    check_denylist.py <rewrite.json> [--denylist-dir DIR] [--quiet]

Denylist directory resolution order:
    1. --denylist-dir CLI flag
    2. CODEBITE_DENYLIST_DIR environment variable
    3. Bundled copy next to this script: scripts/rewrite/denylist/

An annotated denylist (*.annotated.json) may be kept outside the repo for
richer operator output; the bundled copy contains only the match fields.

Input JSON shape:
    {
      "slug": "...",
      "title": "...",
      "description": "...",
      "constraints": "...",
      "sample_inputs": ["...", ...],
      "sample_outputs": ["...", ...]
    }

Exit 0 on pass, 1 on denylist hit. Hits printed to stdout as JSON lines.
"""
import argparse
import json
import os
import re
import sys
from pathlib import Path
from typing import Optional


SCRIPT_DIR = Path(__file__).resolve().parent


def normalize(text: str) -> str:
    """Lowercase, strip backticks, collapse whitespace."""
    text = text.lower()
    text = text.replace("`", "")
    text = re.sub(r"\s+", " ", text)
    return text


def resolve_denylist_dir(cli_flag: Optional[str]) -> Path:
    if cli_flag:
        return Path(cli_flag)
    env = os.environ.get("CODEBITE_DENYLIST_DIR")
    if env:
        return Path(env)
    return SCRIPT_DIR / "denylist"


def load_denylist_file(dir_path: Path, base_name: str) -> dict:
    """Prefer *.annotated.json if present (local-only), fall back to *.json."""
    annotated = dir_path / f"{base_name}.annotated.json"
    plain = dir_path / f"{base_name}.json"
    if annotated.exists():
        return json.loads(annotated.read_text())
    if plain.exists():
        return json.loads(plain.read_text())
    raise RuntimeError(f"Denylist file missing: {plain} (or {annotated})")


def check_examples(rewrite: dict, denylist: dict) -> list[dict]:
    hits = []
    search_fields = {
        "description": rewrite.get("description", ""),
        "constraints": rewrite.get("constraints", ""),
    }
    for i, s in enumerate(rewrite.get("sample_inputs", [])):
        search_fields[f"sample_inputs[{i}]"] = s
    for i, s in enumerate(rewrite.get("sample_outputs", [])):
        search_fields[f"sample_outputs[{i}]"] = s

    normalized = {k: normalize(v) for k, v in search_fields.items()}

    buckets = ["arrays", "strings", "structured", "design_call_traces", "edge_case_phrasings"]
    for bucket in buckets:
        for entry in denylist.get(bucket, []):
            pat = normalize(entry["pattern"])
            if len(pat) < 4:
                continue  # too short to be decisive
            for field_name, field_text in normalized.items():
                if pat in field_text:
                    hit = {
                        "category": "examples",
                        "bucket": bucket,
                        "pattern": entry["pattern"],
                        "field": field_name,
                    }
                    for k, v in entry.items():
                        if k != "pattern":
                            hit[k] = v
                    hits.append(hit)
    return hits


def check_titles(rewrite: dict, denylist: dict) -> list[dict]:
    hits = []
    title = (rewrite.get("title") or "").lower()
    slug = (rewrite.get("slug") or "").lower()
    for entry in denylist.get("forbidden_substrings", []):
        sub = entry["substring"].lower()
        if sub in title or sub in slug:
            hit = {
                "category": "titles",
                "substring": entry["substring"],
                "field": "title" if sub in title else "slug",
            }
            for k, v in entry.items():
                if k != "substring":
                    hit[k] = v
            hits.append(hit)
    return hits


def check_bounds(rewrite: dict, denylist: dict) -> list[dict]:
    hits = []
    constraints = rewrite.get("constraints") or ""
    description = rewrite.get("description") or ""
    corpus = f"{constraints}\n{description}"
    for entry in denylist.get("forbidden_regex", []):
        pattern = entry["regex"]
        match = re.search(pattern, corpus, flags=re.IGNORECASE)
        if match:
            hits.append({
                "category": "bounds",
                "regex": pattern,
                "matched": match.group(0),
                "rationale": entry.get("rationale", ""),
            })
    return hits


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("rewrite_json", help="Path to rewrite JSON")
    parser.add_argument("--denylist-dir", default=None,
                        help="Override denylist directory (else $CODEBITE_DENYLIST_DIR or bundled copy)")
    parser.add_argument("--quiet", action="store_true", help="Only print hits, no summary")
    args = parser.parse_args()

    rewrite = json.loads(Path(args.rewrite_json).read_text())
    denylist_dir = resolve_denylist_dir(args.denylist_dir)

    examples_dl = load_denylist_file(denylist_dir, "examples")
    titles_dl = load_denylist_file(denylist_dir, "titles")
    bounds_dl = load_denylist_file(denylist_dir, "bounds")

    hits = []
    hits += check_examples(rewrite, examples_dl)
    hits += check_titles(rewrite, titles_dl)
    hits += check_bounds(rewrite, bounds_dl)

    for hit in hits:
        print(json.dumps(hit))

    if not args.quiet:
        print(f"# slug={rewrite.get('slug')} hits={len(hits)} denylist_dir={denylist_dir}", file=sys.stderr)

    return 1 if hits else 0


if __name__ == "__main__":
    sys.exit(main())
