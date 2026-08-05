# 07 - PostgreSQL

## Overview

PostgreSQL is the primary relational database for the Gneiss platform.

It stores metadata for platform services and applications.

This deployment is intentionally lightweight while following production-oriented practices such as persistent storage, health checks, externalized configuration, and Docker networking.

---

# Purpose

PostgreSQL serves as the metadata database for:

- Gneiss
- Airflow
- OpenMetadata
- Superset
- Future applications

Instead of deploying multiple PostgreSQL containers, a single PostgreSQL instance hosts multiple databases.

---

# Directory Structure

```text
compose/
└── data-platform/
    └── postgres/
        ├── docker-compose.yml
        ├── .env
        ├── .env.example
        ├── README.md
        ├── init/
        ├── config/
        └── backups/
```

---

# Persistent Storage

Database files are stored on the SSD for optimal performance.

```text
/var/lib/gneiss/postgres/data
```

Reasons:

- Fast random reads
- Fast writes
- Better WAL performance
- Faster index lookups

Large datasets are intentionally stored elsewhere (MinIO/HDD).

---

# Docker Configuration

Image:

```text
postgres:17
```

Container:

```text
postgres
```

Restart Policy:

```text
unless-stopped
```

Network:

```text
gneiss-infra
```

Healthcheck:

```text
pg_isready
```

---

# Environment Variables

Example:

```dotenv
POSTGRES_USER=postgres
POSTGRES_PASSWORD=change-me
POSTGRES_DB=gneiss
TZ=Asia/Kolkata
```

The actual `.env` file is not committed to Git.

---

# Databases

Current databases:

```text
postgres
gneiss
```

Future databases:

```text
airflow
openmetadata
superset
playground
```

Using separate databases keeps application metadata isolated while sharing the same PostgreSQL instance.

---

# Initialization Scripts

SQL files placed under:

```text
init/
```

are executed only during the initial database creation.

Typical use cases:

- Create databases
- Create roles
- Install extensions
- Seed initial metadata

---

# Backups

Backup directory:

```text
backups/
```

Future backups will use:

```bash
pg_dump
```

Example:

```bash
docker exec postgres pg_dump \
    -U postgres \
    gneiss \
    > backups/gneiss.sql
```

Restore:

```bash
cat backups/gneiss.sql | docker exec -i postgres psql -U postgres gneiss
```

---

# Operations

Start:

```bash
make data
```

Stop:

```bash
make stop
```

Destroy:

```bash
make down
```

Restart:

```bash
docker compose restart
```

Container status:

```bash
docker ps
```

Logs:

```bash
docker logs postgres
```

---

# Connecting from Mac

Host:

```text
<server-ip>
```

Port:

```text
5432
```

Credentials:

```text
Username:
Password:
Database:
```

Recommended clients:

- DBeaver
- DataGrip
- psql

---

# Health Check

Verify:

```bash
docker inspect postgres
```

Expected:

```text
healthy
```

---

# Data Persistence

Verify persistence:

1.

```sql
CREATE DATABASE playground;
```

2.

```bash
docker compose down
docker compose up -d
```

3.

```sql
\l
```

The database should still exist.

---

# Security

Current deployment is intended for the local homelab.

Recommendations:

- Use strong passwords.
- Do not expose PostgreSQL directly to the Internet.
- Keep credentials in `.env`.
- Restrict firewall access if remote connections are not required.

---

# Future Improvements

The following features may be added later:

- Scheduled backups
- WAL archiving
- SSL/TLS
- Replication
- PgBouncer
- Resource tuning
- Monitoring with Prometheus
- Grafana dashboards

---

# Architecture

```text
MacBook
    │
    │ PostgreSQL Client
    ▼
PostgreSQL
    │
    ├── gneiss
    ├── airflow
    ├── openmetadata
    ├── superset
    └── playground
```

Applications communicate through Docker networking while development and administration are performed from the MacBook.

---

# Design Decisions

- One PostgreSQL instance
- Multiple logical databases
- Persistent storage on SSD
- Health checks enabled
- Environment-based configuration
- External Docker network
- Production-style directory layout
- Managed through the Gneiss operational framework

---

# Summary

PostgreSQL forms the metadata backbone of Gneiss.

It provides reliable relational storage for orchestration, metadata, analytics, and future platform services while remaining lightweight enough for a homelab deployment.

Future services will reuse this PostgreSQL instance instead of deploying their own database containers.