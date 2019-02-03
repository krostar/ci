# hadolint ignore=DL3006
FROM python:3.7.2-alpine3.8

# hadolint ignore=DL3018
RUN apk add --no-cache bash
RUN pip install --no-cache-dir yamllint==1.14.0

WORKDIR /app-lint
COPY scripts/common.sh .
COPY scripts/lint* ./

WORKDIR /app
ENTRYPOINT [ "/app-lint/lint.sh", "yaml" ]
