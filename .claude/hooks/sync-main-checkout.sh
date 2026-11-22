#!/usr/bin/env bash
# SessionStart hook: keeps the main checkout from trailing origin/master.
#
# A session's CLAUDE.md, skills and scripts are the main checkout's, and nothing moved that
# checkout but a hand `git pull`: it sat seven merges behind for the whole of the #433 build,
# pointing at a script option that no longer existed. When the session starts in the main
# checkout, on master, with no change to a tracked file, and origin/master is ahead, this
# fast-forwards it and prints one line (stdout goes into the session's context), adding which
# instruction files moved, since the session may have been handed the old ones. When it can't
# fast-forward (another branch, local changes, master has commits of its own) it moves nothing and
# prints how far behind the checkout is and the command that catches it up.
#
# Silent, and always exit 0, when there is nothing to do: the checkout is current, the session is
# in a worktree (its own branch is its business), origin can't be reached, or this is no repository.
# scripts/ship-branch.sh does the same fast-forward before and after a ship; this covers the
# sessions that never ship.
cd "${CLAUDE_PROJECT_DIR:-.}" 2>/dev/null || exit 0
git_dir=$(git rev-parse --absolute-git-dir 2>/dev/null) || exit 0
[[ $git_dir -ef $(git rev-parse --git-common-dir) ]] || exit 0 # a worktree's git dir is its own
git fetch -q origin master 2>/dev/null || exit 0

behind=$(git rev-list --count HEAD..origin/master 2>/dev/null) || exit 0
(( behind > 0 )) || exit 0
commits="$behind commit"; (( behind == 1 )) || commits+=s

branch=$(git branch --show-current)
if [[ $branch != master ]]; then
  why="on ${branch:-a detached HEAD}, not master"; fix="git switch master && git merge --ff-only origin/master"
elif ! git diff --quiet || ! git diff --cached --quiet; then
  why="local changes"; fix="git stash && git merge --ff-only origin/master"
elif ! git merge-base --is-ancestor HEAD origin/master; then
  why="master has commits origin/master lacks"; fix="git rebase origin/master"
else
  moved=$(git diff --name-only HEAD origin/master -- CLAUDE.md .claude/ | sed 's|^\(\.claude/[^/]*\)/.*|\1/|' | sort -u | paste -sd' ' -)
  git merge -q --ff-only origin/master 2>/dev/null || exit 0
  line="main checkout: fast-forwarded $commits to $(git rev-parse --short HEAD)."
  [[ -n $moved ]] && line+=" These changed, so re-read any you were given at session start: $moved"
  echo "$line"
  exit 0
fi
echo "main checkout: $commits behind origin/master, not fast-forwarded ($why). Its CLAUDE.md, skills and scripts may be stale: read them from a worktree of origin/master, or catch up with: $fix"
exit 0
