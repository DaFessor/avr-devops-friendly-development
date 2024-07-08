#!/bin/sh

PROJ_DIR=$(realpath $(dirname $(realpath $0))/..)
CMOCK_SCRIPT=${PROJ_DIR}/deps/cmock/lib/cmock.rb
CMOCK_CONFIG=${PROJ_DIR}/native_test/cmock_config.yml


if [ "${#}" -lt 1 ]; then
    echo "Expecting at least 1 argument (file(s) to mock)"
    exit 1
fi

if ! ruby -v > /dev/null; then
    echo "Ruby is not installed"
    exit 1
fi

if [ ! -f ${CMOCK_SCRIPT} ]; then
    echo "Could not find CMock script at ${CMOCK_SCRIPT}"
    exit 1
fi


if [ -f "${1}" ]; then
    FILE2MOCK="${1}"
else
    FILE2MOCK=$(find ${PROJ_DIR}/target_firmware -name "${1}")
fi

if [ -z ${FILE2MOCK} ]; then
    echo "Could not find file to mock: ${FILE2MOCK}"
    exit 1
fi

ruby "${CMOCK_SCRIPT}" -o"${CMOCK_CONFIG}" "${FILE2MOCK}"

