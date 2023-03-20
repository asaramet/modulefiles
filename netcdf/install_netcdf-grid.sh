BASE_DIR="/opt/bwhpc/common/lib/netcdf"
TARGET_DIR="${BASE_DIR}/4.7.3-gnu-8.1"
SRC_DIR="${BASE_DIR}/src"
BUILD_DIR="${BASE_DIR}/build"

[[ ! -d ${BUILD_DIR} ]] && mkdir -p ${BUILD_DIR}

module load lib/hdf5/1.12.0-gnu-8.1
module load devel/cmake/3.11.4

cd ${BUILD_DIR}

# install netcdf C
VERSION="4.7.3"
tar zxvf ${SRC_DIR}/netcdf-c-${VERSION}.tar.gz

[[ ! -d ${BUILD_DIR}/temp ]] && mkdir -p ${BUILD_DIR}/temp
cd ${BUILD_DIR}/temp
#cmake ${BUILD_DIR}/netcdf-c-${VERSION} -DCMAKE_INSTALL_PREFIX=${TARGET_DIR} -DENABLE_DAP=OFF \
cmake ${BUILD_DIR}/netcdf-c-4.7.3 -DCMAKE_INSTALL_PREFIX=${TARGET_DIR} -DENABLE_DAP=OFF \
-DENABLE_EXAMPLES=OFF -DENABLE_TESTS=OFF 
make 2>&1 | tee make.log
make install

# install netcdf fortran
module load lib/netcdf/4.7.3-gnu-8.1

cd ${BUILD_DIR}
VERSION="4.5.2"
tar zxvf ${SRC_DIR}/netcdf-fortran-${VERSION}.tar.gz
cd ${BUILD_DIR}/temp
cmake ${BUILD_DIR}/netcdf-fortran-${VERSION} -DCMAKE_INSTALL_PREFIX=${TARGET_DIR}
make && make install


# install netcdf
VERSION="4.3.1"
tar zxvf ${SRC_DIR}/netcdf-cxx4-${VERSION}.tar.gz
cd ${BUILD_DIR}/temp
#cmake ${BUILD_DIR}/netcdf-cxx4-${VERSION} -DCMAKE_INSTALL_PREFIX=${TARGET_DIR}
cmake ${BUILD_DIR}/netcdf-cxx4-4.3.1 -DCMAKE_INSTALL_PREFIX=${TARGET_DIR}
