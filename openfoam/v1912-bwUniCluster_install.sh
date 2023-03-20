#!/usr/bin/env bash

module load compiler/gnu/10.2
module load mpi/openmpi/4.0
#module load lib/cgal/4.14.3
#module load lib/scotch/6.1

VERSION="v1912"
TARGET_DIR="/opt/bwhpc/common/cae/openfoam/${VERSION}"
#BOOST_VERSION="1_64_0"
#CGAL_VERSION="4.9.1"
#SCOTCH_VERSION="6.0.9"

[[ ! -d ${TARGET_DIR} ]] && mkdir -p $TARGET_DIR
cd $TARGET_DIR
wget https://sourceforge.net/projects/openfoam/files/${VERSION}/OpenFOAM-${VERSION}.tgz
wget https://sourceforge.net/projects/openfoam/files/${VERSION}/ThirdParty-${VERSION}.tgz
tar xvzf OpenFOAM-${VERSION}.tgz && rm OpenFOAM-${VERSION}.tgz
tar xvzf ThirdParty-${VERSION}.tgz && rm ThirdParty-${VERSION}.tgz

cd ThirdParty-${VERSION}
#rm ParaView-* openmpi-* boost_${BOOST_VERSION} CGAL-${CGAL_VERSION} scotch_${SCOTCH_VERSION} -rfv
rm -rfv ParaView-* openmpi-*

cd $TARGET_DIR/ThirdParty-${VERSION}
wget http://glaros.dtc.umn.edu/gkhome/fetch/sw/metis/metis-5.1.0.tar.gz
tar xvzf metis-5.1.0.tar.gz && rm metis-5.1.0.tar.gz

cd $TARGET_DIR/ThirdParty-${VERSION}
wget http://www2.hs-esslingen.de/~asaramet/packages/libccmio-2.6.1.tar.gz
tar xvfz libccmio-2.6.1.tar.gz ; rm libccmio-2.6.1.tar.gz

cd $TARGET_DIR/OpenFOAM-${VERSION}
sed -i s:'projectDir="$HOME/OpenFOAM/OpenFOAM-$WM_PROJECT_VERSION"':"projectDir=${TARGET_DIR}":g etc/bashrc

#sed -i s:"boost_version=boost_${BOOST_VERSION}":'boost_version=boost-system':g etc/config.sh/CGAL
#sed -i s:"cgal_version=CGAL-${CGAL_VERSION}":'cgal_version=cgal-system':g etc/config.sh/CGAL
#sed -i s:'export BOOST_ARCH_PATH=':'#export BOOST_ARCH_PATH=':g etc/config.sh/CGAL
#sed -i s:'export CGAL_ARCH_PATH=':'#export CGAL_ARCH_PATH=':g etc/config.sh/CGAL
#echo "export CGAL_ARCH_PATH=${CGAL_HOME}" >> etc/config.sh/CGAL
#
#sed -i s:"SCOTCH_VERSION=scotch_${SCOTCH_VERSION}":'SCOTCH_VERSION=scotch-system':g etc/config.sh/scotch
#sed -i s:'export SCOTCH_ARCH_PATH=':'#export SCOTCH_ARCH_PATH=':g etc/config.sh/scotch
#echo "export SCOTCH_ARCH_PATH=${SCOTCH_HOME}" >> etc/config.sh/scotch

echo "export GMP_LIBRARIES=${GNU_LIB64_DIR}" >> etc/config.sh/CGAL
echo "export GMP_INCLUDE_DIR=${GNU_INC_DIR}" >> etc/config.sh/CGAL

echo "export MPFR_LIBRARIES=${GNU_LIB64_DIR}" >> etc/config.sh/CGAL
echo "export MPFR_INCLUDE_DIR=${GNU_INC_DIR}" >> etc/config.sh/CGAL

. $TARGET_DIR/OpenFOAM-${VERSION}/etc/bashrc

foamSystemCheck
../ThirdParty-${VERSION}/makeCCMIO
./Allwmake -j 2>&1 | tee Allwmake.log
./Allwmake -j 2>&1 | tee Allwmake.log

### Set wrappers links
cd $TARGET_DIR/OpenFOAM-${VERSION}
ln -s /opt/bwhpc/common/cae/openfoam/bin/decomposeParHPC bin/
ln -s /opt/bwhpc/common/cae/openfoam/bin/reconstructParMeshHPC bin/
ln -s /opt/bwhpc/common/cae/openfoam/bin/reconstructParHPC bin/

cd $TARGET_DIR
chmod -R go=u-w OpenFOAM-${VERSION} ThirdParty-${VERSION}
