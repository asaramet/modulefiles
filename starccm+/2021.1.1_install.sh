#!/usr/bin/env bash

module load compiler/intel/19.1
module load mpi/impi/2020

VERSION="16.02.009"
V_LONG="2021.1.1"
BASE_DIR="/opt/bwhpc/es/cae/starccm+"
SRC_DIR="${BASE_DIR}/src"
BUILD_DIR="${BASE_DIR}/build"

[[ ! -d ${BUILD_DIR} ]] && mkdir -p ${BUILD_DIR}
cd ${BUILD_DIR}
tar zxvf "${SRC_DIR}/${V_LONG}/STAR-CCM+${VERSION}_01_linux-x86_64.tar.gz"
cd starccm+_${VERSION}

export _JAVA_OPTIONS="-Xmx2G"
./STAR-CCM+${VERSION}_01_linux-x86_64-2.17_gnu9.2.sh -i console -DINSTALLDIR=$BASE_DIR -DINSTALLFLEX=false -DADDSYSTEMPATH=false -DNODOC=true

cd ${BASE_DIR}/${VERSION}/STAR-CCM+${VERSION}/mpi/intel/2019.8.254/linux-x86_64/
mv intel64 intel64.org
ln -s /opt/intel/compilers_and_libraries_2019/linux/mpi/intel64 intel64

#cd /opt/bwhpc/es/cae/starccm+/${VERSION}/STAR-CCM+${VERSION}/mpi/openmpi/4.0.2-cda-002/linux-x86_64-2.12/
#mv gnu7.1/ gnu7.1.org
#ln -s /opt/bwhpc/common/mpi/openmpi/4.0.5-gnu-10.2 gnu7.1
