VERSION="1.8.14"
VER="1.8"
BASE_DIR="/opt/bwhpc/common/lib/hdf5"
TARGET_DIR="${BASE_DIR}/${VERSION}-gnu-8.1"
SRC_DIR="${BASE_DIR}/src"
BUILD_DIR="${BASE_DIR}/build"

cd ${SRC_DIR}
wget https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-${VER}/hdf5-${VERSION}/src/hdf5-${VERSION}.tar.gz
tar zxvf hdf5-${VERSION}.tar.gz && rm hdf5-${VERSION}.tar.gz

module load compiler/gnu/8.1
#module load devel/cmake/3.11.4

cd ${BUILD_DIR}
cmake -DCMAKE_INSTALL_PREFIX=${TARGET_DIR} -DCMAKE_BUILD_TYPE=Release \
-DBUILD_SHARED_LIBS=ON -DBUILD_STATIC_EXEC=ON -DHDF5_BUILD_CPP_LIB=ON \
-DHDF5_BUILD_FORTRAN=ON -DHDF5_BUILD_TOOLS=ON -DHDF5_BUILD_HL_LIB=ON \
"${SRC_DIR}/hdf5-${VERSION}"

#-DCGNS_ENABLE_HDF5=ON -DHDF5_LIBRARY=${HDF5_LIB_DIR}

make -j 8

make install
