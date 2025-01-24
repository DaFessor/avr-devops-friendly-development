#! /bin/sh
set -e

if [ ! $# -eq 1 ]; then
    echo "Called with the a wrong number of arguments, expected 1 got $#"
    echo "$@"
    exit 1
fi

REPORAW="${1}"
REPOSITORY=$(echo "${1}" | tr  '[:upper:]' '[:lower:]' )
REPO_OWNER=$(echo "${REPOSITORY}" | cut -f1 -d/ )
REPO_NAME=$(echo "${REPOSITORY}" | cut -f2 -d/ )
PAGES_URL="https://${REPO_OWNER}.github.io/${REPO_NAME}/"
WORKDIR=$(pwd)
echo "Working directory: ${WORKDIR}"

echo "Project pages variables:"
echo "REPOSITORY = ${REPOSITORY}"
echo "REPO_OWNER = ${REPO_OWNER}"
echo "REPO_NAME = ${REPO_NAME}"
echo "PAGES_URL = ${PAGES_URL}"

# Update firmware.zip
cd "${WORKDIR}"/build/target_firmware_/release
zip "${WORKDIR}"/project_pages/firmware/firmware.zip firmware.*

# Update test report
cd "${WORKDIR}/build/native_test_/debug"
cp -rf testreport/* "${WORKDIR}/project_pages/testreport"
zip -r "${WORKDIR}/project_pages/testreport/testreport.zip" testreport

# Update date stamps
cd "${WORKDIR}/project_pages"
NOW=$(date)
sed "s/TTTTTTTTTTTTTT/${NOW}/g" < index.html.template > index_tmp.html
sed "s:RRRRRRRRRRRRRR:${REPORAW}:g" < index_tmp.html > index.html

exit 0
