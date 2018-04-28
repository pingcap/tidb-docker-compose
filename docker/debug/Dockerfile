FROM centos:7

RUN yum update -y && yum install -y \
    curl \
    file \
    gdb \
    git \
    iotop \
    linux-perf \
    mysql \
    net-tools \
    perf \
    perl \
    procps-ng \
    psmisc \
    strace \
    sysstat \
    tree \
    tcpdump \
    unzip \
    vim \
    wget \
    which \
    && yum clean all \
    && rm -rf /var/cache/yum/*

RUN wget -q http://download.pingcap.org/tidb-latest-linux-amd64.tar.gz \
    && tar xzf tidb-latest-linux-amd64.tar.gz \
    && mv tidb-latest-linux-amd64/bin/* /usr/local/bin/ \
    && rm -rf tidb-latest-linux-amd64.tar.gz tidb-latest-linux-amd64

RUN wget https://github.com/brendangregg/FlameGraph/archive/master.zip \
    && unzip master.zip \
    && mv FlameGraph-master /opt/FlameGraph \
    && rm master.zip
ADD run_flamegraph.sh /run_flamegraph.sh

# used for go pprof
ENV GOLANG_VERSION 1.10
ENV GOLANG_DOWNLOAD_URL https://golang.org/dl/go$GOLANG_VERSION.linux-amd64.tar.gz
ENV GOLANG_DOWNLOAD_SHA256 b5a64335f1490277b585832d1f6c7f8c6c11206cba5cd3f771dcb87b98ad1a33
RUN curl -fsSL "$GOLANG_DOWNLOAD_URL" -o golang.tar.gz \
	&& echo "$GOLANG_DOWNLOAD_SHA256  golang.tar.gz" | sha256sum -c - \
	&& tar -C /usr/local -xzf golang.tar.gz \
	&& rm golang.tar.gz
ENV GOPATH /go
ENV GOROOT /usr/local/go
ENV PATH $GOPATH/bin:$GOROOT/bin:$PATH

ENTRYPOINT ["/bin/bash"]
