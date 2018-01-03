FROM pingcap/alpine-glibc

ADD bin/tikv-server /tikv-server

RUN chmod +x /tikv-server

WORKDIR /

EXPOSE 20160

ENTRYPOINT ["/tikv-server"]
