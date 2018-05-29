SHELL				:= /bin/bash
VERSION				?= 0.0.1
BUILD				:= $(shell date -u +%FT%T%z)
GIT_HASH			:= $(shell git rev-parse HEAD)
GIT_REPO			:= $(shell git config --get remote.origin.url)
BUILDKITE_COMMIT	?= $(GIT_HASH)
APP_NAME 			?= $(call get_param, "name")
IMAGE_REPOSITORY	?= $(call get_param, "image.repository")
ifneq (,$(wildcard env/${K8S_NAMESPACE}_app.yaml))
	ENV_SPECIFIC_CONFIG := -f env/${K8S_NAMESPACE}_app.yaml
endif

export APP_NAME
export IMAGE_REPOSITORY
export BUILDKITE_COMMIT

define get_param
$(shell \
docker run --rm \
	-v ${PWD}/app.yaml:/app.yaml \
	quay.io/reevoo/kube-release \
	/bin/sh -c \
	"cat /app.yaml 2> /dev/null | yq read - $(1)" | grep -v null)
endef

.PHONY: up
up:
	docker-compose up -d

.PHONY: down
down:
	docker-compose down -v

.PHONY: test
test: up
	docker-compose exec app .buildkite/test.sh

.PHONY: build
build:
	docker build -t ${IMAGE_REPOSITORY}:${BUILDKITE_COMMIT} .

.PHONY: publish
publish: build
	docker push ${IMAGE_REPOSITORY}:${BUILDKITE_COMMIT}

.PHONY: deploy
deploy:
	docker run --rm \
		-v ~/.kube:/root/.kube \
		-v ${PWD}:/app \
		-w /app \
		quay.io/reevoo/kube-release \
		helm upgrade --install \
			--kube-context=${K8S_CLUSTER} \
			--namespace=${K8S_NAMESPACE} \
			-f app.yaml \
			$(ENV_SPECIFIC_CONFIG) \
			-f konfiguration/${APP_NAME}/${K8S_NAMESPACE}/app.yaml \
			--set image.repository=${IMAGE_REPOSITORY},image.tag=${BUILDKITE_COMMIT} ${APP_NAME}-${K8S_NAMESPACE} \
			konfiguration/charts/reevoo-app

.PHONY: clean
clean: down
