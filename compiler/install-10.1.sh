VERSION="10.1.0"
BASE_DIR="/opt/bwhpc/common/compiler/gnu"
#BASE_DIR="/opt/bwhpc/es/compiler/gnu"
TARGET_DIR="${BASE_DIR}/${VERSION}"
BUILD_DIR="${BASE_DIR}/build"
SRC_DIR="${BASE_DIR}/src"

[[ ! -d ${SRC_DIR} ]] && mkdir -p ${SRC_DIR}
cd ${SRC_DIR} && pwd
wget ftp://ftp.gwdg.de/pub/misc/gcc/releases/gcc-${VERSION}/gcc-${VERSION}.tar.gz

[[ ! -d ${BUILD_DIR} ]] && mkdir -p ${BUILD_DIR}
cd ${BUILD_DIR} && pwd
tar zxvf ${SRC_DIR}/gcc-${VERSION}.tar.gz
mkdir temp
cd temp

module load compiler/gnu/8.4

../gcc-${VERSION}/configure --prefix=${TARGET_DIR} --enable-ld=yes --enable-gold=yes \
--enable-bootstrap=yes --enable-lto=yes --disable-multilib

make -j 80
make install
