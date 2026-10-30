#!/usr/bin/env bash
# Checks .claude/hooks/guard-pr-merge.sh: it must refuse `gh pr merge` with
# --delete-branch or -d (which also deletes the branch's worktree) and let
# every other command through.
set -euo pipefail

hook="$(dirname "$0")/../.claude/hooks/guard-pr-merge.sh"
fail=0
run() { jq -n --arg c "$1" '{tool_name:"Bash",tool_input:{command:$c}}' | "$hook" 2>/dev/null; }
blocks() { if run "$1"; then echo "FAIL: should block: $1"; fail=1; fi; }
allows() { if ! run "$1"; then echo "FAIL: should allow: $1"; fail=1; fi; }

blocks 'gh pr merge 108 --squash --delete-branch'
blocks 'gh pr merge 108 -d --squash'
blocks 'gh pr merge 108 -sd'
blocks 'cd /repo && gh pr merge 111 --squash --delete-branch >/dev/null'
allows 'gh pr merge 108 --squash'
allows 'gh pr merge 108 --squash --admin'
allows 'git push origin --delete feat/x'
allows 'gh pr view 108 --json state'

(( fail )) && exit 1
echo "PASS: guard-pr-merge.sh blocks only gh pr merge --delete-branch"
