#!/usr/bin/env bash
# Tests what scripts/dev-status.sh says about the codebite-postgres, codebite-kafka and
# codebite-redis containers and about what branch databases left behind, and nothing else of its
# report. The whole script runs, against stubs first on PATH: a docker in the state the case
# names, a pgrep that finds no server (one, for the OK case) and a curl that
# answers for Judge0, so no line depends on what runs on this machine. Only the lines that start
# with a container's name, `docker:`, `containers:` or `branch databases:` are compared.
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
# STUB_PG=up: the postgres database answers (the codebite one never does: its lines are not under
# test) with STUB_DATABASES, every database's name, and STUB_BRANCH_DBS, a "<name>\t<worktree>"
# line per branch database. STUB_REDIS_OWNERS: "<index>=<database>" words, the claimed Redis
# indexes. STUB_TOPICS, STUB_GROUPS: Kafka's. Each call's arguments are a line of STUB_CALLS.
if [[ -n "${STUB_CALLS:-}" ]]; then echo "$*" >> "$STUB_CALLS"; fi
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
  exec)
    case " ${STUB_STOPPED:-} " in *" $2 "*) echo "Error: container $2 is not running" >&2; exit 1 ;; esac
    case "$2 $*" in
      codebite-postgres\ *)
        [[ "${STUB_PG:-}" == up ]] || { cat >/dev/null; exit 1; }
        case "$*" in
          *" pg_isready "*) exit 0 ;;
          *"-d postgres "*shobj_description*) printf '%s' "${STUB_BRANCH_DBS:+$STUB_BRANCH_DBS$'\n'}" ;;
          *"-d postgres -tAc SELECT datname FROM pg_database") printf '%s\n' postgres codebite ${STUB_DATABASES:-} ;;
          *) cat >/dev/null; exit 1 ;;
        esac ;;
      codebite-redis\ *" GET codebite-dev-branch-owner")
        for claim in ${STUB_REDIS_OWNERS:-}; do
          if [[ "${claim%%=*}" == "$5" ]]; then echo "${claim#*=}"; fi
        done ;;
      codebite-kafka\ *kafka-topics.sh*" --list") printf '%s\n' submission-events ${STUB_TOPICS:-} ;;
      codebite-kafka\ *kafka-consumer-groups.sh*" --list") printf '%s\n' codebite-worker ${STUB_GROUPS:-} ;;
      *) cat >/dev/null; exit 1 ;;
    esac ;;
  *) cat >/dev/null; exit 1 ;;
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
  printf '%s\n' "$out" | grep -E '^(codebite-[a-z]+|docker|containers|branch databases):' || true
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

# What branch databases left behind (scripts/dev-branch-servers.sh orphans lists it) is one line
# after the containers', with how many databases and the command; none when there is nothing, or
# when Postgres doesn't answer, which the lines above already say.
printf '#!/bin/sh\nexit 1\n' > "$tmp/bin/pgrep"
up="containers: codebite-postgres, codebite-kafka and codebite-redis run"
left() {
  echo "branch databases: LEFTOVER  $1 left behind (a database whose worktree is gone, or a dropped one's Kafka topics or Redis index); list them: scripts/dev-branch-servers.sh orphans"
}
export STUB_PG=up STUB_CALLS="$tmp/calls"

lines=$(container_lines)
[[ "$lines" == "$up" ]] || fail "with nothing left behind there should be no line about it, got: $lines"
[[ ! -s "$tmp/err" ]] || fail "nothing should reach stderr: $(cat "$tmp/err")"
clean_code=$(cat "$tmp/code")

lines=$(STUB_REDIS_OWNERS="3=codebite_gone_aaaaaaaa" container_lines)
[[ "$lines" == "$up"$'\n'"$(left 1)" ]] \
  || fail "a Redis index claimed by a database that is gone should be flagged, got: $lines"
[[ "$(cat "$tmp/code")" == "$clean_code" ]] \
  || fail "a leftover should leave the exit code as it was ($clean_code), got $(cat "$tmp/code")"

lines=$(STUB_TOPICS="codebite_gone_bbbbbbbb-submission-events" container_lines)
[[ "$lines" == "$up"$'\n'"$(left 1)" ]] \
  || fail "a Kafka topic of a database that is gone should be flagged, got: $lines"

# One database counts once, whatever it left; a database whose worktree is gone counts too; a
# claim by a database that exists is nobody's leftover.
lines=$(STUB_BRANCH_DBS="codebite_lost_cccccccc"$'\t'"$tmp/no-such-worktree" \
  STUB_DATABASES="codebite_lost_cccccccc codebite_live_dddddddd" \
  STUB_REDIS_OWNERS="2=codebite_live_dddddddd 3=codebite_gone_aaaaaaaa 7=codebite_gone_bbbbbbbb" \
  STUB_TOPICS="codebite_gone_aaaaaaaa-submission-events codebite_gone_aaaaaaaa-submission-results" \
  STUB_GROUPS="codebite_gone_aaaaaaaa-worker" container_lines)
[[ "$lines" == "$up"$'\n'"$(left 3)" ]] \
  || fail "three databases with something left should be counted as three, got: $lines"
[[ ! -s "$tmp/err" ]] || fail "nothing should reach stderr: $(cat "$tmp/err")"

# A stopped Kafka is not asked: its STOPPED line stands for what couldn't be looked at.
: > "$tmp/calls"
lines=$(STUB_STOPPED="codebite-kafka" STUB_REDIS_OWNERS="3=codebite_gone_aaaaaaaa" \
  STUB_TOPICS="codebite_gone_bbbbbbbb-submission-events" container_lines)
[[ "$lines" == "$kafka_line"$'\n'"$(left 1)" ]] \
  || fail "with Kafka stopped the Redis leftover should still be flagged, and no error added, got: $lines"
[[ ! -s "$tmp/err" ]] || fail "nothing should reach stderr: $(cat "$tmp/err")"
if grep -q '^exec codebite-kafka ' "$tmp/calls"; then
  fail "a stopped Kafka should get no Kafka CLI call: $(grep '^exec codebite-kafka ' "$tmp/calls")"
fi
grep -q '^exec codebite-redis ' "$tmp/calls" || fail "the Redis indexes should have been read: $(cat "$tmp/calls")"

: > "$tmp/calls"
lines=$(STUB_STOPPED="codebite-redis" STUB_REDIS_OWNERS="3=codebite_gone_aaaaaaaa" container_lines)
[[ "$lines" == "$redis_line" ]] || fail "with Redis stopped and nothing else left, only its STOPPED line, got: $lines"
if grep -q '^exec codebite-redis ' "$tmp/calls"; then fail "a stopped Redis should not be asked"; fi

: > "$tmp/calls"
lines=$(STUB_STOPPED="codebite-postgres" STUB_REDIS_OWNERS="3=codebite_gone_aaaaaaaa" container_lines)
[[ "$lines" == "$postgres_line" ]] || fail "with Postgres stopped, only its STOPPED line, got: $lines"
[[ ! -s "$tmp/err" ]] || fail "nothing should reach stderr: $(cat "$tmp/err")"
if grep -q '^exec codebite-\(kafka\|redis\) ' "$tmp/calls"; then
  fail "without Postgres nothing can be told left behind, so Kafka and Redis should not be asked: $(cat "$tmp/calls")"
fi
unset STUB_PG STUB_CALLS

# The compose commands name services infra/docker-compose.yml still has, under these container names.
for service in postgres kafka redis; do
  grep -A3 "^  $service:\$" "$here/../infra/docker-compose.yml" | grep -q "container_name: codebite-$service\$" \
    || fail "infra/docker-compose.yml no longer has a service $service whose container is codebite-$service"
done

echo "dev-status.test.sh: ok"
