@echo off
setlocal

for /f "tokens=2 delims=:," %%i in ('curl -s https://api.github.com/repos/ninja-build/ninja/releases/latest ^| findstr "tag_name"') do set VERSION=%%~i
set VERSION=%VERSION:"=%
echo %VERSION%

set WORKDIR=%CD%

cd %WORKDIR%
git clone https://github.com/ninja-build/ninja.git --depth=1 --branch=v1.13.1
cd ninja

cmake -B build -G Ninja -DCMAKE_BUILD_TYPE=Release^
    -DBUILD_TESTING=OFF^
    -DCMAKE_INSTALL_BINDIR='.'^
    -DCMAKE_INSTALL_PREFIX=%WORKDIR%\build
cmake --build build -j%NUMBER_OF_PROCESSORS%
cmake --install build --strip

move %WORKDIR%\build\ninja.exe %WORKDIR%\build\ninja-x86_64-windows-msvc >nul
