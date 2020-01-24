
include .env

compressedBuild:
	docker build -t ${DOCKER_REPOSITORY}:readmission_RRLACESrv-version-${TAG} ./RRLACESrv/

build:
	docker build -t ${DOCKER_REPOSITORY}:readmission_readmissionrisksrv-version-${TAG} ./readmissionrisksrv/
	docker build -t ${DOCKER_REPOSITORY}:readmission_RRLACESrv-version-${TAG} ./RRLACESrv/
	docker build --build-arg SOURCE_BRANCH=${TAG} -t ${DOCKER_REPOSITORY}:readmission_hisdb-version-${TAG} ./hisdb/
	docker build -t ${DOCKER_REPOSITORY}:readmission_hisui-version-${TAG} ./hisui/

clean:
	-docker rmi ${DOCKER_REPOSITORY}:readmission_readmissionrisksrv-version-${TAG}
	-docker rmi ${DOCKER_REPOSITORY}:readmission_RRLACESrv-version-${TAG} 
	-docker rmi ${DOCKER_REPOSITORY}:readmission_hisdb-version-${TAG}
	-docker rmi ${DOCKER_REPOSITORY}:readmission_hisui-version-${TAG}

push:
	docker push ${DOCKER_REPOSITORY}:readmission_readmissionrisksrv-version-${TAG}
	docker push ${DOCKER_REPOSITORY}:readmission_RRLACESrv-version-${TAG}
	docker push ${DOCKER_REPOSITORY}:readmission_hisdb-version-${TAG}
	docker push ${DOCKER_REPOSITORY}:readmission_hisui-version-${TAG}

run:
	docker-compose up
