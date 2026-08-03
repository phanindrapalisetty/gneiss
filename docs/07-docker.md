# Docker Installation

| Property | Value |
|----------|-------|
| Status | Complete |
| Project | Gneiss |
| Last Updated | 2026-08-03 |

---

# Purpose

Install Docker Engine and Docker Compose to provide the container runtime for all services hosted on Gneiss.

Docker is the foundation upon which CasaOS, Jellyfin, Nextcloud, Airflow, Spark, MinIO, and all other platform services will run.

---

# Prerequisites

- Debian installed
- Git configured
- SSH configured
- Internet connectivity

---

# Background

Docker provides lightweight application isolation using containers.

Instead of installing applications directly on the operating system, every major service in Gneiss runs inside a dedicated container.

Advantages include:

- Isolation
- Easy upgrades
- Reproducibility
- Portability
- Simplified backups

Docker Compose is used to define multi-container applications.

---

# Implementation

## Remove legacy packages

```bash
for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do
    sudo apt remove -y $pkg
done
```

---

## Add Docker GPG Key

```bash
sudo install -m 0755 -d /etc/apt/keyrings

curl -fsSL https://download.docker.com/linux/debian/gpg | \
sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

sudo chmod a+r /etc/apt/keyrings/docker.gpg
```

---

## Add Docker Repository

```bash
echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
https://download.docker.com/linux/debian \
$(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

---

## Install Docker

```bash
sudo apt update

sudo apt install -y \
docker-ce \
docker-ce-cli \
containerd.io \
docker-buildx-plugin \
docker-compose-plugin
```

---

## Allow Non-root Docker Access

```bash
sudo usermod -aG docker phanindra
```

Reconnect to apply the group membership.

---

# Verification

Docker version:

```bash
docker --version
```

Docker Compose:

```bash
docker compose version
```

Container test:

```bash
docker run hello-world
```

Expected output:

```text
Hello from Docker!
```

---

# Troubleshooting

## Permission denied while using Docker

Reconnect or execute:

```bash
newgrp docker
```

---

## Docker daemon not running

```bash
sudo systemctl status docker
```

Start the service:

```bash
sudo systemctl start docker
```

Enable at boot:

```bash
sudo systemctl enable docker
```

---

## Health Check

Verify Docker:

```bash
docker ps
docker images
docker network ls
docker volume ls
docker info


This gives you a standard checklist after every Docker installation.

---

## Next milestone

Once `hello-world` runs successfully and the VS Code extension is refreshed, we'll install **CasaOS**.

After that, we'll **stop using the built-in app store** for deployments and instead connect CasaOS to our Git-managed Docker Compose files. That way, Gneiss stays reproducible, and CasaOS acts as a convenient management UI rather than the source of truth. That's exactly the architecture we've been aiming for. 

# Rollback

Remove Docker:

```bash
sudo apt remove docker-ce docker-ce-cli containerd.io
```

Delete Docker data:

```bash
sudo rm -rf /var/lib/docker
```

---

# Next Steps

Proceed to:

docs/08-casaos.md