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


DOCKER_IMAGE_REGISTRY_URI=$(node -p "require('./package.json')['m3c5s-tools']['docker-image-registry-uri'] || ''")

if [ -z "$DOCKER_IMAGE_REGISTRY_URI" ]; then
    printf "Error: m3c5s-tools.docker-image-registry-uri is not set in package.json.\n" >&2
    exit 1
else
    printf "Docker Image Repository URI:           %s\n" "$DOCKER_IMAGE_REGISTRY_URI"
fi


echo "Pushing $DOCKER_IMAGE_NAME to $DOCKER_IMAGE_REGISTRY_URI"

execute_command() {
    local COMMAND="$1"
    echo "$COMMAND"
    eval "$COMMAND"
}

# Extract the registry URI from the full repository URI
REGISTRY_URI=$(echo "$DOCKER_IMAGE_REGISTRY_URI" | cut -d'/' -f1)

execute_command "aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $REGISTRY_URI"

execute_command "docker tag \"$DOCKER_IMAGE_NAME:$DOCKER_IMAGE_VERSION_NUMBER\" \"$DOCKER_IMAGE_REGISTRY_URI:$DOCKER_IMAGE_VERSION_NUMBER\""

execute_command "docker tag \"$DOCKER_IMAGE_NAME:$DOCKER_IMAGE_VERSION_NUMBER\" \"$DOCKER_IMAGE_REGISTRY_URI:latest\""

execute_command "docker push \"$DOCKER_IMAGE_REGISTRY_URI:$DOCKER_IMAGE_VERSION_NUMBER\""

execute_command "docker push \"$DOCKER_IMAGE_REGISTRY_URI:latest\""
