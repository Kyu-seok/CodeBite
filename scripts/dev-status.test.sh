#!/usr/bin/env bash
# Tests what scripts/dev-status.sh says about the codebite-postgres, codebite-kafka and
# codebite-redis containers, and nothing else of its report. The whole script runs, against stubs
# first on PATH: a docker in the state the case names, a pgrep that finds no server (one, for the
# last case) and a curl that
# answers for Judge0, so no line depends on what runs on this machine. Only the lines that start
# with a container's name, `docker:` or `containers:` are compared.
set -euo pipefail
here=$(cd "$(dirname "$0")" && pwd)
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
mkdir "$tmp/bin"
cat > "$tmp/bin/docker" <<'STUB'
#!/usr/bin/env bash
# STUB_DOCKER=down: the daemon doesn't answer. STUB_STOPPED: the containers that don't run, the
# first of them stopped and any other never created.
if [[ "${STUB_DOCKER:-up}" == down ]]; then
  echo 'Cannot connect to the Docker daemon at unix:///var/run/docker.sock. Is the docker daemon running?' >&2
  exit 1
fi
name=${*: -1}
case "$1" in
  info) exit 0 ;;
  inspect)
    case " ${STUB_STOPPED:-} " in
      *" $name "*)
        if [[ "$STUB_STOPPED" == "$name"* ]]; then echo false; exit 0; fi
        echo; echo "Error: No such object: $name" >&2; exit 1 ;;
    esac
    echo true ;;
  *) cat >/dev/null; exit 1 ;;   # no database answers: the database line is not under test
esac
STUB
printf '#!/bin/sh\nexit 1\n' > "$tmp/bin/pgrep"
printf '#!/bin/sh\nexit 0\n' > "$tmp/bin/curl"
chmod +x "$tmp/bin/docker" "$tmp/bin/pgrep" "$tmp/bin/curl"

fail() { echo "FAIL: $1" >&2; exit 1; }

# The container lines of a run; its whole report goes to $tmp/out and its exit code to $tmp/code
# (the caller is a command substitution, which keeps no variable).
container_lines() {
  local out code=0
  out=$(cd "$here/.." && PATH="$tmp/bin:$PATH" "$here/dev-status.sh" 2>"$tmp/err") || code=$?
  printf '%s\n' "$out" > "$tmp/out"
  echo "$code" > "$tmp/code"
  printf '%s\n' "$out" | grep -E '^(codebite-[a-z]+|docker|containers):' || true
}
start="start it: docker compose -f infra/docker-compose.yml up -d"
postgres_line="codebite-postgres: STOPPED  no database, so the backend and worker don't start and the database scripts refuse; $start postgres"
kafka_line="codebite-kafka: STOPPED  every Submit stays PENDING; $start kafka"
redis_line="codebite-redis: STOPPED  the Run and Submit cooldowns and the token blacklist fail; $start redis"

lines=$(container_lines)
[[ "$lines" == "containers: codebite-postgres, codebite-kafka and codebite-redis run" ]] \
  || fail "all three running should be one line saying so, got: $lines"
[[ ! -s "$tmp/err" ]] || fail "nothing should reach stderr: $(cat "$tmp/err")"
all_up_code=$(cat "$tmp/code")

lines=$(STUB_STOPPED="codebite-kafka codebite-redis" container_lines)
[[ "$lines" == "$kafka_line"$'\n'"$redis_line" ]] \
  || fail "a stopped Kafka and a Redis never created should be one line each, what breaks and what starts it, got: $lines"
[[ ! -s "$tmp/err" ]] || fail "docker's own errors should not show: $(cat "$tmp/err")"
[[ "$(cat "$tmp/code")" == "$all_up_code" ]] \
  || fail "a stopped container should leave the exit code as it was ($all_up_code), got $(cat "$tmp/code")"

lines=$(STUB_STOPPED="codebite-postgres" container_lines)
[[ "$lines" == "$postgres_line" ]] || fail "a stopped Postgres should be flagged alone, got: $lines"

lines=$(STUB_STOPPED="codebite-redis codebite-postgres codebite-kafka" container_lines)
[[ "$lines" == "$postgres_line"$'\n'"$kafka_line"$'\n'"$redis_line" ]] \
  || fail "all three stopped should be three lines, got: $lines"

lines=$(STUB_DOCKER=down container_lines)
[[ "$lines" == "docker: DOWN  no Postgres, Kafka or Redis: the Docker daemon doesn't answer; start Docker Desktop (open -a Docker) and rerun" ]] \
  || fail "a Docker daemon that doesn't answer should be one line, not one per container, got: $lines"
[[ ! -s "$tmp/err" ]] || fail "docker's own errors should not show: $(cat "$tmp/err")"

# A stopped container never reads as all well. For the OK line to be possible at all, pgrep finds
# one backend of this checkout: a shell whose command line holds the path a bootRun's does.
root=$(cd "$here/.." && git rev-parse --show-toplevel)
bash -c 'while :; do sleep 1; done' "$root/backend/build/classes/java/main" &
backend=$!
trap 'kill "$backend" 2>/dev/null && wait "$backend" 2>/dev/null || true; rm -rf "$tmp"' EXIT
printf '#!/bin/sh\ncase "$2" in */backend/build/*) echo %s ;; *) exit 1 ;; esac\n' "$backend" > "$tmp/bin/pgrep"
container_lines >/dev/null
grep -q '^OK:' "$tmp/out" || fail "with every container running the stubbed report should end OK: $(cat "$tmp/out")"
STUB_STOPPED="codebite-kafka" container_lines >/dev/null
if grep -q '^OK:' "$tmp/out"; then fail "a stopped container should keep the OK line away: $(cat "$tmp/out")"; fi
grep -q '^codebite-kafka: STOPPED' "$tmp/out" || fail "the stopped container should still be flagged: $(cat "$tmp/out")"

# The compose commands name services infra/docker-compose.yml still has, under these container names.
for service in postgres kafka redis; do
  grep -A3 "^  $service:\$" "$here/../infra/docker-compose.yml" | grep -q "container_name: codebite-$service\$" \
    || fail "infra/docker-compose.yml no longer has a service $service whose container is codebite-$service"
done

echo "dev-status.test.sh: ok"
