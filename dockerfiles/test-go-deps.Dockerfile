FROM golang:1.11-alpine

# hadolint ignore=DL3018
RUN apk add --no-cache bash git

WORKDIR /app-test
COPY scripts/common.sh .
COPY scripts/test* ./

WORKDIR /app
ENTRYPOINT [ "/app-test/test.sh", "go-deps" ]
