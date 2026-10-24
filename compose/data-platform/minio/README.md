# 08 - MinIO

## Overview

MinIO provides S3-compatible object storage for the Gneiss data platform.

It serves as the central storage layer for datasets, data lake tables, backups, and future analytics workloads. Rather than storing files directly on the filesystem, applications interact with MinIO through the standard S3 API.

---

# Purpose

MinIO is the object storage backend for:

- Spark
- Iceberg
- Trino
- Airflow
- DuckDB
- Python applications
- Future analytics services

MinIO exposes the Amazon S3 API, allowing applications developed locally to be migrated to AWS S3 with minimal changes.

---

# Directory Structure

```text
compose/
└── data-platform/
    └── minio/
        ├── docker-compose.yml
        ├── .env
        ├── .env.example
        ├── README.md
        ├── config/
        ├── backups/
        └── data/
```

---

# Persistent Storage

MinIO stores object data on the HDD.

```text
/mnt/storage/Gneiss/data/object-storage/minio/data
```

Reasoning:

- Large storage capacity
- Optimized for sequential reads/writes
- Suitable for media, Parquet files, Iceberg tables, and backups
- Keeps SSD available for databases and metadata

---

# Docker Configuration

Image:

```text
minio/minio:<version>
```

Container:

```text
minio
```

Restart Policy:

```text
unless-stopped
```

Network:

```text
gneiss-infra
```

Command:

```text
server /data --console-address ":9001"
```

---

# Environment Variables

Example:

```dotenv
MINIO_ROOT_USER=admin
MINIO_ROOT_PASSWORD=change-me
TZ=Asia/Kolkata
```

The actual `.env` file is not committed to Git.

---

# Ports

| Port | Purpose |
|-------|----------|
| 9000 | S3 API |
| 9001 | MinIO Console |

---

# Caddy Configuration

MinIO is exposed through Caddy using separate hostnames for the API and the management console.

| Hostname | Backend |
|----------|---------|
| `minio-api.gneiss` | `:9000` |
| `minio-console.gneiss` | `:9001` |

Example:

```caddy
http://minio-api.gneiss {
    reverse_proxy host.docker.internal:9000
}

http://minio-console.gneiss {
    reverse_proxy host.docker.internal:9001
}
```

---

# Local DNS

Add entries to the hosts file:

```text
192.168.1.7    minio-api.gneiss
192.168.1.7    minio-console.gneiss
```

This allows both services to be accessed using friendly hostnames.

---

# Buckets

Current bucket:

```text
lakehouse
```

Recommended future buckets:

```text
lakehouse
warehouse
backups
artifacts
```

Within the `lakehouse` bucket, applications may use prefixes such as:

```text
raw/
bronze/
silver/
gold/
```

These are logical object prefixes, not actual filesystem directories.

---

# S3 Endpoint

Applications should connect using:

```text
Endpoint:
http://minio-api.gneiss
```

Credentials:

```text
Access Key:
Secret Key:
```

Region:

```text
us-east-1
```

(Path-style access is recommended when supported.)

---

# MinIO Console

Management UI:

```text
http://minio-console.gneiss
```

The console is used for:

- Bucket management
- Object uploads/downloads
- User management
- Access policies
- Monitoring storage usage

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

Logs:

```bash
docker logs minio
```

Container status:

```bash
docker ps
```

---

# Health Verification

Container status:

```bash
docker ps
```

Expected:

```text
Up (healthy)
```

Console:

```text
http://minio-console.gneiss
```

API:

```text
http://minio-api.gneiss
```

---

# Data Persistence

Objects are stored outside Docker:

```text
/mnt/storage/Gneiss/data/object-storage/minio/data
```

Containers can be recreated without losing object data.

---

# Security

Current deployment is intended for a private homelab.

Recommendations:

- Use strong root credentials.
- Do not expose MinIO directly to the Internet.
- Keep credentials in `.env`.
- Restrict access to trusted local networks.

---

# Future Improvements

Planned enhancements include:

- MinIO Client (`mc`)
- Additional users and access policies
- Bucket lifecycle rules
- Automated backups
- TLS/HTTPS
- Prometheus metrics
- Grafana dashboards
- Versioning
- Object replication

---

# Architecture

```text
Applications
     │
     │ S3 API
     ▼
MinIO API
(minio-api.gneiss)
     │
     ▼
Object Storage
(HDD)

     ▲

MinIO Console
(minio-console.gneiss)
```

Applications interact with the S3 API, while administrators use the MinIO Console for management.

---

# Design Decisions

- Single MinIO instance
- S3-compatible API
- Persistent storage on HDD
- Separate API and Console endpoints
- Reverse proxied through Caddy
- Managed through the Gneiss operational framework

---

# Summary

MinIO serves as the object storage foundation of Gneiss. It provides an S3-compatible storage layer for analytics, lakehouse architectures, and application data while remaining lightweight and fully self-hosted.

Future services such as Spark, Iceberg, Trino, and Airflow will use MinIO as their shared storage backend.