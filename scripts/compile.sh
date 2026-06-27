#!/bin/bash

VERSION=$(curl -s https://api.github.com/repos/ninja-build/ninja/releases/latest | grep -Po '"tag_name": "\Kv[0-9.]+')

git clone https://github.com/ninja-build/ninja.git --depth=1 --branch=$VERSION /tmp/ninja
mkdir -p /app/build

TOOLCHAINS=(
  'x86_64-linux-gnu'
  'aarch64-linux-gnu'
  'arm-linux-gnueabi'
  'riscv64-linux-gnu'
)

for toolchain in "${TOOLCHAINS[@]}"; do
  export CXX=/opt/$toolchain/bin/$toolchain-g++

  cd /tmp/ninja
  rm -rf build
  cmake -B build -G Ninja -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=build/install \
    -DCMAKE_INSTALL_BINDIR='.' \
    -DCMAKE_EXE_LINKER_FLAGS='-static-libstdc++ -static-libgcc' \
    -DBUILD_TESTING=OFF
  cmake --build build -j$(nproc)
  cmake --install build --strip

  cd build/install && tar czf /app/build/ninja-$toolchain.tar.gz ninja
done
