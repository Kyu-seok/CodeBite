#!/usr/bin/env bash
# Reads a problem from production's public API, English and Korean.
#
#   scripts/prod-text.sh <slug>                  # prints each language's title, description, constraints
#   scripts/prod-text.sh <slug> --contains <file>
#       exits 0 when both descriptions contain the file's text exactly, 1 when one doesn't
#
# Run --contains before merging a migration that replaces exact text and fails
# without it: an edit through the admin page would otherwise stop the deploy.
# Compare the plain output with scripts/problem-text.sh before a migration that
# overwrites a problem's text, which would discard such an edit.
set -euo pipefail

usage() { echo "usage: scripts/prod-text.sh <slug> [--contains <file>]" >&2; exit 2; }
[[ $# -eq 1 || $# -eq 3 ]] && [[ "$1" != -* ]] || usage
slug=$1
needle_file=
if [[ $# -eq 3 ]]; then
  [[ "$2" == --contains && -r "$3" ]] || usage
  needle_file=$3
fi
base=${CODEBITE_PROD_URL:-https://code-bite.com}

status=0
for locale in en ko; do
  if ! body=$(curl -fsS -m 20 -H "Accept-Language: $locale" "$base/api/problems/$slug"); then
    echo "prod-text.sh: could not read $slug ($locale) from $base" >&2
    exit 2
  fi
  PROD_TEXT_NEEDLE_FILE=$needle_file PROD_TEXT_LOCALE=$locale python3 -I -c '
import json, os, sys
problem = json.loads(sys.stdin.read())
description = problem["description"]
locale = os.environ["PROD_TEXT_LOCALE"]
needle_file = os.environ["PROD_TEXT_NEEDLE_FILE"]
if not needle_file:
    title, constraints = problem.get("title"), problem.get("constraints")
    print(f"--- {locale} ---\ntitle: {title}\n\n{description}\n\nconstraints:\n{constraints}")
    sys.exit(0)
needle = open(needle_file, encoding="utf-8").read().removesuffix("\n")
found = needle in description
print(locale + ": " + ("found" if found else "NOT FOUND"))
sys.exit(0 if found else 1)
' <<<"$body" || status=1
done
exit "$status"
