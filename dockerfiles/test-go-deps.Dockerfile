FROM golang:1.15-alpine

RUN apk add --no-cache bash~=5.0 git~=2.26

WORKDIR /app-test
COPY scripts/common.sh .
COPY scripts/test* ./

WORKDIR /app
ENTRYPOINT [ "/app-test/test.sh", "go-deps" ]
