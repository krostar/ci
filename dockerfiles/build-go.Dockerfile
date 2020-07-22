FROM golang:1.14-alpine

RUN apk --no-cache add \
    bash~=5.0 \
    upx~=3.96 \
    git~=2.26 \
    build-base~=0.5

WORKDIR /app-build
COPY scripts/common.sh .
COPY scripts/build* ./

WORKDIR /app
ENTRYPOINT [ "/app-build/build.sh" ]
