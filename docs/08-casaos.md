# CasaOS Installation

| Property | Value |
|----------|-------|
| Status | Complete |
| Project | Gneiss |
| Last Updated | 2026-08-03 |

---

# Purpose

Install CasaOS to provide a web-based management interface for the Gneiss homelab.

CasaOS will be used as a convenient dashboard for managing applications, monitoring services, and accessing the server remotely.

The Git repository remains the authoritative source for infrastructure definitions.

---

# Prerequisites

- Debian 13 installed
- Docker Engine installed
- Docker Compose installed
- SSH configured
- Internet connectivity

Reference:

- docs/07-docker.md

---

# Background

CasaOS is a lightweight home server management platform.

Within Gneiss it is **not** responsible for infrastructure management.

Instead, Docker Compose files stored in Git define all services.

CasaOS provides:

- Web dashboard
- Application discovery
- Container management
- File browser
- Resource monitoring

Infrastructure changes continue to be performed using Git and Docker Compose.

---

# Architecture

MacBook

↓

Git Repository

↓

Docker Compose

↓

Docker Engine

↓

CasaOS Dashboard

---

# Implementation

## Install CasaOS

Run:

```bash
curl -fsSL https://get.casaos.io | sudo bash
```

The installer downloads the required packages and configures CasaOS automatically.

---

## Verify Services

```bash
sudo systemctl status casaos
```

---

## Determine Server Address

```bash
hostname -I
```

Example:

```text
192.168.1.9
```

---

## Open CasaOS

Visit:

```text
http://192.168.1.9
```

Complete the initial web setup.

---

# Verification

Verify the CasaOS service:

```bash
sudo systemctl status casaos
```

Verify Docker containers:

```bash
docker ps
```

Verify web interface:

Open:

```text
http://<server-ip>
```

The CasaOS dashboard should load successfully.

---

# Troubleshooting

## CasaOS service not running

Restart:

```bash
sudo systemctl restart casaos
```

---

## Unable to access the web interface

Verify the server IP:

```bash
hostname -I
```

Ensure both the MacBook and Gneiss are connected to the same network.

---

## Docker containers not visible

Verify Docker:

```bash
docker info
```

Restart CasaOS:

```bash
sudo systemctl restart casaos
```

---

# Rollback

Uninstall CasaOS:

```bash
casaos-uninstall
```

Docker and Docker Compose remain installed.

---

# Next Steps

Proceed to:

docs/09-homepage.md