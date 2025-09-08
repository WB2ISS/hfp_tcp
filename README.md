# hfp\_tcp

>Stream signals from an Airspy HF+ radio to **[SDR Receiver for iOS and iPadOS](https://itunes.apple.com/us/app/sdr-receiver/id1289939888)**, **[SDR Receiver for macOS](https://apps.apple.com/us/app/sdr-receiver/id1483894151)**, or to any application that supports the `rtl_tcp` protocol.
>
>A pre-built universal binary executable version of `hfp_tcp` for macOS is available on the [SDR Receiver Downloads page](https://www.transitiontechnologyventures.com/sdr-receiver/downloads/).  It will run on x86 or Apple Silicon Macs with macOS 12 Monterey or later.  This executable is self-contained and does not require separate installation of the Airspy HF+ library or `libusb`.

The `hfp_tcp` application is a streaming server that implements the `rtl_tcp` protocol for an Airspy HF+ radio.  It enables any application that supports `rtl_tcp` to stream data over a network from an Airspy HF+. These directions explain how to build and run `hfp_tcp` on a Mac or Raspberry Pi.

## Download and Build hfp_tcp

Building `hfp_tcp` from source will generally consist of two steps: 1. Download and build the Airspy HF+ library; 2. Download and build `hfp_tcp`. In the first step, the `libairspyhf` dynamic library will be built, and the library and header files will be placed in standard system locations.  In the second step, the compile and link process will look in these standard locations to find the library and header files that are required to build and run `hfp_tcp`.  

If the server is a Raspberry Pi and the Airspy SPY Server has previously been installed, the first step will have already been completed and does not need to repeated.  In this case, skip the first step and just follow the directions under the second step.


### 1. Download and Build the Airspy HF+ Library

The Airspy HF+ library is an open source package that includes a library and user mode driver. The source code and directions for building the package are in the [Airspy GitHub repository](https://github.com/airspy/airspyhf).

To build the Airspy HF+ library on Raspberry Pi OS, follow the directions under “How to build the host software on Linux” in the README in the repository.

To build the library on macOS, the first step of the Airspy directions for Linux (the command beginning `sudo apt-get install`) must be replaced by an alternative series of steps which install `cmake`, `libusb` and `pkg-config`.  These can be installed using the `brew` package manager, or they can be built from source without using `brew`.  Both methods are described below.

For either method, start by installing the Xcode Command Line Tools:

	xcode-select --install

For the first method, start by installing `brew`:

	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

Then,  using `brew`, install `cmake`, `libusb`, and `pkg-config`:

	brew install cmake
	brew install libusb
	brew link libusb
	brew install pkg-config

The `libusb` link step will attempt to create symbolic links in `/usr/local/lib` for `libusb-1.0.0.dylib` and `libusb-1.0.dylib` and some other files, and will fail if any of these exist.  If that happens, move or remove the files that are reported as already existing and then repeat the link step.

For the second method, `cmake`, `libusb` and `pkg-config` are built from source without using `brew`.  Building `libusb` will require Xcode which can be downloaded from the Mac App Store.

To build `cmake` start by downloading the `cmake` source for Unix/Linux from [cmake.org](https://cmake.org/download/). Then execute the following commands in the top level directory:

	./bootstrap
	make
	sudo make install

The last step installs the `cmake` command line utility in `/usr/local/bin`.

Next build `libusb`.  The `libusb` project is on GitHub: [libusb/libusb: A cross-platform library to access USB devices](https://github.com/libusb/libusb).  Clone the project:

	git clone https://github.com/libusb/libusb.git
	cd libusb/Xcode

Open `libusb.xcodeproj` in Xcode.  Choose an appropriate Deployment Target for `libusb` and then build the `libusb` target.  The dynamic library and header file now need to be moved to the correct locations.  

In Xcode, locate the Build directory containing the dynamic library and header file by selecting Product → Show Build Folder in Finder.  Then, in the Build directory, navigate to `Products/Release` to locate `libusb-1.0.0.dylib`.  Copy `libusb-1.0.0.dylib` to `/usr/local/lib` and create a symbolic to it as follows:

	cd Products/Release
	cp libusb-1.0.0.dylib /usr/local/lib
	cd /usr/local/lib
	sudo ln -s libusb-1.0.0.dylib libusb-1.0.dylib

Go back to the Build directory.  Then go to the directory containing the header file and copy it to `/usr/local/include`, as follows:

	cd Products/Release/usr/local/include
	cp libusb.h /usr/local/include

To build `pkg-config` start by downloading the latest version of the source code from [freedesktop.org](https://pkg-config.freedesktop.org/releases/). Navigate to the directory containing the source code and then build and install `pkg-config` as follows:

	LDFLAGS="-framework CoreFoundation -framework Carbon" ./configure --with-internal-glib
	make
	sudo make install

The last step installs `pkg-config` in `/usr/local/bin`.

Finally, after installing `cmake`, `libusb` and `pkg-config` either with `brew` or by building from source, download and build `libairspyhf`:

	git clone https://github.com/airspy/airspyhf.git
	cd airspyhf
	mkdir build
	cd build
	cmake ../ -DINSTALL_UDEV_RULES=ON
	make
	sudo make install

The last step installs `libairspyhf` in `/usr/local/lib` and installs various other files in standard system location.

### 2. Download and Build hfp_tcp

The `hfp_tcp` application is a single source file.  It can be built and installed with the included Makefile which requires header files and a dynamic library that are installed as part of building the Airspy HF+ library.  The build process for `hfp_tcp` is the same for both macOS and Raspberry Pi OS.  

To clone the repository and build `hfp_tcp`, execute the following commands in a terminal window:

	git clone https://github.com/WB2ISS/hfp_tcp.git
	cd hfp_tcp
	make
	sudo make install

The target operating system will be detected and applied to obtain the correct compile and link commands.  The detected operating system will be displayed as Darwin for macOS and as Linux for Raspberry Pi OS, and the build command that is being executed will be shown.  The `sudo make install` step will copy the executable into `/usr/local/bin`.

Compilation requires the header files `airspyhf.h` and `airspyhf_commands.h` and the executable requires the `libairspyhf` dynamic library. If the Airspy HF+ library has been installed, these dependencies will have been placed in the correct locations and will be found by the compile and link process.  

## Running hfp\_tcp
To run `hfp_tcp`, connect an Airspy HF+ radio to the system by USB.  The `hfp_tcp` server can then be executed  with the command `hfp_tcp`.  By default, the server will listen for an incoming TCP/IP connection on port 1234.  An alternate port can be specified with the `-p` flag.  For example, to start the server listening on port 1024, the command is:  `hfp_tcp -p 1024`.

By default, for compatibility with the `rtl_tcp` protocol, `hfp_tcp` streams data consisting of 8-bit samples.  In order to take advantage of the additional resolution of the analog to digital converter in the Airspy HF+ radio, `hfp_tcp` can also stream data consisting of 16-bit samples to clients that are able to process this extended precision data.  To stream 16-bit samples, start `hfp_tcp` with the `-b 16` flag and ensure that the client is set to receive 16-bit data.  In **SDR Receiver** go to the Settings tab, select Sampling and set Sample Size to 16-bit.  

Readme.v19
