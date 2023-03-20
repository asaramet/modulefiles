--
-- Intel composer modulefile
--

-- $Id: 20.0.lua 8791 2020-01-23 12:58:14Z ku8089 $
-- $Date: 2018-09-18 14:58:14 +0200 (Di, 18 Sep 2018) $
-- $Author: xl4597 $
-- $Revision: 8791 $
-- $URL: svn+ssh://xl4597@scs-team.scc.kit.edu/srv/svn/OpenOb/scripts/software/all/lmod.fhc/modulefiles/Core/compiler/intel/20.0.lua $

local      module_version = myModuleVersion()
local    module_full_name = myModuleName()
local _, module_name      = splitFileName(module_full_name)
local intel_version = "Intel(R) Compilers 19.1 for Linux*"

local base_dir = "/opt/intel/compilers_and_libraries_2020/linux"
local  bin_dir = pathJoin( base_dir, "bin/intel64" )
local  lib_dir = pathJoin( base_dir, "lib/intel64" )
local  man_dir = pathJoin( base_dir, "man/common" )

local common_flags = "-O2 -ipo -xHost"

local cflags       = common_flags
local cxxflags     = common_flags
local fflags       = common_flags
local fcflags      = common_flags

-- define environment
setenv( "INTEL_LICENSE_FILE", "28518@scclic1.scc.kit.edu" )
setenv( "AR",  pathJoin( bin_dir, "xiar"  ) )
setenv( "CC",  pathJoin( bin_dir, "icc"   ) )
setenv( "CXX", pathJoin( bin_dir, "icpc"  ) )
setenv( "F77", pathJoin( bin_dir, "ifort" ) )
setenv( "FC",  pathJoin( bin_dir, "ifort" ) )
setenv( "CFLAGS",   cflags   )
setenv( "CXXFLAGS", cxxflags )
setenv( "FFLAGS",   fflags   )
setenv( "FCFLAGS",  fcflags  )

-- See: Thread Affinity Interface (Linux* and Windows*)
--      https://software.intel.com/en-us/node/522691
-- KMP_AFFINITY=[<modifier>,...]<type>[,<permute>][,<offset>]
--   * modifier:
--     * noverbose: Does not print verbose messages.
--     * verbose: Prints messages concerning the supported affinity
--     * granularity:
--       * core: Allows all the OpenMP* threads bound to a core to float between the different thread contexts.
--       * fine or thread: Causes each OpenMP* thread to be bound to a single thread context
--     * respect: Respect the process' original affinity mask
--     * norespect: Do not respect original affinity mask for the process
--     * warnings: Print warning messages from the affinity interface
--     * nowarnings: Do not print warning messages from the affinity interface
--   * type:
--     * none: Does not bind OpenMP* threads to particular thread contexts
--     * compact: Specifying compact assigns the OpenMP* thread <n>+1 to a free thread context as close as possible to the thread context where the <n> OpenMP* thread was placed.
--     * disabled: Completely disables the thread affinity interfaces.
--     * explicit: Assign OpenMP threads to a list of OS proc IDs that have been explicitly specified by using the proclist= modifier
--     * scatter: distributes OpenMP threads as evenly as possible across the entire system
--     * logical and physical (deprecated): KMP_AFFINITY=physical,n is equivalent to KMP_AFFINITY=compact,1,n
setenv( "KMP_AFFINITY", "noverbose,granularity=core,respect,warnings,compact,1")

prepend_path( "PATH",            bin_dir )
prepend_path( "MANPATH",         man_dir )
prepend_path( "LD_LIBRARY_PATH", lib_dir )

whatis( "Sets up Intel C/C++ and Fortran compiler version " .. module_version .. " (" .. intel_version .. ") - supported by SCC till 2022-12-31!" )
help( intel_version .. [[

For details see: https://software.intel.com/en-us/intel-compilers
In case of problems, please contact: Hartmut Häfner <hartmut.haefner@kit.edu>
SCC support end: 2022-12-31]])

-- Add modules build for this compiler implementation
local cluster=os.getenv("CLUSTER") or ""
if ( cluster == "fh2" or cluster == "fhc" or 
     cluster == "fh1" or cluster == "fhb" ) then
    prepend_path("MODULEPATH", pathJoin("/software/all/lmod/modulefiles/Compiler", module_name, module_version));
end
if ( cluster == "uc2" or cluster == "ucc" ) then
    prepend_path("MODULEPATH", pathJoin("/software/bwhpc/common/modulefiles_prepend/Compiler", module_name, module_version));
end
-- Set module family
family("compiler")
