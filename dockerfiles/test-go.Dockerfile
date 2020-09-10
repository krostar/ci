FROM golang:1.15-buster

WORKDIR /app-test
COPY scripts/common.sh .
COPY scripts/test* .

WORKDIR /app
ENTRYPOINT [ "/app-test/test.sh", "go" ]
