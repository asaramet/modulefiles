-- Module:          system/ssh_wrapper/0.1
-- Revision:        esbw01
-- TargetSystem:    RHEL7
-- Priority:        private
-- License:         GPL v3
-- 2ndLevelSupport: cluster-support [at] hs-esslingen.de
--
-- (A) Revision history:
--
-- kabw01 170710 r.barthel initial version for bwUniCluster/ForHLR
-- esbw01 070220 a.saramet updated to use available MPIDIR

local root_dir = "/opt/bwhpc/es/system/ssh_wrapper"
local module_version = myModuleVersion()
local base_dir = pathJoin( root_dir, module_version )
prepend_path("PATH", base_dir)

whatis("SSH wrapper (Version " .. module_version .. ") emulates SSH to allow passwordless remote shell access to different hosts within the given job resources.")

help([[
The module SSH Wrapper (]] .. module_version .. [[) emulates SSH to allow:
* passwordless remote shell access to different hosts within the given job resources.
]])
