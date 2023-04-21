#!/usr/bin/env bash

module load compiler/intel/2022.2.1
module load mpi/impi/2021.7.1

VERSION="17.06.008"
V_LONG="2210"
BASE_DIR="/opt/bwhpc/es/cae/starccm+"
SRC_DIR="${BASE_DIR}/src"
BUILD_DIR="${BASE_DIR}/build"

[[ ! -d ${BUILD_DIR} ]] && mkdir -p ${BUILD_DIR}
cd ${BUILD_DIR}
tar zxvf "${SRC_DIR}/${V_LONG}/STAR-CCM+${VERSION}_01_linux-x86_64.tar.gz"
cd starccm+_${VERSION}

export _JAVA_OPTIONS="-Xmx2G"
./STAR-CCM+${VERSION}_01_linux-x86_64-2.17_gnu9.2.sh -i console -DINSTALLDIR=$BASE_DIR -DINSTALLFLEX=false -DADDSYSTEMPATH=false -DNODOC=true

cd ${BASE_DIR}/${VERSION}/STAR-CCM+${VERSION}/mpi/intel/2021.6/
mv linux-x86_64 linux-x86_64.org
ln -s /software/all/toolkit/Intel_OneAPI/mpi/2021.7.1 linux-x86_64