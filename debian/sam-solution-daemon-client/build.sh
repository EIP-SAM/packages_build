#!/bin/sh

# update package builder informations
export DEBFULLNAME="Nicolas Chauvin"
export EMAIL="chauvin.nico@gmail.com"

pkgname="sam-solution-daemon-client"
pkgver="r96.fed5113.rc2"
_pkgver="0${pkgver}" # debian packages cannot start with a letter
arch="any"
srcpkgname="${pkgname}_${pkgver}_build_${arch}"
buildname="${pkgname}_${_pkgver}"
debname="${pkgname}_${_pkgver}_${arch}"
_sourcebase="https://github.com/EIP-SAM/SAM-Solution-Daemon-Client/releases/download"
source="${_sourcebase}/${pkgver}/${srcpkgname}.tar.gz"
sha256source="${_sourcebase}/${pkgver}/${srcpkgname}.sha256.txt"

echo "Creating debian package build directory..."
mkdir "${buildname}"

echo "Entering debian package build directory..."
cd "${buildname}"

echo "Initializing debian package build directory..."
echo "Tip: choose 'indep'"
dh_make --native -p "${buildname}"

echo "Cleaning debian package config directory..."
cd debian
rm *.ex *.EX
rm README*
rm *.docs
cd ..

echo "Copying needed configuration into debian package..."
cd ..
cp -v control "${buildname}/debian/"
cp -v install "${buildname}/debian/"
cp -v postinst "${buildname}/debian/"
cp -v copyright "${buildname}/debian/"

echo "Setting package maintainer informations"
maintainer_substitute="s|\${maintainer}|${DEBFULLNAME} <${EMAIL}>|g"
sed -i "${maintainer_substitute}" "${buildname}/debian/copyright"
sed -i "${maintainer_substitute}" "${buildname}/debian/control"

echo "Downloading build package archive..."
wget "${source}"
echo "Downloading sha256 checksum file..."
wget "${sha256source}"

echo "Checking source archive checksum..."
cat "${srcpkgname}.sha256.txt" | grep ".tar.gz" > "${srcpkgname}.tar.gz.sha256.txt"
if ! sha256sum -c "${srcpkgname}.tar.gz.sha256.txt"; then
    echo "Checksum comparaison failed for '${srcpkgname}.tar.gz'"
    exit 1
fi

echo "Creating debian package target directories..."
mkdir -p "${buildname}/usr/share/"
mkdir -p "${buildname}/lib/systemd/system/"
mkdir -p "${buildname}/etc/${pkgname}/"

echo "Extracting build package archive..."
tar xvf "${srcpkgname}.tar.gz" -C "${buildname}/usr/share/"

echo "Renaming extracted folder to match package name..."
mv "${buildname}/usr/share/${srcpkgname}" "${buildname}/usr/share/${pkgname}"

echo "Linking configuration file to system configuration directory..."
ln -s "/usr/share/${pkgname}/config/base.config.json" "${buildname}/etc/${pkgname}"

echo "Hiding readability of the configuration file for everyone except root..."
chmod 600 "${buildname}/usr/share/${pkgname}/config/base.config.json"

echo "Copying systemd service configuration file..."
install -Dm644 "${buildname}/usr/share/${pkgname}/system_config/${pkgname}.service" \
	"${buildname}/lib/systemd/system/${pkgname}.service"

echo "Building debian package..."
cd "${buildname}"
dpkg-buildpackage --unsigned-source --unsigned-changes
