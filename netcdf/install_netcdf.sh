VERSION="4.7.3"
F_VERSION="4.5.2"
CXX_VERSION="4.3.1"
BASE_DIR="/opt/bwhpc/common/lib/netcdf"
TARGET_DIR="${BASE_DIR}/${VERSION}-intel-19.1"
SRC_DIR="${BASE_DIR}/src"
BUILD_DIR="${SRC_DIR}/build"

[[ ! -d ${BUILD_DIR} ]] && mkdir -p ${BUILD_DIR}

module load lib/hdf5/1.12.0-intel-19.1
module load devel/cmake/3.16

cd ${SRC_DIR} && pwd
wget ftp://ftp.unidata.ucar.edu/pub/netcdf/netcdf-c-${VERSION}.tar.gz
wget ftp://ftp.unidata.ucar.edu/pub/netcdf/netcdf-fortran-${F_VERSION}.tar.gz
wget ftp://ftp.unidata.ucar.edu/pub/netcdf/netcdf-cxx4-${CXX_VERSION}.tar.gz

cd ${BUILD_DIR}

# install netcdf C
tar zxvf ${SRC_DIR}/netcdf-c-${VERSION}.tar.gz

cmake ${BUILD_DIR}/netcdf-c-${VERSION} -DCMAKE_INSTALL_PREFIX=${TARGET_DIR} -DENABLE_DAP=OFF \
-DENABLE_EXAMPLES=OFF -DENABLE_TESTS=OFF
make 2>&1 | tee make.log
make install

# install netcdf fortran
module load lib/netcdf/${VERSION}-intel-19.1

cd ${BUILD_DIR}
tar zxvf ${SRC_DIR}/netcdf-fortran-${F_VERSION}.tar.gz
cmake ${BUILD_DIR}/netcdf-fortran-${F_VERSION} -DCMAKE_INSTALL_PREFIX=${TARGET_DIR}
make && make install


# install netcdf
tar zxvf ${SRC_DIR}/netcdf-cxx4-${CXX_VERSION}.tar.gz
cmake ${BUILD_DIR}/netcdf-cxx4-${CXX_VERSION} -DCMAKE_INSTALL_PREFIX=${TARGET_DIR}

cd ${TARGET_DIR}
chmod -R go=u-w *
