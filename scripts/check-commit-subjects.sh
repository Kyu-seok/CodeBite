#!/usr/bin/env bash
# Runs .githooks/commit-msg over every non-merge commit in a revision range, the 72-character subject
# limit that `git commit --no-verify` skips:
#
#   scripts/check-commit-subjects.sh <base>..<head>
#
# Names each commit whose subject is too long and exits 1 when there is one. Merge commits are left
# out, as the hook leaves out a "Merge …" subject: merge-ticket.sh's own run past 72 characters, and a
# squash-merge's subject is the PR title, never a commit in the range. Called by merge-ticket.sh on
# each ticket branch before merging it, and by CI's scripts-check job on a PR's or a push's commits.
set -euo pipefail
if (( $# != 1 )); then
  echo "usage: scripts/check-commit-subjects.sh <base>..<head>" >&2
  exit 2
fi
hook="$(cd "$(dirname "$0")/.." && pwd)/.githooks/commit-msg"
msg=$(mktemp); trap 'rm -f "$msg"' EXIT
bad=0
for sha in $(git rev-list --no-merges "$1"); do
  git log -1 --format=%B "$sha" > "$msg"
  if ! "$hook" "$msg" 2>/dev/null; then
    subject=$(git log -1 --format=%s "$sha")
    echo "check-commit-subjects: $(git rev-parse --short "$sha") has a ${#subject}-character subject, the limit is 72:" >&2
    echo "  $subject" >&2
    bad=1
  fi
done
if (( bad )); then
  echo "check-commit-subjects: reword them (git rebase -i, reword) and push again" >&2
  exit 1
fi
