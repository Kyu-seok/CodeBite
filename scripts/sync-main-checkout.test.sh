#!/usr/bin/env bash
# Checks .claude/hooks/sync-main-checkout.sh on scratch repositories: a bare origin, a main
# checkout cloned from it, and a second clone that moves origin's master.
set -uo pipefail

hook="$(cd "$(dirname "$0")/.." && pwd)/.claude/hooks/sync-main-checkout.sh"
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
fail=0
check() { # check <what> <actual> <expected>
  [[ $2 == "$3" ]] || { echo "FAIL: $1"; echo "  expected: $3"; echo "  actual:   $2"; fail=1; }
}
contains() { # contains <what> <text> <part>
  [[ $2 == *"$3"* ]] || { echo "FAIL: $1"; echo "  expected to contain: $3"; echo "  actual: $2"; fail=1; }
}
g() { git -c user.name=t -c user.email=t@example.invalid -c commit.gpgsign=false "$@"; }

# fresh <name>: origin with one commit on master, a main checkout at it, an upstream clone.
fresh() {
  w=$tmp/$1; mkdir -p "$w"
  g init -q --bare -b master "$w/origin.git"
  g clone -q "$w/origin.git" "$w/upstream" 2>/dev/null
  (cd "$w/upstream" && echo one >file && echo doc >CLAUDE.md && g add . && g commit -qm one && g push -q origin master)
  g clone -q "$w/origin.git" "$w/main"
}
# land <file>: a new commit on origin's master that changes <file>.
land() { (cd "$w/upstream" && mkdir -p "$(dirname "$1")" && echo "$RANDOM" >>"$1" && g add . && g commit -qm "change $1" && g push -q origin master); }
run() { out=$(CLAUDE_PROJECT_DIR=$1 "$hook" </dev/null 2>"$tmp/err"); code=$?; err=$(<"$tmp/err"); }
head_of() { git -C "$1" rev-parse HEAD; }

# Level with origin: nothing to say.
fresh level
run "$w/main"
check "level: exit 0" "$code" 0
check "level: silent" "$out$err" ""

# Clean, on master, behind: fast-forwards and says how far.
fresh behind
land file; land file
run "$w/main"
check "behind: exit 0" "$code" 0
check "behind: at origin's master" "$(head_of "$w/main")" "$(head_of "$w/upstream")"
contains "behind: says it fast-forwarded" "$out" "main checkout: fast-forwarded 2 commits to $(git -C "$w/main" rev-parse --short HEAD)"
[[ $out == *re-read* ]] && { echo "FAIL: behind: asks for a re-read though no instruction file changed: $out"; fail=1; }

# The commits it pulled change CLAUDE.md or .claude/: says to read them again.
fresh instructions
land CLAUDE.md
run "$w/main"
contains "instructions: names CLAUDE.md" "$out" "CLAUDE.md"
contains "instructions: asks for a re-read" "$out" "re-read"
fresh skills
land .claude/skills/x/SKILL.md
run "$w/main"
contains "skills: names .claude/" "$out" ".claude/"

# Untracked files don't stop it.
fresh untracked
land file
echo mine >"$w/main/untracked"
run "$w/main"
check "untracked: at origin's master" "$(head_of "$w/main")" "$(head_of "$w/upstream")"
check "untracked: file kept" "$(<"$w/main/untracked")" mine

# Local changes to tracked files: left alone, and says so with the command.
fresh dirty
land file
echo edit >>"$w/main/CLAUDE.md"
before=$(head_of "$w/main")
run "$w/main"
check "dirty: exit 0" "$code" 0
check "dirty: HEAD unmoved" "$(head_of "$w/main")" "$before"
contains "dirty: says how far behind" "$out" "main checkout: 1 commit behind origin/master, not fast-forwarded (local changes)"
contains "dirty: gives the command" "$out" "git stash && git merge --ff-only origin/master"

# On another branch: left alone.
fresh branch
land file
g -C "$w/main" switch -qc feature
before=$(head_of "$w/main")
run "$w/main"
check "branch: HEAD unmoved" "$(head_of "$w/main")" "$before"
contains "branch: says why" "$out" "not fast-forwarded (on feature, not master)"

# Diverged master: left alone.
fresh diverged
land file
(cd "$w/main" && echo local >local && g add . && g commit -qm local)
before=$(head_of "$w/main")
run "$w/main"
check "diverged: HEAD unmoved" "$(head_of "$w/main")" "$before"
contains "diverged: says why" "$out" "not fast-forwarded (master has commits origin/master lacks)"

# A worktree session is none of its business, even when the main checkout is behind.
fresh worktree
g -C "$w/main" worktree add -q "$w/wt" -b ticket
land file
before=$(head_of "$w/main")
run "$w/wt"
check "worktree: silent" "$out$err" ""
check "worktree: main checkout unmoved" "$(head_of "$w/main")" "$before"

# origin can't be reached: silent, exit 0, nothing moved.
fresh offline
land file
g -C "$w/main" remote set-url origin "$w/gone.git"
run "$w/main"
check "offline: exit 0" "$code" 0
check "offline: silent" "$out$err" ""

# Not a repository at all.
mkdir -p "$tmp/plain"
run "$tmp/plain"
check "no repository: exit 0" "$code" 0
check "no repository: silent" "$out$err" ""

(( fail )) && exit 1
echo "PASS: sync-main-checkout.sh fast-forwards a clean master and names what it leaves behind"
