#%Module1.0
#
# Module:          mpi/openmpi/4-gnu-9
# Revision:        esbw01
# TargetSystem:    RHEL64
# Priority:        optional
# 2ndLevelSupport: cluster-support[at]hs-esslingen.de

set              version           "4.0.4-gnu-9"
set              base_dir          "/opt/bwhpc/common/mpi/openmpi/$version"

setenv           MPI_VERSION       "$version"
setenv           MPI_HOME          "$base_dir"
setenv           MPIDIR            "$base_dir"

# Defs for Open MPI:

setenv           MPI_BIN_DIR       "$base_dir/bin"
setenv           MPI_LIB_DIR       "$base_dir/lib"
setenv           MPI_LIB_OMP_DIR   "$base_dir/lib/openmpi"
setenv           MPI_LIB_PMI_DIR   "$base_dir/lib/pmix"
setenv           MPI_INC_DIR       "$base_dir/include"
setenv           MPI_INC_OMP_DIR   "$base_dir/include/openmpi"
setenv           MPI_MAN_DIR       "$base_dir/share/man"

# Setup of PATH environment:

prepend-path     PATH              "$env(MPI_BIN_DIR)"
prepend-path     LD_LIBRARY_PATH   "$env(MPI_LIB_PMI_DIR)"
prepend-path     LD_LIBRARY_PATH   "$env(MPI_LIB_OMP_DIR)"
prepend-path     LD_LIBRARY_PATH   "$env(MPI_LIB_DIR)"
prepend-path     MANPATH           "$env(MPI_MAN_DIR)"
prepend-path     INCLUDE           "$env(MPI_INC_OMP_DIR)"
prepend-path     INCLUDE           "$env(MPI_INC_DIR)"

module-whatis    "OpenMPI bindings (mpicc mpicxx mpifort) version $version for gnu/9.2"

if { [module-info mode] == "load" || [module-info mode] == "add" || [module-info mode] == "switch2" } {
  if { ! [is-loaded "compiler/gnu/9"] && "gnu/9" != "gnu/4.4" } {
    puts stderr "Loading module dependency 'compiler/gnu/9'."
    module load "compiler/gnu/9"
  }
  if { ! [is-loaded "compiler/gnu/9"] && "gnu/9" != "gnu/4.4" } {
    puts stderr "\nERROR: Failed to load module dependency 'compiler/gnu/9'. Please check conflicts with already loaded modules.\n";
    break
  }
}

proc ModulesHelp { } {
        global env

        puts stderr "
This module provides the Open MPI Message Passing Interface bindings (mpicc,
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

  Frequently one needs '-I\${MPI_INC_DIR}' in addition.

The MPI-libraries can be found in

  \$MPI_LIB_DIR

Example for compiling an MPI program with Open MPI:

  module load [module-info name]
  mpicc   -O3 mpi_application.c   -o mpi_application.exe # for C programs
  mpicxx  -O3 mpi_application.cxx -o mpi_application.exe # for C++ programs
  mpifort -O3 mpi_application.f   -o mpi_application.exe # for Fortran programs
  # GNU: Optimization level '-O3' results in substantially faster executables.
  For additional help see 'http://www.open-mpi.org/faq/?category=mpi-apps'.

Example for executing the MPI program using 4 cores on the local node:

  module load [module-info name]
  mpirun -np 4 `pwd`/mpi_application.exe

Example PBS snippet for submitting the program on 2 x 8 = 16 cores:

  #PBS -l nodes=2:ppn=8
  module load [module-info name]
  mpirun \$PBS_O_WORKDIR/mpi_application.exe

The mpirun command automatically determines the number of workers
and the hosts for the workers via PBS-TM and/or \$PBS_NODEFILE.

For details on library and include directories please call
    module show [module-info name]

The man pages, environment variables and compiler commands
are available after loading '[module-info name]'.

In case of problems, please contact '<cluster-support@hs-esslingen.de>'.

"
}

# Conflicts and pre-requirements at end of file. Otherwise, "module help"
# will not work, if any of the dependencies fails (which is odd, since
# "module help" should help the user to solve problems like this one).
conflict mpi/impi
conflict mpi/mvapich
conflict mpi/mvapich2
conflict mpi/openmpi
