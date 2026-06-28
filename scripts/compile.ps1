$ErrorActionPreference = "Stop"
$WORKDIR = $PWD

$VERSION = (Invoke-RestMethod https://api.github.com/repos/ninja-build/ninja/releases/latest).tag_name

git clone https://github.com/ninja-build/ninja.git --depth=1 --branch=$VERSION
mkdir -Force $WORKDIR\build | Out-Null

$TOOLCHAINS=@(
  @('x86_64-windows-msvc', "$($args[0])\vcvars64.bat")
  @('aarch64-windows-msvc', "$($args[0])\vcvarsamd64_arm64.bat")
)

foreach ($toolchain in $TOOLCHAINS) {
& {
  echo $VERSION
  cmd /c "`"$($toolchain[1])`" && set" | % { if ($_ -match '([^=]+)=(.*)') { si "env:$($Matches[1])" $Matches[2] } }

  cd $WORKDIR\ninja && rm -r -Force build -ea SilentlyContinue
  cmake -B build -G Ninja -DCMAKE_BUILD_TYPE=Release `
    -DCMAKE_INSTALL_PREFIX=build\install `
    -DCMAKE_INSTALL_BINDIR='.' `
    -DBUILD_TESTING=OFF
  cmake --build build -j $env:NUMBER_OF_PROCESSORS
  cmake --install build --strip

  cd build\install && tar czf $WORKDIR\build\ninja-$($toolchain[0]).tar.gz ninja.exe
} 2>&1 | tee $WORKDIR\build\ninja-$($toolchain[0]).txt
}
