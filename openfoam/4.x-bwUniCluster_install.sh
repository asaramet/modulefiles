#!/usr/bin/env bash

module load compiler/gnu/10.2
module load mpi/openmpi/4.0
module load lib/cgal/4.14.3
module load lib/scotch/6.1

VERSION=4.x
TARGET_DIR="/opt/bwhpc/common/cae/openfoam/${VERSION}"

[[ ! -d ${TARGET_DIR} ]] && mkdir -p $TARGET_DIR
cd $TARGET_DIR
git clone git://github.com/OpenFOAM/OpenFOAM-${VERSION}.git
git clone git://github.com/OpenFOAM/ThirdParty-${VERSION}.git

cd ThirdParty-${VERSION}
rm -rfv ParaView-5.0.1 scotch_6.0.3
wget http://glaros.dtc.umn.edu/gkhome/fetch/sw/metis/metis-5.1.0.tar.gz
tar zxvf metis-5.1.0.tar.gz && rm metis-5.1.0.tar.gz

wget http://www2.hs-esslingen.de/~asaramet/packages/libccmio-2.6.1.tar.gz
tar zxvf libccmio-2.6.1.tar.gz && rm libccmio-2.6.1.tar.gz

cd $TARGET_DIR/OpenFOAM-${VERSION} && git pull

sed -i s:'FOAM_INST_DIR=$HOME/$WM_PROJECT':"FOAM_INST_DIR=$TARGET_DIR":g etc/bashrc
sed -i s:'export FOAM_INST_DIR=$(cd':'# export FOAM_INST_DIR=$(cd':g etc/bashrc
echo "export CGAL_ARCH_PATH=${CGAL_HOME}" >> etc/config.sh/CGAL
echo "export SCOTCH_ARCH_PATH=${SCOTCH_HOME}" >> etc/config.sh/scotch

#sed -i s:'export SCOTCH_ARCH_PATH=$WM_THIRD_PARTY_DIR/platforms/$WM_ARCH$WM_COMPILER$WM_PRECISION_OPTION$WM_LABEL_OPTION/$SCOTCH_VERSION':"export SCOTCH_ARCH_PATH=${SCOTCH_HOME}":g etc/config.sh/scotch

export FOAMY_HEX_MESH=yes
. $TARGET_DIR/OpenFOAM-${VERSION}/etc/bashrc
mkdir -p ${FOAM_EXT_LIBBIN}
ln -s "/opt/bwhpc/common/cae/openfoam/scotch_6.1-gnu-10.2/libscotch.so" "${FOAM_EXT_LIBBIN}/libscotch.so"
ln -s "/opt/bwhpc/common/cae/openfoam/scotch_6.1-gnu-10.2/libscotcherrexit.so" "${FOAM_EXT_LIBBIN}/libscotcherrexit.so"
ln -s "/opt/bwhpc/common/cae/openfoam/scotch_6.1-gnu-10.2/openmpi-system" "${FOAM_EXT_LIBBIN}/"

./Allwmake -j 2>&1 | tee Allwmake.log
./Allwmake -j 2>&1 | tee Allwmake.log
$TARGET_DIR/ThirdParty-${VERSION}/AllwmakeLibccmio

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
