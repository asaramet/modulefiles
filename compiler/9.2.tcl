#%Module1.0
#
# Module:          compiler/gnu/9.2
# Revision:        esbw01
# TargetSystem:    RHEL64
# Priority:        optional
# 2ndLevelSupport: cluster-support@hs-esslingen.de

set              version           "9.2.0"
set              base_dir          "/opt/bwhpc/common/compiler/gnu/$version"

# Defs for GNU compiler:

setenv       GNU_VERSION       "$version"
setenv       GNU_HOME          "$base_dir"
setenv       GNU_BIN_DIR       "$base_dir/bin"
setenv       GNU_MAN_DIR       "$base_dir/share/man"
setenv       GNU_LIB64_DIR     "$base_dir/lib64"
setenv       GNU_LIB_DIR       "$base_dir/lib/gcc/x86_64-pc-linux-gnu/$version"
setenv       GNU_PLUGIN_DIR    "$base_dir/lib/gcc/x86_64-pc-linux-gnu/$version/plugin"
setenv       GNU_EXEC_DIR      "$base_dir/libexec/gcc/x86_64-pc-linux-gnu/$version"
setenv       GNU_INCLUDE_DIR   "$base_dir/include/c++/$version"

prepend-path     PATH              "$env(GNU_BIN_DIR)"
prepend-path     MANPATH           "$env(GNU_MAN_DIR)"
prepend-path     LD_LIBRARY_PATH   "$env(GNU_EXEC_DIR)"
prepend-path     LD_LIBRARY_PATH   "$env(GNU_PLUGIN_DIR)"
prepend-path     LD_LIBRARY_PATH   "$env(GNU_LIB_DIR)"
prepend-path     LD_LIBRARY_PATH   "$env(GNU_LIB64_DIR)"
prepend-path     INCLUDE           "$env(GNU_PLUGIN_DIR)/include"
prepend-path     INCLUDE           "$env(GNU_LIB_DIR)/include"
prepend-path     INCLUDE           "$env(GNU_INCLUDE_DIR)"

setenv       CC                  gcc
setenv       CXX                 g++
setenv       F77                 gfortran
setenv       FC                  gfortran
setenv       F90                 gfortran

module-whatis    "GNU compiler suite version $version (gcc, g++, gfortran, gcj, gccgo)"

proc ModulesHelp { } {
        global env

        puts stderr "
This module provides the GNU compiler suite version $env(GNU_VERSION) via commands
gcc, g++, gfortran and gcj (Java). The GNU compiler has been build with
new versions of the libraries gmp, mpfr and mpc.

cpp      - GNU pre processor
gcc      - GNU C compiler
g++      - GNU C++ compiler
gfortran - GNU Fortran compiler (Fortran 77, 90 and 95)
gcj      - GNU Java compiler
gccgo    - GNU Google's Go language

Libraries can be found in
  \$GNU_HOME/lib64 = $env(GNU_HOME)/lib64
Sometimes one requires in addition some libraries in
  \$GNU_HOME/lib   = $env(GNU_HOME)/lib

Local documentation:
  See commands 'man cpp', 'man gcc', 'man g++' and 'man gfortran'.

Online documentation:
  http://gcc.gnu.org/onlinedocs/

For details on library and include dirs please call
    module show [module-info name]

The man pages, environment variables and compiler commands
are available after loading '[module-info name]'.

ATTENTION: gcc version $env(GNU_VERSION) changed the default debugging format
to DWARF-4. Therefore You will need to use newer versions of the GNU Debugger, e.g.
  module load devel/gdb/7.7
or by compiling with an older debugging format using -g -gdwarf-3.
Further information is available on:
  http://gcc.gnu.org/gcc-7.3/changes.html
"
}

conflict compiler/gnu
