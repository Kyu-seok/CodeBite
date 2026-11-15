#!/usr/bin/env bash
# Runs problems' reference solutions through a backend's Run endpoint, so Java and C++ compile
# against that backend's Drivers on Judge0 and every sample Test Case passes, printing each
# Language's verdict; with --former, also checks that a Former Slug resolves to the new Slug.
#
#   scripts/judge-run.sh <slug>                              # this worktree's branch servers, every Language
#   scripts/judge-run.sh <slug> --languages java,cpp         # just those Languages
#   scripts/judge-run.sh <new-slug> --former <old-slug>      # and GET /api/problems/<old-slug> answers <new-slug>
#   scripts/judge-run.sh <a> --former <old-a> <b> --former <old-b>   # several problems; a --former is the slug's before it
#   scripts/judge-run.sh <slug> --backend http://127.0.0.1:8080      # another backend
#
# The backend defaults to the one `scripts/dev-branch-servers.sh status` prints for this checkout.
# Reference solutions are scripts/replay-solutions/<slug>.<py|java|js|cpp>, Solution class only; a
# Language without one is NOT JUDGED. Runs go 5.5 s apart, past the 5 s per-IP Run cooldown, and a
# 429 is waited out, never reported as a verdict. Run grades the samples only:
# scripts/judge-local.sh judges every case.
#
# Exits 0 when every Language was Accepted and every Former Slug resolves, 1 on any other verdict or
# Former Slug, 2 when the backend can't be reached (it says to restart the branch servers), lacks
# the problem, or a Language has no reference solution.
set -euo pipefail
root="$(cd "$(dirname "$0")/.." && pwd)"
exec python3 -I "$root/scripts/judge-run.py" "$root" "$@"
