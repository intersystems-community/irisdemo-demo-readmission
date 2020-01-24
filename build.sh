#!/bin/bash
VERSION=`cat ./VERSION`
DOCKER_TAG="version-${VERSION}"
DOCKER_REPOSITORY=intersystemsdc/irisdemo-demo-readmission

docker build -t ${DOCKER_REPOSITORY}:readmissionrisksrv-${DOCKER_TAG} ./readmissionrisksrv/

docker build -t ${DOCKER_REPOSITORY}:RRLACESrv-${DOCKER_TAG} ./RRLACESrv/

docker build -t ${DOCKER_REPOSITORY}:hisdb-${DOCKER_TAG} ./hisdb/

docker build -t ${DOCKER_REPOSITORY}:hisui-${DOCKER_TAG} ./hisui/

