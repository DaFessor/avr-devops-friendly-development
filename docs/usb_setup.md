
# USB setup

- Install
- Configure
- Operate

## Install

### Windows

- VS Code https://code.visualstudio.com/
- Docker Desktop https://www.docker.com/products/docker-desktop/
- usbipd-win https://github.com/dorssel/usbipd-win Just download .msi file and install

### WSL

sudo apt-get install hwdata

## Old setup

Container created with "type=bind,source=/dev,target=/dev/host" arguments

Script util_configure_usb.sh

- Check root permissions
- Check usbipd.exe has been installed
- Look for existing shared/attached usb devices
- Check for presence (and validate contents, if found) of tty/usb override file
- If there's more than 1 persisted/shared usb-id available, look fornan usb-id override file
- Check group memberships (possibly adding user as needed) of dialout plugdev
- Remove any existing usb attatch
- Kick to udev service to make sure it runs and detects new serial devices
- (Re-)attach usb device discovered in step 3
- Wait for/check that new attached usb device occurs

## New setup

### Outside dev container

Windows: usbipd.exe running. Usb bind needed manually with admin permissions, can be done via WSL Usb manager GUI or Powershell.

WSL: udev working, plug devices show up when attached.

### Inside dev container

Attached Arduino can be seen via lsusb:

    > lsusb
    Bus 001 Device 001: ID 1d6b:0002 Linux 5.15.167.4-microsoft-standard-WSL2 vhci_hcd USB/IP Virtual Host Controller
    Bus 001 Device 007: ID 2341:0042 Arduino (www.arduino.cc) 
    Bus 002 Device 001: ID 1d6b:0003 Linux 5.15.167.4-microsoft-standard-WSL2 vhci_hcd USB/IP Virtual Host Controller

and detected using hw major 166:

    > ls -l /dev/tty* | grep 166
    crw-rw----    1 root     dialout   166,   0 Feb  1 14:19 /dev/ttyACM0

## Log

###
Enable wsl interop settings by creating file in WSL2 in /etc/wsl.conf:

    # Enable systemd
    [boot]
    systemd=true

    # Automatically mount Windows drive when the distribution is launched
    [automount]
    enabled = true

    # Make WSL support interop processes like launching Windows apps and adding path variables.
    [interop]
    enabled = true
    appendWindowsPath = true


Step 1 = plug in Arduino

In Powershell with administrative privileges

    ❯ usbipd.exe list
    Connected:
    BUSID  VID:PID    DEVICE                                                        STATE
    2-5    04d9:0295  USB Input Device                                              Not shared
    2-6    0db0:bb5a  Realtek USB Audio, USB Input Device                           Not shared
    3-3    2341:0042  USB Serial Device (COM3)                                      Not shared  <<<---
    3-4    1532:0555  Razer BlackShark V2 Pro                                       Not shared
    3-5    1462:7d51  USB Input Device                                              Not shared
    4-1    1532:0099  USB Input Device, Razer Basilisk V3                           Not shared
    5-2    05e3:0732  USB Mass Storage Device                                       Not shared
    6-4    046d:085c  c922 Pro Stream Webcam, C922 Pro Stream Webcam                Not shared
    7-2    046d:c52b  Logitech USB Input Device, USB Input Device                   Not shared

    ❯ usbipd.exe bind --hardware-id=2341:0042
    usbipd: info: Device with hardware-id '2341:0042' found at busid '3-3'

In normal WSL/bash

    ❯ usbipd.exe attach --auto-attach --wsl --hardware-id=2341:0042
    usbipd: info: Device with hardware-id '2341:0042' found at busid '3-3'.
    usbipd: info: Using WSL distribution 'Ubuntu' to attach; the device will be available in all WSL 2 distributions.
    usbipd: info: Using IP address 172.18.80.1 to reach the host.
    usbipd: info: Starting endless attach loop; press Ctrl+C to quit.
    WSL Attached

    ~ took 22s
    ❯

Note for autoattach to work the command needs to run continuously!!
Windows app https://gitlab.com/alelec/wsl-usb-gui/-/releases works nicely, but it's a bit heavy handed to have this running for autoattach?

