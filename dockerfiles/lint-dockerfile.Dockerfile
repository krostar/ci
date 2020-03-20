FROM hadolint/hadolint:v1.17.5-alpine

RUN apk --no-cache add bash~=5.0

WORKDIR /app-lint
COPY scripts/common.sh .
COPY scripts/lint* ./

WORKDIR /app
ENTRYPOINT [ "/app-lint/lint.sh", "dockerfile" ]
