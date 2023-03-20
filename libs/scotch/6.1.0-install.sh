#!/usr/bin/env bash

module load compiler/gnu/10.2
module load mpi/openmpi/4.0

gnu_version="10.2"
mpi_version="4.0"

short_version="6.1"
version="6.1.0"
base_dir="/opt/bwhpc/common/lib/scotch"
src_dir="${base_dir}/src"
build_dir="${base_dir}/build"
target_dir="${base_dir}/${short_version}-gnu-${gnu_version}-mpi-${mpi_version}"

[[ ! -d ${src_dir} ]] && mkdir -p ${src_dir}

cd ${src_dir}
wget "https://gforge.inria.fr/frs/download.php/file/38352/scotch_${version}.tar.gz"

[[ ! -d ${build_dir} ]] && mkdir -p ${build_dir}
cd ${build_dir}
tar zxvf "${src_dir}/scotch_${version}.tar.gz"

cd "${build_dir}/scotch_${version}/src"
cd src
ln -s Make.inc/Makefile.inc.x86-64_pc_linux2 Makefile.inc

# In Makefile.inc add before CCD:
"MPI_INC         = ${MPI_INC_DIR}"
# change "CCD  = gcc" to:
"CCD             = gcc -I$(MPI_INC)"

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
