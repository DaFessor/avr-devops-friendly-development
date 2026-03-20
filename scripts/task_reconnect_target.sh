#!/bin/sh

PROJ_DIR=$(realpath $(dirname $(realpath $0))/..)

TTYDEV="$(ls -l /dev/tty* | grep 166 | rev | cut -d' ' -f1| rev)"
if [ ! -c "${TTYDEV}" ]; then
    echo "*** Error: No connectable device found in /dev/tty* ***"
    echo "You need to install/run usbipd on your computer and run usbip bind/attach on the device."
    exit 0
fi

printf "\n*** To close connection press ctrl-a ctrl-x ***\n\n"

microcom -s 115200 ${TTYDEV}

printf "\n*** Disconnected ***\n\n"
