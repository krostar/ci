FROM golang:1.12-stretch

WORKDIR /app-test
COPY scripts/common.sh .
COPY scripts/test* .

WORKDIR /app
ENTRYPOINT [ "/app-test/test.sh", "go" ]
