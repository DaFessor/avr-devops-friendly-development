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

TTYDEV="/dev/host/$(ls -l /dev/host/ttyFLASH | grep -o "/dev/tty.*" | cut -d'/' -f3)"

if [ ! -c "${TTYDEV}" ]; then
    echo "*** Error: No flashable device found in /dev/host ***"
    echo "You need to install/run usbipd on your computer, and you must also run scripts/reset_usb.sh in"
    echo "an ordinary WSL shell (such as bash) outside this container before you can flash your firmware"
    echo "from inside the container."
    exit 0
fi

avrdude -v -p atmega2560 -C /etc/avrdude.conf -c wiring -b 115200 -D -P "${TTYDEV}" -U "flash:w:${1}:i"
