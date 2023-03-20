-- -*- lua -*-
--[==[
# Cluster:         bwUniCluster
# Module:          compiler/gnu/10.1.0
# Revision:        esbw01
# TargetSystem:    Red-Hat-Enterprise
# MainLocation:    /opt/bwhpc/common/cae/openfoam/7
# Status:          optional
# License:         GPL v3
# URL:             https://gcc.gnu.org
# 2ndLevelSupport: cluster-support[at]hs-esslingen.de
# Date:            20200621 Rainer Keller
# InstallDoc:      modulefiles/gcc-10.1.spec
### END COMMENTS
]==]--

local version = "10.1.0"
local base_dir = pathJoin("/opt/bwhpc/common/compiler/gnu", version)
local bin_dir = pathJoin(base_dir, "bin")
local lib_dir = pathJoin(base_dir, "lib")
local lib64_dir = pathJoin(base_dir, "lib64")

-- updated / extra variables
local man_dir = pathJoin(base_dir, "share", "man")
local lib_ex_dir = pathJoin(lib_dir, "gcc", "x86_64-pc-linux-gnu", version)
local plugin_dir = pathJoin(lib_ex_dir, "plugin")
local exec_dir = pathJoin(base_dir, "libexec", "gcc", "x86_64-pc-linux-gnu", version)
local include_dir = pathJoin(base_dir, "include")
local include_ex_dir = pathJoin(include_dir, "c++", version)

-- Defs for GNU compiler:
setenv("GNU_VERSION", version)
setenv("GNU_HOME", base_dir)
setenv("GNU_BIN_DIR", bin_dir)
setenv("GNU_MAN_DIR", man_dir)
setenv("GNU_LIB_DIR", lib64_dir)
setenv("GNU_LIB_DIR2", lib_dir)

prepend_path("PATH", bin_dir)
prepend_path("MANPATH", man_dir)
prepend_path("LD_LIBRARY_PATH", lib64_dir)
prepend_path("LD_LIBRARY_PATH", lib_dir)

-- extra paths
append_path("LD_LIBRARY_PATH", exec_dir)
append_path("LD_LIBRARY_PATH", lib_ex_dir)
append_path("LD_LIBRARY_PATH", plugin_dir)
prepend_path("INCLUDE", pathJoin(plugin_dir, "include"))
prepend_path("INCLUDE", pathJoin(lib_ex_dir, "include"))
prepend_path("INCLUDE", include_ex_dir)
prepend_path("INCLUDE", include_dir)

pushenv("CC", "gcc")
pushenv("CXX", "g++")
pushenv("F77", "gfortran")
pushenv("FC", "gfortran")
pushenv("F90", "gfortran")

conflict("compiler/gnu")

whatis("GNU compiler suite version "..version.." (gcc, g++, gfortran, gccgo)")

help([[

This module provides the GNU compiler collection version $env(GNU_VERSION) via commands
gcc, g++ and gfortran. The GNU compiler has been build with the libraries
gmp (6.2.0), mpfr (4.0.2a), mpc (1.1.0) and isl (0.22.1).
This compiler supports offloating OpenACC and OpenMP to NVIDIA CUDA using -foffload.

cpp      - GNU pre processor
gcc      - GNU C compiler
g++      - GNU C++ compiler
gfortran - GNU Fortran compiler (Fortran 95/2003/2008 plus legacy Fortran 77)
gccgo    - GNU Google's Go language

Libraries can be found in
  $GNU_HOME/lib64 = ]],base_dir,[[/lib64
One may require additionally libraries installed in
  $GNU_HOME/lib   = ]],base_dir,[[/lib

Local documentation:
  See commands 'man cpp', 'man gcc', 'man g++' and 'man gfortran'.

Online documentation:
  https://gcc.gnu.org/onlinedocs/

For details on library and include dirs please call
    module show [module-info name]

The man pages, environment variables and compiler commands
are available after loading '[module-info name]'.

The full version is: 10.1.0

]])

-- Add modules build for this compiler implementation
local      module_version = myModuleVersion()
local    module_full_name = myModuleName()
local _, module_name      = splitFileName(module_full_name)
local cluster=os.getenv("CLUSTER") or ""
if ( cluster == "fh2" or cluster == "fhc" or
     cluster == "fh1" or cluster == "fhb" ) then
    prepend_path("MODULEPATH", pathJoin("/software/all/lmod/modulefiles/Compiler", module_name, module_version));
end
if ( cluster == "uc2" or cluster == "ucc" or cluster == "uc1" ) then
    prepend_path("MODULEPATH", pathJoin("/software/bwhpc/common/modulefiles/Compiler", module_name, module_version));
end
-- Set module family
family("compiler")
