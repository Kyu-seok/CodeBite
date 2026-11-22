#!/usr/bin/env bash
# Checks scripts/check-shell.sh in a scratch repository with shellcheck faked: a tracked .sh file
# outside scripts/, an empty one, one with a space in its path and extensionless files with a sh or
# bash shebang reach shellcheck at warning severity; a python or zsh shebang, a plain text file, an
# untracked .sh file and a tracked one deleted from the working tree don't; --list prints the same
# files and runs nothing; shellcheck's failing exit code is the script's.
set -euo pipefail

here="$(cd "$(dirname "$0")" && pwd)"
dir=$(mktemp -d)
trap 'rm -rf "$dir"' EXIT
fail=0
check() { [[ "$2" == "$3" ]] || { printf 'FAIL: %s\n  expected: %s\n  got:      %s\n' "$1" "$3" "$2"; fail=1; }; }

repo=$dir/repo
mkdir -p "$repo/scripts" "$repo/tools" "$repo/bin" "$repo/my tools" "$dir/bin"
git -C "$repo" init -q
cp "$here/check-shell.sh" "$repo/scripts/"
echo 'echo new' > "$repo/tools/new.sh"
: > "$repo/empty.sh"
echo 'echo spaced' > "$repo/my tools/space name.sh"
printf '#!/usr/bin/env bash\necho runner\n' > "$repo/bin/runner"
printf '#!/bin/sh -e\necho plain\n' > "$repo/bin/plain"
printf '#!/usr/bin/env python3\nprint(1)\n' > "$repo/bin/py"
printf '#!/bin/zsh\necho z\n' > "$repo/bin/z"
echo 'not a script' > "$repo/notes.txt"
echo 'echo gone' > "$repo/gone.sh"
git -C "$repo" add -A
rm "$repo/gone.sh"
echo 'echo untracked' > "$repo/untracked.sh"

# The fake shellcheck writes each argument on a line of its own and exits with $STUB_EXIT.
printf '#!/usr/bin/env bash\nprintf "%%s\\n" "$@" >> "$STUB_LOG"\nexit "${STUB_EXIT:-0}"\n' > "$dir/bin/shellcheck"
chmod +x "$dir/bin/shellcheck"
log=$dir/log
run() { PATH="$dir/bin:$PATH" STUB_LOG="$log" "$repo/scripts/check-shell.sh" "$@"; }

expected='bin/plain
bin/runner
empty.sh
my tools/space name.sh
scripts/check-shell.sh
tools/new.sh'

rm -f "$log"
code=0; run >/dev/null 2>&1 || code=$?
check "a run exits with shellcheck's 0" "$code" 0
check "shellcheck runs at warning severity" "$(head -2 "$log" 2>/dev/null | tr '\n' ' ')" "-S warning "
check "shellcheck reads the tracked shell files and nothing else" "$(tail -n +3 "$log" 2>/dev/null | sort)" "$expected"

rm -f "$log"
code=0; STUB_EXIT=3 run >/dev/null 2>&1 || code=$?
check "a failing shellcheck's exit code is the script's" "$code" 3

rm -f "$log"
listed=$(run --list)
check "--list prints the same files" "$(sort <<<"$listed")" "$expected"
[[ ! -e "$log" ]] || { echo "FAIL: --list must not run shellcheck"; fail=1; }

code=0; run --nonsense >/dev/null 2>&1 || code=$?
check "an unknown argument is a usage error" "$code" 2

(( fail )) && exit 1
echo "PASS: check-shell.sh shellchecks every tracked shell file"
