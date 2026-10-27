#!/usr/bin/env bash
# Runs the Python 3.12 replay on this machine: exports every problem's test cases from the local
# Postgres (infra/docker-compose.yml) and judges this checkout's scripts/replay-solutions on a local
# Python 3.12 instead of Judge0. Safe to run from several worktrees at once: each run makes its own
# export and touches no shared state. See docs/PYTHON_312_PLAN.md, step 4.
#
#   scripts/replay-local.sh slug,slug,...    # just those problems
#   scripts/replay-local.sh                  # every problem
#
# Exits 1 unless every problem replayed was Accepted. CODEBITE_PYTHON312 names the interpreter
# when python3.12 isn't on PATH. Extra arguments after the slugs go to the replay (e.g. --time-limit 10).
set -euo pipefail
root="$(cd "$(dirname "$0")/.." && pwd)"

python="${CODEBITE_PYTHON312:-$(command -v python3.12 || echo /opt/homebrew/bin/python3.12)}"
container=codebite-postgres
psql() { docker exec -i "$container" psql -U codebite -d codebite -tA "$@"; }

# A database behind the checkout's migrations judges against stale slugs and test cases.
newest=$(ls "$root/common/src/main/resources/db/migration" | sed -nE 's/^V([0-9]+)__.*/\1/p' | sort -n | tail -1)
applied=$(psql -c "select max(version::int) from flyway_schema_history where success")
if (( applied < newest )); then
  echo "replay-local: the local database is at V$applied but this checkout has V$newest;" >&2
  echo "  migrate it first (docs/PYTHON_312_PLAN.md, step 4). Judging against V$applied anyway." >&2
fi

export_file="$(mktemp "${TMPDIR:-/tmp}/replay-local.XXXXXX")"
trap 'rm -f "$export_file"' EXIT
psql < "$root/scripts/replay-judge0-python.sql" > "$export_file"

only=()
if [[ $# -gt 0 && "$1" != -* ]]; then only=(--only "$1"); shift; fi
python3 -I "$root/scripts/replay-judge0-python.py" "$python" 100 "$root" "$export_file" --pause 0 \
  ${only[@]+"${only[@]}"} "$@"
