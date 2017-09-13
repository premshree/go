FROM alpine:3.4

EXPOSE 8067
ENTRYPOINT "/go-links"

COPY go-links /