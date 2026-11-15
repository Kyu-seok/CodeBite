#!/usr/bin/env bash
# Checks scripts/deploy-prod.sh's decisions against a stub docker: the backend rolls unless every
# old replica runs the new image under the same compose config hash, and always on a manual run,
# with no old replicas, or when a replica can't be inspected; the health wait passes once every new
# replica answers and gives up after its attempts.
set -euo pipefail

script="$(cd "$(dirname "$0")" && pwd)/deploy-prod.sh"
dir=$(mktemp -d)
trap 'rm -rf "$dir"' EXIT
mkdir "$dir/bin"
# `docker inspect` answers STATE_<id> ("image hash"), or fails when it is unset. `docker exec <id>`
# succeeds when <id> is listed in $dir/up.
cat > "$dir/bin/docker" <<'STUB'
#!/usr/bin/env bash
case $1 in
  inspect) v="STATE_${!#}"; [[ -n ${!v:-} ]] || exit 1; echo "${!v}" ;;
  exec) grep -qx "$2" "$STUB_DIR/up" 2>/dev/null ;;
  *) exit 1 ;;
esac
STUB
chmod +x "$dir/bin/docker"
export PATH="$dir/bin:$PATH" STUB_DIR=$dir DEPLOY_PROD_LIB=1
# shellcheck source=deploy-prod.sh
source "$script"
set +e

fail=0
rolls() { local desc=$1; shift; needs_roll "$@" || { echo "FAIL: $desc: expected a roll"; fail=1; }; }
keeps() { local desc=$1; shift; ! needs_roll "$@" || { echo "FAIL: $desc: expected no roll"; fail=1; }; }

export STATE_a="img1 h1" STATE_b="img1 h1" STATE_c="img2 h1" STATE_d="img1 h2"
keeps "same image and config on every replica" push img1 h1 a b
rolls "a manual run" workflow_dispatch img1 h1 a b
rolls "no old replicas" push img1 h1
rolls "one replica on another image" push img1 h1 a c
rolls "one replica under another config" push img1 h1 a d
rolls "a replica that can't be inspected" push img1 h1 a gone

sleep() { :; }
printf 'n1\nn2\n' > "$dir/up"
wait_healthy 3 2 n1 n2 >/dev/null || { echo "FAIL: every replica up: expected healthy"; fail=1; }
printf 'n1\n' > "$dir/up"
! wait_healthy 3 2 n1 n2 >/dev/null || { echo "FAIL: one replica down: expected to give up"; fail=1; }

(( fail )) && exit 1
echo "PASS: deploy-prod.sh rolls only on a change and waits for every new replica"
