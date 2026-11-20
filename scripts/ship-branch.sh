#!/usr/bin/env bash
# Ships a finished ticket branch through its own PR, the one-PR-per-ticket path
# (scripts/merge-ticket.sh is the integration-branch path):
#
#   scripts/ship-branch.sh <branch> [<branch> ...] [--title <title> --body-file <file>] [--allow-unticked]
#
# Run it from the main checkout. For each branch it fetches, reuses the branch's open PR (or opens
# one when given --title and --body-file, pushing the branch first), runs the branch's
# scripts/copy-walkthrough-kit.py --check with the kit on this machine (CI has no kit), waits for
# CI to register and finish,
# squash-merges, then deletes the remote branch, the worktree checked out on it (first stopping
# its branch servers and dropping their database: scripts/dev-branch-servers.sh) and the local
# branch. It refuses master, a branch with no PR and no --title, and a run from inside that
# branch's own worktree (the cleanup would remove the directory it runs in). When a check fails
# it names it and leaves everything in place.
#
# Several branches ship in the order given, each through its own open PR; the first that fails
# stops the run with its exit status, and the branches not reached are named and untouched.
# --title and --body-file describe one PR, so they are refused with more than one branch;
# --allow-unticked covers every branch given.
#
# It never ships with a copy of itself older than origin/master's. After each fetch (before the
# first branch, between branches, after the last merge), a checkout on a clean master behind
# origin/master is fast-forwarded, and when that changed this file the run starts again from it
# with the branches still to ship. A checkout that can't be fast-forwarded (another branch, local
# changes to tracked files, diverged) ships on only while its scripts/ship-branch.sh is
# origin/master's; otherwise it exits 1 before any push or PR, with the command that updates it.
#
# Before anything is pushed or waited on, it reads the PR body (the open PR's, or --body-file's
# for a PR it opens) and refuses, printing them, any unticked task-list lines (`- [ ]`, `* [ ]`,
# `+ [ ]`, `1. [ ]` or `1) [ ]` after optional indentation, outside fenced code blocks; see
# unticked_lines): a step left for the user, such as a production comparison, can't merge
# silently. --allow-unticked merges anyway and prints the lines it let through.
#
# The squash commit's subject is the PR's title as GitHub has it (read back from the PR, so a
# reused or renamed PR is covered) followed by " (#<n>)"; without it GitHub takes a one-commit
# PR's subject from the commit. The body is left to GitHub (this repo: the commits' messages).
# A subject over 72 characters is refused, naming its length, before CI is waited on: the
# commit-msg hook never sees a server-side squash.
#
# Why it waits before watching: for the first seconds after a PR opens, `gh pr checks` answers
# "no checks reported" and exits 1, which `--watch` would take for a finished run.
# SHIP_BRANCH_POLL is the seconds between those looks (default 10).
set -euo pipefail

usage() { echo "usage: scripts/ship-branch.sh <branch> [<branch> ...] [--title <title> --body-file <file>] [--allow-unticked]" >&2; exit 2; }
branches=(); title=""; body=""; allow_unticked=""
while [[ $# -gt 0 ]]; do
  case $1 in
    --title) [[ $# -ge 2 ]] || usage; title=$2; shift 2 ;;
    --body-file) [[ $# -ge 2 ]] || usage; body=$2; shift 2 ;;
    --allow-unticked) allow_unticked=1; shift ;;
    -*) usage ;;
    *) branches+=("$1"); shift ;;
  esac
done
(( ${#branches[@]} )) || usage
if (( ${#branches[@]} > 1 )) && [[ -n $title || -n $body ]]; then
  echo "ship-branch: --title and --body-file open one PR, so they go with one branch; open the others' PRs first" >&2
  exit 2
fi

# Stops the branch servers worktree $1 ran with scripts/dev-branch-servers.sh and drops their
# database, Kafka topics and Redis index, from inside it: once it is gone,
# `dev-branch-servers.sh orphans` finds whatever is left. A failure (Postgres or Docker down, say)
# only warns. A stopped Kafka or Redis is no failure: drop drops the rest and says in a line each
# what it left and the drop that deletes it later, so no warning is added to that.
drop_branch_database() {
  local script="$1/scripts/dev-branch-servers.sh"
  [[ -x $script ]] || return 0
  if ! (cd "$1" && "$script" stop >/dev/null && "$script" drop); then
    echo "ship-branch: couldn't drop $1's branch database; later, from the main checkout: scripts/dev-branch-servers.sh orphans, then drop <name>" >&2
  fi
}

# Prints the unticked task-list lines of the PR body on stdin: a list marker (`-`, `*`, `+`, `1.`,
# `1)`) after optional indentation, then spaces or tabs and `[ ]`. A line with other text first (a
# quoted diff's `-- [ ]`, a quote's `> - [ ]`) is not one, nor is a line inside a fenced code
# block. A fence opens on 3 or more backticks or tildes (a backtick fence's info string has no
# backtick, so ```x``` is inline code) and closes only on a line of the same character, at least
# as long, with nothing after it; an unclosed fence runs to the end, as GitHub renders it.
unticked_lines() {
  awk '
    { sub(/\r$/, "") }
    fence != "" {
      if (match($0, /^[[:space:]]*(`+|~+)[[:space:]]*$/)) {
        run = $0; gsub(/[[:space:]]/, "", run)
        if (substr(run, 1, 1) == substr(fence, 1, 1) && length(run) >= length(fence)) fence = ""
      }
      next
    }
    match($0, /^[[:space:]]*(`+|~+)/) {
      run = substr($0, RSTART, RLENGTH); sub(/^[[:space:]]*/, "", run)
      info = substr($0, RSTART + RLENGTH)
      if (length(run) >= 3 && !(run ~ /^`/ && info ~ /`/)) { fence = run; next }
    }
    /^[[:space:]]*([-*+]|[0-9]+[.)])[[:space:]]+\[ \]/
  '
}

# Refuses PR #$1 (or "the new PR") when the body on stdin has unticked lines, unless
# --allow-unticked was given, in which case it names what it lets through.
check_unticked() {
  local lines
  lines=$(unticked_lines)
  [[ -n $lines ]] || return 0
  if [[ -n $allow_unticked ]]; then
    printf 'ship-branch: --allow-unticked: merging %s with these unticked lines:\n%s\n' "$1" "$lines" >&2
    return 0
  fi
  printf 'ship-branch: %s has unticked boxes, nothing merged (tick them, or pass --allow-unticked):\n%s\n' "$1" "$lines" >&2
  exit 1
}

# Ships branch $1 through its PR, start to cleanup. It exits on the first thing that stops it, so
# it runs in a subshell.
ship() {
  local branch=$1 worktree n url pr_body subject tree kit poll out
  worktree=$(worktree_of "$branch")
  n=$(gh pr list --head "$branch" --state open --json number --jq '.[0].number // empty')
  if [[ -z $n ]]; then
    if [[ -z $title || -z $body ]]; then
      echo "ship-branch: $branch has no open PR; pass --title and --body-file to open one" >&2
      exit 2
    fi
    check_unticked "the new PR" < "$body"
    git push -q -u origin "$branch"
    url=$(gh pr create --base master --head "$branch" --title "$title" --body-file "$body")
    n=${url##*/}
  else
    pr_body=$(gh pr view "$n" --json body --jq .body)
    check_unticked "#$n" <<<"$pr_body"
  fi
  echo "ship-branch: PR #$n"

  # The squash subject is the PR's title as it stands (a reused PR may have been renamed) and its
  # number. GitHub's squash runs no commit-msg hook, so its 72-character limit is checked here,
  # before CI is waited on.
  subject="$(gh pr view "$n" --json title --jq .title) (#$n)"
  if (( ${#subject} > 72 )); then
    echo "ship-branch: the squash subject \"$subject\" is ${#subject} characters, over 72; nothing merged. Shorten the title (gh pr edit $n --title …) and run again" >&2
    exit 1
  fi

  # CI can't see the walkthrough kit (it lives only on this machine), so the kit check that needs
  # it (the recorded kit commit is on the kit's main) runs here, on the branch's tree, with the kit
  # beside the main checkout.
  tree=$(mktemp -d)
  # shellcheck disable=SC2064 # the directory made just above, not whatever $tree holds at exit
  trap "rm -rf '$tree'" EXIT
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

  gh pr merge "$n" --squash --subject "$subject"
  git push -q origin --delete "$branch"
  if [[ -n $worktree ]]; then
    drop_branch_database "$worktree"
    git worktree remove "$worktree"
  fi
  if git show-ref -q --verify "refs/heads/$branch"; then git branch -D "$branch" >/dev/null; fi
  echo "ship-branch: merged #$n, deleted $branch${worktree:+ and $worktree}"
}

# The worktree checked out on branch $1, or nothing.
worktree_of() {
  git worktree list --porcelain | awk -v b="refs/heads/$1" '$1=="worktree"{w=$2} $1=="branch" && $2==b {print w}'
}

here=$(git rev-parse --show-toplevel)
for branch in "${branches[@]}"; do
  [[ $branch != master ]] || { echo "ship-branch: master is not shipped" >&2; exit 2; }
  worktree=$(worktree_of "$branch")
  if [[ -n $worktree && $here == "$worktree" ]]; then
    echo "ship-branch: run from the main checkout, not from $branch's worktree ($worktree): the cleanup removes it" >&2
    exit 2
  fi
done

# The options as given, for starting again.
options=()
[[ -z $title ]] || options+=(--title "$title")
[[ -z $body ]] || options+=(--body-file "$body")
[[ -z $allow_unticked ]] || options+=(--allow-unticked)

# Fetches, then brings this checkout to origin/master when that is a fast-forward of a clean
# master. When the fast-forward changed scripts/ship-branch.sh and branches are still to ship ($@),
# the script starts again from the new file with them. A checkout it can't fast-forward (another
# branch, local changes, diverged) ships on while its scripts/ship-branch.sh is origin/master's;
# with a different one, the branches still to ship are refused, since this copy may lack a fix
# already merged. With none left to ship (the call after the last merge) it only says so.
sync_checkout() {
  git fetch -q --prune origin
  git -C "$here" merge-base --is-ancestor origin/master HEAD && return 0
  local before on state fix
  before=$(git -C "$here" rev-parse HEAD)
  on=$(git -C "$here" symbolic-ref -q --short HEAD || echo "a detached HEAD")
  if [[ $on != master ]]; then
    state="is on $on"; fix="git switch master && git merge --ff-only origin/master"
  elif [[ -n $(git -C "$here" status --porcelain --untracked-files=no) ]]; then
    state="has local changes"; fix="git stash && git merge --ff-only origin/master"
  elif ! git -C "$here" merge -q --ff-only origin/master >/dev/null 2>&1; then
    state="has diverged from origin/master"; fix="git rebase origin/master"
  else
    if (( $# )) && [[ -x $here/scripts/ship-branch.sh ]] && ! git -C "$here" diff --quiet "$before" HEAD -- scripts/ship-branch.sh; then
      echo "ship-branch: fast-forwarded $here to origin/master; starting again from its scripts/ship-branch.sh" >&2
      exec "$here/scripts/ship-branch.sh" "$@" ${options[@]+"${options[@]}"}
    fi
    return 0
  fi
  if (( ! $# )); then
    echo "ship-branch: $here $state, so it stays behind origin/master. There: $fix" >&2
    return 0
  fi
  git -C "$here" diff --quiet origin/master -- scripts/ship-branch.sh && return 0
  echo "ship-branch: $here $state and its scripts/ship-branch.sh differs from origin/master's; not shipped: $*. There, first: $fix" >&2
  exit 1
}

# One brace group, so bash has read the rest of this file before a fast-forward replaces it.
{
  while (( ${#branches[@]} )); do
    sync_checkout "${branches[@]}"
    branch=${branches[0]}; branches=("${branches[@]:1}")
    status=0
    # Not `if ! (…)`: a tested subshell runs without errexit.
    set +e; (set -e; ship "$branch"); status=$?; set -e
    if (( status )); then
      if (( ${#branches[@]} )); then echo "ship-branch: stopped at $branch; not reached: ${branches[*]}" >&2; fi
      exit "$status"
    fi
  done
  sync_checkout
  exit 0
}
