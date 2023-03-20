#!/usr/bin/env bash

module load compiler/gnu/10.2
gnu_version="10.2.0"

#version="4.14.3"
version="4.12.2"
base_dir="/opt/bwhpc/common/cae/openfoam"
src_dir="${base_dir}/src"
build_dir="${base_dir}/build"
target_dir="${base_dir}/addons/CGAL/${version}"

[[ ! -d ${src_dir} ]] && mkdir -p ${src_dir}
cd ${src_dir}
wget https://github.com/CGAL/cgal/releases/download/releases%2FCGAL-${version}/CGAL-${version}.tar.xz

[[ ! -d ${build_dir} ]] && mkdir -p ${build_dir}
cd ${build_dir}
tar xvf ${src_dir}/CGAL-${version}.tar.xz

boost_dir="/opt/bwhpc/common/cae/openfoam/addons/boost/1.75.0"

#module load devel/cmake/3.16

compile_dir="${build_dir}/${version}"
[[ ! -d ${compile_dir} ]] && mkdir -p ${compile_dir}
cd ${compile_dir}

cmake "${build_dir}/CGAL-${version}" -DCMAKE_INSTALL_PREFIX=${target_dir} \
-DGMP_INCLUDE_DIR="/opt/bwhpc/common/compiler/gnu/${gnu_version}/include" \
-DGMP_LIBRARIES="/opt/bwhpc/common/compiler/gnu/${gnu_version}/lib64/libgmp.so" \
-DMPFR_INCLUDE_DIR="/opt/bwhpc/common/compiler/gnu/${gnu_version}/include" \
-DMPFR_LIBRARIES="/opt/bwhpc/common/compiler/gnu/${gnu_version}/lib64/libmpfr.so" \
-DCMAKE_BUILD_TYPE="Release" -DCGAL_HEADER_ONLY=OFF

make
make install
