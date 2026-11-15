#!/usr/bin/env bash
# Shows where a CI or Deploy run spent its time, in a few lines per run:
#
#   scripts/ci-timings.sh <run-id>...
#   scripts/ci-timings.sh --last <n> [ci|deploy]     # the newest n runs (default: deploy)
#
# Per run: its wall time from creation (queueing included), each job's duration, every step over
# 5s, and for a deploy job the timestamped phases scripts/deploy-prod.sh prints ("--- Building new
# images ---", "--- New replicas healthy after ~48s ---"), read from the log without the rest of it.
set -euo pipefail

usage() { echo "usage: scripts/ci-timings.sh <run-id>... | --last <n> [ci|deploy]" >&2; exit 2; }
[[ $# -ge 1 ]] || usage
if [[ $1 == --last ]]; then
  [[ $# -ge 2 && $2 =~ ^[0-9]+$ ]] || usage
  runs=()
  while IFS= read -r r; do runs+=("$r"); done \
    < <(gh run list --workflow "${3:-deploy}.yml" --limit "$2" --json databaseId -q '.[].databaseId')
else
  runs=("$@")
fi

for run in "${runs[@]}"; do
  gh run view "$run" --json workflowName,event,headBranch,conclusion,createdAt,updatedAt,jobs --jq '
    def secs(a; b): if (a // "") == "" or (b // "") == "" then null
      else (b | fromdateiso8601) - (a | fromdateiso8601) end;
    def fmt: if . == null then "-" elif . >= 60 then "\(. / 60 | floor)m\(. % 60)s" else "\(.)s" end;
    "== \(.workflowName) #'"$run"' \(.event) \(.headBranch) \(.conclusion // "running"): \(secs(.createdAt; .updatedAt) | fmt) from creation",
    (.jobs[] |
      "  \(.name): \(.conclusion // "running") \(secs(.startedAt; .completedAt) | if . != null and . < 0 then "-" else fmt end)",
      (.steps[]? | select((secs(.startedAt; .completedAt) // 0) > 5)
        | "      \(.name | .[0:70]): \(secs(.startedAt; .completedAt) | fmt)"))'
  job=$(gh run view "$run" --json jobs -q '.jobs[] | select(.name == "deploy" and .conclusion != "skipped") | .databaseId')
  if [[ -n $job ]]; then
    gh run view "$run" --log --job "$job" \
      | grep -E 'Z --- ' | grep -v 'echo "' \
      | sed -E 's/^.*T([0-9:]{8})[.0-9]*Z /    \1 /' | cut -c1-110
  fi
done
