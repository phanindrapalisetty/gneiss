# Post Installation

| Property | Value |
|-|-|
| Status | Complete |
| Project | Gneiss |



# Purpose

Prepare the operating system for future services.



# Prerequisites

- Debian installed
- User account created



# Implementation

## Update package index

```bash
sudo apt update
```



## Upgrade packages

```bash
sudo apt full-upgrade -y
```



## Install essential utilities

```bash
sudo apt install -y \
git \
curl \
wget \
vim \
nano \
htop \
btop \
tree \
zip \
unzip \
ca-certificates \
gnupg \
lsb-release
```



# Installed Utilities

| Utility | Purpose |
|-|-|
| Git | Version control |
| curl | HTTP requests |
| wget | File downloads |
| Vim | Terminal editor |
| Nano | Beginner-friendly editor |
| htop | Process monitor |
| btop | Resource monitor |
| tree | Directory visualization |
| zip | Archive creation |
| unzip | Archive extraction |
| ca-certificates | HTTPS certificates |
| gnupg | Package verification |
| lsb-release | Distribution information |



# Verification

Hostname

```bash
hostname
```

Expected

```text
gneiss
```

Installed packages

```bash
git --version
curl --version
btop --version
```



# Troubleshooting

## Package installation fails

Run

```bash
sudo apt update
```

and retry.



# Current Status

Completed

- Debian installation
- System update
- Utility installation

Pending

- Git configuration
- Docker
- CasaOS



# Next Step

docs/04-git.md