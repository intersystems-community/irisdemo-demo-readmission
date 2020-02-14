#!/bin/bash
VERSION=`cat ./VERSION`
DOCKER_TAG="version-${VERSION}"
DOCKER_REPOSITORY=intersystemsdc/irisdemo-demo-readmission

docker build -t ${DOCKER_REPOSITORY}:risksrv-${DOCKER_TAG} ./image-risksrv/

docker build -t ${DOCKER_REPOSITORY}:riskengine-${DOCKER_TAG} ./image-riskengine/

docker build -t ${DOCKER_REPOSITORY}:hisdb-${DOCKER_TAG} ./image-hisdb/

docker build -t ${DOCKER_REPOSITORY}:hisui-${DOCKER_TAG} ./image-hisui/

