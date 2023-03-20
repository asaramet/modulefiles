-- -*- lua -*-
--[==[
# Module:          es/cae/starccm+/2020.1-r8
# Revision:        esbw01 20201123 Alexandru Saramet
# License:         Private/Corporate
# 2ndLevelSupport: cluster-support[at]hs-esslingen.de
### END COMMENTS
]==]--

local version = "15.02.009-R8"
local base_dir	= pathJoin("/opt/bwhpc/es/cae/starccm+", version)
local starccm_dir = pathJoin(base_dir, "STAR-CCM+"..version)
local starview_dir = pathJoin(base_dir, "STAR-View+"..version)

depends_on("system/ssh_wrapper/0.1")

setenv("MPI_REMSH", "/opt/bwhpc/common/system/ssh_wrapper/0.1/ssh")
setenv("CDLMD_LICENSE_FILE", "1999@flex.cd-adapco.com")
setenv("_JAVA_OPTIONS", "-Xmx2G")

prepend_path("PATH", pathJoin(starccm_dir, "star/bin"))
prepend_path("PATH", pathJoin(starview_dir, "bin"))

conflict("cae/starccm+")

if ( mode() == "load" ) then
  LmodMessage("StarCCM+", version, "is loaded.\n\n", "Tip: Use POD licenses.")
end

if ( mode() == "unload" ) then
  LmodMessage("StarCCM+ ", version, "is unloaded.")
end

whatis("STAR-CCM+ "..version)

help([[Enter 'starccm+' to start StarCCM+, and 'starview+' to start StarView+.

Visit our wiki for information on how to submit a job to the queueing system

Please note the terms and conditions.

'Academic licenses' are intended exclusively for non-commercial reaserch and education only.

Therefore, Siemens CD-Adapco software is strictly limited to the educational and non-commertial research. Results created with academic licenses may not be used for commercial purposes

]])
