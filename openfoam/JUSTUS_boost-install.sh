version="1_75_0"
point_version="1.75.0"
base_dir="/opt/bwhpc/common/cae/openfoam"
src_dir="${base_dir}/src"
build_dir="${base_dir}/build"
target_dir="${base_dir}/addons/boost/${point_version}"

cd ${src_dir}
wget https://dl.bintray.com/boostorg/release/${point_version}/source/boost_${version}.tar.gz

cd ${build_dir}
tar xvf ../src/boost_${version}.tar.gz

cd boost_${version}
./bootstrap.sh --prefix=${target_dir}
./b2 --prefix=${target_dir} --stagedir=${target_dir}
./b2 install
