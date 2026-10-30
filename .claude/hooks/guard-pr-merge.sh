#!/usr/bin/env bash
# PreToolUse hook (Bash): refuses `gh pr merge` with --delete-branch / -d.
# Branches here live in worktrees (CLAUDE.md, "Parallel sessions"), and gh's
# local branch cleanup removes the worktree too, along with any server or
# uncommitted work running from it.
cmd=$(jq -r '.tool_input.command // ""')
if grep -Eq '(^|[^[:alnum:]_-])gh[[:space:]]+pr[[:space:]]+merge([[:space:]].*)?[[:space:]](--delete-branch|-[sdmr]*d[sdmr]*)([[:space:]=]|$)' <<<"$cmd"; then
  echo "Blocked: 'gh pr merge --delete-branch' also deletes the branch's worktree. Merge without it, then delete the remote branch: gh pr merge <n> --squash && git push origin --delete <branch>" >&2
  exit 2
fi
exit 0
