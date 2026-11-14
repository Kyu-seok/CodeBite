#!/usr/bin/env bash
# Says whether CI already tested a commit's exact tree, so Deploy can skip re-running the tests
# (docs/adr/0013):
#
#   scripts/tested-tree.sh <sha>
#
# Prints the commit whose CI run covered the same git tree and exits 0, or exits 1 when there is
# none. The candidates are <sha> itself and the head of every PR GitHub associates with it, which
# for a squash merge is the PR it came from: when that PR's branch already contained master, the
# squash commit has the very tree the PR's CI tested. A CI run counts only when it succeeded with
# every job succeeding, not skipped (a PR from an integration branch skips its jobs; ci.yml), apart
# from notify-failure, which a green run always skips.
# Any error from gh also exits 1, so a doubt always means testing.
set -uo pipefail

[[ $# -eq 1 ]] || { echo "usage: scripts/tested-tree.sh <sha>" >&2; exit 2; }
sha=$1
repo=${GITHUB_REPOSITORY:-$(gh repo view --json nameWithOwner -q .nameWithOwner)} || exit 1

tree_of() { gh api "repos/$repo/commits/$1" --jq .commit.tree.sha; }

tree=$(tree_of "$sha") && [[ -n $tree ]] || exit 1
heads=$(gh api "repos/$repo/commits/$sha/pulls" --jq '.[].head.sha') || heads=""

for c in "$sha" $heads; do
  [[ $c == "$sha" ]] || [[ $(tree_of "$c") == "$tree" ]] || continue
  runs=$(gh api "repos/$repo/actions/workflows/ci.yml/runs?head_sha=$c&status=success" \
    --jq '.workflow_runs[].id') || continue
  for run in $runs; do
    ok=$(gh api "repos/$repo/actions/runs/$run/jobs" \
      --jq '[.jobs[] | select(.name != "notify-failure")] | length > 0 and all(.[]; .conclusion == "success")') \
      || continue
    if [[ $ok == true ]]; then
      echo "tested-tree: CI run $run tested $c, whose tree is $sha's" >&2
      echo "$c"
      exit 0
    fi
  done
done
echo "tested-tree: no successful CI run tested $sha's tree" >&2
exit 1
