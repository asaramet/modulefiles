-- -*- lua -*-
--[==[
# Cluster:         bwUniCluster
# Module:          cae/paraview/5.9
# Revision:        esbw01 08072021 Alexandru Saramet
# License:         BSD
# URL:             https://www.paraview.org
# 2ndLevelSupport: cluster-support[at]hs-esslingen.de
### END COMMENTS
]==]--

local version = "5.9.1"
local base_dir = pathJoin("/opt/bwhpc/common/cae/paraview", version)
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

depends_on("numlib/python_numpy/1.19.1_python_3.8.6_intel_19.1","mpi/impi/2020")

conflict("cae/paraview")

whatis("Open Source Software ParaView version"..version)

if ( mode() == "load" ) then
  LmodMessage([[
Paraview version]],version,[[is now available"

>>> NOTICE: <<<
To run Paraview using VNC system is required on the bwUniCluster.
Run 'start_vnc_desktop --hw-rendering' and start your VNC client on your desktop PC.
Information for remote visualization on KIT HPC system is available on:
https://wiki.scc.kit.edu/hpc/index.php/Remote_Visualization

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
