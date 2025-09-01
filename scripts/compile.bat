@echo off
setlocal

git clone https://github.com/ninja-build/ninja.git --depth=1 --branch=v1.13.1
cd ninja

cmake -B build -G Ninja -DCMAKE_BUILD_TYPE=Release^
    -DBUILD_TESTING=OFF^
    -DCMAKE_INSTALL_BINDIR='.'^
    -DCMAKE_INSTALL_PREFIX=.\build
cmake --build build -j$(nproc)
cmake --install build --strip
