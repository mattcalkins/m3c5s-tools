#!/usr/bin/env sh

echo "This npx binary has been deprecated and replaced by the npx binary 'm3c5s-push2'."


if [ -z "$DOCKER_IMAGE_NAME" ]; then
    echo "Error: DOCKER_IMAGE_NAME environment variable is not set." >&2
    exit 1
fi

if [ -z "$DOCKER_IMAGE_VERSION_NUMBER" ]; then
    echo "Error: DOCKER_IMAGE_VERSION_NUMBER environment variable is not set." >&2
    exit 1
fi

if [ -z "$DOCKER_IMAGE_REPOSITORY_URI" ]; then
    echo "Error: DOCKER_IMAGE_REPOSITORY_URI environment variable is not set." >&2
    exit 1
fi

echo "Pushing $DOCKER_IMAGE_NAME to $DOCKER_IMAGE_REPOSITORY_URI"

execute_command() {
    local COMMAND="$1"
    echo "$COMMAND"
    eval "$COMMAND"
    if [ $? -ne 0 ]; then
        echo "Error: command failed." >&2
        return 1
    fi
    return 0
}

execute_command "docker tag \"$DOCKER_IMAGE_NAME:$DOCKER_IMAGE_VERSION_NUMBER\" \"$DOCKER_IMAGE_REPOSITORY_URI:$DOCKER_IMAGE_VERSION_NUMBER\""
if [ $? -ne 0 ]; then
    exit 1
fi

execute_command "docker tag \"$DOCKER_IMAGE_NAME:$DOCKER_IMAGE_VERSION_NUMBER\" \"$DOCKER_IMAGE_REPOSITORY_URI:latest\""
if [ $? -ne 0 ]; then
    exit 1
fi

execute_command "docker push \"$DOCKER_IMAGE_REPOSITORY_URI:$DOCKER_IMAGE_VERSION_NUMBER\""
if [ $? -ne 0 ]; then
    exit 1
fi

execute_command "docker push \"$DOCKER_IMAGE_REPOSITORY_URI:latest\""
if [ $? -ne 0 ]; then
    exit 1
fi
