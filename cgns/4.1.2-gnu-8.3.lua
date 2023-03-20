--[==[
# Module:          cae/cgns/4.1.2-gnu-8.3
# Revision:        esbw01
# License:         Free
# URL:             https://cgns.github.io
# 2ndLevelSupport: cluster-support[at]hs-esslingen.de
### END COMMENTS
]==]--

local version = "4.1.2"
local base_dir = pathJoin("/opt/bwhpc/common/cae/cgns", version.."-gnu-8.3")
local bin_dir = pathJoin(base_dir, "bin")
local lib_dir = pathJoin(base_dir, "lib")
local inc_dir = pathJoin(base_dir, "include")

setenv("CGNS_VERSION", version)
setenv("CGNS_HOME", base_dir)

setenv("CGNS_BIN_DIR", bin_dir)
setenv("CGNS_LIB_DIR", lib_dir)
setenv("CGNS_STA_DIR", lib_dir)
setenv("CGNS_SHA_DIR", lib_dir)
setenv("CGNS_INC_DIR", inc_dir)
setenv("CGNS_WWW", "http://cgns.github.io")

prepend_path("PATH", bin_dir)
prepend_path("LD_LIBRARY_PATH", lib_dir)
prepend_path("INCLUDE", inc_dir)

depends_on("lib/hdf5/1.12.0-gnu-8.3")

conflict("cae/cgns")

whatis("CGNS library and tools version "..version.." for GNU Compiler 8.3")

help([[
 The CFD General Notation System (CGNS) provides a general, portable,
 and extensible standard for the storage and retrieval of computational
 fluid dynamics (CFD) analysis data. It consists of a collection of conventions,
 and free and open software implementing those conventions. It is self-descriptive,
 machine-independent, well-documented, and administered by an international
 steering committee. It is also an American Institute of Aeronautics
 and Astronautics (AIAA)
]])
