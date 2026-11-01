#!/usr/bin/env bash
# Merges a finished ticket branch into the integration branch checked out in this worktree:
#
#   scripts/merge-ticket.sh <branch> <title>
#
# It takes origin/<branch> when that exists, else the local branch, and merges it with --no-ff and
# the attribution trailer (MERGE_TICKET_TRAILER overrides it). It refuses on master, a detached HEAD,
# a dirty tree, or a branch already merged. On a conflict it aborts the merge and lists the files.
# Then it runs the checks git skips on a clean merge (no pre-commit hook runs): the backend and
# worker tests, forced past UP-TO-DATE, then the frontend lint (no warnings), tests and build. It
# pushes the integration branch only when all of them pass; otherwise it names the failed check and
# leaves the merge commit unpushed (undo it with `git reset --hard HEAD~1`).
#
# A merge that changes this script hands the checks and the push to the merged copy, run as
# `scripts/merge-ticket.sh --checks-and-push`: bash read this copy before the merge, so its checks are
# the old ones. Keep that mode in every later version.
set -euo pipefail

# Why not to merge, or nothing: on branch $1 (empty when detached), with `git status --porcelain`
# output $2, and $3 = yes when the ticket branch is already in HEAD.
merge_refusal() {
  local current=$1 status=$2 merged=$3
  if [[ -z "$current" ]]; then
    echo "refusing to merge on a detached HEAD; check out the integration branch"
  elif [[ "$current" == master ]]; then
    echo "refusing to merge on master; check out the integration branch"
  elif [[ -n "$status" ]]; then
    echo "refusing to merge into a dirty tree; commit or stash first"
  elif [[ "$merged" == yes ]]; then
    echo "already merged into $current"
  fi
}

# The merge commit's message for branch $1 titled $2, ending in the attribution trailer.
merge_message() {
  printf 'Merge %s: %s\n\n%s\n' "$1" "$2" \
    "${MERGE_TICKET_TRAILER:-Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>}"
}

# The backend and worker tests, forced to run: a merge can leave Gradle's inputs looking unchanged,
# and git runs no pre-commit hook on a clean merge, so UP-TO-DATE would mean they never ran.
backend_checks() {
  ./gradlew :backend:test --rerun :worker:test --rerun
}

# The frontend lint with no warnings allowed (as CI and the pre-commit hook run it), tests and build
# (which type-checks), installing dependencies first in a fresh worktree.
frontend_checks() {
  (
    cd frontend
    [[ -d node_modules ]] || npm ci
    npm run lint -- --max-warnings 0 && npm test && npm run build
  )
}

# The checks, then the push of branch $1 when all of them pass.
check_and_push() {
  local current=$1 check
  for check in backend frontend; do
    echo "merge-ticket: running the $check checks"
    if ! "${check}_checks"; then
      echo "merge-ticket: $check checks failed; the merge commit $(git rev-parse --short HEAD) is not pushed" >&2
      return 1
    fi
  done

  git push -q origin "HEAD:refs/heads/$current"
  echo "merge-ticket: pushed $(git rev-parse --short HEAD) to $current"
}

# Hands the checks and the push of branch $1 to the copy of this script the merge just brought in.
run_merged_copy() {
  bash scripts/merge-ticket.sh --checks-and-push "$1"
}

merge_ticket() {
  local branch=$1 title=$2 current ref merged=no conflicts
  current=$(git branch --show-current)
  git fetch -q origin
  if git rev-parse -q --verify "refs/remotes/origin/$branch" >/dev/null; then
    ref=origin/$branch
  elif git rev-parse -q --verify "refs/heads/$branch" >/dev/null; then
    ref=$branch
  else
    echo "merge-ticket: no branch $branch here or on origin" >&2
    return 1
  fi
  git merge-base --is-ancestor "$ref" HEAD && merged=yes
  local refusal
  refusal=$(merge_refusal "$current" "$(git status --porcelain)" "$merged")
  if [[ -n "$refusal" ]]; then
    echo "merge-ticket: $refusal" >&2
    return 1
  fi

  echo "merge-ticket: merging $ref into $current"
  if ! git merge -q --no-ff -m "$(merge_message "$branch" "$title")" "$ref"; then
    conflicts=$(git diff --name-only --diff-filter=U)
    git merge --abort
    echo "merge-ticket: $ref conflicts with $current; merge aborted. Conflicting files:" >&2
    sed 's/^/  /' <<<"$conflicts" >&2
    return 1
  fi

  if git diff --name-only HEAD^1 HEAD | grep -qx scripts/merge-ticket.sh; then
    echo "merge-ticket: the merge changes merge-ticket.sh; its merged copy runs the checks"
    run_merged_copy "$current"
  else
    check_and_push "$current"
  fi
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  if [[ "${1:-}" == --checks-and-push && $# -eq 2 ]]; then
    cd "$(git rev-parse --show-toplevel)"
    check_and_push "$2"
    exit
  fi
  if [[ $# -ne 2 ]]; then
    echo "usage: scripts/merge-ticket.sh <branch> <title>" >&2
    exit 2
  fi
  cd "$(git rev-parse --show-toplevel)"
  merge_ticket "$1" "$2"
fi
