#!/usr/bin/env bash

#version="4.14.3"
version="4.10.2"
base_dir="/opt/bwhpc/common/cae/openfoam"
src_dir="${base_dir}/src"
build_dir="${base_dir}/build/CGAL-${version}"
target_dir="${base_dir}/addons/CGAL/${version}"

[[ ! -d ${src_dir} ]] && mkdir -p ${src_dir}
cd ${src_dir}
wget https://github.com/CGAL/cgal/releases/download/releases%2FCGAL-${version}/CGAL-${version}.tar.xz
tar xvf CGAL-${version}.tar.xz

boost_dir="/opt/bwhpc/common/cae/openfoam/addons/boost/1.72.0"

#module load devel/cmake/3.16

[[ ! -d ${build_dir} ]] && mkdir -p ${build_dir}
cd ${build_dir}
ccmake -DCMAKE_INSTALL_PREFIX=${target_dir} -DCGAL_CXX_FLAGS="-I${boost_dir} -L${boost_dir}/lib" ${src_dir}/CGAL-${version}
make
make install
