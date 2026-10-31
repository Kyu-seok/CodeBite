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

busy=" 18080 18081 "
port_busy() { [[ "$busy" == *" $1 "* ]]; }
check "skips busy ports" "$(first_free_port 18080 18179)" 18082
check "never a shared server's port, even when free" "$(first_free_port 8080 8082)" 8082
check "never a shared server's port, even when free" "$(first_free_port 5173 5175)" 5175
if first_free_port 18080 18081 2>/dev/null; then echo "FAIL: a full range must fail"; fail=1; fi

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
for cmd in start stop drop; do
  out=$(cd "$repo" && PATH="$fake/bin:$PATH" "$script" "$cmd" 2>&1) && code=0 || code=$?
  check "$cmd refused in the main checkout" "$code" 1
  [[ "$out" == *"is the main checkout"* ]] || { echo "FAIL: $cmd: no refusal message: $out"; fail=1; }
done
[[ ! -f "$fake/escaped" ]] || { echo "FAIL: ran past the refusal: $(cat "$fake/escaped")"; fail=1; }
out=$(cd "$repo" && "$script" name)
[[ "$out" == codebite_master_* ]] || { echo "FAIL: name in the main checkout printed '$out'"; fail=1; }
check "worktree name" "$(cd "$fake/wt" && "$script" name)" \
  "$(branch_db_name feat/x "$(cd "$fake/wt" && git rev-parse --show-toplevel)")"
(cd "$fake/wt" && setup && [[ "$root" != "$main" ]]) || { echo "FAIL: a worktree taken for the main checkout"; fail=1; }

out=$("$script" bogus 2>&1) && code=0 || code=$?
check "unknown subcommand" "$code" 2
for cmd in '[start]' stop status drop name; do
  [[ "$out" == *"dev-branch-servers.sh $cmd"* ]] || { echo "FAIL: usage lacks $cmd: $out"; fail=1; }
done

(( fail )) && exit 1
echo "PASS: dev-branch-servers.sh names, ownership, Redis claim, process matching, ports, main-checkout refusal"
