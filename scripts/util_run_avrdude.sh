#!/bin/sh

PROJ_ROOT=$(realpath $(dirname $(realpath $0))/..)

if [ "${#}" -ne 1 ]; then
    echo "Expecting 1 argument (name of file to flash)"
    exit 1
fi

if [ ! -f "${1}" ]; then
    echo "File to flash ${1} does not exist"
    exit 1
fi

TTYDEV="$(ls -l /dev/tty* | grep 166 | rev | cut -d' ' -f1| rev)"

if [ ! -c "${TTYDEV}" ]; then
    echo "*** Error: No flashable device found in /dev/tty* ***"
    echo "You need to install/run usbipd on your computer and run usbip bind/attach on the device."
    exit 0
fi

avrdude -v -p atmega2560 -C /etc/avrdude.conf -c wiring -b 115200 -D -P "${TTYDEV}" -U "flash:w:${1}:i"
