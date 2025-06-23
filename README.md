# hfp_tcp for  Airspy HF+ Discovery and the like

This is a fork of [WB2ISS/hfp_tcp](https://github.com/WB2ISS/hfp_tcp) with key enhancements to not lock the Airspy hardware when not connected to a client and also release it once the connection is closed.

> 🐳 Includes a **Dockerfile** for fully containerized building and deployment
> ✅ Tested on **Orange Pi Zero 2W** and **Airspy Discovery HF+** and remote connected from an iPhone with SDR Receiver app installed. Should be able to run on other arm64 single-board computers like Raspberry Pi or other linux computers.

---

## ✅ Key Improvements

- **No more hardware lockups**: Airspy HF+ Discovery now releases cleanly when no client is connected.
- **Dockerfile added**: Build and run without needing to configure the host system.

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
docker run -d \
  --name hfp_tcp_server \
  --device /dev/bus/usb \
  -p 1234:1234 \
  hfp_tcp_server
```

---

## 🔧 Alternatively: Manual Build Instructions
If you want to build outside Docker directly on the host 👉 Refer to the original project for manual build instructions:
[WB2ISS/hfp_tcp](https://github.com/WB2ISS/hfp_tcp)

---

## 📜 License

This project is released under the MIT License.

You are free to use, modify, and distribute it with attribution.
