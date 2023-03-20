-- -*- lua -*-
--[==[
# Module:          cae/openfoam/4.x
# Revision:        esbw01 20200317 Alexandru Saramet
# License:         GPL v3
# URL:             https://www.openfoam.org
# 2ndLevelSupport: cluster-support[at]hs-esslingen.de
### END COMMENTS
]==]--
local version = "4.x"
local openfoam = "OpenFOAM-"..version
local base_dir = pathJoin("/opt/bwhpc/common/cae/openfoam", version)
local of_dir = pathJoin(base_dir, openfoam)
local bpr_url = "https://wiki.bwhpc.de/e/OpenFoam"

setenv("FOAM_VERSION", version)
setenv("FOAM_INST_DIR", base_dir)
setenv("FOAM_INIT", pathJoin(of_dir, "etc", "bashrc"))
setenv("FOAM_DOC_DIR", pathJoin(of_dir, "doc", "Guides"))
setenv("FOAM_EXA_DIR", pathJoin(of_dir, "tutorials"))
setenv("FOAM_BPR_URL", bpr_url)
setenv("FOAMY_HEX_MESH", "yes")
set_alias("foamInit", "source $FOAM_INIT")

depends_on("compiler/gnu/4.8.5", "mpi/openmpi/4.0", "system/ssh_wrapper/0.1")

conflict("cae/openfoam")

if ( mode() == "load" ) then
  LmodMessage("\nDon't forget to initialize OpenFOAM with:\n\n\tsource $FOAM_INIT\n\nor simply:\n\n\tfoamInit\n")
end

if ( mode() == "unload" ) then
  LmodMessage("OpenFoam-"..version, "is unloaded")
end

whatis("Open Source CFD Toolbox OpenFOAM version "..version)

help([[The OpenFOAM (Open Field Operation and Manipulation) CFD Toolbox can simulate anything
from complex fluid flows involving chemical reactions, turbulence and heat transfer, to
solid dynamics, electromagnetics and the pricing of financial options.

Don't forget to initialize OpenFOAM with:

   source $FOAM_INIT

or simply:

   foamInit

Local documentation in:
   $FOAM_DOC_DIR

Tutorial examples in:
   $FOAM_TUTORIALS

Online documentation in:
   ]],bpr_url,[[

Homepage:
   https://www.openfoam.org

In case of problems, please contact 'bwunicluster-hotline(at)lists.kit.edu',
or create a ticket at 'https://bw-support.scc.kit.edu/'
]])
