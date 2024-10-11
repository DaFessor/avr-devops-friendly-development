#!/usr/bin/sh

USBID_OVERRIDE_FILE="$(dirname ${0})/usb_override.cfg"
TTYLINK="/dev/ttyFLASH"
USBIPD_EXECUTABLE="/mnt/c/Program Files/usbipd-win/usbipd.exe"
USER=${SUDO_USER}

# Write an error message and exit
usage()
{
    echo "Error: ${1} "
    exit 1
}

# Make sure that the user is member of a specified group, and add the
# user to the group if that's not the case
checkgroup()
{
    if ! grep "${USER}" /etc/group | grep -q "${1}"; then
        echo "adding user ${USER} to ${1} group"
        usermod -a -G "${1}" "${USER}"
    else
        echo "ok, user ${USER} already in ${1} group"
fi
}

# Make a snapshot (file with a list) of all currently available tty devices
snapshot_tty_state()
{
    ls -l /dev/tty* | sort > "/tmp/${1}.ttystate"
}

# Remove all existing files with lists of tty devives
clear_tty_snapshots()
{
    rm -rf /tmp/*.ttystate
}

# Detect which tty device has disappeared
get_removed_tty()
{
    TTYDEV="$(diff -b /tmp/before.ttystate /tmp/after.ttystate | grep "^<.*tty.*$" | grep -o "/dev/tty.*$")"
}

# Detect which tty device has been added
get_added_tty()
{
    TTYDEV="$(diff -b /tmp/before.ttystate /tmp/after.ttystate | grep "^>.*tty.*$" | grep -o "/dev/tty.*$")"
}

# ***************** Execution starts here *****************
# =========================================================

# Check root permissions
if [ "$(id -u)" -ne 0 ]; then
    usage "please run this script as root or using sudo!"
fi

# Check that usbipd has been installed
echo -n "Checking installation of usbpid .... "
if ! "${USBIPD_EXECUTABLE}" --version 2>&1 > /dev/null; then
    usage "you need to install usbipd"
else
    echo "ok, usbpipd is installed"
fi

# Check to see if there's any persisted/shared sub devices available
NUMSHARED_USBIDS="$("${USBIPD_EXECUTABLE}" list | grep -E "Shared|Attached" | wc -l)"
if [ "${NUMSHARED_USBIDS}" -lt 1 ]; then
    usage "no persisted/shared usb devices found (did you forget 'usbipd.exe bind'?)"
fi

# Check for presence (and validate contents, if found) of tty/usb override file
USBID_OVERRIDE=""
if [ -f "${USBID_OVERRIDE_FILE}" ]; then
    # tty-usb override file found, check info from that
    if [ -z "$(cat ${USBID_OVERRIDE_FILE} | grep -E '^[1-9]-[1-9]*$')" ]; then
        usage "usb-id override file found, but no valid bus-id info was found in it"
    else
        USBID_OVERRIDE="$(cat ${USBID_OVERRIDE_FILE} | grep -E '^[1-9]-[1-9]*$')"
        # Make sure that specified override usb-id is in fact shared
        if [ ! "$("${USBIPD_EXECUTABLE}" list | grep -E "Shared|Attached" | grep ${USBID_OVERRIDE})" ]; then
            usage "usb-id config file found, but specified bus-id <${USBID_OVERRIDE}> is not shared (did you forget 'usbipd.exe bind'?)"
        else
            echo "Found valid usb-id override config <${USBID_OVERRIDE}>, will try to use that"
        fi
    fi
fi

# If there's more than 1 persisted/shared usb-id available, an usb-id override must be used
if [ "${NUMSHARED_USBIDS}" -gt 1 ]; then
    if [ -z "${USBID_OVERRIDE}" ] ; then
        usage "more than 1 shared usb-id's found (use usb-id override file to select the usb-id to use)"
    fi
    USBID="${USBID_OVERRIDE}"
else
    # There's only 1 persisted/shared usb-id available
    if [ -n "${USBID_OVERRIDE}" ]; then
        USBID="${USBID_OVERRIDE}"
    else
        USBID="$("${USBIPD_EXECUTABLE}" list | grep -E "Shared|Attached" | grep -o -E '^[1-9]-[1-9]*')"
        echo "Found single shared usb-id <${USBID}>, will try to use that"
    fi
fi

# Check group memberships (possibly adding user as needed)
echo -n "Checking dialout group memberships .... "
checkgroup dialout
echo -n "Checking plugdev group memberships .... "
checkgroup plugdev

# Remove any existing usb mount
clear_tty_snapshots
if "${USBIPD_EXECUTABLE}" list | grep -E "Attached" | grep -q "${USBID}"; then
    echo -n "Detaching existing usb mount for <${USBID}> .... "
    snapshot_tty_state "before"
    if  ! "${USBIPD_EXECUTABLE}" detach "--busid=${USBID}" 2>&1 > /dev/null; then
        usage "usbipd detach of <${USBID}> failed, aborting script (unknown error)"
    fi
    sleep 2
    snapshot_tty_state "after"
    get_removed_tty
    if [ -n "${TTYDEV}" ]; then
        rm -rf "${TTYDEV}"
        echo "usb-id <${USBID}> mounted on ${TTYDEV} was detached"
    else
        echo "detaching <${USBID}> did not result in a tty device being removed"
    fi

    rm -rf "${TTYLINK}"
    clear_tty_snapshots
else
    echo "No existing usb mount for <${USBID}>, no detach needed"
fi

# Kick to udev service to make sure it runs and detects new serial devices
sleep 1
echo -n "Restart udev service .................. "
if ! service udev restart 2>&1 > /dev/null; then
    usage "failed (unknown error)"
else
    echo "ok"
fi
sleep 2

# Reattach usb-id
echo "Attaching usb-id <${USBID}> .... "
snapshot_tty_state "before"
if ! "${USBIPD_EXECUTABLE}" attach --wsl "--busid=${USBID}"; then
    usage "could not attach usb device ${USBID}"
fi
sleep 1

echo -n "Waiting for new tty device to appear .... "
for value in 1 2 3 4 5 6 7 8 9 10; do
    sleep 1
    snapshot_tty_state "after"
    get_added_tty
    if [ -c "${TTYDEV}" ]; then
        echo "saw new mount pop up on ${TTYDEV}"
        break
    fi
done
clear_tty_snapshots

# Did we find a new, freshly added tty device?
if [ -c "${TTYDEV}" ]; then
    # Yes we, did
    echo "Found and attached usb device ${USBID} on ${TTYDEV}"
    ln -s "${TTYDEV}" "${TTYLINK}"
    chmod 660 "${TTYLINK}"
    chown -f -h -P root:dialout "${TTYLINK}"
    echo "Created symbolic link ${TTYLINK} for device ${TTYDEV} with }usb-id <${USBID}>"
    echo "- use ${TTYLINK}, it will always be the same, even if the tty/com port changes"
else
    # Nope, no tty device
    usage ">>> Error, no new tty device appeared after attaching <${USBID}> <<<"
fi

echo "*** Done, no errors ***"