FROM golang:1.8-alpine

COPY . /go/src/github.shuttercorp.net/shutterstock/go-links
RUN apk add --no-cache --update git

EXPOSE 8067

ENTRYPOINT /go/bin/go-links

RUN go install github.shuttercorp.net/shutterstock/go-links