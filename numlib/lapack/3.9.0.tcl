#%Module1.0
# Module:          numlib/lapack/3.9.0
# Revision:        esbw00
# Priority:        optional
# TargetSystem:    CentOS6.6
# 2ndLevelSupport: cluster-support[at]hs-esslingen.de
#
set version   "3.9.0"
set base_dir  "/opt/bwhpc/common/numlib/lapack/3.9.0"

setenv        BLAS       $base_dir/lib/libblas.a
setenv        LAPACK     $base_dir/lib/liblapack.a
prepend-path  LD_LIBRARY_PATH  $base_dir/lib

module-whatis   "lapack $version: Linear Algebra PACKage "

if { [module-info mode] == "load" } {
    puts stderr "lapack $version: has been loaded.\nLinear Algebra PACKage "
}

proc ModulesHelp { } {
#        global env

        puts stderr "
    Linear Algebra PACKage
    lapack (Version 3.9.0)
    see http://www.netlib.org/lapack"
}
