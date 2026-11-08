#!/usr/bin/env bash
# Tests for .githooks/commit-msg: the 72-character subject limit.
set -uo pipefail
cd "$(dirname "$0")/.." || exit 2
hook=.githooks/commit-msg
tmp=$(mktemp -d); trap 'rm -rf "$tmp"' EXIT
fails=0
expect() { # <expected exit> <description> <message>
  printf '%s\n' "$3" > "$tmp/msg"
  "$hook" "$tmp/msg" >/dev/null 2>&1; got=$?
  if [[ $got -ne $1 ]]; then echo "FAIL: $2 (exit $got, wanted $1)"; fails=$((fails+1)); else echo "ok: $2"; fi
}
long72=$(printf 'feat(seo): %s' "$(printf 'x%.0s' $(seq 61))")   # exactly 72
expect 0 "a 72-character subject passes" "$long72"
expect 1 "a 73-character subject fails" "${long72}x"
expect 0 "fixup! prefix is not counted" "fixup! $long72"
expect 0 "a merge subject is left alone" "Merge branch 'x' into a-very-long-branch-name-that-runs-well-past-seventy-two-characters"
expect 0 "comment lines are skipped" "$(printf '# a comment longer than seventy-two characters ... %s\n%s' "$long72$long72" "$long72")"
expect 0 "a body may be any length" "$(printf '%s\n\n%s%s' "$long72" "$long72" "$long72")"
(( fails == 0 ))
