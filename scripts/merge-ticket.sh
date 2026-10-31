#!/usr/bin/env bash
# Merges a finished ticket branch into the integration branch checked out in this worktree:
#
#   scripts/merge-ticket.sh <branch> <title>
#
# It takes origin/<branch> when that exists, else the local branch, and merges it with --no-ff and
# the attribution trailer (MERGE_TICKET_TRAILER overrides it). It refuses on master, a detached HEAD,
# a dirty tree, or a branch already merged. On a conflict it aborts the merge and lists the files.
# Then it runs the checks git skips on a clean merge (no pre-commit hook runs): the backend and
# worker tests, forced past UP-TO-DATE, then the frontend tests and build. It pushes the integration
# branch only when all of them pass; otherwise it names the failed check and leaves the merge commit
# unpushed (undo it with `git reset --hard HEAD~1`).
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

# The frontend tests and build (which type-checks), installing dependencies first in a fresh worktree.
frontend_checks() {
  (
    cd frontend
    [[ -d node_modules ]] || npm ci
    npm test && npm run build
  )
}

merge_ticket() {
  local branch=$1 title=$2 current ref merged=no check conflicts
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

  for check in backend frontend; do
    echo "merge-ticket: running the $check checks"
    if ! "${check}_checks"; then
      echo "merge-ticket: $check checks failed; the merge commit $(git rev-parse --short HEAD) is not pushed" >&2
      return 1
    fi
  done

  git push -q origin "HEAD:refs/heads/$current"
  echo "merge-ticket: merged $branch into $current and pushed $(git rev-parse --short HEAD)"
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  if [[ $# -ne 2 ]]; then
    echo "usage: scripts/merge-ticket.sh <branch> <title>" >&2
    exit 2
  fi
  cd "$(git rev-parse --show-toplevel)"
  merge_ticket "$1" "$2"
fi
