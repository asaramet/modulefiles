version="5.1.0"
base_dir="/opt/bwhpc/common/cae/openfoam"
src_dir="${base_dir}/src"
build_dir="${base_dir}/build/metis-${version}"
target_dir="${base_dir}/addons/metis/${version}"

cd ${src_dir}
wget http://glaros.dtc.umn.edu/gkhome/fetch/sw/metis/metis-${version}.tar.gz
tar zxvf metis-${version}.tar.gz && rm metis-${version}.tar.gz

[[ ! -d ${build_dir} ]] && mkdir -p ${build_dir}
cd ${build_dir}
ccmake -DCMAKE_INSTALL_PREFIX=${target_dir} ${src_dir}/metis-${version}

-DCGAL_CXX_FLAGS="-I${boost_dir} -L${boost_dir}/lib"
