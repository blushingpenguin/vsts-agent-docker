#!/bin/bash
set -e

cd "$(dirname $0)"

GIT_COMMIT=${1:-$(git rev-parse HEAD)}
GITHUB_BASE_URL="https://github.com/microsoft/vsts-agent-docker/blob/$GIT_COMMIT"
LATEST_TAG=$(cat latest.tag)

while read DOCKER_TAG; do
  DOCKERFILE_URL=$(echo $DOCKER_TAG | sed 's/-/\//g')/Dockerfile
  MD="[\`$DOCKER_TAG\`]($GITHUB_BASE_URL/$DOCKERFILE_URL)"
  if [ "$DOCKER_TAG" == "$LATEST_TAG" ]; then
    MD="$MD, [\`latest\`]($GITHUB_BASE_URL/$DOCKERFILE_URL)"
  fi
  echo "- $MD [($DOCKERFILE_URL)]($GITHUB_BASE_URL/$DOCKERFILE_URL)"
done < <(ubuntu/list-tags.sh)
