-- -*- lua -*-
--[==[
# Module:          lib/scotch/6.1-icc-19.1-impi-2020
# Revision:        esbw01 20210701 Alexandru Saramet
# License:         GPL v3
# URL:             https://gforge.inria.fr/projects/scotch
# 2ndLevelSupport: cluster-support[at]hs-esslingen.de
### END COMMENT
]==]--

local version = "6.1"
local folder = version.."-icc-19.1-impi-2020"
local base_dir = pathJoin("/opt/bwhpc/common/lib/scotch", folder)
local bin_dir = pathJoin(base_dir, "bin")
local lib_dir = pathJoin(base_dir, "lib")
local inc_dir = pathJoin(base_dir, "include")
local man_dir = pathJoin(base_dir, "share/man")
local doc_dir = pathJoin(base_dir, "bwhpc-examples")

depends_on("compiler/intel/19.1", "mpi/impi/2020")
conflict("lib/scotch")

prepend_path("PATH", bin_dir)
prepend_path("LD_LIBRARY_PATH", lib_dir)
prepend_path("INCLUDE", inc_dir)
prepend_path("MANPATH", man_dir)

setenv("SCOTCH_BIN_DIR", bin_dir)
setenv("SCOTCH_LIB_DIR", lib_dir)
setenv("SCOTCH_INC_DIR", inc_dir)
setenv("SCOTCH_HOME", base_dir)
setenv("SCOTCH_DOC", doc_dir)

whatis("SCOTCH library and tools version "..version, "for compiler/intel/19.1")

if ( mode() == "load" ) then
  LmodMessage("SCOTCH", version, "is loaded.")
end

if ( mode() == "unload" ) then
  LmodMessage("SCOTCH", version, "is unloaded")
end

help([[
Scotch is a software package for graph and mesh/hypergraph partitioning, graph clustering,
and sparse matrix ordering

Official Website: https://gforge.inria.fr/projects/scotch

Documentation and examples in:]], doc_dir)
