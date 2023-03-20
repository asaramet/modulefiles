-- -*- lua -*-
--[==[
# Module:          lib/cgal/5.2-gnu-11.1.0
# Revision:        esbw01 20210507 Alexandru Saramet
# License:         GPL v3
# URL:             https://www.openfoam.org
# 2ndLevelSupport: cluster-support[at]hs-esslingen.de
### END COMMENT
]==]--

local version = "5.2"
local folder = version.."-gnu-11.1.0"
local base_dir = pathJoin("/opt/bwhpc/common/lib/cgal", folder)
local lib_dir = pathJoin(base_dir, "lib64")
local inc_dir = pathJoin(base_dir, "include")
local man_dir = pathJoin(base_dir, "share/man")

depends_on("compiler/gnu/11.1")
conflict("lib/cgal")

prepend_path("LD_LIBRARY_PATH", lib_dir)
prepend_path("INCLUDE", inc_dir)
prepend_path("MANPATH", man_dir)

setenv("CGAL_LIB_DIR", lib_dir)
setenv("CGAL_INC_DIR", inc_dir)
setenv("CGAL_HOME", base_dir)

whatis("CGAL library and tools version "..version, "for compiler/gnu/10.2")

if ( mode() == "unload" ) then
  LmodMessage("CGAL", version, "is unloaded")
end

help([[
CGAL is a software project that provides easy access to efficient and reliable geometric
algorithms in the form of a C++ library. CGAL is used in various areas needing geometric
computation, such as geographic information systems, computer aided design, molecular
biology, medical imaging, computer graphics, and robotics.

The library offers data structures and algorithms like triangulations, Voronoi diagrams,
Boolean operations on polygons and polyhedra, point set processing, arrangements of curves,
surface and volume mesh generation, geometry processing, alpha shapes, convex hull
algorithms, shape reconstruction, AABB and KD trees...

Documentation: https://www.cgal.org/documentation.html
]])
