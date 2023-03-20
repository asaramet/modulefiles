#%Module1.0
#
# Module:          lib/netcdf/4.7.3-gnu-8.1
# Revision:        esbw01
# TargetSystem:    RHEL64
# Priority:        optional
# 2ndLevelSupport: cluster-support[at]hs-esslingen.de

set            version              "4.7.3-gnu-8.1"
set            base_dir             "/opt/bwhpc/common/lib/netcdf/$version"

setenv         NETCDF_VERSION         "$version"
setenv         NETCDF_HOME            "$base_dir"

# Defs for NETCDF:

setenv         NETCDF_BIN_DIR         "$base_dir/bin"
setenv         NETCDF_LIB_DIR         "$base_dir/lib64"
setenv         NETCDF_INC_DIR         "$base_dir/include"
setenv         NETCDF_MAN_DIR         "$base_dir/share/man"

# Setup of PATH environment:

prepend-path   PATH              "$env(NETCDF_BIN_DIR)"
prepend-path   LD_LIBRARY_PATH   "$env(NETCDF_LIB_DIR)"
prepend-path   INCLUDE           "$env(NETCDF_INC_DIR)"
prepend-path   MANPATH           "$env(NETCDF_MAN_DIR)"

module-whatis "NETCDF library and tools version $version for gnu/5.1"

if { [module-info mode] == "load" || [module-info mode] == "add" || [module-info mode] == "switch2" } {
  if { ! [is-loaded "compiler/gnu/8.1"] && "gnu/8.1" != "gnu/4.4" } {
    module load lib/hdf5/1.12.0-gnu-8.1
  }
  if { ! [is-loaded "compiler/gnu/8.1"] && "gnu/8.1" != "gnu/4.4" } {
    puts stderr "\nERROR: Failed to load module dependency 'compiler/gnu/8.1'. Please check conflicts with already loaded modules.\n";
    break
  }
}

proc ModulesHelp { } {
	global version env

	puts stderr "
NetCDF is a set of data formats, programming interfaces, and software libraries that help read and write scientific data files. It provides data and software tools for use in geoscience education and research.

The NetCDF C library package is provided as is and with all faults. The provider does not give any warranties for any kind of inaccuracies or errors in the results produced by NetCDF. The provider will not be liable for any damages you may suffer in connection with using the NetCDF.

Documentation:   https://www.unidata.ucar.edu/software/netcdf/docs/


This module should be available for all users (/opt/bwhpc/common).
"
}

# Conflicts and pre-requirements at end of file. Otherwise, "module help"
# will not work, if any of the dependencies fails (which is odd, since
# "module help" should help the user to solve problems like this one).
prereq  lib/hdf5/1.12.0-gnu-8.1
prereq  compiler/gnu/8.1
conflict lib/netcdf
