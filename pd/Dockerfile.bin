FROM alpine:3.5

ADD bin/pd-server /pd-server

WORKDIR /

EXPOSE 2379 2380

ENTRYPOINT ["/pd-server"]
