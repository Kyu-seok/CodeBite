#!/usr/bin/env bash
# Runs this checkout's backend, worker and Vite beside the shared dev servers (8080, 8081, 5173),
# so a branch's migrations, endpoints and problems can be seen working end to end:
#
#   scripts/dev-branch-servers.sh [start]   start all three and stay in the foreground; Ctrl-C stops them
#   scripts/dev-branch-servers.sh stop      stop them from another shell
#   scripts/dev-branch-servers.sh status    print where they run (ports, database, logs)
#   scripts/dev-branch-servers.sh drop      drop the branch database, Kafka topics and groups, Redis index
#   scripts/dev-branch-servers.sh name      print the branch database name
#
# It refuses to run from the main checkout (only name and status work there): the servers there
# are the shared ones. Each piece is kept off the user's servers and data, and off other sessions':
#   database  codebite_<branch>_<hash of this worktree's path> in the codebite-postgres container,
#             migrated by the backend on start; its COMMENT names this worktree, and drop refuses a
#             database whose comment names another
#   Kafka     topics and consumer groups prefixed with that name (app.kafka.topic.*, app.kafka.group-prefix),
#             so neither side takes a share of the other's submissions or results
#   Redis     a database index of its own (a fresh database's user ids collide with the shared one's),
#             claimed by an owner key holding the database name; drop flushes only that index, never 0
#   processes only those started with CODEBITE_DEV_BRANCH=<this database> are ever stopped
#   ports     free ones from 18080 (backend), 18180 (worker), 15180 (Vite)
#   browser   Vite on 127.0.0.1, whose localStorage is apart from the user's localhost sessions
# Sign in with the dev test token (see the printed summary); OAuth redirects to the shared frontend.
set -euo pipefail

# shellcheck source=SCRIPTDIR/dev-servers-common.sh
source "$(dirname "${BASH_SOURCE[0]}")/dev-servers-common.sh"

# Ports the shared servers and infra use: never picked, even when free.
RESERVED_PORTS=(8080 8081 5173 5174 3000 2358 3001 3100 5433 6379 9090 9092)

# The key in a Redis database index whose value names the branch database that claimed it.
REDIS_OWNER_KEY=codebite-dev-branch-owner

# The branch database name for branch $1 in the worktree at $2: codebite_, the branch lowercased
# with every run of other characters turned into one underscore (cut to fit), then _ and a hash of
# the worktree's path, so two worktrees never share one even when their branches fold to the same
# text (feat/a-b, feat/a_b) or share a long prefix. At most 63 characters (PostgreSQL's limit).
branch_db_name() {
  local s hash
  s=$(printf '%s' "$1" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/_/g; s/^_+//; s/_+$//')
  [[ -z "$s" ]] && s=detached
  hash=$(printf '%08x' "$(printf '%s' "$2" | cksum | cut -d' ' -f1)")
  s=${s:0:45}  # 63 - "codebite_" - "_" - 8 hex digits
  while [[ "$s" == *_ ]]; do s=${s%_}; done
  printf 'codebite_%s_%s\n' "$s" "$hash"
}

# The COMMENT a branch database carries: the worktree that made it.
db_owner_comment() {
  printf 'codebite-dev-branch:%s' "$1"
}

# $1 quoted as an SQL string literal.
sql_literal() {
  printf "'%s'" "$(printf '%s' "$1" | sed "s/'/''/g")"
}

# What to do with the branch database, given $1 = "x" plus its comment ("" when it doesn't
# exist) and $2 = the comment this worktree's carries: create, ours, or foreign (another
# worktree's, or one not made by this script), which nothing here may touch.
database_verdict() {
  if [[ -z "$1" ]]; then
    echo create
  elif [[ "$1" == "x$2" ]]; then
    echo ours
  else
    echo foreign
  fi
}

port_busy() {
  lsof -nP -iTCP:"$1" -sTCP:LISTEN >/dev/null 2>&1
}

# The first port in [from, to] that is neither reserved nor listened on.
first_free_port() {
  local p r
  for (( p = $1; p <= $2; p++ )); do
    for r in "${RESERVED_PORTS[@]}"; do
      [[ $p -eq $r ]] && continue 2
    done
    port_busy "$p" || { echo "$p"; return 0; }
  done
  echo "no free port in $1-$2" >&2
  return 1
}

# Pids of this checkout's apps $@ (backend, worker, frontend; all three when none is named) that
# were started with CODEBITE_DEV_BRANCH=$db, as cmd_start starts them. Nothing else is ever
# stopped: not the shared servers, not another worktree's branch servers.
branch_pids() {
  local app pid
  (( $# )) || set -- backend worker frontend
  for app in "$@"; do
    for pid in $(pgrep -f "$(app_pattern "$app" "$root")" || true); do
      if is_ours "$pid"; then echo "$pid"; fi
    done
  done
}

# Whether process $1 was started by this checkout's cmd_start.
is_ours() {
  [[ -n "$db" && "$(env_value "$1" CODEBITE_DEV_BRANCH)" == "$db" ]]
}

redis_cmd() {
  local index=$1
  shift
  docker exec codebite-redis redis-cli -n "$index" "$@"
}

# The Redis database index (1-15; 0 is the shared backend's) whose owner key names $db; empty
# when none does.
owned_redis_index() {
  local i
  for (( i = 1; i <= 15; i++ )); do
    if [[ "$(redis_cmd "$i" GET "$REDIS_OWNER_KEY")" == "$db" ]]; then
      echo "$i"
      return 0
    fi
  done
}

# The index $db owns, or else the first empty one without an owner, claimed with SET NX so two
# sessions starting at once can't both take it. An index holding keys but no owner is skipped:
# something else uses it.
claim_redis_index() {
  local i
  i=$(owned_redis_index)
  if [[ -n "$i" ]]; then
    echo "$i"
    return 0
  fi
  for (( i = 1; i <= 15; i++ )); do
    [[ "$(redis_cmd "$i" DBSIZE)" == 0 ]] || continue
    if [[ "$(redis_cmd "$i" SET "$REDIS_OWNER_KEY" "$db" NX)" == OK ]]; then
      echo "$i"
      return 0
    fi
  done
  echo "no free Redis database in 1-15 (each has keys or another branch's owner key)" >&2
  return 1
}

# Flushes the index $db owns, which also gives up the claim; no other index is touched.
flush_owned_redis_index() {
  local i
  i=$(owned_redis_index)
  if [[ -z "$i" ]]; then
    echo "Redis: no database owned by $db"
    return 0
  fi
  redis_cmd "$i" FLUSHDB >/dev/null
  echo "Redis database $i: flushed"
}

# ---------------------------------------------------------------------------------------------

psql_admin() {
  docker exec codebite-postgres psql -v ON_ERROR_STOP=1 -U codebite -d postgres -tAc "$1"
}

# "x" plus the branch database's comment, or nothing when it doesn't exist (see database_verdict).
database_state() {
  psql_admin "SELECT 'x' || coalesce(shobj_description(oid, 'pg_database'), '') FROM pg_database WHERE datname = '$db'"
}

kafka_bin() {
  local tool=$1
  shift
  docker exec codebite-kafka "/opt/kafka/bin/$tool" --bootstrap-server localhost:9092 "$@"
}

# Sets the globals the subcommands read: root (this checkout), main (the main checkout), db (the
# branch database), prefix (its Kafka topic and group prefix) and state (the ports, pids and logs).
setup() {
  root=$(git rev-parse --show-toplevel)
  main=$(main_checkout)
  local branch
  branch=$(git -C "$root" branch --show-current)
  db=$(branch_db_name "${branch:-$(basename "$root")}" "$root")
  prefix="$db-"
  state="${TMPDIR:-/tmp}"
  state="${state%/}/codebite-dev-branch/$db"
}

summary() {
  # shellcheck disable=SC1091  # written by cmd_start
  source "$state/ports"
  cat <<EOS

Branch servers for $(git -C "$root" branch --show-current 2>/dev/null || echo "$root"):
  frontend  http://127.0.0.1:$vite_port          (open this, not localhost: separate sign-in)
  backend   http://127.0.0.1:$backend_port/api
  worker    http://127.0.0.1:$worker_port/actuator/health
  database  $db  (psql: docker exec -it codebite-postgres psql -U codebite -d $db)
  Kafka     topics and groups prefixed $prefix, Redis database $redis_db
  logs      $state/backend.log
            $state/worker.log
            $state/vite.log

Sign in (dev test token; role ADMIN, or USER):
  curl -s -X POST 'http://127.0.0.1:$backend_port/api/auth/test-token?username=<name>&role=ADMIN'
  then in the branch frontend's console: localStorage.setItem('token', '<token>') and reload

Stop: Ctrl-C here, or scripts/dev-branch-servers.sh stop.  Drop the data: scripts/dev-branch-servers.sh drop
EOS
}

# Waits until $2 answers or the process $1 dies; on death prints the log's tail.
wait_for() {
  local pid=$1 url=$2 log=$3 what=$4 i
  for (( i = 0; i < 600; i++ )); do
    if curl -fsS -o /dev/null "$url" 2>/dev/null; then
      echo "$what: up"
      return 0
    fi
    if ! kill -0 "$pid" 2>/dev/null; then
      echo "$what: exited before it came up; the end of $log:" >&2
      tail -n 40 "$log" >&2
      return 1
    fi
    sleep 1
  done
  echo "$what: not up after 10 minutes (see $log)" >&2
  return 1
}

stop_all() {
  local pids pid i
  # Tells a foreground start in another shell that this stop is deliberate.
  [[ -d "$state" ]] && touch "$state/stopping"
  pids=$(branch_pids)
  if [[ -n "$pids" ]]; then
    echo "stopping branch servers: $(echo "$pids" | tr '\n' ' ')"
    # shellcheck disable=SC2086
    kill $pids 2>/dev/null || true
    for (( i = 0; i < 30; i++ )); do
      [[ -z "$(branch_pids)" ]] && break
      sleep 1
    done
    pids=$(branch_pids)
    # shellcheck disable=SC2086
    [[ -n "$pids" ]] && kill -9 $pids 2>/dev/null
  fi
  # The gradlew clients exit once their app does; reap any that are left, checking each pid is
  # still one of ours (a pid can be reused once its process is gone).
  if [[ -f "$state/pids" ]]; then
    while read -r pid; do
      if is_ours "$pid"; then kill "$pid" 2>/dev/null || true; fi
    done < "$state/pids"
    rm -f "$state/pids"
  fi
  return 0
}

cmd_start() {
  if [[ -n "$(branch_pids)" ]]; then
    echo "already running for this checkout:" >&2
    [[ -f "$state/ports" ]] && summary >&2
    exit 1
  fi
  docker exec codebite-postgres pg_isready -q -U codebite \
    || { echo "codebite-postgres is not running: docker compose -f infra/docker-compose.yml up -d" >&2; exit 1; }
  if ! docker exec codebite-kafka true || ! docker exec codebite-redis true; then
    echo "codebite-kafka or codebite-redis is not running" >&2
    exit 1
  fi

  local comment
  comment=$(db_owner_comment "$root")
  case "$(database_verdict "$(database_state)" "$comment")" in
    create)
      psql_admin "CREATE DATABASE \"$db\"" >/dev/null
      psql_admin "COMMENT ON DATABASE \"$db\" IS $(sql_literal "$comment")" >/dev/null
      echo "database $db: created (the backend migrates it on start)" ;;
    ours) echo "database $db: exists" ;;
    *)
      echo "database $db exists but isn't this worktree's (its comment isn't '$comment'); not using it" >&2
      exit 1 ;;
  esac

  local redis_db
  redis_db=$(claim_redis_index)

  mkdir -p "$state"
  rm -f "$state/stopping"
  : > "$state/pids"
  local backend_port worker_port vite_port
  backend_port=$(first_free_port 18080 18179)
  worker_port=$(first_free_port 18180 18279)
  vite_port=$(first_free_port 15180 15279)
  printf 'backend_port=%s\nworker_port=%s\nvite_port=%s\nredis_db=%s\n' \
    "$backend_port" "$worker_port" "$vite_port" "$redis_db" > "$state/ports"

  if [[ ! -d "$root/frontend/node_modules" ]]; then
    echo "frontend: npm ci (a worktree has no node_modules)"
    (cd "$root/frontend" && npm ci --silent)
  fi

  local vite_origin="http://127.0.0.1:$vite_port"
  local json
  json=$(cat <<JSON
{"app":{"kafka":{"group-prefix":"$prefix","topic":{
  "submission":"${prefix}submission-events",
  "submission-admin":"${prefix}submission-events-admin",
  "submission-results":"${prefix}submission-results",
  "github-import":"${prefix}github-imports"}},
 "cors":{"allowed-origins":"$vite_origin"}}}
JSON
)

  trap 'echo; stop_all; exit 0' INT TERM
  trap 'stop_all' EXIT

  cd "$root"
  # Values a shell may carry from the production infra/.env (see scripts/dev-env.sh), and the
  # shared servers' own settings, must not reach the branch servers.
  unset CORS_ALLOWED_ORIGINS JWT_SECRET DB_USER DB_PASSWORD DB_URL JUDGE0_URL KAFKA_ENABLED \
    SPRING_PROFILES_ACTIVE SPRING_DATASOURCE_URL SERVER_PORT SPRING_APPLICATION_JSON
  # shellcheck source=SCRIPTDIR/dev-env.sh
  source scripts/dev-env.sh
  # Marks every process started below as this checkout's: branch_pids stops only those, and
  # scripts/dev-status.sh tells them from the shared servers by it.
  export CODEBITE_DEV_BRANCH="$db"
  export SPRING_DATASOURCE_URL="jdbc:postgresql://localhost:5433/$db"
  export SPRING_DATA_REDIS_DATABASE="$redis_db"
  export SPRING_APPLICATION_JSON="$json"

  echo "backend: starting on $backend_port (log $state/backend.log)"
  SPRING_PROFILES_ACTIVE=dev SERVER_PORT=$backend_port ./gradlew :backend:bootRun > "$state/backend.log" 2>&1 &
  echo $! >> "$state/pids"
  wait_for $! "http://127.0.0.1:$backend_port/api/health" "$state/backend.log" backend || exit 1

  # After the backend: it creates the topics, and the two Gradle builds don't contend for common.
  echo "worker: starting on $worker_port (log $state/worker.log)"
  SERVER_PORT=$worker_port ./gradlew :worker:bootRun > "$state/worker.log" 2>&1 &
  echo $! >> "$state/pids"
  wait_for $! "http://127.0.0.1:$worker_port/actuator/health" "$state/worker.log" worker || exit 1

  echo "frontend: starting on $vite_port (log $state/vite.log)"
  (cd frontend && VITE_API_URL="http://127.0.0.1:$backend_port/api" \
    exec "$root/frontend/node_modules/.bin/vite" --host 127.0.0.1 --port "$vite_port" --strictPort) \
    > "$state/vite.log" 2>&1 &
  echo $! >> "$state/pids"
  wait_for $! "$vite_origin" "$state/vite.log" frontend || exit 1

  echo "database $db: at V$(flyway_version "$db")"
  summary

  # Stay up until Ctrl-C, a stop from another shell, or one of the three dying.
  local app
  while :; do
    sleep 2
    if [[ -f "$state/stopping" ]]; then
      echo "branch servers stopped"
      trap - EXIT  # the stop that set the flag is already stopping them
      exit 0
    fi
    for app in backend worker frontend; do
      if [[ -z "$(branch_pids "$app")" ]]; then
        echo "the branch $app stopped (see the logs in $state); stopping the rest" >&2
        exit 1
      fi
    done
  done
}

cmd_drop() {
  if [[ -n "$(branch_pids)" ]]; then
    echo "the branch servers are running; stop them first: scripts/dev-branch-servers.sh stop" >&2
    exit 1
  fi
  local comment
  comment=$(db_owner_comment "$root")
  case "$(database_verdict "$(database_state)" "$comment")" in
    create) echo "database $db: none" ;;
    ours)
      psql_admin "DROP DATABASE IF EXISTS \"$db\" WITH (FORCE)" >/dev/null
      echo "database $db: dropped" ;;
    *)
      echo "database $db isn't this worktree's (its comment isn't '$comment'); dropping nothing" >&2
      exit 1 ;;
  esac
  local topics groups g
  topics=$(kafka_bin kafka-topics.sh --list | grep "^$prefix" || true)
  if [[ -n "$topics" ]]; then
    kafka_bin kafka-topics.sh --delete --topic "$(echo "$topics" | paste -sd, -)" >/dev/null
    echo "Kafka topics: deleted $(echo "$topics" | paste -sd' ' -)"
  fi
  groups=$(kafka_bin kafka-consumer-groups.sh --list 2>/dev/null | grep "^$prefix" || true)
  for g in $groups; do
    kafka_bin kafka-consumer-groups.sh --delete --group "$g" >/dev/null 2>&1 || true
  done
  [[ -n "$groups" ]] && echo "Kafka groups: deleted $(echo "$groups" | paste -sd' ' -)"
  flush_owned_redis_index
  rm -rf "$state"
}

usage() {
  sed -n 's/^#   \(scripts\/dev-branch-servers\.sh .*\)/  \1/p' "$0" >&2
}

main() {
  local cmd=${1:-start}
  case "$cmd" in
    start | stop | status | drop | name) ;;
    *) usage; exit 2 ;;
  esac
  setup
  if [[ "$cmd" != name && "$cmd" != status && "$root" == "$main" ]]; then
    echo "dev-branch-servers.sh: $root is the main checkout, whose servers are the shared ones;" \
      "run it from a worktree (only name and status work here)" >&2
    exit 1
  fi
  case "$cmd" in
    start) cmd_start ;;
    stop) stop_all ;;
    status)
      if [[ -n "$(branch_pids)" && -f "$state/ports" ]]; then summary; else echo "not running ($db)"; fi ;;
    drop) cmd_drop ;;
    name) echo "$db" ;;
  esac
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  main "$@"
fi
