
# run from hfp_tcp/build-static-macos12
#
LIBUSBSTATICDIRx86  = ../../libusb-1.0.26/build-static-x86_64-macos12
LIBUSBSTATICDIRARM  = ../../libusb-1.0.26/build-static-arm64-macos12
LIBUSBINCLUDE				= ../../libusb-1.0.26/libusb

LIBAIRSPYHFSRC			= ../../airspyhf/libairspyhf/src
LIBAIRSPYHFINCLUDE	= ../../airspyhf/libairspyhf/src

SRCDIR = ..

SOURCE    					=   $(SRCDIR)/hfp_tcp.c
AIRSPYSOURCE				=		$(LIBAIRSPYHFSRC)/airspyhf.c $(LIBAIRSPYHFSRC)/iqbalancer.c

LIBx86 =      $(LIBUSBSTATICDIRx86)/libusb-1.0.a \
							$(LIBUSBSTATICDIRx86)/darwin_usb.o

LIBARM =      $(LIBUSBSTATICDIRARM)/libusb-1.0.a \
							$(LIBUSBSTATICDIRARM)/darwin_usb.o

hfp_tcp:			$(SRCDIR)/hfp_tcp.c

								clang $(SOURCE) $(AIRSPYSOURCE) $(LIBx86) \
								    -framework Foundation  \
							      -framework IOKit  \
										-framework Security \
										-I. \
										-I$(LIBAIRSPYHFINCLUDE) \
										-I$(LIBUSBINCLUDE) \
										-L/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/include \
							      -target x86_64-apple-macos12 -lm -o hfp_tcp-x86_64

								clang $(SOURCE) $(AIRSPYSOURCE) $(LIBARM) \
										 -framework Foundation  \
										 -framework IOKit  \
										 -framework Security \
										 -I. \
										 -I$(LIBAIRSPYHFINCLUDE) \
										 -I$(LIBUSBINCLUDE) \
										 -L/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/include \
										 -target arm64-apple-macos12 -lm -o hfp_tcp-arm64

								lipo -create -output hfp_tcp hfp_tcp-x86_64 hfp_tcp-arm64

								lipo -archs hfp_tcp

								otool -L hfp_tcp
