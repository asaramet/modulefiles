#!/usr/bin/env bash

GNU="10.2"
MPI="4.0"

module load compiler/gnu/${GNU}
module load mpi/openmpi/${MPI}
module load devel/cmake/3.17.1

VERSION="v2012"
BASE_DIR="/opt/bwhpc/common/cae/openfoam"
TARGET_DIR="${BASE_DIR}/${VERSION}_openmpi-${MPI}-gnu-${GNU}"

[[ ! -d ${TARGET_DIR} ]] && mkdir -p $TARGET_DIR
cd $TARGET_DIR
wget https://sourceforge.net/projects/openfoam/files/${VERSION}/OpenFOAM-${VERSION}.tgz
wget https://sourceforge.net/projects/openfoam/files/${VERSION}/ThirdParty-${VERSION}.tgz
tar xvzf OpenFOAM-${VERSION}.tgz && rm OpenFOAM-${VERSION}.tgz
tar xvzf ThirdParty-${VERSION}.tgz && rm ThirdParty-${VERSION}.tgz
rm ThirdParty-${VERSION}/ParaView-v5.6.3 ThirdParty-${VERSION}/openmpi-4.0.3 -rfv

cd $TARGET_DIR/ThirdParty-${VERSION}
wget http://glaros.dtc.umn.edu/gkhome/fetch/sw/metis/metis-5.1.0.tar.gz
tar xvzf metis-5.1.0.tar.gz && rm metis-5.1.0.tar.gz

cd $TARGET_DIR/ThirdParty-${VERSION}
wget http://www2.hs-esslingen.de/~asaramet/packages/libccmio-2.6.1.tar.gz
tar xvfz libccmio-2.6.1.tar.gz ; rm libccmio-2.6.1.tar.gz

cd $TARGET_DIR/OpenFOAM-${VERSION}
# set projectDir in etc/bashrc to $TARGET_DIR
sed -i s:'projectDir="$HOME/OpenFOAM/OpenFOAM-$WM_PROJECT_VERSION"':"projectDir=${TARGET_DIR}":g etc/bashrc
. $TARGET_DIR/OpenFOAM-${VERSION}/etc/bashrc

foamSystemCheck
../ThirdParty-${VERSION}/makeCCMIO
./Allwmake -j 2>&1 | tee Allwmake.log
./Allwmake -j 2>&1 | tee Allwmake.log

cd $TARGET_DIR
chmod -R go=u-w OpenFOAM-${VERSION} ThirdParty-${VERSION}

cd $TARGET_DIR/OpenFOAM-${VERSION}
ln -s /opt/bwhpc/common/cae/openfoam/bin/decomposeParHPC bin/
ln -s /opt/bwhpc/common/cae/openfoam/bin/reconstructParMeshHPC bin/
ln -s /opt/bwhpc/common/cae/openfoam/bin/reconstructParHPC bin/
ln -s /opt/bwhpc/common/cae/openfoam/bin/getDataHPC bin/
