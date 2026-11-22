#!/usr/bin/env bash
# Runs shellcheck at warning severity over every tracked shell file: each path `git ls-files` lists
# that is still in the working tree and ends in .sh or starts with a sh, bash, dash or ksh shebang
# (#!/bin/sh, #!/usr/bin/env bash, ...), wherever it lives. The pre-commit hook, scripts/merge-ticket.sh's
# repo_checks and CI's scripts-check job call this and nothing else for shellcheck, so a shell file
# added anywhere is checked by all three (#443).
#
#   scripts/check-shell.sh          shellcheck them; exits with shellcheck's code
#   scripts/check-shell.sh --list   print them, one path per line, and run nothing
#
# It doesn't check that shellcheck is installed: its callers do. None is excluded today; an exclusion,
# if one is ever needed, is one commented line in the awk program below:
#   $0 == "<path>" { next }  # <why shellcheck can't read it>
set -euo pipefail

cd "$(dirname "$0")/.." || exit 2

# One awk reads the first line of every tracked file (getline returns -1 for one deleted from the
# working tree). quotePath=false keeps a path with a space or a non-ASCII character as it is.
shell_files() {
  git -c core.quotePath=false ls-files | LC_ALL=C awk '
    {
      first = ""
      found = (getline first < $0)
      close($0)
      if (found < 0) next
      if ($0 ~ /\.sh$/ || first ~ /^#![ \t]*\/([^ \t]*\/)?(env[ \t]+)?(sh|bash|dash|ksh)([ \t\r]|$)/) print
    }'
}

if [[ $# -gt 1 || ( $# -eq 1 && "$1" != --list ) ]]; then
  echo "usage: scripts/check-shell.sh [--list]" >&2
  exit 2
fi

list=$(shell_files)
if [[ $# -eq 1 ]]; then
  [[ -z "$list" ]] || printf '%s\n' "$list"
  exit 0
fi
if [[ -z "$list" ]]; then
  echo "check-shell: no tracked shell files found" >&2
  exit 2
fi

files=()
while IFS= read -r f; do files+=("$f"); done <<<"$list"
exec shellcheck -S warning "${files[@]}"
