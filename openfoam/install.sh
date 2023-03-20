#!/usr/bin/env bash


module load mpi/openmpi/4.0-gnu-9.2

TARGET_DIR="/opt/bwhpc/common/cae/openfoam/7"

[[ ! -d ${TARGET_DIR} ]] && mkdir -p $TARGET_DIR 
cd $TARGET_DIR
git clone git://github.com/OpenFOAM/OpenFOAM-7.git
git clone git://github.com/OpenFOAM/ThirdParty-7.git

cd ThirdParty-7
wget https://github.com/CGAL/cgal/releases/download/releases%2FCGAL-4.10/CGAL-4.10.tar.xz
tar xvf CGAL-4.10.tar.xz && rm CGAL-4.10.tar.xz

wget http://glaros.dtc.umn.edu/gkhome/fetch/sw/metis/metis-5.1.0.tar.gz
tar zxvf metis-5.1.0.tar.gz && rm metis-5.1.0.tar.gz

wget https://dl.bintray.com/boostorg/release/1.69.0/source/boost_1_69_0.tar.gz
tar zxvf boost_1_69_0.tar.gz && rm boost_1_69_0.tar.gz

cd $TARGET_DIR/OpenFOAM-7 && git pull

sed -i s:'FOAM_INST_DIR=$HOME/$WM_PROJECT':"FOAM_INST_DIR=$TARGET_DIR":g etc/bashrc
sed -i s:'export FOAM_INST_DIR=$(cd':'# export FOAM_INST_DIR=$(cd':g etc/bashrc

export FOAMY_HEX_MESH=yes
. $TARGET_DIR/OpenFOAM-7/etc/bashrc
./Allwmake -j 2>&1 | tee Allwmake.log
./Allwmake -j 2>&1 | tee Allwmake.log

cd $TARGET_DIR
chmod -R go=u-w OpenFOAM-7 ThirdParty-7

cd $TARGET_DIR/OpenFOAM-7
ln -s /opt/bwhpc/common/cae/openfoam/bin/decomposeParHPC bin/
ln -s /opt/bwhpc/common/cae/openfoam/bin/reconstructParMeshHPC bin/
ln -s /opt/bwhpc/common/cae/openfoam/bin/reconstructParHPC bin/
