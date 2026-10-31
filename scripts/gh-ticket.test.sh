#!/usr/bin/env bash
# Checks scripts/gh-ticket.sh against a stub gh: one call creates the issue,
# attaches it to its parent and adds its blockers, printing #<n>; a failed
# attach or link names the issue it left half-linked and exits non-zero.
# shellcheck disable=SC2016 # check() evals its single-quoted conditions later
set -euo pipefail

script="$(cd "$(dirname "$0")" && pwd)/gh-ticket.sh"
dir=$(mktemp -d)
trap 'rm -rf "$dir"' EXIT
mkdir "$dir/bin"
# The stub logs each call on one line and answers `issue create` with a URL.
# GH_STUB_FAIL=<word> makes any call whose arguments contain that word fail.
cat > "$dir/bin/gh" <<'STUB'
#!/usr/bin/env bash
echo "$*" >> "$GH_STUB_LOG"
if [[ -n "${GH_STUB_FAIL:-}" && " $* " == *" $GH_STUB_FAIL "* ]]; then
  echo "stub gh: $GH_STUB_FAIL failed" >&2; exit 1
fi
[[ "$1 $2" == "issue create" ]] && echo "https://github.com/Kyu-seok/CodeBite/issues/142"
exit 0
STUB
chmod +x "$dir/bin/gh"
echo "body" > "$dir/body.md"

fail=0
# run <args...>: sets out, err, status and log for one call of the script.
run() {
  : > "$dir/log"
  status=0
  out=$(PATH="$dir/bin:$PATH" GH_STUB_LOG="$dir/log" "$script" "$@" 2> "$dir/err") || status=$?
  err=$(cat "$dir/err"); log=$(cat "$dir/log")
}
check() { if ! eval "$2"; then echo "FAIL: $1"; echo "  out=$out status=$status err=$err"; echo "  log=$log"; fail=1; fi; }

run --title "Fix the thing" --body-file "$dir/body.md"
check "a plain ticket prints #142" '[[ $status == 0 && $out == "#142" ]]'
check "a plain ticket is one gh call with its title and body file" \
  '[[ $log == "issue create --title Fix the thing --body-file $dir/body.md" ]]'

run --title "Child" --body-file "$dir/body.md" --parent 131 --blocked-by 120,'#121' --label ready-for-agent --label bug
check "a linked ticket prints #142" '[[ $status == 0 && $out == "#142" ]]'
check "labels go on the create call" \
  '[[ $(head -1 <<<"$log") == "issue create --title Child --body-file $dir/body.md --label ready-for-agent --label bug" ]]'
check "it attaches the new issue to its parent" 'grep -qx "issue edit 142 --parent 131" <<<"$log"'
check "it adds every blocker by number" 'grep -qx "issue edit 142 --add-blocked-by 120,121" <<<"$log"'

GH_STUB_FAIL=--parent run --title "Child" --body-file "$dir/body.md" --parent 131 --blocked-by 120
check "a failed attach exits non-zero" '[[ $status != 0 ]]'
check "a failed attach names the created issue" '[[ $err == *"#142"* && $err == *"#131"* ]]'
check "a failed attach still adds the blockers" 'grep -qx "issue edit 142 --add-blocked-by 120" <<<"$log"'

GH_STUB_FAIL=--add-blocked-by run --title "Child" --body-file "$dir/body.md" --blocked-by 120
check "a failed link exits non-zero and names the issue" '[[ $status != 0 && $err == *"#142"* && $err == *"#120"* ]]'

GH_STUB_FAIL=create run --title "Child" --body-file "$dir/body.md" --parent 131
check "a failed create exits non-zero and links nothing" '[[ $status != 0 && $(wc -l <<<"$log") -eq 1 ]]'

for bad in \
  "--body-file $dir/body.md" \
  "--title T" \
  "--title T --body-file $dir/missing.md" \
  "--title T --body-file $dir/body.md --parent abc" \
  "--title T --body-file $dir/body.md --blocked-by 1,x" \
  "--title T --body-file $dir/body.md --title" \
  "--title T --body-file $dir/body.md --bogus"; do
  # shellcheck disable=SC2086
  run $bad
  check "rejects without calling gh: $bad" '[[ $status == 2 && -z $log ]]'
done

(( fail )) && exit 1
echo "PASS: gh-ticket.sh creates, attaches and links one ticket"
