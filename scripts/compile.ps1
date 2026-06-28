$ErrorActionPreference = "Stop"
$WORKDIR = $PWD

$VERSION = (Invoke-RestMethod https://api.github.com/repos/ninja-build/ninja/releases/latest).tag_name

git clone https://github.com/ninja-build/ninja.git --depth=1 --branch=$VERSION
mkdir -Force $WORKDIR\build | Out-Null

$TOOLCHAINS = @(
  @{ Name = 'x86_64-windows-msvc'; Arch = 'x64' }
  @{ Name = 'aarch64-windows-msvc';  Arch = 'ARM64' }
)

foreach ($toolchain in $TOOLCHAINS) {
& {
  echo $VERSION

  cd $WORKDIR\ninja && rm -r -Force build -ea SilentlyContinue
  cmake -B build -A $toolchain.Arch -DCMAKE_BUILD_TYPE=Release `
    -DCMAKE_INSTALL_PREFIX=build\install `
    -DCMAKE_INSTALL_BINDIR='.' `
    -DBUILD_TESTING=OFF
  cmake --build build --config Release -j$env:NUMBER_OF_PROCESSORS
  cmake --install build --config Release --strip

  cd build\install && tar czf $WORKDIR\build\ninja-$($toolchain.Name).tar.gz ninja.exe
} 2>&1 | tee $WORKDIR\build\ninja-$($toolchain.Name).txt
}
