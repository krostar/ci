FROM golang:1.11-alpine

# hadolint ignore=DL3018
RUN apk add --no-cache git
RUN go get github.com/schrej/godacov

WORKDIR /app
ENTRYPOINT [ "godacov" ]
