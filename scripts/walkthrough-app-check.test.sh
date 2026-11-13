#!/usr/bin/env bash
# Checks scripts/walkthrough-app-check.mjs without Chrome or servers: it parses, and it refuses
# missing arguments with its usage and exit 2 before starting anything.
set -uo pipefail
script="$(cd "$(dirname "$0")" && pwd)/walkthrough-app-check.mjs"
fail=0
node --check "$script" || { echo "FAIL: does not parse"; fail=1; }
out=$(node "$script" http://127.0.0.1:1 http://127.0.0.1:1/api /tmp/x 2>&1); code=$?
[[ $code == 2 && "$out" == *usage:* ]] || { echo "FAIL: a missing slug must print usage and exit 2 (got $code: $out)"; fail=1; }
(( fail )) && exit 1
echo "PASS: walkthrough-app-check.mjs parses and refuses missing arguments"
