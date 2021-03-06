#!/bin/bash -l
[ -z "$DEBIAN_MIRROR" ] && DEBIAN_MIRROR=deb.debian.org

if [ -z "$NVM_VERSION" ] ; then
  echo get latest nvm release number ... 
  NVM_VERSION=$(git ls-remote --tags https://github.com/creationix/nvm master v\* | sed -r -n -e 's/.*(v[0-9\.]+)$/\1/p' | sort -V | tail -n 1)
fi
echo using nvm $NVM_VERSION

if [ -z "$NODE_VERSION" ] ; then
  if nvm > /dev/null 2>&1 ; then
    echo get latest node LTS release number
    NODE_VERSION=$(nvm ls-remote | grep LTS | tail -n 1 | sed -r -n -e 's/.*(v[0-9\.]+).*/\1/p')
  else
    NODE_VERSION=v6.11.4
  fi
fi
echo using node $NODE_VERSION
docker build \
  $DOCKER_BUILD_OPTIONS \
  --build-arg debian_mirror=$DEBIAN_MIRROR \
  --build-arg nvm_version=$NVM_VERSION \
  --build-arg node_version=$NODE_VERSION \
  -t doxel-dev \
  .

