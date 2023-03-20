#!/usr/bin/env bash

gnu_version="8.3"
version="6.1.1"
base_dir="/opt/bwhpc/common/lib/scotch"
src_dir="${base_dir}/src"
build_dir="${base_dir}/build"
target_dir="${base_dir}/${version}-gnu-${gnu_version}"

[[ ! -d ${build_dir} ]] && mkdir -p ${build_dir}
cd ${build_dir}
git clone https://gitlab.inria.fr/scotch/scotch.git

cd "${build_dir}/scotch/src"
ln -s Make.inc/Makefile.inc.x86-64_pc_linux2 Makefile.inc

make
make ptscotch

make check
make ptcheck

make prefix=${target_dir} install
mv "${build_dir}/scotch_${version}/doc" ${target_dir} -v

cd "${target_dir}/include"
mkdir openmpi-system
ln -s ${PWD}/ptscotch.h openmpi-system/

chmod a-w ${target_dir} -R

TARGET_DIR="/opt/bwhpc/common/cae/openfoam/scotch_${short_version}-gnu-${gnu_version}"
cd ${TARGET_DIR}
mkdir openmpi-system
mkdir temp && cd temp

ar -x "${target_dir}/lib/libscotch.a"
gcc -shared *.o -o "../libscotch.so"
rm * -v

ar -x "${target_dir}/lib/libscotcherrexit.a"
gcc -shared *.o -o "../libscotcherrexit.so"
rm * -v

ar -x "${target_dir}/lib/libptscotch.a"
gcc -shared *.o -o "../openmpi-system/libptscotch.so"
rm * -v

ar -x "${target_dir}/lib/libptscotcherrexit.a"
gcc -shared *.o -o "../openmpi-system/libptscotcherrexit.so"

cd .. && rm temp -rfv
