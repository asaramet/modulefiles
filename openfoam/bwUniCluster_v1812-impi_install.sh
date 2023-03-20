#!/usr/bin/env bash

module load compiler/intel/2022.2.1
module load mpi/impi/2021.7.1

VERSION="v1812"
TARGET_DIR="/opt/bwhpc/common/cae/openfoam/${VERSION}-impi"

[[ ! -d ${TARGET_DIR} ]] && mkdir -p $TARGET_DIR
cd $TARGET_DIR
wget https://sourceforge.net/projects/openfoam/files/${VERSION}/OpenFOAM-${VERSION}.tgz
wget https://sourceforge.net/projects/openfoam/files/${VERSION}/ThirdParty-${VERSION}.tgz
tar xvzf OpenFOAM-${VERSION}.tgz && rm OpenFOAM-${VERSION}.tgz
tar xvzf ThirdParty-${VERSION}.tgz --exclude=ParaView* --exclude=openmpi* --exclude=boost* --exclude=CGAL* && rm ThirdParty-${VERSION}.tgz

cd ThirdParty-${VERSION}
wget http://glaros.dtc.umn.edu/gkhome/fetch/sw/metis/metis-5.1.0.tar.gz
tar xvzf metis-5.1.0.tar.gz && rm metis-5.1.0.tar.gz

wget http://www2.hs-esslingen.de/~asaramet/packages/libccmio-2.6.1.tar.gz
tar xvfz libccmio-2.6.1.tar.gz ; rm libccmio-2.6.1.tar.gz

cd $TARGET_DIR/OpenFOAM-${VERSION}
sed -i s:'projectDir="$HOME/OpenFOAM/OpenFOAM-$WM_PROJECT_VERSION"':"projectDir=${TARGET_DIR}":g etc/bashrc
sed -i s:'export WM_COMPILER=Gcc':'export WM_COMPILER=Icc':g etc/bashrc
sed -i s:'export WM_MPLIB=SYSTEMOPENMPI':'export WM_MPLIB=SYSTEMMPI':g etc/bashrc

echo "export MPI_ROOT=${MPI_ROOT}/intel64" >> etc/config.sh/settings
echo 'export MPI_ARCH_FLAGS="-DOMPI_SKIP_MPICXX"' >> etc/config.sh/settings
echo 'export MPI_ARCH_INC="-isystem $MPI_ROOT/include"' >> etc/config.sh/settings
echo 'export MPI_ARCH_LIBS="-L$MPI_ROOT/lib -lmpicxx"' >> etc/config.sh/settings

sed -i s:'boost_version=boost_1_64_0':'boost_version=boost-system':g etc/config.sh/CGAL
sed -i s:'cgal_version=CGAL-4.9.1':'cgal_version=cgal-none':g etc/config.sh/CGAL

echo 'WM_CFLAGS="$WM_CFLAGS -diag-disable=10441"' >> etc/config.sh/settings 
echo 'WM_CXXFLAGS="$WM_CXXFLAGS -diag-disable=10441"' >> etc/config.sh/settings 
sed -i s:'-diag-disable 1224,2026,2305':'-diag-disable 1224,2026,2305,10441':g wmake/rules/General/Icc/c++
sed -i s:'-diag-disable 327,654,1125,1292,2289,2304,11062,11074,11076':'-diag-disable 327,654,1125,1292,2289,2304,11062,11074,11076,10441':g wmake/rules/General/Icc/c++
sed -i s:'diag-disable 654,1125,1292,2304':'diag-disable 654,1125,1292,2304,10441':g wmake/rules/linux64IccKNL/c++

. $TARGET_DIR/OpenFOAM-${VERSION}/etc/bashrc

# Issue invalid Line number
# https://www.cfd-online.com/Forums/openfoam-programming-development/218674-invalid-line-number-when-compiling-runtime.html
# https://develop.openfoam.com/Development/OpenFOAM-plus/-/issues/1282
# change vim  src/OpenFOAM/db/dynamicLibrary/dynamicCode/dynamicCodeContext.C
122 void Foam::dynamicCodeContext::addLineDirective
123 (
124     string& code,
125     const label lineNum,
126     const fileName& name
127 )
128 {
129     //code = "#line " + Foam::name(lineNum + 1) + " \"" + name + "\"\n" + code;
130     code = "#line " + Foam::name(lineNum >= 0 ? lineNum + 1 : 1) + " \"" + name + "\"\n" + code;
131 }

foamSystemCheck
./Allwmake -j 64 2>&1 | tee Allwmake.log
../ThirdParty-${VERSION}/makeCCMIO
./Allwmake -j 64 2>&1 | tee Allwmake.log

cd $TARGET_DIR
chmod -R go=u-w OpenFOAM-${VERSION} ThirdParty-${VERSION}

### Set wrappers links
cd $TARGET_DIR/OpenFOAM-${VERSION}
ln -s /opt/bwhpc/common/cae/openfoam/bin/decomposeParHPC bin/
ln -s /opt/bwhpc/common/cae/openfoam/bin/reconstructParMeshHPC bin/
ln -s /opt/bwhpc/common/cae/openfoam/bin/reconstructParHPC bin/
