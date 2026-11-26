#!/usr/bin/env bash
# Checks .claude/hooks/guard-pr-title.sh: it must refuse `gh pr create` and
# `gh pr edit` with a title whose squash subject ("<title> (#<n>)") would pass
# 72 characters, and let every other command through, a title it cannot read
# (one built from a variable or a command) included.
set -euo pipefail

hook="$(dirname "$0")/../.claude/hooks/guard-pr-title.sh"
fail=0
run() { jq -n --arg c "$1" '{tool_name:"Bash",tool_input:{command:$c}}' | "$hook" 2>/dev/null; }
blocks() { if run "$1"; then echo "FAIL: should block: $1"; fail=1; fi; }
allows() { if ! run "$1"; then echo "FAIL: should allow: $1"; fail=1; fi; }
# title <n>: a title of exactly n characters.
title() { printf 'fix(scope): %s' "$(printf 'x%.0s' $(seq 1 $(($1 - 12))))"; }

# A new PR's number is unknown, so the hook leaves room for four digits: 72 - " (#0000)" = 64.
allows "gh pr create --title \"$(title 64)\" --body-file body.md"
blocks "gh pr create --title \"$(title 65)\" --body-file body.md"
blocks "gh pr create --title '$(title 70)' --body-file body.md"
blocks "gh pr create --title=\"$(title 70)\" --body-file body.md"
blocks "gh pr create -t \"$(title 70)\" --body-file body.md"
blocks "cd /repo && gh pr create --base master --title \"$(title 70)\" --body-file body.md"
blocks "gh pr create --body-file body.md \\
  --title \"$(title 70)\""

# An edit names its PR, so the limit is exact: 72 - " (#455)" = 65.
allows "gh pr edit 455 --title \"$(title 65)\""
blocks "gh pr edit 455 --title \"$(title 66)\""
blocks "gh pr edit '#455' --title \"$(title 70)\""
allows "gh pr edit --title \"$(title 64)\" 455"

# Characters, not bytes: 30 Korean characters are 90 bytes.
allows 'gh pr create --title "fix(i18n): 한국어 오류 메시지를 스트릭과 리뷰와 풀이 API에 추가합니다" --body-file b.md'

allows 'gh pr create --title "$(cat title.txt)" --body-file body.md'
allows 'gh pr create --title "$TITLE" --body-file body.md'
allows 'gh pr create --fill'
allows 'gh pr view 455 --json title'
allows "gh issue create --title \"$(title 90)\" --body-file body.md"
allows "git commit -m \"$(title 60)\""

(( fail )) && exit 1
echo "PASS: guard-pr-title.sh blocks only a PR title too long for its squash subject"
