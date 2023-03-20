#!/usr/bin/env bash

module load compiler/intel/2022.2.1
module load mpi/openmpi/4.1

VERSION="v2012"
TARGET_DIR="/opt/bwhpc/common/cae/openfoam/${VERSION}"

[[ ! -d ${TARGET_DIR} ]] && mkdir -p $TARGET_DIR
cd $TARGET_DIR
wget https://sourceforge.net/projects/openfoam/files/${VERSION}/OpenFOAM-${VERSION}.tgz
wget https://sourceforge.net/projects/openfoam/files/${VERSION}/ThirdParty-${VERSION}.tgz
tar xvzf OpenFOAM-${VERSION}.tgz && rm OpenFOAM-${VERSION}.tgz
tar xvzf ThirdParty-${VERSION}.tgz --exclude=ParaView* --exclude=openmpi* --exclude=boost* --exclude=ADIOS* --exclude=CGAL* && rm ThirdParty-${VERSION}.tgz

cd $TARGET_DIR/ThirdParty-${VERSION}
cp ../../10/ThirdParty-10/metis-5.1.0/ . -rfv

cd $TARGET_DIR/ThirdParty-${VERSION}
wget http://www2.hs-esslingen.de/~asaramet/packages/libccmio-2.6.1.tar.gz
tar xvfz libccmio-2.6.1.tar.gz ; rm libccmio-2.6.1.tar.gz

cd $TARGET_DIR/OpenFOAM-${VERSION}
sed -i s:'projectDir="$HOME/OpenFOAM/OpenFOAM-$WM_PROJECT_VERSION"':"projectDir=${TARGET_DIR}":g etc/bashrc
sed -i s:'export WM_COMPILER=Gcc':'export WM_COMPILER=Icc':g etc/bashrc
#echo WM_CFLAGS='"$WM_CFLAGS -diag-disable=10441"' >> etc/bashrc
#echo WM_CXXFLAGS='"$WM_CXXFLAGS -diag-disable=10441"' >> etc/bashrc

# Add 10441 to -diag-disable in wmake/rules/General/Icc/c++
# 17     -diag-disable 327,654,1125,1292,2289,2304,10441,11062,11074,11076 \
# ...
# 21     -diag-disable 1224,2026,2305,10441

sed -i "/showme:link/c\    libDir=/opt\`mpicc --showme:link | sed -e 's/.*-L\\\/opt\\\([^ ]*\\\).*/\\\1/'\`"  etc/config.sh/mpi
sed -i s:'boost_version=boost_1_66_0':'boost_version=boost-system':g etc/config.sh/CGAL

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
