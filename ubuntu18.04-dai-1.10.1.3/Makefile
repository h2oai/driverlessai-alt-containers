#
# Docker image tagging
#
DOCKER_VERSION_TAG ?= "latest"

#
# Build Ubuntu 18.04 Docker Image
#

all: dai.deb runtime-ubuntu18.04

dai.deb:
	curl -o dai.deb https://s3.amazonaws.com/artifacts.h2o.ai/releases/ai/h2o/dai/rel-1.10.1.3-10/x86_64-centos7/dai_1.10.1.3-1_amd64.deb

runtime-ubuntu18.04:
	@echo "+--Building Runtime Docker Image--+"
	docker build \
		-t dai-runtime:$(DOCKER_VERSION_TAG) \
		-f Dockerfile .
