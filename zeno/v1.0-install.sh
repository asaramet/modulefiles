#!/usr/bin/env bash

BASE_DIR="/opt/bwhpc/common/cae/zeno"
#BASE_DIR="/packages/cae/zeno"
SRC_DIR=${BASE_DIR}/src
BUILD_DIR=${BASE_DIR}/build
TARGET_DIR=${BASE_DIR}/1.0

[[ ! -d ${BASE_DIR} ]] && mkdir -p ${BASE_DIR}
[[ ! -d ${SRC_DIR} ]] && mkdir -p ${SRC_DIR}

[[ -d ${TARGET_DIR} ]] && rm -rfv ${TARGET_DIR}
mkdir -p ${TARGET_DIR}/bin

mkdir -p ${BUILD_DIR} && cd ${BUILD_DIR}
tar zxvf ${SRC_DIR}/LFE-DVLP-7-to-Mercedes.tar.gz
cd LFE-DVLP-7-to-Mercedes/NEXT-release/zeno
gcc -o ${TARGET_DIR}/bin/run-zeno zenosource/*.c -lm
gcc -o ${TARGET_DIR}/bin/run-omabu omabu/*.c -lm

sed -i s:'zeno/run-zeno':'run-zeno':g run-ALL-TEST-runs_main.c
sed -i s:'TEST-runs':'$ZENO_HOME/TEST-runs':g run-ALL-TEST-runs_main.c
# remove lines from 178 to 217 as they rum medina tests
sed -i '178,217d' run-ALL-TEST-runs_main.c
gcc -o ${TARGET_DIR}/bin/run-ALL-TEST-runs run-ALL-TEST-runs_main.c -lm

cd ${BUILD_DIR}/LFE-DVLP-7-to-Mercedes
mv Modelle ${TARGET_DIR}
mv NEXT-release/TEST-runs ${TARGET_DIR}
cd ${TARGET_DIR}/TEST-runs
run-ALL-TEST-runs
# view ${TARGET_DIR}/TEST-runs/PROTOKOLL file for output
