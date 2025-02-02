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

TTYDEV="$(ls -l /dev/tty* | grep 166 | rev | cut -d' ' -f1| rev)"
if [ ! -c "${TTYDEV}" ]; then
    echo "*** Error: No flashable device found in /dev/tty* ***"
    echo "You need to install/run usbipd on your computer and run usbip bind/attach on the device."
    exit 0
fi

if echo "${1}" | grep -q release; then
    RUNDIR="${PROJ_DIR}/build/target_firmware_/release"
else
    RUNDIR="${PROJ_DIR}/build/target_firmware_/debug"
fi

LOGFILE=${RUNDIR}/$(basename -s .hex ${1}).log

cd ${RUNDIR}
${PROJ_DIR}/scripts/util_run_avrdude.sh ${1}

printf "\n*** To terminate logging from target press ctrl-a ctrl-x ***\n\n"

microcom -s 115200 ${TTYDEV} | tee ${LOGFILE}

printf "\n*** Logfile with output is saved in ${LOGFILE} ***\n\n"
