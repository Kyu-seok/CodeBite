#!/usr/bin/env bash
# Prints a problem as it stands: English and Korean title, description and
# constraints, then the sample Test Cases, read from the local database.
#
#   scripts/problem-text.sh <slug>         # a Former Slug works too
#   scripts/problem-text.sh <slug> --all   # every Test Case, hidden ones too, by order_index
#   CODEBITE_DB=<database> scripts/problem-text.sh <slug>   # a database other than codebite,
#                                          # such as the one dev-branch-servers.sh prints
#
# Reading migrations instead means finding the newest one that sets each
# column; the oldest grep match is usually stale. The database is only as new
# as the last backend start, so the script warns when this checkout has
# migrations the database hasn't run. For a query across problems, scripts/db-sql.sh.
set -euo pipefail

usage() { echo "usage: scripts/problem-text.sh <slug> [--all]" >&2; exit 2; }
[[ $# -ge 1 && $# -le 2 && "$1" != -* ]] || usage
slug=$1
all=false
if [[ $# -eq 2 ]]; then
  [[ "$2" == --all ]] || usage
  all=true
fi
here=$(cd "$(dirname "$0")/.." && pwd)

# shellcheck source=SCRIPTDIR/dev-servers-common.sh
source "$here/scripts/dev-servers-common.sh"
database=${CODEBITE_DB:-codebite}
warn_if_behind "$database" "$here" problem-text.sh || exit 1
psql() { db_psql "$database" "$@"; }

out=$(psql -tA -v slug="$slug" -v all="$all" <<'SQL'
WITH p AS (
  SELECT * FROM problems
  WHERE slug = :'slug'
     OR id IN (SELECT problem_id FROM problem_former_slugs WHERE slug = :'slug')
)
SELECT format(E'# %s (%s, id %s)\n\n## en: %s\n\n%s\n\n### Constraints\n\n%s\n\n## ko: %s\n\n%s\n\n### Constraints\n\n%s\n\n## %s',
              p.slug, p.difficulty, p.id, p.title, p.description, coalesce(p.constraints, '(none)'),
              coalesce(t.title, '(no translation)'), coalesce(t.description, ''), coalesce(t.constraints, '(none)'),
              CASE WHEN :'all' THEN 'Test Cases (order_index, sample or hidden)' ELSE 'Sample Test Cases' END)
FROM p LEFT JOIN problem_translations t ON t.problem_id = p.id AND t.locale = 'ko'
UNION ALL
(SELECT format(E'\n%s.%s input: %s\n   expected: %s', tc.order_index,
               CASE WHEN :'all' THEN CASE WHEN tc.is_sample THEN ' [sample]' ELSE ' [hidden]' END ELSE '' END,
               tc.input, tc.expected_output)
 FROM test_cases tc JOIN p ON tc.problem_id = p.id
 WHERE tc.is_sample OR :'all' ORDER BY tc.order_index, tc.is_sample DESC, tc.id);
SQL
)
if [[ -z "$out" ]]; then
  echo "problem-text.sh: no problem with slug or Former Slug '$slug'" >&2
  exit 1
fi
printf '%s\n' "$out"
