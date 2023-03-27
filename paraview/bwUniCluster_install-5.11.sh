#!/usr/bin/env bash

#module load numlib/python_numpy/1.19.1_python_3.8.6_intel_19.1
#module load mpi/impi/2020

module load compiler/intel/2022.2.1
module load mpi/impi/2021.7.1

VERSION="5.11.0"
NAME="ParaView-v${VERSION}"
BASE_DIR="/opt/bwhpc/common/cae/paraview"
TARGET_DIR="${BASE_DIR}/${VERSION}"
SRC_DIR="${BASE_DIR}/src"
BUILD_DIR="${BASE_DIR}/build"
[[ ! -d $TARGET_DIR ]] && mkdir -p $TARGET_DIR
[[ ! -d $SRC_DIR ]] && mkdir -p $SRC_DIR
[[ ! -d $BUILD_DIR ]] && mkdir -p ${BUILD_DIR}

cd $SRC_DIR && pwd
# get ${NAME}.tar.gz from https://www.paraview.org/download

cd ${BUILD_DIR}
tar zxvf ${SRC_DIR}/${NAME}.tar.gz

mkdir tmp
cd tmp
cmake ${BUILD_DIR}/${NAME} -DCMAKE_INSTALL_PREFIX=${TARGET_DIR} -DCMAKE_BUILD_TYPE=Release \
-DPARAVIEW_USE_MPI=ON -DPARAVIEW_INSTALL_DEVELOPMENT_FILES=ON -DPARAVIEW_USE_PYTHON=ON 2>&1 | tee -a cmake.log

make -j 40 2>&1 | tee -a make.out
make install 2>&1 | tee -a make_install.out

chmod go=u-w ${TARGET_DIR}/* -R
