-- -*- lua -*-
--[==[
# Cluster:         bwUniCluster
# Module:          es/cae/ansys/19.1
# Revision:        esbw01
# TargetSystem:    Red-Hat-Enterprise
# MainLocation:    /opt/bwhpc/es/cae/ansys/19.1
# Status:          optional
# License:         Private
# URL:             https://www.ansys.com
# 2ndLevelSupport: cluster-support[at]hs-esslingen.de
# Date:            20200325 Alexandru Saramet
### END COMMENTS
]==]--

local version = "19.1"
local short = "191"
local base_dir = pathJoin("/opt/bwhpc/es/cae/ansys", version, "ansys_inc")
local awp_root = pathJoin(base_dir, "v"..short)

setenv("MPI_USESRUN", "1")
setenv("I_MPI_HYDRA_BOOTSTRAP", "slurm")
setenv("I_MPI_HYDRA_RMK", "slurm")
setenv("I_MPI_HYDRA_BRANCH_COUNT", "-1")

local ssh = "/opt/bwhpc/common/system/ssh_wrapper/0.1/ssh"
setenv("MPI_REMSH", ssh)
setenv("CFX5RSH", ssh)
setenv("FLUENT_SSH", ssh)

setenv("FLUENT_SKIP_SSH_CHECK", "1")
setenv("LC_ALL", "C")
setenv("I_MPI_FALLBACK", "1")

setenv("ANSYS_WWW", "http://www.ansys.com/")
setenv("AWP_ROOT"..short, awp_root)
--setenv("ANSYS"..short.."_PRODUCT", "aa_r")
setenv("ANSYS_LOCK", "ON")
setenv("ANSYS_VERSION", version)
setenv("ANSYS_HOME", base_dir)

--prepend_path("LD_LIBRARY_PATH", pathJoin(awp_root, "ACP"))
prepend_path("LD_LIBRARY_PATH", pathJoin(awp_root, "aisol/lib/linx64"))
--prepend_path("LD_LIBRARY_PATH", pathJoin(awp_root, "ansys/lib/linx64"))
--prepend_path("LD_LIBRARY_PATH", pathJoin(awp_root, "autodyn/lib/linx64"))
prepend_path("LD_LIBRARY_PATH", pathJoin(awp_root, "CFX/lib/linux-amd64"))
prepend_path("LD_LIBRARY_PATH", pathJoin(awp_root, "Electronics/Linux64"))
prepend_path("LD_LIBRARY_PATH", pathJoin(awp_root, "fensapice/lib64"))
prepend_path("LD_LIBRARY_PATH", pathJoin(awp_root, "fluent/lib/lnamd64"))
prepend_path("LD_LIBRARY_PATH", pathJoin(awp_root, "Framework/bin/Linux64"))
prepend_path("LD_LIBRARY_PATH", pathJoin(awp_root, "Tools/mono/Linux64/lib64"))
--prepend_path("LD_LIBRARY_PATH", pathJoin(awp_root, "TurboGrid/lib/linux-amd64"))

--prepend_path("PATH", pathJoin(awp_root, "ACP"))
prepend_path("PATH", pathJoin(awp_root, "aisol/bin/linx64"))
--prepend_path("PATH", pathJoin(awp_root, "ansys/bin"))
--prepend_path("PATH", pathJoin(awp_root, "autodyn/bin"))
prepend_path("PATH", pathJoin(awp_root, "CEI/bin"))
prepend_path("PATH", pathJoin(awp_root, "CFX/bin"))
prepend_path("PATH", pathJoin(awp_root, "EKM/bin"))
prepend_path("PATH", pathJoin(awp_root, "Electronics/Linux64"))
prepend_path("PATH", pathJoin(awp_root, "fensapice/bin"))
prepend_path("PATH", pathJoin(awp_root, "fluent/bin"))
prepend_path("PATH", pathJoin(awp_root, "Framework/bin/Linux64"))
prepend_path("PATH", pathJoin(awp_root, "Icepak/bin"))
prepend_path("PATH", pathJoin(awp_root, "polyflow/bin"))
prepend_path("PATH", pathJoin(awp_root, "SystemCoupling/bin"))
prepend_path("PATH", pathJoin(awp_root, "Tools/mono/Linux64/bin"))
--prepend_path("PATH", pathJoin(awp_root, "TurboGrid/bin"))

conflict("cae/ansys")

if ( mode() == "load" ) then
  --LmodMessage("ANSYS ", version, "is loaded.\n\nInstalled packages:\n  - ANSYS Fluids\n  - ANSYS Structures\n")
  LmodMessage("ANSYS ", version, "is loaded.\n\nInstalled packages:\n  - ANSYS Fluids\n")
end

if ( mode() == "unload" ) then
  LmodMessage("ANSYS ", version, "is unloaded.")
end

whatis("ANSYS version "..version..", simulation software BW license manager")

help([[
IMPORTANT:"
1) The analysis work performed with the Academic Program(s) must be non-proprietary work.
2) Licensee and its Contract Users must be or be affiliated with an academic facility.
   In addition to its employees and Contract Users, Licensee may permit individuals who
	 are students at such academic facility to access and use the Academic Program(s).
   Such students will be considered Contract Users of Licensee.
3) The Academic Program(s) may not be used for competitive analysis (such as benchmarking)
   or for any commercial activity, including consulting.
4) Notwithstanding any terms of the Agreement to the contrary, Academic Program(s)
   may be accessed and used by Licensee at the Designated Site or any other location within
	 a 50 mile radius of the Designated Site, provided that such location is within the same
	 country as the Designated Site. Such limitations apply to any access and/or use of the
   Academic Program(s), including, but not limited to, access via a VPN connection or through
	 license borrowing.


This module provides the general-purpose Simulation package ANSYS ]], version, [[

Enter 'fluent' to launch an ANSYS FLUENT session.

As with all processes that require more than a few minutes to run, non-trivial
ANSYS solver jobs must be submitted to the cluster queuing system.

NOTICE:
Don't forget to login in with "-X" option for ssh if you get an error message
"Can't connect to X-server". Now you cant start your ansys work.
]])
