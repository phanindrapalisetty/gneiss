# Debian Installation

| Property | Value |
|-|-|
| Status | Complete |
| Project | Gneiss |



# Purpose

Install a minimal Debian server suitable for self-hosting.



# Prerequisites

Hardware:

- Acer Swift 3 SF315-52G
- 16 GB RAM
- HikVision E3000 NVMe SSD



# Background

Debian was selected because:

- Stable
- Lightweight
- Large package ecosystem
- Excellent Docker support

Desktop environments were intentionally omitted to reduce resource usage.



# BIOS Configuration

Original setting:

RST with Optane

Changed to:

AHCI

Reason:

Linux installer could not detect the NVMe SSD while RST was enabled.



# Installation Decisions

Hostname

```text
gneiss
```

Domain

Blank

Root

Disabled

Reason:

Administrative access will be performed using sudo.



# User

Username

```text
phanindra
```



# Partition Layout

Automatic partitioning.

Result:

- EFI
- ext4
- swap

Future user data will be stored on an external HDD.



# Software Selection

Installed

- SSH Server
- Standard System Utilities

Not Installed

- GNOME
- Desktop Environment
- Apache Web Server



# Verification

Verify hostname

```bash
hostname
```

Expected

```text
gneiss
```



# Troubleshooting

## SSD not detected

Cause

Intel RST enabled.

Resolution

Change BIOS storage mode to AHCI.



# Next Step

docs/03-post-installation.md