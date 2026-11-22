#!/usr/bin/env bash
# Merges finished ticket branches into the integration branch checked out in this worktree:
#
#   scripts/merge-ticket.sh [--refresh] <branch> <title> [<branch> <title> ...]
#   scripts/merge-ticket.sh --checks-and-push <integration branch>
#
# For each branch in order, it takes origin/<branch> when that exists, else the local branch, and
# merges it with --no-ff and the attribution trailer (MERGE_TICKET_TRAILER overrides it). It refuses
# on master, a detached HEAD, a dirty tree, a branch already merged, or a branch with a non-merge
# commit whose subject passes 72 characters (scripts/check-commit-subjects.sh, the commit-msg hook
# that --no-verify skipped; its own "Merge …" subjects are exempt). On a conflict it aborts that
# merge, lists the files and stops: earlier merges stay committed and unpushed. After the last merge
# it runs, once, the checks git skips on a clean merge (no pre-commit hook runs): the pre-commit
# hook's repo-wide checks (doc references, kit copy, shellcheck, script tests), the backend and
# worker tests, forced past UP-TO-DATE, then the frontend lint (no warnings), tests and build. It
# pushes the integration branch once, only when all of them pass; otherwise it names the failed
# check and leaves the merge commits unpushed (undo them with `git reset --hard origin/<integration>`).
#
# When every ticket branch already contained the integration branch's HEAD before its merge (in
# practice, one branch) and the integration branch is one CI runs on when pushed (`integration/` or
# `spec/`, as .github/workflows/ci.yml lists), the merge's tree is the ticket branch's own tree and
# CI checks it after the push, so the local checks are skipped and the merge commit pushed straight
# away, with one line saying why. Ticket branches have no PR of their own, so on any other branch
# the checks run, and a loud warning first names the cost and the rename to `spec/<issue>-<slug>`
# (a warning, not a refusal: the merge is still checked, only slower).
#
# --refresh keeps that fast path for a ticket branch that lacks the integration branch's HEAD (it
# reported just after another merge landed): before the merge it merges HEAD into the ticket branch,
# in the worktree checked out on it or, when there is none, a temporary one. A conflict there stops
# with the files named, the ticket branch as it was and nothing merged here. Then it runs the ticket
# branch's own .githooks/pre-commit over the paths the ticket adds to HEAD, with CODEBITE_SKIP_TESTS=1:
# the doc references and kit copy always, shellcheck, the tracer helpers and the script tests for
# scripts/ and every tracked shell file (scripts/check-shell.sh --list), the frontend lint and tests
# for frontend/ (the hook is the list; this is what it held when written). The Gradle suites are
# left out because they are the ten minutes --refresh exists to save, and CI runs them on the pushed
# tree, which is the refreshed ticket's own;
# the cheap checks run here because the implementer never ran them on the merged tree and a red one
# would otherwise show only after the push. A failing one stops with nothing merged here or pushed:
# the refreshed branch stays in its worktree to fix (a temporary worktree is dropped, the branch
# unmoved). When they pass, the branch is pushed if origin has it, and the merge goes on as above.
#
# Under --refresh those path-scoped checks run for every branch, one that already contains HEAD too
# (no merge into it then, only the checks): a failed check leaves the refresh merge on the branch in
# its worktree, so on the rerun the branch contains HEAD, and a rerun with nothing fixed must fail
# again rather than push unchecked. The rerun after a fix committed in that worktree takes the local
# branch when it is ahead of origin's, and pushes it with the rest. Without --refresh nothing here
# happens.
#
# It refuses, before merging anything, when a CI run on the integration branch's HEAD failed or was
# cancelled: a skipped-check push (above) is checked only by that run, and a merge stacked on a red
# tip hides which merge broke it (#264). A pending run doesn't stop it. The refusal names the red run
# and the command that reruns its failed jobs, for a failure a rerun clears (a download, a flaky test).
#
# The second form merges nothing: it runs the checks below on HEAD and pushes it to <integration
# branch> when they pass. It is the rerun after a failed check that turned out flaky: the merge
# commits are already in place and unpushed, so rerun with the branch checked out here, e.g.
# `scripts/merge-ticket.sh --checks-and-push spec/348-dev-tooling`, rather than merging again.
# A merge that changes this script also hands the checks and the push to the merged copy this way:
# bash read this copy before the merge, so its checks are the old ones. Keep that mode in every
# later version.
set -euo pipefail
merge_ticket_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

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

# The attribution trailer every merge commit here ends in.
merge_trailer() {
  echo "${MERGE_TICKET_TRAILER:-Co-Authored-By: Claude <noreply@anthropic.com>}"
}

# The merge commit's message for branch $1 titled $2, ending in the attribution trailer.
merge_message() {
  printf 'Merge %s: %s\n\n%s\n' "$1" "$2" "$(merge_trailer)"
}

# The message of the commit that merges integration branch $1 into ticket branch $2 (--refresh).
refresh_message() {
  printf 'Merge %s into %s\n\n%s\n' "$1" "$2" "$(merge_trailer)"
}

# The repo-wide checks the pre-commit hook and CI run, which a ticket committed with --no-verify
# skipped: doc references (CLAUDE.md's size ceiling too), the walkthrough kit copy, shellcheck
# (scripts/check-shell.sh, every tracked shell file, as the hook and ci.yml run it) and the script
# tests. Seconds, so they go before Gradle.
repo_checks() {
  python3 -I scripts/check-doc-references.py \
    && python3 -I scripts/copy-walkthrough-kit.py --check \
    && if command -v shellcheck >/dev/null 2>&1; then scripts/check-shell.sh; fi \
    && scripts/run-script-tests.sh
}

# The backend and worker tests, forced to run: a merge can leave Gradle's inputs looking unchanged,
# and git runs no pre-commit hook on a clean merge, so UP-TO-DATE would mean they never ran.
backend_checks() {
  scripts/gradle-test.sh :backend:test --rerun :worker:test --rerun
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
  for check in repo backend frontend; do
    echo "merge-ticket: running the $check checks"
    if ! "${check}_checks"; then
      echo "merge-ticket: $check checks failed; the merge commit $(git rev-parse --short HEAD) is not pushed" >&2
      return 1
    fi
  done

  push_merge "$current"
}

# CI's runs on commit $1, one "<conclusion> <url>" line each (conclusion empty while running); nothing
# when gh is missing or can't answer.
ci_runs() {
  gh run list --commit "$1" --workflow CI --json conclusion,url --jq '.[] | "\(.conclusion) \(.url)"' 2>/dev/null || true
}

# The run that makes a tip red among $1 (ci_runs lines), as its "<conclusion> <url>" line, or nothing:
# the first that failed, was cancelled or timed out.
red_run() {
  local conclusion url
  while read -r conclusion url; do
    if [[ "$conclusion" == failure || "$conclusion" == cancelled || "$conclusion" == timed_out ]]; then
      echo "$conclusion $url"
      return
    fi
  done <<<"$1"
}

# Why not to merge onto a tip whose CI runs are $1 (ci_runs lines), or nothing. A run's URL ends in
# its id, which `gh run rerun` takes.
red_tip_refusal() {
  local red
  red=$(red_run "$1")
  [[ -n "$red" ]] || return 0
  echo "refusing to merge onto a red integration tip: CI $red; fix it first (scripts/test-failures.sh) or rerun its failed jobs (gh run rerun ${red##*/} --failed)"
}

# Whether CI runs on a push to branch $1: keep in step with ci.yml's `push: branches`.
ci_checks_pushes() {
  [[ "$1" == integration/* || "$1" == spec/* ]]
}

# The warning for merging into branch $1 when CI doesn't run on its pushes, or nothing. It warns and
# goes on rather than refusing: the local checks still gate the push, so the merge is only slower.
integration_branch_warning() {
  ci_checks_pushes "$1" && return
  sed 's/^/merge-ticket: WARNING: /' <<EOF
CI doesn't run on pushes to $1 (only spec/** and integration/**),
so every merge runs the full local checks (about 1.5-3 min each), even a ticket
that already contains HEAD. Rename it before the next merge:
  git branch -m spec/<issue>-<slug> && git push -u origin spec/<issue>-<slug>
EOF
}

# The push of branch $1 with no checks, after merging $2, which already contained $1: the merge's
# tree is $2's own tree, and CI checks it on this push.
push_checked_by_ci() {
  echo "merge-ticket: $2 already contains $1; skipping the checks (CI gates the pushed tree)"
  push_merge "$1"
  echo "merge-ticket: CI now checks $(git rev-parse --short HEAD); the next merge refuses if it goes red (gh run list --commit $(git rev-parse HEAD))"
}

# Hands the checks and the push of branch $1 to the copy of this script the merge just brought in.
run_merged_copy() {
  bash scripts/merge-ticket.sh --checks-and-push "$1"
}

# The worktree checked out on branch $1, or nothing.
branch_worktree() {
  git worktree list --porcelain | awk -v want="branch refs/heads/$1" \
    '/^worktree /{path=substr($0, 10)} $0==want{print path; exit}'
}

# The path-scoped checks on the worktree in directory $1, for the paths $2 (one per line): that
# worktree's own pre-commit hook, so the hook stays the one place that says which check a path gets,
# with the Gradle tests skipped. A fresh worktree gets the frontend's dependencies first, as in
# frontend_checks.
refresh_checks() {
  (
    cd "$1"
    if [[ ! -x .githooks/pre-commit ]]; then
      echo "merge-ticket: no .githooks/pre-commit in $1" >&2
      exit 1
    fi
    if grep -q '^frontend/' <<<"$2" && [[ ! -d frontend/node_modules ]]; then (cd frontend && npm ci); fi
    CODEBITE_SKIP_TESTS=1 CODEBITE_HOOK_PATHS=$2 .githooks/pre-commit
  )
}

# Brings ticket branch $1 (at $2) up to HEAD when it lacks it, by merging HEAD into it, and runs the
# path-scoped checks on the result, for a merge into branch $3. Afterwards $2 names the checked
# branch. Its callers test its status, so errexit is off in here: every step is checked by hand and
# a failed one is named.
refresh_ticket() {
  local branch=$1 from=$2 current=$3 tip dir temp='' conflicts paths refreshed status=0
  tip=$(git rev-parse HEAD) || return 1
  dir=$(branch_worktree "$branch") || return 1
  if [[ -n "$dir" ]]; then
    if [[ "$(git rev-parse "refs/heads/$branch")" != "$(git rev-parse "$from")" ]]; then
      echo "merge-ticket: $branch in $dir and $from differ; push or reset one first" >&2
      return 1
    fi
    if [[ -n "$(git -C "$dir" status --porcelain)" ]]; then
      echo "merge-ticket: refusing to refresh $branch: uncommitted changes in $dir" >&2
      return 1
    fi
  else
    if git rev-parse -q --verify "refs/heads/$branch" >/dev/null \
      && [[ "$(git rev-parse "refs/heads/$branch")" != "$(git rev-parse "$from")" ]]; then
      echo "merge-ticket: local $branch and $from differ; push or reset one first" >&2
      return 1
    fi
    if ! temp=$(mktemp -d); then
      echo "merge-ticket: could not make a temporary directory to refresh $branch in; nothing merged into $current" >&2
      return 1
    fi
    dir=$temp/refresh
    if ! git worktree add -q --detach "$dir" "$from"; then
      echo "merge-ticket: could not add a temporary worktree at $dir for $from; nothing merged into $current" >&2
      rm -rf "$temp"
      return 1
    fi
  fi

  if git merge-base --is-ancestor "$tip" "$from"; then
    echo "merge-ticket: $branch already contains $current ($(git rev-parse --short "$tip")); checking it in $dir"
  else
    echo "merge-ticket: refreshing $branch: merging $current ($(git rev-parse --short "$tip")) into it in $dir"
    if ! git -C "$dir" merge -q --no-ff -m "$(refresh_message "$current" "$branch")" "$tip"; then
      conflicts=$(git -C "$dir" diff --name-only --diff-filter=U)
      if git -C "$dir" rev-parse -q --verify MERGE_HEAD >/dev/null && ! git -C "$dir" merge --abort; then
        echo "merge-ticket: could not abort the merge of $current in $dir; abort it there by hand" >&2
      fi
      if [[ -n "$conflicts" ]]; then
        echo "merge-ticket: $current conflicts with $branch; refresh aborted, nothing merged into $current. Conflicting files:" >&2
        sed 's/^/  /' <<<"$conflicts" >&2
      else
        echo "merge-ticket: git could not merge $current into $branch in $dir (no conflict; its message is above); nothing merged into $current" >&2
      fi
      status=1
    fi
  fi

  if (( status == 0 )); then
    if ! refreshed=$(git -C "$dir" rev-parse HEAD) \
      || ! paths=$(git -C "$dir" diff --name-only --diff-filter=ACMR "$tip" HEAD); then
      echo "merge-ticket: could not list what $branch adds to $current in $dir; nothing merged into $current" >&2
      status=1
    else
      echo "merge-ticket: running the path-scoped checks on $branch (Gradle is left to CI)"
      if ! refresh_checks "$dir" "$paths"; then
        if [[ -n "$temp" ]]; then
          echo "merge-ticket: path-scoped checks failed on $branch with $current merged in; nothing is merged into $current or pushed, and $branch is as it was" >&2
        else
          echo "merge-ticket: path-scoped checks failed on $branch with $current merged in; nothing is merged into $current or pushed. Fix it in $dir, commit, and run this again" >&2
        fi
        status=1
      fi
    fi
  fi

  if [[ -n "$temp" ]]; then
    if ! git worktree remove --force "$dir"; then
      echo "merge-ticket: could not remove the temporary worktree $dir (git worktree remove --force); remove it by hand. Nothing is merged into $current or pushed, and $branch is as it was" >&2
      return 1
    fi
    rm -rf "$temp"
    if (( status == 0 )) && git rev-parse -q --verify "refs/heads/$branch" >/dev/null \
      && ! git update-ref "refs/heads/$branch" "$refreshed"; then
      echo "merge-ticket: could not move local $branch to the refreshed $(git rev-parse --short "$refreshed"); nothing merged into $current" >&2
      return 1
    fi
  fi
  (( status == 0 )) || return 1
  if git rev-parse -q --verify "refs/remotes/origin/$branch" >/dev/null \
    && ! git push -q origin "$refreshed:refs/heads/$branch"; then
    echo "merge-ticket: could not push the checked $branch ($(git rev-parse --short "$refreshed")) to origin; nothing merged into $current" >&2
    return 1
  fi
}

# Merges branch $1 titled $2 into branch $3 (no checks, no push), first refreshing a branch that
# lacks HEAD when $4 is yes. Sets contains_head=yes when the branch contained HEAD before the merge,
# and ref to what was merged.
merge_one() {
  local branch=$1 title=$2 current=$3 refresh=${4:-no} merged=no conflicts
  contains_head=no
  if git rev-parse -q --verify "refs/remotes/origin/$branch" >/dev/null; then
    ref=origin/$branch
  elif git rev-parse -q --verify "refs/heads/$branch" >/dev/null; then
    ref=$branch
  else
    echo "merge-ticket: no branch $branch here or on origin" >&2
    return 1
  fi
  # The local branch ahead of origin's is the refresh merge a failed check left in its worktree, plus
  # the fix committed there: take it, and refresh_ticket pushes it once its checks pass.
  if [[ "$refresh" == yes && "$ref" == "origin/$branch" ]] \
    && git rev-parse -q --verify "refs/heads/$branch" >/dev/null \
    && [[ "$(git rev-parse "refs/heads/$branch")" != "$(git rev-parse "$ref")" ]] \
    && git merge-base --is-ancestor "$ref" "refs/heads/$branch"; then
    echo "merge-ticket: local $branch is ahead of $ref; taking the local branch"
    ref=$branch
  fi
  git merge-base --is-ancestor "$ref" HEAD && merged=yes
  git merge-base --is-ancestor HEAD "$ref" && contains_head=yes
  local refusal
  refusal=$(merge_refusal "$current" "$(git status --porcelain)" "$merged")
  if [[ -n "$refusal" ]]; then
    echo "merge-ticket: $refusal" >&2
    return 1
  fi

  if ! "$merge_ticket_dir/check-commit-subjects.sh" "HEAD..$ref"; then
    echo "merge-ticket: $ref has a commit subject over 72 characters; not merged" >&2
    return 1
  fi

  if [[ "$refresh" == yes ]]; then
    refresh_ticket "$branch" "$ref" "$current" || return 1
    git merge-base --is-ancestor HEAD "$ref" && contains_head=yes
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

# Merges each <branch> <title> pair in order, then checks and pushes once. A leading --refresh
# first brings each branch that lacks HEAD up to it.
merge_ticket() {
  local current start all_contain_head=yes ref contains_head red refresh=no
  if [[ "${1:-}" == --refresh ]]; then
    refresh=yes
    shift
  fi
  current=$(git branch --show-current)
  start=$(git rev-parse HEAD)
  [[ -z "$current" || "$current" == master ]] || integration_branch_warning "$current" >&2
  git fetch -q origin
  red=$(red_tip_refusal "$(ci_runs "$start")")
  if [[ -n "$red" ]]; then
    echo "merge-ticket: $red" >&2
    return 1
  fi
  while (( $# >= 2 )); do
    if ! merge_one "$1" "$2" "$current" "$refresh"; then
      [[ "$(git rev-parse HEAD)" == "$start" ]] \
        || echo "merge-ticket: stopped at $1; the merges before it are committed and not pushed" >&2
      return 1
    fi
    [[ "$contains_head" == yes ]] || all_contain_head=no
    shift 2
  done

  if [[ "$all_contain_head" == yes ]] && ci_checks_pushes "$current"; then
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
  pairs=$#
  [[ "${1:-}" == --refresh ]] && pairs=$(( $# - 1 ))
  if (( pairs < 2 || pairs % 2 != 0 )); then
    echo "usage: scripts/merge-ticket.sh [--refresh] <branch> <title> [<branch> <title> ...]" >&2
    echo "       scripts/merge-ticket.sh --checks-and-push <integration branch>" >&2
    exit 2
  fi
  cd "$(git rev-parse --show-toplevel)"
  merge_ticket "$@"
fi
