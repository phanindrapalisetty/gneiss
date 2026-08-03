# 12. Portainer

## Objective

Deploy Portainer Community Edition (CE) as the Docker management interface for Gneiss.

Portainer provides a web-based interface for managing:

- Docker containers
- Images
- Volumes
- Networks
- Docker Compose stacks
- Logs
- Resource utilization

Homepage remains the landing page, while Portainer is the operational interface for Docker.

---

## Why Portainer?

Although Docker can be managed entirely from the command line, a visual interface simplifies:

- Monitoring running containers
- Viewing logs
- Restarting services
- Inspecting networks
- Managing volumes
- Debugging deployments

Portainer complements, rather than replaces, the GitOps workflow.

---

## Architecture

```
                 Browser
                     │
                     ▼
               Homepage Dashboard
                     │
         ┌───────────┴───────────┐
         ▼                       ▼
      CasaOS                Portainer
                                   │
                                   ▼
                            Docker Engine
                                   │
         ┌─────────────────────────┼─────────────────────────┐
         ▼                         ▼                         ▼
     Homepage                  Jellyfin                  MinIO
```

---

## Directory Structure

### Git Repository

```
compose/
└── infrastructure/
    └── portainer/
        ├── docker-compose.yml
        ├── .env.example
        ├── .gitignore
        └── README.md
```

### Persistent Storage

```
/mnt/storage/Gneiss/data/
└── portainer/
```

Portainer stores all persistent state inside this directory, including:

- Users
- Password hashes
- Docker endpoints
- Settings
- Stacks
- Templates

This ensures upgrades and container recreation do not lose configuration. :contentReference[oaicite:0]{index=0}

---

## Docker Compose

Image:

```
portainer/portainer-ce:2.33.1
```

Port:

```
9443
```

Volumes:

```
/var/run/docker.sock
/mnt/storage/Gneiss/data/portainer
```

Docker socket access allows Portainer to manage the local Docker Engine. :contentReference[oaicite:1]{index=1}

---

## Configuration

### `.env.example`

```env
TZ=Asia/Kolkata
```

The local `.env` file is created from this template and is intentionally excluded from Git.

---

## Initial Setup

Open:

```
https://192.168.1.9:9443
```

During first launch:

1. Create the administrator account.
2. Select the **Local** Docker environment.
3. Finish the setup wizard.

Portainer then discovers the local Docker Engine automatically. :contentReference[oaicite:2]{index=2}

---

## Data Persistence

Portainer stores all internal data inside:

```
/mnt/storage/Gneiss/data/portainer
```

Because this directory is bind-mounted from the host:

- `docker compose down` does **not** remove data.
- Recreating the container preserves users and configuration.
- Only deleting the host directory results in data loss.

---

## Credential Management

Gneiss follows the following convention:

### Human credentials

Examples:

- Portainer administrator
- CasaOS administrator
- Grafana administrator

Stored in:

```
Password Manager
```

### Machine credentials

Examples:

- PostgreSQL password
- MinIO root password
- API keys
- JWT secrets

Stored in:

```
/mnt/storage/Gneiss/configs/secrets/
```

This separates user-managed credentials from application-managed secrets.

---

## Homepage Integration

Homepage links to Portainer and associates it with the Docker container.

Example:

```yaml
- Portainer:
    icon: portainer.png
    href: https://192.168.1.9:9443
    description: Docker Management

    server: my-docker
    container: portainer

    siteMonitor: https://192.168.1.9:9443
```

`siteMonitor` provides response time monitoring.

The Docker health badge remains **UNKNOWN** unless the container defines a Docker `HEALTHCHECK`. Docker Compose supports adding custom health checks if desired. :contentReference[oaicite:3]{index=3}

---

## Design Decisions

### Git is the source of truth

Compose files remain in Git.

Portainer is **not** used for editing stacks.

All infrastructure changes are performed by modifying Compose files and redeploying.

This preserves the GitOps workflow.

---

### Separate configuration from runtime data

Git stores:

- Compose files
- Documentation
- Configuration templates

Persistent storage contains:

- Databases
- Application state
- Uploaded files

This separation simplifies backup and disaster recovery.

---

## Access

```
https://192.168.1.9:9443
```

Future state:

```
https://portainer.gneiss
```

---

## Troubleshooting

### Browser reports:

```
Client sent an HTTP request to an HTTPS server
```

Cause:

Portainer listens on HTTPS.

Use:

```
https://192.168.1.9:9443
```

instead of:

```
http://192.168.1.9:9443
```

---

### Browser certificate warning

Expected.

Portainer generates a self-signed certificate during initial startup.

The warning will disappear once reverse proxying with trusted certificates is introduced later.

---

### Homepage shows UNKNOWN

Homepage successfully monitors response time using `siteMonitor`, but the Docker health badge reports `UNKNOWN` when the container image does not define a Docker `HEALTHCHECK`.

This does **not** indicate the container is unhealthy.

---

## Verification

Verify the container:

```bash
docker ps
```

Verify persistence:

```bash
docker compose down
docker compose up -d
```

Confirm:

- Administrator account still exists.
- Previous configuration is preserved.

Verify web access:

```
https://192.168.1.9:9443
```

---

## Lessons Learned

- Separate human credentials from machine secrets.
- Persist application data outside containers.
- Keep infrastructure definitions under version control.
- Use Portainer as an operational interface rather than the deployment source of truth.
- Docker health status and service availability are separate concepts.

---

## Future Enhancements

- Add Docker `HEALTHCHECK` definitions where appropriate.
- Reverse proxy through Caddy.
- Local DNS (`portainer.gneiss`).
- Enable automatic image update notifications.
- Integrate with the Gneiss Makefile for deployment automation.
- Document backup and restore procedures for Portainer data.