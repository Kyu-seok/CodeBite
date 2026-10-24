# shellcheck shell=bash
# Source this before running the backend or worker locally:
#
#   source scripts/dev-env.sh && SPRING_PROFILES_ACTIVE=dev ./gradlew :backend:bootRun
#
# It exports only the OAuth and GitHub App values from infra/.env (or the file
# given as $1). Sourcing infra/.env itself also exports the production-shaped
# CORS_ALLOWED_ORIGINS, JWT_SECRET, DB_* and JUDGE0_URL, which override the dev
# defaults: browser POSTs from localhost:5173 get 403, saved logins stop
# verifying, and the worker can't reach Judge0.

_dev_env_file="${1:-infra/.env}"
if [[ ! -f "$_dev_env_file" ]]; then
  echo "dev-env.sh: $_dev_env_file not found (run from the repo root)" >&2
  return 1 2>/dev/null || exit 1
fi
while IFS= read -r _dev_env_line || [[ -n "$_dev_env_line" ]]; do
  _dev_env_line="${_dev_env_line#export }"
  case "$_dev_env_line" in
    GOOGLE_CLIENT_*=*|GITHUB_CLIENT_*=*|GITHUB_APP_*=*)
      _dev_env_key="${_dev_env_line%%=*}"
      _dev_env_value="${_dev_env_line#*=}"
      if [[ "$_dev_env_value" == \'*\' || "$_dev_env_value" == \"*\" ]]; then
        _dev_env_value="${_dev_env_value:1:${#_dev_env_value}-2}"
      fi
      export "$_dev_env_key=$_dev_env_value"
      ;;
  esac
done < "$_dev_env_file"
unset _dev_env_file _dev_env_line _dev_env_key _dev_env_value
