#!/usr/bin/env bash

module load devel/cmake/3.11.4
module load vis/qt/5.9.7
#module load mpi/impi/2020

VERSION="5.8.0"
NAME="ParaView-v${VERSION}"
BASE_DIR="/opt/bwgrid/vis/paraview"
TARGET_DIR="${BASE_DIR}/${VERSION}"
SRC_DIR="${BASE_DIR}/src"
BUILD_DIR="${SRC_DIR}/build"
[[ ! -d $BUILD_DIR ]] && mkdir -p ${BUILD_DIR}

cd $SRC_DIR && pwd
# get ${NAME}.tar.gz from https://www.paraview.org/download
tar zxvf ${NAME}.tar.gz

cd ${BUILD_DIR}
cmake $SRC_DIR/${NAME} -DCMAKE_INSTALL_PREFIX=${TARGET_DIR} -Wno-dev -DCMAKE_BUILD_TYPE=Release \
-DPARAVIEW_USE_MPI=OFF -DPARAVIEW_INSTALL_DEVELOPMENT_FILES=OFF 2>&1 | tee cmake.log

ccmake $SRC_DIR/${NAME} -DCMAKE_INSTALL_PREFIX=${TARGET_DIR} -Wno-dev -DCMAKE_BUILD_TYPE=Release \
-DPARAVIEW_USE_MPI=OFF -DPARAVIEW_INSTALL_DEVELOPMENT_FILES=OFF

make -j 8 2>&1 | tee -a make.log
make install 2>&1 | tee -a make_install.log
