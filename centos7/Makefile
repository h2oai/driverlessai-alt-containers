#
# Docker image tagging
#
DOCKER_VERSION_TAG ?= "runtime"

#
# Build Centos 7 Docker Image
#
runtime-centos7:
	@echo "+--Building Runtime Docker Image--+"
	docker build \
		-t dai-runtime:$(DOCKER_VERSION_TAG) \
		-f Dockerfile.in .