#!/usr/bin/env bash

module load devel/cmake/3.18

gnu_version="8.3.1"
version="5.3"
base_dir="/opt/bwhpc/common/lib/cgal"
src_dir="${base_dir}/src"
build_dir="${base_dir}/build"
target_dir="${base_dir}/${version}-gnu-${gnu_version}"

[[ ! -d ${src_dir} ]] && mkdir -p ${src_dir}

cd ${src_dir}
wget "https://github.com/CGAL/cgal/archive/v${version}.tar.gz"

[[ ! -d ${build_dir} ]] && mkdir -p ${build_dir}
cd ${build_dir}
tar zxvf "${src_dir}/v${version}.tar.gz"

mkdir -p "${build_dir}/temp"
cd "${build_dir}/temp"


cmake "${build_dir}/cgal-${version}" -DCMAKE_INSTALL_PREFIX=${target_dir} -DCMAKE_BUILD_TYPE="Release"

make
make install
