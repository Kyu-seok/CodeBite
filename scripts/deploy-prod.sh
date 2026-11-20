#!/usr/bin/env bash
# Rolls production to the checked-out commit; Deploy (.github/workflows/deploy.yml) runs it on the
# server over SSH right after `git pull`:
#
#   scripts/deploy-prod.sh <previous-commit> <github-event>
#
# <previous-commit> is what the checkout held before the pull, the rollback target; <github-event>
# is push or workflow_dispatch (a manual run always rolls the backend, to pick up infra/.env).
# Builds the images, starts three new backend replicas beside the three old ones, drains the old
# ones once the new answer /api/health, then updates the other services. Rolls back to
# <previous-commit> when the new replicas or the final check stay unhealthy.
#
# Everything runs inside main(): a rollback checks out an older copy of this very file, and bash
# reads a script as it goes, but a function is read whole before it runs.
# DEPLOY_PROD_LIB=1 only defines the functions, for scripts/deploy-prod.test.sh.
set -euo pipefail

COMPOSE=(docker compose -f infra/docker-compose.prod.yml)

# No default provenance attestation on any build this script starts. BuildKit attaches one to every
# build, new each time, and under Docker's containerd image store an image's id is the digest of
# the index holding both: a fully cached build got a new id, so needs_roll rolled unchanged code
# and `up` recreated an unchanged nginx and worker (#403). `provenance: false` in the compose file
# doesn't do it: compose 5.1.0 leaves a false out of what it hands buildx.
export BUILDX_NO_DEFAULT_ATTESTATIONS=1

# Roll the backend only when its image or its compose config changed: a docs- or frontend-only
# merge builds from cache, and rolling identical replicas spends ~2 min for nothing.
# needs_roll <event> <new-image-id> <new-config-hash> [<old container id>...]
needs_roll() {
  local event=$1 image=$2 hash=$3; shift 3
  [[ $event == workflow_dispatch ]] && return 0
  (( $# )) || return 0
  local id old
  for id in "$@"; do
    old=$(docker inspect -f '{{.Image}} {{index .Config.Labels "com.docker.compose.config-hash"}}' "$id" 2>/dev/null) || old=""
    if [[ $old != "$image $hash" ]]; then
      # Which of the two differs, so a roll of unchanged code can be traced to its cause.
      echo "--- Rolling: replica $id has image/config '$old', the build has '$image $hash' ---"
      return 0
    fi
  done
  return 1
}

# Asks each container's /api/health itself, not through nginx (which may be down or point at
# stale DNS) and not Docker's healthcheck (which only looks every 15s).
# wait_healthy <attempts> <seconds between> <container id>...
wait_healthy() {
  local attempts=$1 pause=$2 i id all; shift 2
  for (( i = 1; i <= attempts; i++ )); do
    all=true
    for id in "$@"; do
      docker exec "$id" wget --quiet --tries=1 -O /dev/null http://localhost:8080/api/health 2>/dev/null \
        || { all=false; break; }
    done
    if [[ $all == true ]]; then
      echo "--- New replicas healthy after ~$(( (i - 1) * pause ))s ---"
      return 0
    fi
    sleep "$pause"
  done
  return 1
}

main() {
  local prev=$1 event=$2
  echo "--- Previous commit: $prev ---"
  # Recorded so a log answers which Docker features the server has.
  echo "--- Docker $(docker version --format '{{.Server.Version}}'), $(docker compose version --short 2>/dev/null || docker compose version) ---"

  echo "--- Building new images ---"
  "${COMPOSE[@]}" build

  local old_ids new_ids="" all_ids id
  old_ids=$("${COMPOSE[@]}" ps -q backend | tr '\n' ' ')
  echo "--- Old backend containers: $old_ids ---"

  local image hash
  image=$(docker image inspect -f '{{.Id}}' codebite-backend)
  hash=$("${COMPOSE[@]}" config --hash backend | awk '$1 == "backend" {print $2}')
  # shellcheck disable=SC2086 # old_ids is a list of ids
  if needs_roll "$event" "$image" "$hash" $old_ids; then
    echo "--- Starting new replicas alongside old ones ---"
    "${COMPOSE[@]}" up -d --no-deps --scale backend=6 --no-recreate backend

    all_ids=$("${COMPOSE[@]}" ps -q backend | tr '\n' ' ')
    for id in $all_ids; do
      case " $old_ids " in
        *" $id "*) ;;
        *) new_ids="$new_ids $id" ;;
      esac
    done
    echo "--- New backend containers:$new_ids ---"

    # Budget ~5 min: Spring Boot cold start on the mini PC is ~30-100s depending on JVM warm-up
    # and disk cache.
    echo "--- Waiting for new replicas to be healthy ---"
    # shellcheck disable=SC2086 # new_ids is a list of ids
    if ! wait_healthy 150 2 $new_ids; then
      # Remove only the new containers by id (no --remove-orphans, which can take nginx down) and
      # leave the old healthy replicas serving.
      echo "--- NEW REPLICAS NEVER HEALTHY — Rolling back to $prev ---"
      for id in $new_ids; do
        echo "--- Removing unhealthy new container $id ---"
        docker stop --time 15 "$id" 2>/dev/null || true
        docker rm -f "$id" 2>/dev/null || true
      done
      git checkout "$prev"
      "${COMPOSE[@]}" up -d --no-deps --scale backend=3 backend
      docker exec codebite-nginx nginx -s reload 2>/dev/null || true
      exit 1
    fi

    # Drain the old containers one by one (graceful shutdown).
    for id in $old_ids; do
      echo "--- Stopping old container $id ---"
      docker stop --time 30 "$id"
      docker rm "$id" 2>/dev/null || true
      sleep 5
    done
  else
    echo "--- Backend image and config unchanged: keeping the running replicas ---"
  fi

  # Back to 3 replicas, then every other service; nginx reloads to pick up new backend IPs.
  "${COMPOSE[@]}" up -d --no-deps --scale backend=3 backend
  "${COMPOSE[@]}" up -d --remove-orphans
  docker exec codebite-nginx nginx -s reload

  echo "--- Final health check ---"
  local healthy=false i
  for (( i = 1; i <= 24; i++ )); do
    sleep 5
    if curl -sf http://localhost/api/health >/dev/null 2>&1; then
      healthy=true
      echo "--- Deploy healthy (attempt $i) ---"
      break
    fi
    echo "--- Health check attempt $i failed, retrying... ---"
  done

  if [[ $healthy == false ]]; then
    echo "--- HEALTH CHECK FAILED — Rolling back to $prev ---"
    git checkout "$prev"
    "${COMPOSE[@]}" up -d --build --remove-orphans
    echo "--- Rollback complete, waiting for recovery ---"
    sleep 30
    if curl -sf http://localhost/api/health >/dev/null 2>&1; then
      echo "--- Rollback healthy ---"
    else
      echo "--- WARNING: Rollback also unhealthy ---"
    fi
    exit 1
  fi

  docker image prune -f
  echo "--- Post-deploy status ---"
  "${COMPOSE[@]}" ps
}

if [[ -z ${DEPLOY_PROD_LIB:-} ]]; then
  [[ $# -eq 2 ]] || { echo "usage: scripts/deploy-prod.sh <previous-commit> <github-event>" >&2; exit 2; }
  main "$@"
fi
