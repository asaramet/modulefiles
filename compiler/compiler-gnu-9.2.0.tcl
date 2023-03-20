#%Module1.0
#
# Module:          compiler/gnu/9.2.0
# Revision:        esbw01
# TargetSystem:    RHEL64
# Priority:        optional
# 2ndLevelSupport: cluster-support@hs-esslingen.de
#
##### Revision history:
#
# ulbw05 110210 c.mosch Initial revision of module
# esbw01 130515 a.reber Based on compiler/gnu/4.5.2
# esbw02 130924 a.saramet Based on compiler/gnu/4.8.0
# esbw03 130924 r.keller Based on compiler/gnu/4.8.1 Adaptations to include Google Go, ADA and java
# esbw05 140428 a.reber Update to 4.9.0
# esbw06 140717 r.keller Update to 4.9.1
# esbw07 150905 r.doros Update to 5.2.0
# hsbw01 170712 r.doros Update to 7.1.0
# hsbw01 180912 r.keller Update to 8.2.0
# esbw01 190508 r.keller Update to 9.1.0
# esbw01 191011 r.keller Update to 9.2.0
#
# * Fri Oct 11 2019 Rainer Keller <rainer.keller@hs-esslingen.de> - 9.2.0-1
# - upgraded to 9.2.0, no subprojet changed
# 
# * Wed May 08 2019 Rainer Keller <rainer.keller@hs-esslingen.de> - 9.1.0-1
# - upgraded to 9.1.0 including the sub-projects (gmp, and isl)
#   while, isl-0.20 previously did not work, isl-0.21 released in Mar 2019 works.
# 
# * Wed Sep 12 2018 Rainer Keller <rainer.keller@hs-esslingen.de> - 8.2.0-1
# - upgraded to 8.2.0 including all the sub-projects (gmp, mpfr, mpc, isl)
#   please note, isl-0.20 does not work due to missing symbols; use isl-0.19
#   Added the just-in-time compilation "language" called jit, this requires --enable-host-shared.
#   Amend documentation of flags: remove configure-flags, that do not do anything,
#   i.e. remove  --with-tune=generic, --enable-shared and --with-ppl
#   Fix a bug in the cleanup OPT_FLAGS, the lines were not properly ended using apostrophe
# 
# * Thu Mar 22 2018 Michael Janczyk <mj0@uni-freiburg.de> - 7.3.0-1
# - update to gcc 7.3, mpfr 4.0.1, mpc 1.1.0
# 
# * Mon Jun 26 2017 Rafael Doros <rafael.doros@hft-stuttgart.de> - 7.1.0-3
# - add isl version number to module file
# 
# * Thu Jun 22 2017 Rafael Doros <rafael.doros@hft-stuttgart.de> - 7.1.0-2
# - update isl version to 0.18
# - change download source for isl from gcc to project site
# - add isl manual.pdf 
# 
# * Mon Jun 12 2017 Rafael Doros <rafael.doros@hft-stuttgart.de> - 7.1.0-1
# - upgraded to 7.1.0
# 
#
# rpmbuild -ba gcc-9.2.spec
#  or
# make gcc-9.2
 
## Define procedure "set_envVAR" to work around a module-unload-load bug (optional):

# Exported environment variables, which do not change their values,
# disappear after an automatic unload and load sequence within a module file.
# This is most likely a bug in the modules environment. Unchanged
# variables are not re-exported upon load in an automatic unload-load
# sequence. The workaround is to "unset" the variable in the right moment
# (so the load of the unload-load-chain can set the variable again)
# and, in addition, to set the environment variable explicitly.

proc set_envVAR {envVAR VARcontent} {
    # Use global function env:
    global env
    # Unset envVAR explicitly:
    if { [info exists env($envVAR)] } {
        catch {
            unset env($envVAR)
        }
    }
    # Call overloaded module command setenv:
    setenv $envVAR $VARcontent
    # Set envVAR explicitly:
    set env([set envVAR]) $VARcontent
}


# Base defs:

set              version           "9.2.0"
set              base_dir          "/opt/bwhpc/common/compiler/gnu/$version"

# Defs for GNU compiler:

set_envVAR       GNU_VERSION       "$version"
set_envVAR       GNU_HOME          "$base_dir"
set_envVAR       GNU_BIN_DIR       "$base_dir/bin"
set_envVAR       GNU_MAN_DIR       "$base_dir/man"
set_envVAR       GNU_LIB_DIR       "$base_dir/lib64"
set_envVAR       GNU_LIB_DIR2      "$base_dir/lib"

prepend-path     PATH              "$env(GNU_BIN_DIR)"
prepend-path     MANPATH           "$env(GNU_MAN_DIR)"
prepend-path     LD_LIBRARY_PATH   "$env(GNU_LIB_DIR):$env(GNU_LIB_DIR2)"

# rk: 2014-07-17: Tell configure, make and cmake which compiler to use:
# (request by Robert Barthel, Karlsruhe)
set_envVAR       CC                  gcc
set_envVAR       CXX                 g++
set_envVAR       F77                 gfortran
set_envVAR       FC                  gfortran
set_envVAR       F90                 gfortran

module-whatis    "GNU compiler suite version $version (gcc, g++, gfortran, gccgo)"


proc ModulesHelp { } {
        global env

        puts stderr "
This module provides the GNU compiler collection version $env(GNU_VERSION) via commands
gcc, g++ and gfortran. The GNU compiler has been build with the libraries 
gmp (6.1.2), mpfr (4.0.2), mpc (1.1.0) and isl (0.21).

cpp      - GNU pre processor
gcc      - GNU C compiler
g++      - GNU C++ compiler
gfortran - GNU Fortran compiler (Fortran 95/2003/2008 plus legacy Fortran 77)
gccgo    - GNU Google's Go language

Libraries can be found in
  \$GNU_HOME/lib64 = $env(GNU_HOME)/lib64
One may require additionally libraries installed in
  \$GNU_HOME/lib   = $env(GNU_HOME)/lib

Local documentation:
  See commands 'man cpp', 'man gcc', 'man g++' and 'man gfortran'.

Online documentation:
  https://gcc.gnu.org/onlinedocs/

For details on library and include dirs please call
    module show [module-info name]

The man pages, environment variables and compiler commands
are available after loading '[module-info name]'.

The full version is: 9.2.0

"
}

# Conflicts and prereqirements at end of file. Otherwise, "module help"
# will not work, if any of the dependencies failes (which is odd, since
# "module help" should help the user to solve problems like this one).
conflict compiler/gnu
# prereq   category/name/version

