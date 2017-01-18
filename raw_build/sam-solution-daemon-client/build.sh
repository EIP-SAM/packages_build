#!/bin/sh

pkgname="sam-solution-daemon-client"
gitname="SAM-Solution-Daemon-Client"
gitbranch="develop"
pkgver="r42.101010.rc1"
arch="any"

echo "Cloning git repository..."
git clone https://github.com/EIP-SAM/${gitname}

echo "Retrieving last repository tag as package version..."
cd ${gitname}
pkgver=`git tag -l --sort=refname "*.*.*" | tail -n 1`
echo "Checking out last repository tag's revision..."
git checkout "tags/${pkgver}"
cd -

echo "Renaming repository to match package name..."
pkgfullname="${pkgname}_${pkgver}_build_${arch}"
mv -v ${gitname} ${pkgfullname}

echo "Installing npm dependencies..."
cd ${pkgfullname}
if ! npm install --production; then
    echo "Package build aborted!"
    exit 1
fi

echo "Generating default config file from example..."
for f in config/*config.json.example; do
    cp -v "$f" "`echo $f | sed s/json.example/json/`"
done

echo "Removing git meta data..."
rm -rf .git
cd -

echo "Removing references to build folder..."
sed_substitute="s|`pwd`|/usr/share|g"
find ${pkgfullname}/ -type f -exec sed -i "$sed_substitute" {} +

echo "Creating gzip tarball..."
tar czf ${pkgfullname}.tar.gz ${pkgfullname}

echo "Creating zip archive..."
zip -r ${pkgfullname}.zip ${pkgfullname}

echo "Creating sha256 hash files..."
sha256sum ${pkgfullname}.tar.gz ${pkgfullname}.zip > ${pkgfullname}.sha256.txt

exit 0
