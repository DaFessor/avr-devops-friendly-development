#!/usr/bin/sh

SCRIPTNAME=$(basename "${0}")
USBIPD_EXECUTABLE="/mnt/c/Program Files/usbipd-win/usbipd.exe"

# Write an error message and exit
usage()
{
    printf "\nError: %s" "${1}"
    printf "\nUsage: %s start [<hw-id> <hw-id> ...] -- Start monitoring one or more device(s)" "${SCRIPTNAME}"
    printf "\n       %s stop [<hw-id> <hw-id> ...]  -- Stop monitoring one or more device(s)" "${SCRIPTNAME}"
    printf "\n       %s stop all                    -- Stop monitoring all devices½" "${SCRIPTNAME}"
    exit 1
}

# ***************** Execution starts here *****************
# =========================================================

if [ $# -lt 2 ]; then
    usage "at least a command and 1 device argument required (hw-id of the USB device, like 2341:0042)"
fi

case "${1}" in
    start)
        # Check that usbipd has been installed
        echo -n "Checking installation of usbipd-win .... "
        if ! "${USBIPD_EXECUTABLE}" --version > /dev/null 2>&1; then
            usage "you need to install usbipd-win"
        else
            echo "ok, usbpipd-win is installed"
        fi
        
        shift
        
        for ttydev in "$@"; do
            # Check that the device is not already being monitored
            echo -n "Starting monitoring of device ${ttydev} .... "
            RUNNING_INSTANCE=$(ps -ef | grep -v grep | grep -c "attach --auto-attach --wsl --hardware-id=${ttydev}")
            if [ "${RUNNING_INSTANCE}" -ne 0 ]; then
                echo "ok, usb device ${ttydev} was already being monitored"
            else
                # Start monitoring the device
                echo -n "Checking that device ${1} is available .... "
                if ! "${USBIPD_EXECUTABLE}" list | grep -q "${ttydev}"; then
                    usage "device ${ttydev} not found - has it been attached and shared (bound) using usbipd-win?"
                else
                    echo "ok, device ${ttydev} is available"
                fi
                (set -m; "${USBIPD_EXECUTABLE}" attach --auto-attach --wsl --hardware-id="${ttydev}" &) > /dev/null 2>&1
                echo "ok, usb device ${ttydev} is now monitored and available in WSL whenever the device gets plugged in"
            fi
        done
        
    ;;
    stop)
        if "$2" -eq "all"; then
            echo -n "Stopping monitoring of all devices .... "
            ps -ef | grep "attach --auto-attach --wsl" | grep -v grep | awk '{print $2}' | xargs kill -9
            echo "ok, all monitoring of usb devices has stopped"
        else
            for ttydev in "$@"; do
                # Check that the device is being monitored
                echo -n "Stopping monitoring of device ${ttydev} .... "
                RUNNING_INSTANCE=$(ps -ef | grep -v grep | grep -c "attach --auto-attach --wsl --hardware-id=${ttydev}")
                if [ "${RUNNING_INSTANCE}" -ne 0 ]; then
                    ps -ef | grep "attach --auto-attach --wsl --hardware-id=${ttydev}" | grep -v grep | awk '{print $2}' | xargs kill -9
                    echo "ok, usb device ${ttydev} is no longer being monitored"
                else
                    echo "ok, usb device ${ttydev} was not being monitored"
                fi
            done
        fi
    ;;
    *)
        usage "a command must be specified (start or stop)"
    ;;
esac

exit 0

