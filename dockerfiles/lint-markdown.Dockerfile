FROM node:13.10-alpine

RUN apk add --no-cache bash~=5.0

RUN npm install -g \
    remark-cli@7.0.1 \
    remark-preset-lint-recommended@3.0.2 \
    remark-lint-sentence-newline@2.0.0 \
    remark-preset-lint-consistent@2.0.3 \
    remark-lint-no-dead-urls@1.0.2

WORKDIR /app-lint
COPY scripts/common.sh .
COPY scripts/lint* ./

WORKDIR /app
ENTRYPOINT [ "/app-lint/lint.sh", "markdown" ]
