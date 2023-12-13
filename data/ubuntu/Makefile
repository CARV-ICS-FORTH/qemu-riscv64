SHELL=/bin/bash

REGISTRY_NAME?=carvicsforth
VERSION?=22.04-1
IMAGE_NAME=$(REGISTRY_NAME)/qemu-riscv64-ubuntu:$(VERSION)

ARCH=$(shell uname -m)
ifeq ($(ARCH),amd64)
OTHER_ARCH=arm64
else
OTHER_ARCH=amd64
endif

.PHONY: all container multiarch push container-push

all: container

container:
	docker build -t $(IMAGE_NAME) .

multiarch:
	docker tag $(IMAGE_NAME) $(IMAGE_NAME)-$(ARCH)
	mkdir $(OTHER_ARCH)
	docker save $(IMAGE_NAME)-$(ARCH) | tar -xC $(OTHER_ARCH)
	IMAGE_ID=`docker image inspect --format '{{.ID}}' $(IMAGE_NAME)-$(ARCH) | cut -d: -f2`; \
	gsed  -i 's|"architecture":"$(ARCH)"|"architecture":"$(OTHER_ARCH)"|' $(OTHER_ARCH)/$$IMAGE_ID.json
	gsed  -i 's|"$(IMAGE_NAME)-$(ARCH)"|"$(IMAGE_NAME)-$(OTHER_ARCH)"|' $(OTHER_ARCH)/manifest.json
	tar -cC $(OTHER_ARCH) . | docker load
	rm -rf $(OTHER_ARCH)

push:
	docker push $(IMAGE_NAME)-$(ARCH)
	docker push $(IMAGE_NAME)-$(OTHER_ARCH)
	docker image rm $(IMAGE_NAME)
	docker manifest create $(IMAGE_NAME) \
		--amend $(IMAGE_NAME)-$(ARCH) \
		--amend $(IMAGE_NAME)-$(OTHER_ARCH)
	docker manifest push $(IMAGE_NAME)

container-push: container multiarch push
