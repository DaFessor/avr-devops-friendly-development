# Made4DevOps
**M**odern **A**rduino **D**velopment **E**nvironment for **DevOps**

**Note/todo:** *the parts that are currently missing for this document is instructions for configuring usb.*

## What is Made4DevOps
Made4DevOps is a demonstration project that shows how modern moderne/contemporary tools and methods (development container, CI, CD, GithUb actions etc.)can be used for programming the Arduino AtMega2560.

### Features
Made4DevOps provides all you need to develop C/C++ code for the Arduino:
- A full compiler chain using avr-gcc to compile C and C++ code
- A IDE/editor experience with **full syntax highlighting, code completion** etc.
- Suppport for writing tests for both target and host computer using the **Unity** test framework and the **CMock** isolation framework
- The ability to **flash and run code to the Arduino** and monitor/log the output coming from the serial line of the Arduino
- The ability to create **code coverage reports** for host based tests
- **GitHub actions** for automatically building all "buildables" (firmware/test files for the Arduino and host tests) when a pull request is attempted. All host based tests are also run before a pull request slides through.
- **Automatic publishing** of the latest build of the Arduino firmware file to GitHub pages together with a test coverage report for the build
- Access to fairly **modern versions of C and C++ (C17 and C++17)**

### Ease of use
The full development setup is packaged inside a development container. All you need to do to use Made4DevOps is:
1. Install the necessary software (in this order)
    * [VSCode](https://learn.microsoft.com/en-us/windows/wsl/install)
    * [WSL (Windows Subsystem for Linux)]()
    * [Docker Desktop for AMD64](https://www.docker.com/products/docker-desktop/)
    * [usbipd-win](https://github.com/dorssel/usbipd-win)
    * [Windows Terminal](https://apps.microsoft.com/detail/9n0dx20hk701?hl=en-US&gl=US) (optional but recommended)
1. Clone this repository to a local folder on your PC (preferrable inside your WSL installation)
1. Open the folder holding the cloned repository with VSCode. At this point you can start writing code.
1. At some point you also to setup an usb configuration to flash code to the Arduino.

Step 1 is of cource only done once.

### Forking Made4DevOps
It's perfectly possible to just do steps listed above, and then use Made4DevOps to build and test software for the Arduino, that works well enough. But Made4DevOps only fully shines if you work in a team creating code for the Areduino and/or use a GitHub repository to maintain your code.

To do that you should *fork* the project on GitHub, not just clone it to a local repository. That way you get your own GitHub repository where you make updates to the code and generally tweak it any way you please.

## User's guide - overview
These are the predefined basic tasks you can execute once you start Made4DevOps:y

### Target firmware code
1. Add some file/code to your target firmware
1. Build your target firmware in release or debug configuration
1. Flash and run your target firmware in release or debug configuration on the Arduino
1. Clean/delete all generated target firmware artifacts

### Target test code
5. Add some file/code to your target tests and define new test cases/executables
1. Build your target tests in release or debug configuration
1. Flash and run your target tests in release or debug configuration in the Arduino
1. Clean/delete all generated target test artifacts

### Native/host test code
9. Add some file/code to your native/host test
1. Build your native/host tests in release or debug configuration
1. Run your native/host tests in release or debug configuration and produce a test coverage report
1. Clean/delete all generated native/host test artifacts

### For whole project
13. Build all subprojects (firmware, firmware-tests, native-tests) in debug or release configuraion
1. Clean delete all generated artifacts for all subprojects (firmware, firmware-tests, native-tests)
1. Reset all subprojects (firmware, firmware-tests, native-tests) - like clean but this also deletes all downloaded dependencies, so it's a full reset

## Opening your Made4DevOps project in VSCode
Wip - workspace

## General code/project layout conventions
Separation of src and generated files
All files pertaing to a file in the same spot
Dependencies gets downloaded

## Working with code for target firmware
Wip

## Working with code for target tests
Wip

## Working with for native/host files
Wip