#!/usr/bin/env bash

module load compiler/gnu/9.2
module load mpi/openmpi/4.0

VERSION="v1912"
TARGET_DIR="/opt/bwhpc/common/cae/openfoam/${VERSION}"

[[ ! -d ${TARGET_DIR} ]] && mkdir -p $TARGET_DIR
cd $TARGET_DIR
wget https://sourceforge.net/projects/openfoam/files/${VERSION}/OpenFOAM-${VERSION}.tgz
wget https://sourceforge.net/projects/openfoam/files/${VERSION}/ThirdParty-${VERSION}.tgz
tar xvzf OpenFOAM-${VERSION}.tgz && rm OpenFOAM-${VERSION}.tgz
tar xvzf ThirdParty-${VERSION}.tgz && rm ThirdParty-${VERSION}.tgz
rm ThirdParty-${VERSION}/ParaView-v5.6.3 ThirdParty-${VERSION}/openmpi-1.10.7 -rfv

cd $TARGET_DIR/ThirdParty-${VERSION}
wget http://glaros.dtc.umn.edu/gkhome/fetch/sw/metis/metis-5.1.0.tar.gz
tar xvzf metis-5.1.0.tar.gz && rm metis-5.1.0.tar.gz

cd $TARGET_DIR/ThirdParty-${VERSION}
wget http://www2.hs-esslingen.de/~asaramet/packages/libccmio-2.6.1.tar.gz
tar xvfz libccmio-2.6.1.tar.gz ; rm libccmio-2.6.1.tar.gz

git clone https://github.com/ornladios/ADIOS2.git

cd $TARGET_DIR/OpenFOAM-${VERSION}
sed -i s:'ADIOS2-2.4.0':"ADIOS2":g etc/config.sh/adios2
# set projectDir in etc/bashrc to $TARGET_DIR
. $TARGET_DIR/OpenFOAM-${VERSION}/etc/bashrc

export WM_NCOMPPROCS=32
foamSystemCheck
../ThirdParty-${VERSION}/makeCCMIO
./Allwmake -j 2>&1 | tee Allwmake.log
./Allwmake -j 2>&1 | tee Allwmake.log

cd $TARGET_DIR
chmod -R go=u-w OpenFOAM-${VERSION} ThirdParty-${VERSION}

### Set wrappers links
cd $TARGET_DIR/OpenFOAM-${VERSION}
ln -s /opt/bwhpc/common/cae/openfoam/bin/decomposeParHPC bin/
ln -s /opt/bwhpc/common/cae/openfoam/bin/reconstructParMeshHPC bin/
ln -s /opt/bwhpc/common/cae/openfoam/bin/reconstructParHPC bin/
