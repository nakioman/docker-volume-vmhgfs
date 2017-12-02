FROM golang:1.9-alpine as builder
COPY . /go/src/github.com/vieux/docker-volume-vmhgfs
WORKDIR /go/src/github.com/vieux/docker-volume-vmhgfs
RUN set -ex \
    && apk add --no-cache --virtual .build-deps \
    gcc libc-dev \
    && go install --ldflags '-extldflags "-static"' \
    && apk del .build-deps
CMD ["/go/bin/docker-volume-vmhgfs"]

FROM alpine
RUN apk update && apk add open-vm-tools
RUN mkdir -p /run/docker/plugins /mnt/state /mnt/volumes
COPY --from=builder /go/bin/docker-volume-vmhgfs .
CMD ["docker-volume-vmhgfs"]
