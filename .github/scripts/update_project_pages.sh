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

echo "List files in the current directory"
ls -al .
echo "List files in the build directory"
ls -al ./build
echo "List files in project_pages directory"
ls -al ./project_pages
echo "List files in project_pages/firmware directory"
ls -al ./project_pages/firmware


# Update firmware.zip
cd ./build/target_firmware_/release
zip "${WORKDIR}"/project_pages/firmware/firmware.zip firmware.*

# Update test report
cp -rf build/native_test_/debug/testreport/* project_pages/testreport
zip -r project_pages/testreport/testreport.zip build/native_test_/debug/testreport

# Update date stamps
NOW=$(date)
sed "s/TTTTTTTTTTTTTT/${NOW}/g" < project_pages/index.html.template > index_tmp.html
sed "s:RRRRRRRRRRRRRR:${REPORAW}:g" < index_tmp.html > index.html
mv -f index.html project_pages/index.html

exit 0
