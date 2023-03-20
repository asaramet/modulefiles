#!/usr/bin/env bash

# number of processors to run a job ncpus=nodes*ppn
#PBS -l nodes=1:ppn=32

# wall time (up to 24 hours)
#PBS -l walltime=12:00:00

# name of the job
#PBS -N install_stuff

# set a log file for job's output
#PBS -o mpi_install.log
#PBS -j oe

# send an e-mail when a job begins, aborts or ends
#PBS -m abe
# e-mail address specification
#PBS -M asaramet@hs-esslingen.de

echo "== START =="
date

BASE_DIR="/opt/bwhpc/common/mpi/openmpi"
SRC_DIR="${BASE_DIR}/install"
BUILD_DIR="${SRC_DIR}/build"
VERSION="4.0.4"
SHORT="4.0"
COMPILER="9"
TARGET_DIR="${BASE_DIR}/${VERSION}-gnu-${COMPILER}"

module load compiler/gnu/${COMPILER}

[[ ! -d ${BUILD_DIR} ]] && mkdir -p ${BUILD_DIR}
cd ${SRC_DIR} && pwd
wget https://download.open-mpi.org/release/open-mpi/v${SHORT}/openmpi-${VERSION}.tar.gz
tar zxvf openmpi-${VERSION}.tar.gz

cd ${BUILD_DIR} && pwd
module list

../openmpi-${VERSION}/configure --prefix=${TARGET_DIR} --with-slurm=no --disable-hwloc-pci 2>&1 | tee configure.log &&
make -j 16 2>&1 | tee make.log &&
make install 2>&1 | tee make_install.log &&

echo "== DONE =="
date
