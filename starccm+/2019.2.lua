-- -*- lua -*-
--[==[
# Cluster:         bwUniCluster
# Module:          es/cae/starccm+/14.04
# Revision:        esbw01
# TargetSystem:    Red-Hat-Enterprise
# MainLocation:    /opt/bwhpc/common/es/cae/starccm+/14.04.013
# Status:          optional
# License:         Private/Corporate
# 2ndLevelSupport: cluster-support[at]hs-esslingen.de
# Date:            20200305 Alexandru Saramet
# InstallDoc:      install-14.04.sh
### END COMMENTS
]==]--

local version = "14.04.013"
local base_dir	= pathJoin("/opt/bwhpc/es/cae/starccm+", version)
local starccm_dir = pathJoin(base_dir, "STAR-CCM+"..version)
local starview_dir = pathJoin(base_dir, "STAR-View+"..version)
--local impi_vers	= "2018.1.163"

--depends_on("compiler/gnu/9.2", "mpi/impi/2018")
depends_on("system/ssh_wrapper/0.1")

setenv("MPI_REMSH", "/opt/bwhpc/common/system/ssh_wrapper/0.1/ssh")
setenv("CDLMD_LICENSE_FILE", "1999@flex.cd-adapco.com")
setenv("_JAVA_OPTIONS", "-Xmx2G")
--setenv("_JAVA_OPTIONS", "-Xms64M -Xmx128m")
--setenv("MPIRUN_OPTIONS", "-prot")
--setenv("MPI_USESRUN", "1")
--setenv("I_MPI_HYDRA_BOOTSTRAP", "slurm")
--setenv("I_MPI_HYDRA_RMK", "slurm")
--setenv("I_MPI_HYDRA_BRANCH_COUNT", "-1")

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
