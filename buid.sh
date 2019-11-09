#! /bin/bash

set -ex
set -o pipefail

mkdir -p resources
if [ -z "$RELEASE_TARBALL" ]; then
    if [[ -n $VERSION ]]
    then
        bosh cr --final --force --tarball resources/encryption-provider-config.tgz --version="$VERSION"
    else
        bosh cr --final --force --tarball resources/encryption-provider-config.tgz
    fi
else
  cp "${RELEASE_TARBALL}" resources/encryption-provider-config.tgz
fi

tar -xf resources/encryption-provider-config.tgz release.MF
release_version=$(grep -e "^version: .*$" release.MF | awk '{print $2}')

sed -i.bak 's/ENCRYPTION_PROVIDER_CONFIG_VERSION/'"${release_version}"'/g' tile.yml
rm -f release.MF 

tile build "${VERSION/+/-}"

mv tile.yml.bak tile.yml