#!/usr/bin/env bash

module load compiler/intel/19.1
module load mpi/openmpi/4.0
#module load lib/cgal/4.14.3
#module load lib/scotch/6.1

#https://www.cfd-online.com/Forums/openfoam/90965-errors-building-openfoam-2-0-0-icc-sgi-mpt-2-03-a.html#post317630

VERSION="2.4.x"
TARGET_DIR="/opt/bwhpc/common/cae/openfoam/${VERSION}"

[[ ! -d ${TARGET_DIR} ]] && mkdir -p $TARGET_DIR
cd $TARGET_DIR
git clone git://github.com/OpenFOAM/OpenFOAM-${VERSION}.git
wget http://download.sourceforge.net/project/foam/foam/2.4.0/ThirdParty-2.4.0.tgz
tar zxvf ThirdParty-2.4.0.tgz && rm ThirdParty-2.4.0.tgz && mv ThirdParty-2.4.0 ThirdParty-${VERSION}

cd ${TARGET_DIR}/ThirdParty-${VERSION}
#rm -rfv ParaView-4.1.0 cmake-2.8.12.1 openmpi-1.8.5 CGAL-4.6 scotch_6.0.3
#rm -rfv ParaView-4.1.0 cmake-2.8.12.1 openmpi-1.8.5 scotch_*
rm -rfv ParaView-4.1.0 cmake-2.8.12.1 openmpi-1.8.5
wget http://glaros.dtc.umn.edu/gkhome/fetch/sw/metis/metis-5.1.0.tar.gz
tar zxvf metis-5.1.0.tar.gz && rm metis-5.1.0.tar.gz

#wget https://gforge.inria.fr/frs/download.php/file/37622/scotch_6.0.6.tar.gz
#tar zxvf scotch_6.0.6.tar.gz && rm scotch_6.0.6.tar.gz

cd $TARGET_DIR/OpenFOAM-${VERSION} && git pull
sed -i s:'foamInstall=$HOME/$WM_PROJECT':"foamInstall=$TARGET_DIR":g etc/bashrc
sed -i s:'export WM_COMPILER=Gcc':'export WM_COMPILER=Icc':g etc/bashrc

#sed -i s:'6.0.3':'6.0.6':g etc/config/scotch.sh

#echo "export CGAL_ARCH_PATH=${CGAL_HOME}" >> etc/config/CGAL.sh
#echo "export SCOTCH_ARCH_PATH=${SCOTCH_HOME}" >> etc/config/scotch.sh
#sed -i s:'6.0.3':'6.1':g etc/config/scotch.sh

export WM_NCOMPPROCS=80

. $TARGET_DIR/OpenFOAM-${VERSION}/etc/bashrc
export WM_CFLAGS="$WM_CFLAGS -DMPI_NO_CPPBIND"
bin/foamInstallationTest

#mkdir -p ${FOAM_EXT_LIBBIN}
#ln -s "/opt/bwhpc/common/cae/openfoam/scotch_6.1-gnu-10.2/libscotch.so" "${FOAM_EXT_LIBBIN}/libscotch.so"
#ln -s "/opt/bwhpc/common/cae/openfoam/scotch_6.1-gnu-10.2/libscotcherrexit.so" "${FOAM_EXT_LIBBIN}/libscotcherrexit.so"
#ln -s "/opt/bwhpc/common/cae/openfoam/scotch_6.1-gnu-10.2/openmpi-system" "${FOAM_EXT_LIBBIN}/"

./Allwmake 2>&1 | tee Allwmake.log
./Allwmake 2>&1 | tee Allwmake.log

cd $TARGET_DIR
chmod -R go=u-w OpenFOAM-${VERSION} ThirdParty-${VERSION}

cd $TARGET_DIR/OpenFOAM-${VERSION}
ln -s /opt/bwhpc/common/cae/openfoam/bin/decomposeParHPC bin/
ln -s /opt/bwhpc/common/cae/openfoam/bin/reconstructParMeshHPC bin/
ln -s /opt/bwhpc/common/cae/openfoam/bin/reconstructParHPC bin/

### Install swak4Foam-dev
cd $TARGET_DIR
svn checkout svn://svn.code.sf.net/p/openfoam-extend/svn/trunk/Breeder_2.0/libraries/swak4Foam/ swak4Foam
cd swak4Foam/
./maintainanceScripts/compileRequirements.sh
cp swakConfiguration.centos6 swakConfiguration
sed -i s:"python2.6":"python2.7":g swakConfiguration
export WM_NCOMPPROCS=16
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
