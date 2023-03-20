#%Module1.0
#
# Module:          cae/ansys/2019R3
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
#   Ansys has built in mpi. Until now we did not had any problems with it.
#
#   Don't forget to login with '-XC' option
#   All the products should be installed in:
#   '/opt/bwhpc/common/cae/ansys/2019R3/ansys_inc' folder
#
#####

set   version     "2019R3"
set   short       "195"
set   base_dir    "/opt/bwhpc/common/cae/ansys/$version/ansys_inc"
set   awp_root    "$base_dir/v$short"

set mod_name [module-info name]
set mod_mode [module-info mode]

setenv        FLUENT_SKIP_SSH_CHECK  "1"
setenv 	      MPI_REMSH		           "/usr/bin/ssh"
setenv        LC_ALL                 "C"

setenv        ANSYS_VERSION          "$version"
setenv        ANSYS_HOME             "$base_dir"
setenv        ANSYS_WWW              "http://www.ansys.com/"
setenv        "AWP_ROOT$short"       "$awp_root"
setenv        ANSYS_LOCK             "ON"

prepend-path  LD_LIBRARY_PATH        "$awp_root/ACP"
prepend-path  LD_LIBRARY_PATH        "$awp_root/aisol/lib/linx64"
prepend-path  LD_LIBRARY_PATH        "$awp_root/ansys/lib/linx64"
prepend-path  LD_LIBRARY_PATH        "$awp_root/autodyn/lib/linx64"
prepend-path  LD_LIBRARY_PATH        "$awp_root/CFX/lib/linux-amd64"
prepend-path  LD_LIBRARY_PATH        "$awp_root/CFD-Post/lib/linux-amd64"
prepend-path  LD_LIBRARY_PATH        "$awp_root/Electronics/Linux64"
prepend-path  LD_LIBRARY_PATH        "$awp_root/fensapice/lib64"
prepend-path  LD_LIBRARY_PATH        "$awp_root/fluent/lib/lnamd64"
prepend-path  LD_LIBRARY_PATH        "$awp_root/Framework/bin/Linux64"
prepend-path  LD_LIBRARY_PATH        "$awp_root/Tools/mono/Linux64/lib64"
prepend-path  LD_LIBRARY_PATH        "$awp_root/TurboGrid/lib/linux-amd64"

prepend-path  PATH                   "$awp_root/ACP"
prepend-path  PATH                   "$awp_root/aisol/bin/linx64"
prepend-path  PATH                   "$awp_root/ansys/bin"
prepend-path  PATH                   "$awp_root/autodyn/bin"
prepend-path  PATH                   "$awp_root/CEI/bin"
prepend-path  PATH                   "$awp_root/CFX/bin"
prepend-path  PATH                   "$awp_root/CFD-Post/bin"
prepend-path  PATH                   "$awp_root/EKM/bin"
prepend-path  PATH                   "$awp_root/Electronics/Linux64"
prepend-path  PATH                   "$awp_root/fensapice/bin"
prepend-path  PATH                   "$awp_root/fluent/bin"
prepend-path  PATH                   "$awp_root/Framework/bin/Linux64"
prepend-path  PATH                   "$awp_root/Icepak/bin"
prepend-path  PATH                   "$awp_root/polyflow/bin"
prepend-path  PATH                   "$awp_root/SystemCoupling/bin"
prepend-path  PATH                   "$awp_root/Tools/mono/Linux64/bin"
prepend-path  PATH                   "$awp_root/TurboGrid/bin"

module-whatis   "ANSYS version $version, simulation software BW license manager"

proc MsgLicenseInfo { } {
  puts stderr ""
  puts stderr "IMPORTANT:"
  puts stderr "1) The analysis work performed with the Academic Program(s) must be"
  puts stderr "   non-proprietary work."
  puts stderr "2) Licensee and its Contract Users must be or"
  puts stderr "   be affiliated with an academic facility. In addition to its employees"
  puts stderr "   and Contract Users, Licensee may permit individuals who are students"
  puts stderr "   at such academic facility to access and use the Academic Program(s)."
  puts stderr "   Such students will be considered Contract Users of Licensee."
  puts stderr "3) The Academic Program(s) may not be used for competitive analysis"
  puts stderr "   (such as benchmarking) or for any commercial activity, including consulting."
  puts stderr "4) Notwithstanding any terms of the Agreement to the contrary, Academic"
  puts stderr "   Program(s) may be accessed and used by Licensee at the Designated Site"
  puts stderr "   or any other location within a 50 mile radius of the Designated Site,"
  puts stderr "   provided that such location is within the same country as the"
  puts stderr "   Designated Site. Such limitations apply to any access and/or use of the"
  puts stderr "   Academic Program(s), including, but not limited to, access via a VPN"
  puts stderr "   connection or through license borrowing."
  puts stderr ""
}
