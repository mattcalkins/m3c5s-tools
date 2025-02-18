#!/usr/bin/env sh

set -e

echo "This npx binary has been deprecated and replaced by the npx binary 'm3c5s-build2'."


if [ -z "$DOCKER_IMAGE_NAME" ]; then
    printf "Error: DOCKER_IMAGE_NAME environment variable is not set.\n" >&2
    exit 1
fi

if [ -z "$DOCKER_IMAGE_VERSION_NUMBER" ]; then
    printf "Error: DOCKER_IMAGE_VERSION_NUMBER environment variable is not set.\n" >&2
    exit 1
fi

printf "Building %s Docker image\n" "$DOCKER_IMAGE_NAME"

if [ -z "$BUILD_NUMBER" ]; then
    BUILD_NUMBER=$(TZ=America/Los_Angeles npx m3c5s-generate-timestamp-tag)
fi

SEMANTIC_VERSION_NUMBER="${DOCKER_IMAGE_VERSION_NUMBER}+${BUILD_NUMBER}"
DOCKER_IMAGE_TAG=$(printf "%s" "$SEMANTIC_VERSION_NUMBER" | sed 's/+/--/g')

printf "  Semantic version number: %s\n" "$SEMANTIC_VERSION_NUMBER"
printf "         Docker image tag: %s\n\n" "$DOCKER_IMAGE_TAG"

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
