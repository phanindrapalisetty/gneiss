# Gneiss

> A self-hosted homelab platform for personal cloud, media streaming, and modern data engineering, with a focus on reproducibility and documentation..


## Overview

Gneiss is a personal homelab built on an old Acer Swift 3 laptop. The objective is to create a reliable, reproducible, and well-documented platform for:

- Personal cloud storage
- Photo management
- Media streaming
- Data engineering experimentation
- Infrastructure learning
- Linux administration
- Docker-based self-hosting

Unlike a traditional NAS, Gneiss is intended to be both a storage platform and a development environment for modern data engineering tools.

## Goals

- Learn Linux system administration
- Learn Docker and container orchestration
- Build a reproducible homelab
- Host personal cloud services
- Host media services
- Build a local data platform
- Document every step of the journey

## Planned Architecture

```text
                   MacBook Air
                        │
                 VS Code + SSH
                        │
                 ───── LAN ─────
                        │
                    Gneiss
             Debian 13 Server
                        │
                 Docker Compose
                        │
    ┌───────────────┬───────────────┐
    │               │               │
 Media Stack    Cloud Stack    Data Platform
    │               │               │
 Jellyfin      Nextcloud        Spark
 Immich        Syncthing        Trino
                               Iceberg
                               MinIO
                               Airflow
                               PostgreSQL
```

## Planned Stack

### Operating System

- Debian 13

### Infrastructure

- Docker
- Docker Compose
- CasaOS

### Media

- Jellyfin
- Immich
- Syncthing

### Personal Cloud

- Nextcloud

### Data Platform

- PostgreSQL
- MinIO
- Apache Spark
- Apache Iceberg
- Project Nessie
- Trino
- Apache Airflow
- dbt

### Monitoring

- Grafana
- Prometheus
- Node Exporter

## Repo Structure
```
gneiss/
│
├── README.md
├── LICENSE
├── .gitignore
├── .env.example
├── Makefile
│
├── docs/
│   ├── 01-introduction.md
│   ├── 02-hardware.md
│   ├── 03-installation.md
│   ├── 04-networking.md
│   ├── 05-storage.md
│   ├── 06-docker.md
│   ├── 07-casaos.md
│   ├── 08-media-stack.md
│   ├── 09-cloud-stack.md
│   ├── 10-data-platform.md
│   ├── 11-monitoring.md
│   ├── 12-backups.md
│   ├── 13-security.md
│   ├── 14-maintenance.md
│   └── 15-roadmap.md
│
├── compose/
│   ├── media/
│   ├── cloud/
│   ├── monitoring/
│   ├── data-platform/
│   └── infrastructure/
│
├── configs/
│
├── scripts/
│
├── storage/
│
└── backups/
```

---
