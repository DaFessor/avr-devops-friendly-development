#!/bin/sh

if [ "${#}" -ne 2 ]; then
    echo "Expecting 2 arguments <root dir> <file to compile>"
    exit 1
fi

if echo "${2}" | grep -q target_firmware; then
    WS="${1}/target_firmware"
elif echo "${2}" | grep -q target_test; then
    WS="${1}/target_test"
elif echo "${2}" | grep -q native_test; then
    WS="${1}/native_test"
else
    echo "Could not find specified subproject folder"
    exit 1
fi

cd "${WS}"
make compile $(basename "${2}")
