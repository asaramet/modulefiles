#!/usr/bin/env bash

#module load compiler/gnu/11.2
module load compiler/gnu/12.1
module load mpi/openmpi/4.1

VERSION="v2112"
TARGET_DIR="/opt/bwhpc/common/cae/openfoam/${VERSION}"

[[ ! -d ${TARGET_DIR} ]] && mkdir -p $TARGET_DIR
cd $TARGET_DIR
wget https://sourceforge.net/projects/openfoam/files/${VERSION}/OpenFOAM-${VERSION}.tgz
wget https://sourceforge.net/projects/openfoam/files/${VERSION}/ThirdParty-${VERSION}.tgz
tar xvzf OpenFOAM-${VERSION}.tgz && rm OpenFOAM-${VERSION}.tgz
tar xvzf ThirdParty-${VERSION}.tgz --exclude=paraview* --exclude=openmpi* --exclude=boost* --exclude=ADIOS* --exclude=CGAL* && rm ThirdParty-${VERSION}.tgz

cd $TARGET_DIR/ThirdParty-${VERSION}/sources
mkdir -p metis && cd metis
cp /opt/bwhpc/common/cae/openfoam/src/metis-5.1.0.tar.gz .
tar xvzf metis-5.1.0.tar.gz && rm metis-5.1.0.tar.gz

cd $TARGET_DIR/ThirdParty-${VERSION}/sources
mkdir -p libccmio && cd libccmio
wget http://www2.hs-esslingen.de/~asaramet/packages/libccmio-2.6.1.tar.gz
tar xvfz libccmio-2.6.1.tar.gz ; rm libccmio-2.6.1.tar.gz

# get ADIOS2
#cd $TARGET_DIR/ThirdParty-${VERSION}/sources
#mkdir adios && cd adios
#git clone https://github.com/ornladios/ADIOS2.git ADIOS2
#sed -i s:'ADIOS2-2.6.0':'ADIOS2-2.7.1':g ${TARGET_DIR}/OpenFOAM-${VERSION}/etc/config.sh/adios2
#module load devel/cmake/3.18

cd $TARGET_DIR/OpenFOAM-${VERSION}
sed -i s:'projectDir="$HOME/OpenFOAM/OpenFOAM-$WM_PROJECT_VERSION"':"projectDir=${TARGET_DIR}":g etc/bashrc

sed -i s:'boost_version=boost_1_74_0':'boost_version=boost-system':g etc/config.sh/CGAL

# Install MPFR
#cd $TARGET_DIR
#mpfr_version="4.1.0"
#wget https://www.mpfr.org/mpfr-current/mpfr-${mpfr_version}.tar.gz
#tar zxvf mpfr-${mpfr_version}.tar.gz && rm mpfr-${mpfr_version}.tar.gz
#cd mpfr-${mpfr_version}
#./configure --prefix=${TARGET_DIR}/side/mpfr-${mpfr_version}
#make -j 16
#make install
#cd $TARGET_DIR && rm mpfr-${mpfr_version} -rfv
#sed -i s:'# export MPFR_ARCH_PATH=...':"export MPFR_ARCH_PATH=${TARGET_DIR}/side/mpfr-${mpfr_version}":g ${TARGET_DIR}/OpenFOAM-${VERSION}/etc/config.sh/CGAL

. $TARGET_DIR/OpenFOAM-${VERSION}/etc/bashrc
#foamSystemCheck
export WM_NCOMPPROCS=80
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
