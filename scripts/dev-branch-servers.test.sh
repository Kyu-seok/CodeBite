#!/usr/bin/env bash
# Checks scripts/dev-branch-servers.sh without Docker or running servers: the branch database name
# (which also prefixes its Kafka topics and groups) and its ownership, the Redis index claim, which
# processes it would stop, the port picking, what orphans lists and drop <name> deletes (Kafka and
# Redis leftovers of a dropped database among them), and that it refuses to run from the main checkout.
set -euo pipefail

script="$(cd "$(dirname "$0")" && pwd)/dev-branch-servers.sh"
# shellcheck source=SCRIPTDIR/dev-branch-servers.sh
source "$script"

fail=0
check() { [[ "$2" == "$3" ]] || { echo "FAIL: $1: expected '$3', got '$2'"; fail=1; }; }
fake=$(mktemp -d)

# --- the fake Postgres ------------------------------------------------------------------------

# The one psql_admin fake: fake_psql_admin puts it in place (again after each `source "$script"`,
# which brings the real one back). It answers from the files of the fixture directory $fx, which
# each block sets and fills:
#   $fx/databases  every database's name, one a line (existing_databases)
#   $fx/owned      each branch database and the worktree that made it, tab-separated (branch_databases)
#   $fx/db-state   "x" plus the comment of the one database asked about; no file, no such database
#   $fx/calls      "psql <query>" for each query, in order
# CREATE, COMMENT ON and DROP DATABASE are logged and change no file. psql_fails=1 fails every
# query. A query it doesn't know, or one whose fixture file the block didn't write, fails and is
# noted in $unknown_queries, which the exit trap prints as FAIL lines: the script may have sent
# the fake's own output anywhere, and may have exited on its answer.
unknown_queries="$fake/unknown-queries"
: > "$unknown_queries"
psql_fails=""
fake_psql_admin() {
  mkdir -p "$fx"
  psql_admin() {
    local file=""
    echo "psql $1" >> "$fx/calls"
    [[ -z "$psql_fails" ]] || return 2
    case "$1" in
      "SELECT datname FROM pg_database") file=databases ;;
      "SELECT datname || E'\\t' || substr(shobj_description(oid, 'pg_database'), "*" LIKE "*) file=owned ;;
      "SELECT 'x' || coalesce(shobj_description(oid, 'pg_database'), '') FROM pg_database WHERE datname = "*)
        cat "$fx/db-state" 2>/dev/null || true ;;
      "CREATE DATABASE "* | "COMMENT ON DATABASE "* | "DROP DATABASE IF EXISTS "*) ;;
      *) echo "unknown query: $1" >> "$unknown_queries"; return 3 ;;
    esac
    [[ -z "$file" ]] && return 0
    [[ -f "$fx/$file" ]] || { echo "no $file file in ${fx##*/} for: $1" >> "$unknown_queries"; return 3; }
    cat "$fx/$file"
  }
}
report_unknown_queries() { awk '!seen[$0]++ { print "FAIL: psql_admin fake: " $0 }' "$unknown_queries"; }
finish() {
  local code=$?
  report_unknown_queries
  [[ ! -s "$unknown_queries" ]] || code=1
  rm -rf "$fake"
  exit "$code"
}
trap finish EXIT

# A query the fake has no answer for is a failure that names it.
fx="$fake/unknown-query"
fake_psql_admin
(psql_admin "SELECT nonsense" >/dev/null 2>&1) && code=0 || code=$?
check "an unknown query fails" "$code" 3
check "an unknown query is named" "$(report_unknown_queries)" "FAIL: psql_admin fake: unknown query: SELECT nonsense"
: > "$unknown_queries"
(psql_admin "SELECT datname FROM pg_database" >/dev/null 2>&1) && code=0 || code=$?
check "a query whose fixture file is missing fails" "$code" 3
check "a missing fixture file is named" "$(report_unknown_queries)" \
  "FAIL: psql_admin fake: no databases file in unknown-query for: SELECT datname FROM pg_database"
: > "$unknown_queries"

# --- database names ---------------------------------------------------------------------------

hash_of() { printf '%08x' "$(printf '%s' "$1" | cksum | cut -d' ' -f1)"; }
wt=/work/wt-a
check "slashes and dashes" "$(branch_db_name chore/dev-branch-servers "$wt")" \
  "codebite_chore_dev_branch_servers_$(hash_of "$wt")"
check "case and runs" "$(branch_db_name 'Feat//Foo--Bar.2' "$wt")" "codebite_feat_foo_bar_2_$(hash_of "$wt")"
check "edges trimmed" "$(branch_db_name '-x-' "$wt")" "codebite_x_$(hash_of "$wt")"
check "never the shared database" "$(branch_db_name '' "$wt")" "codebite_detached_$(hash_of "$wt")"
check "never the shared database" "$(branch_db_name '///' "$wt")" "codebite_detached_$(hash_of "$wt")"
check "stable for one worktree" "$(branch_db_name feat/a "$wt")" "$(branch_db_name feat/a "$wt")"

# Branches that fold to the same text, in two worktrees, get two databases.
a=$(branch_db_name feat/a-b /work/wt-1)
for other in feat/a_b Feat/A.B; do
  b=$(branch_db_name "$other" /work/wt-2)
  [[ "$a" != "$b" ]] || { echo "FAIL: feat/a-b and $other in two worktrees share $a"; fail=1; }
done
long_a=$(branch_db_name "feat/$(printf 'a%.0s' {1..80})-one" /work/wt-1)
long_b=$(branch_db_name "feat/$(printf 'a%.0s' {1..80})-two" /work/wt-2)
check "PostgreSQL's 63-character limit" "${#long_a}" 63
[[ "$long_a" != "$long_b" ]] || { echo "FAIL: long names sharing a prefix collide: $long_a"; fail=1; }
cut=$(branch_db_name "feat/$(printf 'a%.0s' {1..39})_b" "$wt")
check "no trailing underscore after the cut" "$cut" "codebite_feat_$(printf 'a%.0s' {1..39})_$(hash_of "$wt")"

# --- database ownership -----------------------------------------------------------------------

tag=$(db_owner_comment /work/wt-a)
check "absent: create it" "$(database_verdict '' "$tag")" create
check "this worktree's: ours" "$(database_verdict "x$tag" "$tag")" ours
check "another worktree's: foreign" "$(database_verdict "x$(db_owner_comment /work/wt-b)" "$tag")" foreign
check "no comment: foreign" "$(database_verdict x "$tag")" foreign
check "SQL quoting" "$(sql_literal "it's")" "'it''s'"

# --- Redis index claim (a fake Redis: one owner file and one size file per index) -------------

redis_cmd() {
  local f="$fake/redis-$1"
  [[ "$1" == 0 ]] && { echo "FAIL: touched Redis index 0 ($*)" >&2; echo touched > "$fake/redis0"; }
  case "$2" in
    GET) cat "$f.owner" 2>/dev/null || echo ;;
    DBSIZE) cat "$f.size" 2>/dev/null || echo 0 ;;
    SET) if [[ -f "$f.owner" ]]; then echo; else echo "$4" > "$f.owner"; echo 1 > "$f.size"; echo OK; fi ;;
    FLUSHDB) rm -f "$f.owner" "$f.size"; echo OK ;;
  esac
}
echo codebite_other > "$fake/redis-1.owner"; echo 4 > "$fake/redis-1.size"  # another branch's
echo 7 > "$fake/redis-2.size"                                                  # keys, no owner
db=codebite_mine
check "claims the first empty unowned index" "$(claim_redis_index)" 3
check "reuses its index on restart" "$(claim_redis_index)" 3
check "finds its own index" "$(owned_redis_index)" 3
check "another branch claims the next" "$(db=codebite_third claim_redis_index)" 4
flush_owned_redis_index >/dev/null
check "drop flushes its own index" "$(cat "$fake/redis-3.owner" 2>/dev/null)" ""
check "drop leaves another branch's index" "$(cat "$fake/redis-1.owner")" codebite_other
check "drop leaves another branch's index" "$(cat "$fake/redis-4.owner")" codebite_third
check "drop leaves an unowned index" "$(cat "$fake/redis-2.size")" 7
check "nothing to flush once dropped" "$(flush_owned_redis_index)" "Redis: no database owned by codebite_mine"
[[ ! -f "$fake/redis0" ]] || fail=1

# --- which processes it stops ---------------------------------------------------------------

# Fakes: pgrep finds 101 (ours), 102 (the shared server) and 103 (another worktree's) for every
# app; kill records what it was asked to kill, and the killed pids then vanish from pgrep.
pgrep() { local p; for p in 101 102 103; do grep -qx "$p" "$fake/killed" 2>/dev/null || echo "$p"; done; }
env_value() {
  case "$1" in
    101 | 201) echo codebite_mine ;;
    103 | 203) echo codebite_theirs ;;
    *) echo ;;
  esac
}
kill() { local a; for a in "$@"; do [[ "$a" == -* ]] || echo "$a" >> "$fake/killed"; done; }
sleep() { :; }
root=/work/wt-a
check "only processes carrying this database" "$(branch_pids backend | sort -u)" 101
check "never a process when the name is empty" "$(db='' branch_pids)" ""
state="$fake/state"
mkdir -p "$state"
printf '201\n202\n203\n' > "$state/pids"
stop_all >/dev/null
check "stop kills only this checkout's processes and saved pids" "$(sort -u "$fake/killed" | paste -sd' ' -)" "101 201"
unset -f pgrep kill sleep env_value

# --- ports ------------------------------------------------------------------------------------

port_locks="$fake/locks"
busy=" 18080 18081 "
port_busy() { [[ "$busy" == *" $1 "* ]]; }
check "skips busy ports" "$(claim_port 18080 18179)" 18082
check "a claimed port names its database and start" "$(cat "$port_locks/18082")" "$db $$"
check "never a shared server's port, even when free" "$(claim_port 8080 8082)" 8082
check "never a shared server's port, even when free" "$(claim_port 5173 5175)" 5175
if claim_port 18080 18081 2>/dev/null; then echo "FAIL: a full range must fail"; fail=1; fi
busy=""
rm -rf "$port_locks"; mkdir -p "$port_locks"
sh -c 'sleep 30' & alive=$!
sh -c 'exit 0' & wait $!; dead=$!
echo "codebite_theirs $alive" > "$port_locks/18080"   # a running start's
echo "codebite_gone $dead" > "$port_locks/18081"      # a start that died without a stop
echo "$db 1" > "$port_locks/18090"                    # this database's, from its last start
check "skips a port another running start claimed" "$(claim_port 18080 18080 2>/dev/null || echo none)" none
check "takes a port whose start is gone" "$(claim_port 18081 18081)" 18081
release_ports
check "release drops this database's claims" "$(ls "$port_locks" | paste -sd' ' -)" 18080
{ kill "$alive"; wait "$alive"; } 2>/dev/null || true

# Starts in several worktrees at once each get ports of their own. Each picker is a process of its
# own (its $$ the start pid its claims name) that stays alive while the others pick, as a start does.
rm -rf "$port_locks"
for i in 1 2 3 4 5 6; do
  bash -c '
    source "$1"; port_locks=$2; db=codebite_wt$3
    port_busy() { return 1; }
    reserve_ports && echo "$backend_port $worker_port $vite_port"
    sleep 2' _ "$script" "$port_locks" "$i" > "$fake/picked-$i" 2>&1 &
done
wait
picked=$(cat "$fake"/picked-*)
check "six concurrent starts all got ports" "$(echo "$picked" | grep -cE '^[0-9]+ [0-9]+ [0-9]+$')" 6
for col in 1 2 3; do
  check "concurrent starts get distinct ports (column $col)" \
    "$(echo "$picked" | awk -v c="$col" '{print $c}' | sort | uniq -d)" ""
done
[[ ! -e "$port_locks/.mutex-pid" && ! -L "$port_locks/.mutex-pid" ]] || { echo "FAIL: the port mutex was left behind"; fail=1; }

# The mutex a start holds is never broken, however long it holds it; one whose start died is
# broken, by one waiter only. Each waiter enters a critical section that notes any overlap.
rm -rf "$port_locks"; mkdir -p "$port_locks"
sh -c 'sleep 30' & holder=$!
ln -s "$holder" "$port_locks/.mutex-pid"
touch -h -t 202001010000 "$port_locks/.mutex-pid" 2>/dev/null || true   # older than any staleness by age
inside() {
  mkdir "$fake/inside" 2>/dev/null || echo overlap >> "$fake/overlaps"
  echo "$$ ${BASHPID:-}" >> "$fake/entered"
  sleep 0.2
  rmdir "$fake/inside"
}
export -f inside
export fake
rm -f "$fake/overlaps" "$fake/entered"
for i in 1 2 3 4 5 6; do
  bash -c 'source "$1"; port_locks=$2; with_port_mutex inside' _ "$script" "$port_locks" &
done
command sleep 1.5
check "a live start's mutex is never broken" "$(cat "$fake/entered" 2>/dev/null | wc -l | tr -d ' ')" 0
{ kill "$holder"; wait "$holder"; } 2>/dev/null || true
wait
check "once its start is gone, every waiter gets the mutex" "$(wc -l < "$fake/entered" | tr -d ' ')" 6
check "a broken mutex lets in one waiter at a time" "$(cat "$fake/overlaps" 2>/dev/null)" ""
[[ ! -e "$port_locks/.mutex-pid" && ! -L "$port_locks/.mutex-pid" ]] || { echo "FAIL: the port mutex was left behind"; fail=1; }

# --- who listens on a port ----------------------------------------------------------------------

# Fakes: 18080 is ours (pid 101), 18180 another worktree's (103), 15180 a stray process (104),
# 18081 nobody's.
listener_pids() {
  case "$1" in 18080) echo 101 ;; 18180) echo 103 ;; 15180) echo 104 ;; esac
}
env_value() {
  case "$1" in 101) echo "$db" ;; 103) echo codebite_theirs ;; *) echo ;; esac
}
process_name() { echo node; }
check "our listener" "$(listener_verdict 18080)" ours
check "no listener" "$(listener_verdict 18081)" none
check "another worktree's listener" "$(listener_verdict 18180)" "pid 103, the branch servers of codebite_theirs"
check "a stray listener" "$(listener_verdict 15180)" "pid 104 (node), not a branch server"

# --- status ---------------------------------------------------------------------------------

# status exits 0 only when every port it prints is listened on by this checkout's servers, so
# `until status; do sleep; done` waits for them all to be up, and never takes another's for ours.
state="$fake/status-state" prefix="$db-"
mkdir -p "$state"
branch_pids() { :; }
out=$(cmd_status) && code=0 || code=$?
check "status when not running" "$code" 1
check "status says not running" "$out" "not running ($db)"
branch_pids() { echo 101; }
listener_pids() { case "$1" in 18080 | 18180 | 15180) echo 101 ;; esac; }
printf 'backend_port=18080\nworker_port=18180\nvite_port=15180\nredis_db=3\n' > "$state/ports"
out=$(cmd_status) && code=0 || code=$?
check "status when all three are up" "$code" 0
[[ "$out" == *"http://127.0.0.1:18080/api"* ]] || { echo "FAIL: status should print the summary: $out"; fail=1; }
backend_port=1 worker_port=2 vite_port=3 redis_db=4
cmd_status >/dev/null || true
check "status leaves the caller's ports alone" "$backend_port $worker_port $vite_port $redis_db" "1 2 3 4"
listener_pids() { case "$1" in 18080) echo 101 ;; esac; }
out=$(cmd_status) && code=0 || code=$?
check "status while starting" "$code" 1
[[ "$out" == *"worker: nothing listens on 18180 yet"* ]] || { echo "FAIL: status should name the app not up: $out"; fail=1; }
listener_pids() { case "$1" in 18080 | 18180) echo 101 ;; 15180) echo 103 ;; esac; }
out=$(cmd_status) && code=0 || code=$?
check "status with a port held by another" "$code" 1
[[ "$out" == *"frontend: port 15180 is held by pid 103, the branch servers of codebite_theirs, not this checkout's"* ]] \
  || { echo "FAIL: status should name who holds the port: $out"; fail=1; }

# A start waiting on its backend fails at once when the port answers for another's server.
curl() { return 0; }
kill() { return 0; }
out=$(wait_for 999 http://127.0.0.1:15180 "$fake/vite.log" frontend 15180 2>&1) && code=0 || code=$?
check "start refuses another's server on its port" "$code" 1
[[ "$out" == *"frontend: port 15180 answers, but its listener is pid 103"* ]] \
  || { echo "FAIL: wait_for should name who holds the port: $out"; fail=1; }
out=$(wait_for 999 http://127.0.0.1:18080 "$fake/backend.log" backend 18080 2>&1) && code=0 || code=$?
check "start sees its own server up" "$out" "backend: up"
unset -f branch_pids listener_pids env_value process_name curl kill
# shellcheck source=SCRIPTDIR/dev-branch-servers.sh
source "$script"

# --- migrate ----------------------------------------------------------------------------------

# migrate creates the branch database as start does (with this worktree's COMMENT), runs Flyway
# on it through Gradle, and starts nothing; it refuses another worktree's database.
root=/work/wt-a db=codebite_mine
fx="$fake/migrate"
fake_psql_admin
: > "$fx/calls"
docker() { echo "docker $*" >> "$fx/calls"; }
run_flyway() { echo "flyway $1" >> "$fx/calls"; }
container_state() { echo running; }
flyway_version() { echo 260; }
rm -f "$fx/db-state"
out=$(cmd_migrate 2>&1) && code=0 || code=$?
check "migrate a new database" "$code" 0
calls=$(cat "$fx/calls")
[[ "$calls" == *"psql CREATE DATABASE \"codebite_mine\""* ]] || { echo "FAIL: migrate should create the database: $calls"; fail=1; }
[[ "$calls" == *"COMMENT ON DATABASE \"codebite_mine\" IS 'codebite-dev-branch:/work/wt-a'"* ]] \
  || { echo "FAIL: migrate should mark the database this worktree's: $calls"; fail=1; }
[[ "$calls" == *"flyway jdbc:postgresql://localhost:5433/codebite_mine"* ]] || { echo "FAIL: migrate should run Flyway on it: $calls"; fail=1; }
[[ "$out" == *"CODEBITE_DB=codebite_mine"* && "$out" == *"at V260"* ]] || { echo "FAIL: migrate should print the database and its version: $out"; fail=1; }
: > "$fx/calls"
echo "x$(db_owner_comment /work/wt-a)" > "$fx/db-state"
cmd_migrate >/dev/null 2>&1 || { echo "FAIL: migrate on its own database"; fail=1; }
[[ "$(cat "$fx/calls")" != *CREATE* && "$(cat "$fx/calls")" == *flyway* ]] || { echo "FAIL: migrate on an existing database: $(cat "$fx/calls")"; fail=1; }
: > "$fx/calls"
echo "x$(db_owner_comment /work/wt-b)" > "$fx/db-state"
out=$(cmd_migrate 2>&1) && code=0 || code=$?
check "migrate refuses another worktree's database" "$code" 1
[[ "$(cat "$fx/calls")" != *flyway* ]] || { echo "FAIL: migrate ran Flyway on another worktree's database"; fail=1; }
unset -f docker psql_admin run_flyway flyway_version container_state
# shellcheck source=SCRIPTDIR/dev-branch-servers.sh
source "$script"

# --- databases left behind ------------------------------------------------------------------------

# orphans lists the branch databases whose worktree is gone; drop <name> drops only such a one,
# with its Kafka topics and groups and Redis index, and only when none of its servers still run.
mkdir -p "$fake/live-wt"; state_base="$fake/state-base"
fx="$fake/orphans"
fake_psql_admin
: > "$fx/calls"
printf 'codebite_gone_aaaaaaaa\t%s\ncodebite_live_bbbbbbbb\t%s\n' "$fake/gone-wt" "$fake/live-wt" > "$fx/owned"
printf 'postgres\ncodebite_gone_aaaaaaaa\ncodebite_live_bbbbbbbb\n' > "$fx/databases"
kafka_bin() {
  echo "kafka $*" >> "$fx/calls"
  case "$1 $2" in
    "kafka-topics.sh --list") printf 'codebite_gone_aaaaaaaa-submission-events\ncodebite_live_bbbbbbbb-submission-events\n' ;;
  esac
}
flush_owned_redis_index() { echo "redis flush $db" >> "$fx/calls"; }
branch_pids() { :; }
container_state() { echo running; }
live_worktree_databases() { :; }
docker() { echo "docker $*" >> "$fx/calls"; }
check "orphans lists a database whose worktree is gone" "$(orphan_databases)" "codebite_gone_aaaaaaaa	$fake/gone-wt"
out=$(cmd_orphans)
[[ "$out" == *codebite_gone_aaaaaaaa* && "$out" != *codebite_live_bbbbbbbb* ]] || { echo "FAIL: orphans printed: $out"; fail=1; }
for name in codebite_live_bbbbbbbb codebite codebite_nope; do
  : > "$fx/calls"
  out=$(cmd_drop_orphan "$name" 2>&1) && code=0 || code=$?
  check "drop $name by name refused" "$code" 1
  [[ "$(cat "$fx/calls")" != *DROP* && "$(cat "$fx/calls")" != *delete* ]] \
    || { echo "FAIL: drop $name dropped something: $(cat "$fx/calls")"; fail=1; }
done
: > "$fx/calls"
out=$(cmd_drop_orphan codebite_gone_aaaaaaaa 2>&1) && code=0 || code=$?
check "drop an orphan by name" "$code" 0
calls=$(cat "$fx/calls")
[[ "$calls" == *'DROP DATABASE IF EXISTS "codebite_gone_aaaaaaaa"'* ]] || { echo "FAIL: the orphan wasn't dropped: $calls"; fail=1; }
[[ "$calls" == *"--delete --topic codebite_gone_aaaaaaaa-submission-events"* && "$calls" != *"topic codebite_live_bbbbbbbb"* ]] \
  || { echo "FAIL: drop should delete only the orphan's topics: $calls"; fail=1; }
[[ "$calls" == *"redis flush codebite_gone_aaaaaaaa"* ]] || { echo "FAIL: drop should flush the orphan's Redis index: $calls"; fail=1; }
# Kafka and Redis stopped: the database is still dropped, and each skipped cleanup is one line,
# with no docker call that could only print "container ... is not running".
container_state() { case "$1" in codebite-postgres) echo running ;; *) echo stopped ;; esac; }
# The script's own kafka_bin and Redis functions again, over a docker that only fails; the other
# fakes stay.
kept=$(declare -f psql_admin branch_pids container_state live_worktree_databases)
# shellcheck source=SCRIPTDIR/dev-branch-servers.sh
source "$script"
eval "$kept"
docker() {
  echo "docker $*" >> "$fx/calls"
  [[ "$*" == "exec codebite-postgres pg_isready"* ]] && return 0
  echo "Error response from daemon: container 3f2a9c is not running" >&2; return 1
}
mkdir -p "$state_base/codebite_gone_aaaaaaaa"
: > "$fx/calls"
out=$(cmd_drop_orphan codebite_gone_aaaaaaaa 2>&1) && code=0 || code=$?
check "drop with Kafka and Redis stopped still succeeds" "$code" 0
check "drop with Kafka and Redis stopped says what it skipped" "$out" "database codebite_gone_aaaaaaaa: dropped
codebite-kafka isn't running: topics and groups prefixed codebite_gone_aaaaaaaa left behind; once it runs: scripts/dev-branch-servers.sh drop codebite_gone_aaaaaaaa
codebite-redis isn't running: the Redis index of codebite_gone_aaaaaaaa left claimed; once it runs: scripts/dev-branch-servers.sh drop codebite_gone_aaaaaaaa"
calls=$(cat "$fx/calls")
[[ "$calls" == *'DROP DATABASE IF EXISTS "codebite_gone_aaaaaaaa"'* ]] || { echo "FAIL: the database wasn't dropped with Kafka and Redis stopped: $calls"; fail=1; }
[[ "$calls" != *"docker exec codebite-kafka"* && "$calls" != *"docker exec codebite-redis"* ]] \
  || { echo "FAIL: drop called docker on a stopped container: $calls"; fail=1; }
[[ ! -d "$state_base/codebite_gone_aaaaaaaa" ]] || { echo "FAIL: drop with Kafka and Redis stopped left its state directory"; fail=1; }
# Only Redis stopped: Kafka is still cleaned.
container_state() { case "$1" in codebite-redis) echo stopped ;; *) echo running ;; esac; }
: > "$fx/calls"
out=$(cmd_drop_orphan codebite_gone_aaaaaaaa 2>&1) && code=0 || code=$?
[[ "$out" == *"codebite-redis isn't running"* && "$out" != *"codebite-kafka isn't running"* && "$(cat "$fx/calls")" == *"docker exec codebite-kafka"* ]] \
  || { echo "FAIL: with only Redis stopped, Kafka should still be cleaned: $out / $(cat "$fx/calls")"; fail=1; }
# A Docker daemon that doesn't answer is named as such (drop asks Postgres first, so this is a
# daemon that stopped answering after it).
container_state() { echo daemon; }
out=$(use_database codebite_gone_aaaaaaaa; drop_branch_data "scripts/dev-branch-servers.sh drop codebite_gone_aaaaaaaa" 2>&1)
[[ "$out" == *"the Docker daemon doesn't answer: topics and groups prefixed codebite_gone_aaaaaaaa left behind; once it runs: scripts/dev-branch-servers.sh drop codebite_gone_aaaaaaaa"* ]] \
  || { echo "FAIL: drop with the daemon down should say so: $out"; fail=1; }

# start refuses, saying what to start, when Kafka or Redis doesn't run; a daemon that doesn't
# answer is said once.
container_state() { case "$1" in codebite-postgres) echo running ;; *) echo stopped ;; esac; }
out=$( (require_kafka_and_redis) 2>&1) && code=0 || code=$?
check "start refused with Kafka and Redis stopped" "$code" 1
check "start names what to start" "$out" "dev-branch-servers.sh: the codebite-kafka container isn't running; start it: docker compose -f infra/docker-compose.yml up -d kafka
dev-branch-servers.sh: the codebite-redis container isn't running; start it: docker compose -f infra/docker-compose.yml up -d redis"
container_state() { echo daemon; }
out=$( (require_kafka_and_redis) 2>&1) && code=0 || code=$?
check "start refused with Docker down" "$code" 1
check "start names Docker once" "$out" "dev-branch-servers.sh: the Docker daemon doesn't answer; start Docker Desktop (open -a Docker) and rerun"
container_state() { echo running; }
out=$( (require_kafka_and_redis) 2>&1) && code=0 || code=$?
check "start goes on with Kafka and Redis running" "$code/$out" "0/"

branch_pids() { echo 301; }
: > "$fx/calls"
out=$(cmd_drop_orphan codebite_gone_aaaaaaaa 2>&1) && code=0 || code=$?
check "drop by name refused while its servers run" "$code" 1
[[ "$(cat "$fx/calls")" != *DROP* ]] || { echo "FAIL: dropped an orphan whose servers run"; fail=1; }
unset -f psql_admin branch_pids container_state live_worktree_databases docker
# shellcheck source=SCRIPTDIR/dev-branch-servers.sh
source "$script"

# --- Kafka topics and groups, and Redis indexes, left behind ----------------------------------

# A drop that skipped Kafka or Redis (its container stopped) leaves them once its database is
# gone. kafka_owner is the one rule orphans and drop use to tell a branch's topic or group
# ($db-<name>, as start names them) from the shared servers' own and from lookalikes.
b=codebite_feat_x_0a1b2c3d
check "a branch's topic" "$(kafka_owner "$b-submission-events")" "$b"
check "a branch's group" "$(kafka_owner "$b-codebite-worker")" "$b"
check "a branch whose name ends like a hash" "$(kafka_owner codebite_a_12345678_deadbeef-x)" codebite_a_12345678_deadbeef
for name in submission-events submission-events-admin submission-results github-imports \
  codebite-worker codebite-worker-admin codebite-stats codebite-streaks codebite-github-imports \
  codebite-solution-commits codebite-sse-61514665-d682-4023-b3c2-f1a6c7730aff __consumer_offsets \
  "$b" "$b-" "${b}0-submission-events" "${b%?}-submission-events" codebite_feat_x_0A1B2C3D-x \
  codebite__x_0a1b2c3d-x codebite_0a1b2c3d-x codebite_Feat_0a1b2c3d-x "codebite_fé_0a1b2c3d-x" \
  "codebite_feat x_0a1b2c3d-x" "x$b-submission-events" "codebite_$(printf 'a%.0s' {1..46})_0a1b2c3d-x"; do
  check "'$name' is no branch's" "$(kafka_owner "$name")" ""
done

# The fixture: databases that exist, Kafka topics and groups, and each Redis index's owner key.
# codebite_gone_33333333 and codebite_a_12345678 are gone and left things; codebite_kept_22222222
# exists, codebite_wt_44444444 is gone but a live worktree's, and the rest are the shared servers'
# own or lookalikes.
fx="$fake/leftovers"
fake_psql_admin
reset_fixture() {
  rm -rf "$fx"; mkdir -p "$fx"
  printf '%s\n' postgres codebite codebite_orphan_11111111 codebite_kept_22222222 \
    codebite_a_12345678_deadbeef > "$fx/databases"
  printf 'codebite_orphan_11111111\t%s\ncodebite_kept_22222222\t%s\n' "$fake/gone-wt" "$fake/live-wt" > "$fx/owned"
  printf '%s\n' submission-events submission-events-admin submission-results github-imports \
    codebite_gone_33333333-submission-events codebite_gone_33333333-github-imports \
    codebite_kept_22222222-submission-events codebite_kept_222222220-submission-events \
    codebite_a_12345678-submission-events codebite_a_12345678_deadbeef-submission-events \
    codebite_wt_44444444-submission-events > "$fx/topics"
  printf '%s\n' codebite-worker codebite-stats codebite-sse-61514665-d682-4023-b3c2-f1a6c7730aff \
    codebite_gone_33333333-codebite-worker codebite_kept_22222222-codebite-worker > "$fx/groups"
  echo codebite_gone_33333333 > "$fx/redis-0"         # the shared backend's: never read or flushed
  echo codebite_gone_33333333 > "$fx/redis-1"
  echo codebite_kept_22222222 > "$fx/redis-2"
  echo codebite > "$fx/redis-3"                       # not a branch database's name
  echo "codebite_gone_33333333 x" > "$fx/redis-4"
  echo codebite_wt_44444444 > "$fx/redis-5"
  echo codebite_a_12345678 > "$fx/redis-7"
  : > "$fx/calls"
}
kafka_bin() {
  local f="$fx/groups"
  echo "kafka $*" >> "$fx/calls"
  [[ "$1" == kafka-topics.sh ]] && f="$fx/topics"
  case "$2" in
    --list) cat "$f" ;;
    --delete) { echo "$4" | tr , '\n' | grep -vxFf - "$f" || true; } > "$f.new"; mv "$f.new" "$f" ;;
  esac
}
redis_cmd() {
  echo "redis $*" >> "$fx/calls"
  [[ "$1" == 0 ]] && echo "$*" >> "$fx/redis0-touched"
  case "$2" in
    GET) cat "$fx/redis-$1" 2>/dev/null || echo ;;
    FLUSHDB) rm -f "$fx/redis-$1"; echo OK ;;
  esac
}
pg_state=running kafka_state=running redis_state=running
container_state() {
  case "$1" in codebite-kafka) echo "$kafka_state" ;; codebite-redis) echo "$redis_state" ;; *) echo "$pg_state" ;; esac
}
docker() { echo "docker $*" >> "$fx/calls"; }
live_worktree_databases() { printf '%s\n' codebite_kept_22222222 codebite_wt_44444444; }
branch_pids() { :; }
state_base="$fake/leftover-states"
shared_topics="submission-events
submission-events-admin
submission-results
github-imports"
untouched() {  # what no drop here may delete: all but the two gone databases' topics and groups
  [[ "$(cat "$fx/topics")" == "$shared_topics
codebite_kept_22222222-submission-events
codebite_kept_222222220-submission-events
codebite_a_12345678_deadbeef-submission-events
codebite_wt_44444444-submission-events" \
    && "$(cat "$fx/groups")" == "codebite-worker
codebite-stats
codebite-sse-61514665-d682-4023-b3c2-f1a6c7730aff
codebite_kept_22222222-codebite-worker" \
    && "$(cat "$fx/redis-0" "$fx/redis-2" "$fx/redis-3" "$fx/redis-4" "$fx/redis-5")" == "codebite_gone_33333333
codebite_kept_22222222
codebite
codebite_gone_33333333 x
codebite_wt_44444444" && ! -f "$fx/redis0-touched" ]]
}

reset_fixture
check "what gone databases left" "$(orphan_leftovers | LC_ALL=C sort)" "codebite_a_12345678	redis 7
codebite_a_12345678	topic
codebite_gone_33333333	group
codebite_gone_33333333	redis 1
codebite_gone_33333333	topic
codebite_gone_33333333	topic"
out=$(cmd_orphans 2>&1) && code=0 || code=$?
check "orphans lists what gone databases left" "$code
$out" "0
branch databases whose worktree is gone:
  codebite_orphan_11111111  (was $fake/gone-wt)
branch databases already dropped whose Kafka topics or Redis index are left:
  codebite_a_12345678  (1 Kafka topic, Redis index 7)
  codebite_gone_33333333  (2 Kafka topics, 1 Kafka group, Redis index 1)
drop one, with its Kafka topics and Redis index: scripts/dev-branch-servers.sh drop <name>"
[[ ! -f "$fx/redis0-touched" ]] || { echo "FAIL: orphans read Redis index 0"; fail=1; }
# orphans --count is that list as one number for dev-status: each database once, whatever it left.
out=$(cmd_orphans_count 2>&1) && code=0 || code=$?
check "orphans --count counts each database once" "$code
$out" "0
3"

# drop <name> takes only a name orphans lists: never a live database or worktree's, a lookalike,
# a shared name, an owner key's odd value, a pattern, or a listed name on a line of several.
for name in codebite_kept_22222222 codebite_wt_44444444 codebite_a_12345678_deadbeef \
  codebite_kept_222222220 codebite submission-events codebite-worker codebite_zz_99999999 \
  'codebite_gone_33333333 x' 'codebite_gone_3333333.' '.*' 'codebite_gone_33333333-submission-events' \
  $'x\ncodebite_gone_33333333' $'codebite_gone_33333333\ncodebite_kept_22222222' $'codebite_orphan_11111111\nx'; do
  reset_fixture
  out=$(cmd_drop_orphan "$name" 2>&1) && code=0 || code=$?
  check "drop '$name' refused" "$code" 1
  [[ "$(cat "$fx/calls")" != *DROP* && "$(cat "$fx/calls")" != *--delete* && "$(cat "$fx/calls")" != *FLUSHDB* ]] \
    || { echo "FAIL: drop '$name' deleted something: $(cat "$fx/calls")"; fail=1; }
done

reset_fixture
mkdir -p "$state_base/codebite_gone_33333333"
out=$(cmd_drop_orphan codebite_gone_33333333 2>&1) && code=0 || code=$?
check "drop a gone database's leftovers by name" "$code
$out" "0
database codebite_gone_33333333: none (dropped before)
Kafka topics: deleted codebite_gone_33333333-submission-events codebite_gone_33333333-github-imports
Kafka groups: deleted codebite_gone_33333333-codebite-worker
Redis database 1: flushed"
[[ "$(cat "$fx/calls")" != *DROP* ]] || { echo "FAIL: drop of a gone database's leftovers dropped a database"; fail=1; }
[[ ! -f "$fx/redis-1" && "$(cat "$fx/redis-7")" == codebite_a_12345678 ]] || { echo "FAIL: drop flushed the wrong Redis index"; fail=1; }
[[ ! -d "$state_base/codebite_gone_33333333" ]] || { echo "FAIL: drop left the state directory"; fail=1; }
out=$(cmd_drop_orphan codebite_a_12345678 2>&1) && code=0 || code=$?
check "drop a database that is a prefix of another's name" "$code
$out" "0
database codebite_a_12345678: none (dropped before)
Kafka topics: deleted codebite_a_12345678-submission-events
Redis database 7: flushed"
untouched || { echo "FAIL: drop deleted another's: $(cat "$fx/topics" "$fx/groups" "$fx/redis-"*)"; fail=1; }
check "once dropped, orphans lists the database only" "$(cmd_orphans 2>&1)" "branch databases whose worktree is gone:
  codebite_orphan_11111111  (was $fake/gone-wt)
drop one, with its Kafka topics and Redis index: scripts/dev-branch-servers.sh drop <name>"
check "kafka_names_of never takes an empty database for one" "$(kafka_names_of kafka-topics.sh '')" ""

# A database lookup that fails, or answers without the postgres database every server has, is no
# "none exist": read so, an existing database's topics and Redis index would be listed and deleted.
# codebite_a_12345678_deadbeef exists, is no live worktree's and has a topic.
lookup_failed="dev-branch-servers.sh: couldn't list the databases in codebite-postgres; rerun"
for broken in fails empty; do
  for cmd in cmd_orphans 'cmd_drop_orphan codebite_a_12345678_deadbeef' 'cmd_drop_orphan codebite_gone_33333333'; do
    reset_fixture
    if [[ $broken == fails ]]; then psql_fails=1; else : > "$fx/databases"; fi
    # shellcheck disable=SC2086  # the name is a word of its own
    out=$($cmd 2>&1) && code=0 || code=$?
    psql_fails=""
    [[ "$code" == 1 && "$out" == *"$lookup_failed"* && "$out" != *codebite_a_12345678_deadbeef* ]] \
      || { echo "FAIL: $cmd when the database lookup $broken: $code $out"; fail=1; }
    [[ "$(cat "$fx/calls")" != *DROP* && "$(cat "$fx/calls")" != *--delete* && "$(cat "$fx/calls")" != *FLUSHDB* ]] \
      || { echo "FAIL: $cmd when the database lookup $broken deleted something: $(cat "$fx/calls")"; fail=1; }
  done
done

# With Kafka or Redis stopped, orphans says in one line where it didn't look, and lists the rest.
reset_fixture
kafka_state=stopped
out=$(cmd_orphans 2>&1)
check "orphans with Kafka stopped" "$out" "branch databases whose worktree is gone:
  codebite_orphan_11111111  (was $fake/gone-wt)
branch databases already dropped whose Kafka topics or Redis index are left:
  codebite_a_12345678  (Redis index 7)
  codebite_gone_33333333  (Redis index 1)
drop one, with its Kafka topics and Redis index: scripts/dev-branch-servers.sh drop <name>
Kafka topics and groups not looked at: the codebite-kafka container isn't running; start it: docker compose -f infra/docker-compose.yml up -d kafka"
[[ "$(cat "$fx/calls")" != *kafka\ * ]] || { echo "FAIL: orphans asked a stopped Kafka: $(cat "$fx/calls")"; fail=1; }
kafka_state=running redis_state=stopped
check "orphans with Redis stopped" "$(cmd_orphans 2>&1)" "branch databases whose worktree is gone:
  codebite_orphan_11111111  (was $fake/gone-wt)
branch databases already dropped whose Kafka topics or Redis index are left:
  codebite_a_12345678  (1 Kafka topic)
  codebite_gone_33333333  (2 Kafka topics, 1 Kafka group)
drop one, with its Kafka topics and Redis index: scripts/dev-branch-servers.sh drop <name>
Redis indexes not looked at: the codebite-redis container isn't running; start it: docker compose -f infra/docker-compose.yml up -d redis"
redis_state=running
printf '%s\n' "${shared_topics}" > "$fx/topics"; : > "$fx/groups"; rm -f "$fx"/redis-[1-9]*
: > "$fx/owned"
check "orphans with nothing left" "$(cmd_orphans 2>&1)" \
  "no branch database outlives its worktree, and no dropped one left Kafka topics or a Redis index"
check "orphans --count with nothing left" "$(cmd_orphans_count 2>&1)" 0
kafka_state=stopped
check "orphans with nothing found and Kafka stopped claims nothing about Kafka" "$(cmd_orphans 2>&1)" \
  "nothing found: no branch database outlives its worktree, and no dropped one left what could be looked at
Kafka topics and groups not looked at: the codebite-kafka container isn't running; start it: docker compose -f infra/docker-compose.yml up -d kafka"
kafka_state=running

# With Postgres or the Docker daemon down, orphans and drop say so, in one line, and exit 1:
# not a docker error followed by "none".
pg_state=stopped
for cmd in cmd_orphans cmd_orphans_count cmd_drop 'cmd_drop_orphan codebite_gone_33333333'; do
  # shellcheck disable=SC2086  # the name is a word of its own
  out=$(root=/work/wt-x; $cmd 2>&1) && code=0 || code=$?
  check "$cmd with Postgres stopped" "$code
$out" "1
dev-branch-servers.sh: the codebite-postgres container isn't running; start it: docker compose -f infra/docker-compose.yml up -d postgres"
done
pg_state=daemon kafka_state=daemon redis_state=daemon
out=$(cmd_orphans 2>&1) && code=0 || code=$?
check "orphans with the daemon down" "$code
$out" "1
dev-branch-servers.sh: the Docker daemon doesn't answer; start Docker Desktop (open -a Docker) and rerun"
pg_state=running kafka_state=running redis_state=running
docker() { [[ "$*" != *pg_isready* ]]; }
out=$(cmd_orphans 2>&1) && code=0 || code=$?
check "orphans while Postgres starts" "$code
$out" "1
dev-branch-servers.sh: codebite-postgres runs but doesn't accept connections yet; rerun in a few seconds"
docker() { echo "docker $*" >> "$fx/calls"; }

# Plain drop in a worktree whose drop skipped Kafka and Redis: the rerun finds them by its own
# name though the database and state directory are gone; with nothing left it says so.
reset_fixture
root=/work/wt-gone
use_database codebite_gone_33333333
# A lookup of this worktree's database that fails is not "none": its topics and index stay.
psql_fails=1
out=$(cmd_drop 2>&1) && code=0 || code=$?
psql_fails=""
check "plain drop when the database lookup fails" "$code
$out" "1
dev-branch-servers.sh: couldn't look up database codebite_gone_33333333 in codebite-postgres; rerun"
[[ "$(cat "$fx/calls")" != *--delete* && "$(cat "$fx/calls")" != *FLUSHDB* ]] \
  || { echo "FAIL: plain drop deleted something after a failed lookup: $(cat "$fx/calls")"; fail=1; }
out=$(cmd_drop 2>&1) && code=0 || code=$?
check "a rerun of drop finds what the first left" "$code
$out" "0
database codebite_gone_33333333: none
Kafka topics: deleted codebite_gone_33333333-submission-events codebite_gone_33333333-github-imports
Kafka groups: deleted codebite_gone_33333333-codebite-worker
Redis database 1: flushed"
use_database codebite_nothing_55555555
check "drop with nothing anywhere" "$(cmd_drop 2>&1)" "database codebite_nothing_55555555: none; nothing to drop"
# A plain drop that skips Kafka and Redis names the later command for both cases: this worktree
# still there, or gone (as after scripts/ship-branch.sh).
reset_fixture
use_database codebite_mine_66666666
echo "x$(db_owner_comment /work/wt-gone)" > "$fx/db-state"
kafka_state=stopped redis_state=stopped
check "plain drop's skip lines name the later command" "$(cmd_drop 2>&1)" "database codebite_mine_66666666: dropped
codebite-kafka isn't running: topics and groups prefixed codebite_mine_66666666 left behind; once it runs: scripts/dev-branch-servers.sh drop in this worktree, or drop codebite_mine_66666666 once the worktree is gone
codebite-redis isn't running: the Redis index of codebite_mine_66666666 left claimed; once it runs: scripts/dev-branch-servers.sh drop in this worktree, or drop codebite_mine_66666666 once the worktree is gone"
kafka_state=running redis_state=running
unset -f psql_admin kafka_bin redis_cmd container_state docker live_worktree_databases branch_pids reset_fixture untouched
# shellcheck source=SCRIPTDIR/dev-branch-servers.sh
source "$script"

# --- one live set at a time (start --wait) ------------------------------------------------------

# Fakes: the repository has this worktree (codebite_mine) and /work/wt-b (codebite_theirs); pgrep
# finds pid 501 under /work/wt-b while $fx/theirs-live exists, and pid 601 under /work/wt-gone, a
# worktree no longer there, always. require_postgres, the first thing a start does once it goes
# ahead, notes that it started and ends the start with exit 7. Each start is a subshell.
fx="$fake/slot"
mkdir -p "$fx"
state_base="$fake/slot-states" port_locks="$fake/slot-locks" root=/work/wt-a
use_database codebite_mine
worktree_databases() { printf 'codebite_master\t/work/main\ncodebite_mine\t/work/wt-a\ncodebite_theirs\t/work/wt-b\n'; }
pgrep() {
  case "$2" in
    /work/wt-b/*) if [[ -f "$fx/theirs-live" ]]; then echo 501; fi ;;
    /work/wt-gone/*) echo 601 ;;
  esac
}
env_value() { case "$1" in 501) echo codebite_theirs ;; 601) echo codebite_gone ;; *) echo ;; esac; }
require_postgres() { echo started >> "$fx/started"; exit 7; }
export CODEBITE_BRANCH_SERVERS_POLL=0.05 CODEBITE_BRANCH_SERVERS_WAIT=30
waiting_line="dev-branch-servers.sh: waiting for the branch servers of /work/wt-b to stop (one live set at a time)"

# Another worktree's set live: start --wait starts nothing, naming it once, until it stops.
touch "$fx/theirs-live"
(cmd_start --wait) > "$fx/out" 2>&1 &
waiter=$!
command sleep 0.5
check "start --wait starts nothing while another set is live" "$(cat "$fx/started" 2>/dev/null)" ""
check "start --wait names the worktree it waits for, once" "$(cat "$fx/out")" "$waiting_line"
rm "$fx/theirs-live"
wait "$waiter" && code=0 || code=$?
check "start --wait starts once that set stops" "$code $(cat "$fx/started" 2>/dev/null)" "7 started"
check "start --wait says nothing more" "$(cat "$fx/out")" "$waiting_line"
check "the start that goes ahead claims the slot" "$(cat "$state/start.pid")" "$$"

# Without --wait, start goes ahead beside a live set, as before.
touch "$fx/theirs-live"; rm -f "$fx/started"
out=$( (cmd_start) 2>&1) && code=0 || code=$?
check "start without --wait doesn't wait" "$code $(cat "$fx/started" 2>/dev/null)/$out" "7 started/"

# The bound running out: exit 1, one more line naming the set and the command that stops it.
rm -f "$fx/started"
out=$( (CODEBITE_BRANCH_SERVERS_WAIT=0.2; cmd_start --wait) 2>&1) && code=0 || code=$?
check "start --wait gives up after the bound" "$code
$out" "1
$waiting_line
dev-branch-servers.sh: the branch servers of /work/wt-b (codebite_theirs) are still live after 0.2s; stop them: (cd /work/wt-b && scripts/dev-branch-servers.sh stop)"
check "a start that gave up started nothing" "$(cat "$fx/started" 2>/dev/null)" ""
rm "$fx/theirs-live"

# What doesn't hold the slot: a set whose processes are dead (its state and its start's pid left
# behind), a pid of a dead start that another process now has, and the running servers of a
# worktree that is gone.
sh -c 'exit 0' & wait $!; dead=$!
sh -c 'sleep 30; :' & reused=$!
mkdir -p "$state_base/codebite_theirs" "$state_base/codebite_gone"
for pid in "$dead" "$reused"; do
  echo "$pid" > "$state_base/codebite_theirs/start.pid"
  rm -f "$fx/started"
  out=$( (cmd_start --wait) 2>&1) && code=0 || code=$?
  check "a dead set doesn't hold the slot (start.pid $pid)" "$code $(cat "$fx/started" 2>/dev/null)/$out" "7 started/"
done
{ kill "$reused"; wait "$reused"; } 2>/dev/null || true
check "a gone worktree's servers do run" "$(db=codebite_gone root=/work/wt-gone branch_pids | sort -u)" 601
check "no other set is live" "$(other_live_set)" ""

# A start still on its way up (no app process yet) holds the slot by its start.pid: of two starts
# with --wait at once, in two worktrees, the second starts only after the first is gone. Each is
# a process of its own, as a start is, whose "servers" run for half a second.
rm -rf "$state_base"; : > "$fx/order"
for name in mine theirs; do
  bash -c '
    source "$1"; fx=$2 state_base=$3 port_locks=$4 root=/work/wt-$5
    use_database "codebite_$5"
    worktree_databases() { printf "codebite_mine\t/work/wt-mine\ncodebite_theirs\t/work/wt-theirs\n"; }
    pgrep() { :; }
    require_postgres() { echo "$db up" >> "$fx/order"; sleep 0.5; echo "$db down" >> "$fx/order"; exit 0; }
    cmd_start --wait' _ "$script" "$fx" "$state_base" "$port_locks" "$name" > "$fx/race-$name" 2>&1 &
done
wait
check "two waiting starts go one after the other" \
  "$(sed 's/codebite_[a-z]*/a set/' "$fx/order" | paste -sd, -)" "a set up,a set down,a set up,a set down"
check "both waiting starts started" "$(sort "$fx/order" | paste -sd, -)" \
  "codebite_mine down,codebite_mine up,codebite_theirs down,codebite_theirs up"
check "one of them waited for the other" "$(cat "$fx"/race-* | grep -c 'waiting for the branch servers of /work/wt-')" 1
unset -f worktree_databases pgrep env_value require_postgres
unset CODEBITE_BRANCH_SERVERS_POLL CODEBITE_BRANCH_SERVERS_WAIT
# shellcheck source=SCRIPTDIR/dev-branch-servers.sh
source "$script"

# --- the main checkout ------------------------------------------------------------------------

# A throwaway repository with a worktree: the script must refuse everything but name and status
# in its main checkout, and must not refuse in the worktree.
repo="$fake/repo"
git init -q -b master "$repo"
git -C "$repo" -c user.name=t -c user.email=t@t -c core.hooksPath=/dev/null commit -q --allow-empty -m init
git -C "$repo" worktree add -q "$fake/wt" -b feat/x
# Should the refusal break, these stubs keep the run off the real containers and processes.
mkdir -p "$fake/bin"
for tool in docker pgrep kill; do
  printf '#!/bin/sh\necho "%s $*" >> "%s/escaped"; exit 1\n' "$tool" "$fake" > "$fake/bin/$tool"
  chmod +x "$fake/bin/$tool"
done
for cmd in start 'start --detach' 'start --wait' 'start --wait --detach' 'start --detach --wait' restart stop drop migrate; do
  # shellcheck disable=SC2086  # 'start --detach' is two words
  out=$(cd "$repo" && PATH="$fake/bin:$PATH" "$script" $cmd 2>&1) && code=0 || code=$?
  check "$cmd refused in the main checkout" "$code" 1
  [[ "$out" == *"is the main checkout"* ]] || { echo "FAIL: $cmd: no refusal message: $out"; fail=1; }
done
[[ ! -f "$fake/escaped" ]] || { echo "FAIL: ran past the refusal: $(cat "$fake/escaped")"; fail=1; }
out=$(cd "$repo" && PATH="$fake/bin:$PATH" "$script" drop codebite_x 2>&1) || true
[[ "$out" != *"is the main checkout"* ]] || { echo "FAIL: drop <name> refused in the main checkout: $out"; fail=1; }
out=$(cd "$repo" && PATH="$fake/bin:$PATH" "$script" orphans 2>&1) || true
[[ "$out" != *"is the main checkout"* ]] || { echo "FAIL: orphans refused in the main checkout: $out"; fail=1; }
rm -f "$fake/escaped"
out=$(cd "$repo" && "$script" name)
[[ "$out" == codebite_master_* ]] || { echo "FAIL: name in the main checkout printed '$out'"; fail=1; }
check "worktree name" "$(cd "$fake/wt" && "$script" name)" \
  "$(branch_db_name feat/x "$(cd "$fake/wt" && git rev-parse --show-toplevel)")"
(cd "$fake/wt" && setup && [[ "$root" != "$main" ]]) || { echo "FAIL: a worktree taken for the main checkout"; fail=1; }

# The live worktrees' databases, each named as name names it there (a detached one by its
# directory), from any checkout; a worktree whose directory is gone has none.
git -C "$repo" worktree add -q "$fake/wt-removed" -b feat/removed
git -C "$repo" worktree add -q --detach "$fake/wt-detached"
rm -rf "$fake/wt-removed"
check "live worktrees' databases" "$(cd "$fake/wt" && setup && live_worktree_databases)" \
  "$(cd "$repo" && "$script" name)
$(cd "$fake/wt" && "$script" name)
$(cd "$fake/wt-detached" && "$script" name)"
check "each with its worktree" "$(cd "$fake/wt" && setup && worktree_databases | cut -f2)" \
  "$(for d in "$repo" "$fake/wt" "$fake/wt-detached"; do git -C "$d" rev-parse --show-toplevel; done)"

out=$("$script" bogus 2>&1) && code=0 || code=$?
check "unknown subcommand" "$code" 2
for cmd in '[start [--detach]]' 'start --wait [--detach]' restart stop status migrate 'drop [<name>]' orphans 'orphans --count' name; do
  [[ "$out" == *"dev-branch-servers.sh $cmd"* ]] || { echo "FAIL: usage lacks $cmd: $out"; fail=1; }
done

# In the stubbed main checkout, so a broken check can't start real servers.
out=$(cd "$repo" && PATH="$fake/bin:$PATH" "$script" start --bogus 2>&1) && code=0 || code=$?
check "unknown start option" "$code" 2
for cmd in 'start --wait --bogus' 'start --wait --detach --wait' 'restart --wait'; do
  # shellcheck disable=SC2086  # several words
  out=$(cd "$repo" && PATH="$fake/bin:$PATH" "$script" $cmd 2>&1) && code=0 || code=$?
  check "$cmd is a usage error" "$code" 2
done

# --- a detached start ---------------------------------------------------------------------------

# await_detached returns once the start it watches prints its summary, and fails, showing the log,
# once that start dies first.
log="$fake/start.log"
sh -c 'echo "backend: up"; sleep 0.3; echo "Branch servers for feat/x:"; sleep 30' > "$log" 2>&1 &
up=$!
out=$(await_detached "$up" "$log" 2>&1) && code=0 || code=$?
{ kill "$up"; wait "$up"; } 2>/dev/null || true
check "detached start up" "$code" 0
[[ "$out" == *"Branch servers for feat/x:"* ]] || { echo "FAIL: a detached start should print the summary: $out"; fail=1; }
sh -c 'echo "backend: exited before it came up"; exit 1' > "$log" 2>&1 &
out=$(await_detached $! "$log" 2>&1) && code=0 || code=$?
check "detached start died" "$code" 1
[[ "$out" == *"exited before it came up"* ]] || { echo "FAIL: a failed detached start should show its log: $out"; fail=1; }
# A detached start that waits for another worktree's servers: the line saying whose is passed on
# while it waits (stderr), and not printed again with the log.
waiting_line="$WAITING_PREFIX /work/wt-b to stop (one live set at a time)"
sh -c 'echo "$1"; sleep 2.5; echo "Branch servers for feat/x:"; sleep 30' _ "$waiting_line" > "$log" 2>&1 &
up=$!
await_detached "$up" "$log" > "$fake/detached.out" 2> "$fake/detached.err" &
command sleep 1.5
check "a detached start passes on whose servers it waits for" "$(cat "$fake/detached.err")" "$waiting_line"
wait $! && code=0 || code=$?
{ kill "$up"; wait "$up"; } 2>/dev/null || true
check "a detached start that waited is up" "$code $(cat "$fake/detached.out")" "0 Branch servers for feat/x:"
check "the waiting line is printed once" "$(cat "$fake/detached.err")" "$waiting_line"
sh -c 'echo "$1"; sleep 1.5; echo "$2"; exit 1' _ "$waiting_line" "dev-branch-servers.sh: the branch servers of /work/wt-b are still live" > "$log" 2>&1 &
out=$(await_detached $! "$log" 2>&1) && code=0 || code=$?
check "a detached start that gave up" "$code
$out" "1
$waiting_line
dev-branch-servers.sh: the branch servers of /work/wt-b are still live"

# --- Judge0 -----------------------------------------------------------------------------------

# A dev Judge0 URL (a Tailscale name, a LAN address) reaches the branch servers; the production
# one (infra/.env's http://judge0:2358, a compose service name) and none fall back to the dev default.
check "dev URL kept" "$(dev_judge0_url http://nucbox:2358)" http://nucbox:2358
check "LAN URL kept" "$(dev_judge0_url http://192.168.219.200:2358)" http://192.168.219.200:2358
check "production URL dropped" "$(dev_judge0_url http://judge0:2358)" ""
check "unset stays unset" "$(dev_judge0_url '')" ""

(( fail )) && exit 1
[[ -s "$unknown_queries" ]] && exit 1
echo "PASS: dev-branch-servers.sh names, ownership, Redis claim, process matching, ports, one live set at a time, main-checkout refusal, detached start, Judge0 URL"
