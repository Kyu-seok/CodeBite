#!/usr/bin/env bash
# Checks scripts/dev-env.sh: sourcing it must export the OAuth and GitHub App
# values from an env file and nothing else, so a local backend keeps its dev
# CORS origins, JWT secret, database and Judge0 defaults.
set -euo pipefail

here=$(cd "$(dirname "$0")" && pwd)
dir=$(mktemp -d)
trap 'rm -rf "$dir"' EXIT
cat > "$dir/.env" <<'ENV'
export DB_USER=prod_user
export JWT_SECRET=prod-secret
export CORS_ALLOWED_ORIGINS=https://code-bite.com
export JUDGE0_URL=http://judge0:2358
export GOOGLE_CLIENT_ID=google-id
export GITHUB_CLIENT_SECRET="github-secret"
GITHUB_APP_SLUG='codebite-dev'
GITHUB_APP_PRIVATE_KEY_BASE64='LS0tLS1CRUdJTi==='
ENV

out=$(env -i PATH="$PATH" bash -c "source '$(dirname "$0")/dev-env.sh' '$dir/.env' && env")

fail=0
expect() { grep -qx "$1" <<<"$out" || { echo "FAIL: expected $1"; fail=1; }; }
absent() { ! grep -q "^$1=" <<<"$out" || { echo "FAIL: $1 must not be exported"; fail=1; }; }

expect GOOGLE_CLIENT_ID=google-id
expect GITHUB_CLIENT_SECRET=github-secret
expect GITHUB_APP_SLUG=codebite-dev
expect GITHUB_APP_PRIVATE_KEY_BASE64=LS0tLS1CRUdJTi===
for k in DB_USER JWT_SECRET CORS_ALLOWED_ORIGINS JUDGE0_URL; do absent "$k"; done

# From a worktree, with no file given, it reads the main checkout's untracked infra/.env.
repo="$dir/repo"
git init -q "$repo"
git -C "$repo" -c user.name=t -c user.email=t@t commit -q --allow-empty -m init
mkdir -p "$repo/infra" && cp "$dir/.env" "$repo/infra/.env"
git -C "$repo" worktree add -q "$dir/wt" -b wt
out=$(cd "$dir/wt" && env -i PATH="$PATH" bash -c "source '$here/dev-env.sh' && env")
expect GOOGLE_CLIENT_ID=google-id

(( fail )) && exit 1
echo "PASS: dev-env.sh exports only OAuth and GitHub App values"
