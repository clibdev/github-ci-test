FROM ubuntu:24.04

WORKDIR /app

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
        curl ca-certificates git make cmake ninja-build re2c \
    && curl -sSLo gcc-x86_64-linux-gnu.tar.gz https://github.com/prepkg/gcc-toolchain/releases/latest/download/gcc-x86_64-linux-gnu.tar.gz \
    && curl -sSLo gcc-aarch64-linux-gnu.tar.gz https://github.com/prepkg/gcc-toolchain/releases/latest/download/gcc-aarch64-linux-gnu.tar.gz \
    && tar xf gcc-x86_64-linux-gnu.tar.gz -C /opt && rm -rf gcc-x86_64-linux-gnu.tar.gz \
    && tar xf gcc-aarch64-linux-gnu.tar.gz -C /opt && rm -rf gcc-aarch64-linux-gnu.tar.gz \
    && apt-get purge --autoremove -y curl \
    && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/bin/bash"]
