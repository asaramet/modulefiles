#%Module1.0
# Module:          cae/openfoam/v2006
# Revision:        esbw00
# TargetSystem:    RHEL7
# Priority:        optional
# 2ndLevelSupport: cluster-support [at] hs-esslingen.de
#
##### (B) Dependencies:
#
# prereq mpi/openmpi/4.0-gnu-9.2
#
#####

set            version         "v2006"
set            base_dir        "/opt/bwhpc/common/cae/openfoam/$version"
setenv         FOAM_VERSION    "$version"
setenv         FOAM_INST_DIR   "$base_dir"
setenv         FOAM_INIT       "$base_dir/OpenFOAM-$version/etc/bashrc"
setenv         FOAM_DOC_DIR    "$base_dir/OpenFOAM-$version/doc"
setenv         FOAM_EXA_DIR    "$base_dir/OpenFOAM-$version/tutorials"
setenv         FOAM_WWW        "http://www.openfoam.org"

set-alias      foamInit        "source $base_dir/OpenFOAM-$version/etc/bashrc"

set        loading     [module-info mode load]

if { $loading && ![ is-loaded mpi/openmpi/4.0-gnu-9.2 ] } {
    if { [ is-loaded "mpi" ] } {
        puts stderr "Unloading 'mpi'"
        module unload mpi
    }
    if { [ is-loaded "compiler" ] } {
        puts stderr "Unloading 'compiler'"
        module unload compiler
    }
puts stderr "Loading module dependency 'mpi/openmpi/4.0-gnu-9.2'"
module load mpi/openmpi/4.0-gnu-9.2
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
prereq mpi/openmpi/4.0-gnu-9.2
