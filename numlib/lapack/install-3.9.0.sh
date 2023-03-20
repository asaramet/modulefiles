#!/usr/bin/env bash

VERSION="3.9.0"
BASE_DIR="/opt/bwhpc/common/numlib/lapack"
TARGET_DIR="${BASE_DIR}/${VERSION}"
SRC_DIR="${BASE_DIR}/src"
BUILD_DIR="${SRC_DIR}/build"

[[ ! -d ${BUILD_DIR} ]] && mkdir -p ${BUILD_DIR}

cd ${SRC_DIR} && pwd
wget https://github.com/Reference-LAPACK/lapack/archive/v${VERSION}.tar.gz
tar zxvf v${VERSION}.tar.gz

cd $BUILD_DIR && pwd

cmake $SRC_DIR/lapack-${VERSION} -DCMAKE_INSTALL_PREFIX=${TARGET_DIR} 
