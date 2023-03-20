#!/usr/bin/env bash

module load compiler/intel/19.1
module load mpi/impi/2020

icc_version="19.1"
mpi_version="2020"

short_version="6.1"
version="6.1.1"
base_dir="/opt/bwhpc/common/lib/scotch"
src_dir="${base_dir}/src"
build_dir="${base_dir}/build"
target_dir="${base_dir}/${short_version}-icc-${icc_version}-impi-${mpi_version}"

[[ ! -d ${build_dir} ]] && mkdir -p ${build_dir}
cd ${build_dir}
git clone https://gitlab.inria.fr/scotch/scotch.git

cd "${build_dir}/scotch/src"
ln -s Make.inc/Makefile.inc.x86-64_pc_linux2.icc.impi Makefile.inc

make
make ptscotch

make prefix=${target_dir} install
mv "${build_dir}/scotch/doc" ${target_dir} -v

cd "${target_dir}/include"

mkdir mpi-system
ln -s ${PWD}/ptscotch.h mpi-system/

chmod a-w ${target_dir} -R

TARGET_DIR="/opt/bwhpc/common/cae/openfoam/scotch_${short_version}-icc-${icc_version}-impi-${mpi_version}"
[[ ! -d ${TARGET_DIR} ]] && mkdir -p ${TARGET_DIR}
cd ${TARGET_DIR}
mkdir mpi-system
mkdir temp && cd temp

ar -x "${target_dir}/lib/libscotch.a"
gcc -shared *.o -o "../libscotch.so"
rm * -v

ar -x "${target_dir}/lib/libscotcherrexit.a"
gcc -shared *.o -o "../libscotcherrexit.so"
rm * -v

ar -x "${target_dir}/lib/libptscotch.a"
gcc -shared *.o -o "../mpi-system/libptscotch.so"
rm * -v

ar -x "${target_dir}/lib/libptscotcherrexit.a"
gcc -shared *.o -o "../mpi-system/libptscotcherrexit.so"

cd .. && rm temp -rfv
