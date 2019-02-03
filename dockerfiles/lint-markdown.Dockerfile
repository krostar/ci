FROM node:11.8-alpine

# hadolint ignore=DL3018
RUN apk add --no-cache bash

RUN npm install -g \
    remark-cli@6.0.1 \
    remark-preset-lint-recommended@3.0.2 \
    remark-lint-sentence-newline@2.0.0 \
    remark-preset-lint-consistent@2.0.2 \
    remark-lint-no-dead-urls@0.4.1

WORKDIR /app-lint
COPY scripts/common.sh .
COPY scripts/lint* ./

WORKDIR /app
ENTRYPOINT [ "/app-lint/lint.sh", "markdown" ]
