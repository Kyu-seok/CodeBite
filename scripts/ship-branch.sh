#!/usr/bin/env bash
# Ships a finished ticket branch through its own PR, the one-PR-per-ticket path
# (scripts/merge-ticket.sh is the integration-branch path):
#
#   scripts/ship-branch.sh <branch> [--title <title> --body-file <file>]
#
# Run it from the main checkout. It fetches, reuses the branch's open PR (or opens one when given
# --title and --body-file, pushing the branch first), waits for CI to register and finish,
# squash-merges, then deletes the remote branch, the worktree checked out on it and the local
# branch. It refuses master, a branch with no PR and no --title, and a run from inside that
# branch's own worktree (the cleanup would remove the directory it runs in). When a check fails
# it names it and leaves everything in place.
#
# Why it waits before watching: for the first seconds after a PR opens, `gh pr checks` answers
# "no checks reported" and exits 1, which `--watch` would take for a finished run.
# SHIP_BRANCH_POLL is the seconds between those looks (default 10).
set -euo pipefail

usage() { echo "usage: scripts/ship-branch.sh <branch> [--title <title> --body-file <file>]" >&2; exit 2; }
[[ $# -ge 1 ]] || usage
branch=$1; shift
title=""; body=""
while [[ $# -gt 0 ]]; do
  case $1 in
    --title) [[ $# -ge 2 ]] || usage; title=$2; shift 2 ;;
    --body-file) [[ $# -ge 2 ]] || usage; body=$2; shift 2 ;;
    *) usage ;;
  esac
done
[[ $branch != master ]] || { echo "ship-branch: master is not shipped" >&2; exit 2; }

here=$(git rev-parse --show-toplevel)
worktree=$(git worktree list --porcelain | awk -v b="refs/heads/$branch" '$1=="worktree"{w=$2} $1=="branch" && $2==b {print w}')
if [[ -n $worktree && $here == "$worktree" ]]; then
  echo "ship-branch: run from the main checkout, not from $branch's worktree ($worktree): the cleanup removes it" >&2
  exit 2
fi

git fetch -q --prune origin
n=$(gh pr list --head "$branch" --state open --json number --jq '.[0].number // empty')
if [[ -z $n ]]; then
  if [[ -z $title || -z $body ]]; then
    echo "ship-branch: $branch has no open PR; pass --title and --body-file to open one" >&2
    exit 2
  fi
  git push -q -u origin "$branch"
  url=$(gh pr create --base master --head "$branch" --title "$title" --body-file "$body")
  n=${url##*/}
fi
echo "ship-branch: PR #$n"

poll=${SHIP_BRANCH_POLL:-10}
for _ in $(seq 1 30); do
  out=$(gh pr checks "$n" 2>&1) && break
  [[ $out == *"no checks reported"* ]] || break
  sleep "$poll"
done
if ! gh pr checks "$n" --watch --interval 20 >/dev/null 2>&1; then
  echo "ship-branch: a check failed on #$n (or none registered), nothing merged:" >&2
  gh pr checks "$n" >&2 || true
  exit 1
fi

gh pr merge "$n" --squash
git push -q origin --delete "$branch"
[[ -z $worktree ]] || git worktree remove "$worktree"
if git show-ref -q --verify "refs/heads/$branch"; then git branch -D "$branch" >/dev/null; fi
echo "ship-branch: merged #$n, deleted $branch${worktree:+ and $worktree}"
