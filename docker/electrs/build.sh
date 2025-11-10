#!/bin/bash
VERSION=v0.10.9
export VERSION=${VERSION}
docker buildx build --build-arg VERSION -t local/electrs:${VERSION} .
