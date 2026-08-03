# docs/09-storage.md

# Persistent Storage Configuration

| Property | Value |
|----------|-------|
| Status | Complete |
| Project | Gneiss |
| Last Updated | 2026-08-03 |

---

# Purpose

Configure a persistent storage volume for application data and media.

The external HDD stores all persistent data while the internal SSD hosts the operating system.

---

# Prerequisites

- Debian 13 installed
- External HDD connected
- Existing data preserved
- Docker installed

---

# Background

Storage is mounted using UUID instead of device name to ensure consistent mounting after reboot.

Existing NTFS data is preserved.

Mount point:

```
/mnt/storage
```

---

# Storage Layout

```
/mnt/storage
│
├── Movies/
├── Documents/
├── Photos/
│
└── Gneiss/
    ├── apps/
    │   ├── homepage/
    │   ├── jellyfin/
    │   ├── immich/
    │   └── nextcloud/
    │
    ├── data/
    │   ├── databases/
    │   │   └── postgres/
    │   │
    │   ├── object-storage/
    │   │   └── minio/
    │   │
    │   ├── lakehouse/
    │   │   ├── iceberg/
    │   │   ├── spark/
    │   │   └── trino/
    │   │
    │   └── metadata/
    │       └── openmetadata/
    │
    ├── media/
    │   ├── movies/
    │   ├── tv/
    │   ├── music/
    │   └── photos/
    │
    ├── shared/
    ├── backups/
    ├── configs/
    ├── logs/
    └── temp/
```

---

# Implementation

## Verify storage device

```bash
lsblk -f
```

```bash
sudo blkid
```

Device:

```
/dev/sda1
```

Filesystem:

```
NTFS
```

UUID:

```
8228BC9D28BC91A1
```

---

## Create mount point

```bash
sudo mkdir -p /mnt/storage
```

---

## Configure /etc/fstab

```fstab
UUID=8228BC9D28BC91A1 /mnt/storage ntfs-3g defaults,uid=1000,gid=1000,windows_names,nofail 0 0
```

---

## Mount

```bash
sudo mount -a
```

---

## Verify

```bash
df -h
```

Expected:

```
/dev/sda1 mounted at /mnt/storage
```

---

## Create directory structure

```bash
mkdir -p \
/mnt/storage/Gneiss/apps/{homepage,jellyfin,immich,nextcloud} \
/mnt/storage/Gneiss/data/databases/postgres \
/mnt/storage/Gneiss/data/object-storage/minio \
/mnt/storage/Gneiss/data/lakehouse/{iceberg,spark,trino} \
/mnt/storage/Gneiss/data/metadata/openmetadata \
/mnt/storage/Gneiss/media/{movies,tv,music,photos} \
/mnt/storage/Gneiss/{shared,backups,configs,logs,temp}
```

---

# Verification

```bash
df -h
```

```bash
tree -L 4 /mnt/storage/Gneiss
```

Persistent storage is available across reboots.

---

# Troubleshooting

## Drive not mounted

```bash
sudo mount -a
```

Review:

```bash
cat /etc/fstab
```

---

## Verify UUID

```bash
sudo blkid
```

---

## Verify mount

```bash
mount | grep storage
```

---

# Rollback

Restore the backup:

```bash
sudo cp /etc/fstab.bak /etc/fstab
```

Unmount:

```bash
sudo umount /mnt/storage
```

---

# Design Decisions

- OS remains on the internal NVMe SSD.
- Persistent data resides on the external HDD.
- UUID-based mounting ensures stable device mapping.
- Application data is separated from personal media.
- Infrastructure directories mirror the Git repository layout.

---

# Next Steps

- Reserve a static IP address.
- Deploy Homepage using Docker Compose.