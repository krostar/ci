DIR_ROOT        := $(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST)))))
DIR_DOCKERFILES := $(DIR_ROOT)/dockerfiles
VERSION         := $(shell git describe --tags --always --dirty="-dev")

# use this rule as the default make rule
.DEFAULT_GOAL := help
.PHONY: help
help:
	@echo "Available targets descriptions:"
	@# absolutely awesome -> http://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
	@grep -E '^[%a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: lint-all lint-dockerfile lint-sh lint-yaml
lint-all: lint-dockerfile lint-sh lint-yaml ## Run all possible linters
lint-dockerfile: docker-lint-dockerfile		## Lint dockerfiles
lint-sh: docker-lint-sh						## Lint shell files
lint-yaml: docker-lint-yaml					## Lint yaml files

.PHONY: docker-build-all
docker-build-all: docker-build-lint-dockerfile docker-build-lint-go docker-build-lint-markdown docker-build-lint-sh docker-build-lint-yaml docker-build-publish-go-cover docker-build-test-go-deps docker-build-test-go ## Build all containers

.PHONY: docker-build-%
docker-build-%:
	@docker build \
		--tag "ci:${*}.$(VERSION)" \
		--file "$(DIR_DOCKERFILES)/$(*).Dockerfile" \
		.

.PHONY: docker-%
docker-%: docker-build-%
	@docker run \
		--rm \
		--tty \
		--mount type=bind,source="$(DIR_ROOT)",target=/app,readonly \
		$(DOCKER_RUN_OPTS) \
		"ci:${*}.$(VERSION)" \
		$(DOCKER_RUN_ARGS)

docker-push-all: docker-push-lint-dockerfile docker-push-lint-go docker-push-lint-markdown docker-push-lint-sh docker-push-lint-yaml docker-push-publish-go-cover docker-push-test-go-deps docker-push-test-go
docker-push-%:
	@echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
	docker push krostar/ci:${*}.$(VERSION)
