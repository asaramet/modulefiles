-- -*- lua -*-
--[==[
# Cluster:         bwUniCluster
# Module:          lib/netcdf/4.9.0-intel-2021.4
# Revision:        esbw01
# TargetSystem:    Red-Hat-Enterprise
# MainLocation:    /opt/bwhpc/common/lib/netcdf/4.9.0-intel-2021.4
# Status:          optional
# License:         GPL v3
# URL:             https://www.unidata.ucar.edu/software/netcdf/
# 2ndLevelSupport: cluster-support[at]hs-esslingen.de
# Date:            20220804 Alexandru Saramet
# InstallDoc:      scripts/install_netcdf.sh
### END COMMENTS
]==]--

local version = "4.9.0-intel-2021.4"
local base_dir = pathJoin("/opt/bwhpc/common/lib/netcdf", version)
local bin_dir = pathJoin(base_dir, "bin")
local lib_dir = pathJoin(base_dir, "lib")
local inc_dir = pathJoin(base_dir, "include")
local man_dir = pathJoin(base_dir, "share/man")

setenv("NETCDF_VERSION", version)
setenv("NETCDF_HOME", base_dir)

-- Defs for NETCDF:
setenv("NETCDF_BIN_DIR", bin_dir)
setenv("NETCDF_LIB_DIR", lib_dir)
setenv("NETCDF_INC_DIR", inc_dir)
setenv("NETCDF_MAN_DIR", man_dir)

-- Setup of PATH environment:
prepend_path("PATH", bin_dir)
prepend_path("LD_LIBRARY_PATH", lib_dir)
prepend_path("INCLUDE", inc_dir)
prepend_path("MANPATH", man_dir)

load("lib/hdf5/1.12.2-intel-2021.4")
conflict("lib/netcdf")

whatis("netcdf-c library version 4.9.0 for Intel compiler, with netcdf-cxx4 version 4.3.1 and netcdf-fortran version 4.5.4")

if ( mode() == "load" ) then
  LmodMessage("NetCDF "..version, "is loaded.")
end

if ( mode() == "unload" ) then
  LmodMessage("NetCDF"..version, "is unloaded")
end

help([[
NetCDF is a set of data formats, programming interfaces, and software libraries that help
read and write scientific data files. It provides data and software tools for use in
geoscience education and research.

The NetCDF C library package is provided as is and with all faults.
The provider does not give any warranties for any kind of inaccuracies
or errors in the results produced by NetCDF. The provider will not be
liable for any damages you may suffer in connection with using the NetCDF.

Documentation:   https://www.unidata.ucar.edu/software/netcdf/docs/
]])
