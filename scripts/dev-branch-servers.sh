#!/usr/bin/env bash
# Runs this checkout's backend, worker and Vite beside the shared dev servers (8080, 8081, 5173),
# so a branch's migrations, endpoints and problems can be seen working end to end:
#
#   scripts/dev-branch-servers.sh [start [--detach]]  start all three and stay in the foreground, Ctrl-C
#                                           stopping them; --detach returns once they are up, with the
#                                           summary, and leaves them running (log: <state>/start.log)
#   scripts/dev-branch-servers.sh restart   stop, then start detached: the backend migrates the branch
#                                           database to the migrations written since the last start
#   scripts/dev-branch-servers.sh stop      stop them from another shell
#   scripts/dev-branch-servers.sh status    print where they run (ports, database, logs); exits 1, saying
#                                           why, until each port is this checkout's app listening
#   scripts/dev-branch-servers.sh migrate   create the branch database if missing and run this checkout's
#                                           migrations on it, starting no server: for reading a problem
#                                           (CODEBITE_DB=<it> scripts/problem-text.sh) as the branch has it
#   scripts/dev-branch-servers.sh drop      drop the branch database, Kafka topics and groups, Redis index
#                                           (a Kafka or Redis container that isn't running: says what is left behind
#                                           and the command that drops it later, skips it)
#   scripts/dev-branch-servers.sh orphans   list the branch databases whose worktree is gone, and the dropped ones
#                                           whose Kafka topics and groups or Redis index a skipped drop left behind
#   scripts/dev-branch-servers.sh orphans --count  only how many databases orphans lists, as a number (dev-status reads it)
#   scripts/dev-branch-servers.sh drop [<name>]  with a name, drop one of those, from any checkout
#   scripts/dev-branch-servers.sh name      print the branch database name
#
# It refuses to run from the main checkout (only name, status, orphans and drop <name> work there): the servers there
# are the shared ones. Each piece is kept off the user's servers and data, and off other sessions':
#   database  codebite_<branch>_<hash of this worktree's path> in the codebite-postgres container,
#             migrated by the backend on start (or by migrate, with no server); its COMMENT names this worktree, and drop refuses a
#             database whose comment names another
#   Kafka     topics and consumer groups prefixed with that name and a dash (app.kafka.topic.*,
#             app.kafka.group-prefix), so neither side takes a share of the other's submissions or
#             results; the shared servers' own names never start with a branch database name (kafka_owner)
#   Redis     a database index of its own (a fresh database's user ids collide with the shared one's),
#             claimed by an owner key holding the database name; drop flushes only that index, never 0
#   processes only those started with CODEBITE_DEV_BRANCH=<this database> are ever stopped
#   ports     free ones from 18080 (backend), 18180 (worker), 15180 (Vite), each claimed under a lock
#             so starts in two worktrees at once never take one port; start and status check that
#             each port's listener is this checkout's process
#   browser   Vite on 127.0.0.1, whose localStorage is apart from the user's localhost sessions
#   Judge0    the shell's JUDGE0_URL when it is a dev one (a Tailscale name), else the dev profile's
#             LAN default; never production's http://judge0:...
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

# The branch database of the checkout at $1 (its top level): named for its branch, or for its
# directory when detached.
checkout_database() {
  local branch
  branch=$(git -C "$1" branch --show-current)
  branch_db_name "${branch:-$(basename "$1")}" "$1"
}

# Whether $1 has the shape branch_db_name gives: codebite_, runs of a-z0-9 joined by single
# underscores, _ and 8 hex digits, at most 63 characters. The letters are spelled out, since a
# range like a-z can take in other characters in some locales.
is_branch_db_name() {
  local w=abcdefghijklmnopqrstuvwxyz0123456789
  local pattern="^codebite_[$w]+(_[$w]+)*_[0123456789abcdef]{8}\$"
  [[ ${#1} -le 63 && "$1" =~ $pattern ]]
}

# The branch database whose Kafka topic or consumer group $1 is (start names each <database>-<name>,
# and a database name has no dash); empty for any other name. The shared servers' own have no
# branch database name before their first dash: submission-events, codebite-worker.
kafka_owner() {
  local db=${1%%-*}
  if [[ "$1" == "$db"-?* ]] && is_branch_db_name "$db"; then echo "$db"; fi
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

# A port is checked free here but bound only when its server comes up, minutes later, so two
# starts at once could both take it. Each port handed out is claimed first: a file in $port_locks
# named for the port, holding the database and the pid of the start that claimed it, written
# under a mutex. A claim holds until that start's stop releases it or its pid is gone.

# Runs $@ holding the port mutex: a symlink naming the holding start's pid (ln -s is atomic, and a
# start that dies leaves its pid behind). A mutex whose pid is gone is broken, never one whose
# start still runs, however long it holds it; and only under a second such link, the breaker, so
# two waiters that both find it dead don't both break it (the second would break the first's new
# mutex). A start killed while breaking leaves the breaker behind, and waiters give up after two
# minutes, naming both links.
with_port_mutex() {
  local m="$port_locks/.mutex-pid" i rc=0 holder  # not .mutex, the directory an earlier version made
  mkdir -p "$port_locks"
  for (( i = 0; ; i++ )); do
    ln -s "$$" "$m" 2>/dev/null && break
    holder=$(readlink "$m" 2>/dev/null) || continue  # released meanwhile: try again at once
    if ! kill -0 "$holder" 2>/dev/null && ln -s "$$" "$m.break" 2>/dev/null; then
      # Under the breaker nobody else removes the mutex, so the dead pid read now is still its.
      holder=$(readlink "$m" 2>/dev/null) && ! kill -0 "$holder" 2>/dev/null && rm -f "$m"
      rm -f "$m.break"
      continue
    fi
    if (( i >= 1200 )); then
      echo "the port mutex $m (pid $holder) has been held for two minutes; if no start is picking ports," \
        "remove it and $m.break" >&2
      return 1
    fi
    sleep 0.1
  done
  "$@" || rc=$?
  rm -f "$m"
  return "$rc"
}

# Whether port $1 is claimed by another database's start that is still running.
port_held() {
  local f="$port_locks/$1" owner="" pid=""
  [[ -f "$f" ]] || return 1
  read -r owner pid < "$f" || true
  [[ "$owner" != "$db" && -n "$pid" ]] && kill -0 "$pid" 2>/dev/null
}

# Claims and prints the first port in [from, to] that is neither reserved, listened on nor held
# by another start. Run under with_port_mutex.
claim_port() {
  local p r
  for (( p = $1; p <= $2; p++ )); do
    for r in "${RESERVED_PORTS[@]}"; do
      [[ $p -eq $r ]] && continue 2
    done
    port_busy "$p" && continue
    port_held "$p" && continue
    mkdir -p "$port_locks"
    printf '%s %s\n' "$db" "$$" > "$port_locks/$p"
    echo "$p"
    return 0
  done
  echo "no free port in $1-$2" >&2
  return 1
}

# Drops every claim $db holds.
release_ports() {
  local f owner
  [[ -n "${port_locks:-}" && -d "$port_locks" ]] || return 0
  for f in "$port_locks"/[0-9]*; do
    [[ -f "$f" ]] || continue
    read -r owner _ < "$f" || true
    if [[ "$owner" == "$db" ]]; then rm -f "$f"; fi
  done
}

pick_ports() {
  release_ports
  backend_port=$(claim_port 18080 18179) \
    && worker_port=$(claim_port 18180 18279) \
    && vite_port=$(claim_port 15180 15279)
}

# Sets backend_port, worker_port and vite_port to ports claimed for this start.
reserve_ports() {
  with_port_mutex pick_ports
}

# The pids listening on port $1, one a line; none when it is free.
listener_pids() {
  lsof -nP -iTCP:"$1" -sTCP:LISTEN -t 2>/dev/null || true
}

process_name() {
  basename "$(ps -o comm= -p "$1" 2>/dev/null || echo gone)"
}

# Who listens on port $1: ours (a process of this checkout's start), none, or which other process.
listener_verdict() {
  local pids pid other
  pids=$(listener_pids "$1")
  if [[ -z "$pids" ]]; then
    echo none
    return 0
  fi
  for pid in $pids; do
    if is_ours "$pid"; then
      echo ours
      return 0
    fi
  done
  pid=$(echo "$pids" | head -n 1)
  other=$(env_value "$pid" CODEBITE_DEV_BRANCH)
  if [[ -n "$other" ]]; then
    echo "pid $pid, the branch servers of $other"
  else
    echo "pid $pid ($(process_name "$pid")), not a branch server"
  fi
}

# Whether each port in $state/ports is listened on by this checkout's app; says which isn't.
listeners_ours() {
  local backend_port worker_port vite_port redis_db ok=0 app port who
  # shellcheck disable=SC1091  # written by cmd_start; sets the locals above, not the caller's
  source "$state/ports"
  for app in backend:$backend_port worker:$worker_port frontend:$vite_port; do
    port=${app#*:}
    app=${app%%:*}
    who=$(listener_verdict "$port")
    case "$who" in
      ours) ;;
      none) echo "$app: nothing listens on $port yet (starting, or stopped)"; ok=1 ;;
      *) echo "$app: port $port is held by $who, not this checkout's $app"; ok=1 ;;
    esac
  done
  return "$ok"
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

# Every database's name. A lookup that fails, or lacks the postgres database every server has,
# exits: read as "none exist", it would make each existing branch database's topics and Redis
# index look left behind, for drop <name> to delete.
existing_databases() {
  local names
  if ! names=$(psql_admin "SELECT datname FROM pg_database") || ! grep -qxF postgres <<<"$names"; then
    echo "dev-branch-servers.sh: couldn't list the databases in codebite-postgres; rerun" >&2
    exit 1
  fi
  echo "$names"
}

kafka_bin() {
  local tool=$1
  shift
  docker exec codebite-kafka "/opt/kafka/bin/$tool" --bootstrap-server localhost:9092 "$@"
}

# The topics (kafka-topics.sh as $1) or consumer groups (kafka-consumer-groups.sh) of branch
# database $2, by kafka_owner.
kafka_names_of() {
  local name owner
  { kafka_bin "$1" --list 2>/dev/null || true; } | while read -r name; do
    owner=$(kafka_owner "$name")
    if [[ -n "$owner" && "$owner" == "$2" ]]; then echo "$name"; fi
  done
}

# Sets the globals the subcommands read: root (this checkout), main (the main checkout), db (the
# branch database), prefix (its Kafka topic and group prefix), state (the ports, pids and logs)
# port_locks (every start's port claims) and state_base (every branch database's state).
setup() {
  root=$(git rev-parse --show-toplevel)
  main=$(main_checkout)
  state_base="${TMPDIR:-/tmp}"
  state_base="${state_base%/}/codebite-dev-branch"
  port_locks="$state_base/.ports"
  use_database "$(checkout_database "$root")"
}

# Sets db to branch database $1, and the globals named for it: prefix and state.
use_database() {
  db=$1
  prefix="$db-"
  state="$state_base/$db"
}

summary() {
  local backend_port worker_port vite_port redis_db
  # shellcheck disable=SC1091  # written by cmd_start; sets the locals above, not the caller's
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

Stop: Ctrl-C (unless detached), or scripts/dev-branch-servers.sh stop.  After a new migration: restart.  Drop the data: scripts/dev-branch-servers.sh drop
EOS
}

# Waits until $2 answers from this checkout's process listening on port $5, or the process $1
# dies; on death prints the log's tail. Another server answering on the port is an error at once:
# the start would otherwise take it for its own.
wait_for() {
  local pid=$1 url=$2 log=$3 what=$4 port=$5 i who
  for (( i = 0; i < 600; i++ )); do
    if curl -fsS -o /dev/null "$url" 2>/dev/null; then
      who=$(listener_verdict "$port")
      case "$who" in
        ours) echo "$what: up"; return 0 ;;
        none) ;;
        *)
          echo "$what: port $port answers, but its listener is $who, not this checkout's $what" >&2
          return 1 ;;
      esac
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
  release_ports
  return 0
}

# Exits, saying in one line what to start or wait for, unless Postgres in codebite-postgres answers.
require_postgres() {
  local down
  down=$(db_down_reason)
  if [[ -z "$down" ]]; then
    docker exec codebite-postgres pg_isready -q -U codebite && return 0
    down="codebite-postgres runs but doesn't accept connections yet; rerun in a few seconds"
  fi
  echo "dev-branch-servers.sh: $down" >&2
  exit 1
}

# Exits, saying what to start, unless the Kafka and the Redis container both run; a Docker daemon
# that doesn't answer is said once.
require_kafka_and_redis() {
  local container down refused=false
  for container in codebite-kafka codebite-redis; do
    down=$(container_down_reason "$container")
    [[ -z "$down" ]] && continue
    echo "dev-branch-servers.sh: $down" >&2
    refused=true
    [[ "$down" == "$(docker_down_message)" ]] && break
  done
  if $refused; then exit 1; fi
}

# Whether container $1 runs, for a cleanup that needs it; when it doesn't, says in one line that
# $2 is left as it is, and returns 1.
container_runs_or_says() {
  case "$(container_state "$1")" in
    running) return 0 ;;
    stopped) echo "$1 isn't running: $2" >&2 ;;
    *) echo "the Docker daemon doesn't answer: $2" >&2 ;;
  esac
  return 1
}

# Creates the branch database, marked this worktree's, when it doesn't exist ($1 says what
# migrates it); exits when it exists but is another worktree's.
ensure_database() {
  local comment
  comment=$(db_owner_comment "$root")
  case "$(database_verdict "$(database_state)" "$comment")" in
    create)
      psql_admin "CREATE DATABASE \"$db\"" >/dev/null
      psql_admin "COMMENT ON DATABASE \"$db\" IS $(sql_literal "$comment")" >/dev/null
      echo "database $db: created ($1)" ;;
    ours) echo "database $db: exists" ;;
    *)
      echo "database $db exists but isn't this worktree's (its comment isn't '$comment'); not using it" >&2
      exit 1 ;;
  esac
}

# Runs this checkout's Flyway migrations, SQL and Java, against JDBC URL $1, as the backend does
# on start (common's migrateDatabase task; no server).
run_flyway() {
  (cd "$root" && ./gradlew -q --console=plain :common:migrateDatabase -PmigrateUrl="$1")
}

# The branch database migrated to this checkout and nothing else: no server, Kafka topic or Redis
# index. For reading a problem as this checkout has it (scripts/problem-text.sh).
cmd_migrate() {
  require_postgres
  ensure_database "migrating it now"
  echo "database $db: running this checkout's migrations"
  run_flyway "jdbc:postgresql://localhost:5433/$db"
  echo "database $db: at V$(flyway_version "$db")"
  echo "read it with CODEBITE_DB=$db (scripts/problem-text.sh, scripts/db-sql.sh, scripts/judge-local.sh)"
}

cmd_start() {
  if [[ -n "$(branch_pids)" ]]; then
    echo "already running for this checkout:" >&2
    [[ -f "$state/ports" ]] && summary >&2
    exit 1
  fi
  require_postgres
  require_kafka_and_redis
  ensure_database "the backend migrates it on start"

  local redis_db
  redis_db=$(claim_redis_index)

  mkdir -p "$state"
  rm -f "$state/stopping"
  echo $$ > "$state/start.pid"
  : > "$state/pids"
  local backend_port worker_port vite_port
  reserve_ports
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
  local judge0
  judge0=$(dev_judge0_url "${JUDGE0_URL:-}")
  # Values a shell may carry from the production infra/.env (see scripts/dev-env.sh), and the
  # shared servers' own settings, must not reach the branch servers. A dev JUDGE0_URL does.
  unset CORS_ALLOWED_ORIGINS JWT_SECRET DB_USER DB_PASSWORD DB_URL JUDGE0_URL KAFKA_ENABLED \
    SPRING_PROFILES_ACTIVE SPRING_DATASOURCE_URL SERVER_PORT SPRING_APPLICATION_JSON
  if [[ -n "$judge0" ]]; then export JUDGE0_URL="$judge0"; fi
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
  wait_for $! "http://127.0.0.1:$backend_port/api/health" "$state/backend.log" backend "$backend_port" || exit 1

  # After the backend: it creates the topics, and the two Gradle builds don't contend for common.
  echo "worker: starting on $worker_port (log $state/worker.log)"
  SERVER_PORT=$worker_port ./gradlew :worker:bootRun > "$state/worker.log" 2>&1 &
  echo $! >> "$state/pids"
  wait_for $! "http://127.0.0.1:$worker_port/actuator/health" "$state/worker.log" worker "$worker_port" || exit 1

  echo "frontend: starting on $vite_port (log $state/vite.log)"
  (cd frontend && VITE_API_URL="http://127.0.0.1:$backend_port/api" \
    exec "$root/frontend/node_modules/.bin/vite" --host 127.0.0.1 --port "$vite_port" --strictPort) \
    > "$state/vite.log" 2>&1 &
  echo $! >> "$state/pids"
  wait_for $! "$vite_origin" "$state/vite.log" frontend "$vite_port" || exit 1

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

# Starts the servers in the background, detached from this shell, and returns once they are up.
cmd_start_detached() {
  mkdir -p "$state"
  local log="$state/start.log"
  nohup "${BASH_SOURCE[0]}" start > "$log" 2>&1 < /dev/null &
  await_detached $! "$log"
}

# Waits for the start $1 writing log $2: prints the log and returns 0 once it has printed the
# summary, or prints it to stderr and returns 1 once that start has died first.
await_detached() {
  local pid=$1 log=$2
  while kill -0 "$pid" 2>/dev/null; do
    if grep -q '^Branch servers for' "$log" 2>/dev/null; then
      cat "$log"
      return 0
    fi
    sleep 1
  done
  cat "$log" >&2
  return 1
}

# A start left running would see its apps gone and, if that comes before it sees the stop, stop
# everything on its way out, the new servers included: wait for it to exit before starting again.
cmd_restart() {
  local pid i
  stop_all
  if [[ -f "$state/start.pid" ]]; then
    pid=$(cat "$state/start.pid")
    for (( i = 0; i < 15; i++ )); do
      kill -0 "$pid" 2>/dev/null || break
      sleep 1
    done
  fi
  cmd_start_detached
}

# Prints where the servers run and returns 0 once each of their ports is listened on by this
# checkout's app; else says what isn't up, or held by another process, and returns 1. An agent
# can wait on it: until scripts/dev-branch-servers.sh status >/dev/null; do sleep 2; done
cmd_status() {
  if [[ -z "$(branch_pids)" || ! -f "$state/ports" ]]; then
    echo "not running ($db)"
    return 1
  fi
  listeners_ours || return 1
  summary
}

cmd_drop() {
  if [[ -n "$(branch_pids)" ]]; then
    echo "the branch servers are running; stop them first: scripts/dev-branch-servers.sh stop" >&2
    exit 1
  fi
  require_postgres
  local comment found
  comment=$(db_owner_comment "$root")
  # A failed lookup is not "none": that would delete the topics and index of a database still there.
  if ! found=$(database_state); then
    echo "dev-branch-servers.sh: couldn't look up database $db in codebite-postgres; rerun" >&2
    exit 1
  fi
  case "$(database_verdict "$found" "$comment")" in
    create)
      # Nothing was ever started here (start makes the state directory, start and migrate the
      # database), or an earlier drop skipped a stopped Kafka or Redis: only that is looked for.
      if [[ ! -d "$state" && -z "$(leftovers_of_db)" ]]; then
        echo "database $db: none; nothing to drop"
        return 0
      fi
      echo "database $db: none" ;;
    ours) drop_database ;;
    *)
      echo "database $db isn't this worktree's (its comment isn't '$comment'); dropping nothing" >&2
      exit 1 ;;
  esac
  drop_branch_data "scripts/dev-branch-servers.sh drop in this worktree, or drop $db once the worktree is gone"
}

# $db's Kafka topics and groups and Redis index, in whichever of the two containers runs.
leftovers_of_db() {
  if [[ "$(container_state codebite-kafka)" == running ]]; then
    kafka_names_of kafka-topics.sh "$db"
    kafka_names_of kafka-consumer-groups.sh "$db"
  fi
  if [[ "$(container_state codebite-redis)" == running ]]; then owned_redis_index; fi
}

drop_database() {
  psql_admin "DROP DATABASE IF EXISTS \"$db\" WITH (FORCE)" >/dev/null
  echo "database $db: dropped"
}

# Deletes $db's Kafka topics and groups, flushes its Redis index and removes its state and port
# claims: everything but the database. A container that doesn't run is asked once and its cleanup
# skipped with one line ending in $1, the command that cleans up later, so the rest still happens
# and the drop still succeeds.
drop_branch_data() {
  local later=$1 topics groups g
  if container_runs_or_says codebite-kafka "topics and groups prefixed ${prefix%-} left behind; once it runs: $later"; then
    topics=$(kafka_names_of kafka-topics.sh "$db")
    if [[ -n "$topics" ]]; then
      kafka_bin kafka-topics.sh --delete --topic "$(echo "$topics" | paste -sd, -)" >/dev/null
      echo "Kafka topics: deleted $(echo "$topics" | paste -sd' ' -)"
    fi
    groups=$(kafka_names_of kafka-consumer-groups.sh "$db")
    for g in $groups; do
      kafka_bin kafka-consumer-groups.sh --delete --group "$g" >/dev/null 2>&1 || true
    done
    if [[ -n "$groups" ]]; then echo "Kafka groups: deleted $(echo "$groups" | paste -sd' ' -)"; fi
  fi
  if container_runs_or_says codebite-redis "the Redis index of $db left claimed; once it runs: $later"; then
    flush_owned_redis_index
  fi
  release_ports
  rm -rf "$state"
}

# Each branch database (its COMMENT says this script made it) and the worktree that made it,
# tab-separated.
branch_databases() {
  local tag
  tag=$(db_owner_comment '')
  psql_admin "SELECT datname || E'\\t' || substr(shobj_description(oid, 'pg_database'), $(( ${#tag} + 1 ))) FROM pg_database WHERE shobj_description(oid, 'pg_database') LIKE $(sql_literal "$tag%") ORDER BY datname"
}

# The branch databases whose worktree no longer exists (a shipped or removed branch's), with it.
orphan_databases() {
  local name path
  branch_databases | while IFS=$'\t' read -r name path; do
    [[ -n "$name" && ! -d "$path" ]] && printf '%s\t%s\n' "$name" "$path"
  done
  return 0
}

# The branch database of each worktree of this repository whose directory is still there (rev-parse fails
# in a removed one).
live_worktree_databases() {
  local key path top
  git -C "$main" worktree list --porcelain | while read -r key path; do
    [[ "$key" == worktree ]] || continue
    top=$(git -C "$path" rev-parse --show-toplevel 2>/dev/null) || continue
    checkout_database "$top"
  done
}

# What branch databases that are gone left behind (a drop skips a stopped Kafka or Redis): one
# "<database>\ttopic", "<database>\tgroup" or "<database>\tredis <index>" line for each Kafka
# topic, consumer group and Redis index 1-15 whose name (kafka_owner) or owner key names a branch
# database that doesn't exist and is no live worktree's. Looks only in the containers that run.
orphan_leftovers() {
  local known name what i owner
  known=$(existing_databases) || exit 1
  known+=$'\n'$(live_worktree_databases)
  {
    if [[ "$(container_state codebite-kafka)" == running ]]; then
      for what in topic:kafka-topics.sh group:kafka-consumer-groups.sh; do
        { kafka_bin "${what#*:}" --list 2>/dev/null || true; } | while read -r name; do
          owner=$(kafka_owner "$name")
          if [[ -n "$owner" ]]; then printf '%s\t%s\n' "$owner" "${what%%:*}"; fi
        done
      done
    fi
    if [[ "$(container_state codebite-redis)" == running ]]; then
      for (( i = 1; i <= 15; i++ )); do
        owner=$(redis_cmd "$i" GET "$REDIS_OWNER_KEY")
        if is_branch_db_name "$owner"; then printf '%s\tredis %s\n' "$owner" "$i"; fi
      done
    fi
  } | while IFS=$'\t' read -r name what; do
    grep -qxF -- "$name" <<<"$known" || printf '%s\t%s\n' "$name" "$what"
  done
}

cmd_orphans() {
  require_postgres
  local list leftovers down
  list=$(orphan_databases)
  leftovers=$(orphan_leftovers) || exit 1
  if [[ -z "$list$leftovers" ]]; then
    if [[ -z "$(container_down_reason codebite-kafka)$(container_down_reason codebite-redis)" ]]; then
      echo "no branch database outlives its worktree, and no dropped one left Kafka topics or a Redis index"
    else
      echo "nothing found: no branch database outlives its worktree, and no dropped one left what could be looked at"
    fi
  else
    if [[ -n "$list" ]]; then
      echo "branch databases whose worktree is gone:"
      printf '%s\n' "$list" | while IFS=$'\t' read -r name path; do
        echo "  $name  (was $path)"
      done
    fi
    if [[ -n "$leftovers" ]]; then
      echo "branch databases already dropped whose Kafka topics or Redis index are left:"
      printf '%s\n' "$leftovers" | LC_ALL=C sort | awk -F'\t' '
        function many(n, what) { return n " " what (n > 1 ? "s" : "") }
        function flush(  s) {
          if (db == "") return
          if (t) s = many(t, "Kafka topic")
          if (g) s = s (s == "" ? "" : ", ") many(g, "Kafka group")
          if (r != "") s = s (s == "" ? "" : ", ") "Redis index " r
          print "  " db "  (" s ")"
        }
        $1 != db { flush(); db = $1; t = 0; g = 0; r = "" }
        $2 == "topic" { t++ }
        $2 == "group" { g++ }
        $2 ~ /^redis / { r = r (r == "" ? "" : ", ") substr($2, 7) }
        END { flush() }'
    fi
    echo "drop one, with its Kafka topics and Redis index: scripts/dev-branch-servers.sh drop <name>"
  fi
  down=$(container_down_reason codebite-kafka)
  if [[ -n "$down" ]]; then echo "Kafka topics and groups not looked at: $down"; fi
  down=$(container_down_reason codebite-redis)
  if [[ -n "$down" ]]; then echo "Redis indexes not looked at: $down"; fi
}

# How many databases cmd_orphans lists, each once whatever it left: the number alone.
cmd_orphans_count() {
  require_postgres
  local list leftovers
  list=$(orphan_databases)
  leftovers=$(orphan_leftovers) || exit 1
  printf '%s\n%s\n' "$list" "$leftovers" | cut -f1 | LC_ALL=C sort -u | awk 'NF { n++ } END { print n + 0 }'
}

# Drops branch database $1 by name, from any checkout, when its worktree is gone, or what it left
# in Kafka and Redis when it is gone too; a live worktree's is dropped from that worktree, and
# any other database or name is never touched.
cmd_drop_orphan() {
  local name=$1 listed=false gone=false leftovers
  require_postgres
  # The shape comes first: grep reads a name of several lines as several names, any one of which
  # may match. Lists are captured, not piped to grep -q: under pipefail its early exit can fail
  # the pipe it ends, and a lookup that exits inside a pipe wouldn't end the drop.
  if is_branch_db_name "$name"; then
    if grep -qxF -- "$name" <<<"$(orphan_databases | cut -f1)"; then
      listed=true
    else
      leftovers=$(orphan_leftovers) || exit 1
      if grep -qxF -- "$name" <<<"$(cut -f1 <<<"$leftovers")"; then listed=true gone=true; fi
    fi
  fi
  if ! $listed; then
    echo "$name isn't a branch database whose worktree is gone, nor one already dropped that left Kafka topics or a Redis index" \
      "(scripts/dev-branch-servers.sh orphans lists both); dropping nothing" >&2
    exit 1
  fi
  use_database "$name"
  # Its servers, from whatever checkout they run.
  root=""
  if [[ -n "$(branch_pids)" ]]; then
    echo "servers of $db still run (pids $(branch_pids | paste -sd' ' -)); dropping nothing" >&2
    exit 1
  fi
  if $gone; then echo "database $db: none (dropped before)"; else drop_database; fi
  drop_branch_data "scripts/dev-branch-servers.sh drop $db"
}

usage() {
  sed -n 's/^#   \(scripts\/dev-branch-servers\.sh .*\)/  \1/p' "$0" >&2
}

main() {
  local cmd=${1:-start} detach=false orphan="" count=false
  case "$cmd" in
    start)
      case "${2:-}" in
        '') ;;
        --detach) detach=true ;;
        *) usage; exit 2 ;;
      esac ;;
    drop) orphan=${2:-} ;;
    orphans)
      case "${2:-}" in
        '') ;;
        --count) count=true ;;
        *) usage; exit 2 ;;
      esac ;;
    restart | stop | status | migrate | name) [[ $# -le 1 ]] || { usage; exit 2; } ;;
    *) usage; exit 2 ;;
  esac
  (( $# <= 2 )) || { usage; exit 2; }
  setup
  if [[ "$cmd" != name && "$cmd" != status && "$cmd" != orphans && -z "$orphan" && "$root" == "$main" ]]; then
    echo "dev-branch-servers.sh: $root is the main checkout, whose servers are the shared ones;" \
      "run it from a worktree (only name, status, orphans and drop <name> work here)" >&2
    exit 1
  fi
  case "$cmd" in
    start) if $detach; then cmd_start_detached; else cmd_start; fi ;;
    restart) cmd_restart ;;
    migrate) cmd_migrate ;;
    stop) stop_all ;;
    status) cmd_status ;;
    drop) if [[ -n "$orphan" ]]; then cmd_drop_orphan "$orphan"; else cmd_drop; fi ;;
    orphans) if $count; then cmd_orphans_count; else cmd_orphans; fi ;;
    name) echo "$db" ;;
  esac
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  main "$@"
fi
