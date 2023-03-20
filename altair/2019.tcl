#%Module1.0
#
# Module:          cae/altair/2019
# Revision:        esbw00
# Priority:        optional
# TargetSystem:    RHEL6
# 2ndLevelSupport: cluster-support@hs-esslingen.de
#
#
##### Revision history:
#
# esbw00  17.09.2019  A.Saramet: initial revision
#
# install bin files:
# chmod u+x BINFILE.bin
# ./BINFILE.bin
#

set version   "2019"
set base_dir  "/opt/bwhpc/common/cae/altair/$version"


set           MODULEBIN           $base_dir/altair/scripts

setenv        MODULEBIN           $MODULEBIN

prepend-path  PATH             $MODULEBIN

module-whatis   "altair $version: Simulation Software"

proc ModulesHelp { } {
#        global env

        puts stderr " "
}
