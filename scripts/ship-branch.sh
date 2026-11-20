#!/usr/bin/env bash
# Ships a finished ticket branch through its own PR, the one-PR-per-ticket path
# (scripts/merge-ticket.sh is the integration-branch path):
#
#   scripts/ship-branch.sh <branch> [--title <title> --body-file <file>] [--allow-unticked]
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
# Before anything is pushed or waited on, it reads the PR body (the open PR's, or --body-file's
# for a PR it opens) and refuses, printing them, any unticked task-list lines (`- [ ]`, `* [ ]`,
# `+ [ ]`, `1. [ ]` or `1) [ ]` after optional indentation, outside fenced code blocks; see
# unticked_lines): a step left for the user, such as a production comparison, can't merge
# silently. --allow-unticked merges anyway and prints the lines it let through.
#
# Why it waits before watching: for the first seconds after a PR opens, `gh pr checks` answers
# "no checks reported" and exits 1, which `--watch` would take for a finished run.
# SHIP_BRANCH_POLL is the seconds between those looks (default 10).
set -euo pipefail

usage() { echo "usage: scripts/ship-branch.sh <branch> [--title <title> --body-file <file>] [--allow-unticked]" >&2; exit 2; }
[[ $# -ge 1 ]] || usage
branch=$1; shift
title=""; body=""; allow_unticked=""
while [[ $# -gt 0 ]]; do
  case $1 in
    --title) [[ $# -ge 2 ]] || usage; title=$2; shift 2 ;;
    --body-file) [[ $# -ge 2 ]] || usage; body=$2; shift 2 ;;
    --allow-unticked) allow_unticked=1; shift ;;
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
  check_unticked "the new PR" < "$body"
  git push -q -u origin "$branch"
  url=$(gh pr create --base master --head "$branch" --title "$title" --body-file "$body")
  n=${url##*/}
else
  pr_body=$(gh pr view "$n" --json body --jq .body)
  check_unticked "#$n" <<<"$pr_body"
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
