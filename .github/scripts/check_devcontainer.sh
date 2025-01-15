#!/bin/sh -l

# This script is used to search for a container image and, if the image
# is not found, build and push the container image to GitHub Container Registry.

if [ ! $# -eq 3 ]; then
    echo "Called with the a wrong number of arguments, expected 3 got $#"
    echo "$@"
    exit 1
fi

REPO_NAME=$1
IMAGE_PATH=$2
GITHUB_TOKEN=$3

echo "REPO_NAME=${REPO_NAME}"
echo "IMAGE_PATH=${IMAGE_PATH}"

# Constants
REPO_NAME_URL_ENC=$(echo "${REPO_NAME}" | cut -f2 -d/)
IMAGE_NAME=$(echo "${IMAGE_PATH}" | cut -f4 -d/ | cut -f1 -d:)
REPO_NAME_URL_ENC="${REPO_NAME_URL_ENC}%2F${IMAGE_NAME}"

echo "IMAGE_NAME=${IMAGE_NAME}"

# Change to .devcontainer folder and calculate Dockerfile hash
cd "${GITHUB_WORKSPACE}"/.devcontainer || exit 1
DOCKER_HASH=$(sha1sum Dockerfile 2>&1 || true)
echo "Docker hash: ${DOCKER_HASH}"

# Get info on any existing image and try to match hashes
echo "Rest API url: https://api.github.com/user/packages/container/${REPO_NAME_URL_ENC}/versions"
IMG_HITS=$(curl -s -L -H "Accept: application/vnd.github+json" \
                   -H "Authorization: Bearer ${GITHUB_TOKEN}" \
                   -H "X-GitHub-Api-Version: 2022-11-28" \
                   "https://api.github.com/user/packages/container/${REPO_NAME_URL_ENC}/versions" | grep -c "${DOCKER_HASH}")
echo "Number of hash matches: ${IMG_HITS}"

# If hashes don't (or don exist), build and push image
if [ "${IMG_HITS}" -lt  1 ]; then
    echo "Rebuilding image, deleting any old stuff ...."
    docker image rm "${IMAGE_PATH}" || true
    echo "Doing the actual build ...."
    docker build -t "${IMAGE_PATH}" --label org.opencontainers.image.description="${DOCKER_HASH}" .
    echo "Pushing new image to ${IMAGE_PATH} ...."
    docker push "${IMAGE_PATH}"
else
    echo "Image ${IMAGE_PATH} up to date, nothing to do ...."
fi

exit 0