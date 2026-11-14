#!/usr/bin/env bash
# Checks scripts/tested-tree.sh against a stub gh: a squash commit counts as tested when its PR's
# head has the same tree and a CI run on that head succeeded with every job; a different tree, a
# run whose jobs were skipped, no run, or a gh error each mean not tested.
set -euo pipefail

script="$(cd "$(dirname "$0")" && pwd)/tested-tree.sh"
dir=$(mktemp -d)
trap 'rm -rf "$dir"' EXIT
mkdir "$dir/bin"
# Trees: commit "merge" and "head" share tree T1; "behind" has T2. TREE_FAIL makes the commit
# lookup fail. RUNS_<sha> is the run ids listed for that sha; JOBS_<run> is the jq answer.
cat > "$dir/bin/gh" <<'STUB'
#!/usr/bin/env bash
path=$2
case $path in
  */commits/*/pulls) echo "${PR_HEADS:-}" ;;
  */commits/*)
    [[ -z ${TREE_FAIL:-} ]] || exit 1
    case ${path##*/} in merge|head) echo T1 ;; *) echo T2 ;; esac ;;
  *workflows/ci.yml/runs*)
    c=${path#*head_sha=}; c=${c%%&*}; v="RUNS_$c"; echo "${!v:-}" ;;
  */runs/*/jobs)
    r=${path%/jobs}; r=${r##*/}; v="JOBS_$r"; echo "${!v:-false}" ;;
  *) exit 1 ;;
esac
STUB
chmod +x "$dir/bin/gh"

fail=0
run() { env PATH="$dir/bin:$PATH" GITHUB_REPOSITORY=o/r "$@" "$script" merge 2>/dev/null; }
expect_tested() {
  local desc=$1 want=$2; shift 2
  local got; got=$(run "$@") || { echo "FAIL: $desc: expected tested by $want"; fail=1; return; }
  [[ $got == "$want" ]] || { echo "FAIL: $desc: printed $got, expected $want"; fail=1; }
}
expect_untested() {
  local desc=$1; shift
  if run "$@" >/dev/null; then echo "FAIL: $desc: expected not tested"; fail=1; fi
}

expect_tested "PR head with the same tree, all jobs green" head \
  PR_HEADS=head RUNS_head=7 JOBS_7=true
expect_tested "the commit's own green run (a manual deploy)" merge \
  RUNS_merge=8 JOBS_8=true
expect_tested "a skipped-jobs run beside a real one" head \
  PR_HEADS=head RUNS_head=$'5\n6' JOBS_5=false JOBS_6=true
expect_untested "PR head behind master (another tree)" \
  PR_HEADS=behind RUNS_behind=7 JOBS_7=true
expect_untested "only a run whose jobs were skipped" \
  PR_HEADS=head RUNS_head=5 JOBS_5=false
expect_untested "no successful run" PR_HEADS=head
expect_untested "gh error" TREE_FAIL=1 PR_HEADS=head RUNS_head=7 JOBS_7=true

(( fail )) && exit 1
echo "PASS: tested-tree.sh trusts only a green CI run on the same tree"
