
#!/usr/bin/env bash

module load compiler/gnu/10.2
module load devel/cmake/3.18

gnu_version="10.2.0"
version="5.1.0"
base_dir="/opt/bwhpc/common/lib/metis"
src_dir="${base_dir}/src"
build_dir="${base_dir}/build"
target_dir="${base_dir}/${version}-gnu-${gnu_version}"

[[ ! -d ${src_dir} ]] && mkdir -p ${src_dir}

cd ${src_dir}
wget "http://glaros.dtc.umn.edu/gkhome/fetch/sw/metis/metis-${version}.tar.gz"

[[ ! -d ${build_dir} ]] && mkdir -p ${build_dir}
cd ${build_dir}
tar zxvf "${src_dir}/metis-${version}.tar.gz"

mkdir -p "${build_dir}/temp"
cd "${build_dir}/temp"

export CC=$(which gcc)
export CXX=$(which g++)

ccmake "${build_dir}/metis-${version}" -DCMAKE_INSTALL_PREFIX=${target_dir} \
-DCMAKE_BUILD_TYPE="Release"


-DGMP_INCLUDE_DIR="/opt/bwhpc/common/compiler/gnu/${gnu_version}/include" \
-DGMP_LIBRARIES="/opt/bwhpc/common/compiler/gnu/${gnu_version}/lib64/libgmp.so" \
-DGMPXX_INCLUDE_DIR="/opt/bwhpc/common/compiler/gnu/${gnu_version}/include" \
-DGMPXX_LIBRARIES="/opt/bwhpc/common/compiler/gnu/${gnu_version}/lib64/libgmpxx.so" \
-DMPFR_INCLUDE_DIR="/opt/bwhpc/common/compiler/gnu/${gnu_version}/include" \
-DMPFR_LIBRARIES="/opt/bwhpc/common/compiler/gnu/${gnu_version}/lib64/libmpfr.so" \

make install
