#!/usr/bin/env bash

module load compiler/gnu/8.3.1
module load mpi/openmpi/4.0

VERSION=4.0
TARGET_DIR="/opt/bwhpc/common/cae/openfoam/${VERSION}-extend"

[[ ! -d ${TARGET_DIR} ]] && mkdir -p $TARGET_DIR
cd $TARGET_DIR
git clone git://git.code.sf.net/p/foam-extend/foam-extend-${VERSION}

cd $TARGET_DIR/foam-extend-${VERSION} && git pull

sed -i s:'foamInstall=$HOME/$WM_PROJECT':"foamInstall=${TARGET_DIR}":g etc/bashrc
sed -i s:'export WM_THIRD_PARTY_USE_OPENMPI':'#export WM_THIRD_PARTY_USE_OPENMPI':g etc/bashrc
sed -i s/': ${WM_MPLIB:=OPENMPI};'/': ${WM_MPLIB:=SYSTEMOPENMPI};'/g etc/bashrc

. $TARGET_DIR/foam-extend-${VERSION}/etc/bashrc

./Allwmake.firstInstall -j 2>&1 | tee Allwmake.log
./Allwmake -j 2>&1 | tee Allwmake.log

cd $TARGET_DIR/foam-extend-${VERSION}
ln -s /opt/bwhpc/common/cae/openfoam/bin/decomposeParHPC bin/
ln -s /opt/bwhpc/common/cae/openfoam/bin/reconstructParMeshHPC bin/
ln -s /opt/bwhpc/common/cae/openfoam/bin/reconstructParHPC bin/

cd $TARGET_DIR
chmod -R go=u-w foam-extend-${VERSION}

## Update
cd $TARGET_DIR/foame-extend-${VERSION}
git pull
git clean -f -d
sed -i s:'foamInstall=$HOME/$WM_PROJECT':"foamInstall=${TARGET_DIR}":g etc/bashrc
sed -i s:'export WM_THIRD_PARTY_USE_OPENMPI':'#export WM_THIRD_PARTY_USE_OPENMPI':g etc/bashrc
sed -i s/': ${WM_MPLIB:=OPENMPI};'/': ${WM_MPLIB:=SYSTEMOPENMPI};'/g etc/bashrc

ln -s /opt/bwhpc/common/cae/openfoam/bin/decomposeParHPC bin/
ln -s /opt/bwhpc/common/cae/openfoam/bin/reconstructParMeshHPC bin/
ln -s /opt/bwhpc/common/cae/openfoam/bin/reconstructParHPC bin/
ln -s /opt/bwhpc/common/cae/openfoam/bin/bin/

wcleanLnIncludeAll 2>&1 | tee log.wcleanLn
./Allwmake -j -update 2>&1 | tee Allwmake.log
./Allwmake -j 2>&1 | tee Allwmake.log
