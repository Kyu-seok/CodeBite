#!/usr/bin/env bash
# Tests for scripts/check-commit-subjects.sh, in a scratch repository: it passes a range of short
# subjects, fails naming each commit over 72 characters, and leaves merge commits alone.
set -uo pipefail
script="$(cd "$(dirname "$0")" && pwd)/check-commit-subjects.sh"
repo=$(mktemp -d); trap 'rm -rf "$repo"' EXIT
g() { git -C "$repo" -c user.name=t -c user.email=t@t -c core.hooksPath=/dev/null "$@"; }
fail=0
check() { [[ "$2" == "$3" ]] || { echo "FAIL: $1: expected '$3', got '$2'"; fail=1; }; }

long73=$(printf 'feat: %s' "$(printf 'x%.0s' $(seq 67))")
g init -q -b main
g commit -q --allow-empty -m base
g switch -qc ticket
g commit -q --allow-empty -m 'fix: a short subject'
g commit -q --allow-empty -m "$(printf 'docs: short\n\n%s%s' "$long73" "$long73")"
(cd "$repo" && "$script" main..ticket) >/dev/null 2>&1
check "short subjects pass" $? 0

g commit -q --allow-empty -m "$long73"
bad=$(g rev-parse --short HEAD)
out=$(cd "$repo" && "$script" main..ticket 2>&1); status=$?
check "a long subject fails" $status 1
grep -q "$bad" <<<"$out" || { echo "FAIL: must name the commit $bad: $out"; fail=1; }

# A merge commit with a long subject (merge-ticket.sh writes ones of 75+ characters) is skipped.
g switch -q main
g switch -qc side
g commit -q --allow-empty -m 'fix: side'
g switch -q main
g switch -qc integration
g merge -q --no-ff -m "$(printf 'Merge ticket/301-a-long-ticket-branch-name: %s' "$(printf 'y%.0s' $(seq 40))")" side
check "the merge is a merge" "$(g rev-list --parents -1 HEAD | wc -w | tr -d ' ')" 3
(cd "$repo" && "$script" main..integration) >/dev/null 2>&1
check "merge commits are skipped" $? 0

(cd "$repo" && "$script" ticket..ticket) >/dev/null 2>&1
check "an empty range passes" $? 0

(( fail )) && exit 1
echo "PASS: check-commit-subjects.sh"
