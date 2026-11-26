#!/usr/bin/env bash
# Publishes one ticket: creates the issue, attaches it as a sub-issue of its
# parent and adds GitHub's native "blocked by" edges, then prints #<n>.
#
#   scripts/gh-ticket.sh --title "..." --body-file body.md \
#     [--parent <n>] [--blocked-by <n>,<n>] [--label <name>]...
#   scripts/gh-ticket.sh --private --title "..." --body-file body.md \
#     [--severity low|medium|high|critical]
#
# --private is for a finding that names a way past a guard (auth, a rate limit,
# validation): the repository is public, so it goes to a draft security
# advisory, which only maintainers can read, and the script prints its URL.
# An advisory has no parent, blockers or labels; its severity defaults to medium.
#
# Issue numbers may carry a leading '#'. The issue is created first and linked
# with `gh issue edit` (gh 2.103 takes numbers and looks up the ids itself), so
# a failed attach or link still prints the new #<n> and says on stderr what is
# missing, exiting 1. Bad arguments exit 2 before any gh call.
set -euo pipefail

usage() {
  echo "usage: $0 --title <title> --body-file <file> [--parent <n>] [--blocked-by <n>,<n>] [--label <name>]..." >&2
  echo "       $0 --private --title <title> --body-file <file> [--severity low|medium|high|critical]" >&2
  exit 2
}
die() { echo "gh-ticket: $*" >&2; usage; }
number() { [[ ${1#\#} =~ ^[0-9]+$ ]] || die "not an issue number: $1"; echo "${1#\#}"; }

title='' body_file='' parent='' blockers=() labels=() private='' severity=''
while (( $# )); do
  if [[ $1 == --private ]]; then private=1; shift; continue; fi
  [[ $1 == --* && $# -ge 2 ]] || die "${1} needs a value or is unknown"
  case $1 in
    --title) title=$2 ;;
    --body-file) body_file=$2 ;;
    --parent) parent=$(number "$2") ;;
    --blocked-by)
      IFS=, read -ra list <<<"$2"
      for b in "${list[@]}"; do blockers+=("$(number "$b")"); done ;;
    --label) labels+=(--label "$2") ;;
    --severity)
      [[ $2 =~ ^(low|medium|high|critical)$ ]] || die "not a severity: $2"
      severity=$2 ;;
    *) die "unknown option: $1" ;;
  esac
  shift 2
done
[[ -n $title ]] || die "--title is required"
[[ -n $body_file ]] || die "--body-file is required"
[[ -f $body_file ]] || die "no such body file: $body_file"
if [[ -z $private ]]; then
  [[ -z $severity ]] || die "--severity goes with --private"
elif [[ -n $parent ]] || (( ${#blockers[@]} + ${#labels[@]} )); then
  die "--private files a security advisory, which has no parent, blockers or labels"
fi

if [[ -n $private ]]; then
  repo=$(gh repo view --json name --jq .name)
  url=$(jq -n --arg summary "$title" --rawfile description "$body_file" \
      --arg severity "${severity:-medium}" --arg package "$repo" \
      '{summary: $summary, description: $description, severity: $severity,
        vulnerabilities: [{package: {ecosystem: "other", name: $package},
          vulnerable_version_range: null, patched_versions: null, vulnerable_functions: []}]}' \
    | gh api --method POST 'repos/{owner}/{repo}/security-advisories' --input - --jq .html_url)
  [[ $url == https://* ]] || { echo "gh-ticket: gh printed no advisory URL: $url" >&2; exit 1; }
  echo "$url"
  exit 0
fi

url=$(gh issue create --title "$title" --body-file "$body_file" ${labels[@]+"${labels[@]}"} | tail -1)
n=${url##*/}
[[ $n =~ ^[0-9]+$ ]] || { echo "gh-ticket: gh issue create printed no issue URL: $url" >&2; exit 1; }
echo "#$n"

missing=()
if [[ -n $parent ]] && ! gh issue edit "$n" --parent "$parent" >&2; then
  missing+=("not attached to parent #$parent (retry: gh issue edit $n --parent $parent)")
fi
if (( ${#blockers[@]} )); then
  joined=$(IFS=,; echo "${blockers[*]}")
  if ! gh issue edit "$n" --add-blocked-by "$joined" >&2; then
    missing+=("not blocked by #${joined//,/, #} (retry: gh issue edit $n --add-blocked-by $joined)")
  fi
fi
if (( ${#missing[@]} )); then
  echo "gh-ticket: created #$n but it is half-linked:" >&2
  printf '  - %s\n' "${missing[@]}" >&2
  exit 1
fi
