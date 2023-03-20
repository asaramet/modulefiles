#!/usr/bin/env bash

module load compiler/gnu/9.2
module load mpi/impi/2018

VERSION=14.04.013
BASE_DIR="/opt/bwhpc/es/cae/starccm+"
SRC_DIR="${BASE_DIR}/src"
BUILD_DIR="${BASE_DIR}/build"

[[ ! -d ${BUILD_DIR} ]] && mkdir -p ${BUILD_DIR}
cd ${BUILD_DIR}
tar zxvf ${SRC_DIR}/STAR-CCM+${VERSION}_01_linux-x86_64.tar.gz
cd starccm+_${VERSION}

export _JAVA_OPTIONS="-Xmx2G"
./STAR-CCM+${VERSION}_01_linux-x86_64-2.12_gnu7.1.sh -i console -DINSTALLDIR=$BASE_DIR -DINSTALLFLEX=false -DADDSYSTEMPATH=false -DNODOC=true

cd ${BASE_DIR}/${VERSION}/STAR-CCM+${VERSION}/mpi/intel/2018.1.163/linux-x86_64/rto
mv intel64 intel64.org
ln -s /opt/intel/compilers_and_libraries_2019/linux/mpi/intel64 intel64
