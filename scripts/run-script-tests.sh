#!/usr/bin/env bash
# Runs every script test: each scripts/*.test.sh, and each scripts/*.test.py under python3 -I.
# CI's scripts-check job and the pre-commit hook both call this, so a new test is picked up by its
# file name alone, with nothing to register. Runs them all, then exits 1 if any failed.
set -uo pipefail

cd "$(dirname "$0")/.." || exit 2
failed=()
for t in scripts/*.test.sh scripts/*.test.py; do
  [[ -e "$t" ]] || continue
  echo "== $t"
  if [[ "$t" == *.py ]]; then python3 -I "$t"; else "$t"; fi || failed+=("$t")
done

if (( ${#failed[@]} )); then
  printf 'run-script-tests: failed: %s\n' "${failed[@]}" >&2
  exit 1
fi
echo "run-script-tests: all passed"
