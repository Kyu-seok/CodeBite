#!/usr/bin/env bash
# Ships a finished ticket branch through its own PR, the one-PR-per-ticket path
# (scripts/merge-ticket.sh is the integration-branch path):
#
#   scripts/ship-branch.sh <branch> [--title <title> --body-file <file>]
#
# Run it from the main checkout. It fetches, reuses the branch's open PR (or opens one when given
# --title and --body-file, pushing the branch first), runs the branch's
# scripts/copy-walkthrough-kit.py --check with the kit on this machine (CI has no kit), waits for
# CI to register and finish,
# squash-merges, then deletes the remote branch, the worktree checked out on it (first stopping
# its branch servers and dropping their database: scripts/dev-branch-servers.sh) and the local
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

# Stops the branch servers worktree $1 ran with scripts/dev-branch-servers.sh and drops their
# database, Kafka topics and Redis index, from inside it: once it is gone only the main checkout's
# `dev-branch-servers.sh orphans` finds them. A failure (Docker down, say) only warns.
drop_branch_database() {
  local script="$1/scripts/dev-branch-servers.sh"
  [[ -x $script ]] || return 0
  if ! (cd "$1" && "$script" stop >/dev/null && "$script" drop); then
    echo "ship-branch: couldn't drop $1's branch database; later, from the main checkout: scripts/dev-branch-servers.sh orphans, then drop <name>" >&2
  fi
}

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

# CI can't see the walkthrough kit (it lives only on this machine), so the kit check that needs it
# (the recorded kit commit is on the kit's main) runs here, on the branch's tree, with the kit
# beside the main checkout.
tree=$(mktemp -d)
trap 'rm -rf "$tree"' EXIT
git archive "origin/$branch" | tar -x -C "$tree"
if [[ -f $tree/scripts/copy-walkthrough-kit.py ]]; then
  kit=${WALKTHROUGH_KIT:-$(dirname "$(dirname "$(git rev-parse --path-format=absolute --git-common-dir)")")/walkthrough-skill}
  if ! WALKTHROUGH_KIT=$kit python3 -I "$tree/scripts/copy-walkthrough-kit.py" --check; then
    echo "ship-branch: $branch's walkthrough kit copy fails scripts/copy-walkthrough-kit.py --check, nothing merged" >&2
    exit 1
  fi
fi

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
if [[ -n $worktree ]]; then
  drop_branch_database "$worktree"
  git worktree remove "$worktree"
fi
if git show-ref -q --verify "refs/heads/$branch"; then git branch -D "$branch" >/dev/null; fi
echo "ship-branch: merged #$n, deleted $branch${worktree:+ and $worktree}"
