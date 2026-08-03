# 11. Homepage

## Objective

Deploy Homepage as the central dashboard for the Gneiss homelab. Homepage serves as the single entry point to all self-hosted services, infrastructure components, and monitoring tools.

It provides:

- Centralized service dashboard
- Resource monitoring
- Docker integration
- Service grouping
- Quick access to infrastructure

---

## Why Homepage?

As the homelab grows, remembering ports and URLs becomes difficult.

Instead of remembering:

- http://192.168.1.9:3000
- http://192.168.1.9:8080
- http://192.168.1.9:9000
- http://192.168.1.9:8096

Homepage provides one landing page from which every service can be accessed.

Later in the project, Homepage will also display:

- Docker container status
- Service-specific widgets
- Infrastructure health
- Resource utilization

---

## Architecture

```
Browser
     │
     ▼
Homepage
     │
     ├── CasaOS
     ├── Portainer
     ├── Airflow
     ├── Spark
     ├── Trino
     ├── MinIO
     ├── PostgreSQL
     ├── Jellyfin
     ├── Immich
     ├── Grafana
     └── Prometheus
```

Homepage itself is deployed as a Docker container.

---

## Directory Structure

### Git Repository

```
compose/
└── infrastructure/
    └── homepage/
        ├── docker-compose.yml
        ├── .env
        ├── README.md
        └── config/
            ├── settings.yaml
            ├── services.yaml
            ├── widgets.yaml
            ├── bookmarks.yaml
            └── docker.yaml
```

### Persistent Storage

Homepage configuration is intentionally stored in Git.

Unlike databases or media servers, Homepage configuration is code and should be version controlled.

---

## Docker Compose

Homepage is deployed using Docker Compose.

Image:

```
ghcr.io/gethomepage/homepage
```

Ports:

```
3000
```

Volumes:

```
./config
```

Docker socket:

```
/var/run/docker.sock
```

---

## Configuration

Homepage configuration consists of five YAML files.

### settings.yaml

Controls:

- Theme
- Layout
- Dashboard title
- Header style

### services.yaml

Contains all deployed services grouped into:

- Infrastructure
- Data Platform
- Media
- Monitoring

### widgets.yaml

Displays:

- CPU
- Memory
- Disk usage
- Date & Time
- Search

Additional widgets will be added as services are deployed.

### bookmarks.yaml

Contains reference links such as:

- Homepage Documentation
- Docker Hub
- GitHub

### docker.yaml

Defines Docker providers.

Example:

```yaml
my-docker:
  socket: /var/run/docker.sock
```

---

## Docker Integration

Homepage connects directly to the Docker Engine through:

```
/var/run/docker.sock
```

This allows Homepage to associate dashboard cards with running Docker containers.

Example:

```yaml
server: my-docker
container: homepage
```

This enables container discovery and service awareness.

Homepage does **not** provide a complete Docker management interface.

Docker administration will instead be handled by Portainer.

---

## Access

```
http://192.168.1.9:3000
```

Future state:

```
http://home.gneiss
```

---

## Design Decisions

Configuration is stored inside the Git repository.

Reasons:

- Version controlled
- Easy backup
- Easy migration
- Pull requests capture configuration changes
- No dependence on HDD for configuration

Persistent application data is stored separately under:

```
/mnt/storage/Gneiss/data
```

This separation follows the GitOps philosophy adopted throughout Gneiss.

---

## Troubleshooting

### Host validation failed

Cause:

Homepage validates incoming host headers.

Resolution:

Set the following environment variable:

```
HOMEPAGE_ALLOWED_HOSTS=*
```

or specify the allowed hostname.

---

### Configuration changes are not reflected

Cause:

Incorrect volume mount.

Correct:

```
./config:/app/config
```

Incorrect:

```
/mnt/storage/Gneiss/configs/homepage:/app/config
```

---

### Missing Docker integration

Verify:

```
docker.yaml
```

contains:

```yaml
my-docker:
  socket: /var/run/docker.sock
```

Verify Docker socket is mounted:

```
/var/run/docker.sock:/var/run/docker.sock:ro
```

---

### Service card shows UNKNOWN

This indicates Homepage can discover the Docker container but does not have an application-specific widget configured.

Container discovery is functioning correctly.

---

## Verification

Verify Homepage container:

```bash
docker ps
```

Verify Homepage is reachable:

```
http://192.168.1.9:3000
```

Verify configuration reloads after editing YAML files.

Verify Docker provider detects containers.

---

## Lessons Learned

- Configuration should remain inside Git.
- Runtime data belongs on persistent storage.
- Homepage is intended as a landing page, not a Docker management interface.
- Portainer complements Homepage by providing container administration.
- Keeping configuration under version control simplifies maintenance and migration.

---

## Future Enhancements

- Portainer integration
- Jellyfin widget
- Immich widget
- MinIO widget
- Grafana widget
- Airflow widget
- Uptime Kuma widget
- Local DNS through Caddy
- Custom Gneiss branding
- Background image
- CPU temperature
- SMART disk health
- Network throughput
- Battery status