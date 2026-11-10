#!/usr/bin/env bash
# Merges finished ticket branches into the integration branch checked out in this worktree:
#
#   scripts/merge-ticket.sh <branch> <title> [<branch> <title> ...]
#
# For each branch in order, it takes origin/<branch> when that exists, else the local branch, and
# merges it with --no-ff and the attribution trailer (MERGE_TICKET_TRAILER overrides it). It refuses
# on master, a detached HEAD, a dirty tree, or a branch already merged. On a conflict it aborts that
# merge, lists the files and stops: earlier merges stay committed and unpushed. After the last merge
# it runs, once, the checks git skips on a clean merge (no pre-commit hook runs): the backend and
# worker tests, forced past UP-TO-DATE, then the frontend lint (no warnings), tests and build. It
# pushes the integration branch once, only when all of them pass; otherwise it names the failed
# check and leaves the merge commits unpushed (undo them with `git reset --hard origin/<integration>`).
#
# When every ticket branch already contained the integration branch's HEAD before its merge (in
# practice, one branch), the merge's tree is the ticket branch's own tree, which its PR's CI checked
# on push, so the checks are skipped and the merge commit pushed straight away, with one line saying
# why.
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
    "${MERGE_TICKET_TRAILER:-Co-Authored-By: Claude <noreply@anthropic.com>}"
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

# The push of HEAD to branch $1.
push_merge() {
  git push -q origin "HEAD:refs/heads/$1"
  echo "merge-ticket: pushed $(git rev-parse --short HEAD) to $1"
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

  push_merge "$current"
}

# The push of branch $1 with no checks, after merging $2, which already contained $1: the merge's
# tree is $2's own tree, and its PR's CI checked that on push.
push_checked_by_ci() {
  echo "merge-ticket: $2 already contains $1; skipping the checks (CI gates the pushed tree)"
  push_merge "$1"
}

# Hands the checks and the push of branch $1 to the copy of this script the merge just brought in.
run_merged_copy() {
  bash scripts/merge-ticket.sh --checks-and-push "$1"
}

# Merges branch $1 titled $2 into branch $3 (no checks, no push). Sets contains_head=yes when the
# branch already contained HEAD before the merge, and ref to what was merged.
merge_one() {
  local branch=$1 title=$2 current=$3 merged=no conflicts
  contains_head=no
  if git rev-parse -q --verify "refs/remotes/origin/$branch" >/dev/null; then
    ref=origin/$branch
  elif git rev-parse -q --verify "refs/heads/$branch" >/dev/null; then
    ref=$branch
  else
    echo "merge-ticket: no branch $branch here or on origin" >&2
    return 1
  fi
  git merge-base --is-ancestor "$ref" HEAD && merged=yes
  git merge-base --is-ancestor HEAD "$ref" && contains_head=yes
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
}

# Merges each <branch> <title> pair in order, then checks and pushes once.
merge_ticket() {
  local current start all_contain_head=yes ref contains_head
  current=$(git branch --show-current)
  start=$(git rev-parse HEAD)
  git fetch -q origin
  while (( $# >= 2 )); do
    if ! merge_one "$1" "$2" "$current"; then
      [[ "$(git rev-parse HEAD)" == "$start" ]] \
        || echo "merge-ticket: stopped at $1; the merges before it are committed and not pushed" >&2
      return 1
    fi
    [[ "$contains_head" == yes ]] || all_contain_head=no
    shift 2
  done

  if [[ "$all_contain_head" == yes ]]; then
    push_checked_by_ci "$current" "$ref"
  elif git diff --name-only "$start" HEAD | grep -qx scripts/merge-ticket.sh; then
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
  if (( $# < 2 || $# % 2 != 0 )); then
    echo "usage: scripts/merge-ticket.sh <branch> <title> [<branch> <title> ...]" >&2
    exit 2
  fi
  cd "$(git rev-parse --show-toplevel)"
  merge_ticket "$@"
fi
