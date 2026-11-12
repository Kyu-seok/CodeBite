# shellcheck shell=bash
# Helpers scripts/dev-status.sh, scripts/dev-branch-servers.sh, scripts/problem-text.sh and
# scripts/db-sql.sh share. Sourcing it runs nothing.

# The main checkout, which runs the shared dev servers: the parent of the common .git, the same
# from the main checkout and from every worktree.
main_checkout() {
  dirname "$(git rev-parse --path-format=absolute --git-common-dir)"
}

# What the command line of a local $1 (backend, worker or frontend) holds when it runs from
# checkout $2; from any checkout when $2 is left out. backend and worker match the JVM bootRun
# forks, not the gradlew client.
app_pattern() {
  case "$1" in
    backend | worker) echo "${2:-}/$1/build/classes/java/main" ;;
    frontend) echo "${2:-}/frontend/node_modules/.bin/vite" ;;
    *) echo "app_pattern: unknown app $1" >&2; return 1 ;;
  esac
}

# The value of $2 in the environment process $1 started with; empty when it isn't set or the
# process is gone. ps prints that environment as space-separated NAME=value words, so a value
# holding a space would be cut at it: read only names whose values never do (CODEBITE_DEV_BRANCH
# is a database name, SERVER_PORT a number; the PROD check in dev-status.sh only needs the name).
env_value() {
  { ps eww -o command= -p "$1" 2>/dev/null || true; } | tr ' ' '\n' | sed -n "s/^$2=//p" | head -n 1
}

# psql on the local database $1 (the codebite-postgres container), the rest of the arguments
# psql's own; stdin goes through, so a query can arrive as a heredoc. Stops at the first error.
db_psql() {
  local database=$1
  shift
  docker exec -i codebite-postgres psql -U codebite -d "$database" -X -q -v ON_ERROR_STOP=1 "$@"
}

# The newest numbered migration database $1 has run; empty when it can't be read. Reads nothing
# from stdin, so a query piped to the caller (scripts/db-sql.sh) stays for the caller.
flyway_version() {
  db_psql "$1" -tAc \
    "SELECT max(version::int) FROM flyway_schema_history WHERE success AND version ~ '^[0-9]+$'" \
    </dev/null 2>/dev/null || true
}

# Highest Flyway version among checkout $1's migrations, SQL and Java.
newest_migration() {
  find "$1/common/src/main/resources/db/migration" "$1/common/src/main/java/db/migration" \
    -name 'V*__*' 2>/dev/null | sed -E 's|.*/V([0-9]+)__.*|\1|' | sort -n | tail -n 1
}

# What follows a database's name when it can't be read: the container, and how to start it.
db_unreachable_message() {
  echo "not reachable (docker container codebite-postgres); start it: open -a Docker, then docker compose -f infra/docker-compose.yml up -d postgres"
}

# For a script reading database $1 from checkout $2: the database is only as new as the last
# backend start, so a database missing migrations this checkout has (BEHIND) would show problems as
# they were, not as they are. This refuses one on stderr, naming both versions, and returns 1; with
# CODEBITE_ALLOW_STALE=1 it only warns. A checkout with no migrations at all has nothing to be
# behind. Returns 1, with db_unreachable_message prefixed by $3 (the script's name), when the
# database can't be read.
require_current_db() {
  local database=$1 here=$2 script=$3 db ours
  db=$(flyway_version "$database")
  if [[ -z "$db" ]]; then
    echo "$script: database $database $(db_unreachable_message)" >&2
    return 1
  fi
  ours=$(newest_migration "$here")
  if [[ -n "$ours" ]] && (( db < ours )); then
    if [[ "${CODEBITE_ALLOW_STALE:-}" == 1 ]]; then
      echo "WARNING: database $database at V$db, this checkout's migrations reach V$ours; reading it anyway (CODEBITE_ALLOW_STALE=1)" >&2
    else
      echo "$script: database $database at V$db, this checkout's migrations reach V$ours, so it may show problems as they were; start scripts/dev-branch-servers.sh and rerun with CODEBITE_DB=<the database it prints>, or set CODEBITE_ALLOW_STALE=1 to read it anyway" >&2
      return 1
    fi
  fi
}

# $1, a JUDGE0_URL from the shell, when it is a dev one to pass on (the user's Tailscale name for
# Judge0, say, which the dev profile's LAN default can't stand in for off that network); empty for
# none or production's (infra/.env's http://judge0:..., a compose service name).
dev_judge0_url() {
  case "$1" in
    "" | http://judge0:*) ;;
    *) echo "$1" ;;
  esac
}
