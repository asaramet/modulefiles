GNU_VERSION="4.8.5"
BASE_DIR="/opt/bwhpc/common/cae/openfoam/2.4.x/ThirdParty-2.4.x"
TARGET_DIR="${BASE_DIR}/${GNU_VERSION}"

[[ ! -d ${TARGET_DIR} ]] && mkdir -p ${TARGET_DIR}
cd ${TARGET_DIR} && pwd
wget ftp://ftp.gwdg.de/pub/misc/gcc/releases/gcc-${GNU_VERSION}/gcc-${GNU_VERSION}.tar.gz
tar zxvf gcc-${GNU_VERSION}.tar.gz && rm gcc-${GNU_VERSION}.tar.gz

wget https://gmplib.org/download/gmp/gmp-5.1.2.tar.xz
tar xvf gmp-5.1.2.tar.xz && rm gmp-5.1.2.tar.xz

wget https://www.mpfr.org/mpfr-3.1.2/mpfr-3.1.2.tar.gz
tar zxvf mpfr-3.1.2.tar.gz && rm mpfr-3.1.2.tar.gz

wget https://ftp.gnu.org/gnu/mpc/mpc-1.0.1.tar.gz
tar zxvf mpc-1.0.1.tar.gz && rm mpc-1.0.1.tar.gz

wget https://download.open-mpi.org/release/open-mpi/v3.1/openmpi-3.1.6.tar.gz
tar zxvf openmpi-3.1.6.tar.gz && rm openmpi-3.1.6.tar.gz

wget https://cmake.org/files/v2.8/cmake-2.8.12.1.tar.gz
tar zxvf cmake-2.8.12.1.tar.gz && rm cmake-2.8.12.1.tar.gz

# add gccPACKAGE=gcc-4.9.4 version to ${TARGET_DIR}/makeGcc
# Continue with OpenFOAM-2.4.x install
