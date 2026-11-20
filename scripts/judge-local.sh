#!/usr/bin/env bash
# Judges one problem's Test Cases on this machine, without Judge0, in all four Languages: each
# Language's reference solution goes into the problem's Driver at {USER_CODE} and runs on the local
# python3.12, node, javac/java and g++, its output compared as the Grader compares it.
#
#   scripts/judge-local.sh <slug>                                # Test Cases from the local database
#   scripts/judge-local.sh <slug> --languages java,cpp           # just those Languages
#   scripts/judge-local.sh <slug> --cases cases.json             # Test Cases not in a migration yet
#   CODEBITE_DB=<database> scripts/judge-local.sh <slug>         # a database other than codebite, such as
#                                                                # the one scripts/dev-branch-servers.sh prints
#
# A database missing this checkout's migrations is refused (exit 2), as scripts/problem-text.sh and
# scripts/db-sql.sh refuse it; CODEBITE_ALLOW_STALE=1 judges it anyway. A Docker daemon that doesn't
# answer or a codebite-postgres that isn't running exits 2 too, with one line saying what to start.
#
# Reference solutions are scripts/replay-solutions/<slug>.<py|java|js|cpp>, Solution class only, as
# a user would submit it. A Former Slug works for the database. cases.json is a list of
# {"input": ..., "expected_output": ...}; a null expected output only has to run.
#
# Exits 0 when every Language was Accepted, 1 when a case failed (or there are no Test Cases), 2 when
# a compiler, interpreter or reference solution is missing, reported as NOT JUDGED rather than as a
# failed case. Java compiles with --release 13 and C++ with -std=gnu++14, as on Judge0; JavaScript
# runs on the local node, newer than Judge0's Node 12. CODEBITE_PYTHON312 and CXX name the Python and
# C++ compiler when python3.12 and g++ on PATH aren't the ones to use.
set -euo pipefail
root="$(cd "$(dirname "$0")/.." && pwd)"
# shellcheck source=SCRIPTDIR/dev-servers-common.sh
source "$root/scripts/dev-servers-common.sh"

usage() { echo "usage: scripts/judge-local.sh <slug> [--languages python,java,javascript,cpp] [--cases cases.json]" >&2; exit 2; }
[[ $# -ge 1 && "$1" != -* ]] || usage
slug=$1; shift
languages=python,java,javascript,cpp
cases_file=
while [[ $# -gt 0 ]]; do
  case $1 in
    --languages) [[ $# -ge 2 ]] || usage; languages=$2; shift 2 ;;
    --cases) [[ $# -ge 2 ]] || usage; cases_file=$2; shift 2 ;;
    *) usage ;;
  esac
done

work=$(mktemp -d "${TMPDIR:-/tmp}/judge-local.XXXXXX")
trap 'rm -rf "$work"' EXIT

if [[ -z "$cases_file" ]]; then
  database=${CODEBITE_DB:-codebite}
  psql() { db_psql "$database" -tA "$@"; }
  # A database missing this checkout's migrations holds the cases as they were: judging those
  # would report ACCEPTED on cases the branch has changed.
  require_current_db "$database" "$root" judge-local.sh || exit 2
  psql -v slug="$slug" > "$work/export.json" <<'SQL'
SELECT json_build_object(
    'slug', p.slug,
    'test_cases', (SELECT coalesce(json_agg(json_build_object('input', t.input, 'expected_output', t.expected_output)
                                            ORDER BY t.order_index, t.id), '[]')
                   FROM test_cases t WHERE t.problem_id = p.id))
FROM problems p
WHERE p.slug = :'slug'
   OR p.id IN (SELECT problem_id FROM problem_former_slugs WHERE slug = :'slug');
SQL
  if [[ ! -s "$work/export.json" ]]; then
    echo "judge-local.sh: no problem $slug in database $database (a slug or Former Slug)" >&2
    exit 2
  fi
  # The current slug names the Driver, and the Test Cases go to the judge on their own.
  slug=$(python3 -I -c 'import json, sys
export = json.load(open(sys.argv[1]))
json.dump(export["test_cases"], open(sys.argv[2], "w"))
print(export["slug"])' "$work/export.json" "$work/cases.json")
  cases_file=$work/cases.json
fi

echo "== judging $slug on this machine"
exec python3 -I "$root/scripts/judge-local.py" "$root" "$cases_file" "$slug" --languages "$languages"
