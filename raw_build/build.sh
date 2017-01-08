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
git checkout ${gitbranch}
pkgver=`git tag -l --sort=refname "*.*.*" | head -n 1`
cd -

echo "Renaming repository to match package name..."
pkgfullname="${pkgname}_${pkgver}_build_${arch}"
mv ${gitname} ${pkgfullname}

echo "Installing npm dependencies..."
cd ${pkgfullname}
if ! npm install; then
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

exit 0
