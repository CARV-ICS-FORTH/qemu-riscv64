SHELL=/bin/bash

REGISTRY_NAME?=carvicsforth
VERSION?=22.04-1
IMAGE_NAME=$(REGISTRY_NAME)/qemu-riscv64-ubuntu:$(VERSION)

.PHONY: all container container-push

all: container

container:
    docker build -t $(IMAGE_NAME) .

container-push: container
    docker buildx build --platform linux/amd64,linux/arm64 --push -t $(IMAGE_NAME) .
