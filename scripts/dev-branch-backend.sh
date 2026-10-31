#!/usr/bin/env bash
# Runs this checkout's backend, worker and Vite beside the shared dev servers (8080, 8081, 5173),
# so a branch's migrations, endpoints and problems can be seen working end to end:
#
#   scripts/dev-branch-backend.sh [start]   start all three and stay in the foreground; Ctrl-C stops them
#   scripts/dev-branch-backend.sh stop      stop them from another shell
#   scripts/dev-branch-backend.sh status    print where they run (ports, database, logs)
#   scripts/dev-branch-backend.sh drop      drop the branch database, Kafka topics and groups, Redis index
#   scripts/dev-branch-backend.sh name      print the branch database name
#
# Each piece is kept off the user's servers and data:
#   database  codebite_<branch> in the codebite-postgres container, migrated by the backend on start
#   Kafka     topics and consumer groups prefixed with that name (app.kafka.topic.*, app.kafka.group-prefix),
#             so neither side takes a share of the other's submissions or results
#   Redis     its own database index: a fresh database's user ids collide with the shared one's
#   ports     free ones from 18080 (backend), 18180 (worker), 15180 (Vite)
#   browser   Vite on 127.0.0.1, whose localStorage is apart from the user's localhost sessions
# Sign in with the dev test token (see the printed summary); OAuth redirects to the shared frontend.
set -euo pipefail

# Ports the shared servers and infra use: never picked, even when free.
RESERVED_PORTS=(8080 8081 5173 5174 3000 2358 3001 3100 5433 6379 9090 9092)

# The branch database name: codebite_ plus the branch, lowercased, with every run of other
# characters turned into one underscore, at most 63 characters (PostgreSQL's limit).
branch_db_name() {
  local s
  s=$(printf '%s' "$1" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/_/g; s/^_+//; s/_+$//')
  [[ -z "$s" ]] && s=detached
  s="codebite_$s"
  s=${s:0:63}
  printf '%s\n' "${s%_}"
}

# Redis database index 1-15 for a name (0 is the shared backend's).
redis_index() {
  local sum
  sum=$(printf '%s' "$1" | cksum | cut -d' ' -f1)
  echo $(( sum % 15 + 1 ))
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

# ---------------------------------------------------------------------------------------------

psql_admin() {
  docker exec codebite-postgres psql -v ON_ERROR_STOP=1 -U codebite -d postgres -tAc "$1"
}

kafka_bin() {
  local tool=$1
  shift
  docker exec codebite-kafka "/opt/kafka/bin/$tool" --bootstrap-server localhost:9092 "$@"
}

setup() {
  root=$(git rev-parse --show-toplevel)
  local branch
  branch=$(git -C "$root" branch --show-current)
  db=$(branch_db_name "${branch:-$(basename "$root")}")
  prefix="$db-"
  redis_db=$(redis_index "$db")
  state="${TMPDIR:-/tmp}"
  state="${state%/}/codebite-dev-branch/$db"
}

# Pids of this checkout's backend and worker apps (the JVMs bootRun forks) and its Vite.
app_pids() {
  pgrep -f "$root/backend/build/classes/java/main" || true
  pgrep -f "$root/worker/build/classes/java/main" || true
  pgrep -f "$root/frontend/node_modules/.bin/vite" || true
}

summary() {
  # shellcheck disable=SC1091  # written by cmd_start
  source "$state/ports"
  cat <<EOF

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

Stop: Ctrl-C here, or scripts/dev-branch-backend.sh stop.  Drop the data: scripts/dev-branch-backend.sh drop
EOF
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
  pids=$(app_pids)
  if [[ -n "$pids" ]]; then
    echo "stopping branch servers: $(echo "$pids" | tr '\n' ' ')"
    # shellcheck disable=SC2086
    kill $pids 2>/dev/null || true
    for (( i = 0; i < 30; i++ )); do
      [[ -z "$(app_pids)" ]] && break
      sleep 1
    done
    pids=$(app_pids)
    # shellcheck disable=SC2086
    [[ -n "$pids" ]] && kill -9 $pids 2>/dev/null
  fi
  # The gradlew clients exit once their app does; reap any that are left.
  if [[ -f "$state/pids" ]]; then
    while read -r pid; do
      kill "$pid" 2>/dev/null || true
    done < "$state/pids"
    rm -f "$state/pids"
  fi
  return 0
}

cmd_start() {
  if [[ -n "$(app_pids)" ]]; then
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

  if [[ -z "$(psql_admin "SELECT 1 FROM pg_database WHERE datname = '$db'")" ]]; then
    psql_admin "CREATE DATABASE \"$db\"" >/dev/null
    echo "database $db: created (the backend migrates it on start)"
  else
    echo "database $db: exists"
  fi

  mkdir -p "$state"
  rm -f "$state/stopping"
  : > "$state/pids"
  local backend_port worker_port vite_port
  backend_port=$(first_free_port 18080 18179)
  worker_port=$(first_free_port 18180 18279)
  vite_port=$(first_free_port 15180 15279)
  printf 'backend_port=%s\nworker_port=%s\nvite_port=%s\n' \
    "$backend_port" "$worker_port" "$vite_port" > "$state/ports"

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
  export CODEBITE_DEV_BRANCH="$db"  # how scripts/dev-status.sh tells these from the shared servers
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

  local version
  version=$(docker exec codebite-postgres psql -U codebite -d "$db" -tAc \
    "SELECT max(version::int) FROM flyway_schema_history WHERE success AND version ~ '^[0-9]+$'")
  echo "database $db: at V$version"
  summary

  # Stay up until Ctrl-C, a stop from another shell, or one of the three dying.
  while :; do
    sleep 2
    if [[ -f "$state/stopping" ]]; then
      echo "branch servers stopped"
      trap - EXIT  # the stop that set the flag is already stopping them
      exit 0
    fi
    local alive=0
    pgrep -f "$root/backend/build/classes/java/main" >/dev/null && alive=$((alive + 1))
    pgrep -f "$root/worker/build/classes/java/main" >/dev/null && alive=$((alive + 1))
    pgrep -f "$root/frontend/node_modules/.bin/vite" >/dev/null && alive=$((alive + 1))
    if (( alive < 3 )); then
      echo "a branch server stopped (see the logs in $state); stopping the rest" >&2
      exit 1
    fi
  done
}

cmd_drop() {
  if [[ -n "$(app_pids)" ]]; then
    echo "the branch servers are running; stop them first: scripts/dev-branch-backend.sh stop" >&2
    exit 1
  fi
  psql_admin "DROP DATABASE IF EXISTS \"$db\" WITH (FORCE)" >/dev/null
  echo "database $db: dropped"
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
  docker exec codebite-redis redis-cli -n "$redis_db" FLUSHDB >/dev/null
  echo "Redis database $redis_db: flushed"
  rm -rf "$state"
}

main() {
  setup
  case "${1:-start}" in
    start) cmd_start ;;
    stop) stop_all ;;
    status)
      if [[ -n "$(app_pids)" && -f "$state/ports" ]]; then summary; else echo "not running ($db)"; fi ;;
    drop) cmd_drop ;;
    name) echo "$db" ;;
    *) sed -n '2,8p' "$0" >&2; exit 2 ;;
  esac
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  main "$@"
fi
