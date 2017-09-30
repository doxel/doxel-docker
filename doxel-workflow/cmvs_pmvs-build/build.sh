#!/bin/bash
[ -z "$DEBIAN_MIRROR" ] && DEBIAN_MIRROR=deb.debian.org

docker build \
  --build-arg debian_mirror=$DEBIAN_MIRROR \
  -t cmvs_pmvs-build \
  .
