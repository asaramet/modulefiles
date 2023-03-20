#!/usr/bin/env bash

module load compiler/intel/19.1
module load mpi/impi/2020

VERSION=6
TARGET_DIR="/opt/bwhpc/common/cae/openfoam/${VERSION}-impi"

[[ ! -d ${TARGET_DIR} ]] && mkdir -p $TARGET_DIR
cd $TARGET_DIR
git clone git://github.com/OpenFOAM/OpenFOAM-${VERSION}.git
git clone git://github.com/OpenFOAM/ThirdParty-${VERSION}.git

cd ThirdParty-${VERSION}
wget http://glaros.dtc.umn.edu/gkhome/fetch/sw/metis/metis-5.1.0.tar.gz
tar zxvf metis-5.1.0.tar.gz && rm metis-5.1.0.tar.gz

wget https://github.com/CGAL/cgal/releases/download/releases%2FCGAL-4.10/CGAL-4.10.tar.xz
tar xvf CGAL-4.10.tar.xz && rm CGAL-4.10.tar.xz
wget https://dl.bintray.com/boostorg/release/1.69.0/source/boost_1_69_0.tar.gz
tar zxvf boost_1_69_0.tar.gz && rm boost_1_69_0.tar.gz

cd $TARGET_DIR/OpenFOAM-${VERSION} && git pull

sed -i s:boost_version=boost-system:boost_version=boost_1_69_0:g etc/config.sh/CGAL
sed -i s:cgal_version=cgal-system:cgal_version=CGAL-4.10:g etc/config.sh/CGAL

sed -i s:'FOAM_INST_DIR=$HOME/$WM_PROJECT':"FOAM_INST_DIR=$TARGET_DIR":g etc/bashrc
sed -i s:'export FOAM_INST_DIR=$(cd':'# export FOAM_INST_DIR=$(cd':g etc/bashrc
sed -i s:'export WM_COMPILER=Gcc':'export WM_COMPILER=Icc':g etc/bashrc
sed -i s:'export WM_MPLIB=SYSTEMOPENMPI':'export WM_MPLIB=SYSTEMMPI':g etc/bashrc

echo 'export MPI_ARCH_FLAGS="-DOMPI_SKIP_MPICXX"' >> etc/config.sh/settings
echo 'export MPI_ARCH_INC="-isystem $MPI_ROOT/intel64/include"' >> etc/config.sh/settings
echo 'export MPI_ARCH_LIBS="-L$MPI_ROOT/intel64/lib"' >> etc/config.sh/settings

export FOAMY_HEX_MESH=yes
. $TARGET_DIR/OpenFOAM-${VERSION}/etc/bashrc
./Allwmake -j 2>&1 | tee Allwmake.log
./Allwmake -j 2>&1 | tee Allwmake.log

cd $TARGET_DIR
chmod -R go=u-w OpenFOAM-${VERSION} ThirdParty-${VERSION}

cd $TARGET_DIR/OpenFOAM-${VERSION}
ln -s /opt/bwhpc/common/cae/openfoam/bin/decomposeParHPC bin/
ln -s /opt/bwhpc/common/cae/openfoam/bin/reconstructParMeshHPC bin/
ln -s /opt/bwhpc/common/cae/openfoam/bin/reconstructParHPC bin/

### Install swak4Foam-dev
cd $TARGET_DIR
hg clone http://hg.code.sf.net/p/openfoam-extend/swak4Foam swak4Foam
cd swak4Foam/
hg update develop
./maintainanceScripts/compileRequirements.sh
cp swakConfiguration.centos6 swakConfiguration
sed -i s:'export SWAK_PYTHON2_INCLUDE="-I/usr/include/python2.6"':'export SWAK_PYTHON2_INCLUDE="-I/opt/bwhpc/common/devel/python/2.7.12/include/python2.7"':g swakConfiguration
sed -i s:'export SWAK_PYTHON2_LINK="-lpython2.6"':'export SWAK_PYTHON2_LINK="-lpython2.7"':g swakConfiguration
echo 'export SWAK_PYTHON3_INCLUDE="-I/opt/bwhpc/common/devel/python/3.5.2/include/python3.5m"' >> swakConfiguration
echo 'export SWAK_PYTHON3_LINK="-lpython3.5"' >> swakConfiguration
export WM_NCOMPPROCS=16
./Allwmake -j 2>&1 | tee log.Allwmake
./Allwmake -j 2>&1 | tee log.Allwmake
echo 'SWAK4FOAM_SRC="/opt/bwhpc/common/cae/openfoam/7/swak4Foam/Libraries"' >> ../OpenFOAM-${VERSION}/etc/bashrc
echo 'PATH="/opt/bwhpc/common/cae/openfoam/7/swak4Foam/privateRequirements/bin":$PATH' >> ../OpenFOAM-${VERSION}/etc/bashrc
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
