FROM golang:1.12-alpine

RUN apk --no-cache add \
    bash~=4.4 \
    upx~=3.95 \
    git~=2.20

WORKDIR /app-build
COPY scripts/common.sh .
COPY scripts/build* ./

WORKDIR /app
ENTRYPOINT [ "/app-build/build.sh" ]
