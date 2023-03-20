VERSION="4.7.4"
F_VERSION="4.5.3"
CXX_VERSION="4.3.1"
BASE_DIR="/opt/bwhpc/common/lib/netcdf"
TARGET_DIR="${BASE_DIR}/${VERSION}-gnu-8.3"
SRC_DIR="${BASE_DIR}/src"
BUILD_DIR="${BASE_DIR}/build"

[[ ! -d ${BUILD_DIR} ]] && mkdir -p ${BUILD_DIR}

module load lib/hdf5/1.12.0-gnu-8.3
#module load devel/cmake/3.18

cd ${SRC_DIR} && pwd
wget ftp://ftp.unidata.ucar.edu/pub/netcdf/netcdf-c-${VERSION}.tar.gz
wget ftp://ftp.unidata.ucar.edu/pub/netcdf/netcdf-fortran-${F_VERSION}.tar.gz
wget ftp://ftp.unidata.ucar.edu/pub/netcdf/netcdf-cxx4-${CXX_VERSION}.tar.gz

# install netcdf C
cd ${BUILD_DIR}
tar zxvf ${SRC_DIR}/netcdf-c-${VERSION}.tar.gz
cd netcdf-c-${VERSION}
CPPFLAGS="-I${HDF5_INC_DIR}" LDFLAGS="-L${HDF5_LIB_DIR}" ./configure --prefix=${TARGET_DIR}
make check
make install

# install netcdf cxx
cd ${BUILD_DIR}
tar zxvf ${SRC_DIR}/netcdf-cxx4-${CXX_VERSION}.tar.gz
cd netcdf-cxx4-${CXX_VERSION}
CPPFLAGS="-I${HDF5_INC_DIR} -I${TARGET_DIR}/include" LDFLAGS="-L${HDF5_LIB_DIR} -L${TARGET_DIR}/lib" ./configure --prefix=${TARGET_DIR} --disable-filter-testing
make check
make install

# install netcdf fortran
cd ${BUILD_DIR}
tar zxvf ${SRC_DIR}/netcdf-fortran-${F_VERSION}.tar.gz
cd netcdf-fortran-${F_VERSION}
CPPFLAGS="-I${HDF5_INC_DIR} -I${TARGET_DIR}/include" LDFLAGS="-L${HDF5_LIB_DIR} -L${TARGET_DIR}/lib" ./configure --prefix=${TARGET_DIR} --disable-largefile
make check
make install

# share globally
cd ${TARGET_DIR}
chmod -R go=u-w *



cd ${SRC_DIR}
tar zxvf netcdf-fortran-${F_VERSION}.tar.gz
cd ${BUILD_DIR}
cmake ${SRC_DIR}/netcdf-fortran-${F_VERSION} -DCMAKE_INSTALL_PREFIX=${TARGET_DIR}
make && make install
