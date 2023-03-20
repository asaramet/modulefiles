#%Module1.0
#
# Module:          cae/zeno/1.0
# Revision:        esbw00
# TargetSystem:    CentOS 6.6
# Priority:        mandatory
# 2ndLevelSupport: cluster-support@hs-esslingen.de
#
##### (A) Revision history:
#
# esbw00  First INSTALL

##### (B) Dependencies:
#
#####

set   version     "1.0"
set   base_dir    "/opt/bwhpc/common/cae/zeno/$version"

set mod_name [module-info name]
set mod_mode [module-info mode]

setenv        ZENO_VERSION          "$version"
setenv        ZENO_HOME             "$base_dir"
setenv        ZENO_MODELLE          "$base_dir/Modelle"

prepend-path  PATH                  "$base_dir/bin"

module-whatis   "ZENO version $version, in house mesh builder (c) Lautsch Finite Elemente GmbH"
