#%Module2.0
#
# Module:       esslingen/starccm/14.04.013
# Revision:     esbw00
# TargetSystem: RHEL7
# Priority:		optional
# 2ndLevelSupport: cluster-support [at] hs-esslingen.de
#
##### (A) Revision history:
#
# esbw00 A.Saramet Installing the software
#
##### (D) How to install software:
#
# tar zxvf STAR-CCM+14.04.013_01_linux-x86_64-r8.tar.gz
#
# cd starccm+_14.04.013/
#
# export _JAVA_OPTIONS="-Xmx256M"
# ./STAR-CCM+14.04.013_01_linux-x86_64-2.5_gnu4.8-r8.bin -i console
#
# ## follow the steps
# ## set path to:
# # /opt/bwhpc/common/cae/star-ccm+/2019.2.1
#
###

set 	version		"14.04.013"
set		base_dir	"/opt/bwhpc/common/cae/star-ccm+/2019.2.1/${version}/STAR-CCM+${version}"
set 	impi_vers	"2018.1.163"

set		mod_name	[module-info name]
set		mod_mode	[module-info mode]

module-whatis   "STAR-CCM+ ${version}"

proc MsgLicenseInfo { } {
  puts stderr ""
  puts stderr "Please note the terms and conditions."
  puts stderr ""
  puts stderr "'Academic licenses' are intended exclusively for non-commercial"
  puts stderr "reaserch and education only."
  puts stderr ""
  puts stderr "Therefore, CD-Adapco software is strictly limited to the"
  puts stderr "educational and non-commertial research. Results created with"
  puts stderr "academic licenses may not be used for commercial purposes"
  puts stderr ""
}

proc ModulesHelp { } {
  global version
  puts stderr ""
  puts stderr "Enter 'starccm+' to start StarCCM+, and 'starview+' to start StarView+."
  puts stderr "Visit our wiki for information on how to submit a job to the queueing system"
  puts stderr ""
  MsgLicenseInfo
}

setenv CDLMD_LICENSE_FILE 	"1999@flex.cd-adapco.com"
setenv _JAVA_OPTIONS        "-Xmx256M"
setenv MPI_ROOT				      "${base_dir}/mpi/intel/${impi_vers}/linux-x86_64/rto/intel64/bin/"

prepend-path  PATH    "$base_dir/star/bin"
prepend-path	PATH	  "$env(MPI_ROOT)"


puts stderr "Star-CCM+ ${version} is loaded.\nTip: Use POD licenses."

conflict cae/star-ccm+
