VERSION="3.4.1"
BASE_DIR="/opt/bwhpc/common/cae/cgns"
TARGET_DIR="${BASE_DIR}/${VERSION}"
SRC_DIR="${BASE_DIR}/src"
BUILD_DIR="${BASE_DIR}/build"

cd ${SRC_DIR}
wget https://github.com/CGNS/CGNS/archive/v${VERSION}.tar.gz
tar zxvf v${VERSION}.tar.gz && rm v${VERSION}.tar.gz

#module load lib/hdf5/1.8-openmpi-2.0-gnu-5.2
module load lib/hdf5/1.12.0-gnu-8.1
module load devel/cmake/3.11.4
#module load lib/hdf5/1.8-gnu-5.2
#module load compiler/gnu/8.1

cd ${BUILD_DIR}
cmake -DCMAKE_INSTALL_PREFIX=${TARGET_DIR} -DCGNS_ENABLE_FORTRAN=ON \
-DCGNS_BUILD_CGNSTOOLS=ON -DCGNS_ENABLE_64BIT=ON \
-DCGNS_ENABLE_HDF5=ON -DHDF5_LIBRARY=${HDF5_LIB_DIR} \
"${SRC_DIR}/CGNS-${VERSION}"


make -j 8

make install
