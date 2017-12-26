# Builder image
FROM golang:1.9-alpine AS builder

RUN apk update && apk add --no-cache git make

RUN git clone https://github.com/pingcap/pd.git /go/src/github.com/pingcap/pd

WORKDIR /go/src/github.com/pingcap/pd

RUN make

# Executable image
FROM alpine:3.5

COPY --from=builder /go/src/github.com/pingcap/tidb/bin/pd-server /pd-server

WORKDIR /

EXPOSE 2379 2380

ENTRYPOINT ["/pd-server"]
