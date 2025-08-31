#!/bin/bash

cd /tmp
git clone https://github.com/ninja-build/ninja.git --depth=1 --branch=v1.13.1
cd ninja

TOOLCHAINS=(
  'x86_64-linux-gnu'
  'aarch64-linux-gnu'
)

for toolchain in "${TOOLCHAINS[@]}"; do
  export CXX=/opt/$toolchain/bin/$toolchain-g++

  rm -rf build
  cmake -B build -G Ninja -DCMAKE_BUILD_TYPE=Release \
      -DBUILD_TESTING=OFF \
      -DCMAKE_EXE_LINKER_FLAGS='-static-libstdc++ -static-libgcc' \
      -DCMAKE_INSTALL_PREFIX=/app/build/$toolchain
  cmake --build build -j$(nproc)
  cmake --install build --strip
done
