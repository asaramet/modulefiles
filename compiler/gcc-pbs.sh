#!/usr/bin/env bash

# number of processors to run a job ncpus=nodes*ppn
#PBS -l nodes=1:ppn=32

# wall time (up to 24 hours)
#PBS -l walltime=8:00:00


# name of the job
#PBS -N gcc-install

# set a log file for job's output
#PBS -o output-gcc.log
#PBS -j oe

# send an e-mail when a job begins, aborts or ends
#PBS -m abe
# e-mail address specification
#PBS -M asaramet@hs-esslingen.de

echo "== START =="
date

VERSION="10.1.0"
BASE_DIR="/opt/bwhpc/common/compiler/gnu"
TARGET_DIR="${BASE_DIR}/${VERSION}"
BUILD_DIR="${BASE_DIR}/build"
SRC_DIR="${BASE_DIR}/src"

#[[ ! -d ${SRC_DIR} ]] && mkdir -p ${SRC_DIR}
#cd ${SRC_DIR} && pwd
#wget ftp://ftp.gwdg.de/pub/misc/gcc/releases/gcc-${VERSION}/gcc-${VERSION}.tar.gz
#
#[[ ! -d ${BUILD_DIR} ]] && mkdir -p ${BUILD_DIR}
#cd ${BUILD_DIR} && pwd
#tar zxvf ${SRC_DIR}/gcc-${VERSION}.tar.gz
[[ ! -d ${BUILD_DIR}/temp ]] && rm -rf ${BUILD_DIR}/temp
mkdir ${BUILD_DIR}/temp
cd ${BUILD_DIR}/temp

${BUILD_DIR}/gcc-${VERSION}/configure --prefix=${TARGET_DIR} --enable-ld=yes --enable-gold=yes \
--enable-bootstrap=yes --enable-lto=yes --disable-multilib \
--with-mpc="/opt/bwhpc/common/lib/mpc/1.0.3" \
--with-gmp="/opt/bwhpc/common/lib/gmp/6.1.2" \
--with-mpfr="/opt/bwhpc/common/lib/mpfr/3.1.3" 2>&1 | tee configure.log &&

make -j 16 2>&1 | tee make.log &&
make install 2>&1 | tee make_install.log &&

echo "== END =="
date
