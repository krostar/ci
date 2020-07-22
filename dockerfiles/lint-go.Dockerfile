FROM golang:1.14-alpine

SHELL ["/bin/ash", "-eo", "pipefail", "-c"]

RUN apk add --no-cache \
    bash~=5.0 \
    git~=2.26 \
    build-base~=0.5 \
    curl~=7.69

RUN curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b "$(go env GOPATH)/bin" v1.23.8

WORKDIR /app-lint
COPY scripts/common.sh .
COPY scripts/lint* ./

WORKDIR /app
ENTRYPOINT [ "/app-lint/lint.sh", "go" ]
