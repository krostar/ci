FROM golang:1.11-alpine

# hadolint ignore=DL3018
RUN apk add --no-cache bash git

RUN go get github.com/golangci/golangci-lint/cmd/golangci-lint

WORKDIR /app-lint
COPY scripts/common.sh .
COPY scripts/lint* ./

WORKDIR /app
ENTRYPOINT [ "/app-lint/lint.sh", "go" ]
