#!/usr/bin/env bash
# Checks the pure parts of scripts/dev-branch-servers.sh: the branch database name (which also
# prefixes its Kafka topics and groups), the Redis index and the port picking.
set -euo pipefail

# shellcheck source=SCRIPTDIR/dev-branch-servers.sh
source "$(dirname "$0")/dev-branch-servers.sh"

fail=0
check() { [[ "$2" == "$3" ]] || { echo "FAIL: $1: expected '$3', got '$2'"; fail=1; }; }

check "slashes and dashes" "$(branch_db_name chore/dev-branch-backend)" codebite_chore_dev_branch_backend
check "case and runs" "$(branch_db_name 'Feat//Foo--Bar.2')" codebite_feat_foo_bar_2
check "edges trimmed" "$(branch_db_name '-x-')" codebite_x
check "never the shared database" "$(branch_db_name '')" codebite_detached
check "never the shared database" "$(branch_db_name '///')" codebite_detached
long=$(branch_db_name "feat/$(printf 'a%.0s' {1..80})")
check "PostgreSQL's 63-character limit" "${#long}" 63
check "no trailing underscore after the cut" "$(branch_db_name "feat/$(printf 'a%.0s' {1..48})_b")" \
  "codebite_feat_$(printf 'a%.0s' {1..48})"

for name in codebite_a codebite_b codebite_chore_dev_branch_backend; do
  i=$(redis_index "$name")
  (( i >= 1 && i <= 15 )) || { echo "FAIL: redis index $i for $name is outside 1-15"; fail=1; }
  check "redis index is stable" "$(redis_index "$name")" "$i"
done

busy=" 18080 18081 "
port_busy() { [[ "$busy" == *" $1 "* ]]; }
check "skips busy ports" "$(first_free_port 18080 18179)" 18082
check "never a shared server's port, even when free" "$(first_free_port 8080 8082)" 8082
check "never a shared server's port, even when free" "$(first_free_port 5173 5175)" 5175
if first_free_port 18080 18081 2>/dev/null; then echo "FAIL: a full range must fail"; fail=1; fi

(( fail )) && exit 1
echo "PASS: dev-branch-servers.sh names, Redis index and ports"
