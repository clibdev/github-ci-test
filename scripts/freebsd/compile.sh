#!/bin/sh
set -eo pipefail

VERSION=$(curl -s https://api.github.com/repos/ninja-build/ninja/releases/latest | grep -oE '"tag_name": "v[0-9.]+"' | grep -oE 'v[0-9.]+')

git clone https://github.com/ninja-build/ninja.git --depth=1 --branch=$VERSION /tmp/ninja
mkdir -p build

WORKDIR=$(pwd)

{
  echo $VERSION

  cd /tmp/ninja && rm -rf build
  cmake -B build -G Ninja -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=build/install \
    -DCMAKE_INSTALL_BINDIR='.' \
    -DBUILD_TESTING=OFF
  cmake --build build -j$(nproc)
  cmake --install build --strip

  cd build/install && tar czf $WORKDIR/build/ninja-x86_64-freebsd.tar.gz ninja
} 2>&1 | tee $WORKDIR/build/ninja-x86_64-freebsd.txt
