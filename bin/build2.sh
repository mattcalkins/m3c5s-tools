#!/usr/bin/env sh

set -eu


DOCKER_IMAGE_NAME=$(node -p "require('./package.json')['m3c5s-tools']['docker-image-name'] || ''")

if [ -z "$DOCKER_IMAGE_NAME" ]; then
    printf "Error: m3c5s-tools.docker-image-name is not set in package.json.\n" >&2
    exit 1
else
    printf "Docker Image Name:           %s\n" "$DOCKER_IMAGE_NAME"
fi


DOCKER_IMAGE_VERSION_NUMBER=$(node -p "require('./package.json')['version'] || ''")

if [ -z "$DOCKER_IMAGE_VERSION_NUMBER" ]; then
    printf "Error: version is not set in package.json.\n" >&2
    exit 1
else
    printf "Docker Image Version Number: %s\n" "$DOCKER_IMAGE_VERSION_NUMBER"
fi


BUILD_NUMBER=$(TZ=America/Los_Angeles npx m3c5s-generate-timestamp-tag)
SEMANTIC_VERSION_NUMBER="${DOCKER_IMAGE_VERSION_NUMBER}+${BUILD_NUMBER}"
DOCKER_IMAGE_TAG=$(printf "%s" "$SEMANTIC_VERSION_NUMBER" | sed 's/+/--/g')

printf "Semantic version number:     %s\n" "$SEMANTIC_VERSION_NUMBER"
printf "Docker image tag:            %s\n\n" "$DOCKER_IMAGE_TAG"


COMMAND="\
    docker build \
    --platform linux/amd64 \
    --pull \
    --tag \"$DOCKER_IMAGE_NAME:$DOCKER_IMAGE_VERSION_NUMBER\" \
    --tag \"$DOCKER_IMAGE_NAME:$DOCKER_IMAGE_TAG\" \
    --tag \"$DOCKER_IMAGE_NAME:latest\" \
    . \
"

printf "%s\n" "$COMMAND"
eval "$COMMAND"
