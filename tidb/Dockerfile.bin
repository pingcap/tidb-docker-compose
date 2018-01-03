from alpine:3.5

ADD bin/tidb-server /tidb-server

RUN chmod +x /tidb-server

WORKDIR /

EXPOSE 4000 10080

ENTRYPOINT ["/tidb-server"]
