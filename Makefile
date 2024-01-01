SHELL=/bin/bash

REGISTRY_NAME?=carvicsforth
VERSION?=1.1.0

.PHONY: all launcher launcher-rvv-0.7.1 console data launcher-push launcher-rvv-0.7.1-push console-push data-push containers containers-push

all: containers

launcher:
	(cd launcher && docker build -t $(REGISTRY_NAME)/qemu-riscv64-launcher:$(VERSION) .)

launcher-rvv-0.7.1:
	(cd launcher-rvv-0.7.1 && docker build -t $(REGISTRY_NAME)/qemu-riscv64-launcher-rvv-0.7.1:$(VERSION) .)

console:
	(cd console && docker build -t $(REGISTRY_NAME)/qemu-riscv64-console:$(VERSION) .)

data:
	(cd data && for i in `ls`; do (cd $$i && make container); done)

launcher-push:
	(cd launcher && docker buildx build --platform linux/amd64,linux/arm64 --push -t $(REGISTRY_NAME)/qemu-riscv64-launcher:$(VERSION) .)

launcher-rvv-0.7.1-push:
	(cd launcher-rvv-0.7.1 && docker buildx build --platform linux/amd64,linux/arm64 --push -t $(REGISTRY_NAME)/qemu-riscv64-launcher-rvv-0.7.1:$(VERSION) .)

console-push:
	(cd console && docker buildx build --platform linux/amd64,linux/arm64 --push -t $(REGISTRY_NAME)/qemu-riscv64-console:$(VERSION) .)

data-push:
	(cd data && for i in `ls`; do (cd $$i && make container-push); done)

containers: launcher launcher-rvv-0.7.1 console #data

containers-push: launcher-push launcher-rvv-0.7.1-push console-push #data-push
