#!/usr/bin/env bash

module load compiler/clang/9.0
module load mpi/impi/2020
module load devel/cmake/3.18

VERSION="v2106"
TARGET_DIR="/opt/bwhpc/common/cae/openfoam/${VERSION}-impi"

[[ ! -d ${TARGET_DIR} ]] && mkdir -p $TARGET_DIR
cd $TARGET_DIR
wget https://sourceforge.net/projects/openfoam/files/${VERSION}/OpenFOAM-${VERSION}.tgz
wget https://sourceforge.net/projects/openfoam/files/${VERSION}/ThirdParty-${VERSION}.tgz
tar xvzf OpenFOAM-${VERSION}.tgz && rm OpenFOAM-${VERSION}.tgz
tar xvzf ThirdParty-${VERSION}.tgz && rm ThirdParty-${VERSION}.tgz

cd ThirdParty-${VERSION}
rm -rfv ParaView-v5.9.1 openmpi-4.0.3 boost_1_66_0 CGAL-4.12.2

wget http://glaros.dtc.umn.edu/gkhome/fetch/sw/metis/metis-5.1.0.tar.gz
tar xvzf metis-5.1.0.tar.gz && rm metis-5.1.0.tar.gz

wget http://www2.hs-esslingen.de/~asaramet/packages/libccmio-2.6.1.tar.gz
tar xvfz libccmio-2.6.1.tar.gz ; rm libccmio-2.6.1.tar.gz

cd $TARGET_DIR/OpenFOAM-${VERSION}
sed -i s:'projectDir="$HOME/OpenFOAM/OpenFOAM-$WM_PROJECT_VERSION"':"projectDir=${TARGET_DIR}":g etc/bashrc
sed -i s:'export WM_COMPILER=Gcc':'export WM_COMPILER=Clang':g etc/bashrc
sed -i s:'export WM_MPLIB=SYSTEMOPENMPI':'export WM_MPLIB=SYSTEMMPI':g etc/bashrc

echo "export MPI_ROOT=${MPI_ROOT}/intel64" >> etc/config.sh/settings
echo 'export MPI_ARCH_FLAGS="-DOMPI_SKIP_MPICXX"' >> etc/config.sh/settings
echo 'export MPI_ARCH_INC="-isystem $MPI_ROOT/include"' >> etc/config.sh/settings
echo 'export MPI_ARCH_LIBS="-L$MPI_ROOT/lib -lmpicxx"' >> etc/config.sh/settings

. $TARGET_DIR/OpenFOAM-${VERSION}/etc/bashrc

foamSystemCheck
./Allwmake -j 2>&1 | tee Allwmake.log
../ThirdParty-${VERSION}/makeCCMIO
./Allwmake -j 2>&1 | tee Allwmake.log

cd $TARGET_DIR
chmod -R go=u-w OpenFOAM-${VERSION} ThirdParty-${VERSION}

### Set wrappers links
cd $TARGET_DIR/OpenFOAM-${VERSION}
ln -s /opt/bwhpc/common/cae/openfoam/bin/decomposeParHPC bin/
ln -s /opt/bwhpc/common/cae/openfoam/bin/reconstructParMeshHPC bin/
ln -s /opt/bwhpc/common/cae/openfoam/bin/reconstructParHPC bin/
