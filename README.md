# Installation scripts and modulefiles for system packages

This repository contains a collection of modulefiles and installation scripts for Linux systems, designed to help users install and manage software packages outside the system libraries and folders.

## Repository structure

Each software package is organized in a separate folder named after the package being installed or managed. Each folder contains a `bash` script that documents the installation process and is placed under version control. Additionally, the folder may contain `tcl` or `lua` modulefiles for use with the *Modules* package.

The installation script provides a detailed description of the installation process, including any prerequisites or dependencies that must be installed before the package. The modulefiles specify the environment variables needed to run the software, such as `PATH`, `LD_LIBRARY_PATH`, and `INCLUDE`.

Note that not all software packages may contain modulefiles or installation scripts, and some may require additional files or configuration.

## Modules on Linux systems

*Modules* is a package management system for Linux that allows users to easily manage and switch between multiple versions of software packages installed on a system. It provides a user-specific, dynamic modification of Linux environment variables, enabling the configuration of software packages in specific directories, outside the system libraries and folders. *Modules* can help with managing conflicting dependencies, simplifying software installation, and ensuring that different versions of software packages do not interfere with each other.

Key benefits of using *Modules* include cleaner installations, easier maintenance, and better version control. For example, you can load a different version of a software package to test compatibility or switch between versions of a package depending on your needs.

Each software package has a corresponding *modulefile* that defines the environment variables needed to use it. Modulefiles instruct the `module` command to alter or set shell environment variables such as PATH, LD_LIBRARY_PATH, INCLUDE, and more. Modulefiles are usually shared by many users on the system, and each user can additionally alter their own variables.

The `module` command has several subcommands to interact with the system's modules:
| Command                     | Description                                              |
|-----------------------------|----------------------------------------------------------|
| module avail (`modulefile`) | List all or specifically available modules on the system |
| module list                 | List loaded modules                                      |
| module load `modulefile`    | Load `modulefile`(s) into the shell environment          |
| module unload `modulefile`  | Remove `modulefile`(s) from the shell environment        |
| module purge                | Unload all loaded modules                                |

Modulefiles are written in either Tool Command Language (`tcl`) or Lua scripts if using Lmod, a new environment module system. TCL modulefiles are easier to write and have a simpler syntax, while Lua modulefiles are more powerful and offer additional features.

## Quick examples

Here are some quick examples that demonstrate how to use modules in a Linux bash shell:

```bash
# List available modules
$ module avail

# List available compiler modules
$ module avail compiler
-------------------------/opt/bwhpc/common/modulefiles ---------------------
compiler/cuda/6.0         compiler/gnu/4.9          compiler/gnu/8.1        
compiler/gnu/4.7(default) compiler/gnu/5.2          compiler/gnu/9.3

# Load gnu-9.3 compiler module
$ module load compiler/gnu/9.3

# List all currently loaded modules
$ module list

# Unload gnu-9.3 compiler module
$ module unload compiler/gnu

# Unload all modules
$ module purge
```

## License

This project is licensed under the MIT License. See the LICENSE.md file for more information.

## Credits

Extra informative resources:

- [Environment Modules](https://modules.sourceforge.net/) - a tool that provides users with the ability to dynamically modify their shell environment and add or remove software packages, using *modulefiles* in TCL. The website provides documentation, downloads, and a community forum.
- [Lmod: A new Environment Module System](https://lmod.readthedocs.io/en/latest/index.html) - *Lmod* is a modern version of *Environment Modules* that provides improved performance, flexibility, and features. It is widely used in high-performance computing environments and offers many advanced capabilities such as hierarchical module collections, virtual environments, and support for Lua modulefiles. The documentation provides detailed information on installation, usage, and configuration.
