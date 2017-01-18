#!/bin/bash

pkgname="sam-solution-daemon-client"
_pkgname="SAM-Solution Daemon Client"
pkgver="r96.fed5113.rc2"
arch="any"
publisher="EIP-SAM"
srcpkgname="${pkgname}_${pkgver}_build_${arch}"
setupname="${pkgname}_${_pkgver}_${arch}"
_sourcebase="https://github.com/EIP-SAM/SAM-Solution-Daemon-Client/releases/download"
source="${_sourcebase}/${pkgver}/${srcpkgname}.zip"
sha256source="${_sourcebase}/${pkgver}/${srcpkgname}.sha256.txt"

echo "Downloading build package archive..."
wget "${source}"
echo "Downloading sha256 checksum file..."
wget "${sha256source}"

echo "Checking source archive checksum..."
cat "${srcpkgname}.sha256.txt" | grep ".zip" > "${srcpkgname}.zip.sha256.txt"
if ! sha256sum -c "${srcpkgname}.zip.sha256.txt"; then
    echo "Checksum comparaison failed for '${srcpkgname}.zip'"
    exit 1
fi

echo "Extracting build package archive..."
unzip "${srcpkgname}.zip"

echo "Building setup executable with inno setup..."
iscc="ISCC.exe" # inno setup command-line compiler
current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
current_dir="$(cygpath.exe -w "${current_dir}")"
$iscc "PKGBUILD.iss" "/Dpkgname=${pkgname}" \
      "/D_pkgname=${_pkgname}" \
      "/Dpkgver=${pkgver}" \
      "/Dpublisher=${publisher}" \
      "/Dsource_dir=${current_dir}\\${srcpkgname}" \
      "/Doutput_dir=${current_dir}"
