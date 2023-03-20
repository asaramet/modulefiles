VERSION="4.8.1"
F_VERSION="4.5.3"
CXX_VERSION="4.3.1"
PNET_VERSION="1.12.2"
BASE_DIR="/opt/bwhpc/common/lib/netcdf"
TARGET_DIR="${BASE_DIR}/${VERSION}-intel-2021.4-impi"
SRC_DIR="${BASE_DIR}/src"
BUILD_DIR="${SRC_DIR}/build"

[[ ! -d ${BUILD_DIR} ]] && mkdir -p ${BUILD_DIR}

module load lib/hdf5/1.12.1-intel-2021.4-impi-2021.4.0
module load devel/cmake/3.18

cd ${SRC_DIR} && pwd
#wget ftp://ftp.unidata.ucar.edu/pub/netcdf/netcdf-c-${VERSION}.tar.gz
wget https://downloads.unidata.ucar.edu/netcdf-c/${VERSION}/src/netcdf-c-${VERSION}.tar.gz
wget https://downloads.unidata.ucar.edu/netcdf-fortran/${F_VERSION}/netcdf-fortran-${F_VERSION}.tar.gz
#wget ftp://ftp.unidata.ucar.edu/pub/netcdf/netcdf-fortran-${F_VERSION}.tar.gz
#wget ftp://ftp.unidata.ucar.edu/pub/netcdf/netcdf-cxx4-${CXX_VERSION}.tar.gz
wget https://downloads.unidata.ucar.edu/netcdf-cxx/${CXX_VERSION}/netcdf-cxx4-${CXX_VERSION}.tar.gz
wget https://parallel-netcdf.github.io/Release/pnetcdf-${PNET_VERSION}.tar.gz

cd ${BUILD_DIR}

# install pnetcdf
tar zxvf ${SRC_DIR}/pnetcdf-${PNET_VERSION}.tar.gz
cd ${BUILD_DIR}/pnetcdf-${PNET_VERSION}
./configure --prefix=${TARGET_DIR}
make
make install


# install netcdf C
tar zxvf ${SRC_DIR}/netcdf-c-${VERSION}.tar.gz

cmake ${BUILD_DIR}/netcdf-c-${VERSION} -DCMAKE_INSTALL_PREFIX=${TARGET_DIR} -DENABLE_DAP=OFF \
-DENABLE_EXAMPLES=OFF -DENABLE_TESTS=OFF -DENABLE_PNETCDF=ON
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
