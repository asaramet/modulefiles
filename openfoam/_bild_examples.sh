#!/usr/bin/env bash

# exit if OpenFOAM version is not provided
[[ -z $1 ]] && echo "Provide the OpenFOAM version please" && exit 1

VERSION=$1
FOLDER="/pfs/data5/software_uc2/bwhpc/common/cae/openfoam/$1/bwhpc-examples"

multiple() {
  cat << EOF
#!/bin/bash

# Allocate nodes
#SBATCH --nodes=2
# Number of program instances to be executed
#SBATCH --ntasks-per-node=40
# Queue class https://wiki.bwhpc.de/e/BwUniCluster_2.0_Batch_Queues
#SBATCH --partition=multiple
# Maximum run time of job
#SBATCH --time=4:00:00
# Give job a reasonable name
#SBATCH --job-name=openfoam
# File name for standard output (%j will be replaced by job id)
#SBATCH --output=logs-%j.out
# File name for error output
#SBATCH --error=logs-%j.err

# Initialize the job
MPIRUN_OPTIONS="--bind-to core --map-by core -report-bindings"

module load "cae/openfoam/${VERSION}"
source \${FOAM_INIT}

echo "Starting at "
date

cd \${SLURM_SUBMIT_DIR}

# Source tutorial run functions
echo \${WM_PROJECT_DIR}
. \${WM_PROJECT_DIR}/bin/tools/RunFunctions

runApplication blockMesh

runApplication decomposeParHPC -copyZero

mpirun \${MPIRUN_OPTIONS} snappyHexMesh -overwrite -parallel &> log.snappyHexMesh

## Check decomposed mesh
mpirun \${MPIRUN_OPTIONS} checkMesh -allGeometry -allTopology -meshQuality -parallel &> log.checkMesh

mpirun \${MPIRUN_OPTIONS} patchSummary -parallel &> log.patchSummary

mpirun \${MPIRUN_OPTIONS} \$(getApplication) -parallel &> log.\$(getApplication) &&

runApplication reconstructParHPC &&

rm -rf processor*

echo "Run completed at "
date
EOF
}


single() {
  cat << EOF
#!/bin/bash

# Allocate nodes
#SBATCH --nodes=1
# Number of program instances to be executed
#SBATCH --ntasks-per-node=40
# Queue class https://wiki.bwhpc.de/e/BwUniCluster_2.0_Batch_Queues
#SBATCH --partition=single
# Maximum run time of job
#SBATCH --time=4:00:00
# Give job a reasonable name
#SBATCH --job-name=openfoam
# File name for standard output (%j will be replaced by job id)
#SBATCH --output=logs-%j.out
# File name for error output
#SBATCH --error=logs-%j.err

# Initialize the job
MPIRUN_OPTIONS="--bind-to core --map-by core -report-bindings"

module load "cae/openfoam/${VERSION}"
source \${FOAM_INIT}

echo "Starting at "
date

cd \${SLURM_SUBMIT_DIR}

# Source tutorial run functions
echo \${WM_PROJECT_DIR}
. \${WM_PROJECT_DIR}/bin/tools/RunFunctions

runApplication blockMesh

runApplication decomposePar -copyZero

mpirun \${MPIRUN_OPTIONS} snappyHexMesh -overwrite -parallel &> log.snappyHexMesh

## Check decomposed mesh
mpirun \${MPIRUN_OPTIONS} checkMesh -allGeometry -allTopology -meshQuality -parallel &> log.checkMesh

mpirun \${MPIRUN_OPTIONS} patchSummary -parallel &> log.patchSummary

mpirun \${MPIRUN_OPTIONS} \$(getApplication) -parallel &> log.\$(getApplication) &&

runApplication reconstructPar &&

rm -rf processor*

echo "Run completed at "
date
EOF
}

[[ ! -d ${FOLDER} ]] && mkdir -p ${FOLDER}
single > ${FOLDER}/single.sh
multiple > ${FOLDER}/multiple.sh
