FROM golang:1.12-alpine

RUN apk add --no-cache bash~=4.4 git~=2.20

RUN go get github.com/golangci/golangci-lint/cmd/golangci-lint

WORKDIR /app-lint
COPY scripts/common.sh .
COPY scripts/lint* ./

WORKDIR /app
ENTRYPOINT [ "/app-lint/lint.sh", "go" ]
