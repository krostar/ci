FROM koalaman/shellcheck-alpine:v0.6.0

RUN apk add --no-cache bash~=4.4

WORKDIR /app-lint
COPY scripts/common.sh .
COPY scripts/lint* ./

WORKDIR /app
ENTRYPOINT [ "/app-lint/lint.sh", "sh" ]
