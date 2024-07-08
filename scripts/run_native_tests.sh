#!/bin/sh

PROJ_DIR=$(realpath $(dirname $(realpath $0))/..)

echo "Running native tests ${PROJ_DIR}"
cd ${PROJ_DIR}
make run_native_test
