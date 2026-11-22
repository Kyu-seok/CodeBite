#!/usr/bin/env bash
# Checks scripts/deploy-prod.sh's decisions against a stub docker: the backend rolls unless every
# old replica runs the new image under the same compose config hash, and always on a manual run,
# with no old replicas, or when a replica can't be inspected; the health wait passes once every new
# replica answers and gives up after its attempts; every compose call builds without BuildKit's
# default attestation, which gives a fully cached image a new id on every build (#403); a changed
# frontend is published under the running nginx with one reload, an unchanged deploy reloads
# nothing, a recreated nginx is logged as that and not reloaded, and an nginx.conf that fails
# `nginx -t` stops the deploy before anything is brought up or reloaded; a rollback publishes the
# previous build when the previous commit has a frontend service (#434, docs/adr/0014).
set -euo pipefail

script="$(cd "$(dirname "$0")" && pwd)/deploy-prod.sh"
dir=$(mktemp -d)
trap 'rm -rf "$dir"' EXIT
mkdir "$dir/bin"
# `docker inspect` answers STATE_<id> ("image hash"), or fails when it is unset. `docker exec <id>`
# succeeds when <id> is listed in $dir/up. `docker compose` records whether default attestations
# are off and appends its arguments to $dir/calls; the frontend's publish prints $dir/publish-says,
# `nginx -t` fails when $dir/conf-broken exists, and `up` replaces nginx (a new id in
# $dir/nginx-id) when $dir/recreate-on-up exists, and the compose file's services are $dir/services. `git` only records its arguments in $dir/git-calls
# (so no commit differs from another), and `curl` always succeeds.
cat > "$dir/bin/docker" <<'STUB'
#!/usr/bin/env bash
case $1 in
  inspect) v="STATE_${!#}"; [[ -n ${!v:-} ]] || exit 1; echo "${!v}" ;;
  exec) grep -qx "$2" "$STUB_DIR/up" 2>/dev/null ;;
  version) echo 29.0.0 ;;
  image) echo img1 ;;
  compose)
    echo "${BUILDX_NO_DEFAULT_ATTESTATIONS:-unset}" > "$STUB_DIR/attestations-off"
    echo "$*" >> "$STUB_DIR/calls"
    case "$*" in
      *" ps -q nginx") cat "$STUB_DIR/nginx-id" ;;
      *" ps -q") cat "$STUB_DIR/nginx-id"; echo other ;;
      *" run --rm frontend") cat "$STUB_DIR/publish-says" ;;
      *" config --services") cat "$STUB_DIR/services" ;;
      *" nginx nginx -t") [[ ! -e "$STUB_DIR/conf-broken" ]] ;;
      *" up -d --remove-orphans") [[ ! -e "$STUB_DIR/recreate-on-up" ]] || echo nginx2 > "$STUB_DIR/nginx-id" ;;
    esac ;;
  *) exit 1 ;;
esac
STUB
cat > "$dir/bin/git" <<'STUB'
#!/usr/bin/env bash
echo "$*" >> "$STUB_DIR/git-calls"
STUB
printf '#!/usr/bin/env bash\nexit 0\n' > "$dir/bin/curl"
chmod +x "$dir/bin/docker" "$dir/bin/git" "$dir/bin/curl"
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

"${COMPOSE[@]}" build
[[ $(cat "$dir/attestations-off") == 1 ]] \
  || { echo "FAIL: compose build: expected BUILDX_NO_DEFAULT_ATTESTATIONS=1, so a cached image keeps its id"; fail=1; }

sleep() { :; }
printf 'n1\nn2\n' > "$dir/up"
wait_healthy 3 2 n1 n2 >/dev/null || { echo "FAIL: every replica up: expected healthy"; fail=1; }
printf 'n1\n' > "$dir/up"
! wait_healthy 3 2 n1 n2 >/dev/null || { echo "FAIL: one replica down: expected to give up"; fail=1; }

# front <description> <what the publish prints> [<reason to reload>...]: one update_front against a
# running nginx; its log is in $dir/log and its compose calls in $dir/calls.
front() {
  local desc=$1 says=$2; shift 2
  echo nginx1 > "$dir/nginx-id"; echo "$says" > "$dir/publish-says"; : > "$dir/calls"
  update_front "$@" > "$dir/log" 2>&1 || { echo "FAIL: $desc: update_front failed"; fail=1; }
}
reloads() { grep -c "nginx -s reload" "$dir/calls"; }
expect() { local desc=$1; shift; "$@" || { echo "FAIL: $desc"; cat "$dir/log"; fail=1; }; }

front "frontend changed" "Frontend published (build 2)"
expect "frontend changed: one reload" test "$(reloads)" = 1
expect "frontend changed: logged as kept running" grep -q "nginx: kept running, reloaded (frontend published)" "$dir/log"

front "nothing changed" "Frontend unchanged (build 2)"
expect "nothing changed: no reload" test "$(reloads)" = 0
expect "nothing changed: logged as kept running" grep -q "nginx: kept running, no reload" "$dir/log"

front "nginx.conf changed" "Frontend unchanged (build 2)" "nginx.conf changed"
expect "nginx.conf changed: one reload" test "$(reloads)" = 1

touch "$dir/recreate-on-up"
front "image or service definition changed" "Frontend published (build 3)"
expect "image or service definition changed: logged as recreated" grep -q "nginx: recreated" "$dir/log"
expect "image or service definition changed: a new container needs no reload" test "$(reloads)" = 0
rm "$dir/recreate-on-up"

# A whole deploy with a broken nginx.conf: out before the backend roll, nothing brought up or
# reloaded, and the checkout back on the previous commit so a restart finds the old config.
touch "$dir/conf-broken"; : > "$dir/calls"; : > "$dir/git-calls"
( main prev123 push ) > "$dir/log" 2>&1
expect "broken nginx.conf: the deploy fails" test $? = 1
expect "broken nginx.conf: nothing brought up" bash -c "! grep -q ' up -d' '$dir/calls'"
expect "broken nginx.conf: no reload" test "$(reloads)" = 0
expect "broken nginx.conf: back on the previous commit" grep -qx "checkout prev123" "$dir/git-calls"
: > "$dir/nginx-id"
check_nginx_conf > /dev/null
expect "no nginx running: its config isn't tested" test $? = 0
rm "$dir/conf-broken"

# A whole deploy of a changed frontend onto a running nginx, from the build to the final check.
echo nginx1 > "$dir/nginx-id"; echo "Frontend published (build 4)" > "$dir/publish-says"; : > "$dir/calls"
( main prev123 push ) > "$dir/log" 2>&1
expect "whole deploy: succeeds" test $? = 0
expect "whole deploy: the frontend image is built" grep -q -- "--profile publish build$" "$dir/calls"
expect "whole deploy: nginx kept running" grep -q "nginx: kept running, reloaded (backend rolled, frontend published)" "$dir/log"
expect "whole deploy: one reload" test "$(reloads)" = 1

printf 'backend\nfrontend\nnginx\n' > "$dir/services"; : > "$dir/calls"
restore_front > "$dir/log" 2>&1
expect "rollback: the previous build is published" grep -q " run --rm frontend$" "$dir/calls"
printf 'backend\nnginx\n' > "$dir/services"; : > "$dir/calls"
restore_front > "$dir/log" 2>&1
expect "rollback to a commit whose nginx image holds the files: nothing to publish" bash -c "! grep -q ' run ' '$dir/calls'"

(( fail )) && exit 1
echo "PASS: deploy-prod.sh rolls only on a change, waits for every new replica and keeps nginx running"
