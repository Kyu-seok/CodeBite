#!/usr/bin/env bash
# Prints the path of a Python 3.12 or newer: the one way a script here finds the interpreter that
# tracers, the replay and the local judge need (this machine's python3 is 3.9).
#
#   python=$(scripts/python312.sh) || exit 2
#
# Tries $CODEBITE_PYTHON312 (a path or a name on PATH), then python3.12, then python3, and asks each
# its version: one that is missing, older or not a Python is passed over, never handed back. Exits 2
# with one line on stderr when none is left, with no prefix: a caller puts it after its own name.
# Shell builtins only, so it runs on any PATH.
set -uo pipefail

for candidate in "${CODEBITE_PYTHON312:-}" python3.12 python3; do
  [[ -n "$candidate" ]] || continue
  path=$(command -v "$candidate") || continue
  version=$("$path" -c 'import sys; print("%d.%d" % sys.version_info[:2])' 2>/dev/null) || continue
  [[ "$version" =~ ^([0-9]+)\.([0-9]+)$ ]] || continue
  if (( BASH_REMATCH[1] > 3 || (BASH_REMATCH[1] == 3 && BASH_REMATCH[2] >= 12) )); then
    printf '%s\n' "$path"
    exit 0
  fi
done

echo "no Python 3.12 or newer found: install python3.12 or set CODEBITE_PYTHON312 to one" >&2
exit 2
