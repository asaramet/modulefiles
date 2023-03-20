#!/usr/bin/env bash

#module load compiler/gnu/12.1
module load compiler/intel/2022.2.1
module load mpi/openmpi/4.1

VERSION="v1812"
TARGET_DIR="/opt/bwhpc/common/cae/openfoam/${VERSION}"

[[ ! -d ${TARGET_DIR} ]] && mkdir -p $TARGET_DIR
cd $TARGET_DIR
wget https://sourceforge.net/projects/openfoam/files/${VERSION}/OpenFOAM-${VERSION}.tgz
wget https://sourceforge.net/projects/openfoam/files/${VERSION}/ThirdParty-${VERSION}.tgz
tar xvzf OpenFOAM-${VERSION}.tgz && rm OpenFOAM-${VERSION}.tgz
tar xvzf ThirdParty-${VERSION}.tgz && rm ThirdParty-${VERSION}.tgz

cd $TARGET_DIR/ThirdParty-${VERSION}/
rm -rfv ParaView-* openmpi-* boost-* 

cd $TARGET_DIR/ThirdParty-${VERSION}
wget http://glaros.dtc.umn.edu/gkhome/fetch/sw/metis/metis-5.1.0.tar.gz
tar xvzf metis-5.1.0.tar.gz && rm metis-5.1.0.tar.gz

cd $TARGET_DIR/ThirdParty-${VERSION}
wget http://www2.hs-esslingen.de/~asaramet/packages/libccmio-2.6.1.tar.gz
tar xvfz libccmio-2.6.1.tar.gz ; rm libccmio-2.6.1.tar.gz

# get ADIOS2
#cd $TARGET_DIR/ThirdParty-${VERSION}/sources
#mkdir adios && cd adios
#git clone https://github.com/ornladios/ADIOS2.git ADIOS2
#sed -i s:'ADIOS2-2.6.0':'ADIOS2-2.7.1':g ${TARGET_DIR}/OpenFOAM-${VERSION}/etc/config.sh/adios2
#module load devel/cmake/3.18

# Install MPFR
cd $TARGET_DIR
mpfr_version="4.1.1"
wget https://www.mpfr.org/mpfr-current/mpfr-${mpfr_version}.tar.gz
tar zxvf mpfr-${mpfr_version}.tar.gz && rm mpfr-${mpfr_version}.tar.gz
cd mpfr-${mpfr_version}
./configure --prefix=${TARGET_DIR}/side/mpfr-${mpfr_version}
make -j 16
make install
cd $TARGET_DIR && rm mpfr-${mpfr_version} -rfv
echo "export MPFR_ARCH_PATH=${TARGET_DIR}/side/mpfr-${mpfr_version}" >> ${TARGET_DIR}/OpenFOAM-${VERSION}/etc/config.sh/CGAL

cd $TARGET_DIR/OpenFOAM-${VERSION}
sed -i s:'projectDir="$HOME/OpenFOAM/OpenFOAM-$WM_PROJECT_VERSION"':"projectDir=${TARGET_DIR}":g etc/bashrc
sed -i s:'export WM_COMPILER=Gcc':'export WM_COMPILER=Icc':g etc/bashrc
echo WM_CFLAGS='"$WM_CFLAGS -diag-disable=10441"' >> etc/bashrc
echo WM_CXXFLAGS='"$WM_CXXFLAGS -diag-disable=10441"' >> etc/bashrc
sed -i s:'boost_version=boost_1_64_0':'boost_version=boost-system':g etc/config.sh/CGAL
sed -i s:'cgal_version=CGAL-4.9.1':'cgal_version=cgal-none':g etc/config.sh/CGAL
sed -i "/showme:link/c\    libDir=/opt\`mpicc --showme:link | sed -e 's/.*-L\\\/opt\\\([^ ]*\\\).*/\\\1/'\`"  etc/config.sh/mpi

. $TARGET_DIR/OpenFOAM-${VERSION}/etc/bashrc
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
