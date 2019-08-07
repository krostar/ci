FROM golang:1.12-alpine

RUN apk add --no-cache bash~=5.0 git~=2.22

RUN go get github.com/golangci/golangci-lint/cmd/golangci-lint

WORKDIR /app-lint
COPY scripts/common.sh .
COPY scripts/lint* ./

WORKDIR /app
ENTRYPOINT [ "/app-lint/lint.sh", "go" ]
