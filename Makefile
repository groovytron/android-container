BUILD_NAME=android
COMPOSE_BUILD_NAME=android-container
VERSIONS=29 28 27 26 25
LATEST=$(firstword $(VERSIONS))
ALL=$(addprefix $(BUILD_NAME),$(VERSIONS))
VCS_REF="$(shell git rev-parse HEAD)"
BUILD_DATE="$(shell date -u +"%Y-%m-%dT%H:%m:%SZ")"
DOCKERHUB_USER=groovytron

.PHONY: all
all: $(ALL)

.PHONY: $(ALL)
$(ALL):
	BUILD_DATE=$(BUILD_DATE) \
	BUILD_NAME=$(BUILD_NAME) \
	COMPOSE_BUILD_NAME=$(COMPOSE_BUILD_NAME) \
	VCS_REF=$(VCS_REF) \
	docker-compose -f build.yaml build \
		$@

.PHONY:clean
clean:
	for VERSION in $(VERSIONS); do \
		docker image rm -f $(COMPOSE_BUILD_NAME):$$VERSION; \
	done

.PHONY:publish-docker-images
publish-docker-images:
	for VERSION in $(VERSIONS); do \
		docker tag $(COMPOSE_BUILD_NAME):$$VERSION $(DOCKERHUB_USER)/$(BUILD_NAME):$$VERSION && \
		docker push $(DOCKERHUB_USER)/$(BUILD_NAME):$$VERSION; \
	done && \
	docker tag $(COMPOSE_BUILD_NAME):$(LATEST) $(DOCKERHUB_USER)/$(BUILD_NAME):latest && \
	docker push $(DOCKERHUB_USER)/$(BUILD_NAME):latest

.PHONY: run
run: build
	docker run \
		-it \
		--entrypoint /bin/bash \
		--name $(CONTAINER_NAME) \
		--user=dev \
		$(BUILD_NAME)

.PHONY:jumpin
jumpin:
	docker exec \
		-it \
		--user=dev \
		$(CONTAINER_NAME) \
		/bin/bash

.PHONY:rootin
rootin:
	docker exec \
		-it \
		--user=root \
		$(CONTAINER_NAME) \
		/bin/bash
