#!/usr/bin/env bash
# Checks scripts/ship-branch.sh against a stub gh and a throwaway origin: it reuses or opens the
# PR, waits past "no checks reported", merges only when the checks pass, and then deletes the
# remote branch, the branch database scripts/dev-branch-servers.sh made for the worktree, the
# worktree and the local branch; it refuses master, a branch with no PR and
# no --title, a run from inside the branch's worktree, and a branch whose walkthrough kit copy
# fails scripts/copy-walkthrough-kit.py --check; and it refuses a PR body (open PR or --body-file) with
# an unticked task-list line outside a fenced block, unless --allow-unticked names it. It merges
# under the PR's own title and number, refusing a subject over 72 characters before CI.
# shellcheck disable=SC2016,SC2034,SC2329 # check() evals its single-quoted conditions (and the variables they read) later
set -euo pipefail

script="$(cd "$(dirname "$0")" && pwd)/ship-branch.sh"
dir=$(mktemp -d)
trap 'rm -rf "$dir"' EXIT
mkdir "$dir/bin"
# The stub logs each call on one line. `pr list` answers GH_STUB_PR (a number, or nothing);
# the first GH_STUB_NOCHECKS `pr checks` calls answer "no checks reported" and exit 1; after
# that a check passes, or fails when GH_STUB_FAIL_CHECK is set; `pr create` answers a URL;
# `pr view` answers GH_STUB_TITLE (default "feat: thing") when asked for the title, else
# GH_STUB_BODY, the PR's body.
cat > "$dir/bin/gh" <<'STUB'
#!/usr/bin/env bash
echo "$*" >> "$GH_STUB_LOG"
case "$1 $2" in
  "pr list") [[ -n "${GH_STUB_PR:-}" ]] && echo "$GH_STUB_PR"; exit 0 ;;
  "pr create") echo "https://github.com/Kyu-seok/CodeBite/pull/9"; exit 0 ;;
  "pr view")
    if [[ $* == *"--json title"* ]]; then printf '%s\n' "${GH_STUB_TITLE-feat: thing}"; else printf '%s\n' "${GH_STUB_BODY:-}"; fi
    exit 0 ;;
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
  # With "servers", the branch has a scripts/dev-branch-servers.sh stub that logs its calls and
  # the directory they run in; its drop fails when SERVERS_STUB_FAIL is set, and skips Kafka
  # (exiting 0, as dev-branch-servers.sh does with codebite-kafka stopped) when SERVERS_STUB_SKIP is.
  if [[ ${1:-} == servers ]]; then
    mkdir -p "$dir/wt/scripts"
    cat > "$dir/wt/scripts/dev-branch-servers.sh" <<'SERVERS'
#!/usr/bin/env bash
echo "servers $* in $PWD" >> "$GH_STUB_LOG"
[[ $1 == drop && -n "${SERVERS_STUB_FAIL:-}" ]] && exit 1
[[ $1 == drop && -n "${SERVERS_STUB_SKIP:-}" ]] && echo "codebite-kafka isn't running: topics and groups prefixed codebite_feat_1 left behind; once it runs: scripts/dev-branch-servers.sh drop in this worktree, or drop codebite_feat_1 once the worktree is gone" >&2
exit 0
SERVERS
    chmod +x "$dir/wt/scripts/dev-branch-servers.sh"
    git -C "$dir/wt" add scripts
    git -C "$dir/wt" -c user.name=t -c user.email=t@t commit -q -m servers
  fi
  # With "kit", the branch has a scripts/copy-walkthrough-kit.py stub that logs its arguments, the
  # directory it was run from and the kit it was given; it fails when KIT_STUB_FAIL is set.
  if [[ ${1:-} == kit ]]; then
    mkdir -p "$dir/wt/scripts"
    cat > "$dir/wt/scripts/copy-walkthrough-kit.py" <<'KIT'
import os, sys
from pathlib import Path
with open(os.environ["GH_STUB_LOG"], "a") as log:
    print("kit", *sys.argv[1:], "in", Path(__file__).resolve().parents[1].name,
          "with", os.environ.get("WALKTHROUGH_KIT", ""), file=log)
sys.exit(1 if os.environ.get("KIT_STUB_FAIL") else 0)
KIT
    git -C "$dir/wt" add scripts
    git -C "$dir/wt" -c user.name=t -c user.email=t@t commit -q -m kit
  fi
  git -C "$dir/wt" push -q -u origin feat 2>/dev/null
}

fail=0
# run <cwd> <args...>: sets out, err, status and log for one call of the script from <cwd>.
run() {
  local cwd=$1; shift
  : > "$dir/log"; rm -f "$dir/count"
  status=0
  out=$(cd "$cwd" && unset WALKTHROUGH_KIT && PATH="$dir/bin:$PATH" GH_STUB_LOG="$dir/log" GH_STUB_COUNT="$dir/count" SHIP_BRANCH_POLL=0 "$script" "$@" 2> "$dir/err") || status=$?
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
check "an open PR is reused and merged" '[[ $status == 0 ]] && grep -qx "pr merge 7 --squash --subject feat: thing (#7)" <<<"$log"'
check "it waited past the two no-checks answers before watching" '[[ $(grep -c "^pr checks 7$" <<<"$log") -ge 3 ]] && grep -q "^pr checks 7 --watch" <<<"$log"'
check "the remote branch, the worktree and the local branch are gone" '! remote_has feat && ! local_has feat && [[ ! -d $dir/wt ]]'
check "it reports the merge" '[[ $out == *"merged #7"* && $out == *"$dir/wt"* ]]'

# The squash subject is the title the PR has now, so a PR reused from an earlier push, or renamed
# on GitHub, merges under that title and not under --title.
reset_branch
GH_STUB_PR=7 GH_STUB_TITLE="Renamed on GitHub" run "$main" feat --title "stale title" --body-file "$dir/body.md"
check "a reused PR merges under its own title and number" \
  '[[ $status == 0 ]] && grep -qx "pr merge 7 --squash --subject Renamed on GitHub (#7)" <<<"$log"'

# GitHub's squash runs no commit-msg hook, so the 72-character subject limit is checked here,
# with " (#7)" counted, before CI is waited on.
reset_branch
GH_STUB_PR=7 GH_STUB_TITLE=$(printf 'x%.0s' {1..68}) run "$main" feat
check "a 73-character subject exits 1, names the length and how to retitle" \
  '[[ $status == 1 && $err == *"73 characters"* && $err == *"gh pr edit 7 --title"* ]]'
check "a too-long subject merges, deletes and waits on nothing" \
  '! grep -q "pr merge" <<<"$log" && ! grep -q "^pr checks" <<<"$log" && remote_has feat && local_has feat && [[ -d $dir/wt ]]'

title67=$(printf 'x%.0s' {1..67})
GH_STUB_PR=7 GH_STUB_TITLE=$title67 run "$main" feat
check "a subject of exactly 72 characters merges" '[[ $status == 0 ]] && grep -qx "pr merge 7 --squash --subject $title67 (#7)" <<<"$log"'

reset_branch
GH_STUB_PR=7 GH_STUB_FAIL_CHECK=1 run "$main" feat
check "a failed check exits 1 and names it" '[[ $status == 1 && $err == *"backend-test"* ]]'
check "a failed check merges and deletes nothing" '! grep -q "pr merge" <<<"$log" && remote_has feat && local_has feat && [[ -d $dir/wt ]]'

run "$main" feat --title "feat: thing" --body-file "$dir/body.md"
check "with --title and --body-file it opens the PR and merges it" \
  'grep -qx "pr create --base master --head feat --title feat: thing --body-file $dir/body.md" <<<"$log" && grep -qx "pr merge 9 --squash --subject feat: thing (#9)" <<<"$log"'
check "the opened PR's branch is cleaned up too" '[[ $status == 0 ]] && ! remote_has feat && ! local_has feat'

check "a worktree with no branch servers script is not asked to drop" '! grep -q "^servers" <<<"$log"'

# The shipped worktree's branch database goes with it: its servers stopped, then dropped, from
# inside the worktree before it is removed.
reset_branch servers
wt_real=$(cd "$dir/wt" && pwd -P)
GH_STUB_PR=7 run "$main" feat
check "it stops the branch servers, then drops their data, in the worktree" \
  '[[ $status == 0 && $(grep "^servers" <<<"$log" | paste -sd"|" -) == "servers stop in $wt_real|servers drop in $wt_real" ]]'
check "the worktree is gone after the drop" '[[ ! -d $dir/wt ]] && ! local_has feat'

reset_branch servers
GH_STUB_PR=7 SERVERS_STUB_FAIL=1 run "$main" feat
check "a failed drop still ships, and says how to drop it later" \
  '[[ $status == 0 && ! -d $dir/wt && $err == *"dev-branch-servers.sh orphans"* ]]'

reset_branch servers
GH_STUB_PR=7 SERVERS_STUB_SKIP=1 run "$main" feat
check "a drop that skipped Kafka ships with its own line, and no warning that it failed" \
  '[[ $status == 0 && ! -d $dir/wt && $err == *"drop codebite_feat_1"* && $err != *"couldn'\''t drop"* ]]'

# The walkthrough kit copy is checked on the branch's tree before merging, with the kit beside the
# main checkout; a failing check ships nothing.
mkdir -p "$dir/walkthrough-skill/kit"
reset_branch kit
GH_STUB_PR=7 KIT_STUB_FAIL=1 run "$main" feat
check "a failing kit check exits 1, before waiting on CI" \
  '[[ $status == 1 && $err == *"copy-walkthrough-kit"* ]] && ! grep -q "^pr checks" <<<"$log"'
check "a failing kit check merges and deletes nothing" '! grep -q "pr merge" <<<"$log" && remote_has feat && local_has feat && [[ -d $dir/wt ]]'
GH_STUB_PR=7 run "$main" feat
check "the branch's own copy-walkthrough-kit.py checks, given the kit beside the main checkout" \
  '[[ $status == 0 ]] && grep -q "^kit --check in .* with $(cd "$dir" && pwd -P)/walkthrough-skill$" <<<"$log" && grep -qx "pr merge 7 --squash --subject feat: thing (#7)" <<<"$log"'
rm -rf "$dir/walkthrough-skill"

# An unticked task-list line anywhere in the PR body stops the merge before CI is waited on.
reset_branch
GH_STUB_PR=7 GH_STUB_BODY=$'## Evidence\n- [x] tests pass\n  - [ ] compare with prod-text.sh' run "$main" feat
check "an unticked box under any heading exits 1 and quotes the line" \
  '[[ $status == 1 && $err == *"  - [ ] compare with prod-text.sh"* && $err != *"tests pass"* ]]'
check "an unticked box merges, deletes and waits on nothing" \
  '! grep -q "pr merge" <<<"$log" && ! grep -q "^pr checks" <<<"$log" && remote_has feat && local_has feat && [[ -d $dir/wt ]]'

GH_STUB_PR=7 GH_STUB_BODY=$'* [ ] star item\r\n- [x] done' run "$main" feat --allow-unticked
check "--allow-unticked merges and names the lines it let through" \
  '[[ $status == 0 && $err == *"--allow-unticked"* && $err == *"* [ ] star item"* && $err != *"done"* ]] && grep -qx "pr merge 7 --squash --subject feat: thing (#7)" <<<"$log"'

reset_branch
GH_STUB_PR=7 GH_STUB_BODY=$'## Checks\n- [x] tests pass\n* [X] lint' run "$main" feat
check "a body with only ticked boxes merges as before" '[[ $status == 0 && -z $err ]] && grep -qx "pr merge 7 --squash --subject feat: thing (#7)" <<<"$log"'

reset_branch
GH_STUB_PR=7 GH_STUB_BODY=$'Template:\n```markdown\n- [ ] in a fence\n```\n~~~\n  * [ ] tilde fence\n~~~\n```diff\n-- [ ] quoted diff line in a fence\n```\n-- [ ] quoted diff line\n> - [ ] quoted\nsee 1. [ ] later\n```\n- [ ] in an unclosed fence' run "$main" feat
check "boxes in fenced blocks and quoted diff lines don't stop the merge" '[[ $status == 0 ]] && grep -qx "pr merge 7 --squash --subject feat: thing (#7)" <<<"$log"'

# A fence closes only on a line of its own character, at least as long, with nothing after it; so
# a box after a closed fence, or after an inner line that only looks like a fence, still stops it.
reset_branch
for shape in \
  "a closed fence"$'\n```\n- [ ] in the fence\n```' \
  "a four-backtick fence with a three-backtick line"$'\n````\n```\n````' \
  "a backtick fence with a tilde line"$'\n```\n~~~\n```' \
  "a tilde fence with a backtick line"$'\n~~~\n```\n~~~' \
  "a backtick fence with a longer closing line"$'\n```sh\n``` x\n`````' \
  "one-line inline code"$'\n```foo```'; do
  GH_STUB_PR=7 GH_STUB_BODY="${shape#*$'\n'}"$'\n- [ ] after the fence' run "$main" feat
  check "a box after ${shape%%$'\n'*} stops the merge" \
    '[[ $status == 1 && $err == *"- [ ] after the fence"* && $err != *"in the fence"* ]] && ! grep -q "pr merge" <<<"$log"'
done

# GitHub renders these as unticked tasks too; text before the marker makes it not a task.
for line in '+ [ ] plus' '1. [ ] ordered' '12) [ ] ordered paren' '-   [ ] spaces' $'*\t[ ] tab'; do
  GH_STUB_PR=7 GH_STUB_BODY=$'## Notes\n'"$line" run "$main" feat
  check "an unticked '$line' stops the merge" '[[ $status == 1 && $err == *"$line"* ]] && ! grep -q "pr merge" <<<"$log"'
done

reset_branch
git -C "$main" push -q origin --delete feat
printf '%s\n' '# Summary' '- [ ] run prod-text.sh' > "$dir/unticked.md"
run "$main" feat --title "feat: thing" --body-file "$dir/unticked.md"
check "a --body-file with an unticked box is refused before the push and the PR" \
  '[[ $status == 1 && $err == *"- [ ] run prod-text.sh"* ]] && ! remote_has feat && ! grep -q "^pr create" <<<"$log" && local_has feat && [[ -d $dir/wt ]]'

run "$main"
check "no branch prints usage" '[[ $status == 2 && $err == usage:* ]]'

exit $fail
