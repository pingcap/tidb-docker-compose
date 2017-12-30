# Builder image
FROM golang:1.9 AS builder

ENV RUSTUP_VERSION=1.7.0 \
    RUSTUP_ARCH=x86_64-unknown-linux-gnu \
    RUSTUP_HOME=/usr/local/rustup \
    RUST_TOOLCHAIN=nightly-2017-08-09 \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH

RUN apt-get update && apt-get install -y cmake

RUN wget https://static.rust-lang.org/rustup/archive/${RUSTUP_VERSION}/${RUSTUP_ARCH}/rustup-init \
    && chmod +x rustup-init \
    && ./rustup-init -y --no-modify-path --default-toolchain ${RUST_TOOLCHAIN} \
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
