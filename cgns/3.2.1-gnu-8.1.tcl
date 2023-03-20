#%Module1.0
#
# Module:          cae/cgns/3.2.1-gnu-8.1
# Revision:        esbw01
# TargetSystem:    RHEL64
# Priority:        optional
# 2ndLevelSupport: cluster-support[at]hs-esslingen.de

set            version              "3.2.1"
set            base_dir             "/opt/bwhpc/common/cae/cgns/$version"

setenv         CGNS_VERSION         "$version"
setenv         CGNS_HOME            "$base_dir"

# Defs for CGNS:

setenv         CGNS_BIN_DIR         "$base_dir/bin"
setenv         CGNS_LIB_DIR         "$base_dir/lib"
setenv         CGNS_STA_DIR         "$base_dir/lib"
setenv         CGNS_SHA_DIR         "$base_dir/lib"
setenv         CGNS_INC_DIR         "$base_dir/include"
setenv         CGNS_WWW             "http://cgns.github.io"

# Setup of PATH environment:

prepend-path   PATH              "$env(CGNS_BIN_DIR)"
prepend-path   LD_LIBRARY_PATH   "$env(CGNS_LIB_DIR)"
prepend-path   INCLUDE           "$env(CGNS_INC_DIR)"

module-whatis "CGNS library and tools version $version for gnu/8.1"

if { [module-info mode] == "load" || [module-info mode] == "add" || [module-info mode] == "switch2" } {
  if { ! [is-loaded "compiler/gnu/8.1"] && "gnu/8.1" != "gnu/4.4" } {
    puts stderr "Loading module dependency 'compiler/gnu/8.1'."
    module load "compiler/gnu/8.1"
  }
  if { ! [is-loaded "compiler/gnu/8.1"] && "gnu/8.1" != "gnu/4.4" } {
    puts stderr "\nERROR: Failed to load module dependency 'compiler/gnu/8.1'. Please check conflicts with already loaded modules.\n";
    break
  }
}

proc ModulesHelp { } {
	global version env

	puts stderr "
 The CFD General Notation System (CGNS) provides a general, portable,
 and extensible standard for the storage and retrieval of computational
 fluid dynamics (CFD) analysis data. It consists of a collection of conventions,
 and free and open software implementing those conventions. It is self-descriptive,
 machine-independent, well-documented, and administered by an international
 steering committee. It is also an American Institute of Aeronautics
 and Astronautics (AIAA)

"
}

# Conflicts and pre-requirements at end of file. Otherwise, "module help"
# will not work, if any of the dependencies fails (which is odd, since
# "module help" should help the user to solve problems like this one).
conflict cae/cgns
