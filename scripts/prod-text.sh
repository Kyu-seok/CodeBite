#!/usr/bin/env bash
# Reads a problem from production's public API, English and Korean.
#
#   scripts/prod-text.sh <slug>                  # prints each language's title, description, constraints
#   scripts/prod-text.sh <slug> --contains <file>
#       exits 0 when both descriptions contain the file's text exactly, 1 when one doesn't
#   scripts/prod-text.sh --matches-db <slug>...
#       exits 0 when each problem's title, description and constraints, in both languages, are
#       production's exactly in the local database CODEBITE_DB (default codebite), 1 naming each
#       that differs
#
# Run --contains before merging a migration that replaces exact text and fails
# without it: an edit through the admin page would otherwise stop the deploy.
# --matches-db is that check for a migration that replaces a different line in each language or
# across many problems: run it on a database at origin/master's migrations, which is the text the
# migration expects, such as the branch database right after a fresh worktree's first
# `scripts/dev-branch-servers.sh migrate`, before the migration exists.
# Compare the plain output with scripts/problem-text.sh before a migration that
# overwrites a problem's text, which would discard such an edit.
set -euo pipefail

usage() { echo "usage: scripts/prod-text.sh <slug> [--contains <file>] | --matches-db <slug>..." >&2; exit 2; }
base=${CODEBITE_PROD_URL:-https://code-bite.com}

if [[ "${1:-}" == --matches-db ]]; then
  shift
  [[ $# -ge 1 ]] || usage
  here=$(cd "$(dirname "$0")/.." && pwd)
  # shellcheck source=SCRIPTDIR/dev-servers-common.sh
  source "$here/scripts/dev-servers-common.sh"
  database=${CODEBITE_DB:-codebite}
  version=$(flyway_version "$database")
  [[ -n "$version" ]] || { echo "prod-text.sh: database $database $(db_unreachable_message)" >&2; exit 2; }
  echo "comparing production with database $database (V$version)"
  status=0
  for slug in "$@"; do
    [[ "$slug" =~ ^[a-z0-9-]+$ ]] || { echo "prod-text.sh: not a slug: $slug" >&2; exit 2; }
    local_json=$(db_psql "$database" -tA -c "SELECT json_build_object(
        'en', json_build_object('title', p.title, 'description', p.description, 'constraints', p.constraints),
        'ko', json_build_object('title', t.title, 'description', t.description, 'constraints', t.constraints))
      FROM problems p LEFT JOIN problem_translations t ON t.problem_id = p.id AND t.locale = 'ko'
      WHERE p.slug = '$slug'")
    [[ -n "$local_json" ]] || { echo "$slug: not in database $database"; status=1; continue; }
    for locale in en ko; do
      if ! body=$(curl -fsS -m 20 -H "Accept-Language: $locale" "$base/api/problems/$slug"); then
        echo "prod-text.sh: could not read $slug ($locale) from $base" >&2
        exit 2
      fi
      PROD_TEXT_LOCAL=$local_json PROD_TEXT_LOCALE=$locale PROD_TEXT_SLUG=$slug python3 -I -c '
import json, os, sys
prod = json.loads(sys.stdin.read())
locale, slug = os.environ["PROD_TEXT_LOCALE"], os.environ["PROD_TEXT_SLUG"]
local = json.loads(os.environ["PROD_TEXT_LOCAL"])[locale]
differs = [f for f in ("title", "description", "constraints") if prod.get(f) != local[f]]
for field in differs:
    print(f"{slug} ({locale}): {field} DIFFERS from production")
sys.exit(1 if differs else 0)
' <<<"$body" || status=1
    done
  done
  (( status == 0 )) && echo "all $# problem(s) match production in both languages"
  exit "$status"
fi

[[ $# -eq 1 || $# -eq 3 ]] && [[ "$1" != -* ]] || usage
slug=$1
needle_file=
if [[ $# -eq 3 ]]; then
  [[ "$2" == --contains && -r "$3" ]] || usage
  needle_file=$3
fi

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
