#!/bin/sh

PROJ_DIR=$(realpath $(dirname $(realpath $0))/..)

if [ "${#}" -lt 1 ]; then
    echo "Expecting 1 argument <hex file to flash and run>"
    exit 1
fi

if [ ! -f ${1} ]; then
    echo "Could not find hex file ${1}"
    exit 1
fi

if echo "${1}" | grep -q release; then
    RUNDIR="${PROJ_DIR}/build/target_test_/release"
else
    RUNDIR="${PROJ_DIR}/build/target_test_/debug"
fi

LOGFILE=${RUNDIR}/$(basename -s .hex ${1}).log

cd ${RUNDIR}
${PROJ_DIR}/scripts/util_run_avrdude.sh ${1}
${PROJ_DIR}/scripts/util_serial_monitor.tcl "(?w)^(OK|FAIL)$" ${LOGFILE}

printf "\n*** Logfile with test results saved in ${LOGFILE} ***\n\n"
