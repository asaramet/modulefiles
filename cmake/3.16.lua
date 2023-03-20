-- -*- lua -*-
--[==[
# Cluster:         bwUniCluster
# Module:          devel/cmake/3.16.4
# Revision:        esbw01
# TargetSystem:    Red-Hat-Enterprise
# MainLocation:    /opt/bwhpc/common/devel/cmake/3.16.4
# Status:          optional
# License:         BSD 3-clause
# URL:             https://www.cmake.org
# 2ndLevelSupport: cluster-support[at]hs-esslingen.de
# Date:            20200228 Alexandru Saramet
# InstallDoc:      scripts/cmake-install.sh
### END COMMENTS
]==]--

local version = "3.16.4"
local base_dir = pathJoin("/opt/bwhpc/common/devel/cmake", version)
local bin_dir = pathJoin(base_dir, "bin")
local doc_dir = pathJoin(base_dir, "doc")

setenv("CMAKE_VERSION", version)
setenv("CMAKE_HOME", base_dir)
setenv("CMAKE_BIN_DIR", bin_dir)
setenv("CMAKE_DOC_DIR", doc_dir)

prepend_path("PATH", bin_dir)

conflict("devel/cmake")

whatis("CMake, a cross-platform open-source build system (version"..version..")")

help([[
Home page:            https://www.cmake.org
Online Documentation: https://www.cmake.org/HTML/Documentation.html
Local Documentation:  ]],doc_dir,[[
FAQ:                  https://gitlab.kitware.com/cmake/community/wikis/FAQ

In case of problems, please contact 'bwunicluster-hotline (at) lists.kit.edu'
or submit a trouble ticket at http://www.support.bwhpc-c5.de.
]])
