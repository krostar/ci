FROM golang:1.12-alpine

RUN apk --no-cache add \
    bash~=5.0 \
    upx~=3.95 \
    git~=2.22 \
    build-base~=0.5

WORKDIR /app-build
COPY scripts/common.sh .
COPY scripts/build* ./

WORKDIR /app
ENTRYPOINT [ "/app-build/build.sh" ]
