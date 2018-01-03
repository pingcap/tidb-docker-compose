# Builder image
FROM golang:1.9 AS builder

ENV RUSTUP_ARCH=x86_64-unknown-linux-gnu \
    RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH

RUN apt-get update && apt-get install -y cmake

ARG rustup_version=1.7.0
ARG rust_toolchain=nightly-2017-08-09

RUN wget https://static.rust-lang.org/rustup/archive/${rustup_version}/${RUSTUP_ARCH}/rustup-init \
    && chmod +x rustup-init \
    && ./rustup-init -y --no-modify-path --default-toolchain ${rust_toolchain} \
    && chmod -R a+w $RUSTUP_HOME $CARGO_HOME

ARG repo="https://github.com/pingcap/tikv.git"

RUN git clone ${repo} /tikv

WORKDIR /tikv

ARG branch=master

RUN git checkout ${branch} && make

# Executable image
FROM pingcap/alpine-glibc

COPY --from=builder /tikv/bin/tikv-server /tikv-server

EXPOSE 20160

ENTRYPOINT ["/tikv-server"]
