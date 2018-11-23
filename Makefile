.PHONY: all
all: build

.PHONY: build
build: Dockerfile
	docker build \
		--build-arg VCS_REF="$(shell git rev-parse HEAD)" \
		--build-arg BUILD_DATE="$(shell date -u +"%Y-%m-%dT%H:%m:%SZ")" \
		--tag android-container:latest .
