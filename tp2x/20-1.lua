-- -*- lua -*-
--[==[
# Cluster:         bwUniCluster
# Module:          es/cae/tp2x/20-1
# Revision:        esbw01
# TargetSystem:    Red-Hat-Enterprise
# MainLocation:    /opt/bwhpc/es/cae/tp2x/20-1
# Status:          optional
# License:         Private
# 2ndLevelSupport: cluster-support[at]hs-esslingen.de
# Date:            20200722 Alexandru Saramet
### END COMMENTS
]==]--

local version = "20-1"
local base_dir = pathJoin("/opt/bwhpc/es/cae/tp2x", "TP2x_"..version, "Wtp2000")

setenv("FEM_Wtp2000", pathJoin(base_dir, "TP2x"))
