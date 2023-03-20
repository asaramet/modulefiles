VERSION='1.12.0'
BASE_DIR="/opt/bwhpc/common/lib/hdf5"
#TARGET_DIR="${BASE_DIR}/${VERSION}-gnu-8.1"
TARGET_DIR="${BASE_DIR}/${VERSION}-gnu-8.1-openmpi-3.1"
BUILD_DIR="${BASE_DIR}/build"

#module load compiler/gnu/8.1
module load mpi/openmpi/3.1-gnu-8.1

SHORT="1.12"
[[ ! -d ${BUILD_DIR} ]] && mkdir -p ${BUILD_DIR}
cd ${BUILD_DIR}
wget https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-${SHORT}/hdf5-${VERSION}/src/hdf5-${VERSION}.tar.gz
tar zxvf hdf5-${VERSION}.tar.gz --exclude='java'
cd hdf5-${VERSION}

#./configure --prefix=${TARGET_DIR} --enable-fortran --enable-cxx # --enable-parallel --enable-java
./configure --prefix=${TARGET_DIR} --enable-fortran --enable-parallel
make 2>&1 | tee make.log
make install 2>&1 | tee make_install.log
