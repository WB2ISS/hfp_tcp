# hfp_tcp for Airspy HF+ (Dockerized, ARM64 Ready)

This is a fork of [WB2ISS/hfp_tcp](https://github.com/WB2ISS/hfp_tcp) with key enhancements to not lock the Airspy hardware when not connected to a client and then release it once the connection is closed.

> 🐳 Includes a **Dockerfile** for fully containerized building and deployment
> ✅ **Tested on Orange Pi Zero 2W** and **Airspy Discovery HF+**. Should ideally work on other Pis as well including Raspberry Pi.

---

## ✅ Key Improvements

- **No more hardware lockups**: Airspy HF+ now releases cleanly when no client is connected.
- **Dockerfile added**: Build and run without needing to configure the host system.
- **Reduced runtime footprint**: Docker image uses only the runtime dependencies after stripping the build chain.

---

## 📦 Requirements

- An ARM64-based Linux system (Raspberry Pi, Orange Pi, etc.)
- Docker installed
- An **Airspy HF+** USB SDR device connected
- SSH keys configured (for cloning dependencies like `libairspyhf` via SSH)

---

## 🏗️ Build the Docker Image

Make sure your SSH agent is running:

```bash
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa
```

Then build using Docker BuildKit and SSH mount:
```bash
DOCKER_BUILDKIT=1 docker build --ssh default -t hfp_tcp_server .
```

---

## 🚀 Run the Server


```bash
docker run --rm \
  --device /dev/bus/usb \
  -p 1234:1234 \
  hfp_tcp_server
```

---

## 🔧 Alternatively: Manual Build Instructions
If you want to build outside Docker directly on the host:

👉 Refer to the original project for manual build instructions:
[WB2ISS/hfp_tcp](https://github.com/WB2ISS/hfp_tcp)

---

## 📜 License

This project is released under the MIT License.

You are free to use, modify, and distribute it with attribution.
