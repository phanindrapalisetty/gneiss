# 06 - Operations & Startup Automation

## Overview

Gneiss uses a small operational framework to manage all Docker Compose services consistently.

Instead of manually running `docker compose up/down` for each service, all lifecycle operations are handled through:

- Makefile
- Shell scripts
- systemd

This provides:

- Automatic startup after reboot
- Consistent operational commands
- Scalable service discovery
- Separation by platform groups

---

# Directory Structure

```text
compose/
├── infrastructure/
├── monitoring/
├── data-platform/
├── applications/
└── scripts/
    ├── common.sh
    ├── up.sh
    ├── stop.sh
    └── down.sh
```

---

# Service Groups

Services are organized into logical groups.

```text
Infrastructure
├── Homepage
├── Portainer
└── Caddy

Monitoring
├── Prometheus
├── Grafana
└── Loki

Data Platform
├── PostgreSQL
├── MinIO
├── Spark
├── Trino
└── Airflow

Applications
└── Future applications
```

Scripts automatically discover Docker Compose projects inside each group.

---

# common.sh

Contains shared configuration used by every operational script.

Responsibilities:

- Repository root discovery
- Platform directory definitions
- Shared constants

Example:

```bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

INFRA_DIR="$ROOT/infrastructure"
MONITORING_DIR="$ROOT/monitoring"
DATA_DIR="$ROOT/data-platform"
APPLICATIONS_DIR="$ROOT/applications"
```

All other scripts source this file.

---

# up.sh

Starts Docker Compose services.

Features:

- Starts services by platform group
- Automatically discovers compose projects
- Starts containers in detached mode
- Skips groups that do not yet exist

Examples:

```bash
./up.sh
```

Starts everything.

```bash
./up.sh infrastructure
```

Starts only infrastructure.

```bash
./up.sh monitoring
```

Starts only monitoring.

---

# stop.sh

Gracefully stops containers.

Uses:

```bash
docker compose stop
```

Containers remain available.

Networks remain.

Volumes remain.

Recommended for:

- Laptop shutdown
- Maintenance
- Daily use

---

# down.sh

Completely tears down Docker Compose projects.

Uses:

```bash
docker compose down
```

Removes:

- Containers
- Compose networks

Persistent volumes remain because they are bind-mounted outside Docker.

Recommended only for:

- Upgrades
- Configuration changes
- Complete rebuilds

---

# Automatic Service Discovery

Scripts locate Docker Compose projects using:

```bash
find <group> -name docker-compose.yml
```

This means adding a new service requires no script changes.

Simply create:

```text
compose/data-platform/minio/docker-compose.yml
```

and it is automatically managed.

---

# Makefile

Primary operational interface.

Available commands:

```bash
make up
```

Starts every service.

```bash
make stop
```

Stops every service.

```bash
make down
```

Destroys all compose stacks.

Individual groups:

```bash
make infra
make monitoring
make data
make apps
```

Individual services:

```bash
make homepage
make caddy
make portainer
```

Future services will follow the same pattern.

---

# systemd Integration

A systemd unit automatically starts Gneiss after every boot.

Location:

```text
/etc/systemd/system/gneiss.service
```

Service executes:

```text
make up
```

during startup.

When stopped:

```text
make stop
```

is executed.

Enable:

```bash
sudo systemctl enable gneiss.service
```

Check status:

```bash
systemctl status gneiss.service
```

Expected state:

```text
active (exited)
```

This is correct because the service is a `Type=oneshot` unit.

---

# Operational Workflow

Daily startup:

```bash
make up
```

Daily shutdown:

```bash
make stop
```

Complete teardown:

```bash
make down
```

Start infrastructure only:

```bash
make infra
```

Start monitoring only:

```bash
make monitoring
```

---

# Boot Process

On power-up:

```text
BIOS
    ↓
Debian
    ↓
systemd
    ↓
gneiss.service
    ↓
make up
    ↓
up.sh
    ↓
docker compose up -d
```

No manual intervention is required.

---

# Adding New Services

Example:

```text
compose/
└── monitoring/
    └── grafana/
        ├── docker-compose.yml
        ├── .env.example
        └── README.md
```

No changes are required in:

- Makefile
- systemd
- up.sh
- stop.sh
- down.sh

The framework automatically discovers the service.

---

# Design Principles

The operational framework follows these principles:

- Convention over configuration
- Automatic service discovery
- One Docker Compose project per service
- Platform-oriented grouping
- Centralized operational commands
- Automatic startup after reboot
- Persistent data stored outside Docker
- Infrastructure scales without changing operational code