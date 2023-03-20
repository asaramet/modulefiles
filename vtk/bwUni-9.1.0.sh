#!/usr/bin/env bash

module load compiler/gnu/10.2
module load mpi/openmpi/4.0
module load devel/cmake/3.18

VERSION="9.1.0"
SHORT="9.1"
BASE_DIR="/opt/bwhpc/common/vis/vtk"
SRC_DIR="${BASE_DIR}/src"
BUILD_DIR="${BASE_DIR}/build"
TARGET_DIR="${BASE_DIR}/${VERSION}"

[[ ! -d ${SRC_DIR} ]] && mkdir -p ${SRC_DIR}
cd $SRC_DIR
wget https://www.vtk.org/files/release/${SHORT}/VTK-${VERSION}.tar.gz
tar zxvf VTK-${VERSION}.tar.gz && rm VTK-${VERSION}.tar.gz

[[ ! -d ${BUILD_DIR} ]] && mkdir -p ${BUILD_DIR}
cd ${BUILD_DIR}
cmake -DCMAKE_INSTALL_PREFIX=${TARGET_DIR} -DVTK_USE_MPI=ON "${SRC_DIR}/VTK-${VERSION}"
make -j 8
make install
