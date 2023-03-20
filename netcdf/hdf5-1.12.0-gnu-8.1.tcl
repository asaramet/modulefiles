#%Module1.0
#
# Module:          lib/hdf5/1.12.0-gnu-8.1
# Revision:        esbw01
# TargetSystem:    RHEL64
# Priority:        optional
# 2ndLevelSupport: cluster-support[at]hs-esslingen.de

set            version              "1.12.0-gnu-8.1"
set            base_dir             "/opt/bwhpc/common/lib/hdf5/$version"

setenv         HDF5_VERSION         "$version"
setenv         HDF5_HOME            "$base_dir"

# Defs for HDF5:

setenv         HDF5_BIN_DIR         "$base_dir/bin"
setenv         HDF5_LIB_DIR         "$base_dir/lib"
setenv         HDF5_STA_DIR         "$base_dir/lib"
setenv         HDF5_SHA_DIR         "$base_dir/lib"
setenv         HDF5_INC_DIR         "$base_dir/include"
setenv         HDF5_DOC_DIR         "$base_dir/doc"
setenv         HDF5_EXA_DIR         "$base_dir/share/hdf5_examples"
setenv         HDF5_WWW             "http://www.hdfgroup.org/"

# Setup of PATH environment:

prepend-path   PATH              "$env(HDF5_BIN_DIR)"
prepend-path   LD_LIBRARY_PATH   "$env(HDF5_LIB_DIR)"
prepend-path   INCLUDE           "$env(HDF5_INC_DIR)"

module-whatis "HDF5 library and tools version $version for gnu/5.1"

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
 Hierarchical Data Format 5 (HDF5) library and tools version $version. The
 corresponding compiler suite (gnu/8.1) module should (and automatically will)
 be loaded first.

 The HDF5 technology suite includes:
 * A versatile data model that can represent very complex data objects and
   a wide variety of metadata.
 * A completely portable file format with no limit on the number or size of
   data objects in the collection.
 * A software library that runs on a range of computational platforms, from
   laptops to massively parallel systems, and implements a high-level API
   with C, C++, Fortran 90, and Java interfaces.
 * A rich set of integrated performance features that allow for access time
   and storage space optimizations.
 * Tools and applications for managing, manipulating, viewing, and
   analyzing the data in the collection.

 When using HDF5 on a Lustre file system, the internal data
 structures should be aligned with the striping of the file
 system. You can query and set the stripe size for a directory
 with the commands lfs getstripe and lfs setstripe.

 About striping have a look at
 http://wiki.lustre.org/index.php/Configuring_Lustre_File_Striping

 Next, the hdf parameters should be tuned as follows:

   H5AC_cache_config_t mdc_config;
   hid_t file_id;
   file_id = H5Fopen(\"file.h5\", H5ACC_RDWR, H5P_DEFAULT);
   mdc_config.version = H5AC__CURR_CACHE_CONFIG_VERSION;
   H5Pget_mdc_config(file_id, &mdc_config)
   mdc_config.evictions_enabled = 0 /* FALSE */;
   mdc_config.incr_mode = H5C_incr__off;
   mdc_config.decr_mode = H5C_decr__off;
   mdc_config.flash_incr_mode = H5C_flash_incr__off;
   H5Pset_mdc_config(file_id, &mdc_config);

 There is an interesting thread about this in the hdf-forum:
 http://hdf-forum.184993.n3.nabble.com/Question-re-Howison-et-al-Lustre-mdc-config-tuning-recommendations-td2469878.html

 Documentation: $env(HDF5_DOC_DIR)
 Examples:      $env(HDF5_EXA_DIR)
 Web:           $env(HDF5_WWW)

 In case of problems, please contact 'bwunicluster-hotline (at) lists.kit.edu'
 or submit a trouble ticket at http://www.support.bwhpc-c5.de.

 The full version is: $version

"
}

# Conflicts and pre-requirements at end of file. Otherwise, "module help"
# will not work, if any of the dependencies fails (which is odd, since
# "module help" should help the user to solve problems like this one).
conflict lib/hdf5
