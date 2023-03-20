#!/usr/bin/env bash

# number of processors to run a job ncpus=nodes*ppn
#PBS -l nodes=1:ppn=32

# wall time (up to 24 hours)
#PBS -l walltime=8:00:00


# name of the job
#PBS -N OpenFOAM-inst

# set a log file for job's output
#PBS -o outfile.log
#PBS -j oe

# send an e-mail when a job begins, aborts or ends
#PBS -m abe
# e-mail address specification
#PBS -M asaramet@hs-esslingen.de

echo "Starting at "
date

module load mpi/openmpi/4.0-gnu-9.2
module load devel/cmake/3.11.4

VERSION="v2006"
TARGET_DIR="/opt/bwhpc/common/cae/openfoam/${VERSION}"

[[ ! -d ${TARGET_DIR} ]] && mkdir -p $TARGET_DIR
cd $TARGET_DIR
#wget https://sourceforge.net/projects/openfoam/files/${VERSION}/OpenFOAM-${VERSION}.tgz
#wget https://sourceforge.net/projects/openfoam/files/${VERSION}/ThirdParty-${VERSION}.tgz
#tar xvzf OpenFOAM-${VERSION}.tgz && rm OpenFOAM-${VERSION}.tgz
#tar xvzf ThirdParty-${VERSION}.tgz && rm ThirdParty-${VERSION}.tgz
#rm ThirdParty-${VERSION}/ParaView-v5.6.3 ThirdParty-${VERSION}/openmpi-4.0.3 -rfv

#cd $TARGET_DIR/ThirdParty-${VERSION}
#wget http://glaros.dtc.umn.edu/gkhome/fetch/sw/metis/metis-5.1.0.tar.gz
#tar xvzf metis-5.1.0.tar.gz && rm metis-5.1.0.tar.gz
#
#cd $TARGET_DIR/ThirdParty-${VERSION}
#wget http://www2.hs-esslingen.de/~asaramet/packages/libccmio-2.6.1.tar.gz
#tar xvfz libccmio-2.6.1.tar.gz ; rm libccmio-2.6.1.tar.gz
#
#cd $TARGET_DIR/ThirdParty-${VERSION}
#git clone https://github.com/ornladios/ADIOS2.git

# set projectDir in etc/bashrc to $TARGET_DIR

. $TARGET_DIR/OpenFOAM-${VERSION}/etc/bashrc

cd $TARGET_DIR/OpenFOAM-${VERSION}

module list

export WM_NCOMPPROCS=32
foamSystemCheck

../ThirdParty-${VERSION}/makeCCMIO;

./Allwmake -j 2>&1 | tee Allwmake.log &&
./Allwmake -j 2>&1 | tee Allwmake.log &&

cd $TARGET_DIR
chmod -R go=u-w OpenFOAM-${VERSION} ThirdParty-${VERSION}

### Set wrappers links
#cd $TARGET_DIR/OpenFOAM-${VERSION}
#ln -s /opt/bwhpc/common/cae/openfoam/bin/decomposeParHPC bin/
#ln -s /opt/bwhpc/common/cae/openfoam/bin/reconstructParMeshHPC bin/
#ln -s /opt/bwhpc/common/cae/openfoam/bin/reconstructParHPC bin/
