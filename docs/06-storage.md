# Storage Architecture

| Property | Value |
|----------|-------|
| Status | Complete |
| Project | Gneiss |
| Last Updated | 2026-08-03 |

---

# Purpose

Define the storage architecture for Gneiss and establish a consistent layout for operating system files, persistent application data, media, backups, and future expansion.

---

# Prerequisites

- Debian installed
- System updated
- Git configured
- SSH access configured

---

# Background

Gneiss uses two storage tiers:

1. **NVMe SSD** for the operating system, Docker engine, configuration, and application runtime.
2. **External HDD** for persistent user data, media, databases, backups, and analytics data.

Separating system files from persistent data simplifies maintenance, upgrades, and disaster recovery.

---

# Storage Design

## NVMe SSD

Stores:

- Debian
- Docker Engine
- Docker images
- Docker Compose files
- Git repository
- Logs
- Configuration files

## External HDD

Stores:

- Media
- Photos
- Personal cloud data
- Database files
- Object storage
- Lakehouse data
- Backups

---

# Directory Layout

```text
/mnt/storage
├── media/
├── photos/
├── cloud/
├── databases/
├── object-storage/
├── lakehouse/
├── backups/
├── logs/
└── temp/
```

---

# Repository Layout

```text
~/Projects/gneiss
├── docs/
├── compose/
├── scripts/
├── configs/
└── README.md
```

---

# Filesystem

Initial filesystem:

- ext4

Reason:

- Stable
- Mature
- Excellent Linux support
- Simple recovery

Future migration to Btrfs remains possible if snapshot functionality becomes desirable.

## Storage Layout

The external HDD may already contain personal files.

Rather than requiring a dedicated drive, Gneiss stores all platform-managed data inside a dedicated directory:

```text
/mnt/storage/Gneiss
```

This approach:

- Preserves existing user data.
- Simplifies migration.
- Clearly separates platform data from personal files.

---

# Docker Storage

Docker services should use bind mounts into `/mnt/storage` instead of anonymous Docker volumes.

Example:

```yaml
volumes:
  - /mnt/storage/databases/postgres:/var/lib/postgresql/data
```

---

# Verification

Verify mount:

```bash
mount | grep storage
```

Verify free space:

```bash
df -h
```

Verify block devices:

```bash
lsblk
```

---

# Troubleshooting

## External HDD not mounted

Verify:

```bash
lsblk
```

Check `/etc/fstab`:

```bash
cat /etc/fstab
```

Mount manually:

```bash
sudo mount -a
```

---

# Rollback

Unmount storage:

```bash
sudo umount /mnt/storage
```

Remove mount point:

```bash
sudo rmdir /mnt/storage
```

---

# Next Steps

Proceed to:

docs/07-docker.md