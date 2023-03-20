#%Module1.0
#
# Module:          cae/openfoam/7
# Revision:        esbw00
# TargetSystem:    RHEL7
# Priority:        optional
# 2ndLevelSupport: cluster-support [at] hs-esslingen.de
#
##### (A) Revision history:
#
# esbw00 08052019 A.Saramet Compilling OpenFOAM-7 (without Paraview)
#
##### (B) Dependencies:
#
# prereq mpi/openmpi/3.1-gnu-8.2
#
##### (C) How to obtain software?
#
# ### Main Site:
# http://www.openfoam.org
#
# ### Download:
# git clone git://github.com/OpenFOAM/OpenFOAM-7.git
# git clone git://github.com/OpenFOAM/ThirdParty-7.git
# 
# ### (D) Howto compile and install OpenFOAM?
# 
# ### (1) Compilation of OpenFOAM ###
# 
# module load mpi/openmpi/3.1-gnu-8.2
#
# # check if OpenMPI is compiled with threading support
# ompi_info -c | grep -oE "MPI_THREAD_MULTIPLE[^,]*"
#
# TARGET_DIR="/opt/bwhpc/common/cae/openfoam/7"
#
# mkdir -p $TARGET_DIR && cd $TARGET_DIR
# git clone git://github.com/OpenFOAM/OpenFOAM-7.git
# git clone git://github.com/OpenFOAM/ThirdParty-7.git
#
# cd ThirdParty-7
# wget https://github.com/CGAL/cgal/releases/download/releases%2FCGAL-4.10/CGAL-4.10.tar.xz
# tar xvf CGAL-4.10.tar.xz && rm CGAL-4.10.tar.xz
#
# wget http://glaros.dtc.umn.edu/gkhome/fetch/sw/metis/metis-5.1.0.tar.gz
# tar zxvf metis-5.1.0.tar.gz && rm metis-5.1.0.tar.gz
#
# wget https://dl.bintray.com/boostorg/release/1.69.0/source/boost_1_69_0.tar.gz
# tar zxvf boost_1_69_0.tar.gz && rm boost_1_69_0.tar.gz
#
# cd $TARGET_DIR/OpenFOAM-7 && git pull
#
# sed -i s:'FOAM_INST_DIR=$HOME/$WM_PROJECT':"FOAM_INST_DIR=$TARGET_DIR":g etc/bashrc
# sed -i s:'export FOAM_INST_DIR=$(cd':'# export FOAM_INST_DIR=$(cd':g etc/bashrc
#
# export FOAMY_HEX_MESH=yes
# . $TARGET_DIR/OpenFOAM-7/etc/bashrc
# ./Allwmake -j 2>&1 | tee Allwmake.log
# ./Allwmake -j 2>&1 | tee Allwmake.log
#
# cd $TARGET_DIR
# chmod -R go=u-w OpenFOAM-7 ThirdParty-7
#
# ### Set wrappers links
# cd $TARGET_DIR/OpenFOAM-7
# ln -s /opt/bwhpc/common/cae/openfoam/bin/decomposeParHPC bin/
# ln -s /opt/bwhpc/common/cae/openfoam/bin/reconstructParMeshHPC bin/
# ln -s /opt/bwhpc/common/cae/openfoam/bin/reconstructParHPC bin/
#
# ## Update
# cd $TARGET_DIR/OpenFOAM-7
# git pull
# git clean -f -d
# cp ../modulefiles/bashrc etc/bashrc
# ln -s /opt/bwhpc/common/cae/openfoam/bin/decomposeParHPC bin/
# ln -s /opt/bwhpc/common/cae/openfoam/bin/reconstructParMeshHPC bin/
# ln -s /opt/bwhpc/common/cae/openfoam/bin/reconstructParHPC bin/
#
# wcleanLnIncludeAll 2>&1 | tee log.wcleanLn
# ./Allwmake -j -update 2>&1 | tee Allwmake.log
# ./Allwmake -j 2>&1 | tee Allwmake.log
#
# ### Install swak4Foam-dev
# cd $TARGET_DIR
# ## Downloading:
# hg clone http://hg.code.sf.net/p/openfoam-extend/swak4Foam swak4Foam
# cd swak4Foam/
# hg update develop
# ./maintainanceScripts/compileRequirements.sh
#
# cp swakConfiguration.centos6 swakConfiguration
# sed -i s:'export SWAK_PYTHON2_INCLUDE="-I/usr/include/python2.6"':'export SWAK_PYTHON2_INCLUDE="-I/opt/bwhpc/common/devel/python/2.7.12/include/python2.7"':g swakConfiguration 
# sed -i s:'export SWAK_PYTHON2_LINK="-lpython2.6"':'export SWAK_PYTHON2_LINK="-lpython2.7"':g swakConfiguration
# echo 'export SWAK_PYTHON3_INCLUDE="-I/opt/bwhpc/common/devel/python/3.5.2/include/python3.5m"' >> swakConfiguration 
# echo 'export SWAK_PYTHON3_LINK="-lpython3.5"' >> swakConfiguration
#
# export WM_NCOMPPROCS=16
# ./Allwmake -j 2>&1 | tee log.Allwmake
# ./Allwmake -j 2>&1 | tee log.Allwmake
# echo 'SWAK4FOAM_SRC="/opt/bwhpc/common/cae/openfoam/7/swak4Foam/Libraries"' >> ../OpenFOAM-7/etc/bashrc
# echo 'PATH="/opt/bwhpc/common/cae/openfoam/7/swak4Foam/privateRequirements/bin":$PATH' >> ../OpenFOAM-7/etc/bashrc
#
# ./maintainanceScripts/copySwakFilesToSite.sh 
#
# ## Install globally
# cp $FOAM_USER_LIBBIN/* $FOAM_LIBBIN -fv
# cp $FOAM_USER_APPBIN/* $FOAM_APPBIN -fv
#
#####

set            version         "7"
set            base_dir        "/opt/bwhpc/common/cae/openfoam/$version"
setenv         FOAM_VERSION    "$version"
setenv         FOAM_INST_DIR   "$base_dir"
setenv         FOAM_INIT       "$base_dir/OpenFOAM-$version/etc/bashrc"
setenv         FOAM_DOC_DIR    "$base_dir/OpenFOAM-$version/doc/Guides-a4"
setenv         FOAM_EXA_DIR    "$base_dir/OpenFOAM-$version/tutorials"
setenv         FOAM_WWW        "http://www.openfoam.org"
setenv 		   FOAMY_HEX_MESH  "yes"

set-alias      foamInit        "source $base_dir/OpenFOAM-$version/etc/bashrc"
set            FOAM_BPR_URL    "http://www.bwhpc-c5.de/wiki/index.php/OpenFoam"

set        loading     [module-info mode load]

if { $loading && ![ is-loaded mpi/openmpi/3.1-gnu-8.2 ] } {
    if { [ is-loaded "mpi" ] } {
        puts stderr "Unloading 'mpi'"
        module unload mpi
    }
    if { [ is-loaded "compiler" ] } {
        puts stderr "Unloading 'compiler'"
        module unload compiler
    }
puts stderr "Loading module dependency 'mpi/openmpi/3.1-gnu-8.2'"
module load mpi/openmpi/3.1-gnu-8.2
}

if { $loading && ![ is-loaded system/ssh_wrapper/0.1 ] } { 
	if { [ is-loaded "system/ssh_wrapper" ] } { 
		module unload system/ssh_wrapper 
	} 
	module load /opt/bwhpc/es/system/ssh_wrapper/0.1/modulefiles/0.1
}

module-whatis    "Open Source CFD Toolbox OpenFOAM version $version"

proc ModulesHelp { } {
        global env
        puts stderr "
The OpenFOAM (Open Field Operation and Manipulation) CFD Toolbox can simulate anything
from complex fluid flows involving chemical reactions, turbulence and heat transfer, to
solid dynamics, electromagnetics and the pricing of financial options.

Usage possible after:
   module load cae/openfoam/$env(FOAM_VERSION)
   source \$FOAM_INIT (or simply: foamInit)

Local documentation in:
   \$FOAM_DOC_DIR

Tutorial examples in:
   \$FOAM_TUTORIALS

Online documenation:
   $env(FOAM_WWW)/docs

In case of problems, please contact 'bwunicluster-hotline(at)lists.kit.edu',
or create a ticket at 'https://bw-support.scc.kit.edu/'
"
}

# Conflicts and prereqirements at end of file. Otherwise, "module help"
# will not work, if any of the dependencies failes (which is odd, since
# "module help" should help the user to solve exactly this problem).
conflict cae/openfoam
prereq mpi/openmpi/3.1-gnu-8.2
