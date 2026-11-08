#!/usr/bin/env bash
# Checks scripts/ship-branch.sh against a stub gh and a throwaway origin: it reuses or opens the
# PR, waits past "no checks reported", merges only when the checks pass, and then deletes the
# remote branch, the worktree and the local branch; it refuses master, a branch with no PR and
# no --title, and a run from inside the branch's worktree.
# shellcheck disable=SC2016 # check() evals its single-quoted conditions later
set -euo pipefail

script="$(cd "$(dirname "$0")" && pwd)/ship-branch.sh"
dir=$(mktemp -d)
trap 'rm -rf "$dir"' EXIT
mkdir "$dir/bin"
# The stub logs each call on one line. `pr list` answers GH_STUB_PR (a number, or nothing);
# the first GH_STUB_NOCHECKS `pr checks` calls answer "no checks reported" and exit 1; after
# that a check passes, or fails when GH_STUB_FAIL_CHECK is set; `pr create` answers a URL.
cat > "$dir/bin/gh" <<'STUB'
#!/usr/bin/env bash
echo "$*" >> "$GH_STUB_LOG"
case "$1 $2" in
  "pr list") [[ -n "${GH_STUB_PR:-}" ]] && echo "$GH_STUB_PR"; exit 0 ;;
  "pr create") echo "https://github.com/Kyu-seok/CodeBite/pull/9"; exit 0 ;;
  "pr checks")
    count=$(( $(cat "$GH_STUB_COUNT" 2>/dev/null || echo 0) + 1 )); echo "$count" > "$GH_STUB_COUNT"
    if (( count <= ${GH_STUB_NOCHECKS:-0} )); then echo "no checks reported on the branch"; exit 1; fi
    if [[ -n "${GH_STUB_FAIL_CHECK:-}" ]]; then echo "backend-test	fail	1m"; exit 1; fi
    echo "backend-test	pass	1m"; exit 0 ;;
  *) exit 0 ;;
esac
STUB
chmod +x "$dir/bin/gh"
echo "body" > "$dir/body.md"

# A bare origin, a main checkout on master, and a worktree on branch feat pushed to origin.
git init -q --bare "$dir/origin.git"
git -C "$dir/origin.git" symbolic-ref HEAD refs/heads/master
git clone -q "$dir/origin.git" "$dir/main" 2>/dev/null
main="$dir/main"
git -C "$main" -c user.name=t -c user.email=t@t commit -q --allow-empty -m init
git -C "$main" push -q origin master 2>/dev/null
reset_branch() {
  git -C "$main" worktree remove --force "$dir/wt" 2>/dev/null || true
  git -C "$main" branch -D feat >/dev/null 2>&1 || true
  git -C "$main" push -q origin --delete feat 2>/dev/null || true
  git -C "$main" worktree add -q "$dir/wt" -b feat master
  git -C "$dir/wt" -c user.name=t -c user.email=t@t commit -q --allow-empty -m feat
  git -C "$dir/wt" push -q -u origin feat 2>/dev/null
}

fail=0
# run <cwd> <args...>: sets out, err, status and log for one call of the script from <cwd>.
run() {
  local cwd=$1; shift
  : > "$dir/log"; rm -f "$dir/count"
  status=0
  out=$(cd "$cwd" && PATH="$dir/bin:$PATH" GH_STUB_LOG="$dir/log" GH_STUB_COUNT="$dir/count" SHIP_BRANCH_POLL=0 "$script" "$@" 2> "$dir/err") || status=$?
  err=$(cat "$dir/err"); log=$(cat "$dir/log")
}
check() { if ! eval "$2"; then echo "FAIL: $1"; echo "  out=$out status=$status err=$err"; echo "  log=$log"; fail=1; fi; }
remote_has() { git -C "$dir/origin.git" show-ref -q --verify "refs/heads/$1"; }
local_has() { git -C "$main" show-ref -q --verify "refs/heads/$1"; }

reset_branch
run "$main" master
check "master is refused" '[[ $status == 2 && -z $log ]]'

run "$dir/wt" feat
check "a run from the branch's own worktree is refused before any gh call" '[[ $status == 2 && $err == *"main checkout"* && -z $log ]]'

run "$main" feat
check "no PR and no --title exits 2 after looking for the PR" '[[ $status == 2 && $err == *"no open PR"* && $(wc -l <<<"$log") -eq 1 ]]'
check "nothing was deleted" 'remote_has feat && local_has feat && [[ -d $dir/wt ]]'

GH_STUB_PR=7 GH_STUB_NOCHECKS=2 run "$main" feat
check "an open PR is reused and merged" '[[ $status == 0 ]] && grep -qx "pr merge 7 --squash" <<<"$log"'
check "it waited past the two no-checks answers before watching" '[[ $(grep -c "^pr checks 7$" <<<"$log") -ge 3 ]] && grep -q "^pr checks 7 --watch" <<<"$log"'
check "the remote branch, the worktree and the local branch are gone" '! remote_has feat && ! local_has feat && [[ ! -d $dir/wt ]]'
check "it reports the merge" '[[ $out == *"merged #7"* && $out == *"$dir/wt"* ]]'

reset_branch
GH_STUB_PR=7 GH_STUB_FAIL_CHECK=1 run "$main" feat
check "a failed check exits 1 and names it" '[[ $status == 1 && $err == *"backend-test"* ]]'
check "a failed check merges and deletes nothing" '! grep -q "pr merge" <<<"$log" && remote_has feat && local_has feat && [[ -d $dir/wt ]]'

run "$main" feat --title "feat: thing" --body-file "$dir/body.md"
check "with --title and --body-file it opens the PR and merges it" \
  'grep -qx "pr create --base master --head feat --title feat: thing --body-file $dir/body.md" <<<"$log" && grep -qx "pr merge 9 --squash" <<<"$log"'
check "the opened PR's branch is cleaned up too" '[[ $status == 0 ]] && ! remote_has feat && ! local_has feat'

run "$main"
check "no branch prints usage" '[[ $status == 2 && $err == usage:* ]]'

exit $fail
