-- -*- lua -*-
--[==[
# Cluster:         bwUniCluster
# Module:          mpi/openmpi/4.0.3rc3-gnu-9.2
# Revision:        esbw11
# TargetSystem:    RHEL64
# MainLocation:    /opt/bwhpc/common/mpi/openmpi/4.0.3rc3-gnu-9.2
# Status:          optional
# 2ndLevelSupport: cluster-support[at]hs-esslingen.de
# License:         BSD-3-Clause
# URL:             https://www.open-mpi.org/
# Date:            20200224 Rainer Keller
# InstallDoc:      modulefiles/openmpi-4.0.spec
### END COMMENTS
]==]--

local version  = "4.0.3rc3-gnu-9.2"
local base_dir = pathJoin("/opt/bwhpc/common/mpi/openmpi", version)
local bin_dir = pathJoin(base_dir, "bin")
local lib_dir = pathJoin(base_dir, "lib")
local lib64_dir = pathJoin(base_dir, "lib64")
local man_dir = pathJoin(base_dir, "share/man")
local inc_dir = pathJoin(base_dir, "include")

setenv("MPI_VERSION", version)
setenv("MPI_HOME", base_dir)
setenv("MPIDIR", base_dir)

-- Defs for Open MPI:

setenv("MPI_BIN_DIR", bin_dir)
setenv("MPI_LIB_DIR", lib_dir)
setenv("MPI_LIB64_DIR", lib64_dir)
setenv("MPI_INC_DIR", inc_dir)
setenv("MPI_MAN_DIR", man_dir)
setenv("MPI_EXA_DIR", pathJoin(base_dir, "examples"))

-- Setup of PATH environment:

prepend_path("PATH", bin_dir)
prepend_path("LD_LIBRARY_PATH", lib64_dir)
prepend_path("LD_LIBRARY_PATH", lib_dir)
prepend_path("MANPATH", man_dir)

load("compiler/gnu/9.2")

conflict("mpi/impi")
conflict("mpi/mvapich")
conflict("mpi/mvapich2")
conflict("mpi/openmpi")

whatis("OpenMPI bindings (mpicc mpicxx mpifort) version "..version.."for gnu/9.2")

help([[This module provides the Open MPI Message Passing Interface bindings (mpicc,
mpicxx, mpifort (mpif77 and mpif90)). The corresponding compiler suite
(gnu/9.2) module should (and automatically will) be loaded first.

Documentation:

  See man pages of mpicc, mpicxx, mpifort (mpif77, mpif90) and mpirun,
  e.g. 'man mpicc'.
  For additional help see 'http://www.open-mpi.org/faq/'.

Compiling and executing MPI-programs:

  Instead of the usual compiler commands, you should compile and link your
  mpi-program with mpicc, mpicxx, mpifort (mpif77 and mpif90). What e.g.
  'mpicc' is really doing can be displayed via command 'mpicc -show'.

  Frequently one needs '-I]],inc_dir,[[ in addition.

The MPI-libraries can be found in

  ]],lib_dir,[[


Example for compiling an MPI program with Open MPI:

  module load [module-info name]
  mpicc   -O2 mpi_application.c   -o mpi_application.exe # for C programs
  mpicxx  -O2 mpi_application.cxx -o mpi_application.exe # for C++ programs
  mpifort -O2 mpi_application.f   -o mpi_application.exe # for Fortran programs
  # GNU: Optimization level '-O2' results in substantially faster executables.
  For additional help see 'http://www.open-mpi.org/faq/?category=mpi-apps'.

Example for executing the MPI program using 4 cores on the local node:

  module load [module-info name]
  mpirun -np 4 `pwd`/mpi_application.exe

Open MPI offers an abundance on parameters using the MCA. For more
information, check ompi_info using:
  ompi_info --param all all --level 9

Good examples of mpirun's parameters are:
  mpirun -np 4 --report-bindings --mca pml ucx mpi_application

For details on library and include directories please call
    module show [module-info name]

The man pages, environment variables and compiler commands
are available after loading '[module-info name]'.

In case of problems, submit a trouble ticket at 'https://bw-support.scc.kit.edu'.

The full version is: 4.0.3rc3-gnu-9.2

]])

-- Add modules build for this MPI implementation
local    module_version   = myModuleVersion()
local    module_full_name = myModuleName()
local _, module_name      = splitFileName(module_full_name)

-- Get compiler name and version
local hierA = hierarchyA( myModuleFullName() , 1)
local compiler_version = hierA[1]:gsub("^.*/([^/]+)$",       "%1" )
local compiler_name    = hierA[1]:gsub("^.*/([^/]+)/[^/]+$", "%1" )

prepend_path("MODULEPATH", pathJoin("/software/bwhpc/common/modulefiles_prepend/MPI", compiler_name, compiler_version ,module_name, module_version));
