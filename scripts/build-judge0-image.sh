#!/usr/bin/env bash
# Builds the custom Judge0 image (infra/judge0/Dockerfile) on the production server and tags it
# localhost/codebite-judge0:1.13.1-py312. CI never builds it (docs/adr/0004), so run this after
# changing the Dockerfile, or if the image is ever lost from the server.
#
# The Dockerfile copies nothing in, so it is piped over ssh as the whole build context: the
# server's checkout doesn't need to be on this branch. The classic builder on two cores with low
# CPU shares keeps live judging ahead of the build.
#
# Run from the repo root:  scripts/build-judge0-image.sh   (SSH_TARGET defaults to mini)
set -euo pipefail

SSH_TARGET=${SSH_TARGET:-mini}
IMAGE=localhost/codebite-judge0:1.13.1-py312

ssh "$SSH_TARGET" "DOCKER_BUILDKIT=0 docker build --cpuset-cpus=2,3 --cpu-shares=128 -t $IMAGE -" \
  < infra/judge0/Dockerfile
ssh "$SSH_TARGET" "docker image inspect -f '$IMAGE built {{.Created}}' $IMAGE"
