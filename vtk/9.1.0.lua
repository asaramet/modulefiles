-- -*- lua -*-
--[==[
# Module:          vis/vtk/9.1.0
# Revision:        esbw01 20211207 Alexandru Saramet
# License:         GPL v3
# URL:             https://www.openfoam.org
# 2ndLevelSupport: cluster-support[at]hs-esslingen.de
### END COMMENT
]==]--

local version = "9.1.0"
local base_dir = pathJoin("/opt/bwhpc/common/vis/vtk", version)
local bin_dir = pathJoin(base_dir, "bin")
local lib_dir = pathJoin(base_dir, "lib64")
local inc_dir = pathJoin(base_dir, "include")

depends_on("compiler/gnu/10.2", "mpi/openmpi/4.0")
conflict("vis/vtk")

prepend_path("PATH", bin_dir)
prepend_path("LD_LIBRARY_PATH", lib_dir)
prepend_path("INCLUDE", inc_dir)

setenv("VTK_BIN_DIR", bin_dir)
setenv("VTK_LIB_DIR", lib_dir)
setenv("VTK_INC_DIR", inc_dir)
setenv("VTK_HOME", base_dir)

whatis("VTK library and tools version "..version, "for compiler/gnu/10.2 and mpi/openmpi/4.0")

if ( mode() == "unload" ) then
  LmodMessage("VTK", version, "is unloaded")
end

help([[
The Visualization Toolkit (VTK) is an open-source, freely available software system for 3D
computer graphics, modeling, image processing, volume rendering, scientific visualization,
and 2D plotting. It supports a wide variety of visualization algorithms and advanced modeling
techniques, and it takes advantage of both threaded and distributed memory parallel processing
for speed and scalability, respectively.

Documentation: https://www.vtk.org/documentation
]])
