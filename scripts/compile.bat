@echo off
setlocal

for /f "tokens=2 delims=:, " %%i in ('curl -s https://api.github.com/repos/ninja-build/ninja/releases/latest ^| findstr "tag_name"') do set VERSION=%%~i
set VERSION=%VERSION:"=%

set WORKDIR=%CD%

git clone https://github.com/ninja-build/ninja.git --depth=1 --branch=%VERSION%
cd ninja

cmake -B build -G Ninja -DCMAKE_BUILD_TYPE=Release^
    -DCMAKE_INSTALL_PREFIX=%WORKDIR%\build^
    -DCMAKE_INSTALL_BINDIR='.'^
    -DBUILD_TESTING=OFF
cmake --build build -j%NUMBER_OF_PROCESSORS%
cmake --install build --strip

move %WORKDIR%\build\ninja.exe %WORKDIR%\build\ninja-x86_64-windows-msvc >nul
