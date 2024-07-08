#!/bin/sh

#if [ "${#}" -ne 1 ]; then
#    echo "Expecting 1 argument (name of file to flash)"
#    exit 1
#fi

#SCRIPT_DIR=$(dirname $(realpath $0))

# Flash firmware with tests
#${SCRIPT_DIR}/run_avrdude.sh ${1}

picocom /dev/host/ttyFLASH > picout &
echo $!
sleep 5
kill -9 $!
echo "Done!"


