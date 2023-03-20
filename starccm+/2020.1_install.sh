#!/usr/bin/env bash

module load compiler/intel/19.1
module load mpi/impi/2018

VERSION="15.02.009"
V_LONG="2020.1.1"
BASE_DIR="/opt/bwhpc/es/cae/starccm+"
SRC_DIR="${BASE_DIR}/src"
BUILD_DIR="${BASE_DIR}/build"

[[ ! -d ${BUILD_DIR} ]] && mkdir -p ${BUILD_DIR}
cd ${BUILD_DIR}
tar zxvf "${SRC_DIR}/${V_LONG}/STAR-CCM+${VERSION}_01_linux-x86_64.tar.gz"
cd starccm+_${VERSION}

export _JAVA_OPTIONS="-Xmx2G"
./STAR-CCM+${VERSION}_01_linux-x86_64-2.12_gnu7.1.sh -i console -DINSTALLDIR=$BASE_DIR -DINSTALLFLEX=false -DADDSYSTEMPATH=false -DNODOC=true

cd ${BASE_DIR}/${VERSION}/STAR-CCM+${VERSION}/mpi/intel/2018.1.163/linux-x86_64/rto
mv intel64 intel64.org
ln -s /opt/intel/compilers_and_libraries_2019/linux/mpi/intel64 intel64

#cd /opt/bwhpc/es/cae/starccm+/${VERSION}/STAR-CCM+${VERSION}/mpi/openmpi/4.0.1-cda-002/linux-x86_64-2.12
#mv gnu7.1 gnu7.1.org
#ln -s /opt/bwhpc/common/mpi/openmpi/4.0.5-gnu-10.2 gnu7.1
#
#cd /opt/bwhpc/es/cae/starccm+/${VERSION}/STAR-CCM+${VERSION}/mpi/openmpi/3.1.3-cda-006/linux-x86_64-2.12
#mv gnu7.1 gnu7.1.org
#ln -s /opt/bwhpc/common/mpi/openmpi/4.0.5-gnu-10.2 gnu7.1
