#!/usr/bin/env bash
# Runs one SQL query against the local database and prints the rows, unaligned and
# tab-separated (psql -tA), for a read across problems that scripts/problem-text.sh,
# one slug at a time, doesn't cover: the largest Test Case of several problems, every
# description mentioning a word, both languages' constraints.
#
#   scripts/db-sql.sh "select slug, difficulty from problems order by slug"
#   scripts/db-sql.sh <<'SQL'          # the query on stdin when there is no argument
#   select ...
#   SQL
#   CODEBITE_DB=<database> scripts/db-sql.sh "<sql>"   # a database other than codebite,
#                                      # such as the one dev-branch-servers.sh prints
#
# Reads only: the session is read-only, so a write fails; a change to a problem goes in
# a migration. The database is only as new as the last backend start, so the script
# warns (BEHIND) when this checkout has migrations the database hasn't run. A query
# error exits non-zero with psql's message.
set -euo pipefail

usage() { echo 'usage: scripts/db-sql.sh "<sql>"   or   scripts/db-sql.sh < query.sql' >&2; exit 2; }
[[ $# -le 1 ]] || usage
[[ $# -eq 1 || ! -t 0 ]] || usage
here=$(cd "$(dirname "$0")/.." && pwd)
# shellcheck source=SCRIPTDIR/dev-servers-common.sh
source "$here/scripts/dev-servers-common.sh"

database=${CODEBITE_DB:-codebite}
warn_if_behind "$database" "$here" db-sql.sh || exit 1

{
  echo 'SET default_transaction_read_only = on;'
  if [[ $# -eq 1 ]]; then printf '%s\n' "$1"; else cat; fi
} | db_psql "$database" -tA -F $'\t'
