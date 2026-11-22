#!/usr/bin/env bash
# Checks scripts/integration-pr-body.sh on a scratch state directory and a scratch repository: the
# body it writes from a merge log and notes, and, against a stub gh, that it edits the branch's PR
# when there is one and only writes the file when there isn't.
# shellcheck disable=SC2016,SC2034 # check() evals its single-quoted conditions (which read $expected) later
set -euo pipefail

script="$(cd "$(dirname "$0")" && pwd)/integration-pr-body.sh"
dir=$(mktemp -d)
trap 'rm -rf "$dir"' EXIT
dir=$(cd "$dir" && pwd -P)

git init -q "$dir/repo"
git -C "$dir/repo" -c user.name=t -c user.email=t@t commit -q --allow-empty -m tip
git -C "$dir/repo" branch integration/batch
tip=$(git -C "$dir/repo" rev-parse --short integration/batch)

mkdir -p "$dir/bin" "$dir/state/pr-notes"
# The stub logs each call on one line. GH_STUB_PR=<n> makes `pr list` answer with that PR number.
cat > "$dir/bin/gh" <<'STUB'
#!/usr/bin/env bash
echo "$*" >> "$GH_STUB_LOG"
[[ "$1 $2" == "pr list" ]] && echo "${GH_STUB_PR:-}"
exit 0
STUB
chmod +x "$dir/bin/gh"

cat > "$dir/state/merge-log.md" <<'LOG'
12|ticket/12-fix|Fixed the thing.|Check it in production.
14|ticket/14-docs|Wrote the docs.|-
12 14|ticket/review-fixes|Review fixes.|-
LOG
printf 'Notes for twelve.\n' > "$dir/state/pr-notes/12.md"
printf 'Notes for thirteen.\n' > "$dir/state/pr-notes/13.md"

fail=0
# run <args...>: sets out, err, status and log for one call of the script, from the scratch repository
# (HOME is elsewhere, so the state directory is shown whole).
run() {
  : > "$dir/log"
  status=0
  out=$(cd "$dir/repo" && HOME=/nonexistent PATH="$dir/bin:$PATH" GH_STUB_LOG="$dir/log" "$script" "$@" 2> "$dir/err") || status=$?
  err=$(cat "$dir/err"); log=$(cat "$dir/log")
}
check() { if ! eval "$2"; then echo "FAIL: $1"; echo "  status=$status err=$err"; echo "  out=$out"; echo "  log=$log"; fail=1; fi; }

expected="Three tickets (#12 #13 #14) with no spec, landed on one integration branch.

State directory: \`$dir/state/\` (brief: \`BRIEF.md\`, merge log: \`merge-log.md\`). Integration tip: \`$tip\`.

## Merged

- #12 (\`ticket/12-fix\`): Fixed the thing. **Owed:** Check it in production.
- #14 (\`ticket/14-docs\`): Wrote the docs.
- #12 #14 (\`ticket/review-fixes\`): Review fixes.

## Not merged yet

#13

## #12

Notes for twelve.

Closes #12
Closes #14

🤖 Generated with [Claude Code](https://claude.com/claude-code)"

run --print integration/batch "$dir/state" 12 '#13' 14
check "the body lists the merges with what is owed, the unmerged tickets, merged notes and Closes" \
  '[[ $status == 0 && $out == "$expected" ]]'
check "--print calls no gh and writes no file" '[[ -z $log && ! -e $dir/state/pr-body.md ]]'

run integration/batch "$dir/state" 12 13 14
check "with no PR it writes the body file" '[[ $status == 0 && $(cat "$dir/state/pr-body.md") == "$expected" ]]'
check "with no PR it says where the body is" '[[ $out == "no PR yet; body written to $dir/state/pr-body.md" ]]'
check "with no PR it edits nothing" '[[ $log == "pr list --head integration/batch --json number --jq .[0].number // empty" ]]'

rm "$dir/state/pr-body.md"
GH_STUB_PR=77 run integration/batch "$dir/state" 12 13 14
check "with a PR it edits that PR's body from the file" \
  '[[ $status == 0 && $(tail -1 <<<"$log") == "pr edit 77 --body-file $dir/state/pr-body.md" ]]'
check "with a PR the file holds the body" '[[ $(cat "$dir/state/pr-body.md") == "$expected" ]]'
check "with a PR it names it and the tip" '[[ $out == "PR #77 body updated (tip $tip)" ]]'

mkdir "$dir/empty"
run --print integration/batch "$dir/empty" 5
check "with no merge log yet nothing is merged and nothing closes" \
  '[[ $status == 0 && $out == *"One ticket (#5) "* && $out == *"Nothing yet."* && $out == *"## Not merged yet"*"#5"* && $out != *Closes* ]]'

for bad in \
  "integration/batch $dir/state" \
  "integration/batch $dir/missing 12" \
  "integration/batch $dir/state 12 x" \
  "integration/none $dir/state 12"; do
  # shellcheck disable=SC2086
  run $bad
  check "rejects without calling gh: $bad" '[[ $status == 2 && -z $log ]]'
done

(( fail )) && exit 1
echo "PASS: integration-pr-body.sh writes the body and edits the PR only when there is one"
