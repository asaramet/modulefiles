-- -*- lua -*-
--[==[
# Cluster:         bwUniCluster
# Module:          lib/netcdf/4.7.3-intel-19.1
# Revision:        esbw01
# TargetSystem:    Red-Hat-Enterprise
# MainLocation:    /opt/bwhpc/common/lib/netcdf/4.7.3-intel-19.1
# Status:          optional
# License:         GPL v3
# URL:             https://www.unidata.ucar.edu/software/netcdf/
# 2ndLevelSupport: cluster-support[at]hs-esslingen.de
# Date:            20200319 Alexandru Saramet
# InstallDoc:      scripts/install_netcdf.sh
### END COMMENTS
]==]--

local version = "4.7.3-gnu-8.1"
local base_dir = pathJoin("/opt/bwhpc/common/lib/netcdf", version)
local bin_dir = pathJoin(base_dir, "bin")
local lib_dir = pathJoin(base_dir, "lib64")
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

depends_on("compiler/intel/19.1", "lib/hdf5/1.12.0-intel-19.1")
conflict("lib/netcdf")

whatis("NETCDF library and tools version "..version, "for compiler/intel/19.1")

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
