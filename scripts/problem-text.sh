#!/usr/bin/env bash
# Prints a problem as it stands: English and Korean title, description and
# constraints, then the sample Test Cases, read from the local database.
#
#   scripts/problem-text.sh <slug>     # a Former Slug works too
#
# Reading migrations instead means finding the newest one that sets each
# column; the oldest grep match is usually stale. The database is only as new
# as the last backend start, so the script warns when this checkout has
# migrations the database hasn't run.
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "usage: scripts/problem-text.sh <slug>" >&2
  exit 2
fi
slug=$1
here=$(cd "$(dirname "$0")/.." && pwd)

psql() { docker exec -i codebite-postgres psql -U codebite -d codebite -X -q -v ON_ERROR_STOP=1 "$@"; }

if ! db=$(psql -tAc "SELECT max(version::int) FROM flyway_schema_history WHERE success AND version ~ '^[0-9]+\$'" 2>/dev/null); then
  echo "problem-text.sh: database not reachable (docker container codebite-postgres)" >&2
  exit 1
fi
ours=$(find "$here/common/src/main/resources/db/migration" "$here/common/src/main/java/db/migration" \
  -name 'V*__*' | sed -E 's|.*/V([0-9]+)__.*|\1|' | sort -n | tail -n 1)
if (( db < ours )); then
  echo "WARNING: database at V$db, this checkout's migrations reach V$ours; start the backend to apply them" >&2
fi

out=$(psql -tA -v slug="$slug" <<'SQL'
WITH p AS (
  SELECT * FROM problems
  WHERE slug = :'slug'
     OR id IN (SELECT problem_id FROM problem_former_slugs WHERE slug = :'slug')
)
SELECT format(E'# %s (%s, id %s)\n\n## en: %s\n\n%s\n\n### Constraints\n\n%s\n\n## ko: %s\n\n%s\n\n### Constraints\n\n%s\n\n## Sample Test Cases',
              p.slug, p.difficulty, p.id, p.title, p.description, coalesce(p.constraints, '(none)'),
              coalesce(t.title, '(no translation)'), coalesce(t.description, ''), coalesce(t.constraints, '(none)'))
FROM p LEFT JOIN problem_translations t ON t.problem_id = p.id AND t.locale = 'ko'
UNION ALL
(SELECT format(E'\n%s. input: %s\n   expected: %s', tc.order_index, tc.input, tc.expected_output)
 FROM test_cases tc JOIN p ON tc.problem_id = p.id
 WHERE tc.is_sample ORDER BY tc.order_index);
SQL
)
if [[ -z "$out" ]]; then
  echo "problem-text.sh: no problem with slug or Former Slug '$slug'" >&2
  exit 1
fi
printf '%s\n' "$out"
