
module load compiler/gnu/10.2
module load mpi/openmpi/4.0
module load lib/scotch/6.1

TARGET_DIR="/opt/bwhpc/common/cae/openfoam/scotch_6.1-gnu-10.2"
[[ ! -d ${TARGET_DIR} ]] && mkdir -p $TARGET_DIR

cd ${TARGET_DIR}
mkdir openmpi-system
mkdir temp && cd temp

ar -x "${SCOTCH_HOME}/lib/libscotch.a"
gcc -shared *.o -o "../libscotch.so"
rm * -v

ar -x "${SCOTCH_HOME}/lib/libscotcherrexit.a"
gcc -shared *.o -o "../libscotcherrexit.so"
rm * -v

ar -x "${SCOTCH_HOME}/lib/libptscotch.a"
gcc -shared *.o -o "../openmpi-system/libptscotch.so"
rm * -v

ar -x "${SCOTCH_HOME}/lib/libptscotcherrexit.a"
gcc -shared *.o -o "../openmpi-system/libptscotcherrexit.so"

cd .. && rm temp -rfv
