VERSION="4.9.0"
F_VERSION="4.5.4"
CXX_VERSION="4.3.1"
BASE_DIR="/opt/bwhpc/common/lib/netcdf"
TARGET_DIR="${BASE_DIR}/${VERSION}-gnu-12.1-openmpi-4.1"
SRC_DIR="${BASE_DIR}/src"
BUILD_DIR="${BASE_DIR}/build"

[[ -d ${BUILD_DIR} ]] && rm -rf ${BUILD_DIR}
mkdir -p ${BUILD_DIR}

module load lib/hdf5/1.12.2-gnu-12.1-openmpi-4.1

cd ${SRC_DIR} && pwd
wget https://downloads.unidata.ucar.edu/netcdf-c/${VERSION}/netcdf-c-${VERSION}.tar.gz
wget https://downloads.unidata.ucar.edu/netcdf-fortran/${F_VERSION}/netcdf-fortran-${F_VERSION}.tar.gz
wget https://downloads.unidata.ucar.edu/netcdf-cxx/${CXX_VERSION}/netcdf-cxx4-${CXX_VERSION}.tar.gz

# install netcdf C with cmake
cd ${BUILD_DIR}
tar zxvf ${SRC_DIR}/netcdf-c-${VERSION}.tar.gz

cd netcdf-c-${VERSION}
CC=mpicc CFLAGS="-I${HDF5_INC_DIR}" LDFLAGS="-L${HDF5_LIB_DIR}" ./configure --prefix=${TARGET_DIR} --with-mpiexec=mpiicc
make check
make install

# Set the environment variables to use netcdf-c in further installs
bin_dir=${TARGET_DIR}/bin
lib_dir=${TARGET_DIR}/lib
inc_dir=${TARGET_DIR}/include

PATH=${bin_dir}:${PATH}
LD_LIBRARY_PATH=${lib_dir}:${LD_LIBRARY_PATH}
INCLUDE=${inc_dir}:${INCLUDE}

# install netcdf cxx
cd ${BUILD_DIR}
tar zxvf ${SRC_DIR}/netcdf-cxx4-${CXX_VERSION}.tar.gz
cd netcdf-cxx4-${CXX_VERSION}
CC=mpicc CPPFLAGS="-I${HDF5_INC_DIR} -I${TARGET_DIR}/include" LDFLAGS="-L${HDF5_LIB_DIR} -L${TARGET_DIR}/lib" ./configure --prefix=${TARGET_DIR} --disable-filter-testing
make check
make install

# install netcdf fortran
cd ${BUILD_DIR}
tar zxvf ${SRC_DIR}/netcdf-fortran-${F_VERSION}.tar.gz
cd netcdf-fortran-${F_VERSION}
FC=mpifort CPPFLAGS="-I${HDF5_INC_DIR} -I${TARGET_DIR}/include" LDFLAGS="-L${HDF5_LIB_DIR} -L${TARGET_DIR}/lib" ./configure --prefix=${TARGET_DIR} --disable-largefile --with-mpiexec=mpifort
make check
make install

# share globally
cd ${TARGET_DIR}
chmod -R go=u-w *
