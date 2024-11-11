.PHONY: build push gotest gobuild

CONTAINER_ENGINE ?= $(shell which podman >/dev/null 2>&1 && echo podman || echo docker)

IMAGE_NAME := quay.io/app-sre/signalfx-prometheus-exporter
IMAGE_TAG := $(shell git rev-parse --short=7 HEAD)

ifneq (,$(wildcard $(CURDIR)/.docker))
	DOCKER_CONF := $(CURDIR)/.docker
else
	DOCKER_CONF := $(HOME)/.docker
endif

gotest:
	CGO_ENABLED=0 GOOS=$(shell go env GOOS) go test ./...

gobuild: gotest
	CGO_ENABLED=0 GOOS=$(shell go env GOOS) go build -o signalfx-prometheus-exporter -a -installsuffix cgo main.go

build:
	@DOCKER_BUILDKIT=1 $(CONTAINER_ENGINE) --config=$(DOCKER_CONF) build --no-cache -t $(IMAGE_NAME):latest . --progress=plain
	@$(CONTAINER_ENGINE) tag $(IMAGE_NAME):latest $(IMAGE_NAME):$(IMAGE_TAG)

push:
	@$(CONTAINER_ENGINE) --config=$(DOCKER_CONF) push $(IMAGE_NAME):latest
	@$(CONTAINER_ENGINE) --config=$(DOCKER_CONF) push $(IMAGE_NAME):$(IMAGE_TAG)

.PHONY: container-test
container-test:
	$(CONTAINER_ENGINE) build --target test -t $(IMAGE_NAME):pr-$(IMAGE_TAG) -f Dockerfile .
