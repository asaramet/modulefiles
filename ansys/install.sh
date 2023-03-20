VERSION="2020R3"
BASE_DIR="/opt/bwhpc/common/cae/ansys"
TARGET_DIR="${BASE_DIR}/${VERSION}"
BUILD_DIR="${BASE_DIR}/build"
SRC_DIR="${BASE_DIR}/src"

#PACKAGE="STRUCTURES_${VERSION}_LINX64"
#PACKAGE="FLUIDS_${VERSION}_LINX64"
PACKAGE="FLUIDSTRUCTURES_${VERSION}_LINX64"

[[ -d ${BUILD_DIR} ]] && rm -rfv ${BUILD_DIR}
mkdir -p ${BUILD_DIR}

cd ${BUILD_DIR} && pwd
tar xvf "${SRC_DIR}/${PACKAGE}.tar"

./INSTALL

# update libs:
SHORT="v202"
cd "${TARGET_DIR}/ansys_inc/${SHORT}/fluent/lib/lnamd64"
mv libcrypto.so.1.1 libcrypto.so.1.1.bak
ln -s /lib64/libcrypto.so.1.1 .
