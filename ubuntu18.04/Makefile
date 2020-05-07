#
# Docker image tagging
#
DOCKER_VERSION_TAG ?= "latest"

#
# JDK URL you have to define this yourself!
#
JDK_URL ?= ""

#
# Build Ubunut 18.04 Docker Image
#
runtime-ubuntu18.04:
	@echo "+--Building Runtime Docker Image--+"
	docker build \
		--build-arg JDK_URL=$(JDK_URL) \
		-t dai-runtime:$(DOCKER_VERSION_TAG) \
		-f Dockerfile.in .
