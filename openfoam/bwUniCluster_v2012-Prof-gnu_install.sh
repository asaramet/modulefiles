#!/usr/bin/env bash

#module load devel/scorep/7.1-intel-2021.4.0-openmpi-4.1
module load devel/scorep/7.1-gnu-11.2-openmpi-4.1

VERSION="v2012"
TARGET_DIR="/opt/bwhpc/common/cae/openfoam/${VERSION}-Prof"

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
sed -i s:'export WM_COMPILE_OPTION=Opt':'export WM_COMPILE_OPTION=Prof':g etc/bashrc
sed -i s:'= gcc':'= scorep-mpicc':g wmake/rules/General/Gcc/c
sed -i s:'= g++':'= scorep-mpicxx':g wmake/rules/General/Gcc/c++

sed -i "/showme:link/c\    libDir=/opt\`mpicc --showme:link | sed -e 's/.*-L\\\/opt\\\([^ ]*\\\).*/\\\1/'\`"  etc/config.sh/mpi
sed -i s:'boost_version=boost_1_66_0':'boost_version=boost-system':g etc/config.sh/CGAL

. $TARGET_DIR/OpenFOAM-${VERSION}/etc/bashrc

foamSystemCheck
# nohup `nice -n 9 ${TARGET_DIR}/../extra/nohup_make.sh > Allwmake.log` &
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
