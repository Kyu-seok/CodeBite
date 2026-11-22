#!/usr/bin/env bash
# Writes the body of an integration branch's PR from the batch's state directory, and puts it on the PR:
#
#   scripts/integration-pr-body.sh [--print] <integration branch> <state directory> <ticket>...
#
# <state directory>/merge-log.md has one line per merge, oldest first:
#   <ticket numbers, space separated>|<ticket branch>|<what changed>|<what is owed after merge, or ->
# <state directory>/pr-notes/<n>.md (optional) is what ticket <n> asks the PR to record; it becomes
# that ticket's section once the merge log names the ticket.
#
# The body names the tickets, the state directory and the branch's tip (`git rev-parse --short
# <branch>` in the current checkout), lists the merges in log order with what each owes, the
# tickets no merge names yet, each merged ticket's notes, and one `Closes #<n>` per merged ticket,
# tickets in the order given. Run it again after each merge: it writes <state directory>/pr-body.md
# and, when the branch has a PR, sets that PR's body to the file. --print prints the body to stdout
# and writes nothing. Bad arguments exit 2.
set -euo pipefail

usage() {
  echo "usage: $0 [--print] <integration branch> <state directory> <ticket>..." >&2
  exit 2
}
die() { echo "integration-pr-body: $*" >&2; usage; }

print=0
if [[ ${1:-} == --print ]]; then print=1; shift; fi
(( $# >= 3 )) || usage
branch=$1
[[ -d $2 ]] || die "no such state directory: $2"
state=$(cd "$2" && pwd)
shift 2
tickets=()
for t in "$@"; do
  [[ ${t#\#} =~ ^[0-9]+$ ]] || die "not a ticket number: $t"
  tickets+=("${t#\#}")
done
tip=$(git rev-parse --short --verify --quiet "$branch^{commit}") || die "no branch $branch in this checkout"

log=$state/merge-log.md
merged=' '
if [[ -f $log ]]; then
  while IFS='|' read -r numbers _; do merged+="$numbers "; done <"$log"
fi
is_merged() { [[ $merged == *" $1 "* ]]; }

body() {
  local words=(Zero One Two Three Four Five Six Seven Eight Nine Ten Eleven Twelve)
  local n=${#tickets[@]} count noun=tickets numbers pending=() t
  count=${words[n]:-$n}
  (( n == 1 )) && noun=ticket
  numbers=$(printf ' #%s' "${tickets[@]}")
  echo "$count $noun (${numbers# }) with no spec, landed on one integration branch."
  echo
  local shown=$state
  [[ $state == "$HOME"/* ]] && shown="~${state#"$HOME"}"
  echo "State directory: \`$shown/\` (brief: \`BRIEF.md\`, merge log: \`merge-log.md\`). Integration tip: \`$tip\`."
  echo
  echo "## Merged"
  echo
  if [[ -s $log ]]; then
    local line numbers_in tbranch what owed
    while IFS='|' read -r numbers_in tbranch what owed; do
      [[ -n $numbers_in ]] || continue
      line="-"
      for t in $numbers_in; do line+=" #$t"; done
      line+=" (\`$tbranch\`): $what"
      [[ -n $owed && $owed != - ]] && line+=" **Owed:** $owed"
      echo "$line"
    done <"$log"
  else
    echo "Nothing yet."
  fi
  echo
  for t in "${tickets[@]}"; do is_merged "$t" || pending+=("#$t"); done
  if (( ${#pending[@]} )); then
    echo "## Not merged yet"
    echo
    echo "${pending[*]}"
    echo
  fi
  for t in "${tickets[@]}"; do
    if is_merged "$t" && [[ -f $state/pr-notes/$t.md ]]; then
      echo "## #$t"
      echo
      cat "$state/pr-notes/$t.md"
      echo
    fi
  done
  for t in "${tickets[@]}"; do
    if is_merged "$t"; then echo "Closes #$t"; fi
  done
  echo
  echo "🤖 Generated with [Claude Code](https://claude.com/claude-code)"
}

if (( print )); then
  body
  exit 0
fi
body >"$state/pr-body.md"
pr=$(gh pr list --head "$branch" --json number --jq '.[0].number // empty')
if [[ -n $pr ]]; then
  gh pr edit "$pr" --body-file "$state/pr-body.md" >/dev/null
  echo "PR #$pr body updated (tip $tip)"
else
  echo "no PR yet; body written to $state/pr-body.md"
fi
