# syntax=docker/dockerfile:1.4

### ---- Stage 1: Build ----
FROM ubuntu:22.04 AS builder

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    pkg-config \
    libusb-1.0-0-dev \
    openssh-client \
    git \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt

# SSH known_hosts setup
RUN mkdir -p /root/.ssh && ssh-keyscan github.com >> /root/.ssh/known_hosts

# Clone and build libairspyhf
RUN --mount=type=ssh git clone git@github.com:airspy/airspyhf.git

WORKDIR /opt/airspyhf
RUN mkdir build && cd build && \
    cmake .. && make -j$(nproc) && make install

# Clone and build hfp_tcp
WORKDIR /opt
RUN --mount=type=ssh git clone git@github.com:gruenwelt/hfp_tcp.git

WORKDIR /opt/hfp_tcp
RUN make -j$(nproc)

### ---- Stage 2: Runtime ----
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    libusb-1.0-0 \
    && rm -rf /var/lib/apt/lists/*

# Copy libairspyhf and hfp_tcp binary
COPY --from=builder /usr/local/lib/libairspyhf.so* /usr/local/lib/
COPY --from=builder /usr/local/include/libairspyhf* /usr/local/include/
COPY --from=builder /opt/hfp_tcp/hfp_tcp /usr/local/bin/hfp_tcp

RUN ldconfig
