@echo off
setlocal

cmake -B build -G Ninja -DCMAKE_BUILD_TYPE=Release \
    -DBUILD_TESTING=OFF \
    -DCMAKE_INSTALL_BINDIR='.' \
    -DCMAKE_INSTALL_PREFIX=/app/build
