#!/usr/bin/env bash
# Runs ./gradlew with the given arguments, one Gradle run on this machine at a time: the machine has
# 8 GB, and two test runs from two worktrees at once starve each other. Waits for a run another
# worktree holds, saying whose; takes over a lock its holder left by dying; passes Gradle's exit code.
#
#   scripts/gradle-test.sh :backend:test --tests 'com.codebite.problem.*'
#
# The lock is a directory, made atomically by mkdir (CODEBITE_GRADLE_LOCK, default
# /tmp/codebite-gradle.lock), whose `owner` file holds the pid, the worktree and the arguments.
# A Gradle run inside one that holds the lock (a git hook under merge-ticket.sh) runs straight away.
# Runs from the repo root this script lives in, or CODEBITE_ROOT (for tests).
set -uo pipefail

root=${CODEBITE_ROOT:-$(cd "$(dirname "$0")/.." && pwd)}
lock=${CODEBITE_GRADLE_LOCK:-/tmp/codebite-gradle.lock}
poll=${CODEBITE_GRADLE_POLL:-5}

held_by_ancestor() { [[ -n "${CODEBITE_GRADLE_LOCK_HOLDER:-}" && -e "$lock/owner" ]] \
  && [[ "$(cut -d' ' -f1 "$lock/owner" 2>/dev/null)" == "$CODEBITE_GRADLE_LOCK_HOLDER" ]]; }

if ! held_by_ancestor; then
  said=
  until mkdir "$lock" 2>/dev/null; do
    owner=$(cat "$lock/owner" 2>/dev/null || true)
    pid=${owner%% *}
    if [[ -n "$pid" ]] && ! kill -0 "$pid" 2>/dev/null; then
      echo "gradle-test: taking over a stale Gradle lock from dead pid $pid ($owner)" >&2
      rm -rf "$lock"
      continue
    fi
    if [[ -z "$said" ]]; then
      echo "gradle-test: waiting for the Gradle lock, held by ${owner:-a run that is starting} ($lock)" >&2
      said=1
    fi
    sleep "$poll"
  done
  echo "$$ $root $*" > "$lock/owner"
  trap 'rm -rf "$lock"' EXIT
  trap 'exit 130' INT
  trap 'exit 143' TERM
  trap 'exit 129' HUP
  export CODEBITE_GRADLE_LOCK_HOLDER=$$
fi

cd "$root" || exit 2
./gradlew "$@"
