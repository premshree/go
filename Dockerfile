FROM alpine

ENV GOPATH /go
COPY . /go/src/github.shuttercorp.net/shutterstock/go-links
RUN apk update \
  && apk add go git musl-dev \
  && apk del go git musl-dev \
  && rm -rf /var/cache/apk/* \
  && rm -rf /go/src /go/pkg \
  && mkdir /data

RUN go install https://github.shuttercorp.net/shutterstock/go-links

ENTRYPOINT /go/bin/go-links

EXPOSE 8067