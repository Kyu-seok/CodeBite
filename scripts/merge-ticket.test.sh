#!/usr/bin/env bash
# Checks scripts/merge-ticket.sh without Gradle or npm: the usage line, when it refuses to merge, the merge commit's
# message, the warning on an integration branch CI doesn't run on, that the frontend checks lint with no warnings before the tests and build (npm faked), and
# (in scratch repositories with the checks faked) that a conflict aborts and lists the
# files, a failing check leaves the merge commit unpushed, green checks push it, a ticket that already
# contains the integration branch's HEAD is pushed with no checks, a ticket with a commit subject over
# 72 characters is refused, an unprefixed integration branch warns and still merges, a merge that changes
# merge-ticket.sh hands the checks and the push to the merged copy, and two tickets in one call get
# one run of the checks and one push, or stop at a conflict on the second with the first unpushed.
set -euo pipefail

script="$(cd "$(dirname "$0")" && pwd)/merge-ticket.sh"
# shellcheck source=SCRIPTDIR/merge-ticket.sh
source "$script"

fail=0
check() { [[ "$2" == "$3" ]] || { echo "FAIL: $1: expected '$3', got '$2'"; fail=1; }; }

# --- the usage line: both modes, the second also the rerun after a flaky check ----------------

usage_out=$(bash "$script" 2>&1) && { echo "FAIL: no arguments must exit non-zero"; fail=1; }
check "usage names both modes" "$usage_out" \
"usage: scripts/merge-ticket.sh <branch> <title> [<branch> <title> ...]
       scripts/merge-ticket.sh --checks-and-push <integration branch>"
usage_out=$(bash "$script" --checks-and-push 2>&1) && { echo "FAIL: --checks-and-push alone must exit non-zero"; fail=1; }
[[ "$usage_out" == *"--checks-and-push <integration branch>"* ]] \
  || { echo "FAIL: --checks-and-push without a branch must print the usage: $usage_out"; fail=1; }

# --- a red integration tip: CI's runs on HEAD, one "<conclusion> <url>" line each ------------------

check "no runs" "$(red_tip_refusal '')" ""
check "pending and green" "$(red_tip_refusal ' https://ci/1
success https://ci/2')" ""
check "red" "$(red_tip_refusal 'success https://ci/1
failure https://ci/2')" "refusing to merge onto a red integration tip: CI failure https://ci/2; fix it first (scripts/test-failures.sh)"
check "cancelled counts as red" "$(red_tip_refusal 'cancelled https://ci/3')" \
  "refusing to merge onto a red integration tip: CI cancelled https://ci/3; fix it first (scripts/test-failures.sh)"

# --- which integration branches CI checks on push (ci.yml) -------------------------------------

check "integration/ pushes run CI" "$(ci_checks_pushes integration/x && echo yes || echo no)" yes
check "spec/ pushes run CI" "$(ci_checks_pushes spec/258-walkthroughs && echo yes || echo no)" yes
check "other pushes run no CI" "$(ci_checks_pushes feat/x && echo yes || echo no)" no

# --- an integration branch CI doesn't run on: a loud warning, and the merge goes on ------------

check "no warning on spec/" "$(integration_branch_warning spec/301-statement-audit)" ""
check "no warning on integration/" "$(integration_branch_warning integration/x)" ""
check "warning elsewhere" "$(integration_branch_warning statement-audit-2026-11)" \
"merge-ticket: WARNING: CI doesn't run on pushes to statement-audit-2026-11 (only spec/** and integration/**),
merge-ticket: WARNING: so every merge runs the full local checks (about 1.5-3 min each), even a ticket
merge-ticket: WARNING: that already contains HEAD. Rename it before the next merge:
merge-ticket: WARNING:   git branch -m spec/<issue>-<slug> && git push -u origin spec/<issue>-<slug>"

# --- refusals ----------------------------------------------------------------------------------

check "on master" "$(merge_refusal master '' no)" "refusing to merge on master; check out the integration branch"
check "detached" "$(merge_refusal '' '' no)" "refusing to merge on a detached HEAD; check out the integration branch"
check "dirty tree" "$(merge_refusal integration/x ' M a.txt' no)" "refusing to merge into a dirty tree; commit or stash first"
check "already merged" "$(merge_refusal integration/x '' yes)" "already merged into integration/x"
check "clean and unmerged" "$(merge_refusal integration/x '' no)" ""

# --- the merge commit's message --------------------------------------------------------------

check "message" "$(merge_message ticket/130-merge-ticket 'Merge a ticket branch in one command')" \
  "Merge ticket/130-merge-ticket: Merge a ticket branch in one command

Co-Authored-By: Claude <noreply@anthropic.com>"
check "trailer from MERGE_TICKET_TRAILER" \
  "$(MERGE_TICKET_TRAILER='Co-Authored-By: X <x@x>' merge_message feat/a 'A')" "Merge feat/a: A

Co-Authored-By: X <x@x>"

# --- the frontend checks: lint (no warnings), tests and build, with npm faked ------------------

fe=$(mktemp -d)
mkdir -p "$fe/frontend/node_modules" "$fe/bin"
cat > "$fe/bin/npm" <<'NPM'
#!/usr/bin/env bash
echo "npm $*" >> "$NPM_LOG"
[[ "$*" != "${NPM_FAIL:-none}" ]]
NPM
chmod +x "$fe/bin/npm"
fe_run() { (cd "$fe" && PATH="$fe/bin:$PATH" NPM_LOG="$fe/log" frontend_checks) >/dev/null 2>&1; }
fe_run || { echo "FAIL: green frontend checks failed"; fail=1; }
check "frontend checks" "$(cat "$fe/log")" "npm run lint -- --max-warnings 0
npm test
npm run build"
rm -f "$fe/log"
if NPM_FAIL='run lint -- --max-warnings 0' fe_run; then echo "FAIL: a lint warning must fail the frontend checks"; fail=1; fi
check "lint fails first" "$(cat "$fe/log")" "npm run lint -- --max-warnings 0"
rm -rf "$fe"

# --- the whole merge, in scratch repositories with the checks faked ---------------------------

scratch=$(mktemp -d)
trap 'rm -rf "$scratch"' EXIT
g() { git -c user.name=t -c user.email=t@t -c core.hooksPath=/dev/null "$@"; }
git init -q --bare "$scratch/origin.git"
g clone -q "$scratch/origin.git" "$scratch/seed" 2>/dev/null
(
  cd "$scratch/seed"
  echo base > shared.txt && g add . && g commit -qm base && g push -q origin HEAD:refs/heads/integration/x
  g switch -qc ticket/ok && echo ok > ok.txt && g add . && g commit -qm ok && g push -q origin ticket/ok
  g switch -q --detach integration/x 2>/dev/null || g switch -q --detach origin/integration/x
  g switch -qc ticket/clash && echo theirs > shared.txt && g commit -qam clash && g push -q origin ticket/clash
)
g clone -q -b integration/x "$scratch/origin.git" "$scratch/work"
(cd "$scratch/seed" && g switch -q --detach && g fetch -q origin integration/x \
  && g switch -q --detach origin/integration/x && echo ours > shared.txt && g commit -qam ours \
  && g push -q origin HEAD:integration/x)
(cd "$scratch/work" && g pull -q)

remote_head() { git -C "$scratch/origin.git" rev-parse integration/x; }
run_merge() {
  (cd "$scratch/work" && GIT_CONFIG_COUNT=3 GIT_CONFIG_KEY_0=user.name GIT_CONFIG_VALUE_0=t \
    GIT_CONFIG_KEY_1=user.email GIT_CONFIG_VALUE_1=t@t GIT_CONFIG_KEY_2=core.hooksPath GIT_CONFIG_VALUE_2=/dev/null \
    merge_ticket "$@") 2>&1
}
repo_checks() { echo repo-ran; }
backend_checks() { echo backend-ran; }
frontend_checks() { echo frontend-ran; }
ci_runs() { :; }  # no CI runs on HEAD unless a test says so

ci_runs() { echo "failure https://ci/red"; }
before=$(remote_head)
if out=$(run_merge ticket/ok 'Ok ticket'); then echo "FAIL: merging onto a red tip must fail"; fail=1; fi
grep -q 'red integration tip: CI failure https://ci/red' <<<"$out" || { echo "FAIL: must name the red run: $out"; fail=1; }
check "red tip: HEAD unchanged" "$(git -C "$scratch/work" rev-parse HEAD)" "$before"
ci_runs() { :; }


before=$(remote_head)
if out=$(run_merge ticket/clash 'Clash'); then echo "FAIL: a conflict must fail"; fail=1; fi
grep -q 'shared.txt' <<<"$out" || { echo "FAIL: conflict must list shared.txt: $out"; fail=1; }
check "conflict aborted" "$(git -C "$scratch/work" status --porcelain)" ""
check "conflict leaves HEAD" "$(git -C "$scratch/work" rev-parse HEAD)" "$before"
grep -q backend-ran <<<"$out" && { echo "FAIL: checks ran after a conflict"; fail=1; }
grep -q WARNING <<<"$out" && { echo "FAIL: warned on integration/x: $out"; fail=1; }

frontend_checks() { echo frontend-ran; return 1; }
if out=$(run_merge ticket/ok 'Ok ticket'); then echo "FAIL: a failing check must fail"; fail=1; fi
grep -q 'frontend checks failed' <<<"$out" || { echo "FAIL: must name the failing check: $out"; fail=1; }
check "red: not pushed" "$(remote_head)" "$before"
check "red: merge commit kept" "$(git -C "$scratch/work" log -1 --format=%s)" "Merge ticket/ok: Ok ticket"
check "red: two parents" "$(git -C "$scratch/work" rev-list --parents -1 HEAD | wc -w | tr -d ' ')" 3
g -C "$scratch/work" reset -q --hard "$before"

frontend_checks() { echo frontend-ran; }
# The checks the pre-commit hook runs and --no-verify skipped (doc references, kit copy, scripts) go
# first: a red one stops the merge before the minutes of Gradle.
repo_checks() { echo repo-ran; return 1; }
if out=$(run_merge ticket/ok 'Ok ticket'); then echo "FAIL: a failing repo check must fail"; fail=1; fi
grep -q 'repo checks failed' <<<"$out" || { echo "FAIL: must name the repo checks: $out"; fail=1; }
grep -q backend-ran <<<"$out" && { echo "FAIL: Gradle ran after a red repo check: $out"; fail=1; }
check "repo red: not pushed" "$(remote_head)" "$before"
g -C "$scratch/work" reset -q --hard "$before"
repo_checks() { echo repo-ran; }

if ! out=$(run_merge ticket/ok 'Ok ticket'); then echo "FAIL: green merge failed: $out"; fail=1; fi
[[ "$out" == *repo-ran*backend-ran*frontend-ran* ]] || { echo "FAIL: checks not run: $out"; fail=1; }
check "green: pushed" "$(remote_head)" "$(git -C "$scratch/work" rev-parse HEAD)"
check "green: trailer" "$(git -C "$scratch/work" log -1 --format=%B | sed "/^$/d" | tail -1)" \
  "Co-Authored-By: Claude <noreply@anthropic.com>"

if out=$(run_merge ticket/ok 'Ok ticket'); then echo "FAIL: merging twice must fail"; fail=1; fi
grep -q 'already merged' <<<"$out" || { echo "FAIL: must say already merged: $out"; fail=1; }
if out=$(run_merge ticket/none 'None'); then echo "FAIL: an unknown branch must fail"; fail=1; fi
# A ticket that already contains the integration branch's HEAD: the merge's tree is the ticket's own,
# which CI checked, so no check runs and the merge commit is pushed straight away.
(cd "$scratch/seed" && g fetch -q origin && g switch -q --detach origin/integration/x \
  && g switch -qc ticket/ontop && echo top > top.txt && g add . && g commit -qm top \
  && g push -q origin ticket/ontop)
if ! out=$(run_merge ticket/ontop 'On top'); then echo "FAIL: on-top merge failed: $out"; fail=1; fi
grep -q 'ticket/ontop already contains integration/x; skipping the checks' <<<"$out" \
  || { echo "FAIL: must say why the checks are skipped: $out"; fail=1; }
[[ "$out" == *-ran* ]] && { echo "FAIL: checks ran on a ticket that contains HEAD: $out"; fail=1; }
check "on top: pushed" "$(remote_head)" "$(git -C "$scratch/work" rev-parse HEAD)"
check "on top: two parents" "$(git -C "$scratch/work" rev-list --parents -1 HEAD | wc -w | tr -d ' ')" 3

# A ticket that changes merge-ticket.sh itself (based on ticket/ok, so it lacks HEAD and the checks
# are due): this copy was read before the merge, so the checks and the push are handed to the merged
# copy.
(cd "$scratch/seed" && g switch -q --detach ticket/ok \
  && g switch -qc ticket/self && mkdir -p scripts && echo new > scripts/merge-ticket.sh \
  && g add . && g commit -qm self && g push -q origin ticket/self)
run_merged_copy() { echo "merged-copy-ran on $1"; }
if ! out=$(run_merge ticket/self 'Self'); then echo "FAIL: self merge failed: $out"; fail=1; fi
grep -q 'merged-copy-ran on integration/x' <<<"$out" || { echo "FAIL: the merged copy must run the checks: $out"; fail=1; }
grep -q backend-ran <<<"$out" && { echo "FAIL: the old copy ran the checks: $out"; fail=1; }
check "self: push left to the merged copy" "$(remote_head)" "$(git -C "$scratch/work" rev-parse HEAD^1)"
g -C "$scratch/work" reset -q --hard "$(remote_head)"

# Two tickets in one call: both merge in order, then the checks run once and one push carries both.
# ticket/two-a contains HEAD but ticket/two-b doesn't, so the checks are still due.
(cd "$scratch/seed" && g fetch -q origin && g switch -q --detach origin/integration/x \
  && g switch -qc ticket/two-a && echo a > two-a.txt && g add . && g commit -qm two-a && g push -q origin ticket/two-a \
  && g switch -q --detach origin/integration/x~1 \
  && g switch -qc ticket/two-b && echo b > two-b.txt && g add . && g commit -qm two-b && g push -q origin ticket/two-b)
if ! out=$(run_merge ticket/two-a 'Two A' ticket/two-b 'Two B'); then echo "FAIL: two-ticket merge failed: $out"; fail=1; fi
check "two: checks ran once" "$(grep -c backend-ran <<<"$out")" 1
check "two: one push" "$(grep -c 'merge-ticket: pushed' <<<"$out")" 1
check "two: pushed" "$(remote_head)" "$(git -C "$scratch/work" rev-parse HEAD)"
check "two: merged in order" "$(git -C "$scratch/work" log -2 --format=%s)" "Merge ticket/two-b: Two B
Merge ticket/two-a: Two A"

# A conflict on the second ticket aborts that merge and stops: the first stays committed, unpushed.
before=$(remote_head)
(cd "$scratch/seed" && g fetch -q origin && g switch -q --detach origin/integration/x \
  && g switch -qc ticket/two-c && echo c > two-c.txt && g add . && g commit -qm two-c && g push -q origin ticket/two-c)
if out=$(run_merge ticket/two-c 'Two C' ticket/clash 'Clash'); then echo "FAIL: a second-ticket conflict must fail"; fail=1; fi
grep -q 'shared.txt' <<<"$out" || { echo "FAIL: conflict must list shared.txt: $out"; fail=1; }
grep -q backend-ran <<<"$out" && { echo "FAIL: checks ran after a conflict: $out"; fail=1; }
check "two-conflict: clean tree" "$(git -C "$scratch/work" status --porcelain)" ""
check "two-conflict: first merge kept" "$(git -C "$scratch/work" log -1 --format=%s)" "Merge ticket/two-c: Two C"
check "two-conflict: not pushed" "$(remote_head)" "$before"
g -C "$scratch/work" reset -q --hard "$before"

# A ticket with a commit subject over 72 characters (committed with --no-verify, which skips the
# commit-msg hook) is refused before its merge: it names the commit and nothing runs or is pushed.
before=$(remote_head)
(cd "$scratch/seed" && g fetch -q origin && g switch -q --detach origin/integration/x \
  && g switch -qc ticket/long && echo long > long.txt && g add . \
  && g commit -qm "fix: $(printf 'z%.0s' $(seq 70))" && g push -q origin ticket/long)
if out=$(run_merge ticket/long 'Long'); then echo "FAIL: a long subject must refuse the merge"; fail=1; fi
grep -q "$(git -C "$scratch/seed" rev-parse --short ticket/long) has a 75-character subject" <<<"$out" \
  || { echo "FAIL: must name the long commit: $out"; fail=1; }
check "long subject: HEAD unchanged" "$(git -C "$scratch/work" rev-parse HEAD)" "$before"
check "long subject: not pushed" "$(remote_head)" "$before"
[[ "$out" == *-ran* ]] && { echo "FAIL: checks ran on a refused ticket: $out"; fail=1; }

# An integration branch outside spec/ and integration/: the warning comes first, then the merge,
# checks and push go ahead as usual.
g -C "$scratch/work" switch -qc audit-2026-11
(cd "$scratch/seed" && g fetch -q origin && g switch -q --detach origin/integration/x \
  && g switch -qc ticket/audit && echo audit > audit.txt && g add . && g commit -qm audit && g push -q origin ticket/audit)
if ! out=$(run_merge ticket/audit 'Audit'); then echo "FAIL: merge on an unprefixed branch failed: $out"; fail=1; fi
check "unprefixed: warning first" "$(head -1 <<<"$out")" \
  "merge-ticket: WARNING: CI doesn't run on pushes to audit-2026-11 (only spec/** and integration/**),"
[[ "$out" == *backend-ran*frontend-ran* ]] || { echo "FAIL: unprefixed: checks not run: $out"; fail=1; }
check "unprefixed: pushed" "$(git -C "$scratch/origin.git" rev-parse audit-2026-11)" "$(git -C "$scratch/work" rev-parse HEAD)"
g -C "$scratch/work" switch -q integration/x

echo dirt > "$scratch/work/dirt.txt"
if out=$(run_merge ticket/clash 'Clash'); then echo "FAIL: a dirty tree must fail"; fail=1; fi
grep -q 'dirty tree' <<<"$out" || { echo "FAIL: must say dirty tree: $out"; fail=1; }

(( fail )) && exit 1
echo "PASS: merge-ticket.sh refuses, aborts on conflicts, pushes only when green or CI-checked"
