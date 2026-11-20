# shellcheck shell=bash
# Helpers scripts/dev-status.sh, scripts/dev-branch-servers.sh, scripts/problem-text.sh,
# scripts/db-sql.sh and scripts/judge-local.sh share. Sourcing it runs nothing.

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

# Why no database in the codebite-postgres container can be reached, as what to start; empty when
# the container runs. One docker inspect then, and a docker info only to tell a daemon that doesn't
# answer from a container that is stopped or was never created. Reads nothing from stdin, which may
# hold the caller's query.
db_down_reason() {
  local running
  running=$(docker inspect -f '{{.State.Running}}' codebite-postgres 2>/dev/null </dev/null) || true
  if [[ "$running" == true ]]; then
    return 0
  elif docker info >/dev/null 2>&1 </dev/null; then
    echo "the codebite-postgres container isn't running; start it: docker compose -f infra/docker-compose.yml up -d postgres"
  else
    echo "the Docker daemon doesn't answer; start Docker Desktop (open -a Docker) and rerun"
  fi
}

# psql on the local database $1 (the codebite-postgres container), the rest of the arguments
# psql's own; stdin goes through, so a query can arrive as a heredoc. Stops at the first error.
# Runs nothing and returns 2, saying on stderr what to start, when Docker or the container is down.
db_psql() {
  local database=$1 down
  shift
  down=$(db_down_reason)
  if [[ -n "$down" ]]; then
    echo "$(basename "$0"): database $database not reachable: $down" >&2
    return 2
  fi
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

# What follows a database's name when it can't be read: what to start when Docker or the container
# is down (db_down_reason), and otherwise that the container runs: the database is missing or empty, or
# Postgres in a container just started doesn't answer yet.
db_unreachable_message() {
  local down
  down=$(db_down_reason)
  if [[ -n "$down" ]]; then
    echo "not reachable: $down"
  else
    echo "not readable though the codebite-postgres container runs: no such database, no migration has run in it, or Postgres is still starting (rerun in a few seconds)"
  fi
}

# For a script reading database $1 from checkout $2: the database is only as new as the last
# backend start or migrate, so a database missing migrations this checkout has (BEHIND) would show problems as
# they were, not as they are. This refuses one on stderr, naming both versions, and returns 1; with
# CODEBITE_ALLOW_STALE=1 it only warns. A checkout with no migrations at all has nothing to be
# behind. Returns 2, with db_unreachable_message prefixed by $3 (the script's name), when the
# database can't be read: 1 is the refusal above, and a failing case in scripts/judge-local.sh.
require_current_db() {
  local database=$1 here=$2 script=$3 db ours
  db=$(flyway_version "$database")
  if [[ -z "$db" ]]; then
    echo "$script: database $database $(db_unreachable_message)" >&2
    return 2
  fi
  ours=$(newest_migration "$here")
  if [[ -n "$ours" ]] && (( db < ours )); then
    if [[ "${CODEBITE_ALLOW_STALE:-}" == 1 ]]; then
      echo "WARNING: database $database at V$db, this checkout's migrations reach V$ours; reading it anyway (CODEBITE_ALLOW_STALE=1)" >&2
    else
      echo "$script: database $database at V$db, this checkout's migrations reach V$ours, so it may show problems as they were; run scripts/dev-branch-servers.sh migrate (seconds, no servers) and rerun with CODEBITE_DB=<the database it prints>, or set CODEBITE_ALLOW_STALE=1 to read it anyway" >&2
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
