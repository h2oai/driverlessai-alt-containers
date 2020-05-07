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
		-t opsh2oai/h2oai-runtime:$(DOCKER_VERSION_TAG) \
		-f ubuntu18.04/Dockerfile.in .
