FROM golang:1.12-alpine

RUN apk add --no-cache bash~=4.4 git~=2.20

WORKDIR /app-test
COPY scripts/common.sh .
COPY scripts/test* ./

WORKDIR /app
ENTRYPOINT [ "/app-test/test.sh", "go-deps" ]
