#!/bin/bash
set -e
set -x
cd openmvg-docker/openmvg-build
./build.sh
cd ..
cd openmvg-bin/
./build.sh
cd ../..
cd cmvs_pmvs-build
./build.sh
cd ..
cd potree_converter-build
./build.sh
