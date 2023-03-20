#!/usr/bin/env bash
module load numlib/python_scipy/1.5.0_numpy-1.19.0_python-3.8.3 # it was install just with python but it should work as the numpy has the same python version
module load compiler/intel/19.1.2
module load mpi/impi/2019.8
module load devel/cmake/3.17.1
module load devel/qt/5.14.2

VERSION="5.9.1"
NAME="ParaView-v${VERSION}"
BASE_DIR="/opt/bwhpc/common/vis/paraview"
TARGET_DIR="${BASE_DIR}/${VERSION}_impi-2019.8-intel-19.1.2-python-3.8.3"
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
-DINSTALL_DOCS=ON -DPARAVIEW_BUILD_EXAMPLES=ON \
-DPARAVIEW_USE_MPI=ON -DPARAVIEW_INSTALL_DEVELOPMENT_FILES=ON -DPARAVIEW_USE_PYTHON=ON 2>&1 | tee -a cmake.log

make -j 80 2>&1 | tee -a make.out
make install 2>&1 | tee -a make_install.out

chmod go=u-w ${TARGET_DIR}/* -R
