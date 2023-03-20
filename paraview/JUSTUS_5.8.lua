-- -*- lua -*-
--[==[
# License:         BSD
# URL:             https://www.paraview.org
# Date:            20200921 Alexandru Saramet
### END COMMENTS
]==]--

local version = "5.8.1"
local base_dir = pathJoin("/opt/bwhpc/common/vis/paraview", version.."_impi-2019.7-intel-19.1-python-3.8.3")
local bin_dir = pathJoin(base_dir, "bin")
local doc_dir = pathJoin(base_dir, "share/doc")
local lib_dir = pathJoin(base_dir, "lib64")

setenv("PARAVIEW_VERSION", version)
setenv("PARAVIEW_INST_DIR", base_dir)
setenv("PARAVIEW_BIN_DIR", bin_dir)
setenv("PARAVIEW_DOC_DIR", doc_dir)
setenv("PARAVIEW_LIB_DIR", lib_dir)

prepend_path("PATH", bin_dir)
prepend_path("LD_LIBRARY_PATH", lib_dir)

depends_on("devel/python/3.8.3", "compiler/intel/19.1", "mpi/impi/2019.7")

conflict("cae/paraview")

whatis("Open Source Software ParaView version"..version)

if ( mode() == "load" ) then
  LmodMessage([[
Paraview version]],version,[[is now available
]])
end

if ( mode() == "unload" ) then
  LmodMessage("ParaView "..version, "is unloaded.")
end

help([[
ParaView is a tool for postprocessing/visualization of results (usually results from
simulations with OpenFoam). Also works for parallel postprocessing with Intel MPI

Usage possible after:
   module load cae/paraview/]],version,[[

You need to have installed locally and running an X-Client (e.g. XMing or MobaXterm are
suitable freeware tools) and to log-in on the uc1 with ssh username -X

Calling the programm with:
   paraview

Online documenation:
   www.paraview.org

]])
