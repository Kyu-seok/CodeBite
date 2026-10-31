# shellcheck shell=bash
# Helpers scripts/dev-status.sh and scripts/dev-branch-servers.sh share. Sourcing it runs nothing.

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

# The newest numbered migration database $1 has run; empty when it can't be read.
flyway_version() {
  docker exec codebite-postgres psql -U codebite -d "$1" -tAc \
    "SELECT max(version::int) FROM flyway_schema_history WHERE success AND version ~ '^[0-9]+$'" \
    2>/dev/null || true
}
