FROM golang:1.15-alpine

RUN apk add --no-cache git~=2.26
RUN go get github.com/schrej/godacov

WORKDIR /app
ENTRYPOINT [ "godacov" ]
