# hfp\_tcp

>Stream signals from an Airspy HF+ radio to **[SDR Receiver](https://itunes.apple.com/us/app/sdr-receiver/id1289939888?ls=1&mt=8)**, a software defined radio receiver for iOS, or to any application that supports the rtl_tcp protocol.


## Download and Build hfp_tcp
The hfp\_tcp application is a streaming server that implements the rtl\_tcp protocol for an Airspy HF+ radio.  It enables any application that supports the rtl_tcp protocol to stream data over a network from an Airspy HF+ radio. These directions explain how to build and run the hfp\_tcp application on a Mac or Raspberry Pi.

The hfp\_tcp application consists of a single source file which requires two header files and a dynamic library that are part of the Airspy HF+ Library package.   Building hfp_tcp will generally consist of two steps:

	1. Download and build the Airspy HF+ library.
	2. Download and build hfp_tcp.

The first step will place the dynamic library and header files in standard system locations.  In the second step, the compile and link process will look in these standard locations to locate the header files and dynamic library that are required to build and run hfp_tcp.

If the Airspy SPY Server application has been successfully installed on the Raspberry Pi, Step 1 below will have already been completed and it does not need to repeated.  In this case, skip Step 1 and just follow the directions under Step 2.


### 1. Download and Build the Airspy HF+ Library

The Airspy HF+ Library is an open source  package that includes a library and user mode driver for the Airspy HF+ radio.  The source code and directions for building the package are in the Airspy airspyhf GitHub repository at: [airspy/airspyhf: Code repository for AirspyHF+](https://github.com/airspy/airspyhf/).

To build the library on Raspberry Pi Raspbian, follow the directions under “How to build the host software on Linux” in the README on the Airspy airspyhf GitHub repository.  

To build the library on macOS, the first step of the Airspy directions for Linux:

		sudo apt-get install build-essential cmake libusb-1.0-0-dev pkg-config

must be replaced by a series of steps which install utilities and libraries that are required to build libairspyhf.  These utilities and libraries are: brew, libusb, cmake and pkg-config.  The initial step of installing brew will also install some other packages including the Xcode Command Line Tools.  The complete sequence is as follows:

**Install Homebrew**

[HomeBrew](https://brew.sh/)

		/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"


**Install libusb**

[libusb](http://macappstore.org/libusb/)  
[How to set up libusb on Mac OS X? - Stack Overflow](https://stackoverflow.com/questions/3853634/how-to-set-up-libusb-on-mac-os-x)

		brew install libusb
		brew link libusb

The link step will attempt to create symbolic links in /usr/local/lib
for libusb-1.0.0.dylib and libusb-1.0.dylib and some other files, and
will fail if any of these exist.  If that happens, move or remove the
files that are reported as already existing.

**Install CMake**

[CMake](https://cmake.org/download/)  
[homebrew - Installing cmake with home-brew - Stack Overflow](https://stackoverflow.com/questions/32185079/installing-cmake-with-home-brew)

		brew install cmake

**Install pkg-config**

		brew install pkg-config

**Download and Build libairspyhf**

[airspy/airspyhf: Code repository for AirspyHF+](https://github.com/airspy/airspyhf/)

		git clone https://github.com/airspy/airspyhf.git
		cd airspyhf
		mkdir build
		cd build  
		cmake ../ -DINSTALL_UDEV_RULES=ON  
		make  
		sudo make install

### 2. Download and Build hfp_tcp

The hfp\_tcp application is a single source file.  It can be built with the included Makefile which requires header files and a dynamic library that were installed in Step 1 above.  The process is the same for both macOS and Raspberry Pi Raspbian.

The following commands should be executed in a terminal window.  These commands will clone the hfp\_tcp repository into a local directory and will then build and install the executable:

		git clone https://github.com/WB2ISS/hfp_tcp.git
		cd hfp_tcp
		make
		sudo make install

The target operating system will be detected and applied to obtain the correct compile and link command for the target system.  The detected OS will be displayed as Darwin for macOS and Linux for Raspberry Pi Raspbian, and the build command that is being executed will be shown.   The `sudo make install` step will copy the executable into /usr/local/lib where it will be found as part of the standard execution path.

Compilation requires the header files `airspyhf.h` and `airspyhf_commands.h` and the executable requires the libairspyhf driver. If the Airspy HF+ Library has been installed as described in Step 1, these dependencies will have been placed in standard system locations and will be located by the compile and link process.  

By cloning the hfp\_tcp repository it becomes very easy to obtain updates.  First cd to the the hfp\_tcp repository. Then the steps are:

		git pull
		make
		sudo make install

The `git pull` step will obtain updates to the repository if there are any.  Then, if there was an update, the `make` step will detect that, and if the source code was updated it will build a new executable.  The `sudo make install` step will install the new executable in /usr/local/bin.

## Running hfp\_tcp
To run the hfp\_tcp application, connect an Airspy HF+ radio to the system via USB.  The hfp\_tcp application can then be executed with the command `hfp_tcp`.  By default, the application will listen for an incoming TCP/IP connection on port 1234.  An alternate port can be specified with the -p flag.  For example, to start the application listening on port 1024, the command is:  `hfp_tcp -p 1024`.

By default, for compatibility with the rtl_tcp protocol, hfp_tcp streams data consisting of 8-bit samples.  In order to take advantage of the additional resolution of the analog to digital converter in the Airspy HF+ radio, hfp_tcp can also stream data consisting of 16-bit samples.  To stream 16-bit samples to SDR Receiver, start hfp_tcp with the -b 16 flag and in SDR Receiver, on the Settings tab, select Sampling and set Sample Size to 16-bits.  

Readme.v18
