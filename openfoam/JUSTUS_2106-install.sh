#!/usr/bin/env bash

COMPILER="10.2"
MPI="4.0"
#COMPILER="19.1.2"
#MPI="2019.8"

#module load compiler/intel/${COMPILER}
module load compiler/gnu/${COMPILER}
module load mpi/openmpi/${MPI}
#module load mpi/impi/${MPI}
module load devel/cmake/3.17.1

VERSION="v2106"
BASE_DIR="/opt/bwhpc/common/cae/openfoam"
#TARGET_DIR="${BASE_DIR}/${VERSION}_impi-${MPI}-intel-${COMPILER}"
TARGET_DIR="${BASE_DIR}/${VERSION}_openmpi-${MPI}-gnu-${COMPILER}"
cgal_version="4.14.3"
fftw_version="3.3.9"

[[ ! -d ${TARGET_DIR} ]] && mkdir -p $TARGET_DIR
cd $TARGET_DIR
wget https://sourceforge.net/projects/openfoam/files/${VERSION}/OpenFOAM-${VERSION}.tgz
wget https://sourceforge.net/projects/openfoam/files/${VERSION}/ThirdParty-${VERSION}.tgz
tar xvzf OpenFOAM-${VERSION}.tgz && rm OpenFOAM-${VERSION}.tgz
tar xvzf ThirdParty-${VERSION}.tgz --exclude=ParaView-* --exclude=openmpi-* --exclude=boost_* \
--exclude=CGAL-* --exclude=fftw-* && rm ThirdParty-${VERSION}.tgz

cd $TARGET_DIR/ThirdParty-${VERSION}
wget http://glaros.dtc.umn.edu/gkhome/fetch/sw/metis/metis-5.1.0.tar.gz
tar xvzf metis-5.1.0.tar.gz && rm metis-5.1.0.tar.gz

cd $TARGET_DIR/ThirdParty-${VERSION}
wget http://www2.hs-esslingen.de/~asaramet/packages/libccmio-2.6.1.tar.gz
tar xvfz libccmio-2.6.1.tar.gz ; rm libccmio-2.6.1.tar.gz

wget https://fftw.org/fftw-${fftw_version}.tar.gz
tar zxvf fftw-${fftw_version}.tar.gz && rm fftw-${fftw_version}.tar.gz

wget "https://github.com/CGAL/cgal/archive/v${cgal_version}.tar.gz"
tar zxvf v${cgal_version}.tar.gz && rm v${cgal_version}.tar.gz
mv cgal-${cgal_version} CGAL-${cgal_version}

cd $TARGET_DIR/OpenFOAM-${VERSION}
sed -i s:'projectDir="$HOME/OpenFOAM/OpenFOAM-$WM_PROJECT_VERSION"':"projectDir=${TARGET_DIR}":g etc/bashrc
#sed -i s:'export WM_COMPILER=Gcc':'export WM_COMPILER=Icc':g etc/bashrc
#sed -i s:'export WM_MPLIB=SYSTEMOPENMPI':'export WM_MPLIB=SYSTEMMPI':g etc/bashrc

#echo 'export MPI_ROOT=${MPI_HOME}' >> etc/config.sh/settings
#echo 'export MPI_ARCH_FLAGS="-DOMPI_SKIP_MPICXX"' >> etc/config.sh/settings
#echo 'export MPI_ARCH_INC="-isystem $MPI_ROOT/include"' >> etc/config.sh/settings
#echo 'export MPI_ARCH_LIBS="-L$MPI_ROOT/lib -lmpicxx"' >> etc/config.sh/settings
sed -i s:'boost_version=boost_1_66_0':'boost_version=boost-system':g etc/config.sh/CGAL
sed -i s:'cgal_version=CGAL-4.12.2':"cgal_version=CGAL-${cgal_version}":g etc/config.sh/CGAL

sed -i s:'fftw_version=fftw-3.3.7':"fftw_version=fftw-${fftw_version}":g etc/config.sh/FFTW

. $TARGET_DIR/OpenFOAM-${VERSION}/etc/bashrc

foamSystemCheck
./Allwmake -j 2>&1 | tee Allwmake.log
../ThirdParty-${VERSION}/makeCCMIO
./Allwmake -j 2>&1 | tee Allwmake.log

cd $TARGET_DIR
chmod -R go=u-w OpenFOAM-${VERSION} ThirdParty-${VERSION}

cd $TARGET_DIR/OpenFOAM-${VERSION}
ln -s /opt/bwhpc/common/cae/openfoam/bin/decomposeParHPC bin/
ln -s /opt/bwhpc/common/cae/openfoam/bin/reconstructParMeshHPC bin/
ln -s /opt/bwhpc/common/cae/openfoam/bin/reconstructParHPC bin/
ln -s /opt/bwhpc/common/cae/openfoam/bin/getDataHPC bin/
