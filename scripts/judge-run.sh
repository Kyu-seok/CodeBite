#!/usr/bin/env bash
# Runs problems' reference solutions through a backend's Run endpoint (samples, Judge0) and checks
# that Former Slugs resolve:
#   scripts/judge-run.sh <slug> [--former <old-slug>]... [<slug> ...] [--languages python,java,…] [--backend <url>]
# Options, spacing and exit codes: the docstring of scripts/judge-run.py.
set -euo pipefail
root="$(cd "$(dirname "$0")/.." && pwd)"
exec python3 -I "$root/scripts/judge-run.py" "$root" "$@"
