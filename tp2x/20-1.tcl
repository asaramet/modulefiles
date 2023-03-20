#%Module1.0
#
# Module:          cae/tp2x/20-1
# Revision:        esbw00
# TargetSystem:    CentOS 6.6
# 2ndLevelSupport: cluster-support@hs-esslingen.de

set   version     "20-1"
set   base_dir    "/opt/bwhpc/es/cae/tp2x/TP2x_$version/Wtp2000"

set mod_name [module-info name]
set mod_mode [module-info mode]

setenv        FEM_Wtp2000            "$base_dir/Tp2x"
