#!/bin/bash

source ./buildtools.sh

VERSION=`cat ./VERSION`
DOCKER_TAG="version-${VERSION}"
DOCKER_REPOSITORY=intersystemsdc/irisdemo-demo-readmission

trace "Building ./image-risksrv/"
docker build -t ${DOCKER_REPOSITORY}:risksrv-${DOCKER_TAG} ./image-risksrv/
exit_if_error "Error when building ./image-risksrv/"

trace "Building ./image-riskengine/"
docker build -t ${DOCKER_REPOSITORY}:riskengine-${DOCKER_TAG} ./image-riskengine/
exit_if_error "Error when building ./image-riskengine/"

trace "Building ./image-hisdb/"
docker build -t ${DOCKER_REPOSITORY}:hisdb-${DOCKER_TAG} ./image-hisdb/
exit_if_error "Error when building ./image-hisdb/"

trace "Building ./image-hisui/"
docker build -t ${DOCKER_REPOSITORY}:hisui-${DOCKER_TAG} ./image-hisui/
exit_if_error "Error when building ./image-hisui/"
