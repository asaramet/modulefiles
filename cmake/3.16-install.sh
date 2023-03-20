#!/usr/bin/env bash

version="3.18.3"
base_dir="/opt/bwhpc/common/devel/cmake"
src_dir="${base_dir}/src"
build_dir="${base_dir}/build"
target_dir="${base_dir}/${version}"

[[ ! -d ${src_dir} ]] && mkdir -p ${src_dir}
cd ${src_dir}
wget https://github.com/Kitware/CMake/releases/download/v${version}/cmake-${version}.tar.gz

[[ ! -d ${build_dir} ]] && mkdir -p ${build_dir}
cd ${build_dir} && pwd
tar zxvf "${src_dir}/cmake-${version}.tar.gz"

cd cmake-${version}
./bootstrap --prefix=${target_dir}
make
make install
