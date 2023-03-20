#!/usr/bin/env bash

module load compiler/gnu/11.2
module load mpi/openmpi/4.1

VERSION=10
TARGET_DIR="/opt/bwhpc/common/cae/openfoam/temp/${VERSION}"

[[ ! -d ${TARGET_DIR} ]] && mkdir -p $TARGET_DIR
cd $TARGET_DIR
git clone https://github.com/OpenFOAM/OpenFOAM-${VERSION}.git
git clone https://github.com/OpenFOAM/ThirdParty-${VERSION}.git

cd ThirdParty-${VERSION}
wget http://glaros.dtc.umn.edu/gkhome/fetch/sw/metis/metis-5.1.0.tar.gz
tar zxvf metis-5.1.0.tar.gz && rm metis-5.1.0.tar.gz

wget http://www2.hs-esslingen.de/~asaramet/packages/libccmio-2.6.1.tar.gz
tar zxvf libccmio-2.6.1.tar.gz && rm libccmio-2.6.1.tar.gz

cd $TARGET_DIR/OpenFOAM-${VERSION} && git pull

sed -i s:'FOAM_INST_DIR=$HOME/$WM_PROJECT':"FOAM_INST_DIR=$TARGET_DIR":g etc/bashrc
sed -i s:'export FOAM_INST_DIR=$(cd':'# export FOAM_INST_DIR=$(cd':g etc/bashrc
sed -i "/showme:link/c\    libDir=/opt\`mpicc --showme:link | sed -e 's/.*-L\\\/opt\\\([^ ]*\\\).*/\\\1/'\`"  etc/config.sh/mpi

. $TARGET_DIR/OpenFOAM-${VERSION}/etc/bashrc

./Allwmake -j 2>&1 | tee Allwmake.log
$TARGET_DIR/ThirdParty-${VERSION}/AllwmakeLibccmio
$FOAM_APP/utilities/mesh/conversion/Optional/Allwmake
./Allwmake -j 2>&1 | tee Allwmake.log

cd $TARGET_DIR/OpenFOAM-${VERSION}
ln -s /opt/bwhpc/common/cae/openfoam/bin/decomposeParHPC bin/
ln -s /opt/bwhpc/common/cae/openfoam/bin/reconstructParMeshHPC bin/
ln -s /opt/bwhpc/common/cae/openfoam/bin/reconstructParHPC bin/

cd $TARGET_DIR
chmod -R go=u-w OpenFOAM-${VERSION} ThirdParty-${VERSION}

### Install swak4Foam-dev
cd $TARGET_DIR
hg clone http://hg.code.sf.net/p/openfoam-extend/swak4Foam swak4Foam
cd swak4Foam/
hg update develop
./maintainanceScripts/compileRequirements.sh
cp swakConfiguration.centos6 swakConfiguration
sed -i s:"python2.6":"python2.7":g swakConfiguration
export WM_NCOMPPROCS=64
./Allwmake -j 2>&1 | tee log.Allwmake
./Allwmake -j 2>&1 | tee log.Allwmake
echo 'SWAK4FOAM_SRC="/opt/bwhpc/common/cae/openfoam/${VERSION}/swak4Foam/Libraries"' >> ../OpenFOAM-${VERSION}/etc/bashrc
echo 'PATH="/opt/bwhpc/common/cae/openfoam/${VERSION}/swak4Foam/privateRequirements/bin":$PATH' >> ../OpenFOAM-${VERSION}/etc/bashrc
./maintainanceScripts/copySwakFilesToSite.sh
cp $FOAM_USER_LIBBIN/* $FOAM_LIBBIN -fv
cp $FOAM_USER_APPBIN/* $FOAM_APPBIN -fv

## Update
cd $TARGET_DIR/OpenFOAM-${VERSION}
git pull
git clean -f -d
cp ../modulefiles/bashrc etc/bashrc
ln -s /opt/bwhpc/common/cae/openfoam/bin/decomposeParHPC bin/
ln -s /opt/bwhpc/common/cae/openfoam/bin/reconstructParMeshHPC bin/
ln -s /opt/bwhpc/common/cae/openfoam/bin/reconstructParHPC bin/
wcleanLnIncludeAll 2>&1 | tee log.wcleanLn
./Allwmake -j -update 2>&1 | tee Allwmake.log
./Allwmake -j 2>&1 | tee Allwmake.log
