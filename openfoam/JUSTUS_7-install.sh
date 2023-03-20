#!/usr/bin/env bash

MPI="4.0"
GNU="10.2"
CGAL="5.3"
BOOST="1_75_0"

module load compiler/gnu/${GNU}
module load mpi/openmpi/${MPI}

VERSION=7
TARGET_DIR="/opt/bwhpc/common/cae/openfoam/${VERSION}_openmpi-${MPI}-gnu-${GNU}"

[[ ! -d ${TARGET_DIR} ]] && mkdir -p $TARGET_DIR
cd $TARGET_DIR
git clone git://github.com/OpenFOAM/OpenFOAM-${VERSION}.git
git clone git://github.com/OpenFOAM/ThirdParty-${VERSION}.git

cd ThirdParty-${VERSION}
wget http://glaros.dtc.umn.edu/gkhome/fetch/sw/metis/metis-5.1.0.tar.gz
tar zxvf metis-5.1.0.tar.gz && rm metis-5.1.0.tar.gz


wget https://github.com/CGAL/cgal/releases/download/v${CGAL}/CGAL-${CGAL}.tar.xz
tar xvf CGAL-${CGAL}.tar.xz && rm CGAL-${CGAL}.tar.xz

wget http://www2.hs-esslingen.de/~asaramet/packages/libccmio-2.6.1.tar.gz
tar zxvf libccmio-2.6.1.tar.gz && rm libccmio-2.6.1.tar.gz

sed -i s:cgal_version=cgal-system:cgal_version=CGAL-${CGAL}:g $TARGET_DIR/OpenFOAM-${VERSION}/etc/config.sh/CGAL

cd $TARGET_DIR/OpenFOAM-${VERSION} && git pull

sed -i s:'FOAM_INST_DIR=$HOME/$WM_PROJECT':"FOAM_INST_DIR=\"$TARGET_DIR\"":g etc/bashrc
sed -i s:'export FOAM_INST_DIR=$(cd':'# export FOAM_INST_DIR=$(cd':g etc/bashrc

export FOAMY_HEX_MESH=yes
. $TARGET_DIR/OpenFOAM-${VERSION}/etc/bashrc
./Allwmake -j 2>&1 | tee Allwmake.log
./Allwmake -j 2>&1 | tee Allwmake.log
$TARGET_DIR/ThirdParty-${VERSION}/AllwmakeLibccmio

cd $TARGET_DIR
chmod -R go=u-w OpenFOAM-${VERSION} ThirdParty-${VERSION}

### Install swak4Foam-dev
cd $TARGET_DIR

git clone https://github.com/Unofficial-Extend-Project-Mirror/openfoam-extend-swak4Foam-dev.git swak4Foam
cd swak4Foam/
git checkout branches/develop

./maintainanceScripts/compileRequirements.sh
cp swakConfiguration.centos6 swakConfiguration
sed -i s:"python2.6":"python2.7":g swakConfiguration
export WM_NCOMPPROCS=16
./Allwmake -j 2>&1 | tee log.Allwmake
./Allwmake -j 2>&1 | tee log.Allwmake
echo "SWAK4FOAM_SRC=/opt/bwhpc/common/cae/openfoam/${VERSION}_openmpi-${MPI}-gnu-${GNU}/swak4Foam/Libraries" >> ../OpenFOAM-${VERSION}/etc/bashrc
echo 'PATH=${PATH}'":/opt/bwhpc/common/cae/openfoam/${VERSION}_openmpi-${MPI}-gnu-${GNU}/swak4Foam/privateRequirements/bin" >> ../OpenFOAM-${VERSION}/etc/bashrc

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
ln -s /opt/bwhpc/common/cae/openfoam/bin/getDataHPC bin/
wcleanLnIncludeAll 2>&1 | tee log.wcleanLn
./Allwmake -j -update 2>&1 | tee Allwmake.log
./Allwmake -j 2>&1 | tee Allwmake.log
