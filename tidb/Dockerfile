# Builder image
FROM golang:1.9-alpine AS builder

RUN apk update && apk add --no-cache git make

RUN git clone https://github.com/pingcap/tidb.git /go/src/github.com/pingcap/tidb

WORKDIR /go/src/github.com/pingcap/tidb

RUN make

# Executable image
FROM alpine:3.5

COPY --from=builder /go/src/github.com/pingcap/tidb/bin/tidb-server /tidb-server

WORKDIR /

EXPOSE 4000 10080

ENTRYPOINT ["/tidb-server"]
