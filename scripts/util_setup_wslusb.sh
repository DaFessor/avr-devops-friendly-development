#!/usr/bin/sh
# shellcheck disable=SC3037

USBIPD_EXECUTABLE="/mnt/c/Program Files/usbipd-win/usbipd.exe"
USER=${SUDO_USER}
WSLCONF_FILE="/etc/wsl.conf"

# Write an error message and exit
usage() {
    echo "Error: ${1} "
    exit 1
}

# Make sure that the user is member of a specified group, and add the
# user to the group if that's not the case
checkgroup() {
    if ! grep "${USER}" /etc/group | grep -q "${1}"; then
        echo "adding user ${USER} to ${1} group"
        usermod -a -G "${1}" "${USER}"
    else
        echo "ok, user ${USER} already in ${1} group"
    fi
}

# ***************** Execution starts here *****************
# =========================================================

# Check root permissions
if [ "$(id -u)" -ne 0 ]; then
    usage "please run this script as root or using sudo!"
fi

# Check that usbipd has been installed
echo -n "Checking installation of usbipd-win .... "
if ! "${USBIPD_EXECUTABLE}" --version >/dev/null 2>&1; then
    usage "you need to install usbipd-win"
else
    echo "ok, usbpipd-win is installed"
fi

# Make sure that the hwdata packages is installed
apt-get install hwdata

# Check group memberships (possibly adding user as needed)
echo -n "Checking dialout group memberships .... "
checkgroup dialout
echo -n "Checking plugdev group memberships .... "
checkgroup plugdev

# Make sure that an "${WSLCONF_FILE}" file exists
echo -n "Checking for ${WSLCONF_FILE} file .... "
if [ ! -f "${WSLCONF_FILE}" ] || [ ! -s "$WSLCONF_FILE" ]; then
    echo "creating ${WSLCONF_FILE} file"
    cat <<-EOF >"${WSLCONF_FILE}"
# Enable systemd
[boot]
systemd = true
 
# Automatically mount Windows drive when the distribution is launched
[automount]
enabled = true
 


[interop]
enabled = true
appendWindowsPath = true
EOF
    echo "${WSLCONF_FILE} file created"
else
    echo "ok, ${WSLCONF_FILE} file already exists"
fi

echo "*** Done, no errors ***"
