# hadolint ignore=DL3006
FROM python:3.7.7-alpine

RUN apk add --no-cache bash~=5.0
RUN pip install --no-cache-dir yamllint==1.20.0

WORKDIR /app-lint
COPY scripts/common.sh .
COPY scripts/lint* ./

WORKDIR /app
ENTRYPOINT [ "/app-lint/lint.sh", "yaml" ]
