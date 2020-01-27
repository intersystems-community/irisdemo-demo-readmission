
include .env

compressedBuild:
	docker build -t ${DOCKER_REPOSITORY}:riskengine-version-${TAG} ./image-riskengine/

build:
	docker build -t ${DOCKER_REPOSITORY}:risksrv-version-${TAG} ./image-risksrv/
	docker build -t ${DOCKER_REPOSITORY}:riskengine-version-${TAG} ./image-riskengine/
	docker build --build-arg SOURCE_BRANCH=${TAG} -t ${DOCKER_REPOSITORY}:hisdb-version-${TAG} ./image-hisdb/
	docker build -t ${DOCKER_REPOSITORY}:hidb-version-${TAG} ./image-hisui/

clean:
	-docker rmi ${DOCKER_REPOSITORY}:risksrv-version-${TAG}
	-docker rmi ${DOCKER_REPOSITORY}:riskengine-version-${TAG} 
	-docker rmi ${DOCKER_REPOSITORY}:hisdb-version-${TAG}
	-docker rmi ${DOCKER_REPOSITORY}:hisui-version-${TAG}

push:
	docker push ${DOCKER_REPOSITORY}:risksrv-version-${TAG}
	docker push ${DOCKER_REPOSITORY}:riskengine-version-${TAG}
	docker push ${DOCKER_REPOSITORY}:hisdb-version-${TAG}
	docker push ${DOCKER_REPOSITORY}:hisui-version-${TAG}

run:
	docker-compose up
