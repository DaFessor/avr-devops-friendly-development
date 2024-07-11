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
make --directory=${RUNDIR} --no-builtin-rules --makefile=${PROJ_DIR}/native_test/Makefile target_tests 2&>1 > /dev/null

${PROJ_DIR}/scripts/run_avrdude.sh ${1}
${PROJ_DIR}/scripts/serial_monitor.tcl "(?w)^(OK|FAIL)$" ${LOGFILE}

printf "\n*** Logfile with test results saved in ${LOGFILE} ***\n\n"
