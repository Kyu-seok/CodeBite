#!/usr/bin/env bash
# Checks scripts/deploy-prod.sh's decisions against a stub docker: the backend rolls unless every
# old replica runs the new image under the same compose config hash, and always on a manual run,
# with no old replicas, or when a replica can't be inspected; the health wait passes once every new
# replica answers and gives up after its attempts; every compose call builds without BuildKit's
# default attestation, which gives a fully cached image a new id on every build (#403); a changed
# frontend is published under the running nginx with one reload, an unchanged deploy reloads
# nothing, a recreated nginx is logged as that and not reloaded, and an nginx.conf that fails
# `nginx -t` stops the deploy before anything is brought up or reloaded, as does a compose that
# can't say whether nginx runs; a rollback publishes the previous build when the previous commit has
# a frontend service, and a step of that restore that fails is named; a whole deploy whose final
# check or whose publish fails goes back to the previous commit, backend and frontend build, and
# one whose new replicas never answer reloads nginx through compose (#434, docs/adr/0014).
set -euo pipefail

script="$(cd "$(dirname "$0")" && pwd)/deploy-prod.sh"
dir=$(mktemp -d)
trap 'rm -rf "$dir"' EXIT
mkdir "$dir/bin"
# `docker inspect` answers STATE_<id> ("image hash"), or fails when it is unset. `docker exec <id>`
# succeeds when <id> is listed in $dir/up. `docker compose` records whether default attestations
# are off and appends its arguments to $dir/calls; the frontend's publish prints $dir/publish-says,
# `nginx -t` fails when $dir/conf-broken exists, and `up` replaces nginx (a new id in
# $dir/nginx-id) when $dir/recreate-on-up exists, and the compose file's services are $dir/services
# (no such file: `config --services` fails). `ps -q nginx` fails when $dir/ps-fails exists, the
# publish when $dir/publish-fails does (holding "once", only the next one), the frontend image's
# build when $dir/build-fails does, and the backend's containers are $dir/backend-ids, which gains
# new1 when the backend is scaled to six. `git` only
# records its arguments in $dir/git-calls (so no commit differs from another), and `curl` succeeds
# unless $dir/unhealthy exists.
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
      *" ps -q nginx") [[ ! -e "$STUB_DIR/ps-fails" ]] || exit 1; cat "$STUB_DIR/nginx-id" ;;
      *" ps -q backend") cat "$STUB_DIR/backend-ids" 2>/dev/null || true ;;
      *" ps -q") cat "$STUB_DIR/nginx-id"; echo other ;;
      *" run --rm frontend")
        if [[ -e "$STUB_DIR/publish-fails" ]]; then
          [[ $(cat "$STUB_DIR/publish-fails") != once ]] || rm "$STUB_DIR/publish-fails"
          echo "publish.sh: stubbed failure"; exit 1
        fi
        cat "$STUB_DIR/publish-says" ;;
      *" config --services") cat "$STUB_DIR/services" ;;
      *" build frontend") [[ ! -e "$STUB_DIR/build-fails" ]] ;;
      *" --scale backend=6 "*) [[ ! -e "$STUB_DIR/backend-ids" ]] || echo new1 >> "$STUB_DIR/backend-ids" ;;
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
printf '#!/usr/bin/env bash\n[[ ! -e "$STUB_DIR/unhealthy" ]]\n' > "$dir/bin/curl"
chmod +x "$dir/bin/docker" "$dir/bin/git" "$dir/bin/curl"
export PATH="$dir/bin:$PATH" STUB_DIR=$dir DEPLOY_PROD_LIB=1
# shellcheck source=deploy-prod.sh
source "$script"
set +e  # the checks below read $?; a whole deploy runs as ( set -e; main … ), as the server runs it

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

# front <description> <what the publish prints> [<reason to reload>...]: one publish and
# update_front against a running nginx, as main chains them; its log is in $dir/log and its compose
# calls in $dir/calls.
front() {
  local desc=$1 says=$2 front_published; shift 2
  echo nginx1 > "$dir/nginx-id"; echo "$says" > "$dir/publish-says"; : > "$dir/calls"
  publish_front > "$dir/log" 2>&1 || { echo "FAIL: $desc: publish_front failed"; fail=1; }
  [[ $front_published == no ]] || set -- "$@" "frontend published"
  update_front "$@" >> "$dir/log" 2>&1 || { echo "FAIL: $desc: update_front failed"; fail=1; }
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
# Compose that can't say whether nginx is running is not "no nginx running": the test isn't skipped.
echo nginx1 > "$dir/nginx-id"; touch "$dir/ps-fails"; : > "$dir/calls"
check_nginx_conf > "$dir/log" 2>&1
expect "compose ps fails: the config test fails" test $? = 1
expect "compose ps fails: not logged as no nginx running" bash -c "! grep -q 'No nginx running' '$dir/log'"
rm "$dir/ps-fails" "$dir/conf-broken"

# A whole deploy of a changed frontend onto a running nginx, from the build to the final check.
echo nginx1 > "$dir/nginx-id"; echo "Frontend published (build 4)" > "$dir/publish-says"; : > "$dir/calls"
( main prev123 push ) > "$dir/log" 2>&1
expect "whole deploy: succeeds" test $? = 0
expect "whole deploy: the frontend image is built" grep -q -- "--profile publish build$" "$dir/calls"
expect "whole deploy: nginx kept running" grep -q "nginx: kept running, reloaded (backend rolled, frontend published)" "$dir/log"
expect "whole deploy: one reload" test "$(reloads)" = 1

printf 'backend\nfrontend\nnginx\n' > "$dir/services"; : > "$dir/calls"
restore_front > "$dir/log" 2>&1
expect "rollback: restoring succeeds" test $? = 0
expect "rollback: the previous build is published" grep -q " run --rm frontend$" "$dir/calls"
printf 'backend\nnginx\n' > "$dir/services"; : > "$dir/calls"
restore_front > "$dir/log" 2>&1
expect "rollback to a commit whose nginx image holds the files: nothing to publish" bash -c "! grep -q ' run ' '$dir/calls'"

# A step of the restore that fails stops it there and says which.
rm "$dir/services"; : > "$dir/calls"
restore_front > "$dir/log" 2>&1
expect "restore, services can't be listed: fails" test $? = 1
expect "restore, services can't be listed: says so" grep -q "could not list the previous commit's services" "$dir/log"
printf 'backend\nfrontend\nnginx\n' > "$dir/services"; touch "$dir/build-fails"; : > "$dir/calls"
restore_front > "$dir/log" 2>&1
expect "restore, image build fails: fails" test $? = 1
expect "restore, image build fails: says so" grep -q "could not build the previous frontend image" "$dir/log"
expect "restore, image build fails: nothing published from the stale image" bash -c "! grep -q ' run ' '$dir/calls'"
rm "$dir/build-fails"; echo always > "$dir/publish-fails"
restore_front > "$dir/log" 2>&1
expect "restore, publish fails: fails" test $? = 1
expect "restore, publish fails: says so" grep -q "could not publish the previous frontend build" "$dir/log"
rm "$dir/publish-fails"

# rolled_back <description> <reloads>: the whole rollback after a main that just failed, its log in
# $dir/log, with that many nginx reloads over the deploy and its rollback.
rolled_back() {
  expect "$1: back on the previous commit" grep -qx "checkout prev123" "$dir/git-calls"
  expect "$1: the previous frontend image is built" grep -q -- "--profile publish build frontend$" "$dir/calls"
  expect "$1: the previous backend is built and brought up" grep -q " up -d --build --remove-orphans$" "$dir/calls"
  expect "$1: $2 nginx reload(s)" test "$(reloads)" = "$2"
  expect "$1: logged as a rollback to the previous commit" grep -q "Rolling back to prev123" "$dir/log"
}

# A whole deploy whose final health check never passes: the previous commit, backend and frontend.
echo nginx1 > "$dir/nginx-id"; echo "Frontend unchanged (build 4)" > "$dir/publish-says"
touch "$dir/unhealthy"; : > "$dir/calls"; : > "$dir/git-calls"
( set -e; main prev123 push ) > "$dir/log" 2>&1
expect "failed health check: the deploy fails" test $? = 1
rolled_back "failed health check" 2  # the backend rolled, then the rollback
expect "failed health check: published, then the previous build published" test "$(grep -c ' run --rm frontend$' "$dir/calls")" = 2
expect "failed health check: no restore warning" bash -c "! grep -q 'NOT RESTORED' '$dir/log'"
rm "$dir/unhealthy"

# A whole deploy whose publish fails after the backend rolled: the same rollback, not a server left
# with the new backend, the new checkout and the other services not brought up.
echo once > "$dir/publish-fails"; : > "$dir/calls"; : > "$dir/git-calls"
( set -e; main prev123 push ) > "$dir/log" 2>&1
expect "failed publish: the deploy fails" test $? = 1
expect "failed publish: logged" grep -q "FRONTEND PUBLISH FAILED" "$dir/log"
rolled_back "failed publish" 1
expect "failed publish: the new commit's other services are not brought up" bash -c "! grep -q ' up -d --remove-orphans$' '$dir/calls'"
expect "failed publish: the previous build is published" test "$(grep -c ' run --rm frontend$' "$dir/calls")" = 2
expect "failed publish: no restore warning" bash -c "! grep -q 'NOT RESTORED' '$dir/log'"

# The publish fails and so does the restore's: the rollback still finishes, and says so loudly.
echo always > "$dir/publish-fails"; : > "$dir/calls"; : > "$dir/git-calls"
( set -e; main prev123 push ) > "$dir/log" 2>&1
expect "failed publish and restore: the deploy fails" test $? = 1
rolled_back "failed publish and restore" 1
expect "failed publish and restore: says the previous build is not restored" grep -q "PREVIOUS FRONTEND BUILD NOT RESTORED" "$dir/log"
rm "$dir/publish-fails"

# New replicas that never answer: they are removed, the old ones kept, and nginx is reloaded the one
# way every other step reloads it, through compose.
echo "old1" > "$dir/backend-ids"; : > "$dir/up"; : > "$dir/calls"; : > "$dir/git-calls"
( set -e; main prev123 workflow_dispatch ) > "$dir/log" 2>&1
expect "replicas never healthy: the deploy fails" test $? = 1
expect "replicas never healthy: back on the previous commit" grep -qx "checkout prev123" "$dir/git-calls"
expect "replicas never healthy: nginx reloaded through compose" test "$(reloads)" = 1
rm "$dir/backend-ids"

(( fail )) && exit 1
echo "PASS: deploy-prod.sh rolls only on a change, waits for every new replica and keeps nginx running"
