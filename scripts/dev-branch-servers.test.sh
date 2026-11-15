#!/usr/bin/env bash
# Checks scripts/dev-branch-servers.sh without Docker or running servers: the branch database name
# (which also prefixes its Kafka topics and groups) and its ownership, the Redis index claim, which
# processes it would stop, the port picking, and that it refuses to run from the main checkout.
set -euo pipefail

script="$(cd "$(dirname "$0")" && pwd)/dev-branch-servers.sh"
# shellcheck source=SCRIPTDIR/dev-branch-servers.sh
source "$script"

fail=0
check() { [[ "$2" == "$3" ]] || { echo "FAIL: $1: expected '$3', got '$2'"; fail=1; }; }
fake=$(mktemp -d)
trap 'rm -rf "$fake"' EXIT

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
[[ ! -d "$port_locks/.mutex" ]] || { echo "FAIL: the port mutex was left behind"; fail=1; }

# --- who listens on a port ----------------------------------------------------------------------

# Fakes: 18080 is ours (pid 101), 18180 another worktree's (103), 15180 a stray process (104),
# 18081 nobody's.
port_listeners() {
  case "$1" in 18080) echo 101 ;; 18180) echo 103 ;; 15180) echo 104 ;; esac
}
env_value() {
  case "$1" in 101) echo "$db" ;; 103) echo codebite_theirs ;; *) echo ;; esac
}
process_name() { echo node; }
check "our listener" "$(port_listener 18080)" ours
check "no listener" "$(port_listener 18081)" none
check "another worktree's listener" "$(port_listener 18180)" "pid 103, the branch servers of codebite_theirs"
check "a stray listener" "$(port_listener 15180)" "pid 104 (node), not a branch server"

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
port_listeners() { case "$1" in 18080 | 18180 | 15180) echo 101 ;; esac; }
printf 'backend_port=18080\nworker_port=18180\nvite_port=15180\nredis_db=3\n' > "$state/ports"
out=$(cmd_status) && code=0 || code=$?
check "status when all three are up" "$code" 0
[[ "$out" == *"http://127.0.0.1:18080/api"* ]] || { echo "FAIL: status should print the summary: $out"; fail=1; }
port_listeners() { case "$1" in 18080) echo 101 ;; esac; }
out=$(cmd_status) && code=0 || code=$?
check "status while starting" "$code" 1
[[ "$out" == *"worker: nothing listens on 18180 yet"* ]] || { echo "FAIL: status should name the app not up: $out"; fail=1; }
port_listeners() { case "$1" in 18080 | 18180) echo 101 ;; 15180) echo 103 ;; esac; }
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
unset -f branch_pids port_listeners env_value process_name curl kill
# shellcheck source=SCRIPTDIR/dev-branch-servers.sh
source "$script"

# --- migrate ----------------------------------------------------------------------------------

# migrate creates the branch database as start does (with this worktree's COMMENT), runs Flyway
# on it through Gradle, and starts nothing; it refuses another worktree's database.
root=/work/wt-a db=codebite_mine
: > "$fake/calls"
docker() { echo "docker $*" >> "$fake/calls"; }
psql_admin() { echo "psql $1" >> "$fake/calls"; [[ "$1" == SELECT* ]] && cat "$fake/db-state" 2>/dev/null; return 0; }
run_flyway() { echo "flyway $1" >> "$fake/calls"; }
flyway_version() { echo 260; }
rm -f "$fake/db-state"
out=$(cmd_migrate 2>&1) && code=0 || code=$?
check "migrate a new database" "$code" 0
calls=$(cat "$fake/calls")
[[ "$calls" == *"psql CREATE DATABASE \"codebite_mine\""* ]] || { echo "FAIL: migrate should create the database: $calls"; fail=1; }
[[ "$calls" == *"COMMENT ON DATABASE \"codebite_mine\" IS 'codebite-dev-branch:/work/wt-a'"* ]] \
  || { echo "FAIL: migrate should mark the database this worktree's: $calls"; fail=1; }
[[ "$calls" == *"flyway jdbc:postgresql://localhost:5433/codebite_mine"* ]] || { echo "FAIL: migrate should run Flyway on it: $calls"; fail=1; }
[[ "$out" == *"CODEBITE_DB=codebite_mine"* && "$out" == *"at V260"* ]] || { echo "FAIL: migrate should print the database and its version: $out"; fail=1; }
: > "$fake/calls"
echo "x$(db_owner_comment /work/wt-a)" > "$fake/db-state"
cmd_migrate >/dev/null 2>&1 || { echo "FAIL: migrate on its own database"; fail=1; }
[[ "$(cat "$fake/calls")" != *CREATE* && "$(cat "$fake/calls")" == *flyway* ]] || { echo "FAIL: migrate on an existing database: $(cat "$fake/calls")"; fail=1; }
: > "$fake/calls"
echo "x$(db_owner_comment /work/wt-b)" > "$fake/db-state"
out=$(cmd_migrate 2>&1) && code=0 || code=$?
check "migrate refuses another worktree's database" "$code" 1
[[ "$(cat "$fake/calls")" != *flyway* ]] || { echo "FAIL: migrate ran Flyway on another worktree's database"; fail=1; }
unset -f docker psql_admin run_flyway flyway_version
# shellcheck source=SCRIPTDIR/dev-branch-servers.sh
source "$script"

# --- databases left behind ------------------------------------------------------------------------

# orphans lists the branch databases whose worktree is gone; drop <name> drops only such a one,
# with its Kafka topics and groups and Redis index, and only when none of its servers still run.
mkdir -p "$fake/live-wt"; state_base="$fake/state-base"
: > "$fake/calls"
psql_admin() {
  echo "psql $1" >> "$fake/calls"
  case "$1" in
    *shobj_description*LIKE*) printf 'codebite_gone_1\t%s\ncodebite_live_2\t%s\n' "$fake/gone-wt" "$fake/live-wt" ;;
  esac
  return 0
}
kafka_bin() {
  echo "kafka $*" >> "$fake/calls"
  case "$1 $2" in
    "kafka-topics.sh --list") printf 'codebite_gone_1-submission-events\ncodebite_live_2-submission-events\n' ;;
  esac
}
flush_owned_redis_index() { echo "redis flush $db" >> "$fake/calls"; }
branch_pids() { :; }
check "orphans lists a database whose worktree is gone" "$(orphan_databases)" "codebite_gone_1	$fake/gone-wt"
out=$(cmd_orphans)
[[ "$out" == *codebite_gone_1* && "$out" != *codebite_live_2* ]] || { echo "FAIL: orphans printed: $out"; fail=1; }
for name in codebite_live_2 codebite codebite_nope; do
  : > "$fake/calls"
  out=$(cmd_drop_orphan "$name" 2>&1) && code=0 || code=$?
  check "drop $name by name refused" "$code" 1
  [[ "$(cat "$fake/calls")" != *DROP* && "$(cat "$fake/calls")" != *delete* ]] \
    || { echo "FAIL: drop $name dropped something: $(cat "$fake/calls")"; fail=1; }
done
: > "$fake/calls"
out=$(cmd_drop_orphan codebite_gone_1 2>&1) && code=0 || code=$?
check "drop an orphan by name" "$code" 0
calls=$(cat "$fake/calls")
[[ "$calls" == *'DROP DATABASE IF EXISTS "codebite_gone_1"'* ]] || { echo "FAIL: the orphan wasn't dropped: $calls"; fail=1; }
[[ "$calls" == *"--delete --topic codebite_gone_1-submission-events"* && "$calls" != *"topic codebite_live_2"* ]] \
  || { echo "FAIL: drop should delete only the orphan's topics: $calls"; fail=1; }
[[ "$calls" == *"redis flush codebite_gone_1"* ]] || { echo "FAIL: drop should flush the orphan's Redis index: $calls"; fail=1; }
branch_pids() { echo 301; }
: > "$fake/calls"
out=$(cmd_drop_orphan codebite_gone_1 2>&1) && code=0 || code=$?
check "drop by name refused while its servers run" "$code" 1
[[ "$(cat "$fake/calls")" != *DROP* ]] || { echo "FAIL: dropped an orphan whose servers run"; fail=1; }
unset -f psql_admin kafka_bin flush_owned_redis_index branch_pids
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
for cmd in start 'start --detach' restart stop drop migrate; do
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

out=$("$script" bogus 2>&1) && code=0 || code=$?
check "unknown subcommand" "$code" 2
for cmd in '[start [--detach]]' restart stop status migrate 'drop [<name>]' orphans name; do
  [[ "$out" == *"dev-branch-servers.sh $cmd"* ]] || { echo "FAIL: usage lacks $cmd: $out"; fail=1; }
done

# In the stubbed main checkout, so a broken check can't start real servers.
out=$(cd "$repo" && PATH="$fake/bin:$PATH" "$script" start --bogus 2>&1) && code=0 || code=$?
check "unknown start option" "$code" 2

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

# --- Judge0 -----------------------------------------------------------------------------------

# A dev Judge0 URL (a Tailscale name, a LAN address) reaches the branch servers; the production
# one (infra/.env's http://judge0:2358, a compose service name) and none fall back to the dev default.
check "dev URL kept" "$(dev_judge0_url http://nucbox:2358)" http://nucbox:2358
check "LAN URL kept" "$(dev_judge0_url http://192.168.219.200:2358)" http://192.168.219.200:2358
check "production URL dropped" "$(dev_judge0_url http://judge0:2358)" ""
check "unset stays unset" "$(dev_judge0_url '')" ""

(( fail )) && exit 1
echo "PASS: dev-branch-servers.sh names, ownership, Redis claim, process matching, ports, main-checkout refusal, detached start, Judge0 URL"
