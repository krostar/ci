FROM koalaman/shellcheck-alpine:v0.7.0

RUN apk add --no-cache bash~=5.0

WORKDIR /app-lint
COPY scripts/common.sh .
COPY scripts/lint* ./

WORKDIR /app
ENTRYPOINT [ "/app-lint/lint.sh", "sh" ]
