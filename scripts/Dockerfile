FROM ubuntu:26.04

WORKDIR /app

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
        curl ca-certificates git make cmake ninja-build re2c \
    && curl -sSL https://github.com/prepkg/gcc-toolchain/releases/latest/download/gcc-x86_64-linux-gnu.tar.gz | tar xz -C /opt \
    && curl -sSL https://github.com/prepkg/gcc-toolchain/releases/latest/download/gcc-aarch64-linux-gnu.tar.gz | tar xz -C /opt \
    && curl -sSL https://github.com/prepkg/gcc-toolchain/releases/latest/download/gcc-arm-linux-gnueabi.tar.gz | tar xz -C /opt \
    && curl -sSL https://github.com/prepkg/gcc-toolchain/releases/latest/download/gcc-riscv64-linux-gnu.tar.gz | tar xz -C /opt \
    && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/bin/bash"]
