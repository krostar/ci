FROM koalaman/shellcheck-alpine:v0.6.0

# hadolint ignore=DL3018
RUN apk add --no-cache bash

WORKDIR /app-lint
COPY scripts/common.sh .
COPY scripts/lint* ./

WORKDIR /app
ENTRYPOINT [ "/app-lint/lint.sh", "sh" ]
