FROM golang:1.11-alpine

RUN apk add --no-cache git~=2.20
RUN go get github.com/schrej/godacov

WORKDIR /app
ENTRYPOINT [ "godacov" ]
