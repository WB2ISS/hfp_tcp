# syntax=docker/dockerfile:1.4

FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# ---- Stage: Build ----
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    pkg-config \
    libusb-1.0-0-dev \
    openssh-client \
    git \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt

# Add GitHub to known_hosts so SSH won't fail on host verification
RUN mkdir -p /root/.ssh && \
    ssh-keyscan github.com >> /root/.ssh/known_hosts

# Use SSH agent to clone libairspyhf
# Requires: DOCKER_BUILDKIT=1 and --ssh default
RUN --mount=type=ssh git clone git@github.com:airspy/airspyhf.git

# Build and install libairspyhf
WORKDIR /opt/airspyhf
RUN mkdir build && cd build && \
    cmake .. && \
    make -j$(nproc) && \
    make install && \
    ldconfig

# Clone and build hfp_tcp
WORKDIR /opt
RUN --mount=type=ssh git clone git@github.com:gruenwelt/hfp_tcp.git

WORKDIR /opt/hfp_tcp
RUN make -j$(nproc) && make install

# Clean up build dependencies
RUN apt-get remove -y \
    build-essential \
    cmake \
    pkg-config \
    libusb-1.0-0-dev \
    git \
    openssh-client && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /opt/airspyhf /opt/hfp_tcp/*.o

# Runtime-only dependencies
RUN apt-get update && apt-get install -y libusb-1.0-0 && rm -rf /var/lib/apt/lists/*

# Expose the TCP port if needed
EXPOSE 1234

# Default CMD (adjust to match your hfp_tcp usage)
CMD ["hfp_tcp"]
