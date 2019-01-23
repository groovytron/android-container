BUILD_NAME=android-container:latest
CONTAINER_NAME=my-android-container

.PHONY: all
all: build

.PHONY: build
build: Dockerfile
	docker build \
		--build-arg VCS_REF="$(shell git rev-parse HEAD)" \
		--build-arg BUILD_DATE="$(shell date -u +"%Y-%m-%dT%H:%m:%SZ")" \
		--tag $(BUILD_NAME) .

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
