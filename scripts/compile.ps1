$ErrorActionPreference = "Stop"

$VERSION = (Invoke-RestMethod https://api.github.com/repos/ninja-build/ninja/releases/latest).tag_name
$WORKDIR = $PWD

git clone https://github.com/ninja-build/ninja.git --depth=1 --branch=$VERSION *> $null
New-Item -ItemType Directory -Force -Path $WORKDIR\build | Out-Null

Set-Location ninja

& {
  Write-Output $VERSION

  cmake -B build -G Ninja -DCMAKE_BUILD_TYPE=Release `
    -DCMAKE_INSTALL_PREFIX="$WORKDIR\build" `
    -DCMAKE_INSTALL_BINDIR="." `
    -DBUILD_TESTING=OFF
  cmake --build build -j $env:NUMBER_OF_PROCESSORS
  cmake --install build --strip

  Move-Item $WORKDIR\build\ninja.exe $WORKDIR\build\ninja-x86_64-windows-msvc.exe
} 2>&1 | Tee-Object -FilePath $WORKDIR\build\ninja-x86_64-windows-msvc.txt
