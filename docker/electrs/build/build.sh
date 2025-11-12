#!/bin/bash
PATH_TO_DOCKER_FILE=./Dockerfile
IMAGE_NAME=local/electrs
VERSION=v0.10.9

export VERSION=${VERSION}
export UID=$(id -u)
export GID=$(id -g)
export USER=$(id -un)
export GROUP=$(id -gn)

docker buildx build -f ${PATH_TO_DOCKER_FILE} \
--build-arg VERSION \
--build-arg UID \
--build-arg GID \
--build-arg USER \
--build-arg GROUP \
-t ${IMAGE_NAME}:${VERSION} .
