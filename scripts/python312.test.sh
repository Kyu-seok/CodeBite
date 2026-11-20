#!/usr/bin/env bash
# Tests scripts/python312.sh on a PATH that holds only stand-in interpreters, each a script that
# answers one version whatever it is asked, so the result never depends on this machine's Pythons.
set -euo pipefail
here=$(cd "$(dirname "$0")" && pwd)
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

fail() { echo "FAIL: $1" >&2; exit 1; }

# interpreter <path> <version>: a stand-in that answers that version (nothing: it prints nothing).
interpreter() {
  mkdir -p "$(dirname "$1")"
  printf '#!/bin/sh\necho %s\n' "${2:-}" > "$1"
  chmod +x "$1"
}

# find_in <bin directory>: the finder with only that directory on PATH; sets out, err and code.
find_in() {
  code=0
  out=$(PATH="$1" /bin/bash "$here/python312.sh" 2>"$tmp/err") || code=$?
  err=$(cat "$tmp/err")
}

interpreter "$tmp/plain/python3.12" 3.12
unset CODEBITE_PYTHON312
find_in "$tmp/plain"
[[ "$code" == 0 && "$out" == "$tmp/plain/python3.12" ]] \
  || fail "python3.12 on PATH should be printed by its path, got '$out' (exit $code) $err"

interpreter "$tmp/old/python3.12" 3.11
interpreter "$tmp/old/python3" 3.13
find_in "$tmp/old"
[[ "$code" == 0 && "$out" == "$tmp/old/python3" ]] \
  || fail "a python3.12 answering 3.11 should be passed over for a python3 answering 3.13, got '$out' (exit $code) $err"

# An override is tried first, and is asked its version like the rest.
interpreter "$tmp/elsewhere/mypython" 3.14
CODEBITE_PYTHON312="$tmp/elsewhere/mypython" find_in "$tmp/plain"
[[ "$code" == 0 && "$out" == "$tmp/elsewhere/mypython" ]] \
  || fail "an override answering 3.14 should win over python3.12 on PATH, got '$out' (exit $code) $err"

interpreter "$tmp/elsewhere/python3.9" 3.9
CODEBITE_PYTHON312="$tmp/elsewhere/python3.9" find_in "$tmp/plain"
[[ "$code" == 0 && "$out" == "$tmp/plain/python3.12" ]] \
  || fail "an override naming an older interpreter should be passed over, got '$out' (exit $code) $err"

CODEBITE_PYTHON312="$tmp/elsewhere/no-such-python" find_in "$tmp/plain"
[[ "$code" == 0 && "$out" == "$tmp/plain/python3.12" ]] \
  || fail "an override naming a missing interpreter should be passed over, got '$out' (exit $code) $err"

# Something that is not a Python: it answers no version, or fails when asked.
interpreter "$tmp/notpython/python3.12"
printf '#!/bin/sh\necho 3.12\nexit 1\n' > "$tmp/notpython/python3"; chmod +x "$tmp/notpython/python3"
find_in "$tmp/notpython"
[[ "$code" == 2 && -z "$out" ]] \
  || fail "an interpreter that answers no version or fails should be passed over, got '$out' (exit $code)"

interpreter "$tmp/none/python3" 3.9
CODEBITE_PYTHON312="$tmp/elsewhere/python3.9" find_in "$tmp/none"
[[ "$code" == 2 && -z "$out" ]] || fail "no 3.12 or newer should exit 2 printing no path, got '$out' (exit $code)"
[[ "$err" == *"install python3.12"* && "$err" == *"CODEBITE_PYTHON312"* && $(wc -l <<<"$err") -eq 1 ]] \
  || fail "exit 2 should say in one line to install python3.12 or set CODEBITE_PYTHON312, got '$err'"

echo "python312.test.sh: all passed"
