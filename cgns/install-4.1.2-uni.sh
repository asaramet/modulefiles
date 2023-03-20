VERSION="4.1.2"
BASE_DIR="/opt/bwhpc/common/cae/cgns"
PILER="gnu-8.3"
TARGET_DIR="${BASE_DIR}/${VERSION}-${PILER}"
SRC_DIR="${BASE_DIR}/src"
BUILD_DIR="${BASE_DIR}/build"

cd ${SRC_DIR}
wget https://github.com/CGNS/CGNS/archive/v${VERSION}.tar.gz
tar zxvf v${VERSION}.tar.gz && rm v${VERSION}.tar.gz

#module load lib/hdf5/1.12.0-intel-19.1
module load lib/hdf5/1.12.0-gnu-8.3

cd ${BUILD_DIR}
cmake -DCMAKE_INSTALL_PREFIX=${TARGET_DIR} -DCGNS_ENABLE_FORTRAN=ON \
-DCGNS_BUILD_CGNSTOOLS=ON -DCGNS_ENABLE_64BIT=ON \
-DCGNS_ENABLE_HDF5=ON -DHDF5_LIBRARY=${HDF5_LIB_DIR} \
-DCGNS_ENABLE_BASE_SCOPE=ON -DCGNS_BUILD_TESTING=ON -DCGNS_ENABLE_MEM_DEBUG=ON \
-DCGNS_ENABLE_SCOPING=ON \
"${SRC_DIR}/CGNS-${VERSION}" -Wno-dev

make -j 8

make install
